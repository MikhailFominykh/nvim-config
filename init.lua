vim.cmd.language("en_US")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.smartindent = true
vim.opt.laststatus = 3
vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.autoread = true

vim.g.mapleader = " "

require("plugins")
require("mike")

vim.cmd.colorscheme("nord")
vim.cmd("hi Normal guibg=#232730")
vim.cmd("hi CursorLine guibg=#2e3440")

vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave" }, {
    group = vim.api.nvim_create_augroup("CursorLineToggle", {}),
    callback = function(t) vim.opt.cursorline = t.event == "WinEnter" end
})

-- Replace selected text without changing default register
vim.keymap.set("x", "<leader>p", '"_dP')

-- Telescope mappings
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<C-/>", function() telescope.current_buffer_fuzzy_find(require("telescope.themes").get_ivy()) end)
vim.keymap.set("n", "<leader>ff", telescope.find_files)
vim.keymap.set("n", "<leader>b", telescope.buffers)

-- Quickfix mappings
vim.keymap.set("n", "<M-j>", vim.cmd.cnext)
vim.keymap.set("n", "<M-k>", vim.cmd.cprev)
vim.keymap.set("n", "<leader>q", require("mike").toggle_quickfix_window)

-- Tabs mappings
vim.keymap.set("n", "<M-.>", vim.cmd.tabnext)
vim.keymap.set("n", "<M-,>", vim.cmd.tabprev)

-- Toggle line wrapping
vim.keymap.set("n", "<leader>w", function() vim.opt.wrap = not vim.opt.wrap:get() end)

vim.keymap.set("n", "<leader><leader>x", function()
    vim.cmd.write()
    vim.cmd.source("%")
end)
