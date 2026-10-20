-- Copied from https://github.com/dharmx/nvim-colo
-- Mostly stripped of everything, no need for the fancy schmancy stuff.
local Color = {}
Color.__index = Color

local function clamp(value, lo, hi) return math.min(hi, math.max(lo, value)) end

function Color:new(params)
	params = params or { r = 0, g = 0, b = 0 }
	local c = params.hex and Color.HEX2RGB(params.hex) or params
	return setmetatable({
		r = clamp(math.floor(c.r or 0), 0, 255),
		g = clamp(math.floor(c.g or 0), 0, 255),
		b = clamp(math.floor(c.b or 0), 0, 255),
	}, Color)
end

function Color:HEX(prefix)
	return string.format('%s%02X%02X%02X', prefix and '#' or '', self.r, self.g, self.b)
end

function Color:HSL()
	local r, g, b = self.r / 255, self.g / 255, self.b / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local l = (max + min) / 2
	if max == min then return { h = 0, s = 0, l = l } end

	local d = max - min
	local s = l > 0.5 and d / (2 - max - min) or d / (max + min)
	local h
	if max == r then
		h = (g - b) / d + (g < b and 6 or 0)
	elseif max == g then
		-- XXX: used to compare against self.g (0-255), so green-dominant colors got the wrong hue
		h = (b - r) / d + 2
	else
		h = (r - g) / d + 4
	end
	return { h = h / 6, s = s, l = l }
end

local function increase(self, channel, a)
	local c = { r = self.r, g = self.g, b = self.b }
	c[channel] = c[channel] + a * 2.55
	return Color:new(c)
end

function Color:increase_red(a) return increase(self, 'r', a) end

function Color:increase_green(a) return increase(self, 'g', a) end

function Color:increase_blue(a) return increase(self, 'b', a) end

function Color:brighten(a)
	local d = math.ceil(255 * (a or 10) / 100)
	return Color:new {
		r = self.r + d,
		g = self.g + d,
		b = self.b + d,
	}
end

function Color:darken(a)
	local hsl = self:HSL()
	hsl.l = clamp(hsl.l - (a or 10) / 100, 0, 1)
	return Color:new(Color.HSL2RGB(hsl.h, hsl.s, hsl.l))
end

function Color.HEX2RGB(hex)
	hex = hex:gsub('^#', '')
	if #hex == 3 then hex = hex:gsub('.', '%0%0') end
	return {
		r = tonumber(hex:sub(1, 2), 16),
		g = tonumber(hex:sub(3, 4), 16),
		b = tonumber(hex:sub(5, 6), 16),
	}
end

function Color.HSL2RGB(h, s, l)
	local function hue2rgb(p, q, t)
		t = t % 1
		if t < 1 / 6 then
			return p + (q - p) * 6 * t
		elseif t < 1 / 2 then
			return q
		elseif t < 2 / 3 then
			return p + (q - p) * (2 / 3 - t) * 6
		end
		return p
	end

	if s == 0 then
		return { r = math.ceil(l * 255), g = math.ceil(l * 255), b = math.ceil(l * 255) }
	end

	local q = l < 0.5 and l * (1 + s) or l + s - l * s
	local p = 2 * l - q
	return {
		r = math.ceil(hue2rgb(p, q, h + 1 / 3) * 255),
		g = math.ceil(hue2rgb(p, q, h) * 255),
		b = math.ceil(hue2rgb(p, q, h - 1 / 3) * 255),
	}
end

Color.__tostring = function(self) return self:HEX(true) end

return Color
