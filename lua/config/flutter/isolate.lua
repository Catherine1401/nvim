-- Chọn isolate giao diện của app: có app (vd. bipay) chạy thêm engine nền cũng tên "main" nên không thể dựa vào tên
local M = {}

local PROBE_GROUP = "config-flutter-isolate-probe"
local ISOLATE_NAME = "main"
local READY_EXT = "ext.flutter.inspector.isWidgetTreeReady"
local KEY = "config.flutter.isolate"

-- Isolate giao diện đã xác định; xoá khi có isolate mới đăng ký inspector hoặc app dừng
local cached = nil
-- Các isolate đã đăng ký inspector (từ sự kiện serviceExtensionAdded), để khỏi gọi getVM khi dò lần đầu
local known = {}

local function count_nodes(node)
  local total = 1
  for _, child in ipairs(node.children or {}) do
    total = total + count_nodes(child)
  end
  return total
end

-- Các isolate ứng viên: tên "main", nếu không có thì lấy tất cả
local function candidates(vm)
  local all, mains = {}, {}
  for _, isolate in ipairs(vm.isolates or {}) do
    all[#all + 1] = isolate.id
    if isolate.name == ISOLATE_NAME then mains[#mains + 1] = isolate.id end
  end
  return #mains > 0 and mains or all
end

-- Gọi song song fn cho từng id, gom kết quả theo thứ tự rồi trả về qua done
local function map_async(ids, fn, done)
  local results, pending = {}, #ids
  for i, id in ipairs(ids) do
    fn(id, function(value)
      results[i] = value
      pending = pending - 1
      if pending == 0 then done(results) end
    end)
  end
end

-- Chọn isolate có cây widget lớn nhất; chỉ dùng khi isWidgetTreeReady không đủ để phân biệt
local function probe_by_size(session, ids, callback)
  map_async(ids, function(id, done)
    local params = { objectGroup = PROBE_GROUP, isolateId = id }
    session:request("callService", { method = "ext.flutter.inspector.getRootWidgetSummaryTree", params = params }, function(err, response)
      session:request("callService", { method = "ext.flutter.inspector.disposeGroup", params = params }, function() end)
      done(not err and response and count_nodes(response.result or response) or 0)
    end)
  end, function(sizes)
    local best, best_size = nil, -1
    for i, size in ipairs(sizes) do
      if size > best_size then best, best_size = ids[i], size end
    end
    callback(best)
  end)
end

-- Các isolate có widget tree sẵn sàng (2 đến 3 ms mỗi isolate, rẻ hơn lấy cả cây); isolate đã chết hoặc nền bị loại
local function ready_ids(session, ids, callback)
  map_async(ids, function(id, done)
    session:request("callService", { method = READY_EXT, params = { isolateId = id } }, function(err, response)
      done(not err and response ~= nil and response.result == true)
    end)
  end, function(flags)
    local ready = {}
    for i, is_ready in ipairs(flags) do
      if is_ready then ready[#ready + 1] = ids[i] end
    end
    callback(ready)
  end)
end

-- Chỉ một isolate sẵn sàng thì chọn luôn; nhiều hoặc không có isolate nào thì dò theo kích thước cây
local function pick(session, ids, callback)
  ready_ids(session, ids, function(ready)
    if #ready == 1 then return callback(ready[1]) end
    probe_by_size(session, #ready > 1 and ready or ids, callback)
  end)
end

local function choose(session, ids, callback)
  if #ids <= 1 then
    cached = ids[1]
    return callback(cached)
  end
  pick(session, ids, function(id)
    cached = id
    callback(id)
  end)
end

-- Danh sách isolate ứng viên: sự kiện đã thấy từ hai isolate trở lên thì dùng luôn; chỉ thấy một (có thể bỏ sót isolate khác) thì hỏi getVM
local function candidate_ids(session, callback)
  if #known > 1 then return callback(vim.list_slice(known)) end
  session:request("callService", { method = "getVM", params = vim.empty_dict() }, function(err, response)
    callback(not err and response and candidates(response.result or response) or {})
  end)
end

local function detect(session, callback)
  candidate_ids(session, function(ids) choose(session, ids, callback) end)
end

-- Gọi method của Flutter inspector trên isolate giao diện; isolate cache hỏng (đã chết) thì dò lại đúng một lần
-- callback(err, response, isolate_id)
function M.call(session, method, params, callback)
  local function request(isolate_id, retry)
    if not isolate_id then return callback("không tìm thấy isolate giao diện", nil, nil) end
    local full = vim.tbl_extend("force", params, { isolateId = isolate_id })
    session:request("callService", { method = method, params = full }, function(err, response)
      if err and retry then
        cached, known = nil, {}
        return detect(session, function(id) request(id, false) end)
      end
      callback(err, response, isolate_id)
    end)
  end
  if cached then return request(cached, true) end
  detect(session, function(id) request(id, false) end)
end

-- Isolate giao diện đang được xem (nil khi chưa xác định)
function M.current() return cached end

-- Chuyển sang isolate giao diện kế tiếp (vòng tròn); callback(new_id, index, total, old_id), chỉ có một isolate thì new_id là chính nó
function M.cycle(session, callback)
  candidate_ids(session, function(ids)
    ready_ids(session, ids, function(ready)
      local old = cached
      if #ready <= 1 then return callback(ready[1] or old, 1, #ready, old) end
      local index = 0
      for i, id in ipairs(ready) do
        if id == old then index = i end
      end
      index = index % #ready + 1
      cached = ready[index]
      callback(cached, index, #ready, old)
    end)
  end)
end

-- Ghi nhận isolate đăng ký inspector (hot restart tạo isolate mới) và xoá hết khi app dừng
function M.setup()
  local dap = require("dap")
  dap.listeners.after["event_dart.serviceExtensionAdded"][KEY] = function(_, body)
    if not body or body.extensionRPC ~= "ext.flutter.inspector.show" or not body.isolateId then return end
    cached = nil
    if not vim.tbl_contains(known, body.isolateId) then known[#known + 1] = body.isolateId end
  end
  for _, event in ipairs({ "event_terminated", "event_exited" }) do
    dap.listeners.after[event][KEY] = function() cached, known = nil, {} end
  end
end

return M
