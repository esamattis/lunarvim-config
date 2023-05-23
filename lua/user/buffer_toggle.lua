local fns = require("user.functions")

local buffer_history = {}

local function is_file_buffer(buffer)
    if vim.api.nvim_buf_is_valid(buffer) == false then
        return false
    end

    local buftype = vim.api.nvim_buf_get_option(buffer, "buftype")
    return buftype ~= "terminal" and buftype ~= "nofile"
end

local function is_terminal_buffer(buffer)
    if vim.api.nvim_buf_is_valid(buffer) == false then
        return false
    end

    local buftype = vim.api.nvim_buf_get_option(buffer, "buftype")
    return buftype == "terminal"
end


local function toggle_buffer()
    local list = buffer_history
    if #buffer_history <= 1 then
        list = vim.api.nvim_list_bufs()
    end

    -- loop the list in reverse
    for i = 1, #list do
        local buf = list[#list + 1 - i]
        if buf ~= vim.fn.bufnr() then
            if vim.bo.buftype == "terminal" then
                if is_terminal_buffer(buf) then
                    vim.api.nvim_command("buffer " .. buf)
                    return
                end
            else
                if is_file_buffer(buf) then
                    vim.api.nvim_command("buffer " .. buf)
                    return
                end
            end
        end
    end

    print("No other buffers")
end

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    callback = function()
        local current_buffer = vim.fn.bufnr()

        fns.remove_value(buffer_history, current_buffer)

        table.insert(buffer_history, current_buffer)
    end
})


vim.api.nvim_create_autocmd({ "BufDelete" }, {
    callback = function()
        local deleted_buffer = vim.fn.expand("<abuf>")
        fns.remove_value(buffer_history, deleted_buffer)
    end
})

vim.api.nvim_create_user_command("BufferToggleDebug", function()
    local debug = {}

    for _, buffer in ipairs(buffer_history) do
        local name = vim.fn.bufname(buffer)

        local buftype = "errrrrrr"
        if vim.api.nvim_buf_is_valid(buffer) then
            buftype = vim.api.nvim_buf_get_option(buffer, "buftype")
        end

        table.insert(debug, { number = buffer, name = name, buftype = buftype, })
    end

    print(vim.inspect(debug))
end, { nargs = 0 })



vim.keymap.set('n', ',m', toggle_buffer)
vim.keymap.set('t', '<M-m>', toggle_buffer)
