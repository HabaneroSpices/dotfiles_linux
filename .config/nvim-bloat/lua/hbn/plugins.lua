-- Require packer
local status, packer = pcall(require, "packer")
if not status then
	print("Packer is not installed")
	return
end

-- Reloads Neovim after whenever you save plugins.lua
vim.cmd([[
    augroup packer_user_config
      autocmd!
     autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup END
]])

packer.startup(function(use)
  use("wbthomason/packer.nvim")           -- Packer can manage itself
  use("glepnir/dashboard-nvim")           -- Dashboard is a nice start screen for nvim
  
  -- Telescope
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    requires = { { "nvim-lua/plenary.nvim" } },
  })
  use("nvim-telescope/telescope-file-browser.nvim")
  use("nvim-treesitter/nvim-treesitter") -- Treesitter Syntax Highlighting

  -- Productivity
  use("vimwiki/vimwiki")
  use("jreybert/vimagit")
  use("nvim-orgmode/orgmode")
  
  use("folke/which-key.nvim") -- Which Key
  use("nvim-lualine/lualine.nvim") -- A better statusline

  -- File management --
  use("vifm/vifm.vim")
  use("scrooloose/nerdtree")
  use("tiagofumo/vim-nerdtree-syntax-highlight")
  use("ryanoasis/vim-devicons")

  -- Syntax Highlighting and Colors --
  use("PotatoesMaster/i3-vim-syntax")
  use("kovetskiy/sxhkd-vim")
  use("vim-python/python-syntax")
  use("ap/vim-css-color")

  use("junegunn/vim-emoji")
  use("RRethy/nvim-base16")

  use("frazrepo/vim-rainbow") -- The most important plugin

  if packer_bootstrap then
    packer.sync()
  end

end)
