-- ~/.config/nvim/lua/plugins/easy-dotnet.lua
-- Yêu cầu: dotnet tool install -g EasyDotnet

return {
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    ft = { "cs", "vb", "csproj", "sln", "slnx", "props", "fsproj" },
    config = function()
      local dotnet = require("easy-dotnet")

      dotnet.setup({
        managed_terminal = {
          auto_hide = true,
          auto_hide_delay = 1000,
        },
        lsp = {
          enabled = true,
          preload_roslyn = true,
          roslynator_enabled = true,
          easy_dotnet_analyzer_enabled = true,
          auto_refresh_codelens = true,
        },
        debugger = {
          console = "integratedTerminal",
          apply_value_converters = true,
          auto_register_dap = true,
        },
        test_runner = {
          auto_start_testrunner = true,
          viewmode = "float",
        },
        new = {
          project = { prefix = "sln" },
        },
        csproj_mappings = true,
        fsproj_mappings = true,
        auto_bootstrap_namespace = {
          type = "block_scoped",
          enabled = true,
        },
        picker = "telescope",
        background_scanning = true,
        diagnostics = {
          default_severity = "error",
          setqflist = false,
        },
      })

      local map = vim.keymap.set
      local o = function(desc) return { desc = "dotnet: " .. desc, silent = true } end

      map("n", "<leader>db", function() dotnet.build_solution() end,          o("Build solution"))
      map("n", "<leader>dB", function() dotnet.build_solution_quickfix() end, o("Build solution (quickfix)"))
      map("n", "<leader>dr", function() dotnet.run_default() end,             o("Run (default)"))
      map("n", "<leader>dR", function() dotnet.run() end,                     o("Run (pick)"))
      map("n", "<leader>dy", function() dotnet.testrunner() end,              o("Toggle test runner"))
      map("n", "<leader>dT", function() dotnet.test_solution() end,           o("Test solution"))
      map("n", "<leader>dw", function() dotnet.watch_default() end,           o("Watch (default)"))
      map("n", "<leader>ds", function() dotnet.secrets() end,                 o("User secrets"))
      map("n", "<leader>do", function() dotnet.outdated() end,                o("Outdated packages"))
      map("n", "<leader>da", function() dotnet.add_package() end,             o("Add NuGet package"))
      map("n", "<leader>dp", function() dotnet.project_view() end,            o("Project view"))
      map("n", "<leader>dn", function() dotnet.new() end,                     o("New template"))
      map("n", "<leader>dD", function()
        require("easy-dotnet.actions.diagnostics").get_workspace_diagnostics()
      end, o("Workspace diagnostics"))
    end,
  },
}
