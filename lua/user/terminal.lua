-- start pop terminal
lvim.builtin.terminal.open_mapping = "<m-y>"

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

local function bind_navigation(key)
    vim.keymap.set({ "t", "x" }, "<m-" .. key .. ">", function()
        vim.api.nvim_command("stopinsert")
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>" .. key, true, true, true), "n", true)
    end)

    vim.keymap.set({ "i", "x" }, "<m-" .. key .. ">", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>" .. key, true, true, true), "n", true)
    end)
    vim.keymap.set({ "n", "x" }, "<m-" .. key .. ">", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>" .. key, true, true, true), "n", true)
    end)
end

bind_navigation("h")
bind_navigation("j")
bind_navigation("k")
bind_navigation("l")
