-- Todo-comments: Highlight and search TODO, FIXME, BUG, NOTE, PERF in comments

return {
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            {
                "]t",
                function()
                    require("todo-comments").jump_next()
                end,
                desc = "Todo: Next TODO comment",
            },
            {
                "[t",
                function()
                    require("todo-comments").jump_prev()
                end,
                desc = "Todo: Previous TODO comment",
            },
            { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find: Project TODOs (Telescope)" },
            { "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "Trouble: Project TODOs (Trouble)" },
        },
        opts = {},
    },
}
