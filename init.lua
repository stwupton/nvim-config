-- Lazy Plugins
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
			indent = { enable = true },
			textobjects = { enable = true },
			ensure_installed = {
				'lua',
				'odin'
			},
			sync_install = false,
			auto_install = true,
			ignore_install = {},
			modules = {},
		})
	end
}

-- LSPs
local lsp_config_plugin = {
	'neovim/nvim-lspconfig',
	config = function()
		local lspconfig = require('lspconfig')
		lspconfig.ols.setup({})
		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					workspace = {
						library = vim.api.nvim_get_runtime_file('', true),
					},
				}
			}
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
	},
	config = function()
		local cmp = require('cmp')
		cmp.setup({
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'buffer' },
				{ name = 'path' },
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
		'nvim-lua/plenary.nvim'
	},
	branch = '0.1.x',
	config = function()
		local telescope_builtin = require('telescope.builtin')
		vim.keymap.set('n', '<C-p>', telescope_builtin.git_files, { desc = 'Find Files' } )
		vim.keymap.set('n', '<C-f>', telescope_builtin.live_grep, { desc = 'Live Grep' } )
	end
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
	lsp_config_plugin,
	autocomplete_plugin,
	autopairs_plugin,
	telescope_plugin
}, {})

-- Diagnostics
vim.diagnostic.config({
	virtual_text = {
		enable = true
	},
	underline = true
})

-- General
vim.opt.scrolloff = 12
vim.opt.title = true
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Keymaps
vim.keymap.set('n', 'vv', 'v', { desc = 'Visual Mode' })
vim.keymap.set('n', 'vl', '<S-v>', { desc = 'Visual Line Mode' })
vim.keymap.set('n', 'vb', '<C-v>', { desc = 'Visual Block Mode' })
vim.keymap.set('n', '<C-l>', 'gt', { desc = 'Next Tab' })
vim.keymap.set('n', '<C-h>', 'gT', { desc = 'Previous Tab' })

-- Theme
local theme_normal_background = '#0a1924'
local theme_normal_foreground = '#e7dab9'
local theme_string_literal_foreground = '#ce8e98'
local theme_constant_literal_foreground = '#cec1d9'
local theme_comment_foreground = '#83d1aa'
local theme_keyword_foreground = '#bdd2de'

vim.api.nvim_set_hl(0, 'Normal', { fg = theme_normal_foreground, bg = theme_normal_background })
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
