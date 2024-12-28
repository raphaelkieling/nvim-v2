Languages = { "lua_ls", "rust_analyzer", "gopls", "ts_ls", "yamlls", "jsonls" }

-- On attach to the LSP, setup the keybindings
function Handler_on_attach(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")

    -- All the keybinding for LSP
    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_set_keymap("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
    vim.api.nvim_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_set_keymap("n", "rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_set_keymap("n", "]d", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    vim.api.nvim_set_keymap("n", "[d", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<leader>ft", "<Cmd>:lua vim.diagnostic.setloclist()<CR>", opts)
    vim.api.nvim_set_keymap("n", "ga", "<Cmd>:lua vim.lsp.buf.code_action()<CR>", opts)
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
                ensure_installed = Languages,
                automatic_installation = true,
            })

            for _, lang in ipairs(Languages) do
                require("lspconfig")[lang].setup({
                    on_attach = Handler_on_attach,
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
                    ["<C-r>"] = cmp.mapping.confirm({ select = true }),
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
                python = { "isort", "black" },
                rust = { "rustfmt", lsp_format = "fallback" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
                yaml = { "yamlfix" },
                json = { "jq" },
                typescript = { "prettierd" },
            },
        },
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                -- Customize or remove this keymap to your liking
                "<leader>ff",
                function()
                    require("conform").format({ async = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
    },
}
