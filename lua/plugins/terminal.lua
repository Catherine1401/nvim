return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      shell = "powershell.exe",     -- hoặc "pwsh"
      direction = "float",          -- floating terminal
      start_in_insert = true,
    },
  }
}
