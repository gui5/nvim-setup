-- Bufferline: Top tabs with file icons, modified indicator, and LSP diagnostic badges

return {
    {
        "akinsho/bufferline.nvim",
        version = "*",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Buffer: Previous Tab" },
            { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Buffer: Next Tab" },
            { "<leader>bp", "<cmd>BufferLineTogglePin<CR>", desc = "Buffer: Toggle Pin Tab" },
            { "<leader>bc", "<cmd>BufferLinePickClose<CR>", desc = "Buffer: Pick and Close" },
            { "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", desc = "Buffer: Close All to the Left" },
            { "<leader>br", "<cmd>BufferLineCloseRight<CR>", desc = "Buffer: Close All to the Right" },
        },
        opts = {
            options = {
                mode = "buffers",
                separator_style = "slant",
                always_show_bufferline = true,
                show_buffer_close_icons = true,
                show_close_icon = false,
                color_icons = true,
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level)
                    local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
                end,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "left",
                        separator = true,
                    },
                },
            },
        },
    },
}
