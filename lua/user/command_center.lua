local ts_layout = {
    layout_strategy = 'vertical', layout_config = { width = 0.8, height = 0.8 }
}
local tsbuiltin = require("telescope.builtin")

lvim.builtin.which_key.mappings["h"] = {
    function()
        vim.diagnostic.open_float()
    end, "Show diagnostics info"
}


vim.api.nvim_create_user_command(
    'ShowDiagnostics',
    function()
        tsbuiltin.diagnostics(ts_layout)
    end,
    { nargs = 0 }
)


lvim.builtin.which_key.mappings["t"] = {
    "<CMD>ShowDiagnostics<cr>", "Show diagnostics"
}

-- open command center
lvim.builtin.which_key.mappings["a"] = {
    "<CMD>CommandCenter<cr>", "Open command center"
}

vim.api.nvim_create_user_command(
    'FindReferences',
    function()
        tsbuiltin.lsp_references(ts_layout)
    end,
    { nargs = 0 }
)

lvim.builtin.which_key.mappings["R"] = {
    "<CMD>FindReferences<cr>", "Find References"
}

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
        require("command_center").add({
            {
                desc = "Search inside current buffer",
                cmd = "<CMD>Telescope current_buffer_fuzzy_find<CR>",
            },
            {
                desc = "Show file tree",
                cmd = "<CMD>NvimTreeToggle<CR>",
            },
            {
                desc = "Copy default register to system clipboard",
                cmd  = function()
                    local register_content = vim.fn.getreg('"')
                    vim.fn.setreg('+', register_content)
                end
            },
            {
                desc = "Show all errors",
                cmd  = "<CMD>ErrorList<cr>",
            },
            {
                desc = "Find All References | <leader>R",
                cmd  = "<CMD>FindReferences<cr>",
            },
            {
                desc = "Quick Fix",
                cmd  = "<CMD>CodeActionMenu<cr>",
            },
            {
                desc = "Toggle Copilot",
                cmd  = "<CMD>Copilot toggle<CR>"
            },
            -- {
            --     desc = "Toggle Diagnostic",
            --     cmd  = toggle_diagnostics,
            -- },
            {
                desc = "Show Diagnostics | <leader>t",
                cmd  = "<CMD>ShowDiagnostics<cr>",
            },
            {
                desc = "Git restore",
                cmd  = "<CMD>Gread<cr>",
            },
            {
                desc = "Find All Files",
                cmd  = "<CMD>Telescope find_files<CR>"
            },
            {
                desc = "Find Untracked Files with Telescope",
                cmd = function()
                    require("telescope.builtin").find_files({
                        find_command = { "git", "ls-files", "--exclude-standard", "--others" },
                    })
                end
            }
        })
    end
}
