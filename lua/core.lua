print("Core loaded")

local opt = vim.opt
local g = vim.g

g.mapleader = " "

-- Options
opt.number=true
opt.relativenumber=true
opt.clipboard="unnamedplus"
opt.shiftwidth=4
opt.tabstop=4
opt.wrap=false
opt.signcolumn = 'yes'

-- Disable default tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- Split Layout
vim.api.nvim_set_keymap('n', '<C-k>', ':wincmd k<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', ':wincmd j<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', ':wincmd h<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', { noremap = true, silent = true })

