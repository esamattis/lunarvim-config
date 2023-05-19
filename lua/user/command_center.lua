local ts_layout = {
    layout_strategy = 'vertical', layout_config = { width = 0.8, height = 0.8 }
}
local tsbuiltin = require("telescope.builtin")

lvim.builtin.which_key.mappings["a"] = {
    "<CMD>CommandCenter<cr>", "Open command center"
}


local fns = require("user.functions")

-- bind <leader>a to visual mode
vim.keymap.set("v", "<C-a>", function()
    print("wat: " .. fns.get_visual_selection())
end)

vim.api.nvim_create_user_command(
    'ErrorList',
    function()
        tsbuiltin.diagnostics(ts_layout)
    end,
    { nargs = 0 }
)

return {
    "FeiyouG/command_center.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = { "CommandCenter" },
    config = function()
        vim.api.nvim_create_user_command(
            "CommandCenter",
            "Telescope command_center",
            { nargs = 0 }
        )
        require("telescope").load_extension("command_center")
        require("telescope").setup {
            extensions = {
                command_center = {
                }
            }
        }
    end
}
