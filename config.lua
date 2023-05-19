local diagnostics_active = true
local function toggle_diagnostics()
    if diagnostics_active then
        vim.diagnostic.config({
            virtual_text = false,
        })
        diagnostics_active = false
    else
        vim.diagnostic.config({
            virtual_text = true,
        })
        diagnostics_active = true
    end
end

local wat = require("user.options")




lvim.plugins = {
    require("user.command_center"),
    require("user.copilot"),
    require("user.yanky"),
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

require("user.terminal")


-- if ITERM_PROFILE is set to "dark" then use the dark theme
if os.getenv("ITERM_PROFILE") == "Light" then
    lvim.colorscheme = "catppuccin-latte"
end


vim.api.nvim_create_user_command(
    'ToggleDiagnostic',
    toggle_diagnostics,

    { nargs = 0 }
)

lvim.builtin.which_key.mappings["E"] = {
    toggle_diagnostics, "Toggle diagnostics virtual text"
}

lvim.builtin.which_key.mappings["r"] = {
    function()
        -- rename with lsp action
        vim.lsp.buf.rename()
    end, "Rename symbol"
}


-- always exit vim no matter what with <m-x>
local function always_exit()
    vim.api.nvim_command("stopinsert")
    vim.api.nvim_command("qa!")
end
vim.keymap.set("i", "<m-x>", always_exit)
vim.keymap.set("n", "<m-x>", always_exit)
vim.keymap.set("t", "<m-x>", always_exit)


-- split resize
vim.keymap.set("n", "<C-j>", "2<c-w>+")
vim.keymap.set("n", "<C-k>", "2<c-w>-")
vim.keymap.set("n", "<C-l>", "10<c-w>>")
vim.keymap.set("n", "<C-h>", "10<c-w><")


-- insert tab character always
vim.keymap.set("i", "<S-Tab>", "<C-V><Tab>")



-- old leader
vim.keymap.set("n", ",", function()
    print("not in use!!!!!")
end)



lvim.keys.normal_mode["<Leader>w"] = ":wa<cr>"


-- join lines with above
lvim.lsp.buffer_mappings.normal_mode.K = false
lvim.keys.normal_mode["K"] = "kJ"


--lvim.keys.insert_mode["<M-2>"] = "@"

lvim.keys.normal_mode["<Leader>d"] = ":bd!<cr>"
lvim.keys.normal_mode["<Leader>o"] = ":only<cr>"

lvim.keys.normal_mode["gh"] = ":lua vim.lsp.buf.hover()<cr>"





-- go back from jump to definition. Does not work.
lvim.keys.normal_mode["gb"] = "<c-o>"

lvim.keys.normal_mode["<Leader>q"] = ":q<cr>"
lvim.keys.insert_mode["jj"] = "<esc>"

-- move to start and end of the line
lvim.keys.normal_mode["ö"] = "^"
lvim.keys.normal_mode["ä"] = "$"
lvim.keys.visual_mode["ö"] = "^"
lvim.keys.visual_mode["ä"] = "$"


-- quick search with word under the cursor
vim.keymap.set("n", "<space><space>", "*N")


local tsbuiltin = require("telescope.builtin")

lvim.builtin.which_key.mappings["f"] = {
    function()
        tsbuiltin.git_files({
            git_command = { "git", "ls-files", "--exclude-standard", "--cached", vim.fn.getcwd() }
        }
        )
    end, "Find git files from CWD"
}

lvim.builtin.which_key.mappings["F"] = {
    function()
        tsbuiltin.git_files()
    end, "Find git files from Root"
}




lvim.builtin.which_key.mappings["b"] = {
    function()
        tsbuiltin.buffers({
            initial_mode = "insert",
        })
    end, "Select buffer"
}

lvim.builtin.which_key.mappings["c"] = {
    function()
        -- vim.lsp.buf.code_action()
        vim.api.nvim_command("CodeActionMenu")
    end, "Quick Fix"
}

lvim.builtin.which_key.mappings["e"] = {
    function()
        vim.diagnostic.goto_next()
    end, "Go no next diagnostic"
}





local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
    {
        exe = "eslint",
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
    },
}


local null_ls = require("null-ls")

null_ls.setup {
    sources = {
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.prettier,
    },
}


-- toggle recent buffers
vim.keymap.set('n', ',m',
    function()
        tsbuiltin.buffers({
            sort_mru = true,
            ignore_current_buffer = true
        })
    end)
