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
end




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
if fns.is_pnpm_monorepo() then
    lvim.builtin.project.patterns = { ">packages", }
end

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

-- maximize in terminal mode
vim.keymap.set({ "t", "x" }, "<m-o>", "<C-\\><C-n><C-w>_i")
vim.keymap.set({ "n", "x" }, "<m-o>", "<C-w>_")
vim.keymap.set({ "i", "x" }, "<m-o>", "<Esc><C-w>_i")

-- balance splits
vim.keymap.set({ "t", "x" }, "<m-O>", "<C-\\><C-n><C-w>=i")
vim.keymap.set({ "n", "x" }, "<m-O>", "<C-w>=")
vim.keymap.set({ "i", "x" }, "<m-O>", "<esc><C-w>=i")
vim.keymap.set({ "v", "x" }, "<m-O>", "<C-w>=")



-- quick search with word under the cursor
vim.keymap.set("n", "<space><space>", "*N")

lvim.builtin.which_key.mappings["j"] = {
    "'", "Jump to mark"
}
