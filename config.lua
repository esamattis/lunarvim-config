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


vim.api.nvim_create_user_command(
    "Test",
    wat.test,
    { nargs = 0 }
)


lvim.plugins = {
    require("user.command_center"),
    {
        "gbprod/yanky.nvim",
        config = function()
            require("yanky").setup({
                highlight = {
                    on_put = true,
                    on_yank = true,
                    timer = 200,
                },
            })
        end
    },
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
        "zbirenbaum/copilot.lua",
        config = function()
            require("copilot").setup({
                suggestion = {
                    auto_trigger = true,
                    keymap = {
                        accept = "<M-m>",
                        accept_word = false,
                        accept_line = false,
                        next = "<M-n>",
                        prev = "<M-p>",
                        dismiss = "<M-c>",
                    },
                }
            })
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

-- exit terminal insert mode
vim.keymap.set({ "t", "x" }, "<m-o>", "<C-\\><C-n>")

lvim.builtin.terminal.open_mapping = "<m-y>"


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


-- vim.keymap.set({ "t", "x" }, "<m-k>", function()
--     vim.api.nvim_command("stopinsert")
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>k", true, true, true), "n", true)
-- end)





vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleBackward)")


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


-- copilot accept suggestion. For some setting as plugin setting the keymap is
-- not working in  all files
vim.keymap.set("i", "<M-l>", function()
    require("copilot.suggestion").accept()
end)


-- old leader
vim.keymap.set("n", ",", function()
    print("not in use!!!!!")
end)



vim.opt.whichwrap = ""

-- bash like completion
vim.opt.wildmode = "longest,list"

-- disable system clipboad sync
vim.opt.clipboard = ""

-- display tab characters
vim.opt.list = true


-- Do not change endof file ever to avoid useless git diffs
vim.opt.fixendofline = false

-- lvim.leader = "<Space>"





lvim.keys.normal_mode["<Leader>w"] = ":wa<cr>"


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



-- lvim.keys.insert_mode["<C-,>"] = function()
--     print("wat2")
--     require("copilot.suggestion").accept()
-- end

-- vim.keymap.set({ "i", "x" }, "<C-ö>", function()
--     require("copilot.suggestion").accept()
-- end)



-- lvim.builtin.which_key.mappings["c"] = {
--     function()
--         require("copilot.panel").next()
--     end, "Github Copilot Next"
-- }

-- lvim.builtin.which_key.mappings["cp"] = {
--     function()
--         require("copilot.panel").open()
--     end, "Github Copilot"
-- }

-- lvim.keys.normal_mode["<Leader>f"] = false
-- lvim.keys.normal_mode["<Leader>F"] = ":lua vim.lsp.buf.code_action()<CR>"
--
-- lvim.keys.normal_mode["<leader>m"] = ":Telescope buffers<cr>"
-- lvim.keys.normal_mode["<leader>n"] = ":Telescope find_files<cr>"
--
--
--

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


-- quick search
vim.keymap.set("n", "<space><space>", "*N")


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

local ts_layout = {
    layout_strategy = 'vertical', layout_config = { width = 0.8, height = 0.8 }
}



-- vim.keymap.set({ "n", "x" }, "<leader>E", function()
--     vim.diagnostic.goto_next()
-- end)


-- vim.keymap.set({ "n", "x" }, "<leader>E", ":Error<cr>")

-- vim.keymap.set({ "i", "x" }, "<leader>c", function()
--     require("copilot.panel").open()
-- end)

-- vim.keymap.set({ "i", "x" }, "<leader>E", ":Error<cr>")
--
--
--
vim.api.nvim_create_user_command(
    'FindReferences',
    function()
        tsbuiltin.lsp_references(ts_layout)
    end,
    { nargs = 0 }
)


lvim.builtin.which_key.mappings["R"] = {
    function()
        tsbuiltin.lsp_references(ts_layout)
    end, "Find References"
}

vim.api.nvim_create_user_command(
    'Error',
    function()
        tsbuiltin.diagnostic.goto_next()
    end,
    { nargs = 0 }
)

vim.api.nvim_create_user_command(
    'ErrorList',
    function()
        tsbuiltin.diagnostics(ts_layout)
    end,
    { nargs = 0 }
)

lvim.builtin.which_key.mappings["t"] = {
    function()
        -- require("trouble").toggle()
        tsbuiltin.diagnostics(ts_layout)
    end, "Show diagnostics"
}

lvim.builtin.which_key.mappings["h"] = {
    function()
        vim.diagnostic.open_float()
    end, "Show diagnostics info"
}





-- Copy default register to system clipboard
-- vim.api.nvim_create_user_command(
--     'ToClipboard',
--     'let @+=@"',
--     { nargs = 0 }
-- )

-- vim.api.nvim_create_user_command(
--     'Files',
--     function()
--         vim.api.nvim_command("NvimTreeToggle")
--     end,
--     { nargs = 0 }
-- )

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        print("setting insert mode for new termal")
        vim.api.nvim_command("startinsert")
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if vim.bo.buftype == "terminal" then
            print("setting insert mode for existing termal")
            vim.api.nvim_command("startinsert")
        end
    end,
})



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
