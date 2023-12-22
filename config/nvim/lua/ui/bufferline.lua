local M = {}

local highlight_text = require("utils").highlight_text
local api, fn = vim.api, vim.fn

function M.cycle_next()
    local buffers = M.buffers or {}

    for i, buffer in ipairs(buffers) do
        if api.nvim_get_current_buf() == buffer.number then
            vim.cmd.buffer(i == #buffers and buffers[1].path or buffers[i + 1].path)
            break
        end
    end
end

function M.cycle_prev()
    local buffers = M.buffers or {}

    for i, buffer in ipairs(buffers) do
        if api.nvim_get_current_buf() == buffer.number then
            vim.cmd.buffer(i == #buffers and buffers[1].path or buffers[i - 1].path)
            break
        end
    end
end

local function compute_unique_prefixes(buffers)
    local prefixes, paths = {}, {}

    for _, buffer in ipairs(buffers) do
        prefixes[#prefixes + 1] = {}
        paths[#paths + 1] = fn.reverse(vim.split(buffer.path, "/"))
    end

    for i = 1, #paths do
        for j = i + 1, #paths do
            local k = 1
            while paths[i][k] == paths[j][k] and paths[i][k] do
                k = k + 1
                prefixes[i][k - 1] = prefixes[i][k - 1] or paths[i][k]
                prefixes[j][k - 1] = prefixes[j][k - 1] or paths[j][k]
            end
            if k ~= 1 then
                prefixes[i][k - 1] = prefixes[i][k - 1] or paths[i][k]
                prefixes[j][k - 1] = prefixes[j][k - 1] or paths[j][k]
            end
        end
    end

    for i, buffer in ipairs(buffers) do
        buffer.unique_prefix = table.concat {
            #prefixes[i] == #paths[i] and "/" or "",
            fn.join(fn.reverse(prefixes[i]), "/"),
            #prefixes[i] > 0 and "/" or "",
        }
    end
end

local function create_buffer_tab(buffer)
    local buffer_name = fn.fnamemodify(buffer.path, ":t")
    if not buffer_name or buffer_name == "" then
        buffer_name = "[scratch]"
    end

    local bufnr = buffer.number
    local is_current = bufnr == api.nvim_get_current_buf()

    local name_highlight = "TabLine" .. (is_current and "Sel" or "")
    if vim.bo[bufnr].readonly then
        name_highlight = name_highlight .. "_readonly"
    elseif vim.bo[bufnr].modified then
        name_highlight = name_highlight .. "_modified"
    end

    local unique_prefix_highlight = "Tabline" .. (is_current and "Sel" or "") .. "_unique_prefix"

    local content = highlight_text(unique_prefix_highlight, " " .. buffer.unique_prefix)
        .. highlight_text(name_highlight, buffer_name .. " ")
    local content_size = #buffer.unique_prefix + #buffer_name
    return content_size, "%" .. tostring(bufnr) .. "@TbGoToBuf@" .. content .. "%X"
end

local function get_neotree_window_width()
    local size = 0
    for _, win in pairs(api.nvim_tabpage_list_wins(0)) do
        if vim.bo[api.nvim_win_get_buf(win)].ft == "neo-tree" then
            size = api.nvim_win_get_width(win) + 1
            break
        end
    end
end

M.draw = function()
    M.buffers = {}
    for _, bufnr in pairs(api.nvim_list_bufs()) do
        if api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
            table.insert(M.buffers, {
                number = bufnr,
                path = api.nvim_buf_get_name(bufnr),
                unique_prefix = "",
            })
        end
    end

    compute_unique_prefixes(M.buffers)

    local buffer_tabs = {}
    local total_buffer_tabs_size = 0

    local neotree_window_width = get_neotree_window_width() or 0
    local remaining_space = vim.o.columns - neotree_window_width
    print(remaining_space, "before")

    for _, buffer in ipairs(M.buffers) do
        local buffer_tab_size, buffer_tab = create_buffer_tab(buffer)
        remaining_space = remaining_space - buffer_tab_size
        print(remaining_space, "after")

        if remaining_space > vim.o.columns then
            if buffer.number == api.nvim_get_current_buf() then
                break
            end
            -- Remove the first buffer on the list to show the new buffer
            table.remove(M.buffers, 1)
        end

        table.insert(buffer_tabs, buffer_tab)
    end

    return highlight_text("NeotreeNormal", string.rep(" ", neotree_window_width))
        .. table.concat(buffer_tabs)
        .. highlight_text("TabLinefill", "%=")
end

function M.init()
    -- Switches to given buffer as the 1st argument
    require("ui.theme").load_skeleton "bufferline"
    vim.cmd "function! TbGoToBuf(bufnr,b,c,d) \n execute 'buffer ' .. a:bufnr \n endfunction"
    vim.opt.tabline = "%!v:lua.require('ui.bufferline').draw()"

    vim.keymap.set("n", "<Tab>", M.cycle_next, { desc = "Cycle To next buffer" })
    vim.keymap.set("n", "<S-Tab>", M.cycle_prev, { desc = "Cycle To previous buffer" })
end

return M
