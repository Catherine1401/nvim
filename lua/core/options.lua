-- General options
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·" }
vim.opt.fillchars = { eob = " " }
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 10
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.autowrite = true
vim.opt.autoread = true
vim.opt.fileencoding = "utf-8"
vim.opt.encoding = "utf-8"
-- Performance settings are set above
vim.opt.exrc = true
vim.opt.secure = true

-- Performance
vim.opt.synmaxcol = 240
vim.opt.updatetime = 300
vim.opt.redrawtime = 1500
vim.opt.timeoutlen = 300

-- Indent guides
vim.opt.listchars = {
  tab = "  ",
  trail = "·",
  extends = "❯",
  precedes = "❮",
}

-- Better search
vim.opt.incsearch = true
vim.opt.wrapscan = true

-- Better completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore = {
  "*.o", "*.obj", "*.dll", "*.so", "*.dylib",
  "*.exe", "*.out", "*.app", "*.i*86", "*.x86_64",
  "*.hex", "*.class", "*.pyc", "__pycache__",
  "*.jpg", "*.jpeg", "*.png", "*.gif", "*.ico",
  "*.svg", "*.pdf", "*.zip", "*.tar.gz", "*.tar.bz2",
  "*.rar", "*.7z", "*.mp3", "*.mp4", "*.avi",
  "*.mkv", "*.mov", "*.wmv", "*.flv", "*.webm",
  "node_modules", ".git", ".svn", ".hg", ".bzr",
  "*.swp", "*.swo", "*~", "*.tmp", "*.temp",
  ".DS_Store", "Thumbs.db", "*.log", "*.sql",
  "*.sqlite", "*.db", "*.cache", ".cache",
  "dist", "build", "coverage", ".nyc_output",
  ".next", ".nuxt", ".output", ".vuepress/dist",
  "public", "static", "assets", "uploads",
}

-- Better window management
vim.opt.equalalways = false
vim.opt.winminwidth = 5
vim.opt.winminheight = 1

-- Better buffer management
vim.opt.bufhidden = "hide"
vim.opt.buflisted = true

-- Better terminal
vim.opt.termguicolors = true

-- Better folding
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.foldnestmax = 10
vim.opt.foldminlines = 1

-- Better diff
vim.opt.diffopt = "filler,iwhite,internal,algorithm:patience"

-- Better grep
vim.opt.grepprg = "rg --vimgrep --smart-case --follow"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Better shell
if vim.fn.has("win32") == 1 then
  vim.opt.shell = "powershell.exe"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellxquote = ""
else
  vim.opt.shell = "bash"
end
