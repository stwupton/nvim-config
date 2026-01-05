-- Imports
local utils = require('utils')

-- General
vim.g.mapleader = ' '
vim.opt.scrolloff = 12
vim.opt.title = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.colorcolumn = '81,121'
vim.opt.number = true
vim.opt.fixendofline = false

-- Treesitter
local treesitter_plugin = {
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	config = function()
		local treesitter_configs = require('nvim-treesitter.configs')
		treesitter_configs.setup({
			highlight = { enable = true },
			textobjects = { enable = true },
			ensure_installed = {
				'lua',
				'odin',
				'typescript',
				'javascript'
			},
			sync_install = false,
			auto_install = true,
			ignore_install = {},
			modules = {},
		})
	end
}

-- Lazydev
local lazydev_plugin = {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } }
		}
	}
}

-- LSPs
local lspconfig_plugin = {
	'neovim/nvim-lspconfig',
	config = function()
		local lspconfig = require('lspconfig')
		lspconfig.ols.setup({})
		lspconfig.lua_ls.setup({})
		lspconfig.gdscript.setup({})
		lspconfig.ts_ls.setup({})
		lspconfig.somesass_ls.setup({})

		local eslint_base_on_attach = vim.lsp.config.eslint.on_attach
		lspconfig.eslint.setup({
			on_attach = function(client, bufnr)
				if not eslint_base_on_attach then return end

				eslint_base_on_attach(client, bufnr)
				vim.api.nvim_create_autocmd('BufWritePre', {
					buffer = bufnr,
					command = 'LspEslintFixAll'
				})
			end
		})

		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to Definition' })
		vim.keymap.set('n', 'gg', vim.lsp.buf.hover, { desc = 'LSP Display Info' })
	end
}

-- Autocomplete
local autocomplete_plugin = {
	'hrsh7th/nvim-cmp',
	event = 'InsertEnter',
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
	},
	config = function()
		local cmp = require('cmp')
		cmp.setup({
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end,
			},
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'buffer' },
				{ name = 'path' },
				{ name = 'luasnip' },
			}),
			formatting = {
				fields = { 'kind', 'abbr' }
			},
			mapping = cmp.mapping.preset.insert({
				['<C-H>'] = cmp.mapping.abort(),
				['<C-J>'] = cmp.mapping.select_next_item(),
				['<C-K>'] = cmp.mapping.select_prev_item(),
				['<C-L>'] = cmp.mapping.confirm({ select = true }),
			})
		})
	end
}

-- Autopair
local autopairs_plugin = {
	'windwp/nvim-autopairs',
	dependencies = {
		'hrsh7th/nvim-cmp',
	},
	event = 'InsertCharPre',
	config = function()
		local autopairs = require('nvim-autopairs')
		autopairs.setup({ check_ts = true })

		local autopairs_cmp = require('nvim-autopairs.completion.cmp')
		local cmp = require('cmp')
		cmp.event:on('confirm_done', autopairs_cmp.on_confirm_done())
	end
}

-- Telescope
local telescope_plugin = {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope-ui-select.nvim'
	},
	branch = '0.1.x',
	config = function()
		local telescope = require('telescope')
		telescope.setup({
			defaults = {
				file_ignore_patterns = { '.git[\\/].*', 'node_modules' }
			},
			pickers = {
				find_files = {
					hidden = true,
					no_ignore = true
				}
			},
			extensions = {
				['ui-select'] = {
					require('telescope.themes').get_dropdown({})
				}
			}
		})

		telescope.load_extension('ui-select')

		local telescope_builtin = require('telescope.builtin')
		vim.keymap.set('n', '<C-p>', telescope_builtin.find_files, { desc = 'Find Files' })
		vim.keymap.set('n', '<C-f>', telescope_builtin.live_grep, { desc = 'Live Grep' })
		vim.keymap.set('n', '?', telescope_builtin.current_buffer_fuzzy_find, { desc = 'Fuzzy Find' })
		vim.keymap.set('n', '<leader>o', telescope_builtin.lsp_document_symbols, { desc = 'Find Symbols' })
		vim.keymap.set('n', '<leader>b', telescope_builtin.buffers, { desc = 'Find Buffers' })
		vim.keymap.set('n', '<leader>e', telescope_builtin.diagnostics, { desc = 'Find Diagnostics' })
		vim.keymap.set('n', '<leader>h', telescope_builtin.help_tags, { desc = 'Find Help Tags' })
		vim.keymap.set('n', 'grr', telescope_builtin.lsp_references, { desc = 'Find References' })
	end
}

-- Guess Indent
local guess_indent_plugin = {
	'nmac427/guess-indent.nvim',
	config = function()
		local guess_indent = require('guess-indent')
		guess_indent.setup({
			override_editorconfig = false
		})
	end
}

-- Lua Snip
local luasnip_plugin = {
	'L3MON4D3/LuaSnip',
	version = 'v2.*',
	config = function()
		local vscode_loader = require('luasnip.loaders.from_vscode')
		vscode_loader.load({ paths = { './snippets' } })
	end
}

-- Gitsigns
local gitsigns_plugin = {
	'lewis6991/gitsigns.nvim',
	version = "v1.*",
	config = function()
		local gitsigns = require('gitsigns')
		gitsigns.setup({
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = 'right_align',
				delay = 1000
			}
		})
	end
}

-- DAP
local dap_plugin = {
	'mfussenegger/nvim-dap',
	version = '0.11.*',
	config = function()
		local dap = require('dap')
		local settings_ok, settings = pcall(require, 'settings')

		dap.set_log_level('TRACE')

		if settings_ok then
			if not utils.is_empty(settings.vscode_open_debug_path) then
				dap.adapters.cppdbg = {
					id = 'cppdbg',
					type = 'executable',
					command = settings.vscode_open_debug_path,
					options = {
						detached = false
					}
				}
			end

			if not utils.is_empty(settings.vscode_chrome_debug_path) then
				dap.adapters.chrome = {
					type = 'executable',
					command = 'node',
					args = { settings.vscode_chrome_debug_path }
				}
			end
		end

		vim.keymap.set('n', '<leader>dt', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
		vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug Continue' })
	end
}

-- DAP UI
local dapui_plugin = {
	'rcarriga/nvim-dap-ui',
	dependencies = {
		'nvim-neotest/nvim-nio',
		'mfussenegger/nvim-dap',
	},
	config = function()
		local dapui = require('dapui')
		dapui.setup()

		vim.keymap.set('n', '<leader>dd', dapui.open, { desc = 'Open DAP UI' })
		vim.keymap.set('n', '<leader>dq', dapui.close, { desc = 'Close DAP UI' })

		local dap = require('dap')

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end

		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end

		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end

		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
	end
}

-- LSP Signature
local lsp_signature = {
	'ray-x/lsp_signature.nvim',
	event = 'InsertEnter',
	opts = {
		bind = true,
		toggle_key = '<C-s>',
		hint_enable = false,
		handler_opts = {
			border = 'none',
		}
	}
}

-- Lazy Setup
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath
	})
end

vim.opt.rtp:prepend(lazypath)

local lazy = require('lazy')
lazy.setup({
	treesitter_plugin,
	lazydev_plugin,
	lspconfig_plugin,
	autocomplete_plugin,
	autopairs_plugin,
	telescope_plugin,
	guess_indent_plugin,
	luasnip_plugin,
	gitsigns_plugin,
	dap_plugin,
	dapui_plugin,
	lsp_signature,
}, {})

-- Diagnostics
vim.diagnostic.config({
	virtual_text = {
		enable = true,
	},
	underline = true
})

-- Keymaps
vim.keymap.set('n', 'vv', 'v', { desc = 'Visual Mode' })
vim.keymap.set('n', 'vl', '<S-v>', { desc = 'Visual Line Mode' })
vim.keymap.set('n', 'vb', '<C-v>', { desc = 'Visual Block Mode' })
vim.keymap.set('n', 'j', 'gj', { desc = 'Move Down (including wrapped single line)' })
vim.keymap.set('n', 'k', 'gk', { desc = 'Move Up (including wrapped single line)' })
vim.keymap.set('n', '<escape>', ':noh<CR>')

local hmove = function(direction)
	return function()
		local previous_window_id = vim.api.nvim_get_current_win()

		local key = direction > 0 and 'l' or 'h'
		vim.cmd('wincmd ' .. key)

		local new_window_id = vim.api.nvim_get_current_win()
		if previous_window_id == new_window_id then
			local tab_command = direction > 0 and 'tabnext' or 'tabprevious'
			vim.cmd(tab_command)
		end
	end
end

vim.keymap.set('n', 'H', hmove(-1), { desc = 'Navigate Left' })
vim.keymap.set('n', 'J', ':wincmd j<CR>', { desc = 'Navigate Down' })
vim.keymap.set('n', 'K', ':wincmd k<CR>', { desc = 'Navigate Up' })
vim.keymap.set('n', 'L', hmove(1), { desc = 'Navigate Right' })
vim.keymap.set('n', '<C-h>', ':vsplit<CR>', { desc = 'Split Left' })
vim.keymap.set('n', '<C-j>', ':split<CR>:wincmd j<CR>', { desc = 'Split Down' })
vim.keymap.set('n', '<C-k>', ':split<CR>', { desc = 'Split Up' })
vim.keymap.set('n', '<C-l>', ':vsplit<CR>:wincmd l<CR>', { desc = 'Split Right' })

-- Theme
local theme_normal_background = '#0a1924'
local theme_normal_foreground = '#e7dab9'
local theme_string_literal_foreground = '#ce8e98'
local theme_constant_literal_foreground = '#cec1d9'
local theme_comment_foreground = '#83d1aa'
local theme_keyword_foreground = '#bdd2de'
local theme_accent_background = '#08151d'

vim.api.nvim_set_hl(0, 'Normal', { fg = theme_normal_foreground, bg = theme_normal_background })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = theme_accent_background })
vim.api.nvim_set_hl(0, 'Function', { fg = theme_normal_foreground })
vim.api.nvim_set_hl(0, 'Identifier', { fg = theme_normal_foreground })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = theme_normal_foreground })
vim.api.nvim_set_hl(0, 'Type', { fg = theme_normal_foreground })
vim.api.nvim_set_hl(0, 'Special', { fg = theme_normal_foreground })
vim.api.nvim_set_hl(0, '@variable', { fg = theme_normal_foreground })
vim.api.nvim_set_hl(0, 'Comment', { fg = theme_comment_foreground })
vim.api.nvim_set_hl(0, 'Number', { fg = theme_constant_literal_foreground })
vim.api.nvim_set_hl(0, 'Constant', { fg = theme_constant_literal_foreground })
vim.api.nvim_set_hl(0, 'String', { fg = theme_string_literal_foreground })
vim.api.nvim_set_hl(0, 'Character', { fg = theme_string_literal_foreground })
vim.api.nvim_set_hl(0, 'Keyword', { fg = theme_keyword_foreground })
vim.api.nvim_set_hl(0, 'Operator', { fg = theme_keyword_foreground })
vim.api.nvim_set_hl(0, 'Statement', { fg = theme_keyword_foreground })
vim.api.nvim_set_hl(0, 'PreProc', { fg = theme_keyword_foreground })

vim.api.nvim_set_hl(0, '@constant.odin', { fg = theme_normal_foreground })

-- Project Settings
vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
	pattern = '*',
	desc = 'Run local project nvim settings in .nvim/init.lua',
	callback = function()
		local cwd = vim.fn.getcwd()
		if cwd == vim.g.project_settings_cwd then
			return
		end

		vim.g.project_settings_cwd = cwd

		local init_file = cwd .. '/.nvim/init.lua'
		if vim.fn.filereadable(init_file) == 1 then
			vim.cmd('luafile ' .. init_file)
		end
	end
})
