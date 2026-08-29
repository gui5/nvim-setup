-- Diffview.nvim: Side-by-side git diffs, file history, and 3-way merge conflict resolver

return {
    {
        "sindrets/diffview.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        cmd = {
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewToggleFiles",
            "DiffviewFocusFiles",
            "DiffviewFileHistory",
        },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git Diff: Open Workspace Diffview" },
            { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Git Diff: Close Diffview" },
            { "<leader>ghf", "<cmd>DiffviewFileHistory %<CR>", desc = "Git Diff: Current File History" },
            { "<leader>ghF", "<cmd>DiffviewFileHistory<CR>", desc = "Git Diff: Entire Branch History" },
        },
        opts = {
            enhanced_diff_hl = true,
            view = {
                merge_tool = {
                    layout = "diff3_mixed",
                },
            },
        },
    },
}
