local M = {}

M.select = function(title, options, callback)
    local max_length = 0
    for _, o in ipairs(options) do
        max_length = math.max(max_length, string.len(o))
    end
    max_length = math.max(max_length, string.len(title)) + 2
    local padded_options = {}
    for _, opt in ipairs(options) do
        table.insert(padded_options, " " .. opt .. " ")
    end

    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, padded_options)
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
    local win = vim.api.nvim_open_win(bufnr, true,
        {
            relative = "cursor",
            row = 0,
            col = 0,
            width = max_length,
            height = table.maxn(options),
            style = "minimal",
            noautocmd = true,
            border = "single",
            title = title,
            title_pos = "center",
        })
    vim.api.nvim_win_set_option(win, "cursorline", true)
    vim.keymap.set("n", "<cr>",
        function()
            local cursor = vim.api.nvim_win_get_cursor(win)
            local option_index = cursor[1]
            local selected_option = { index = option_index, value = options[option_index] }
            vim.api.nvim_buf_delete(bufnr, {})
            callback(selected_option)
        end,
        { buffer = bufnr })

    vim.keymap.set("n", "q",
        function()
            vim.api.nvim_buf_delete(bufnr, {})
        end,
        { buffer = bufnr })
end

return M
