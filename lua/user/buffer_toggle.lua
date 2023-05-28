local function is_file_buffer(buffer)
    if not vim.api.nvim_buf_is_loaded(buffer) then
        return false
    end

    if not vim.api.nvim_buf_is_valid(buffer) then
        return false
    end


    local buftype = vim.api.nvim_buf_get_option(buffer, "buftype")
    return buftype ~= "terminal" and buftype ~= "nofile"
end

local function is_terminal_buffer(buffer)
    if not vim.api.nvim_buf_is_loaded(buffer) then
        return false
    end

    if not vim.api.nvim_buf_is_valid(buffer) then
        return false
    end

    local buftype = vim.api.nvim_buf_get_option(buffer, "buftype")
    return buftype == "terminal"
end


local function toggle_buffer()
    local list = vim.api.nvim_list_bufs()

    table.sort(list, function(a, b)
        return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end)

    for _, buf in ipairs(list) do
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

    print("No previous buffer")
end

vim.keymap.set('n', ',m', toggle_buffer)
