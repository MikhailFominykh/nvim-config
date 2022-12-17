vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave" }, {
    group = vim.api.nvim_create_augroup("CursorLineToggle", {}),
    callback = function(t) vim.opt.cursorline = t.event == "WinEnter" end
})

