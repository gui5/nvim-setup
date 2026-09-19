-- Flash.nvim: Lightning-fast navigation & Treesitter motion jumping
-- Jump to any word or Treesitter node on screen with 2 keystrokes

return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            labels = "asdfghjklqwertyuiopzxcvbnm",
            search = {
                mode = "exact",
                incremental = false,
            },
            jump = {
                jumplist = true,
                pos = "start",
                history = false,
                register = false,
                nohlsearch = true,
                autojump = false,
            },
            modes = {
                char = {
                    enabled = true,
                    jump_labels = true,
                },
            },
        },
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash: Jump to Label",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash: Treesitter Scope Jump",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Flash: Remote Action",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Flash: Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Flash: Toggle Search Integration",
            },
        },
    },
}
