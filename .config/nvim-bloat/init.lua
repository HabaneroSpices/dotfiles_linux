--local home = os.getenv("HOME")
--local nvimPath = home .. "/.config/nvim/"

require("kickstart") -- Auto-Installer & Advanced Configuration
require("maps") -- Maps

local g = vim.g
local o = vim.o
local opt = vim.opt

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
--o.undolevels = 1000
o.swapfile = false
-- o.backupdir = '/tmp/'
-- o.directory = '/tmp/'
-- o.undodir = '/tmp/'

-- Remember 50 items in commandline history
o.history = 50

opt.mouse = ""
