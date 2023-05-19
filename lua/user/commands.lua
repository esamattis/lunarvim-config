local function add_command(cmd)
    if cmd.leader then
        lvim.builtin.which_key.mappings[cmd.leader] = {
            cmd.cmd, cmd.desc
        }
    end

    local command_name = "My" .. cmd.command_name

    vim.api.nvim_create_user_command(command_name, cmd.cmd, { nargs = 0 })

    require("command_center").add({
        {
            cmd  = "<CMD>:" .. command_name .. "<CR>",
            desc = cmd.desc .. (cmd.leader and " | <Leader>" .. cmd.leader or ""),
        }
    })
end

local ts_layout = {
    layout_strategy = 'vertical', layout_config = { width = 0.9, height = 0.9 }
}
local tsbuiltin = require("telescope.builtin")



add_command({
    desc         = "Search inside current buffer",
    leader       = "z",
    command_name = "CurrentBufferFuzzyFind",
    cmd          = "Telescope current_buffer_fuzzy_find",
})

add_command({
    desc         = "Show Diagnostics",
    leader       = "t",
    command_name = "ShowDiagnostics",
    cmd          = function()
        tsbuiltin.diagnostics(ts_layout)
    end,
})



add_command({
    desc         = "Find All References",
    leader       = "R",
    command_name = "FindAllReferences",
    cmd          = function()
        tsbuiltin.lsp_references(ts_layout)
    end,
})

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
    desc         = "Copy default register to system clipboard",
    command_name = "CopyDefaultRegisterToSystemClipboard",
    cmd          = function()
        local register_content = vim.fn.getreg('"')
        vim.fn.setreg('+', register_content)
    end,
})

add_command({
    desc         = "Quick Fix",
    leader       = "c",
    command_name = "QuickFix",
    cmd          = "CodeActionMenu"
})

add_command({
    desc         = "Toggle Copilot",
    command_name = "ToggleCopilot",
    cmd          = "Copilot toggle"
})

add_command({
    desc         = "Git Restore",
    command_name = "GitRestore",
    cmd          = "Gread"
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
    desc         = "Edit snippets",
    command_name = "EditSnippets",
    cmd          = function()
        -- open snippet file in ~/.config/nvim/snippets/[filetype].snippets
        vim.cmd("edit " .. vim.fn.stdpath("config") .. "/snippets/" .. vim.bo.filetype .. ".snippets")
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

local diagnostics_active = true
add_command({
    desc = "Toggle Virtual Text Diagnostics",
    leader = "E",
    command_name = "ToggleVirtualTextDiagnostics",
    cmd = function()
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
        tsbuiltin.live_grep(ts_layout)
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
