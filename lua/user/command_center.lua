local ts_layout = {
    layout_strategy = 'vertical', layout_config = { width = 0.8, height = 0.8 }
}
local tsbuiltin = require("telescope.builtin")

lvim.builtin.which_key.mappings["a"] = {
    "<CMD>CommandCenter<cr>", "Open command center"
}

lvim.builtin.which_key.vmappings["a"] = {
    "<CMD>CommandCenter<cr>", "Open command center"
}

-- local fns = require("user.functions")

-- -- bind <leader>a to visual mode
-- -- vim.keymap.set("v", "<C-a>", function()
-- vim.keymap.set("v", "<Leader>a", function()
--     -- vim.cmd("normal")
--     vim.cmd("CommandCenter")
--     -- vim.cmd("normal gv")
-- end)


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
