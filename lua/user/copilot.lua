-- copilot accept suggestion. For some setting as plugin setting the keymap is
-- not working in  all files
-- vim.keymap.set("i", "<M-l>", function()
--     print("wat")
--     -- require("copilot.suggestion").accept()
-- end)

return {
    "zbirenbaum/copilot.lua",
    config = function()
        require("copilot").setup({
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = "<M-y>",
                    accept_word = false,
                    accept_line = false,
                    next = "<M-n>",
                    prev = "<M-p>",
                    dismiss = "<M-c>",
                },
            }
        })
    end
}
