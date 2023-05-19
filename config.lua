reload("user.options")


lvim.plugins = {
    require("user.command_center"),
    require("user.copilot"),
    require("user.yanky"),
}

local plugins = require("user.plugins")
for _, plugin in ipairs(plugins) do
    lvim.plugins[#lvim.plugins + 1] = plugin
end

require("user.terminal")
require("user.commands")


-- if ITERM_PROFILE is set to "dark" then use the dark theme
if os.getenv("ITERM_PROFILE") == "Light" then
    lvim.colorscheme = "catppuccin-latte"
end



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
        require("telescope.builtin").buffers({
            sort_mru = true,
            ignore_current_buffer = true
        })
    end)
