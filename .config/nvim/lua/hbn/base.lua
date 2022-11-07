local g = vim.g
local o = vim.o
local opt = vim.opt

o.termguicolors = true

-- Decrease update time
o.timeoutlen = 500
o.updatetime = 200

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 8

-- Better editor UI
o.number = true
o.numberwidth = 2
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.linebreak = true
o.showbreak = "+++"


-- Better editing experience
o.expandtab = true
o.smarttab = true
o.smartindent = true
o.cindent = true
o.autoindent = true
o.wrap = true
o.textwidth = 300   -- Might need to be 0 if theres wrapping issues
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = -1  -- If negative, shiftwidth value is used
o.list = true
--o.listchars = "trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂"
o.showmatch = true  -- Highlight matching brace
o.visualbell = true -- Use visual ell (no beeping)
o.ruler = true      -- Show row and column ruler information

-- Makes neovim and host OS clipboard play nicely with each other
--o.clipboard = "unnamedplus"

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true -- Always case-insensitive
o.smartcase = true  -- Enable smart-case search
o.hlsearch = true   -- Highlight all search results
o.incsearch = true  -- Searches for strings incrementally

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
o.undolevels = 1000
o.swapfile = false
-- o.backupdir = '/tmp/'
-- o.directory = '/tmp/'
-- o.undodir = '/tmp/'

-- Remember 50 items in commandline history
o.history = 50

-- Better buffer splitting
o.splitright = true
o.splitbelow = true

-- Map <leader> to space
g.mapleader = " "
g.maplocalleader = " "

--opt.mouse = "a"
