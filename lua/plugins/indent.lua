-- Indent-blankline (ibl): Visual indentation guides and active scope highlighter

return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = false,
                highlight = { "Function", "Label" },
            },
            exclude = {
                filetypes = {
                    "help",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "toggleterm",
                },
            },
        },
    },
}
