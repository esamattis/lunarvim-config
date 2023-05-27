local fns = require("user.functions")

-- Better project root detection for pnpm monorepos
lvim.builtin.project.manual_mode = true

vim.api.nvim_create_user_command("SmartRoot", function()
    local patterns = { ".git", "package.json" }

    if fns.is_pnpm_monorepo() then
        patterns = { ">packages", }
    end

    require("project_nvim").setup {
        manual_mode = true,
        patterns = patterns,
        detection_methods = { "pattern" },
        silent_chdir = true,
    }

    vim.cmd("ProjectRoot")
end, { nargs = 0 })

-- https://github.com/ahmedkhalf/project.nvim/blob/8c6bad7d22eef1b71144b401c9f74ed01526a4fb/lua/project_nvim/project.lua#LL260C40-L260C68
vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter * ++nested" }, {
    callback = function()
        vim.cmd("SmartRoot")
    end,
})

-- fns.keymap_all("<D-p>", function()
--     vim.cmd("Telescope projects")
-- end)
