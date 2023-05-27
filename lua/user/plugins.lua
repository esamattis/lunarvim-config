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
    {
        "nvim-treesitter/nvim-treesitter-context",

        config = function()
            require("treesitter-context").setup {
                enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
                throttle = true, -- Throttles plugin updates (may improve performance)
                max_lines = 3,   -- How many lines the window should span. Values <= 0 mean no limit.
                patterns = {
                    -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                    -- For all filetypes
                    -- Note that setting an entry here replaces all other patterns for this entry.
                    -- By setting the 'default' entry below, you can control which nodes you want to
                    -- appear in the context window.
                    default = {
                        'class',
                        'function',
                        'method',
                        'test',
                    },
                },
            }
        end
    },
    { "nvim-pack/nvim-spectre", lazy = true },
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
    -- {
    --     'weilbith/nvim-code-action-menu',
    --     cmd = 'CodeActionMenu',
    -- }

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

-- if vim.g.neovide or vim.g.goneovim or vim.g.nvui or vim.g.gnvim then
--     require("size-matters").setup({
--         default_mappings = true,
--     })
-- end
--

return plugins
