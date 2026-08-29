-- Telescope Fuzzy Finder Configuration

return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find: Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find: Live Grep (Ripgrep)" },
            { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find: Open Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find: Help Tags" },
            { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Find: Document Symbols" },
            { "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Find: Workspace Symbols" },
            { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Find: Diagnostics" },
            { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Find: Keymaps" },
            { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Find: Commands" },
            { "<leader>fr", "<cmd>Telescope resume<CR>", desc = "Find: Resume Last Search" },
            { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git: Commits" },
            { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git: Status" },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    prompt_prefix = "   ",
                    selection_caret = " ",
                    path_display = { "truncate" },
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<Esc>"] = actions.close,
                        },
                    },
                    file_ignore_patterns = {
                        "%.git/",
                        "build/",
                        "%.o$",
                        "%.a$",
                        "%.so$",
                        "%.out$",
                        "node_modules/",
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
            })

            pcall(telescope.load_extension, "fzf")
        end,
    },
}
