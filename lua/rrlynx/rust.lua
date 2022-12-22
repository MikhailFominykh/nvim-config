local M = {}

local function try_parse_message(m)
    -- Last message 'aborting due to previous error' has no spans.
    if m.reason ~= "compiler-message" or #m.message.spans == 0 then
        return
    end

    local item = { text = m.message.message, type = "E" }
    if m.message.level == "error" then
        local code = m.message.code;
        if code ~= vim.NIL then
            item.nr = code.code
        end
    elseif m.message.level == "warning" then
        item.type = "W"
    end
    for _, span in ipairs(m.message.spans) do
        if span.is_primary then
            item.filename = span.file_name
            item.lnum = span.line_start
            item.col = span.column_start
            return item
        end
    end
end

local function set_qflist_from_cargo_task_output(data)
    if not data then
        return
    end
    local list = {}
    for _, s in ipairs(data) do
        if s ~= nil and #s > 0 then
            local decoded = vim.json.decode(s)
            local parsed = try_parse_message(decoded)
            if parsed then
                table.insert(list, parsed)
            end
        end
    end
    if #list > 0 then
        vim.fn.setqflist(list)
        vim.cmd "copen"
    else
        vim.fn.setqflist({})
        vim.cmd "cclose"
        print("Cargo task complete")
    end
end

local function run_task(task_name)
    local stdout_data
    vim.fn.jobstart(
        { "cargo", task_name, "--message-format", "json-diagnostic-short" },
        {
            stdout_buffered = true,
            on_stdout = function(_, data)
                stdout_data = data
            end,
            on_exit = function()
                set_qflist_from_cargo_task_output(stdout_data)
            end
        })
end

M.cargo_build = function()
    run_task("build")
end

M.cargo_clippy = function()
    run_task("clippy")
end

return M
