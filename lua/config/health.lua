-- Chẩn đoán phụ thuộc của config: dùng cho :checkhealth config và install.sh
local M = {}

local MIN_TREE_SITTER = "0.26.1"
local LEVELS = { "required", "recommended", "optional" }

-- Mỗi mục: lệnh (một hoặc nhiều tên thay thế), mức độ, lý do cần
local TOOLS = {
	{ names = { "git" }, level = "required", why = "lazy.nvim clones plugins" },
	{ names = { "curl" }, level = "required", why = "nvim-treesitter downloads parsers" },
	{ names = { "tar" }, level = "required", why = "nvim-treesitter unpacks parsers" },
	{ names = { "make" }, level = "required", why = "builds telescope-fzf-native and LuaSnip jsregexp" },
	{ names = { "cc", "gcc", "clang" }, level = "required", why = "compiles treesitter parsers" },
	{ names = { "rg" }, level = "recommended", why = "live grep and file search" },
	{ names = { "fd", "fdfind" }, level = "recommended", why = "file search" },
	{ names = { "node" }, level = "recommended", why = "Mason installs LSPs and formatters (pyright, prettier, ...)" },
	{ names = { "npm" }, level = "recommended", why = "Mason installs LSPs and formatters" },
	{ names = { "python3" }, level = "recommended", why = "Mason installs black and isort" },
	{ names = { "cargo" }, level = "recommended", why = "builds the blink.cmp fuzzy library (a slower Lua fallback is used without it)" },
	{ names = { "go" }, level = "optional", why = "Go development" },
	{ names = { "gopls" }, level = "optional", why = "Go language server" },
	{ names = { "goimports" }, level = "optional", why = "Go format on save" },
	{ names = { "dlv" }, level = "optional", why = "Go debugging" },
	{ names = { "flutter" }, level = "optional", why = "Flutter development" },
	{ names = { "dart" }, level = "optional", why = "Flutter development" },
	{ names = { "adb" }, level = "optional", why = "Flutter on Android (avoids the ANR dialog while debugging)" },
	{ names = { "lazygit" }, level = "optional", why = "lazygit terminal" },
	{ names = { "ibus", "fcitx5-remote" }, level = "optional", why = "Vietnamese input switching (im-select.nvim)" },
	{ names = { "claude" }, level = "optional", why = "claudecode.nvim" },
	{ names = { "codex" }, level = "optional", why = "neovim-codex" },
}

local function find_tool(names)
	for _, name in ipairs(names) do
		if vim.fn.executable(name) == 1 then
			return name
		end
	end
end

local function version_ge(version, minimum)
	local function parts(text)
		local major, minor, patch = text:match("(%d+)%.(%d+)%.?(%d*)")
		return { tonumber(major) or 0, tonumber(minor) or 0, tonumber(patch) or 0 }
	end
	local a, b = parts(version), parts(minimum)
	for i = 1, 3 do
		if a[i] ~= b[i] then
			return a[i] > b[i]
		end
	end
	return true
end

-- Kết quả kiểm tra công cụ ngoài, mỗi mục { level, ok, message }
local function tool_results()
	local results = {}
	for _, tool in ipairs(TOOLS) do
		local found = find_tool(tool.names)
		local label = table.concat(tool.names, " / ")
		results[#results + 1] = { level = tool.level, ok = found ~= nil, message = found and (found .. " found") or (label .. " not found: " .. tool.why) }
	end
	return results
end

-- Kết quả kiểm tra Neovim, tree-sitter CLI và parser đã cài
local function core_results()
	local results = {}
	local has_nvim = vim.fn.has("nvim-0.12") == 1
	results[#results + 1] = { level = "required", ok = has_nvim, message = has_nvim and "Neovim >= 0.12" or "Neovim >= 0.12 is required (nvim-treesitter main branch)" }
	-- Chỉ lấy dòng phiên bản, bỏ cảnh báo của trình liên kết (ví dụ weak version GLIBC) lẫn trong đầu ra
	local output = vim.fn.executable("tree-sitter") == 1 and vim.fn.system({ "tree-sitter", "--version" }) or ""
	local banner = output:match("tree%-sitter %d+%.%d+%.%d+")
	local ok = banner ~= nil and version_ge(banner, MIN_TREE_SITTER)
	results[#results + 1] = { level = "required", ok = ok, message = ok and banner or ("tree-sitter CLI >= " .. MIN_TREE_SITTER .. " is required to build parsers") }
	local parsers = vim.fn.glob(vim.fn.stdpath("data") .. "/site/parser/*.so", false, true)
	results[#results + 1] = { level = "required", ok = #parsers > 0, message = #parsers > 0 and (#parsers .. " treesitter parsers installed") or "no treesitter parsers installed (run :TSUpdate once tree-sitter is available)" }
	return results
end

local function all_results()
	return vim.list_extend(core_results(), tool_results())
end

-- Số mục bắt buộc còn thiếu
function M.missing_required()
	local missing = 0
	for _, result in ipairs(all_results()) do
		missing = missing + ((result.level == "required" and not result.ok) and 1 or 0)
	end
	return missing
end

-- Giao diện :checkhealth config
function M.check()
	local results = all_results()
	for _, level in ipairs(LEVELS) do
		vim.health.start("config: " .. level)
		for _, result in ipairs(results) do
			if result.level == level then
				if result.ok then
					vim.health.ok(result.message)
				elseif level == "required" then
					vim.health.error(result.message)
				else
					vim.health.warn(result.message)
				end
			end
		end
	end
end

-- Báo cáo văn bản cho install.sh; thoát với mã khác 0 nếu thiếu mục bắt buộc
function M.run()
	local results = all_results()
	for _, level in ipairs(LEVELS) do
		io.stdout:write(level .. ":\n")
		for _, result in ipairs(results) do
			if result.level == level then
				io.stdout:write(string.format("  [%s] %s\n", result.ok and "ok" or (level == "required" and "FAIL" or "missing"), result.message))
			end
		end
	end
	local missing = M.missing_required()
	vim.cmd(missing > 0 and ("cquit " .. missing) or "qa")
end

return M
