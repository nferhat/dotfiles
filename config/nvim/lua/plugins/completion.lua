vim.pack.add({
	-- Use a tagged version to get the pre-built binary for the fuzzy matcher
	-- Otherwise it would get messy depending on rust for a neovim config
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.6.0" },
	-- Provide default snippets, in addition to the LSP ones
	"https://github.com/rafamadriz/friendly-snippets",
	-- FIXME: Autoexpand on tab with native vim snippets
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("v2.*") },
})

local kind_icons = {
	codicons = {
		Text = "",
		Method = "",
		Function = "",
		Constructor = "",
		Field = "",
		Variable = "",
		Class = "",
		Interface = "",
		Module = "",
		Property = "",
		Unit = "",
		Value = "",
		Enum = "",
		Keyword = "",
		Snippet = "",
		Color = "",
		File = "",
		Reference = "",
		Folder = "",
		EnumMember = "",
		Constant = "",
		Struct = "",
		Event = "",
		Operator = "",
		TypeParameter = "",
	},
	text = {
		Text = "t",
		Method = "M",
		Function = "F",
		Constructor = "C",
		Field = "f",
		Variable = "v",
		Class = "C",
		Interface = "I",
		Module = "m",
		Property = "p",
		Unit = "u",
		Value = "v",
		Enum = "E",
		Keyword = "k",
		Snippet = "S",
		Color = "c",
		File = "f",
		Reference = "r",
		Folder = "F",
		EnumMember = "e",
		Constant = "C",
		Struct = "S",
		Event = "e",
		Operator = "O",
		TypeParameter = "t",
	},
}

require("theme").load_skeleton("cmp")

local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

require("blink.cmp").setup({
	snippets = { preset = "luasnip" },
	keymap = {
		preset = "enter",
		["<Tab>"] = {
			-- By default, we select next
			"select_next",
			-- If we can expand a snippet, try todo that, otherwise, try to jump
			-- to the next marker
			--
			-- We are also assured that we can't select anything, no need to
			-- check if the menu is visible
			function(_)
				local can = luasnip.expand_or_jumpable()
				if can then
					vim.schedule(luasnip.expand_or_jump)
				end

				return can
			end,
			"snippet_forward",
			"select_next",
			"fallback",
		},
		["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
		["<C-s>"] = {
			function(c)
				c.show({ providers = { "snippets" } })
			end,
		},
	},
	appearance = {
		nerd_font_variant = "mono",
		kind_icons = kind_icons.text,
	},
	signature = {
		enabled = true,
		trigger = { show_on_keyword = true, show_on_insert = true },
		-- winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder',
	},
	completion = {
		menu = {
			border = "none",
			draw = {
				padding = { 0, 1 }, -- padding only on right side
				columns = {
					{ "kind_icon" },
					{ "label", width = { fill = true } },
					-- { "label_description" },
				},
				components = {
					kind_icon = {
						text = function(ctx)
							return " " .. ctx.kind_icon .. ctx.icon_gap .. " "
						end,
					},
				},
			},
		},
		list = { selection = { auto_insert = true } },
		documentation = { auto_show = true },
		trigger = {
			show_on_keyword = false,
			show_on_trigger_character = false,
			show_on_accept_on_trigger_character = false,
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning", prebuilt_binaries = { force_version = "v1.6.0" } },
})
