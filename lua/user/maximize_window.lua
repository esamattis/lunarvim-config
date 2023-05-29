local m = {};

function m.is_maximized()
    return vim.fn.tabpagenr("$") ~= 1
end

function m.maximize()
    if not m.is_maximized() then
        vim.cmd("tab split")
        if vim.bo.buftype == "terminal" then
            vim.api.nvim_command("startinsert")
        end
    end
end

function m.restore()
    if m.is_maximized() then
        vim.cmd("tabclose")
    end
end

function m.toggle()
    if m.is_maximized() then
        m.restore()
    else
        m.maximize()
    end
end

return m
