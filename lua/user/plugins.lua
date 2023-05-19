return {
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
    { "shaunsingh/nord.nvim" },
    {
        "catppuccin/nvim",
        name = "catppuccin"
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
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    }

}
