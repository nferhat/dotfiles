local M = {
    default_config = {
        skeletons_module = "theme.skeletons",
    },
    config = nil,
}

local function save_skeleton(name, highlights)
    -- Convert the skeleton highlights to an string that gets dumpted to lua bytecode
    local highlights_as_string = ""

    for hl, data in pairs(highlights) do
        if data.r then
            -- Passed in a Color struct
            local str = string.format("vim.api.nvim_set_hl(0, '%s', { fg = '%s' })", hl, data:HEX(true))
            highlights_as_string = highlights_as_string .. str
        elseif type(data) == "string" then
            -- Passed in a color hex value
            local str = string.format("vim.api.nvim_set_hl(0, '%s', { fg = '%s' })", hl, data)
            highlights_as_string = highlights_as_string .. str
        else
            -- Now its just a regular highlight table, as in `nvim_set_hl(ns, name, **opts**)`
            local opts = ""
            for opt_name, opt_val in pairs(data) do
                local ret
                if type(opt_val) == "table" and opt_val.r then
                    ret = "'" .. opt_val:HEX(true) .. "'"
                elseif type(opt_val) == "boolean" or type(opt_val) == "number" then
                    ret = tostring(opt_val)
                elseif type(opt_val) == "string" then
                    ret = "'" .. opt_val .. "'"
                end
                opts = opts .. opt_name .. "=" .. ret .. ","
            end

            highlights_as_string = highlights_as_string .. "vim.api.nvim_set_hl(0,'" .. hl .. "',{" .. opts .. "});"
        end
    end

    local data = loadstring("return string.dump(function()" .. highlights_as_string .. "end)")()
    local file = io.open(_G.theme_cache_path .. name, "wb")

    if file and data then
        file:write(data)
        file:close()
        print("Compiled skeleton: " .. name)
    else
        vim.notify("Failed to compile skeleton: " .. name, vim.log.levels.WARN)
    end
end

function M.load_skeleton(name)
    if vim.fn.filereadable(_G.theme_cache_path .. name) == 0 then
        local ok, highlights = pcall(require, "ui.theme.skeletons." .. name)
        if not ok then
            return vim.notify("No skeleton named: " .. name, vim.log.levels.ERROR)
        end
        save_skeleton(name, highlights)
    end

    dofile(_G.theme_cache_path .. name)
end

local function save_all(skeletons_path, load)
    for _, file in ipairs(vim.fn.readdir(skeletons_path)) do
        local filename = vim.fn.fnamemodify(file, ":r")
        local data = require("ui.theme.skeletons." .. filename)
        save_skeleton(filename, data)
        if load then
            M.load_skeleton(filename)
        end
    end
end

function M.init(opts)
    _G.theme_cache_path = vim.fn.stdpath "cache" .. "/theme/"

    local skeletons_path = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h") .. "/skeletons/"

    if not vim.loop.fs_stat(_G.theme_cache_path) then
        vim.fn.mkdir(_G.theme_cache_path, "p")
        save_all(skeletons_path, false)
    end

    vim.api.nvim_create_user_command("RecompileSkeletons", function()
        vim.fn.delete(_G.theme_cache_path, "rf")
        vim.fn.mkdir(_G.theme_cache_path, "p")
        require("plenary.reload").reload_module "ui.theme.skeletons"
        require("plenary.reload").reload_module "ui.theme.colors"
        save_all(skeletons_path, true)
    end, {})

    M.load_skeleton "base"
end

return M
