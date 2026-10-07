-- Giữ chế độ chọn widget (inspector) qua hot restart: Flutter tắt nó khi tạo isolate mới
local M = {}

local EXT = "ext.flutter.inspector.show"

-- Người dùng đang muốn chế độ chọn widget bật
local wanted = false

-- Isolate bị tắt inspector do chuyển isolate (không phải ý định tắt của người dùng)
local released = {}

-- Ghi nhận ý định bật/tắt từ chính các lệnh callService của plugin (nvim-dap truyền thẳng bảng arguments)
local function track_intent(_, err, _, args)
  if err or not args or args.method ~= EXT or not args.params then return end
  local isolate_id = args.params.isolateId
  if args.params.enabled == "false" and released[isolate_id] then
    released[isolate_id] = nil
    return
  end
  if args.params.enabled ~= nil then wanted = args.params.enabled == "true" end
end

-- Isolate mới đăng ký lại extension: bật lại chế độ chọn widget nếu người dùng đang muốn
local function restore(session, body)
  if not wanted or not body or body.extensionRPC ~= EXT then return end
  session:request("callService", { method = EXT, params = { enabled = "true", isolateId = body.isolateId } }, function() end)
end

-- Bật/tắt chế độ chọn widget trên isolate giao diện, đảo theo trạng thái thật của app
function M.toggle()
  local session = require("dap").session()
  if not session then return vim.notify("Flutter inspector: chưa có app đang chạy qua DAP", vim.log.levels.WARN) end
  local isolate = require("config.flutter.isolate")
  isolate.call(session, EXT, {}, function(err, response, isolate_id)
    if err then return vim.notify("Flutter inspector: " .. vim.inspect(err), vim.log.levels.WARN) end
    local enabled = (response.result or response).enabled == "true"
    session:request("callService", { method = EXT, params = { enabled = tostring(not enabled), isolateId = isolate_id } }, function() end)
  end)
end

-- Chuyển chế độ chọn widget từ isolate cũ sang isolate mới khi người dùng đổi isolate đang xem và đang bật inspector
function M.move(session, from, to)
  if not wanted or not to or from == to then return end
  if from then released[from] = true end
  if from then session:request("callService", { method = EXT, params = { enabled = "false", isolateId = from } }, function() end) end
  session:request("callService", { method = EXT, params = { enabled = "true", isolateId = to } }, function() end)
end

function M.setup()
  require("config.flutter.isolate").setup()
  local KEY = "config.flutter.inspect"
  local dap = require("dap")
  dap.listeners.after.callService[KEY] = track_intent
  dap.listeners.after["event_dart.serviceExtensionAdded"][KEY] = restore
  for _, event in ipairs({ "event_terminated", "event_exited" }) do
    dap.listeners.after[event][KEY] = function() wanted = false end
  end
end

return M
