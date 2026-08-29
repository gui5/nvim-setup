-- Harpoon2: Lightning-fast file bookmarking and jumping

return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                "<leader>a",
                function()
                    require("harpoon"):list():add()
                    vim.notify("󱡁 File added to Harpoon")
                end,
                desc = "Harpoon: Add File",
            },
            {
                "<leader>h",
                function()
                    local harpoon = require("harpoon")
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "Harpoon: Quick Menu",
            },
            {
                "<leader>1",
                function()
                    require("harpoon"):list():select(1)
                end,
                desc = "Harpoon: Jump to File 1",
            },
            {
                "<leader>2",
                function()
                    require("harpoon"):list():select(2)
                end,
                desc = "Harpoon: Jump to File 2",
            },
            {
                "<leader>3",
                function()
                    require("harpoon"):list():select(3)
                end,
                desc = "Harpoon: Jump to File 3",
            },
            {
                "<leader>4",
                function()
                    require("harpoon"):list():select(4)
                end,
                desc = "Harpoon: Jump to File 4",
            },
            {
                "<leader>5",
                function()
                    require("harpoon"):list():select(5)
                end,
                desc = "Harpoon: Jump to File 5",
            },
        },
        opts = {},
    },
}
