-- Code Formatting with conform.nvim (Multi-Language: C/C++, Web/React, Python, Go)

return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre", "BufReadPre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = { "n", "v" },
                desc = "Format: Buffer / Selection",
            },
            {
                "<leader>tf",
                function()
                    vim.g.autoformat_enabled = not vim.g.autoformat_enabled
                    vim.notify("Auto-format on save: " .. (vim.g.autoformat_enabled and "Enabled" or "Disabled"))
                end,
                desc = "Toggle: Auto-format on save",
            },
        },
        opts = {
            formatters_by_ft = {
                -- C / C++ / CUDA
                c = { "clang_format" },
                cpp = { "clang_format" },
                cuda = { "clang_format" },

                -- CMake & Lua
                cmake = { "gersemi", lsp_format = "fallback" },
                lua = { "stylua" },

                -- Web: TypeScript, JavaScript, React, HTML, CSS, JSON, YAML
                javascript = { "prettierd", "prettier", stop_after_first = true },
                javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                html = { "prettierd", "prettier", stop_after_first = true },
                css = { "prettierd", "prettier", stop_after_first = true },
                scss = { "prettierd", "prettier", stop_after_first = true },
                less = { "prettierd", "prettier", stop_after_first = true },
                json = { "prettierd", "prettier", stop_after_first = true },
                jsonc = { "prettierd", "prettier", stop_after_first = true },
                yaml = { "prettierd", "prettier", stop_after_first = true },
                markdown = { "prettierd", "prettier", stop_after_first = true },

                -- Shell (shfmt)
                sh = { "shfmt" },
                bash = { "shfmt" },

                -- Python (Ruff with Black / isort fallback)
                python = { "ruff_fix", "ruff_format" },

                -- Go (Gofumpt / Goimports)
                go = { "gofumpt", "goimports", "gofmt" },

                -- Rust (rustfmt)
                rust = { "rustfmt" },
            },
            formatters = {
                clang_format = {
                    command = "clang-format",
                    args = { "-assume-filename", "$FILENAME" },
                },
            },
            format_on_save = function(bufnr)
                if vim.g.autoformat_enabled == false then
                    return nil
                end
                -- Disable for files in vendor, build, node_modules, or git directories
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                if bufname:match("/build/") or bufname:match("/vendor/") or bufname:match("/node_modules/") or bufname:match("/%.git/") then
                    return nil
                end
                return {
                    timeout_ms = 800,
                    lsp_format = "fallback",
                }
            end,
        },
        init = function()
            -- Enable autoformat by default
            vim.g.autoformat_enabled = true
        end,
    },
}
