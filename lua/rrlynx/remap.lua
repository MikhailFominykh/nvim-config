-- Open NetRw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Tabs mappings
vim.keymap.set("n", "<M-.>", vim.cmd.tabnext)
vim.keymap.set("n", "<M-,>", vim.cmd.tabprev)

-- Toggle line wrapping
vim.keymap.set("n", "<leader>w", function() vim.opt.wrap = not vim.opt.wrap:get() end)

-- Write and source current file
vim.keymap.set("n", "<leader><leader>x", function()
    vim.cmd.write()
    vim.cmd.source("%")
end)

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("n", "<leader><leader>p", '"+p')
vim.keymap.set("n", "<leader><leader>P", '"+P')

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
