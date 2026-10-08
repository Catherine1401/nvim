-- live_grep của telescope với kết quả sắp theo file dùng gần nhất
local M = {}

local MAX_RANKED = 20
local BASE_SCORE = 1
local RANK_WEIGHT = 1e-4
local UNRANKED_SCORE = 2

-- Thứ hạng theo đường dẫn tương đối: buffer đang mở theo lastused trước, rồi tới oldfiles
local function build_ranks()
	local ranks = {}
	local count = 0
	local function add(path)
		local rel = vim.fn.fnamemodify(path, ":.")
		if count < MAX_RANKED and path ~= "" and not ranks[rel] then
			count = count + 1
			ranks[rel] = count
		end
	end
	local bufs = vim.fn.getbufinfo({ buflisted = 1 })
	table.sort(bufs, function(a, b)
		return a.lastused > b.lastused
	end)
	for _, buf in ipairs(bufs) do
		add(buf.name)
	end
	for _, path in ipairs(vim.v.oldfiles) do
		add(path)
	end
	return ranks
end

function M.live_grep()
	local sorters = require("telescope.sorters")
	local ranks = build_ranks()
	local original = sorters.highlighter_only
	-- Thay sorter gắn cứng của live_grep; điểm >= 1 để telescope giữ thứ tự dòng rg trả về
	sorters.highlighter_only = function(opts)
		local sorter = original(opts)
		sorter.scoring_function = function(_, _, _, entry)
			local rank = ranks[entry.filename]
			return rank and (BASE_SCORE + rank * RANK_WEIGHT) or UNRANKED_SCORE
		end
		return sorter
	end
	local ok, err = pcall(require("telescope.builtin").live_grep)
	sorters.highlighter_only = original
	if not ok then
		error(err)
	end
end

return M
