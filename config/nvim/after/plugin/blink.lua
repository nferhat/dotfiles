-- blink.* stuff, from saghen, the amazing plugin dev
-- Fast, reliable plugins, nothing more, nothing less.

vim.pack.add {
	{ src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' },
}

-- custom highlight function.
-- instead of having separate icons, the entries are highlighted based on their type
-- additional details are included in comment text
local function highlight_label(ctx)
	-- label and label details
	local label = ctx.label
	local highlights = {
		{
			0,
			#label,
			group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or ctx.kind_hl,
		},
	}

	if ctx.label_detail then
		table.insert(highlights, {
			#label,
			#label + #ctx.label_detail,
			group = 'BlinkCmpLabelDetail',
		})
	end

	if vim.list_contains(ctx.self.treesitter, ctx.source_id) and not ctx.deprecated then
		-- add treesitter highlights
		vim.list_extend(
			highlights,
			require('blink.cmp.completion.windows.render.treesitter').highlight(ctx)
		)
	end

	-- characters matched on the label by the fuzzy matcher
	for _, idx in ipairs(ctx.label_matched_indices) do
		table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
	end

	return highlights
end

require('blink.cmp').setup {
	keymap = {
		preset = 'enter',
		['<Tab>'] = {
			-- By default, we select next
			'select_next',
			'snippet_forward',
			'select_next',
			'fallback',
		},
		['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
	},
	appearance = { nerd_font_variant = 'mono' },

	signature = {
		enabled = true,
		trigger = { show_on_keyword = true, show_on_insert = true },
		-- winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder',
	},

	completion = {
		documentation = {
			window = { border = 'single' },
			auto_show = false,
		},

		menu = {
			scrollbar = false,
			border = 'single',
			draw = {
				padding = { 1, 1 }, -- padding only on right side
				columns = { { 'label', width = { fill = true } } },
				components = { label = { highlight = highlight_label } },
			},
		},
		list = { selection = { auto_insert = true, preselect = true } },
		trigger = {
			show_on_keyword = true,
			show_on_trigger_character = true,
			show_on_accept_on_trigger_character = false,
		},
	},
	cmdline = { enabled = false, completion = { ghost_text = { enabled = true } } },
	fuzzy = {
		implementation = 'prefer_rust_with_warning',
		prebuilt_binaries = { force_version = 'v1.6.0' },
	},
}
