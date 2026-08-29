-- Blink.cmp completion configuration (Fast Rust-powered autocompletion)

return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        version = "*",
        event = "InsertEnter",
        opts = {
            keymap = {
                preset = "default",
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<CR>"] = { "accept", "fallback" },
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            completion = {
                accept = {
                    auto_brackets = {
                        enabled = true,
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    window = {
                        border = "rounded",
                    },
                },
                menu = {
                    border = "rounded",
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind", gap = 1 },
                        },
                    },
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                },
            },
        },
    },
}
