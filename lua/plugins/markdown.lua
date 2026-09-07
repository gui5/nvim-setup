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
