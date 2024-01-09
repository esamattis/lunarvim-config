reload("user.options")
local fns = require("user.functions")

lvim.builtin.bufferline.active = false
lvim.builtin.alpha.active = false

lvim.lsp.buffer_mappings.normal_mode.gd = nil
lvim.lsp.buffer_mappings.normal_mode.gD = nil


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
require("user.project_chdir")

-- breaks focus on terminal
-- require("user.autoread")


if vim.g.neovide then
    local out = vim.fn.systemlist("defaults read -g AppleInterfaceStyle")[1]

    if out == "Dark" then
        lvim.colorscheme = "tokyonight"
    else
        lvim.colorscheme = "onenord-light"
    end



    vim.opt.linespace = 5
    vim.g.neovide_scale_factor = 1.0
    -- vim.o.guifont = "SauceCodePro Nerd Font:h14"
    -- vim.o.guifont = "FantasqueSansM Nerd Font:h16"
    vim.o.guifont = "UbuntuMono Nerd Font Mono:h14"
    -- vim.o.guifont = "Comic Mono:h14"
    -- vim.o.guifont = "FiraMono Nerd Font Mono:h14"
    vim.g.neovide_remember_window_size = true
    -- vim.g.neovide_cursor_vfx_mode = "pixiedust"
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_cursor_animation_length = 0.07
    vim.g.neovide_cursor_trail_size = 0.3
    vim.g.neovide_cursor_animate_command_line = true
    -- vim.g.neovide_input_macos_alt_is_meta = true

    vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
    vim.keymap.set('x', '<D-c>', '"+ygv')  -- Copy
    vim.keymap.set('n', '<D-v>', '"+P')    -- Paste normal mode
    vim.keymap.set('x', '<D-v>', 'x"+P')   -- Paste visual mode
    vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
    vim.keymap.set('i', '<D-v>', '<C-R>+', { noremap = true, silent = true }) -- Paste insert mode

    -- paste in terminal mode
    vim.keymap.set('t', '<D-v>', function()
        fns.type_keys("<C-\\><C-n>")
        -- what, type keys is async?
        vim.defer_fn(function()
            vim.cmd('normal! "+Pi')
        end, 100)
    end, { noremap = true, silent = true })
else
    if os.getenv("ITERM_PROFILE") == "Light" then
        -- if ITERM_PROFILE is set to "dark" then use the dark theme
        lvim.colorscheme = "onenord-light"
    else
        lvim.colorscheme = "tokyonight"
    end
end


-- vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('!', '<D-v>', '"+P', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('t', '<D-v>', '"+P', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('v', '<D-v>', '"+P', { noremap = true, silent = true })



-- always exit vim no matter what with <m-x>
fns.keymap_all("<m-x>", function()
    vim.api.nvim_command("stopinsert")
    vim.api.nvim_command("qa!")
end)

-- split resize
fns.keymap_all("<S-C-j>", "5<c-w>+")
fns.keymap_all("<S-C-k>", "5<c-w>-")
fns.keymap_all("<S-C-l>", "10<c-w>>")
fns.keymap_all("<S-C-h>", "10<c-w><")

-- fast movement with ctrl
fns.keymap_all("<C-j>", ")")
fns.keymap_all("<C-k>", "(")
fns.keymap_all("<C-l>", "e")
fns.keymap_all("<C-h>", "b")



-- insert tab character always
vim.keymap.set("i", "<S-Tab>", "<C-V><Tab>")


-- Aways start insert mode with i and a in visual mode
vim.keymap.set("x", "i", "<esc>i")
vim.keymap.set("x", "a", "<esc>a")

vim.keymap.set("x", "<space>", "<esc>")

-- Always send insert mode enter in visual and normal modes
vim.keymap.set("x", "<enter>", "<esc>i<enter>")
vim.keymap.set("n", "<enter>", "i<enter>")

-- Always clear with backspace
vim.keymap.set("x", "<bs>", "<esc>i<bs>")
vim.keymap.set("n", "<bs>", "i<bs>")

-- Copy to system clipboard
vim.keymap.set("x", "<space>y", '"+y')
vim.keymap.set("x", "<space>c", '"+y')

-- old leader
vim.keymap.set("n", ",", function()
    print("not in use!!!!!")
end)




-- join current line with the above line
lvim.lsp.buffer_mappings.normal_mode.K = nil
vim.keymap.set("n", "K", "kJ", { noremap = true, silent = true })

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

if vim.fn.argc() == 0 and vim.g.neovide then
    vim.defer_fn(
        function()
            vim.cmd('Telescope projects')
        end,
        0
    )
end
