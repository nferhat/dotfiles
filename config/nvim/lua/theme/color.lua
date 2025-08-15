-- Copied from https://github.com/dharmx/nvim-colo
-- A color class that has builtin functions for color manipulation.
local Color = {}

local function limit(c, a, op)
    if op == "i" then
        return (c + a) > 100 and 100 or c + a
    elseif op == "d" then
        return (c - a) < 0 and 0 or c - a
    end
    error("operation should be either i or, d", vim.log.levels.ERROR)
end

local function in_range(number, finish)
    assert(number, "number should not be nil")
    local temp = number

    if type(number) == "string" and number:find "%." and tonumber(number) == 1 then
        number = tonumber(number) * 100 .. "%"
    end

    if type(number) == "string" and number:find "%%" then
        temp = (tonumber(number:sub(1, #number - 1)) * finish) / 100
    end

    assert(temp >= 0 and temp <= finish, "number should be between 0-255/0-1/0-100")
    return temp
end

local function tbl_sum(list)
    local sum = 0
    for _, item in pairs(list) do
        sum = sum + item
    end
    return sum
end

function Color:new(params)
    local colors = vim.F.if_nil(params, { r = 0, g = 0, b = 0 })
    if colors.hex then
        colors = Color.HEX2RGB(colors.hex)
    elseif colors.int then
        colors = Color.HEX2RGB(string.format("#%06X", colors.int))
    elseif colors.h and colors.s and colors.l then
        colors = Color.HSL2RGB(colors.h, colors.s, colors.l)
    else
        colors.r = math.floor(in_range(colors.r, 255))
        colors.g = math.floor(in_range(colors.g, 255))
        colors.b = math.floor(in_range(colors.b, 255))
    end

    self.__index = self
    setmetatable(colors, self)
    return colors
end

function Color:percentage(number)
    local c = {
        r = (self.r / 255) * 100,
        g = (self.g / 255) * 100,
        b = (self.b / 255) * 100,
    }
    if number then
        return c
    end
    c.r = c.r .. "%"
    c.g = c.g .. "%"
    c.b = c.b .. "%"
    return c
end

function Color:floating()
    local floating = {}
    for key, value in pairs(self:percentage()) do
        local float_done = tonumber(value:sub(1, #value - 1)) / 100
        floating[key] = float_done == 1 and "1.0" or string.format("%.2F", float_done)
    end
    return floating
end

function Color:HEX(prefix)
    local prefix_sym = prefix and "#" or ""
    local function callback(item)
        return item:len() == 1 and item:rep(2) or item
    end
    local hex_tbl = vim.tbl_map(callback, {
        string.format("%02X", self.r),
        string.format("%02X", self.g),
        string.format("%02X", self.b),
    })
    return prefix_sym .. table.concat(hex_tbl)
end

function Color:INT()
    return self.r .. self.g .. self.b
end

function Color:HSL(unit)
    local c = self:floating()
    local r = tonumber(c.r)
    local g = tonumber(c.g)
    local b = tonumber(c.b)

    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local h = (max + min) / 2
    local l = h
    local s = h

    if max == min then
        h = 0
        s = 0
    else
        local diff = max - min
        s = l > 0.5 and diff / (2 - max - min) or diff / (max + min)
        if max == r then
            h = (g - b) / diff + (g < b and 6 or 0)
        elseif max == self.g then
            h = (b - r) / diff + 2
        elseif max == b then
            h = (r - g) / diff + 4
        end
        h = h / 6
    end
    return unit
            and {
                h = math.ceil(h * 360) .. "deg",
                s = math.ceil(s * 100) .. "%",
                l = math.ceil(l * 100) .. "%",
            }
        or { h = h, s = s, l = l }
end

function Color:increase_red(a)
    local c = self:percentage(true)
    return Color:new {
        r = limit(c.r, a, "i") .. "%",
        g = c.g .. "%",
        b = c.b .. "%",
    }
end

function Color:increase_green(a)
    local c = self:percentage(true)
    return Color:new {
        r = c.r .. "%",
        g = limit(c.g, a, "i") .. "%",
        b = c.b .. "%",
    }
end

function Color:increase_blue(a)
    local c = self:percentage(true)
    return Color:new {
        r = c.r .. "%",
        g = c.g .. "%",
        b = limit(c.b, a, "i") .. "%",
    }
end

function Color:decrease_red(a)
    local c = self:percentage(true)
    return Color:new {
        r = limit(c.r, a, "d") .. "%",
        g = c.g .. "%",
        b = c.b .. "%",
    }
end

function Color:decrease_green(a)
    local c = self:percentage(true)
    return Color:new {
        r = c.r .. "%",
        g = limit(c.g, a, "d") .. "%",
        b = c.b .. "%",
    }
end

function Color:decrease_blue(a)
    local c = self:percentage(true)
    return Color:new {
        r = c.r .. "%",
        g = c.g .. "%",
        b = limit(c.b, a, "d") .. "%",
    }
end

local function clamp(value)
    return math.min(1, math.max(0, value))
end

function Color:brighten(a)
    a = a == 0 and 0 or (a or 10)
    return Color:new {
        r = math.max(0, math.min(255, self.r - math.floor(255 * -(a / 100)))),
        g = math.max(0, math.min(255, self.g - math.floor(255 * -(a / 100)))),
        b = math.max(0, math.min(255, self.b - math.floor(255 * -(a / 100)))),
    }
end

function Color:lighten(a)
    a = a == 0 and 0 or (a or 10)
    local HSL = self:HSL()
    HSL.l = HSL.l + a / 100
    HSL.l = clamp(HSL.l)

    local RGB = Color.HSL2RGB(HSL.h, HSL.s, HSL.l)
    return Color:new {
        r = RGB.r,
        g = RGB.g,
        b = RGB.b,
    }
end

function Color:darken(a)
    a = a == 0 and 0 or (a or 10)
    local HSL = self:HSL()
    HSL.l = HSL.l - a / 100
    HSL.l = clamp(HSL.l)

    local RGB = Color.HSL2RGB(HSL.h, HSL.s, HSL.l)
    return Color:new {
        r = RGB.r,
        g = RGB.g,
        b = RGB.b,
    }
end

local function alter(attr, per)
    return math.floor(attr * (100 + per) / 100)
end

function Color:oldshade(a)
    a = a == 0 and 0 or (a or 5)
    self.r = alter(self.r, a)
    self.g = alter(self.g, a)
    self.b = alter(self.b, a)

    self.r = math.min(self.r, 255)
    self.g = math.min(self.g, 255)
    self.b = math.min(self.b, 255)
    return self
end

function Color:shade(a)
    a = a == 0 and 0 or (a or 10)
    return self:mix(Color:new { name = "black" }, a)
end

function Color:tint(a)
    a = a == 0 and 0 or (a or 10)
    return self:mix(Color:new { name = "white" }, a)
end

function Color:saturate(a)
    a = a == 0 and 0 or (a or 10)
    local HSL = self:HSL()
    HSL.s = HSL.s + a / 100
    HSL.s = clamp(HSL.s)

    local RGB = Color.HSL2RGB(HSL.h, HSL.s, HSL.l)
    return Color:new {
        r = RGB.r,
        g = RGB.g,
        b = RGB.b,
    }
end

function Color:desaturate(a)
    a = a == 0 and 0 or (a or 10)
    local HSL = self:HSL()
    HSL.s = HSL.s - a / 100
    HSL.s = clamp(HSL.s)

    local RGB = Color.HSL2RGB(HSL.h, HSL.s, HSL.l)
    return Color:new {
        r = RGB.r,
        g = RGB.g,
        b = RGB.b,
    }
end

function Color:spin(a)
    a = a == 0 and 0 or (a or 10)
    local HSL = self:HSL()
    local h = (HSL.h + a) % 360
    HSL.h = h < 0 and 360 + h or h

    local RGB = Color.HSL2RGB(HSL.h, HSL.s, HSL.l)
    return Color:new {
        r = RGB.r,
        g = RGB.g,
        b = RGB.b,
    }
end

function Color:complement()
    local HSL = self:HSL()
    return Color:new { h = (HSL.h + 180) % 360, s = HSL.s, l = HSL.l }
end

function Color:triad()
    local HSL = self:HSL()
    local h = HSL.h
    return {
        self,
        Color:new { h = (h + 120) % 360, s = HSL.s, l = HSL.l },
        Color:new { h = (h + 240) % 360, s = HSL.s, l = HSL.l },
    }
end

function Color:tetrad()
    local HSL = self:HSL()
    local h = HSL.h
    return {
        self,
        Color:new { h = (h + 90) % 360, s = HSL.s, l = HSL.l },
        Color:new { h = (h + 180) % 360, s = HSL.s, l = HSL.l },
        Color:new { h = (h + 270) % 360, s = HSL.s, l = HSL.l },
    }
end

function Color:split_complement()
    local HSL = self:HSL()
    local h = HSL.h
    return {
        self,
        Color:new { h = (h + 72) % 360, s = HSL.s, l = HSL.l },
        Color:new { h = (h + 216) % 360, s = HSL.s, l = HSL.l },
    }
end

function Color:brightness()
    return (self.r * 299 + self.g * 587 + self.b * 114) / 1000
end

function Color:light()
    return not self:dark()
end

function Color:dark()
    return self:brightness() < 128
end

function Color:luminance()
    local RsRGB, GsRGB, BsRGB, R, G, B
    RsRGB = self.r / 255
    GsRGB = self.g / 255
    BsRGB = self.b / 255

    if RsRGB <= 0.03928 then
        R = RsRGB / 12.92
    else
        R = math.pow(((RsRGB + 0.055) / 1.055), 2.4)
    end
    if GsRGB <= 0.03928 then
        G = GsRGB / 12.92
    else
        G = math.pow(((GsRGB + 0.055) / 1.055), 2.4)
    end
    if BsRGB <= 0.03928 then
        B = BsRGB / 12.92
    else
        B = math.pow(((BsRGB + 0.055) / 1.055), 2.4)
    end
    return (0.2126 * R) + (0.7152 * G) + (0.0722 * B)
end

function Color:greyscale()
    self:desaturate(100)
end

function Color:readability(c)
    local sl = self:luminance()
    local cl = c:luminance()
    return (math.max(sl, cl) + 0.05) / (math.min(sl, cl) + 0.05)
end

local function validateWCAG2Parms(parms)
    parms = parms or { level = "AA", size = "small" }
    local level = (parms.level or "AA"):upper()
    local size = (parms.size or "small"):lower()

    if level ~= "AA" and level ~= "AAA" then
        level = "AA"
    end

    if size ~= "small" and size ~= "large" then
        size = "small"
    end
    return { level = level, size = size }
end

function Color:readable(c, wcag2)
    local readability = self:readability(c)
    local output = false
    local wcag2Parms = validateWCAG2Parms(wcag2)
    local level_size = wcag2Parms.level + wcag2Parms.size

    if level_size == "AAsmall" and level_size == "AAAlarge" then
        output = readability >= 4.5
    elseif level_size == "AAlarge" then
        output = readability >= 3
    elseif level_size == "AAAsmall" then
        output = readability >= 7
    end
    return output
end

function Color:mix(c, a)
    a = a == 0 and 0 or (a or 50)
    local value = a / 100
    return Color:new {
        r = ((c.r - self.r) * value) + self.r,
        g = ((c.g - self.g) * value) + self.g,
        b = ((c.b - self.b) * value) + self.b,
    }
end

function Color:invert()
    return Color:new { name = "white" } - self
end

function Color:RGB()
    return {
        r = self.r,
        g = self.g,
        b = self.b,
    }
end

function Color.HEX2RGB(hex)
    hex = hex:sub(1, 1) == "#" and hex:sub(2) or hex
    if hex:len() == 3 then
        hex = hex:sub(1, 1):rep(2) .. hex:sub(2, 2):rep(2) .. hex:sub(3, 3):rep(2)
    end

    return {
        r = tonumber(hex:sub(1, 2), 16),
        g = tonumber(hex:sub(3, 4), 16),
        b = tonumber(hex:sub(5, 6), 16),
    }
end

function Color.HSL2RGB(h, s, l)
    local rgb = {}

    local function HUE2RGB(p, q, t)
        if t < 0 then
            t = t + 1
        end
        if t > 1 then
            t = t - 1
        end
        if t < 1 / 6 then
            return p + (q - p) * 6 * t
        end
        if t < 1 / 2 then
            return q
        end
        if t < 2 / 3 then
            return p + (q - p) * (2 / 3 - t) * 6
        end
        return p
    end

    if s == 0 then
        rgb.r = l
        rgb.g = l
        rgb.b = l
    else
        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        rgb.r = HUE2RGB(p, q, h + 1 / 3)
        rgb.g = HUE2RGB(p, q, h)
        rgb.b = HUE2RGB(p, q, h - 1 / 3)
    end

    return { r = math.ceil(rgb.r * 255), g = math.ceil(rgb.g * 255), b = math.ceil(rgb.b * 255) }
end

Color.__tostring = function(self, _)
    return self:HEX(true)
end

Color.__eq = function(self, o)
    return self.r == o.r and self.g == o.g and self.b == o.b
end

Color.__lt = function(self, o)
    return tbl_sum(self:RGB()) > tbl_sum(o:RGB())
end

Color.__gt = function(self, o)
    return tbl_sum(self:RGB()) < tbl_sum(o:RGB())
end

Color.__add = function(self, o)
    self.r = self.r + o.r
    self.g = self.g + o.g
    self.b = self.b + o.b
    return self
end

Color.__sub = function(self, o)
    self.r = self.r - o.r
    self.g = self.g - o.g
    self.b = self.b - o.b
    return self
end

return Color
