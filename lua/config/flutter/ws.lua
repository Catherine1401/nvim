-- Mã hóa/giải mã frame WebSocket theo RFC 6455, không giữ trạng thái
local M = {}

M.OPCODE = { cont = 0, text = 1, binary = 2, close = 8, ping = 9, pong = 10 }

-- XOR payload với khóa mask 4 byte
local function mask(payload, key)
  local keys = { key:byte(1, 4) }
  local out = {}
  for i = 1, #payload do
    out[i] = string.char(bit.bxor(payload:byte(i), keys[(i - 1) % 4 + 1]))
  end
  return table.concat(out)
end

-- Header độ dài payload cho frame client (bit mask luôn bật)
local function length_header(len)
  if len < 126 then
    return string.char(0x80 + len)
  elseif len < 65536 then
    return string.char(0x80 + 126, bit.rshift(len, 8), bit.band(len, 0xFF))
  end
  return string.char(0x80 + 127, 0, 0, 0, 0, bit.band(bit.rshift(len, 24), 0xFF), bit.band(bit.rshift(len, 16), 0xFF), bit.band(bit.rshift(len, 8), 0xFF), bit.band(len, 0xFF))
end

-- Tạo frame client hoàn chỉnh (FIN=1, có mask và khóa mask)
function M.encode(opcode, payload)
  payload = payload or ""
  local key = vim.uv.random(4)
  return string.char(0x80 + opcode) .. length_header(#payload) .. key .. mask(payload, key)
end

-- Tạo request nâng cấp WebSocket với khóa ngẫu nhiên
function M.handshake(host, port, path)
  local lines = {
    "GET " .. path .. " HTTP/1.1",
    "Host: " .. host .. ":" .. port,
    "Upgrade: websocket",
    "Connection: Upgrade",
    "Sec-WebSocket-Key: " .. vim.base64.encode(vim.uv.random(16)),
    "Sec-WebSocket-Version: 13",
    "",
    "",
  }
  return table.concat(lines, "\r\n")
end

-- Tách phần phản hồi handshake; trả về dòng trạng thái và byte còn dư, nil nếu chưa đủ dữ liệu
function M.parse_handshake(buf)
  local head_end = buf:find("\r\n\r\n", 1, true)
  if not head_end then return nil end
  return buf:match("^[^\r\n]*"), buf:sub(head_end + 4)
end

-- Đọc độ dài payload, trả về độ dài và kích thước header; nil nếu chưa đủ dữ liệu
local function read_length(buf)
  local len7 = bit.band(buf:byte(2), 0x7F)
  if len7 < 126 then return len7, 2 end
  if len7 == 126 then
    if #buf < 4 then return nil end
    return buf:byte(3) * 256 + buf:byte(4), 4
  end
  if #buf < 10 then return nil end
  local hi = buf:byte(3) * 16777216 + buf:byte(4) * 65536 + buf:byte(5) * 256 + buf:byte(6)
  if hi > 0 then return nil, nil, "payload quá lớn" end
  return buf:byte(7) * 16777216 + buf:byte(8) * 65536 + buf:byte(9) * 256 + buf:byte(10), 10
end

-- Giải mã một frame đầu buffer; trả về frame và phần còn lại, nil nếu chưa đủ dữ liệu
function M.decode(buf)
  if #buf < 2 then return nil, buf end
  local len, header, err = read_length(buf)
  if err then return nil, buf, err end
  if not len then return nil, buf end
  -- Tính kích thước bằng nhánh tường minh, tránh and/or trong biểu thức số (LuaJIT tính sai ở đây)
  local key_len = 0
  if bit.band(buf:byte(2), 0x80) ~= 0 then key_len = 4 end
  local total = header + key_len + len
  if #buf < total then return nil, buf end
  local payload = buf:sub(header + key_len + 1, total)
  if key_len > 0 then payload = mask(payload, buf:sub(header + 1, header + 4)) end
  local fin = bit.band(buf:byte(1), 0x80) ~= 0
  return { fin = fin, opcode = bit.band(buf:byte(1), 0x0F), payload = payload }, buf:sub(total + 1)
end

return M
