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
    local search_len = string.len(search)
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

return fns
