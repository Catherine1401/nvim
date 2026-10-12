-- Kiểm tra quy ước repo: nvim --headless -l scripts/check.lua (thoát 1 nếu có vi phạm mới)
local ROOT = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local MAX_FILE_LINES = 1000
local MAX_FUNC_LINES = 100
local MAX_LEADER_KEYS = 2
local LEADER = "<leader>"
local WHICH_KEY_FILE = "plugins/which_key.lua"

-- Vi phạm có sẵn được chấp nhận tạm: chỉ cảnh báo, không làm fail (khóa "<loại> <đường dẫn>")
local KNOWN = {}

local failures, warnings = {}, {}

local function report(kind, rel, msg)
	local list = KNOWN[kind .. " " .. rel] and warnings or failures
	table.insert(list, string.format("[%s] %s: %s", kind, rel, msg))
end

local function read(path)
	return table.concat(vim.fn.readfile(path), "\n")
end

local function rel(path)
	return path:sub(#ROOT + 2)
end

local function lua_files()
	return vim.fn.globpath(ROOT, "{lua,scripts}/**/*.lua", false, true)
end

-- Tìm hàm dài nhất trong cây treesitter
local function longest_func(node)
	local best = 0
	if node:type() == "function_declaration" or node:type() == "function_definition" then
		local srow, _, erow = node:range()
		best = erow - srow + 1
	end
	for child in node:iter_children() do
		best = math.max(best, longest_func(child))
	end
	return best
end

local function check_sizes()
	for _, path in ipairs(lua_files()) do
		local src = read(path)
		local lines = select(2, src:gsub("\n", "\n")) + 1
		if lines > MAX_FILE_LINES then
			report("file", rel(path), lines .. " lines")
		end
		local root = vim.treesitter.get_string_parser(src, "lua"):parse()[1]:root()
		local func = longest_func(root)
		if func > MAX_FUNC_LINES then
			report("func", rel(path), "a function has " .. func .. " lines")
		end
	end
end

-- Gom mọi chuỗi "<leader>..." trong code thành bảng lhs -> file
local function collect_leader_keys()
	local found = {}
	for _, path in ipairs(vim.fn.globpath(ROOT, "lua/**/*.lua", false, true)) do
		-- which_key.lua chỉ khai báo nhóm; dạng "<leader>x", nil cũng là khai báo nhóm
		if not path:find(WHICH_KEY_FILE, 1, true) then
			local src = read(path):gsub('"' .. LEADER .. '[^"%s]+",%s*nil', "")
			for lhs in src:gmatch('"(' .. LEADER .. '[^"%s]+)"') do
				found[lhs] = found[lhs] or rel(path)
			end
		end
	end
	return found
end

-- Tách phần sau <leader> thành danh sách phím (<Key> tính là một phím)
local function split_keys(lhs)
	local keys, rest = {}, lhs:sub(#LEADER + 1)
	while #rest > 0 do
		local special = rest:match("^<[^>]+>")
		local key = special or rest:sub(1, 1)
		table.insert(keys, key)
		rest = rest:sub(#key + 1)
	end
	return keys
end

local function check_leader_keys(found)
	for lhs, file in pairs(found) do
		if #split_keys(lhs) > MAX_LEADER_KEYS then
			report("leader", file, lhs .. " has more than " .. MAX_LEADER_KEYS .. " keys")
		end
		for other in pairs(found) do
			if other ~= lhs and vim.startswith(other, lhs) then
				report("prefix", file, lhs .. " is a prefix of " .. other)
			end
		end
	end
end

-- Mỗi phím leader phải có trong docs/keymaps.md (dạng đầy đủ hoặc rút gọn trong nhóm)
local function check_docs(found)
	local docs = read(ROOT .. "/docs/keymaps.md")
	for lhs, file in pairs(found) do
		local short = lhs:sub(#LEADER + 1)
		local patterns = { "`" .. lhs .. "`", "`" .. short .. "`", lhs .. "`", "/ " .. short .. "`" }
		local documented = false
		for _, p in ipairs(patterns) do
			documented = documented or docs:find(p, 1, true) ~= nil
		end
		if not documented then
			report("docs", file, lhs .. " missing in docs/keymaps.md")
		end
	end
end

-- Nhóm leader có từ 2 phím trở lên phải được khai báo group
local function check_groups(found)
	local count, all = {}, ""
	for _, path in ipairs(vim.fn.globpath(ROOT, "lua/**/*.lua", false, true)) do
		all = all .. read(path)
	end
	for lhs, file in pairs(found) do
		local first = split_keys(lhs)[1]
		count[first] = count[first] or { n = 0, file = file }
		count[first].n = count[first].n + 1
	end
	for first, info in pairs(count) do
		local declared = all:find('"' .. LEADER .. first .. '"[^}]-group')
		if info.n >= 2 and #first == 1 and not declared then
			report("group", info.file, LEADER .. first .. " has " .. info.n .. " keys but no group")
		end
	end
end

local function print_all(title, list)
	if #list > 0 then
		print(title)
		table.sort(list)
		print("  " .. table.concat(list, "\n  ") .. "\n")
	end
end

check_sizes()
local keys = collect_leader_keys()
check_leader_keys(keys)
check_docs(keys)
check_groups(keys)
print_all("Known (not failing):", warnings)
print_all("FAIL:", failures)
if #failures > 0 then
	os.exit(1)
end
print("check: ok")
