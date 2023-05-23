local previous_buffer = nil
local current_buffer = nil

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    callback = function()
        if current_buffer ~= nil then
            previous_buffer = current_buffer
        end

        current_buffer = vim.fn.bufnr()
    end
})


vim.keymap.set('n', ',m', function()
    vim.api.nvim_command("buffer " .. previous_buffer)
end)
