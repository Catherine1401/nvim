-- Chọn isolate giao diện của app: có app (vd. bipay) chạy thêm engine nền cũng tên "main", nên chọn isolate có cây widget lớn nhất
local M = {}

local PROBE_GROUP = "config-flutter-isolate-probe"
local ISOLATE_NAME = "main"

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

local function probe(session, ids, callback)
  local best, best_size, pending = nil, -1, #ids
  for _, id in ipairs(ids) do
    local params = { objectGroup = PROBE_GROUP, isolateId = id }
    session:request("callService", { method = "ext.flutter.inspector.getRootWidgetSummaryTree", params = params }, function(err, response)
      local size = not err and response and count_nodes(response.result or response) or 0
      if size > best_size then best, best_size = id, size end
      session:request("callService", { method = "ext.flutter.inspector.disposeGroup", params = params }, function() end)
      pending = pending - 1
      if pending == 0 then callback(best) end
    end)
  end
end

-- Gọi callback(isolate_id) với isolate giao diện, hoặc nil khi không tìm thấy; chỉ dò cây khi có nhiều hơn một ứng viên
function M.ui(session, callback)
  session:request("callService", { method = "getVM", params = vim.empty_dict() }, function(err, response)
    local ids = not err and response and candidates(response.result or response) or {}
    if #ids <= 1 then return callback(ids[1]) end
    probe(session, ids, callback)
  end)
end

return M
