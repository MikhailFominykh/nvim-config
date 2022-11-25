vim.cmd.language("en_US")

vim.opt.guicursor = ""
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

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

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

local ks = vim.keymap.set
-- Telescope mappings
local telescope = require("telescope.builtin")
ks("n", "<C-/>", function() telescope.current_buffer_fuzzy_find(require("telescope.themes").get_ivy()) end)
ks("n", "<leader>ff", telescope.find_files)
ks("n", "<leader>b", telescope.buffers)

-- Quickfix mappings
ks("n", "<M-j>", vim.cmd.cnext)
ks("n", "<M-k>", vim.cmd.cprev)
ks("n", "<leader>q", require("mike").toggle_quickfix_window)

-- Tabs mappings
ks("n", "<M-.>", vim.cmd.tabnext)
ks("n", "<M-,>", vim.cmd.tabprev)

ks("n", "<leader><leader>x", function()
    vim.cmd.write()
    vim.cmd.source("%")
end)
