local languages = { "lua_ls", "rust_analyzer", "gopls" }

-- On attach to the LSP, setup the keybindings
function handler_on_attach(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")

	-- All the keybinding for LSP
	local opts = { noremap = false, silent = true }
	vim.api.nvim_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "]d", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "[d", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { noremap = true, silent = true })
end

return {
	-- Install formatters and lsp stuff
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			-- Config from: https://github.com/williamboman/mason-lspconfig.nvim
			require("mason").setup({
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
