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
	vim.api.nvim_set_keymap("n", "g+r", "<Cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })
end

return {
	-- Install formatters and lsp stuff
	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Mason
			-- Config from: https://github.com/williamboman/mason-lspconfig.nvim
			local languages = { "lua_ls", "rust_analyzer" }
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
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
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
