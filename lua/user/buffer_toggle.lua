local fns = require("user.functions")

local buffer_history = {}

local function is_file_buffer(buffer)
    if vim.api.nvim_buf_is_valid(buffer) == false then
        return false
    end

    local buftype = vim.api.nvim_buf_get_option(buffer, "buftype")
    return buftype ~= "terminal" and buftype ~= "nofile"
end

local function get_non_terminal_buffers()
    local buffers = vim.api.nvim_list_bufs()

    local non_terminal_buffers = {}

    for _, buffer in ipairs(buffers) do
        if is_file_buffer(buffer) then
            table.insert(non_terminal_buffers, buffer)
        end
    end

    return non_terminal_buffers
end

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    callback = function()
        local current_buffer = vim.fn.bufnr()

        fns.remove_value(buffer_history, current_buffer)

        if is_file_buffer(current_buffer) then
            table.insert(buffer_history, current_buffer)
        end
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



vim.keymap.set('n', ',m', function()
    local non_terminal_buffers = get_non_terminal_buffers()

    if #non_terminal_buffers <= 1 then
        print("No other buffers")
        return
    end


    local list = buffer_history
    if #buffer_history <= 1 then
        list = non_terminal_buffers
    end

    -- loop the list in reverse
    for i = 1, #list do
        local buf = list[#list + 1 - i]
        if buf ~= vim.fn.bufnr() and is_file_buffer(buf) then
            vim.api.nvim_command("buffer " .. buf)
            return
        end
    end
end)
