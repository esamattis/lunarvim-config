local plugins = {
    {
        "folke/todo-comments.nvim",
        event = "BufRead",
        config = function()
            require("todo-comments").setup()
        end,
    },
    { "tpope/vim-surround" },
    { "projekt0n/github-nvim-theme" },
    { "olimorris/onedarkpro.nvim" },
    { "rmehri01/onenord.nvim" },
    { "shaunsingh/nord.nvim" },
    { "nvim-pack/nvim-spectre",     lazy = true },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    { "almo7aya/openingh.nvim", cmd = { "OpenInGHFile" } },
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin"
    -- },
    {
        "mhanberg/output-panel.nvim",
        event = "VeryLazy",
        config = function()
            require("output_panel").setup()
        end
    },
    {
        "tpope/vim-fugitive",
        cmd = { "Gread", "GMove", "Gwrite" },
    },
    {
        "tpope/vim-eunuch",
        cmd = { "Rename", "Delete", "Move", "Mkdir" },
    },
    {
        "mxsdev/nvim-dap-vscode-js",
        cmd = { "InitDebug" },
        dependencies = { "mfussenegger/nvim-dap", "microsoft/vscode-js-debug" },
        main = "dap-vscode-js",
        config = function()
            vim.api.nvim_create_user_command("InitDebug", function()
            end, { nargs = 0 })

            -- local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason")
            -- local lunarvim_path = vim.fn.glob(vim.fn.stdpath("data") .. "/lunarvim")
            local lunarvim_path = os.getenv("LUNARVIM_RUNTIME_DIR")

            require("dap-vscode-js").setup({
                -- debugger_cmd = { "js-debug-adapter" },                                                       -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
                debugger_cmd = { "node",
                    lunarvim_path .. "/site/pack/lazy/opt/vscode-js-debug/dist/src/vsDebugServer.js" },      -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.

                adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
                -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
                -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
                -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
            })

            local dap = require('dap')
            dap.configurations.typescript = {
                {
                    type                     = 'pwa-node',
                    request                  = 'launch',
                    name                     = 'Launch Test Program (pwa-node with vitest)',
                    cwd                      = vim.fn.getcwd(),
                    program                  = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
                    args                     = { '--inspect-brk', '--threads', 'false', 'run', '${file}' },
                    autoAttachChildProcesses = true,
                    smartStep                = true,
                    console                  = 'integratedTerminal',
                    skipFiles                = { '<node_internals>/**', 'node_modules/**' },
                },
            }
        end

    },
    {
        "microsoft/vscode-js-debug",
        lazy = true,
        build = "npm ci && npx gulp vsDebugServerBundle",
    },
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        cmd = { "Trouble" },
        config = function()
            require("trouble").setup {
                auto_close = true,
                auto_preview = false
            }
        end
    },
    {
        'nmac427/guess-indent.nvim',
        config = function() require('guess-indent').setup {} end,
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            -- This is your opts table
            require("telescope").setup {
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {}
                    }
                }
            }
            require("telescope").load_extension("ui-select")
        end
    }

}

if vim.g.neovide then
    table.insert(plugins, {
        "tenxsoydev/size-matters.nvim",
        cmd = { "FontSizeUp", "FontSizeDown", "FontReset" },
        config = function()
            require("size-matters").setup {
                default_mappings = false
            }
        end
    })
end


return plugins
