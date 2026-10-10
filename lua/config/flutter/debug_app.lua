-- Đánh dấu app Android là "đang debug" trước khi khởi động: Android bỏ qua ANR nên app dừng ở breakpoint không bị hộp thoại "isn't responding" hay bị giết
local M = {}

local ADB_TIMEOUT_MS = 3000
local APP_ID_PATTERN = "applicationId%s*=?%s*[\"']([^\"']+)[\"']"
local GRADLE_FILES = { "android/app/build.gradle.kts", "android/app/build.gradle" }

-- applicationId đọc từ file gradle của app Android
local function application_id(root)
	for _, name in ipairs(GRADLE_FILES) do
		local ok, lines = pcall(vim.fn.readfile, root .. "/" .. name)
		for _, line in ipairs(ok and lines or {}) do
			local id = line:match(APP_ID_PATTERN)
			if id then
				return id
			end
		end
	end
end

-- Id thiết bị nằm sau cờ -d trong args của cấu hình launch (chỉ có khi bạn chọn thiết bị tường minh)
local function device_id(args)
	for i, arg in ipairs(args or {}) do
		if arg == "-d" then
			return args[i + 1]
		end
	end
end

-- Serial các thiết bị adb đang kết nối (dùng khi lệnh chạy không chỉ định -d)
local function connected_devices()
	local ok, result = pcall(function()
		return vim.system({ "adb", "devices" }, { text = true }):wait(ADB_TIMEOUT_MS)
	end)
	local serials = {}
	for line in ((ok and result.stdout) or ""):gmatch("[^\n]+") do
		local serial = line:match("^(%S+)%s+device$")
		if serial then
			serials[#serials + 1] = serial
		end
	end
	return serials
end

-- Chạy trước khi phiên bắt đầu (cờ chỉ áp dụng cho tiến trình khởi động sau đó); lỗi hay thiết bị không phải Android thì bỏ qua
local function mark(config)
	local id = application_id(config.cwd or vim.fn.getcwd())
	if id then
		local device = device_id(config.args)
		for _, serial in ipairs(device and { device } or connected_devices()) do
			pcall(function()
				vim.system({ "adb", "-s", serial, "shell", "am", "set-debug-app", "--persistent", id }):wait(ADB_TIMEOUT_MS)
			end)
		end
	end
	return config
end

function M.setup()
	require("dap").listeners.on_config["config.flutter.debug_app"] = mark
end

return M
