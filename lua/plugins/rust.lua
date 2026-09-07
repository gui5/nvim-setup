-- Rustaceanvim: Advanced Rust tooling & LSP extensions (Neovim 0.12)

return {
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        lazy = false,
        init = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local has_blink, blink = pcall(require, "blink.cmp")
            if has_blink then
                capabilities = blink.get_lsp_capabilities(capabilities)
            end

            -- Locate rust-analyzer executable
            local function get_rust_analyzer_cmd()
                local ra_path = vim.fn.exepath("rust-analyzer")
                if ra_path == "" then
                    local local_ra = vim.fn.expand("~/.local/bin/rust-analyzer")
                    if vim.fn.executable(local_ra) == 1 then
                        ra_path = local_ra
                    elseif vim.fn.executable(vim.fn.expand("~/.cargo/bin/rust-analyzer")) == 1 then
                        ra_path = vim.fn.expand("~/.cargo/bin/rust-analyzer")
                    end
                end
                return { ra_path ~= "" and ra_path or "rust-analyzer" }
            end

            vim.g.rustaceanvim = {
                server = {
                    cmd = get_rust_analyzer_cmd,
                    capabilities = capabilities,
                    on_attach = function(client, bufnr)
                        local map = function(mode, lhs, rhs, desc)
                            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "Rust: " .. desc })
                        end

                        -- Standard LSP Keymaps
                        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
                        map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")
                        map("n", "gr", vim.lsp.buf.references, "Find references")
                        map("n", "K", function()
                            vim.cmd.RustLsp({ "hover", "actions" })
                        end, "Hover Actions & Documentation")
                        map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
                        map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")

                        -- Inlay Hints Toggle
                        if client and client.server_capabilities and client.server_capabilities.inlayHintProvider then
                            map("n", "<leader>th", function()
                                local current = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                                vim.lsp.inlay_hint.enable(not current, { bufnr = bufnr })
                                vim.notify("Inlay hints " .. (not current and "enabled" or "disabled"))
                            end, "Toggle inlay hints")
                        end

                        -- Rustaceanvim Specific Keymaps
                        map("n", "<leader>ca", function()
                            vim.cmd.RustLsp("codeAction")
                        end, "Rust Code Action")

                        map("n", "<leader>cM", function()
                            vim.cmd.RustLsp("expandMacro")
                        end, "Expand Macro")

                        map("n", "<leader>co", function()
                            vim.cmd.RustLsp("openDocs")
                        end, "Open docs.rs")

                        map("n", "<leader>cR", function()
                            vim.cmd.RustLsp("runnables")
                        end, "Rust Runnables")

                        map("n", "<leader>ct", function()
                            vim.cmd.RustLsp("testables")
                        end, "Rust Testables")

                        map("n", "<leader>ce", function()
                            vim.cmd.RustLsp("explainError")
                        end, "Explain Compiler Error")

                        map("n", "<leader>cp", function()
                            vim.cmd.RustLsp("parentModule")
                        end, "Go to Parent Module")

                        map("n", "<leader>cpm", function()
                            vim.cmd.RustLsp("rebuildProcMacros")
                        end, "Rebuild Proc Macros")
                    end,
                    default_settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                buildScripts = {
                                    enable = true,
                                },
                            },
                            checkOnSave = true,
                            check = {
                                command = "clippy",
                                extraArgs = { "--no-deps" },
                            },
                            procMacro = {
                                enable = true,
                            },
                            inlayHints = {
                                bindingModeHints = { enable = false },
                                chainingHints = { enable = true },
                                closingBraceHints = { enable = true },
                                closureReturnTypeHints = { enable = "always" },
                                lifetimeElisionHints = { enable = "always", useParameterNames = true },
                                parameterHints = { enable = true },
                                typeHints = { enable = true },
                            },
                        },
                    },
                },
                dap = {
                    adapter = function()
                        if vim.fn.has("mac") == 1 or vim.fn.executable("lldb-dap") == 1 then
                            return {
                                type = "executable",
                                command = vim.fn.executable("lldb-dap") == 1 and "lldb-dap" or "lldb-vscode",
                                name = "lldb",
                            }
                        else
                            return {
                                type = "executable",
                                command = "gdb",
                                args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
                            }
                        end
                    end,
                },
            }
        end,
    },
}
