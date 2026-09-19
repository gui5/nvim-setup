-- Telescope Fuzzy Finder Configuration (High-Performance Code Search & Discovery)

return {
    {
        "nvim-telescope/telescope.nvim",
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
            -- File Search
            { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find: Files (Tracked & Hidden)" },
            {
                "<leader>fa",
                function()
                    require("telescope.builtin").find_files({ no_ignore = true, hidden = true })
                end,
                desc = "Find: All Files (Including Ignored)",
            },
            { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Find: Recent / Old Files" },
            { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find: Open Buffers" },

            -- Source Code Grep (Ripgrep)
            { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find: Live Grep (Ripgrep)" },
            {
                "<leader>fw",
                function()
                    require("telescope.builtin").grep_string()
                end,
                mode = { "n", "x" },
                desc = "Find: Word / Selection in Project",
            },
            {
                "<leader>fW",
                function()
                    require("telescope.builtin").grep_string({ word_match = "-w" })
                end,
                desc = "Find: Exact Word in Project",
            },
            {
                "<leader>/",
                function()
                    require("telescope.builtin").current_buffer_fuzzy_find({
                        previewer = false,
                        layout_config = { width = 0.75, height = 0.70 },
                    })
                end,
                desc = "Find: Fuzzy in Current Buffer",
            },
            {
                "<leader>fl",
                function()
                    require("telescope.builtin").current_buffer_fuzzy_find()
                end,
                desc = "Find: Current Buffer Lines (with Preview)",
            },

            -- LSP Symbols & Call Hierarchy
            { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Find: Document Symbols" },
            { "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Find: Workspace Symbols" },
            { "<leader>fi", "<cmd>Telescope lsp_implementations<CR>", desc = "Find: LSP Implementations" },
            { "<leader>fci", "<cmd>Telescope lsp_incoming_calls<CR>", desc = "Find: Incoming Calls Hierarchy" },
            { "<leader>fco", "<cmd>Telescope lsp_outgoing_calls<CR>", desc = "Find: Outgoing Calls Hierarchy" },

            -- Diagnostics
            { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Find: Project Diagnostics" },
            {
                "<leader>fD",
                function()
                    require("telescope.builtin").diagnostics({ bufnr = 0 })
                end,
                desc = "Find: Buffer Diagnostics",
            },

            -- Git Search
            { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git: Project Commits" },
            { "<leader>gbc", "<cmd>Telescope git_bcommits<CR>", desc = "Git: Buffer Commits History" },
            { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git: Changed Files (Status)" },

            -- Navigation & Vim History
            { "<leader>fm", "<cmd>Telescope marks<CR>", desc = "Find: Bookmark Marks" },
            { "<leader>fj", "<cmd>Telescope jumplist<CR>", desc = "Find: Jump List History" },
            { "<leader>fq", "<cmd>Telescope quickfix<CR>", desc = "Find: Quickfix Items" },
            { "<leader>fr", "<cmd>Telescope resume<CR>", desc = "Find: Resume Last Search" },
            { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Find: Keymaps Discovery" },
            { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Find: Available Commands" },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find: Neovim Help Tags" },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    prompt_prefix = "   ",
                    selection_caret = " ",
                    entry_prefix = "  ",
                    initial_mode = "insert",
                    selection_strategy = "reset",
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.55,
                            results_width = 0.8,
                        },
                        vertical = {
                            mirror = false,
                        },
                        width = 0.88,
                        height = 0.82,
                        preview_cutoff = 120,
                    },
                    path_display = { "filename_first" },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--glob=!.git/",
                    },
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,
                            ["<C-v>"] = actions.select_vertical,
                            ["<C-x>"] = actions.select_horizontal,
                            ["<C-s>"] = actions.select_horizontal,
                            ["<C-t>"] = actions.select_tab,
                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<Esc>"] = actions.close,
                        },
                        n = {
                            ["q"] = actions.close,
                            ["<Esc>"] = actions.close,
                            ["<C-v>"] = actions.select_vertical,
                            ["<C-x>"] = actions.select_horizontal,
                            ["<C-s>"] = actions.select_horizontal,
                            ["<C-t>"] = actions.select_tab,
                        },
                    },
                    file_ignore_patterns = {
                        "%.git/",
                        "build/",
                        "%.o$",
                        "%.a$",
                        "%.so$",
                        "%.dylib$",
                        "%.out$",
                        "node_modules/",
                        "target/",
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        follow = true,
                    },
                    live_grep = {
                        additional_args = function()
                            return { "--hidden" }
                        end,
                    },
                    buffers = {
                        sort_mru = true,
                        ignore_current_buffer = false,
                        mappings = {
                            i = {
                                ["<C-d>"] = actions.delete_buffer,
                            },
                            n = {
                                ["dd"] = actions.delete_buffer,
                            },
                        },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })

            pcall(telescope.load_extension, "fzf")
        end,
    },
}
