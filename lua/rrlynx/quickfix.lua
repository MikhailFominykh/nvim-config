local toggle_quickfix_window = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
    if buftype == "quickfix" then
        vim.cmd.cclose()
    else
        vim.cmd.copen()
    end
end

vim.keymap.set("n", "<M-j>", vim.cmd.cnext)
vim.keymap.set("n", "<M-k>", vim.cmd.cprev)
vim.keymap.set("n", "<leader>q", toggle_quickfix_window)

