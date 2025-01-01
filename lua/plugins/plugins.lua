return {
    -- Dashboard
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local startify = require("alpha.themes.startify")
            startify.file_icons.provider = "devicons"
            require("alpha").setup(startify.config)
        end,
    },
    -- Session Management, open the last session
    {
        "rmagatti/auto-session",
        lazy = false,
        opts = {},
    },
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
        dependencies = {
            "kyazdani42/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({
                diagnostics = {
                    enable = true,
                    show_on_dirs = false,
                    icons = {
                        hint = "",
                        info = "",
                        warning = "",
                        error = "",
                    },
                },
                update_focused_file = {
                    enable = true,
                },
                view = {
                    adaptive_size = true,
                },
                filters = {
                    dotfiles = false,
                },
            })

            vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
            -- Probably deprecated. Since i'm using the update_focused_file.
            -- vim.api.nvim_set_keymap("n", "<leader>fe", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
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
                winblend = 0,
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
    -- Manage the surrounds (parentheses, brackets, etc)
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
    },
    -- Autoclose
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    -- Jump between specific pages
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            local add = function()
                print("Harpoon added")
                harpoon:list():add()
            end

            vim.keymap.set("n", "<leader>a", add)
            vim.keymap.set("n", "<leader>fe", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end)

            vim.keymap.set("n", "<leader>1", function()
                harpoon:list():select(1)
            end)
            vim.keymap.set("n", "<leader>2", function()
                harpoon:list():select(2)
            end)
            vim.keymap.set("n", "<leader>3", function()
                harpoon:list():select(3)
            end)
            vim.keymap.set("n", "<leader>4", function()
                harpoon:list():select(4)
            end)
        end,
    },
}
