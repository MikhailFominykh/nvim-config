-- Open NetRw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file browser" })

-- Tabs mappings
vim.keymap.set("n", "<M-.>", vim.cmd.tabnext, { desc = "Next tab" })
vim.keymap.set("n", "<M-,>", vim.cmd.tabprev, { desc = "Prev tab" })

-- Toggle line wrapping
vim.keymap.set("n", "<leader>w", function() vim.opt.wrap = not vim.opt.wrap:get() end, { desc = "Toggle line wrapping" })

-- Write and source current file
vim.keymap.set("n", "<leader><leader>x", function()
    vim.cmd.write()
    vim.cmd.source("%")
end, { desc = "Write and source current file" })

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move lines up" })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move lines down" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader><leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<leader><leader>P", '"+P', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<leader><leader>d", '"_d', { desc = "Delete without writing to default register" })

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Search and replace current word" })

-- Quickfix mappings
vim.keymap.set("n", "<M-j>", vim.cmd.cnext, { desc = "Next quickfix item" })
vim.keymap.set("n", "<M-k>", vim.cmd.cprev, { desc = "Prev quickfix item" })
vim.keymap.set("n", "<leader>q", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
    if buftype == "quickfix" then
        vim.cmd.cclose()
    else
        vim.cmd.copen()
    end
end, { desc = "Toggle quickfix window" })

vim.keymap.set("v", "<leader>`", "c`<c-r>\"`<esc>", { desc = "`Sourround a text`" })
vim.keymap.set("v", "<leader>'", "c'<c-r>\"'<esc>", { desc = "'Sourround a text'" })
vim.keymap.set("v", "<leader>\"", "c\"<c-r>\"\"<esc>", { desc = "\"Sourround a text\"" })
vim.keymap.set("v", "<leader>[", "c[<c-r>\"]<esc>", { desc = "[Sourround a text]" })
vim.keymap.set("v", "<leader>(", "c(<c-r>\")<esc>", { desc = "(Sourround a text)" })
