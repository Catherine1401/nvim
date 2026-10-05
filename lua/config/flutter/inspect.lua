-- Giữ chế độ chọn widget (inspector) qua hot restart: Flutter tắt nó khi tạo isolate mới
local M = {}

local EXT = "ext.flutter.inspector.show"

-- Người dùng đang muốn chế độ chọn widget bật
local wanted = false

-- Ghi nhận ý định bật/tắt từ chính các lệnh callService của plugin (nvim-dap truyền thẳng bảng arguments)
local function track_intent(_, err, _, args)
  if err or not args or args.method ~= EXT or not args.params then return end
  if args.params.enabled ~= nil then wanted = args.params.enabled == "true" end
end

-- Isolate mới đăng ký lại extension: bật lại chế độ chọn widget nếu người dùng đang muốn
local function restore(session, body)
  if not wanted or not body or body.extensionRPC ~= EXT then return end
  session:request("callService", { method = EXT, params = { enabled = "true", isolateId = body.isolateId } }, function() end)
end

function M.setup()
  local KEY = "config.flutter.inspect"
  local dap = require("dap")
  dap.listeners.after.callService[KEY] = track_intent
  dap.listeners.after["event_dart.serviceExtensionAdded"][KEY] = restore
  for _, event in ipairs({ "event_terminated", "event_exited" }) do
    dap.listeners.after[event][KEY] = function() wanted = false end
  end
end

return M
