return {
	-- Hop
	{
		"smoka7/hop.nvim",
		config = function()
			-- Hop configuration
			vim.api.nvim_set_keymap("", "S", "<cmd>HopChar1MW<CR>", {})
			vim.api.nvim_set_keymap("", "s", "<cmd>HopChar1<CR>", {})
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({})
		end,
	},
	-- Show shortcuts
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	},
	-- Treefile
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				update_focused_file = {
					enable = true,
				},
				filters = {
					dotfiles = false,
				},
				-- Disable all icons, useful
				-- when does not have nerd font
				renderer = {
					icons = {
						-- show = {
						-- 	folder = false,
						-- 	file = false,
						-- 	folder_arrow = false,
						-- },
					},
				},

			})

			vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<leader>fe", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
		end,
	},
	-- Show errors on lines
	{
		"folke/trouble.nvim",
		opts = { use_diagnostic_signs = true },
	},
	-- Find files
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			defaults = {
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0
			},
		},
		config = function()
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		end,
	},
	-- Bottom bar
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function() end,
	},
	-- Treesitter. Add color highlight
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		opts = {
			sync_install = true,
			highlight = { enabled = true },
			indent = { enabled = true },
			ensure_installed = {
				"bash",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"yaml",
				"rust",
				"go",
			},
		},
	},
	-- Git
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>g", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
}
