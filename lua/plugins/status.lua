return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    -- Hàm tiện ích để kiểm tra Noice có sẵn sàng không
    local function show_macro_recording()
      local noice_status = require("noice").api.status
      return noice_status.mode.get()
    end

    local function has_macro_recording()
      local noice_status = require("noice").api.status
      return package.loaded["noice"] and noice_status.mode.has()
    end

    local function show_keys()
      local noice_status = require("noice").api.status
      return noice_status.command.get()
    end

    local function has_keys()
      local noice_status = require("noice").api.status
      return package.loaded["noice"] and noice_status.command.has()
    end

    return {
      options = {
        theme = "auto",        -- Tự động theo màu giao diện
        globalstatus = true,   -- Thanh trạng thái toàn cục
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
      },
      sections = {
        -- Giữ nguyên các phần bên trái
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        
        -- Giữ nguyên các phần bên phải
        lualine_x = {{
            show_keys,
            cond = has_keys,
            color = { fg = "#ff9e64" }, -- Màu cam cho dễ nhìn
          }, "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        
        -- === PHẦN QUAN TRỌNG: GÓC PHẢI (LUALINE_Z) ===
        lualine_z = {
          -- 1. Hiển thị phím đang gõ (Show CMD)
          -- Ví dụ: Khi cậu gõ 'd', '12', 'y', nó sẽ hiện ở đây
          
          
          -- 2. Hiển thị trạng thái quay Macro (Recording @q)
          {
            show_macro_recording,
            cond = has_macro_recording,
            -- color = { fg = "#ff9e64" }, -- Màu cam
          },

          -- 3. Đồng hồ (cậu yêu cầu lúc nãy)
          { "datetime", style = "%H:%M" },
          
          -- 4. Vị trí dòng/cột
          "location", 
        },
      },
    }
  end,
}
