print("Core loaded")

local opt = vim.opt
local g = vim.g
local api = vim.api
local o = vim.o

g.mapleader = " "

-- Options
opt.number=true
opt.relativenumber=true
opt.clipboard="unnamedplus"
opt.shiftwidth=4
opt.tabstop=4
opt.wrap=false
opt.signcolumn = 'yes'
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.history = 1000
o.scrolloff = 8

-- Disable default tree
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Split Layout
api.nvim_set_keymap('n', '<C-k>', ':wincmd k<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<C-j>', ':wincmd j<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<C-h>', ':wincmd h<CR>', { noremap = true, silent = true })
api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', { noremap = true, silent = true })

-- Terminal 
api.nvim_set_keymap('t', '<C-e>', [[<C-\><C-n>]], { noremap = true, silent = true })


-- Yank highlight
api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=200})
  augroup end
]], false)

