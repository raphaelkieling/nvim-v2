local languages = { "lua_ls", "rust_analyzer" }

-- On attach to the LSP, setup the keybindings
function handler_on_attach(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")

	-- All the keybinding for LSP
	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap("n", "g+d", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_set_keymap("n", "g+D", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_set_keymap("n", "g+h", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_set_keymap("n", "g+I", "<cmd>Telescope lsp_implementations<CR>", opts)
	vim.api.nvim_set_keymap("n", "g+b", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	vim.api.nvim_set_keymap("n", "g+r", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
end

return {
	-- Install formatters and lsp stuff
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			-- Config from: https://github.com/williamboman/mason-lspconfig.nvim
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = languages,
			})

			for _, lang in ipairs(languages) do
				require("lspconfig")[lang].setup({
					on_attach = handler_on_attach,
				})
			end
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				completion = {
					autocomplete = { cmp.TriggerEvent.TextChanged },
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "cmdline" },
				},
			})

			cmp.setup.cmdline(":", {
				sources = {
					{ name = "cmdline" }, -- Autocomplete for command ':'
					{ name = "path" }, -- Complete for current path
				},
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			require("lspconfig").util.default_config =
				vim.tbl_deep_extend("force", require("lspconfig").util.default_config, {
					capabilities = capabilities,
				})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "isort", "black" },
				-- You can customize some of the format options for the filetype (:help conform.format)
				rust = { "rustfmt", lsp_format = "fallback" },
				-- Conform will run the first available formatter
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>f",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
	},
}
