local fns = require("user.functions")
lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.js", "*.ts", "*.tsx", "*.php", "*.json", "*.php", "*.rs", "*.md" }

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "prettier", filetypes = { "php" } },
}


-- vim.opt.mousefocus = false
-- disable mouse
-- vim.opt.mouse = ""
vim.opt.scrolloff = 0


vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true

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
--


vim.diagnostic.config({ virtual_text = false, })

vim.opt.autoread = true


vim.opt.showtabline = 0

vim.opt.iskeyword:append("-")
