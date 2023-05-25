local fns         = require("user.functions")

-- start pop terminal
-- lvim.builtin.terminal.open_mapping = "<m-y>"
--
local Terminal    = require('toggleterm.terminal').Terminal
local popterminal = Terminal:new({ hidden = true, direction = "float" })

fns.keymap_all("<M-y>", function()
    popterminal:toggle()
end)

-- exit from terminal mode
vim.keymap.set({ "t", "x" }, "<m-n>", "<C-\\><C-n>")

-- Automatically go to insert mode for new terminals
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        print("Setting insert mode for new termal")
        vim.api.nvim_command("startinsert")
    end,
})

-- Automatically go to inser mode for existing terminals
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if vim.bo.buftype == "terminal" then
            print("Setting insert mode for existing terminal")
            vim.api.nvim_command("startinsert")
        end
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd("setlocal nonumber")
    end,
})

fns.keymap_all("<M-j>", function()
    vim.api.nvim_command("stopinsert")
    fns.type_keys("<C-w>j")
end)

fns.keymap_all("<M-k>", function()
    vim.api.nvim_command("stopinsert")
    fns.type_keys("<C-w>k")
end)

fns.keymap_all("<M-h>", function()
    vim.api.nvim_command("stopinsert")
    fns.type_keys("<C-w>h")
end)

fns.keymap_all("<M-l>", function()
    vim.api.nvim_command("stopinsert")
    fns.type_keys("<C-w>l")
end)
