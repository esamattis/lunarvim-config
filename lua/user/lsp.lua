local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
    {
        exe = "eslint",
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
    },
}


local null_ls = require("null-ls")

null_ls.setup {
    root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git", "node_modules"),
    sources = {
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.prettier,
    },
}
