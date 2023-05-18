lvim.plugins = {
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
        "tpope/vim-fugitive",
        cmd = { "Gread" },
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


vim.g.diagnostics_active = true
local function toggle_diagnostics()
    if vim.g.diagnostics_active then
        vim.diagnostic.config({
            virtual_text = false,
        })
        vim.g.diagnostics_active = false
    else
        vim.diagnostic.config({
            virtual_text = true,
        })
        vim.g.diagnostics_active = true
    end
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


-- split resize
vim.keymap.set("n", "<C-j>", "2<c-w>+")
vim.keymap.set("n", "<C-k>", "2<c-w>-")
vim.keymap.set("n", "<C-l>", "10<c-w>>")
vim.keymap.set("n", "<C-h>", "10<c-w><")


vim.keymap.set("i", "<S-Tab>", "<C-V><Tab>")


-- does not work
vim.keymap.set({ "n", "x" }, "K", "kJ")


vim.opt.whichwrap = ""

-- bash like completion
vim.opt.wildmode = "longest,list"

-- disable system clipboad sync
vim.opt.clipboard = ""

-- display tab characters
vim.opt.list = true

lvim.leader = ","

lvim.format_on_save.enabled = true




lvim.keys.normal_mode["<Leader>w"] = ":wa<cr>"
lvim.keys.insert_mode["<Leader>w"] = "<esc>:wa<cr>"


--lvim.keys.insert_mode["<M-2>"] = "@"

lvim.keys.normal_mode["<Leader>d"] = ":bd!<cr>"
lvim.keys.normal_mode["<Leader>o"] = ":only<cr>"

lvim.keys.normal_mode["gh"] = ":lua vim.lsp.buf.hover()<cr>"


-- quick search
lvim.keys.normal_mode["<space>"] = "*N"



-- go back from jump to definition. Does not work.
lvim.keys.normal_mode["gb"] = "<c-o>"

lvim.keys.insert_mode["<Leader>q"] = "<esc>:q<cr>"
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

local tsbuiltin = require("telescope.builtin")

lvim.builtin.which_key.mappings["n"] = {
    function()
        tsbuiltin.find_files({ cwd = vim.fn.getcwd() })
    end, "Find git files from CWD"
}

lvim.builtin.which_key.mappings["m"] = {
    function()
        tsbuiltin.buffers()
    end, "Select buffer"
}

lvim.builtin.which_key.mappings["f"] = {
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


lvim.builtin.which_key.mappings["t"] = {
    function()
        require("trouble").toggle()
    end, "Toggle trouble"
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
vim.api.nvim_create_user_command(
    'Error',
    function()
        vim.diagnostic.goto_next()
    end,
    { nargs = 0 }
)

vim.api.nvim_create_user_command(
    'QQ',
    "qa!",
    { nargs = 0 }
)

-- Copy default register to system clipboard
vim.api.nvim_create_user_command(
    'ToClipboard',
    'let @+=@"',
    { nargs = 0 }
)

vim.api.nvim_create_user_command(
    'Files',
    function()
        vim.api.nvim_command("NvimTreeToggle")
    end,
    { nargs = 0 }
)

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


vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.number = true

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
