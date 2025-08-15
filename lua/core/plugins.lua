return require("lazy").setup({
  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin"
    end,
  },

  -- Essential plugins
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
        -- NvimTree keymaps
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')
          
          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end
          
          -- Default mappings
          vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD | Đổi root theo node'))
          vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place | Mở thay thế trong buffer hiện tại'))
          vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info | Thông tin node'))
          vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename | Đổi tên (bỏ phần tên file)'))
          vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab | Mở trong tab mới'))
          vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split | Mở ở split dọc'))
          vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split | Mở ở split ngang'))
          vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory | Đóng thư mục'))
          vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open | Mở'))
          vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open: No Pick | Mở không chọn cửa sổ'))
          vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling | Anh em kế tiếp'))
          vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling | Anh em trước đó'))
          vim.keymap.set('n', '.', api.node.run.cmd, opts('Run Command | Chạy lệnh'))
          vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up | Lên thư mục cha'))
          vim.keymap.set('n', 'a', api.fs.create, opts('Create | Tạo mới'))
          vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked | Di chuyển các bookmark'))
          vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer | Ẩn file không có buffer'))
          vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy | Sao chép'))
          vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean | Bật/tắt lọc git clean'))
          vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git | Hunk trước'))
          vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git | Hunk sau'))
          vim.keymap.set('n', 'd', api.fs.remove, opts('Delete | Xóa'))
          vim.keymap.set('n', 'D', api.fs.trash, opts('Trash | Thùng rác'))
          vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All | Mở rộng tất cả'))
          vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename | Đổi tên (basename)'))
          vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic | Lỗi kế tiếp'))
          vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic | Lỗi trước đó'))
          vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter | Xóa bộ lọc'))
          vim.keymap.set('n', 'f', api.live_filter.start, opts('Filter | Lọc theo tên'))
          vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help | Trợ giúp'))
          vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path | Sao chép đường dẫn tuyệt đối'))
          vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles | Ẩn/hiện file ẩn'))
          vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore | Ẩn/hiện file bị gitignore'))
          vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling | Anh em cuối'))
          vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling | Anh em đầu'))
          vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark | Bật/tắt bookmark'))
          vim.keymap.set('n', 'o', api.node.open.edit, opts('Open | Mở'))
          vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker | Mở không chọn cửa sổ'))
          vim.keymap.set('n', 'p', api.fs.paste, opts('Paste | Dán'))
          vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory | Thư mục cha'))
          vim.keymap.set('n', 'q', api.tree.close, opts('Close | Đóng'))
          vim.keymap.set('n', 'r', api.fs.rename, opts('Rename | Đổi tên'))
          vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh | Làm mới'))
          vim.keymap.set('n', 's', api.node.run.system, opts('Run System | Mở bằng hệ thống'))
          vim.keymap.set('n', 'S', api.tree.search_node, opts('Search | Tìm kiếm'))
          vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden | Bật/tắt bộ lọc tùy chỉnh'))
          vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse | Thu gọn tất cả'))
          vim.keymap.set('n', 'x', api.fs.cut, opts('Cut | Cắt'))
          vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name | Sao chép tên'))
          vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path | Sao chép đường dẫn tương đối'))
          vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open | Mở'))
          vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD | Đổi root theo node'))
        end,
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        preselect = cmp.PreselectMode.Item,
        completion = { completeopt = "menu,menuone" },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter nhận mục đang chọn (mặc định chọn mục 1)
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })

             require("luasnip.loaders.from_vscode").lazy_load()

       -- Configure diagnostics for realtime error display
       vim.diagnostic.config({
         virtual_text = {
           enabled = true,
           format = function(diagnostic)
             return string.format("%s %s", diagnostic.source, diagnostic.message)
           end,
         },
         signs = true,
         underline = true,
         update_in_insert = false,
         severity_sort = true,
         float = {
           border = "rounded",
           source = "always",
           header = "",
           prefix = "",
         },
       })

       -- Hide diagnostics in insert mode
       local hide_diagnostics_group = vim.api.nvim_create_augroup("HideDiagnosticsInInsertMode", { clear = true })
       vim.api.nvim_create_autocmd("ModeChanged", {
         group = hide_diagnostics_group,
         pattern = "*",
         callback = function()
           local mode = vim.api.nvim_get_mode().mode
           if mode == "i" or mode == "ic" or mode == "ix" then
             vim.diagnostic.config({ virtual_text = false })
           else
             vim.diagnostic.config({ virtual_text = { enabled = true } })
           end
         end,
       })

       local capabilities = require("cmp_nvim_lsp").default_capabilities()
       local lspconfig = require("lspconfig")

                                     -- LSP servers (front-end + PHP + Dart/Flutter + Node.js Backend)
          local servers = {
            "ts_ls",    -- TypeScript/JavaScript (thay vì ts_ls)
            "html",     -- HTML
            "cssls",    -- CSS
            "jsonls",   -- JSON
            "tailwindcss", -- Tailwind CSS
            "vue_ls",    -- Vue (Volar)
            "emmet_ls", -- Emmet
            "intelephense", -- PHP language server
            "denols",   -- Deno/Node.js language server
            "yamlls",   -- YAML language server
            "dockerls", -- Docker language server
            "docker_compose_language_service", -- Docker Compose
          }

      -- LSP servers will be configured by mason-lspconfig handlers

      -- Mason setup
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
        handlers = {
          function(server_name)
            local config = {
              capabilities = capabilities,
                             on_attach = function(client, bufnr)
                 -- LSP keymaps
                 vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, noremap = true, silent = true })
                 vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, noremap = true, silent = true })
                 vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, noremap = true, silent = true })
                 vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, noremap = true, silent = true })
                 vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, noremap = true, silent = true })
                 
                 -- Diagnostics keymaps
                 vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, noremap = true, silent = true })
                 vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, noremap = true, silent = true })
                 -- Use <leader>de for diagnostics float to avoid conflict with NvimTree toggle
                 vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { buffer = bufnr, noremap = true, silent = true })
                 vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { buffer = bufnr, noremap = true, silent = true })
               end,
            }
            
            -- Add specific settings for TypeScript
            if server_name == "ts_ls" then
              config.settings = {
                typescript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
                javascript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
              }
            end
            
            -- Add specific settings for Vue
            if server_name == "vue_ls" then
              config.settings = {
                vue = {
                  inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
              }
            end
            
                                       -- Add specific settings for PHP (intelephense)
              if server_name == "intelephense" then
                config.settings = {
                  intelephense = {
                    files = { maxSize = 2000000 },
                    format = { enable = false },
                    stubs = {
                      "apache", "bcmath", "bz2", "calendar", "core", "curl", "date", "dom", "fileinfo",
                      "filter", "ftp", "gd", "gettext", "hash", "iconv", "imap", "json", "libxml",
                      "mbstring", "mcrypt", "mysql", "mysqli", "password", "pcntl", "pcre", "pdo",
                      "pdo_mysql", "Phar", "readline", "regex", "session", "SimpleXML", "soap", "sockets",
                      "sodium", "spl", "standard", "tokenizer", "xml", "xmlreader", "xmlwriter", "zip",
                      "zlib", "wordpress", "woocommerce", "acf", "laravel", "lumen", "cakephp", "codeigniter",
                    },
                  },
                }
              end

              -- Add specific settings for Node.js Backend (denols)
              if server_name == "denols" then
                config.settings = {
                  deno = {
                    enable = true,
                    unstable = false,
                    config = "./deno.json",
                    importMap = "./import_map.json",
                    lint = true,
                    codeLens = {
                      implementations = true,
                      references = true,
                      referencesAllFunctions = true,
                    },
                    suggest = {
                      imports = {
                        hosts = {
                          ["https://deno.land"] = true,
                          ["https://cdn.nest.land"] = true,
                          ["https://crux.land"] = true,
                        },
                      },
                    },
                  },
                }
              end



              -- Add specific settings for Docker
              if server_name == "dockerls" then
                config.settings = {
                  docker = {
                    languageserver = {
                      diagnostics = {
                        dockerfilelint = {},
                        hadolint = {},
                      },
                    },
                  },
                }
              end
             
                           

            require("lspconfig")[server_name].setup(config)
          end,
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
                                   ensure_installed = {
            "javascript", "typescript", "tsx",
            "html", "css", "scss", "json", "yaml",
            "vue", "lua", "vim", "bash", "markdown", "xml", "svelte", "php",
            "dart",
            -- Node.js Backend parsers
            "jsdoc", "toml", "dockerfile", "sql", "graphql", "prisma",
          },
        highlight = { enable = true },
        indent = { enable = true },
        matchup = { enable = true },
        auto_install = true,
      })
    end,
  },

  -- Match-up để nhảy/hiện vùng cặp ngoặc/thẻ tốt hơn
  { "andymass/vim-matchup" },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Git blame
  {
    "f-person/git-blame.nvim",
    init = function()
      vim.g.gitblame_enabled = 0
      vim.g.gitblame_display_virtual_text = 0
    end,
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      npairs.setup({
        check_ts = true, -- dùng Treesitter để quyết định chèn ngoặc thông minh
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        map_cr = true, -- tự xử lý phím Enter trong cặp ngoặc để thụt dòng thông minh
        map_bs = true, -- cho phép backspace xoá cặp ngoặc an toàn
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          java = false,
        },
        fast_wrap = {
          map = "<M-e>", -- Alt+e
          chars = { '{', '[', '(', '"', "'" },
          pattern = string.gsub([[ [%'%)%>%]%)%}%,] ]], " ", ""),
          offset = 0,
          end_key = '$',
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })

      -- Tối ưu dấu nháy đơn cho JS/TS/JSX/TSX/Vue (không chèn khi trước/sau là chữ số/ký tự chữ)
      npairs.add_rules({
        Rule("'", "'", { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" })
          :with_pair(cond.not_after_text("%w"))
          :with_pair(cond.not_before_text("%w")),
      })

      -- Gỡ quy tắc regex thừa dễ chặn gõ ngoặc thủ công

      -- Tự hoàn tất ngoặc khi xác nhận completion (cmp)
      local ok_cmp, cmp = pcall(require, "cmp")
      if ok_cmp then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- Tự động đóng/đổi tên thẻ cho HTML/JSX/Vue qua Treesitter
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
                                   filetypes = {
            "html",
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
            "tsx",
            "jsx",
            "vue",
            "svelte",
            "xml",
            "php",
            "dart",
            "markdown",
            "markdown_inline",
            -- Node.js Backend filetypes
            "jsdoc", "graphql", "prisma",
          },
      })
    end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = true,
          injected_languages = true,
          highlight = "Function",
          priority = 500,
        },
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
        },
      })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Buffer line
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          always_show_bufferline = true,
          show_buffer_close_icons = true,
          show_close_icon = false,
          color_icons = true,
          close_command = function(n) require("mini.bufremove").delete(n, false) end,
          right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, _, diag)
            local parts = {}
            if diag.error and diag.error > 0 then table.insert(parts, " " .. diag.error) end
            if diag.warning and diag.warning > 0 then table.insert(parts, " " .. diag.warning) end
            if diag.info and diag.info > 0 then table.insert(parts, " " .. diag.info) end
            if diag.hint and diag.hint > 0 then table.insert(parts, " " .. diag.hint) end
            return table.concat(parts, " ")
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            },
          },
        },
      })
    end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    config = function()
      local conform = require("conform")

      conform.setup({
        -- Prefer Beautify where applicable; fallback to Prettier
                                   formatters_by_ft = {
            lua = { "stylua" },
            -- JS/HTML/CSS: Chỉ Beautify (theo yêu cầu)
            javascript = { "js-beautify" },
            javascriptreact = { "js-beautify" },
            html = { "html-beautify" },
            css = { "css-beautify" },
            scss = { "css-beautify" },
            -- TS/TSX/Vue/JSON/YAML/Markdown: Không auto-fallback sang Prettier
            typescript = {},
            typescriptreact = {},
            vue = {},
            json = {},
            yaml = {},
            markdown = {},
            php = { "php-cs-fixer", "phpcbf" },
            -- Dart/Flutter: Sử dụng dart format
            dart = { "dart_format" },
            -- Node.js Backend formatters
            jsdoc = { "prettier" },
            graphql = { "prettier" },
            prisma = { "prettier" },
            dockerfile = { "hadolint" },
            sql = { "sqlformat" },
          },
        format_on_save = false,
        -- Define formatter adapters for Beautify family
        formatters = {
          ["js-beautify"] = {
            command = "js-beautify",
            stdin = true,
          },
          ["html-beautify"] = {
            command = "html-beautify",
            stdin = true,
          },
          ["css-beautify"] = {
            command = "css-beautify",
            stdin = true,
          },
                     ["php-cs-fixer"] = {
             command = "php-cs-fixer",
             args = { "fix", "--using-cache=no", "--quiet", "$FILENAME" },
             stdin = false,
             tempfile = "$FILENAME",
           },
           phpcbf = {
             command = "phpcbf",
             stdin = false,
             args = { "--standard=PSR12", "$FILENAME" },
             tempfile = "$FILENAME",
           },
                       ["dart_format"] = {
              command = "dart",
              args = { "format", "$FILENAME" },
              stdin = false,
              tempfile = "$FILENAME",
            },
            -- Node.js Backend formatters
            ["prettier"] = {
              command = "prettier",
              args = { "--write", "$FILENAME" },
              stdin = false,
              tempfile = "$FILENAME",
            },
            ["hadolint"] = {
              command = "hadolint",
              args = { "$FILENAME" },
              stdin = false,
              tempfile = "$FILENAME",
            },
            ["sqlformat"] = {
              command = "sqlformat",
              args = { "--reindent", "--keywords", "upper", "$FILENAME" },
              stdin = false,
              tempfile = "$FILENAME",
            },
        },
      })

      -- Create :Format command for keymap compatibility
      vim.api.nvim_create_user_command("Format", function()
        conform.format({ async = true, lsp_fallback = false })
      end, {})
    end,
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    config = function()
                           require("lint").linters_by_ft = {
          javascript = { "eslint_d", "eslint" },
          typescript = { "eslint_d", "eslint" },
          javascriptreact = { "eslint_d", "eslint" },
          typescriptreact = { "eslint_d", "eslint" },
          vue = { "eslint_d", "eslint" },
          php = { "phpcs" },
          dart = { "dart_analyzer" },
          -- Node.js Backend linters
          jsdoc = { "eslint_d" },
          graphql = { "eslint_d" },
          prisma = { "eslint_d" },
          dockerfile = { "hadolint" },
          sql = { "sqlfluff" },
          yaml = { "yamllint" },
        }
    end,
  },

  -- Better search
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },

  -- Better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

      -- Blade syntax for Laravel
    { "jwalton512/vim-blade" },

    -- Node.js Backend specific plugins
    -- JSDoc syntax highlighting
    { "heavenshell/vim-jsdoc" },
    
    -- GraphQL syntax highlighting
    { "jparise/vim-graphql" },
    
    -- Prisma schema syntax highlighting
    { "prisma/vim-prisma" },
    
    -- Docker syntax highlighting
    { "ekalinin/Dockerfile.vim" },
    
    -- SQL syntax highlighting
    { "b4winckler/vim-angry" },
    
    -- YAML syntax highlighting
    { "stephpy/vim-yaml" },
    
    -- TOML syntax highlighting
    { "cespare/vim-toml" },
    
    -- REST client for API testing (Windows compatible)
    { "diepm/vim-rest-console" },
    
    -- Database client
    { "tpope/vim-dadbod" },
    { "kristijanhusak/vim-dadbod-ui" },
    
    -- Git workflow for Node.js projects
    { "tpope/vim-fugitive" },
    
    -- Git blame with better display
    { "f-person/git-blame.nvim" },
    
    -- Git diff in sign column
    { "lewis6991/gitsigns.nvim" },
    
    -- Git conflict resolution
    { "akinsho/git-conflict.nvim" },
    
    -- Git branch management
    { "rbong/vim-flog" },
    
    -- REST client configuration (vim-rest-console)
    {
      "diepm/vim-rest-console",
      config = function()
        vim.g.vrc_curl_opts = {
          '-s', '-S', '--connect-timeout', '10',
          '--max-time', '60', '--retry', '3'
        }
        vim.g.vrc_auto_format_response_patterns = {
          json = 'jq',
          xml = 'xmllint --format -'
        }
        vim.g.vrc_response_default_content_type = 'application/json'
        vim.g.vrc_show_command = 0
        vim.g.vrc_include_response_headers = 1
        vim.g.vrc_include_response_body = 1
        vim.g.vrc_auto_format_response_enabled = 1
        vim.g.vrc_auto_format_response_patterns = {
          json = 'jq',
          xml = 'xmllint --format -'
        }
      end,
    },
    
    -- Database client configuration
    {
      "tpope/vim-dadbod",
      config = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_show_database_icon = 1
        vim.g.db_ui_winwidth = 30
        vim.g.db_ui_winheight = 20
        vim.g.db_ui_auto_execute_table_helpers = 1
        vim.g.db_ui_table_helpers = {
          sqlite = {
            count = "SELECT COUNT(*) FROM {table}",
            explain = "EXPLAIN QUERY PLAN {last_query}",
            indexes = "PRAGMA index_list({table})",
            show = "PRAGMA table_info({table})",
            size = "SELECT page_count * page_size as size FROM pragma_page_count(), pragma_page_size() WHERE name = '{table}'"
          },
          mysql = {
            count = "SELECT COUNT(*) FROM `{table}`",
            explain = "EXPLAIN {last_query}",
            indexes = "SHOW INDEX FROM `{table}`",
            show = "SHOW CREATE TABLE `{table}`",
            size = "SELECT ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)' FROM information_schema.TABLES WHERE table_schema = '{database}' AND table_name = '{table}'"
          },
          postgresql = {
            count = "SELECT COUNT(*) FROM {table}",
            explain = "EXPLAIN {last_query}",
            indexes = "SELECT indexname, indexdef FROM pg_indexes WHERE tablename = '{table}'",
            show = "\\d {table}",
            size = "SELECT pg_size_pretty(pg_total_relation_size('{table}'))"
          }
        }
      end,
    },
    
    -- Git conflict resolution configuration
    {
      "akinsho/git-conflict.nvim",
      config = function()
        require('git-conflict').setup({
          default_mappings = true,
          disable_diagnostics = false,
          highlights = {
            incoming = 'DiffAdd',
            current = 'DiffText',
          }
        })
      end,
    },

     -- Laravel helper (Artisan/Tinker routes etc.)
   -- Temporarily disabled due to missing promise-async dependency
   -- {
   --   "adalessa/laravel.nvim",
   --   dependencies = {
   --     "nvim-telescope/telescope.nvim",
   --     "nvim-lua/plenary.nvim",
   --     "rcarriga/nvim-notify",
   --     "nvim-neotest/nvim-nio",
   --   },
   --   config = function()
   --     require("laravel").setup()
   --   end,
   -- },

  -- Live Server (requires `npm i -g live-server`)
  {
    "barrett-ruth/live-server.nvim",
    config = function()
      require("live-server").setup({
        port = 5500,
        quiet = true,
        no_css_inject = false,
        browser_command = nil, -- dùng trình duyệt mặc định của hệ thống
      })
    end,
  },

     -- Mason-null-ls to auto-manage external formatters/linters (Beautify/Prettier/ESLint)
   {
     "jay-babu/mason-null-ls.nvim",
     dependencies = {
       "williamboman/mason.nvim",
       "nvimtools/none-ls.nvim",
     },
     config = function()
       require("mason-null-ls").setup({
                             ensure_installed = {
             -- Beautify family
             "js-beautify",
             "html-beautify",
             "css-beautify",
             -- Prettier & ESLint (fallbacks and TS/Vue)
             "prettier",
             "eslint_d",
             -- PHP tools (chỉ formatters/linters, không phải LSP)
             "phpcs",
             "phpcbf",
             "php-cs-fixer",
             -- Node.js Backend tools
             "hadolint",
             "sqlformat",
             "sqlfluff",
             "yamllint",
             "deno",
           },
         automatic_installation = true,
       })
     end,
   },

  -- Better notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
      -- Configure notify for better error display
      require("notify").setup({
        stages = "fade_in_slide_out",
        timeout = 3000,
        background_colour = "#000000",
        max_width = 80,
        max_height = 10,
      })
    end,
  },

  -- PHP Debug Adapter (Xdebug) via nvim-dap
  {
    "mfussenegger/nvim-dap",
  },
     {
     "rcarriga/nvim-dap-ui",
     dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
     config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    config = function()
             require("mason-nvim-dap").setup({
                   ensure_installed = { "php" }, -- php-debug-adapter
         automatic_installation = true,
       })
    end,
  },

  -- Better UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-notify",
    },
  },

  -- Better cursor
  {
    "mawkler/modicator.nvim",
    config = function()
      require("modicator").setup()
    end,
  },

  -- Better scrollbar
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end,
  },

  -- Better highlight
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        delay = 200,
      })
    end,
  },

  -- Better diagnostics display
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({
        auto_preview = false,
        auto_fold = false,
        use_diagnostic_signs = true,
        action_keys = {
          refresh = "r",
          toggle_preview = "P",
          switch_severity = "s",
          toggle_fold = "z",
          jump = { "<cr>", "<tab>" },
          open_in_browser = "gx",
          copy_to_clipboard = "<C-c>",
          toggle_mode = "m",
          switch_severity = "s",
          toggle_preview = "P",
          hover = "K",
          preview = "p",
          close_folds = "zM",
          cancel = "<esc>",
        },
      })
    end,
  },

  -- Better motion
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
    },
  },

  -- Better text objects
  {
    "echasnovski/mini.ai",
    version = "*",
    config = function()
      require("mini.ai").setup()
    end,
  },

  -- Safe buffer delete (used by bufferline close commands)
  {
    "echasnovski/mini.bufremove",
    version = false,
    config = function()
      require("mini.bufremove").setup()
    end,
  },

  -- Better splits
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("smart-splits").setup()
    end,
  },

  -- Better tabs (using bufferline instead of barbar)
  -- Bufferline is already configured above

  -- Better project management
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern" },
        patterns = { ".git", "package.json", "Makefile", "README.md" },
      })
    end,
  },

  -- Better session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "folds" } },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

     -- Better startup
   {
     "echasnovski/mini.starter",
     version = "*",
     config = function()
       require("mini.starter").setup()
     end,
   },

   -- Dart/Flutter specific plugins
   -- Flutter hot reload and commands
   {
     "akinsho/flutter-tools.nvim",
     dependencies = { "nvim-lua/plenary.nvim" },
     config = function()
       require("flutter-tools").setup({
         lsp = {
           color = {
             enabled = true,
             background = true,
             virtual_text = true,
           },
           settings = {
             showTodos = true,
             completeFunctionCalls = true,
             analysisExcludedFolders = {
               vim.fn.expand("$HOME/.pub-cache"),
               vim.fn.expand("$HOME/.pub-cache/global"),
             },
           },
         },
         debugger = {
           enabled = true,
           run_via_dap = true,
           exception_breakpoints = {},
           register_configurations = function(_)
             require("dap").configurations.dart = {
               {
                 type = "dart",
                 request = "launch",
                 name = "Launch Dart Program",
                 program = "${file}",
                 cwd = "${workspaceFolder}",
               },
               {
                 type = "dart",
                 request = "launch",
                 name = "Flutter: Hot Reload",
                 program = "${workspaceFolder}/lib/main.dart",
                 cwd = "${workspaceFolder}",
                 args = { "--hot" },
               },
               {
                 type = "dart",
                 request = "launch",
                 name = "Flutter: Hot Restart",
                 program = "${workspaceFolder}/lib/main.dart",
                 cwd = "${workspaceFolder}",
                 args = { "--hot-restart" },
               },
             }
           end,
         },
         fvm = false,
         ui = {
           border = "rounded",
           notification_style = "plugin",
         },
       })
     end,
   },

       -- Dart snippets
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load({
          paths = { vim.fn.stdpath("data") .. "/lazy/friendly-snippets/snippets" },
        })
      end,
    },

               -- Flutter/Dart project templates
     {
       "nvim-telescope/telescope.nvim",
       keys = {
         {
           "<leader>fp",
           "<cmd>Telescope flutter_devices<cr>",
           desc = "Flutter Devices",
         },
       },
     },

     -- Node.js Backend project templates and tools
     {
       "nvim-telescope/telescope.nvim",
       keys = {
         {
           "<leader>nb",
           "<cmd>Telescope git_branches<cr>",
           desc = "Git Branches",
         },
         {
           "<leader>nc",
           "<cmd>Telescope git_commits<cr>",
           desc = "Git Commits",
         },
         {
           "<leader>nf",
           "<cmd>Telescope git_files<cr>",
           desc = "Git Files",
         },
         {
           "<leader>ns",
           "<cmd>Telescope git_status<cr>",
           desc = "Git Status",
         },
         {
           "<leader>nd",
           "<cmd>DBUIToggle<cr>",
           desc = "Database UI",
         },
                   {
            "<leader>nr",
            "<cmd>VrcQuery<cr>",
            desc = "REST Client",
          },
       },
     },
 })
