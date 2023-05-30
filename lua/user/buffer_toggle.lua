local fns = require("user.functions")

local function toggle_buffer()
    local buffers = vim.api.nvim_list_bufs()

    table.sort(buffers, function(a, b)
        return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end)

    for _, buf in ipairs(buffers) do
        if buf ~= vim.fn.bufnr() then
            if vim.bo.buftype == "terminal" then
                if fns.is_terminal_buffer(buf) then
                    vim.api.nvim_command("buffer " .. buf)
                    return
                end
            else
                if fns.is_file_buffer(buf) then
                    vim.api.nvim_command("buffer " .. buf)
                    return
                end
            end
        end
    end

    print("No previous buffer")
end

vim.keymap.set('n', ',m', toggle_buffer)
