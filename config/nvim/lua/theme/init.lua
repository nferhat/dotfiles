local M = {}

local function save_skeleton(name, highlights)
    -- Convert the skeleton highlights to an string that gets dumpted to lua bytecode
    local highlights_as_string = ""

    for hl, data in pairs(highlights) do
        if data.HEX then
            highlights_as_string = highlights_as_string
                .. "vim.api.nvim_set_hl(0,'"
                .. hl
                .. "',{fg='"
                .. data:HEX(true)
                .. "'});"
        else
            local opts = ""
            for k, v in pairs(data) do
                local ret
                if type(v) == "table" and v.HEX then
                    ret = "'" .. v:HEX(true) .. "'"
                elseif type(v) == "boolean" or type(v) == "number" then
                    ret = tostring(v)
                elseif type(v) == "string" then
                    ret = "'" .. v .. "'"
                end
                opts = opts .. k .. "=" .. ret .. ","
            end

            highlights_as_string = highlights_as_string .. "vim.api.nvim_set_hl(0,'" .. hl .. "',{" .. opts .. "});"
        end
    end

    local data = loadstring("return string.dump(function()" .. highlights_as_string .. "end)")()
    local file = io.open(_G.theme_cache_path .. name, "wb")

    if file and data then
        file:write(data)
        file:close()
        vim.notify("Compiled skeleton: " .. name, vim.log.levels.INFO, {})
    end
end

function M.load_skeleton(name)
    if vim.fn.filereadable(_G.theme_cache_path .. name) == 0 then
        local ok, highlights = pcall(require, "theme.skeletons." .. name)
        if not ok then
            return vim.notify("No skeleton named: " .. name, vim.log.levels.ERROR)
        end
        save_skeleton(name, highlights)
    end

    dofile(_G.theme_cache_path .. name)
end

function M.init()
    _G.theme_cache_path = vim.fn.stdpath "cache" .. "/theme/"

    local skeletons_path = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h") .. "/skeletons/"

    if not vim.loop.fs_stat(_G.theme_cache_path) then
        vim.fn.mkdir(_G.theme_cache_path, "p")

        for _, file in ipairs(vim.fn.readdir(skeletons_path)) do
            local filename = vim.fn.fnamemodify(file, ":r")
            local data = require("theme.skeletons." .. filename)
            save_skeleton(filename, data)
        end
    end

    vim.api.nvim_create_user_command("RecompileSkeletons", function(args)
        for _, str in pairs(vim.split(args.args, "%s")) do
            if str == "cmp-kinds-bg-on" then
                vim.g.cmp_with_bg = true
            elseif str == "cmp-kinds-bg-off" then
                vim.g.cmp_with_bg = false
            end
        end

        vim.fn.delete(_G.theme_cache_path, "rf")
        vim.fn.mkdir(_G.theme_cache_path, "p")

        require("plenary.reload").reload_module "theme.skeletons"
        require("plenary.reload").reload_module "theme.colors"

        for _, file in ipairs(vim.fn.readdir(skeletons_path)) do
            local filename = vim.fn.fnamemodify(file, ":r")
            local data = require("theme.skeletons." .. filename)
            save_skeleton(filename, data)
            M.load_skeleton(filename)
        end
    end, {
        nargs = "*",
        complete = function(_, line)
            return { "cmp-kinds-bg-on", "cmp-kinds-bg-off" }
        end,
    })

    M.load_skeleton "base"
end

return M
