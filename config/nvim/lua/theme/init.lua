local M = {
    -- To make this theme as fast as possible, this loader compiles it down to bytecode.
    -- Then, we just load the bytecode. the user has to manually call RecompileTheme
    bytecode_path = vim.fs.joinpath(vim.fn.stdpath "cache", "theme"),
}

local function save_to_bytecode(highlights)
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
    local file = io.open(M.bytecode_path, "wb")

    if file and data then
        file:write(data)
        file:close()
    end
end

function M.init()
    if not vim.loop.fs_stat(M.bytecode_path) then
        -- Do an initial save
        local data = require "theme.highlights"
        save_to_bytecode(data)
    end

    vim.api.nvim_create_user_command("RecompileTheme", function(args)
        vim.fn.delete(M.bytecode_path, "rf")

        for _, str in pairs(vim.split(args.args, "%s")) do
            if str == "cmp-kinds-bg-on" then
                vim.g.cmp_with_bg = true
            elseif str == "cmp-kinds-bg-off" then
                vim.g.cmp_with_bg = false
            end
        end

        -- FIXME: Get rid of plenary for this
        require("plenary.reload").reload_module "theme.highlights"
        local data = require "theme.highlights"
        save_to_bytecode(data)
    end, {
        nargs = "*",
        complete = function(_, line)
            return { "cmp-kinds-bg-on", "cmp-kinds-bg-off" }
        end,
    })

    -- Set terminal colors too
    local colors = require "theme.colors"
    for i = 0, 15, 1 do
        vim.g[string.format("terminal_color_%d", i)] = "#" .. colors[string.format("color%d", i)]:HEX()
    end

    dofile(M.bytecode_path)
end

return M
