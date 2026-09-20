-- Markdown Support: LSP (marksman), In-editor Rendering (render-markdown), and Live Browser Preview (markdown-preview)

return {
    -- In-editor Markdown Rendering (Headings, Codeblocks, Tables, Checkboxes, Callouts)
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        ft = { "markdown", "markdown_inline" },
        keys = {
            { "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", desc = "Markdown: Toggle In-Buffer Render" },
        },
        opts = {
            heading = {
                enabled = true,
                sign = true,
                icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
            },
            code = {
                enabled = true,
                sign = true,
                style = "full",
                border = "thin",
            },
            checkbox = {
                enabled = true,
                unchecked = { icon = "󰄱 " },
                checked = { icon = "󰱒 " },
            },
            bullet = {
                enabled = true,
                icons = { "●", "○", "◆", "◇" },
            },
            pipe_table = {
                enabled = true,
                preset = "round",
                style = "full",
            },
            callout = {
                note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "DiagnosticInfo" },
                tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "DiagnosticOk" },
                important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "DiagnosticWarn" },
                warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "DiagnosticWarn" },
                caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "DiagnosticError" },
            },
        },
    },

    -- In-Buffer Diagram Rendering (Mermaid, PlantUML, D2, Gnuplot) via Kitty/Sixel graphics
    {
        "3rd/diagram.nvim",
        dependencies = {
            {
                "3rd/image.nvim",
                opts = {
                    backend = "kitty",
                    processor = "magick_cli",
                    integrations = {
                        markdown = {
                            enabled = true,
                            clear_in_insert_mode = false,
                            download_remote_images = true,
                            only_render_image_at_cursor = false,
                            filetypes = { "markdown", "vimwiki" },
                        },
                    },
                    max_width = nil,
                    max_height = nil,
                    max_width_window_percentage = nil,
                    max_height_window_percentage = 50,
                    window_overlap_clear_enabled = false,
                    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
                    editor_only_render_when_focused = false,
                    tmux_show_only_in_active_window = false,
                    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
                },
            },
        },
        ft = { "markdown" },
        opts = {
            events = {
                render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
                clear_buffer = { "BufLeave" },
            },
            renderer_options = {
                mermaid = {
                    background = "transparent",
                    theme = "dark",
                    scale = 1,
                },
            },
        },
        keys = {
            {
                "<leader>md",
                function()
                    require("diagram").show_diagram_hover()
                end,
                mode = "n",
                ft = { "markdown" },
                desc = "Markdown: View Diagram at Cursor (Tab)",
            },
            {
                "<leader>mD",
                function()
                    require("diagram").render()
                end,
                mode = "n",
                ft = { "markdown" },
                desc = "Markdown: Refresh In-Buffer Diagrams",
            },
            {
                "<leader>mc",
                function()
                    require("diagram").clear()
                end,
                mode = "n",
                ft = { "markdown" },
                desc = "Markdown: Clear In-Buffer Diagrams",
            },
        },
    },

    -- Live Browser Preview with sync scroll, KaTeX, and Mermaid
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        init = function()
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_auto_close = 1
            vim.g.mkdp_refresh_slow = 0
            vim.g.mkdp_open_to_the_world = 0
            vim.g.mkdp_open_ip = ""
            vim.g.mkdp_browser = ""
            vim.g.mkdp_echo_preview_url = 0
            vim.g.mkdp_page_title = "「${name}」Markdown Preview"
            vim.g.mkdp_theme = "dark"
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        keys = {
            { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown: Toggle Live Browser Preview" },
        },
    },
}
