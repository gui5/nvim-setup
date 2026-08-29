-- Toggleterm: Floating and split terminal manager

return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = {
            { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Terminal: Toggle (Floating)", mode = { "n", "t" } },
            { "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal: Toggle Floating" },
            { "<leader>th", "<cmd>ToggleTerm size=15 direction=horizontal<CR>", desc = "Terminal: Toggle Horizontal Split" },
            { "<leader>tv", "<cmd>ToggleTerm size=60 direction=vertical<CR>", desc = "Terminal: Toggle Vertical Split" },
        },
        opts = {
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = [[<C-\>]],
            hide_numbers = true,
            shade_terminals = false,
            start_in_insert = true,
            insert_mappings = true,
            terminal_mappings = true,
            persist_size = true,
            persist_mode = true,
            direction = "float",
            close_on_exit = true,
            float_opts = {
                border = "rounded",
                winblend = 0,
            },
        },
    },
}
