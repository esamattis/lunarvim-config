reload("user.options")
local fns = require("user.functions")

lvim.builtin.bufferline.active = false
lvim.builtin.alpha.active = false

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
require("user.lsp")
require("user.buffer_toggle")


-- if ITERM_PROFILE is set to "dark" then use the dark theme
if os.getenv("ITERM_PROFILE") == "Light" then
    lvim.colorscheme = "onenord-light"
else
    lvim.colorscheme = "tokyonight"
end

if vim.g.neovide then
    vim.opt.linespace = 0
    vim.g.neovide_scale_factor = 1.0
    vim.o.guifont = "SauceCodePro Nerd Font:h14"
    vim.g.neovide_remember_window_size = true
    -- vim.g.neovide_input_macos_alt_is_meta = true


    vim.keymap.set('n', '<D-s>', ':w<CR>')      -- Save
    vim.keymap.set('v', '<D-c>', '"+y')         -- Copy
    vim.keymap.set('n', '<D-v>', '"+P')         -- Paste normal mode
    vim.keymap.set('v', '<D-v>', '"+P')         -- Paste visual mode
    vim.keymap.set('c', '<D-v>', '<C-R>+')      -- Paste command mode
    vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
    vim.g.neovide_cursor_vfx_mode = "pixiedust"
end

vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })



-- always exit vim no matter what with <m-x>
fns.keymap_all("<m-x>", function()
    vim.api.nvim_command("stopinsert")
    vim.api.nvim_command("qa!")
end)

-- split resize
vim.keymap.set("n", "<C-j>", "5<c-w>+")
vim.keymap.set("n", "<C-k>", "5<c-w>-")
vim.keymap.set("n", "<C-l>", "10<c-w>>")
vim.keymap.set("n", "<C-h>", "10<c-w><")


-- insert tab character always
vim.keymap.set("i", "<S-Tab>", "<C-V><Tab>")



-- Better project root detection for pnpm monorepos
-- if fns.is_pnpm_monorepo() then
lvim.builtin.project.patterns = { ">packages", ".git", "package.json" }
-- end
lvim.builtin.project.manual_mode = true

-- old leader
vim.keymap.set("n", ",", function()
    print("not in use!!!!!")
end)




-- join lines with above
lvim.lsp.buffer_mappings.normal_mode.K = false
lvim.keys.normal_mode["K"] = "kJ"



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

lvim.builtin.which_key.mappings["j"] = {
    "'", "Jump to mark"
}


fns.keymap_all("<D-+>", function()
    vim.cmd("FontSizeUp 1")
end)

fns.keymap_all("<D-->", function()
    vim.cmd("FontSizeDown 1")
end)

fns.keymap_all("<D-0>", function()
    vim.cmd("FontReset")
end)

-- if vim.fn.argc() == 0 and vim.g.neovide then
--     vim.defer_fn(
--         function()
--             vim.cmd('Telescope projects')
--         end,
--         0
--     )
-- end
