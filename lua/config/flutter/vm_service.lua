-- Client VM service (WebSocket) thay cho bản của flutter-tools: tự kết nối lại và đăng ký lại stream khi bị ngắt
local ws = require("config.flutter.ws")

local M = {}

-- Trạng thái duy nhất của kết nối; gen tăng mỗi lần đổi socket để bỏ qua callback của socket cũ
local S = {
  tcp = nil,
  phase = "closed", -- closed | connecting | open
  buf = "",
  frag = nil,
  uri = nil,
  wanted = false,
  attempts = 0,
  opened_once = false,
  next_id = 0,
  pending = {},
  handlers = {},
  on_connect = nil,
  on_error = nil,
  gen = 0,
}

local open_socket

local function notify(msg, level)
  vim.schedule(function() vim.notify("Flutter VM service: " .. msg, level or vim.log.levels.INFO) end)
end

-- Tách host, port, path từ URI; path luôn kết thúc bằng /ws
local function parse_uri(uri)
  local protocol, rest = uri:match("^(wss?)://(.+)$")
  if not protocol then protocol, rest = uri:match("^(https?)://(.+)$") end
  if not rest then return nil end
  local host_port, path = rest:match("^([^/]+)(/.*)$")
  if not host_port then host_port, path = rest, "/" end
  local host, port = host_port:match("^([^:]+):(%d+)$")
  if not host then
    host = host_port
    port = 80
    if protocol == "wss" or protocol == "https" then port = 443 end
  end
  if not path:match("/ws$") then path = path:gsub("/$", "") .. "/ws" end
  return host, tonumber(port), path
end

-- Trả lỗi cho mọi request đang chờ
local function fail_pending(reason)
  local pending = S.pending
  S.pending = {}
  for _, callback in pairs(pending) do
    vim.schedule(function() callback(reason, nil) end)
  end
end

local function close_socket()
  S.gen = S.gen + 1
  local tcp = S.tcp
  S.tcp, S.phase, S.buf, S.frag = nil, "closed", "", nil
  if tcp and not tcp:is_closing() then
    tcp:read_stop()
    tcp:close()
  end
  fail_pending("Service connection closed")
end

local function schedule_reconnect(reason)
  local MAX_ATTEMPTS = 20
  local BACKOFF_MS = { 300, 600, 1200, 2500, 5000 }
  if not S.wanted then return end
  S.attempts = S.attempts + 1
  if S.attempts > MAX_ATTEMPTS then
    S.wanted = false
    notify("không kết nối lại được (" .. reason .. "), dừng thử", vim.log.levels.WARN)
    if S.on_error then vim.schedule(function() S.on_error(reason) end) end
    return
  end
  if S.attempts == 1 then notify("mất kết nối (" .. reason .. "), đang kết nối lại", vim.log.levels.WARN) end
  local gen = S.gen
  local delay = BACKOFF_MS[math.min(S.attempts, #BACKOFF_MS)]
  vim.defer_fn(function()
    if S.wanted and S.phase == "closed" and S.gen == gen then open_socket() end
  end, delay)
end

-- Socket bị đóng ngoài ý muốn: dọn dẹp rồi thử nối lại
local function on_closed(gen, reason)
  if gen ~= S.gen then return end
  close_socket()
  schedule_reconnect(reason)
end

local function send(data)
  if S.tcp and S.phase == "open" then S.tcp:write(data) end
end

local function request(method, params, callback)
  local REQUEST_TIMEOUT_MS = 15000
  if S.phase ~= "open" or not S.tcp then
    if callback then callback("Not connected", nil) end
    return
  end
  S.next_id = S.next_id + 1
  local id = tostring(S.next_id)
  if callback then
    S.pending[id] = callback
    vim.defer_fn(function()
      local cb = S.pending[id]
      if cb then
        S.pending[id] = nil
        cb("Request timeout", nil)
      end
    end, REQUEST_TIMEOUT_MS)
  end
  local message = vim.json.encode({ jsonrpc = "2.0", id = id, method = method, params = params or {} })
  S.tcp:write(ws.encode(ws.OPCODE.text, message))
end

local function handle_message(text)
  local ok, data = pcall(vim.json.decode, text)
  if not ok or type(data) ~= "table" then return end
  if data.id and S.pending[data.id] then
    local callback = S.pending[data.id]
    S.pending[data.id] = nil
    vim.schedule(function() callback(data.error, data.result) end)
  elseif data.method == "streamNotify" and data.params then
    local handler = S.handlers[data.params.streamId]
    if handler then vim.schedule(function() handler(data.params.event) end) end
  end
end

local function close_code(payload)
  if #payload < 2 then return "?" end
  return tostring(payload:byte(1) * 256 + payload:byte(2))
end

local function on_frame(frame, gen)
  local op = ws.OPCODE
  if frame.opcode == op.ping then return send(ws.encode(op.pong, frame.payload)) end
  if frame.opcode == op.close then
    send(ws.encode(op.close, frame.payload:sub(1, 2)))
    return on_closed(gen, "server đóng kết nối, mã " .. close_code(frame.payload))
  end
  if frame.opcode == op.text or frame.opcode == op.binary or frame.opcode == op.cont then
    if frame.opcode ~= op.cont then S.frag = "" end
    S.frag = (S.frag or "") .. frame.payload
    if frame.fin then
      local text = S.frag
      S.frag = nil
      handle_message(text)
    end
  end
end

-- Giải mã mọi frame đang có trong buffer
local function feed(gen)
  while gen == S.gen do
    local frame, rest, err = ws.decode(S.buf)
    if err then return on_closed(gen, err) end
    if not frame then return end
    S.buf = rest
    on_frame(frame, gen)
  end
end

-- Handshake xong: đăng ký lại stream đã lưu, lần đầu thì báo cho người gọi
local function on_open()
  S.phase = "open"
  S.attempts = 0
  for stream in pairs(S.handlers) do
    request("streamListen", { streamId = stream })
  end
  if S.opened_once then return notify("đã kết nối lại") end
  S.opened_once = true
  if S.on_connect then vim.schedule(S.on_connect) end
end

local function on_data(gen, chunk)
  S.buf = S.buf .. chunk
  if S.phase == "connecting" then
    local status, rest = ws.parse_handshake(S.buf)
    if not status then return end
    if not status:find("^HTTP/1%.1 101") then return on_closed(gen, "handshake thất bại: " .. status) end
    S.buf = rest
    on_open()
  end
  feed(gen)
end

function open_socket()
  local host, port, path = parse_uri(S.uri)
  if not host then
    S.wanted = false
    if S.on_error then S.on_error("Invalid URI: " .. S.uri) end
    return
  end
  S.gen = S.gen + 1
  local gen = S.gen
  local tcp = vim.uv.new_tcp()
  S.tcp, S.phase, S.buf, S.frag = tcp, "connecting", "", nil
  tcp:connect(host, port, function(err)
    if gen ~= S.gen then return end
    if err then return vim.schedule(function() on_closed(gen, "connect lỗi: " .. tostring(err)) end) end
    tcp:write(ws.handshake(host, port, path))
    tcp:read_start(function(read_err, chunk)
      if gen ~= S.gen then return end
      vim.schedule(function()
        if read_err then return on_closed(gen, "lỗi đọc: " .. tostring(read_err)) end
        if not chunk then return on_closed(gen, "server ngắt kết nối") end
        if gen == S.gen then on_data(gen, chunk) end
      end)
    end)
  end)
end

-- Dừng thử nối lại khi phiên debug kết thúc
local function stop_on_dap_end()
  local DAP_KEY = "config.flutter.vm_service"
  local ok, dap = pcall(require, "dap")
  if not ok then return end
  for _, event in ipairs({ "event_terminated", "event_exited" }) do
    dap.listeners.before[event][DAP_KEY] = function() M.disconnect() end
  end
end

function M.connect(uri, on_connect, on_error)
  M.disconnect()
  S.uri, S.on_connect, S.on_error = uri, on_connect, on_error
  S.wanted, S.attempts, S.opened_once = true, 0, false
  stop_on_dap_end()
  open_socket()
end

function M.disconnect()
  S.wanted = false
  S.handlers = {}
  close_socket()
end

function M.stream_listen(stream_id, handler, callback)
  S.handlers[stream_id] = handler
  request("streamListen", { streamId = stream_id }, callback)
end

function M.is_connected() return S.phase == "open" end

return M
