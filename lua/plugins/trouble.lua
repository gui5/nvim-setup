-- Trouble.nvim: Diagnostics, References, and Symbols Outline Panel

return {
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "Trouble" },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble: Project Diagnostics" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Trouble: Buffer Diagnostics" },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Trouble: Code Symbols Outline" },
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "Trouble: LSP Defs / References" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<CR>", desc = "Trouble: Location List" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<CR>", desc = "Trouble: Quickfix List" },
        },
        opts = {
            modes = {
                symbols = {
                    win = { position = "right", size = 0.3 },
                },
            },
        },
    },
}
