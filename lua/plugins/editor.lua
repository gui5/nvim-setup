-- Editor utilities (Neo-tree, Oil.nvim, Gitsigns, Auto-pairs, Comments)

return {
    -- Neo-tree File Explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree",
        keys = {
            { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Explorer: Toggle Neo-tree" },
            { "<leader>fe", "<cmd>Neotree reveal<CR>", desc = "Explorer: Reveal in Neo-tree" },
            { "<leader>ge", "<cmd>Neotree git_status<CR>", desc = "Explorer: Git Status Tree" },
            { "<leader>be", "<cmd>Neotree buffers<CR>", desc = "Explorer: Buffers Tree" },
        },
        opts = {
            sources = { "filesystem", "buffers", "git_status" },
            open_on_tabnew = false,
            close_if_last_window = true,
            popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = true,
            filesystem = {
                bind_to_cwd = false,
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false,
                },
                use_libuv_file_watcher = true,
                filtered_items = {
                    visible = false,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_by_name = {
                        ".git",
                        "node_modules",
                    },
                    never_show = {
                        ".DS_Store",
                    },
                },
                window = {
                    mappings = {
                        ["\\"] = "close_window",
                    },
                },
            },
            window = {
                position = "left",
                width = 32,
                mapping_options = {
                    noremap = true,
                    nowait = true,
                },
                mappings = {
                    ["<space>"] = "none",
                    ["l"] = "open",
                    ["h"] = "close_node",
                    ["<cr>"] = "open",
                    ["P"] = { "toggle_preview", config = { use_float = true } },
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true,
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                git_status = {
                    symbols = {
                        added = "✚",
                        modified = "",
                        deleted = "✖",
                        renamed = "󰁕",
                        untracked = "",
                        ignored = "",
                        unstaged = "󰄱",
                        staged = "",
                        conflict = "",
                    },
                },
            },
        },
    },

    -- Oil.nvim: edit filesystem like a normal buffer
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "-", "<cmd>Oil<CR>", desc = "Open parent directory with Oil" },
            { "<leader>o", "<cmd>Oil<CR>", desc = "Open Oil file editor" },
        },
        opts = {
            default_file_explorer = false,
            columns = {
                "icon",
                "permissions",
                "size",
                "mtime",
            },
            view_options = {
                show_hidden = true,
            },
        },
    },

    -- Git integration in gutter
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = " " },
                topdelete = { text = "▔" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = "Git: " .. desc })
                end

                -- Navigation
                map("n", "]h", function()
                    if vim.wo.diff then return "]h" end
                    vim.schedule(function() gs.next_hunk() end)
                    return "<Ignore>"
                end, "Next Git Hunk")

                map("n", "[h", function()
                    if vim.wo.diff then return "[h" end
                    vim.schedule(function() gs.prev_hunk() end)
                    return "<Ignore>"
                end, "Previous Git Hunk")

                -- Actions
                map("n", "<leader>ghs", gs.stage_hunk, "Stage Hunk")
                map("n", "<leader>ghr", gs.reset_hunk, "Reset Hunk")
                map("v", "<leader>ghs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage Selected Hunk")
                map("v", "<leader>ghr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset Selected Hunk")
                map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Git Blame Line")
                map("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle Current Line Blame")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
            end,
        },
    },

    -- Auto-pairing parens, brackets, quotes
    {
        "echasnovski/mini.pairs",
        event = "InsertEnter",
        opts = {},
    },

    -- Fast Treesitter comments
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
