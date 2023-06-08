local fns = {}

function fns.type_keys(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), 'n', true)
end

function fns.get_visual_selection()
    -- Yank current visual selection into the 'v' register
    --
    -- Note that this makes no effort to preserve this register
    vim.cmd('noau normal! "vy"')

    return vim.fn.getreg('v')
end

function fns.remove_value(target, value)
    for i, v in ipairs(target) do
        if v == value then
            table.remove(target, i)
            return
        end
    end
end

function fns.concat_tables(a, b)
    local result = {}

    for _, v in ipairs(a) do
        table.insert(result, v)
    end

    for _, v in ipairs(b) do
        table.insert(result, v)
    end

    return result
end

local function plain_replace(text, search, replacement)
    local result = ""
    local index = 1
    while index <= string.len(text) do
        local match_start, match_end = string.find(text, search, index, true)
        if match_start and match_end then
            result = result .. string.sub(text, index, match_start - 1) .. replacement
            index = match_end + 1
        else
            result = result .. string.sub(text, index)
            break
        end
    end
    return result
end


function fns.search_and_replace_current_buffer(old_string, new_string)
    -- Get the current buffer number
    local bufnr = vim.api.nvim_get_current_buf()

    -- Get the buffer lines
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Replace old_string with new_string in every line
    for i, line in ipairs(lines) do
        -- lines[i] = line:gsub(old_string, new_string)
        lines[i] = plain_replace(line, old_string, new_string)
    end

    -- Set the buffer lines with the modified content
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

-- get the previous buffer. Get file if the current buffer is a file and
-- terminal if the current buffer is a terminal
function fns.get_previous_buffer()
    local buffers = vim.api.nvim_list_bufs()

    table.sort(buffers, function(a, b)
        return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end)

    for _, buf in ipairs(buffers) do
        if buf ~= vim.fn.bufnr() then
            if vim.bo.buftype == "terminal" then
                if fns.is_terminal_buffer(buf) then
                    return buf
                end
            else
                if fns.is_file_buffer(buf) then
                    return buf
                end
            end
        end
    end
end

-- delete current buffer without closing the window
function fns.delete_current_buffer()
    local current_buffer = vim.api.nvim_get_current_buf()

    local buf = fns.get_previous_buffer()
    if buf then
        vim.api.nvim_command("buffer " .. buf)
        vim.cmd("bd " .. current_buffer)
    else
        fns.notify("No previous buffer, cannot delete")
    end
end

function fns.is_pnpm_monorepo()
    local root_dir = require("null-ls.utils").root_pattern("pnpm-lock.yaml")
    local root = root_dir(vim.fn.expand("%:p:h"))

    if root == nil then
        return false
    end

    local pnpm_lock = root .. "/pnpm-lock.yaml"
    local pnpm_lock_exists = vim.fn.filereadable(pnpm_lock) == 1

    return pnpm_lock_exists
end

-- Add key binding for all modes
function fns.keymap_all(key, callback)
    if type(callback) == "string" then
        vim.keymap.set({ "t", "x" }, key, callback)
        vim.keymap.set({ "i", "x" }, key, callback)
        vim.keymap.set({ "n", "x" }, key, callback)
        vim.keymap.set({ "v", "x" }, key, callback)
        return
    end


    vim.keymap.set("t", key, function()
        callback("terminal")
    end)

    vim.keymap.set("i", key, function()
        callback("insert")
    end)

    vim.keymap.set("n", key, function()
        callback("normal")
    end)

    vim.keymap.set("x", key, function()
        callback("visual")
    end)
end

function fns.meta_key(key)
    if vim.g.neovide then
        return "<S-D-" .. key .. ">"
    else
        return "<M-" .. key .. ">"
    end
end

function fns.log(...)
    local args = { ... }
    local home = os.getenv("HOME")
    local f = io.open(home .. "/.config/lvim/debug.log", "a")
    if f == nil then
        print("Could not open file ~/.config/lvim/debug.log")
        return
    end

    for _, v in ipairs(args) do
        if type(v) == "string" then
            f:write(v)
            f:write(" ")
        else
            f:write(" ")
            f:write(vim.inspect(v))
        end
    end
    f:write("\n")
    f:close()
end

function fns.notify(message, level)
    require("notify")(message, level)
end

function fns.is_file_buffer(bufnr)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
        return false
    end

    if not vim.api.nvim_buf_is_valid(bufnr) then
        return false
    end


    local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
    return buftype ~= "terminal" and buftype ~= "nofile"
end

function fns.is_terminal_buffer(bufnr)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
        return false
    end

    if not vim.api.nvim_buf_is_valid(bufnr) then
        return false
    end

    local name = vim.api.nvim_buf_get_name(bufnr)
    if string.find(name, "#toggleterm#") then
        return false
    end


    local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
    return buftype == "terminal"
end

return fns
