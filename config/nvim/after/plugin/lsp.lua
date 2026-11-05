-- lsp.lua -*- configure LSP-related stuff
--
-- FIXME: I rely on nvim-lspconfig to provide configurations, I'd rather not.
-- But it works fine so I don't mind it (perhaps copy what I need)
vim.pack.add { 'https://github.com/neovim/nvim-lspconfig' }

local api = vim.api
local lsp = vim.lsp

-- Disable semantic highlighting, its just not good
-- Let treesitter do the highlighting
lsp.semantic_tokens.enable(false)
-- Document colors are used to display for example hex codes from language servers
-- think CSS, tailwind, etc.
lsp.document_color.enable(true, nil, { style = 'virtual' })
-- Inlay hints are nice
lsp.inlay_hint.enable(true)
-- Setup diagnostic styling
vim.diagnostic.config {
	underline = true, -- underline the area with diagnostics
	virtual_lines = { current_line = true },
	signs = false,
	update_in_insert = false,
	severity_sort = true,
	float = {
		header = '',
		prefix = '',
		border = 'single',
		max_width = 80,
		max_height = math.floor(vim.o.lines * 0.5),
	},
}

-- override open_floating_preview to have custom border.
-- since otherwise its rendered in white
local open_floating_preview = lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function lsp.util.open_floating_preview(contents, syntax, opts)
	local buf, win = open_floating_preview(contents, syntax, opts)
	vim.wo[win].concealcursor = 'nvic'
	vim.wo[win].colorcolumn = ''
	vim.wo[win].spell = false
	-- default open_floating_preview replaces --- with the custom char
	vim.fn.matchadd('FloatBorder', [[^─\+$]], 10, -1, { window = win })
	return buf, win
end

lsp.config('*', {
	capabilities = require('blink.cmp').get_lsp_capabilities(),
	on_init = function(client, _)
		if client:supports_method 'textDocument/semanticTokens' then
			client.server_capabilities.semanticTokensProvider = nil
		end
	end,
})
-- Setup lua-language-server to behave properly inside the neovim config environment
-- IE make it recognize the vim runtime and vim globals
lsp.config('lua_ls', {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath 'config'
				and (
					vim.uv.fs_stat(path .. '/.luarc.json')
					or vim.uv.fs_stat(path .. '/.luarc.jsonc')
				)
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				version = 'LuaJIT',
				path = { 'lua/?.lua', 'lua/?/init.lua' },
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
		})
	end,
	settings = {
		Lua = {},
	},
})

lsp.config('rust_analyzer', {
	settings = {
		['rust-analyzer'] = {
			cargo = {
				-- Yeah buddy its about time to wrap it up.
				-- allTargets will means rust will re-compile everything on each edit.
				allTargets = false,
			},
			check = {
				-- Makes stuff faster.
				-- FIXME: I dont know if this is worth it or not.
				workspace = false,
			},
			completion = {
				-- Fuck you.
				autoIter = { enable = false },
				fullFunctionSignatures = { enable = true },
			},
			imports = {
				-- working with bevy
				preferPrelude = true,
			},
			inlayHints = {
				typeHints = {
					-- No need to really.
					hideClosureInitialization = true,
					hideInferredTypes = true,
					hideNamedConstructor = true,
				},
			},
			-- dunno wtf is this
			lens = { enable = false },
		},
	},
})

lsp.enable {
	'gleam',
	'gopls',
	'lua_ls',
	'ts_ls',
	'ty',
	'ruff',
	'tailwindcss',
	'emmet-language-server',
	'html',
	'css',
	'json',
	'svelte',
	'rust_analyzer',
	'clangd',
	'wgsl_analyzer',
	'qmlls',
	'tinymist',
	'nixd',
	'jdtls',
	'zls',
	'tinymist',
	'slint_lsp',
}

-- Autocommand to attach onto buffers that have Lsp enabled
-- this allows me to setup configurations
local aug = api.nvim_create_augroup('UserLspConfig', { clear = true })
api.nvim_create_autocmd('LspAttach', {
	group = aug,
	callback = function(event)
		local buffer = event.buf
		local client = assert(lsp.get_client_by_id(event.data.client_id))
		local map = function(mode, lhs, rhs, opts)
			opts = opts or {}
			opts.buffer = buffer
			vim.keymap.set(mode, lhs, rhs, opts)
		end

		map('n', '[d', function() vim.diagnostic.jump { count = -1, float = true } end)
		map('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end)
		map('n', '<leader>a', lsp.buf.code_action, { desc = 'Buffer Code Action(s)' })
		map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Cursor diagnostics' })
		-- NOTE: snacks input w/o title, centered on the cursor. passing the name
		-- to lsp.buf.rename skips its own vim.ui.input prompt
		map('n', '<leader>r', function()
			-- color the name like the symbol is in the buffer (last capture = most specific)
			local caps = vim.treesitter.get_captures_at_cursor(0)
			local hl = caps[#caps] and '@' .. caps[#caps]
			local win = Snacks.input({
				prompt = '',
				prompt_pos = false,
				icon_pos = false,
				default = vim.fn.expand '<cword>',
				highlight = hl and function(text) return { { 0, #text, hl } } end,
				-- box is 3 rows tall w/ border: above the cursor line, or below if no room
				win = {
					relative = 'cursor',
					row = vim.fn.winline() > 3 and -3 or 1,
				},
			}, function(name)
				if name and name ~= '' then lsp.buf.rename(name) end
			end)
			-- XXX: snacks forces a " " statuscolumn (can't override it through `win`), so kill it after
			vim.wo[win.win].statuscolumn = ''
		end, { desc = 'Rename Symbol' })
		map(
			'n',
			'<leader>lI',
			function() Snacks.picker.lsp_implementations() end,
			{ desc = 'Goto Implementation' }
		)
		map(
			'n',
			'gd',
			function() Snacks.picker.lsp_definitions() end,
			{ desc = 'Goto Definition(s)' }
		)
		map(
			'n',
			'gD',
			function() Snacks.picker.lsp_declarations() end,
			{ desc = 'Goto Declaration' }
		)
		map(
			'n',
			'<leader>lr',
			function() Snacks.picker.lsp_references() end,
			{ desc = 'References', nowait = true }
		)
		map(
			'n',
			'<leader>lt',
			function() Snacks.picker.lsp_type_definitions() end,
			{ desc = 'Type Definitions', nowait = true }
		)
		map('i', '<C-k>', lsp.buf.signature_help, { desc = 'Open Signature Help' })
		map(
			'n',
			'<leader>k',
			function() lsp.buf.hover { max_width = 80 } end,
			{ desc = 'Hover Symbol', buffer = buffer }
		)

		-- formatting, but **FUCK** autoformatting man
		-- it's so annoying, esp on save since it blocks the editor and I might start doing stuff
		-- while its formatting so it shits itself
		if client:supports_method 'textDocument/formatting' then
			map(
				'n',
				'<leader>F',
				function() lsp.buf.format { bufnr = buffer, id = client.id, timeout_ms = 1000 } end,
				{ desc = 'LSP format buffer' }
			)
		end

		-- Linked Editing
		-- In short, this allows the LSP server to auto-edit other parts of the code according to
		-- where you are editing right now, like HTML tags updating the closing one
		if client:supports_method 'textDocument/linkedEditingRange' then
			vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
		end
	end,
})
