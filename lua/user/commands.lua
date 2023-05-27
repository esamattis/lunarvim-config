local fns = require("user.functions")

local full_screen = {
    layout_strategy = 'vertical', layout_config = { width = 0.99, height = 0.99 }
}

local tsbuiltin = require("telescope.builtin")

local source_mode = "normal"


lvim.builtin.which_key.mappings["a"] = {
    function()
        source_mode = "normal"
        vim.api.nvim_input("<esc><CMD>CommandCenter<cr>")
    end, "Open command center"
}


fns.keymap_all("<m-a>", function(mode)
    if mode ~= "normal" then
        vim.api.nvim_command("stopinsert")
    end
    vim.api.nvim_input("<esc><CMD>CommandCenter<cr>")
end)


lvim.builtin.which_key.vmappings["a"] = {
    function()
        source_mode = "visual"
        vim.api.nvim_input("<esc><CMD>CommandCenter<cr>")
    end, "Open command center"
}

local function add_command(cmd)
    local command_name = "My" .. cmd.command_name

    if cmd.command_name == cmd.cmd then
        command_name = cmd.cmd
    end

    vim.api.nvim_create_user_command(command_name, cmd.cmd, { nargs = 0 })

    local spec = {
        cmd  = "<CMD>:" .. command_name .. "<CR>",
        -- desc = cmd.desc .. (cmd.leader and " | <Leader>" .. cmd.leader or ""),
        desc = cmd.desc,
        keys = {}
    }

    if cmd.leader then
        -- lvim.builtin.which_key.mappings[cmd.leader] = {}
        lvim.builtin.which_key.mappings[cmd.leader] = { cmd.cmd, cmd.desc }
        table.insert(spec.keys, {
            "n", "<Leader>" .. cmd.leader,
            { noremap = true, silent = true }
        })
    end

    if cmd.key then
        table.insert(spec.keys, cmd.key)
    end

    require("command_center").add({ spec })
end


add_command({
    desc         = "Close all terminal buffers",
    command_name = "CloseAllTerminalBuffers",
    cmd          = function()
        local confirm = vim.fn.input("Close all terminal buffers (y/n): ")
        if confirm ~= "y" then
            return
        end

        local terminal_bufs = vim.tbl_filter(function(buf)
            return vim.bo[buf].buftype == "terminal"
        end, vim.api.nvim_list_bufs())

        for _, buf in ipairs(terminal_bufs) do
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
})

add_command({
    desc         = "Close all other buffers",
    command_name = "CloseAllOtherBuffers",
    cmd          = function()
        local confirm = vim.fn.input("Close all other buffers (y/n): ")
        if confirm ~= "y" then
            return
        end

        local terminal_bufs = vim.tbl_filter(function(buf)
            local current_buf = vim.fn.bufnr()
            return current_buf ~= buf
        end, vim.api.nvim_list_bufs())

        for _, buf in ipairs(terminal_bufs) do
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
})

add_command({
    desc         = "File Delete",
    command_name = "FileDelete",
    cmd          = function()
        local confirm = vim.fn.input("Delete file (y/n): ")
        if confirm == "y" then
            local file = vim.fn.expand('%')
            fns.delete_current_buffer()
            vim.fn.delete(file)
        end
    end
})

add_command({
    desc         = "File Rename",
    command_name = "FileRename",
    cmd          = function()
        local new_name = vim.fn.input("New name: ")
        vim.cmd("Rename " .. new_name)
    end
})


add_command({
    desc         = "Coloscheme",
    command_name = "Coloscheme",
    cmd          = "Telescope colorscheme",
})

add_command({
    desc         = "LSP Restart",
    command_name = "LspRestart",
    cmd          = "LspRestart",
})

add_command({
    desc         = "LSP Info",
    command_name = "LspInfo",
    cmd          = "LspInfo",
})

add_command({
    desc         = "Fuzzy Current Buffer",
    leader       = "i",
    command_name = "CurrentBufferFuzzyFind",
    -- cmd          = "Telescope current_buffer_fuzzy_find",
    cmd          = function()
        -- tsbuiltin.current_buffer_fuzzy_find(full_screen)
        vim.cmd("Telescope current_buffer_fuzzy_find")
    end,
})

add_command({
    desc         = "Show Key Mappings",
    command_name = "ShowKeyMappings",
    cmd          = function()
        tsbuiltin.keymaps(full_screen)
    end,
})

add_command({
    desc         = "Show Diagnostics",
    leader       = "t",
    command_name = "ShowDiagnostics",
    cmd          = function()
        tsbuiltin.diagnostics(full_screen)
    end,
})

add_command({
    desc         = "Delete Buffer",
    leader       = "d",
    command_name = "DeleteBuffer",
    cmd          = function()
        if vim.bo.buftype == "terminal" then
            vim.cmd("bd!")
        else
            fns.delete_current_buffer()
        end
    end,
})

add_command({
    desc         = "Save all buffers",
    leader       = "w",
    command_name = "SaveAllBuffers",
    key          = { "i", "<C-s>" },
    cmd          = function()
        vim.cmd("wa")
    end,
})


add_command({
    desc         = "Find All References",
    leader       = "R",
    command_name = "FindAllReferences",
    cmd          = function()
        tsbuiltin.lsp_references(full_screen)
    end,
})

add_command({
    desc         = "Go to definition",
    -- leader       = "R",
    command_name = "GoToDefinition",
    key          = { "n", "gd" },
    cmd          = function()
        vim.lsp.buf.definition()
    end,
})

-- add_command({
--     desc         = "Go Back",
--     -- leader       = "R",
--     command_name = "GoToDefinition",
--     key          = { "n", "gb" },
--     cmd          = function()
--         fns.type_keys("<C-o>")
--     end,
-- })

add_command({
    desc         = "Rename Symbol",
    leader       = "r",
    command_name = "RenameSymbol",
    cmd          = function()
        vim.lsp.buf.rename()
    end,
})

add_command({
    desc         = "Show Diagnostics info",
    leader       = "h",
    command_name = "ShowDiagnosticsInfo",
    cmd          = function()
        vim.diagnostic.open_float()
    end,
})


add_command({
    desc         = "Show File Tree",
    -- leader       = "n",
    command_name = "ShowFileTree",
    cmd          = "NvimTreeToggle",
})


add_command({
    desc         = "Copy to system clipboard",
    command_name = "CopyToSystemClipboard",
    key          = { "v", "<M-c>" },
    cmd          = function()
        if vim.api.nvim_get_mode().mode == "v" or vim.api.nvim_get_mode().mode == "V" or vim.api.nvim_get_mode().mode == "^v" then
            vim.cmd("normal y")
            local register_content = vim.fn.getreg('"')
            vim.fn.setreg('+', register_content)
            print("Copied visual selection to system clipboard")
        elseif source_mode == "visual" then
            vim.cmd("normal gvy")
            local register_content = vim.fn.getreg('"')
            vim.fn.setreg('+', register_content)
            print("Copied visual selection to system clipboard")
        else
            local register_content = vim.fn.getreg('"')
            vim.fn.setreg('+', register_content)
            print("Copied default register content to system clipboard")
        end
    end
})

add_command({
    desc         = "Marks",
    command_name = "Marks",
    cmd          = function()
        vim.cmd("Telescope marks")
    end,
})

add_command({
    desc         = "Clear All Marks",
    command_name = "ClearAllMarks",
    cmd          = function()
        vim.cmd("delmarks! | delmarks A-Z0-9")
    end,
})

add_command({
    desc         = "Recent Projects",
    command_name = "RecentProjects",
    cmd          = function()
        vim.cmd("Telescope projects")
    end,
})

add_command({
    desc         = "Code Actions",
    leader       = "c",
    command_name = "CodeActions",
    cmd          = function()
        print("Loading actions...")
        vim.lsp.buf.code_action()
    end,
})

add_command({
    desc         = "Toggle Copilot Active",
    command_name = "ToggleCopilotActive",
    cmd          = "Copilot toggle"
})

add_command({
    desc         = "Open Copilot Panel",
    command_name = "OpenCopilotPanel",
    cmd          = "Copilot panel"
})

add_command({
    desc         = "Git Restore File",
    command_name = "GitRestoreFile",
    cmd          = function()
        local confirm = vim.fn.input("Confirm git restore (y/n): ")
        if confirm == "y" then
            vim.cmd("Gread")
        end
    end
})

add_command({
    desc         = "Git Interactive Restore",
    command_name = "GitInteractiveRestore",
    cmd          = function()
        vim.cmd("terminal git checkout -p %")
    end
})

add_command({
    desc         = "Git Diff",
    command_name = "GitDiff",
    cmd          = function()
        vim.cmd("terminal git diff %")
    end
})

add_command({
    desc         = "Git Commit this file",
    command_name = "GitCommit",
    cmd          = function()
        vim.cmd("terminal git commit -p %")
    end
})

add_command({
    desc         = "Git Commit All",
    command_name = "GitCommit",
    cmd          = function()
        vim.cmd("terminal git c")
    end
})

add_command({
    desc         = "Git Add",
    command_name = "GitAdd",
    cmd          = "Gwrite"
})


add_command({
    desc         = "Find All Files",
    command_name = "FindAllFiles",
    cmd          = "Telescope find_files"
})

add_command({
    desc         = "Clear highlights",
    command_name = "ClearHighlights",
    cmd          = "noh"
})

add_command({
    desc         = "Find Untracked Files with Telescope",
    command_name = "FindUntrackedFiles",
    cmd          = function()
        require("telescope.builtin").find_files({
            find_command = { "git", "ls-files", "--exclude-standard", "--others" },
        })
    end
})

add_command({
    desc         = "Find Git Files from Root",
    command_name = "FindGitFiles",
    leader       = "F",
    cmd          = function()
        require("telescope.builtin").git_files()
    end
})

add_command({
    desc         = "Find Git Files from CWD",
    leader       = "f",
    command_name = "FindGitFilesFromCWD",
    cmd          = function()
        require("telescope.builtin").git_files({
            git_command = { "git", "ls-files", "--exclude-standard", "--cached", vim.fn.getcwd() }
        })
    end
})

add_command({
    desc         = "Edit Snippets For this filetype",
    command_name = "EditSnippets",
    cmd          = function()
        -- open snippet file in ~/.config/nvim/snippets/[filetype].snippets
        vim.cmd("edit " .. vim.fn.stdpath("config") .. "/snippets/" .. vim.bo.filetype .. ".snippets")
    end
})

add_command({
    desc         = "Edit LunarVim Config",
    command_name = "EditLunarVimConfig",
    cmd          = function()
        -- open snippet file in ~/.config/nvim/snippets/[filetype].snippets
        vim.cmd("edit " .. vim.fn.stdpath("config") .. "/config.lua")
    end
})

add_command({
    desc         = "Select Buffer",
    leader       = "b",
    command_name = "SelectBuffer",
    cmd          = function()
        tsbuiltin.buffers({
            initial_mode = "insert",
            sort_mru = true,
            ignore_current_buffer = true
        })
    end
})

add_command({
    desc         = "Select Select Terminal",
    leader       = "B",
    command_name = "SelectTerminal",
    cmd          = function()
        tsbuiltin.buffers({
            initial_mode = "normal",
            sort_mru = true,
            ignore_current_buffer = true,
            default_text = "term://"
        })
    end
})

-- add_command({
--     desc         = "Git revert selected range",
--     command_name = "GitRevertSelectedRange",
--     cmd          = function()
--         vim.cmd("normal gv")
--         vim.cmd("Gitsigns reset_hunk")
--     end
-- })

add_command({
    desc         = "Git reset hunk",
    command_name = "GitResetHunk",
    leader       = "gr",
    cmd          = function()
        vim.cmd("Gitsigns reset_hunk")
    end
})

add_command({
    desc         = "Git next hunk",
    leader       = "gj",
    command_name = "GitNextHunk",
    cmd          = function()
        vim.cmd("Gitsigns next_hunk")
    end
})

add_command({
    desc         = "Git previous hunk",
    leader       = "gk",
    command_name = "GitPreviousHunk",
    cmd          = function()
        vim.cmd("Gitsigns prev_hunk")
    end
})

add_command({
    desc         = "Git preview hunk",
    leader       = "gp",
    command_name = "GitPreviewHunk",
    cmd          = function()
        vim.cmd("Gitsigns preview_hunk")
    end
})

local diagnostics_active = true
add_command({
    desc = "Toggle Virtual Text Diagnostics",
    leader = "E",
    command_name = "ToggleVirtualTextDiagnostics",
    cmd = function()
        if vim.diagnostic.config().virtual_text then
            vim.diagnostic.config({ virtual_text = false, })
        else
            vim.diagnostic.config({ virtual_text = true, })
        end
    end
})

add_command({
    desc = "Go to next diagnostic",
    leader = "e",
    command_name = "GoToNextDiagnostic",
    cmd = function()
        vim.diagnostic.goto_next()
    end
})

add_command({
    desc         = "Live Grep",
    command_name = "LiveGrep",
    cmd          = function()
        tsbuiltin.live_grep(full_screen)
    end
})

add_command({
    desc         = "Live Grep with yanked text",
    command_name = "LiveGrepYankedText",
    cmd          = function()
        tsbuiltin.live_grep({
            default_text = vim.fn.getreg('"'),
        })
    end
})

add_command({
    desc         = "Search and Replace from all files",
    command_name = "SearchReplaceAll",
    cmd          = function()
        require("spectre").open_visual()
    end
})

add_command({
    desc         = "Search and Replace this file",
    command_name = "SearchReplace",
    cmd          = function()
        require("spectre").open_file_search()
    end
})

add_command({
    desc = "Open in GitHub",
    command_name = "OpenInGHFile",
    cmd = function()
        if source_mode == "visual" then
            vim.cmd("normal gv")
            local visual_start = vim.fn.getpos("'<")
            local visual_end = vim.fn.getpos("'>")

            print("Opening lines " .. visual_start[2] .. " to " .. visual_end[2] .. " in GitHub")
            require("openingh").open_file(visual_start[2], visual_end[2])
        else
            print("Opening file in GitHub")
            require("openingh").open_file()
        end

        -- local line = vim.fn.line(".")
        -- print("Opening line " .. line .. " in GitHub")
        -- require("openingh").open_file(line, line)
    end
})

add_command({
    desc         = "Terminal Split",
    command_name = "TerminalSplit",
    leader       = "s",
    key          = { "t", "<M-s>" },
    cmd          = function()
        -- bail if in toggleterm terminal
        local current_buffer = vim.api.nvim_get_current_buf()
        local current_buffer_name = vim.api.nvim_buf_get_name(current_buffer)
        if string.find(current_buffer_name, "toggleterm#") then
            return
        end

        -- if in terminal already, create vertical terminal
        if vim.bo.buftype == "terminal" then
            vim.cmd("vsplit")
            vim.cmd("term")
            return
        end

        -- if a terminal window, exists go to it
        local windows = vim.api.nvim_list_wins()
        for _, window in ipairs(windows) do
            local buffer = vim.api.nvim_win_get_buf(window)
            local buftype = vim.api.nvim_buf_get_option(buffer, "buftype")
            if buftype == "terminal" then
                vim.api.nvim_set_current_win(window)
                return
            end
        end


        -- otherwise create a new window
        vim.cmd("botright split")
        vim.cmd("resize 20")

        -- and open existing terminal from background if it exists
        local buffers = vim.api.nvim_list_bufs()
        for _, buffer in ipairs(buffers) do
            if vim.api.nvim_buf_is_valid(buffer) then
                local buftype = vim.api.nvim_buf_get_option(buffer, "buftype")
                local name = vim.api.nvim_buf_get_name(buffer)

                if buftype == "terminal" and not string.find(name, "#toggleterm#") then
                    vim.cmd("buffer " .. buffer)
                    return
                end
            end
        end

        -- if not start new terminal
        vim.cmd("term")
    end
})


add_command({
    desc         = "Simple Plain Search and Replace",
    command_name = "SimpleSearchReplace",
    cmd          = function()
        local search = vim.fn.input("search> ")
        if search == "" then
            search = vim.fn.getreg('"')
            print("")
            print("Using value from the default register: ")
            print(">> " .. search)
        end
        local replace = vim.fn.input("replace> ")
        fns.search_and_replace_current_buffer(search, replace)
    end,
})

add_command({
    desc         = "Make current file executable",
    command_name = "MakeFileExecutable",
    cmd          = function()
        vim.cmd("silent !chmod +x %")
    end
})

add_command({
    desc         = "Force prettier",
    command_name = "ForcePrettier",

    cmd          = function()
        vim.cmd("silent !prettier --write %")
    end
})

add_command({
    desc         = "Save without formatting",
    command_name = "SaveWithoutFormatting",

    cmd          = function()
        vim.cmd("noautocmd w")
    end
})

add_command({
    desc         = "Select filetype",
    command_name = "SelectFileType",
    cmd          = function()
        vim.cmd("Telescope filetypes")
    end
})
