
local fns = require("user.functions")

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "FocusGained" }, {
    callback = function()
        local current_buffer = vim.api.nvim_get_current_buf()
        if not fns.is_file_buffer(current_buffer) then
             return
        end


        if vim.bo.modified == false then
            vim.cmd("silent! e!")
        else
            fns.notify("This file has unsaved changes.", vim.log.levels.WARN)
        end
    end,
})
