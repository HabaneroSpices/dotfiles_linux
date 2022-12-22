-- (m)ode i=insertmode, n=normalmode, v=visualmode
-- (k)ey The one on ya keyboard
-- (v)im What should n/vim do?
local function map(m, k, v)
  vim.keymap.set(m, k, v, { silent = true})
end

-- Mimic shell movements
map("i", "<C-E>", "<ESC>A") -- Ctrl+e goes to end of line (Insertmode)
map("i", "<C-A>", "<ESC>I") -- Ctrl+a goes to start of line (Insertmode)

map("n", "q", ":quit<CR>")  -- q tries to quit the buffer
map("n", "Q", ":quit!") -- Q quits the buffer forcefully
map("n", "<CR>", ":write<CR>") -- Enter/return saves the buffer

-- Load recent sessions
map("n", "<leader>sl", "<CMD>SessionLoad<CR>")

-- Keybindings for telescope
map("n", "<leader>fr", "<CMD>Telescope oldfiles<CR>")
map("n", "<leader>ff", "<CMD>Telescope find_files<CR>")
map("n", "<leader>fb", "<CMD>Telescope file_browser<CR>")
map("n", "<leader>fw", "<CMD>Telescope live_grep<CR>")
map("n", "<leader>ht", "<CMD>Telescope colorscheme<CR>")
