local fns         = require("user.functions")

-- start pop terminal
-- lvim.builtin.terminal.open_mapping = "<m-y>"
--
local Terminal    = require('toggleterm.terminal').Terminal
local popterminal = Terminal:new({ hidden = true, direction = "float" })

fns.keymap_all(fns.meta_key("y"), function()
    popterminal:toggle()
end)

-- exit from terminal mode
vim.keymap.set("t", fns.meta_key("n"), "<C-\\><C-n>")
vim.keymap.set("t", "jj", "<C-\\><C-n>")


-- Insert Control-C from normal mode too when a terminal buffer is active
vim.keymap.set({ "n", "x" }, "<C-c>", function()
    if vim.bo.buftype == "terminal" then
        vim.api.nvim_command("startinsert")
        fns.type_keys("<C-c>")
    end
end)


-- delay insert start in neovide to allow animatio to finish
local function start_delayed_insert()
    if vim.g.neovide then
        vim.defer_fn(function()
            vim.api.nvim_command("startinsert")
        end, 100)
    else
        vim.api.nvim_command("startinsert")
    end
end

-- Automatically go to insert mode for new terminals
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        start_delayed_insert()
    end,
})

-- Automatically go to inser mode for existing terminals
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if vim.bo.buftype == "terminal" then
            start_delayed_insert()
        end
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd("setlocal nonumber")
    end,
})

fns.keymap_all(fns.meta_key("j"), function()
    vim.api.nvim_command("stopinsert")
    fns.type_keys("<C-w>j")
end)

fns.keymap_all(fns.meta_key("k"), function()
    vim.api.nvim_command("stopinsert")
    fns.type_keys("<C-w>k")
end)

fns.keymap_all(fns.meta_key("h"), function()
    vim.api.nvim_command("stopinsert")
    fns.type_keys("<C-w>h")
end)

fns.keymap_all(fns.meta_key("l"), function()
    vim.api.nvim_command("stopinsert")
    fns.type_keys("<C-w>l")
end)
