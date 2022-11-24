local M = {}
local P = function(value)
    return vim.inspect(value)
end

local find_buffer = function(buffer_name)
    local buffers = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(buffers) do
        local bname = vim.fn.bufname(bufnr)
        if bname == buffer_name then
            return bufnr
        end
    end
end

local find_window = function(bufnr)
    local windows = vim.api.nvim_list_wins()
    for _, winnr in ipairs(windows) do
        if vim.api.nvim_win_get_buf(winnr) == bufnr then
            return winnr
        end
    end
end

M.cargo_build = function()
    local Job = require 'plenary.job'
    --    vim.lsp.cargo_build()

    local list = {}
    Job:new({
        command = 'cargo',
        args = { 'build' },
        cwd = vim.fn.getcwd(),
        enabled_recording = true,
        on_exit = function(self, _, _)
            local item
            local error_found = false
            for _, s in ipairs(self:stderr_result()) do
                if (error_found) then
                    local _, _, file, line, col = string.find(s, "%s*--> ([^:]+):(%d+):(%d+)")
                    print(file, line, col)
                    item.filename = file
                    item.lnum = tonumber(line)
                    item.col = tonumber(col)
                    table.insert(list, item)
                    error_found = false
                else
                    local _, _, err_no, err_msg = string.find(s, "error%[([^%]]+)%]: (.+)")
                    if err_no ~= nil and err_msg ~= nil then
                        print("Error found", err_no, err_msg)
                        error_found = true
                        item = { nr = err_no, text = err_msg, type = 'E' }
                    end
                end
            end
        end,
    }):sync()
    if #list > 0 then
        vim.fn.setqflist(list)
        vim.cmd "copen"
    else
        vim.fn.setqflist({})
        vim.cmd "cclose"
        print("Build complete")
    end
end

--[=[
local _, _, err_no, err_msg = string.find("error[ERR_NUMBER234]: Some error text", "error%[([^%]]+)%]: (.+)")
print(err_no)
print(err_msg)
local _, _, file, line, col = string.find("  --> foo/bar/file.rs:234:3", "%s*--> ([^:]+):(%d+):(%d+)")
print("file:", file)
print("line:", line)
print("col:", col)
--]=]

--[=[local bufnr = vim.api.nvim_create_buf(true, true)
local bufnr = find_buffer("My Buffer")
if bufnr == nil then
    bufnr = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(bufnr, "My Buffer")
end
local winnr = find_window(bufnr)
if winnr == nil then
    vim.cmd "bo split"
    winnr = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(winnr, bufnr)
end
local lines_count = vim.api.nvim_buf_line_count(bufnr)
vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { string.format("%d", lines_count) })
--]=]

return M
