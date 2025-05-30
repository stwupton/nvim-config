-- Lazy Setup
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
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
lazy.setup({}, {})

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
vim.api.nvim_set_hl(0, 'Keyword', { fg = theme_keyword_foreground })
vim.api.nvim_set_hl(0, 'Operator', { fg = theme_keyword_foreground })
vim.api.nvim_set_hl(0, 'Statement', { fg = theme_keyword_foreground })
