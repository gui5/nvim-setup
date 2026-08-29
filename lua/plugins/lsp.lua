-- LSP Configuration for C/C++, Web (React/TS/JS), Python, Go, and tooling
-- Neovim 0.12 Native vim.lsp.config API

return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "p00f/clangd_extensions.nvim",
        },
        config = function()
            -- Setup Mason for managing external LSP servers and tooling
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",
                    "tailwindcss",
                    "html",
                    "cssls",
                    "eslint",
                    "emmet_language_server",
                    "pyright",
                    "ruff",
                    "gopls",
                },
                automatic_installation = true,
            })

            -- Setup capabilities (support blink.cmp or default)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local has_blink, blink = pcall(require, "blink.cmp")
            if has_blink then
                capabilities = blink.get_lsp_capabilities(capabilities)
            end

            -- Global LspAttach handler for keymaps and buffer setup
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local bufnr = args.buf

                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
                    end

                    -- LSP Navigation & Actions
                    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
                    map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")
                    map("n", "gr", vim.lsp.buf.references, "Find references")
                    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
                    map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
                    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")

                    -- Inlay hints toggle (Neovim 0.10+ / 0.12 native)
                    if client and client.server_capabilities and client.server_capabilities.inlayHintProvider then
                        map("n", "<leader>th", function()
                            local current = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
                            vim.lsp.inlay_hint.enable(not current, { bufnr = bufnr })
                            vim.notify("Inlay hints " .. (not current and "enabled" or "disabled"))
                        end, "Toggle inlay hints")
                    end

                    -- Clangd specific keymaps
                    if client and client.name == "clangd" then
                        map("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<CR>", "Switch between Source and Header")
                        map("n", "<leader>cT", "<cmd>ClangdTypeHierarchy<CR>", "Clangd Type Hierarchy")
                        map("n", "<leader>cM", "<cmd>ClangdMemoryUsage<CR>", "Clangd Memory Usage")
                        map("n", "<leader>cA", "<cmd>ClangdAST<CR>", "Clangd AST View")
                        map("n", "<leader>cs", "<cmd>ClangdSymbolInfo<CR>", "Clangd Symbol Info")
                    end
                end,
            })

            -- Configure clangd_extensions for C/C++
            require("clangd_extensions").setup({
                ast = {
                    role_icons = {
                        type = "",
                        declaration = "",
                        expression = "",
                        specifier = "",
                        statement = "",
                        ["template argument"] = "",
                    },
                    kind_icons = {
                        Compound = "",
                        Recovery = "",
                        TranslationUnit = "",
                        PackExpansion = "",
                        TemplateTypeParm = "",
                        TemplateTemplateParm = "",
                        TemplateParamObject = "",
                    },
                },
                memory_usage = {
                    border = "rounded",
                },
                symbol_info = {
                    border = "rounded",
                },
            })

            -- -----------------------------------------------------------------
            -- 1. C & C++ (Clangd)
            -- -----------------------------------------------------------------
            vim.lsp.config["clangd"] = {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
                root_markers = {
                    ".clangd",
                    ".clang-tidy",
                    ".clang-format",
                    "compile_commands.json",
                    "compile_flags.txt",
                    "build.ninja",
                    "CMakeLists.txt",
                    "Makefile",
                    ".git",
                },
                capabilities = capabilities,
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
            }

            -- -----------------------------------------------------------------
            -- 2. CMake (neocmakelsp)
            -- -----------------------------------------------------------------
            vim.lsp.config["neocmake"] = {
                cmd = { "neocmakelsp", "stdio" },
                filetypes = { "cmake" },
                root_markers = { "CMakeLists.txt", "build.ninja", ".git" },
                capabilities = capabilities,
                init_options = {
                    format = {
                        enable = true,
                    },
                    scan_cmake_in_package = true,
                },
            }

            -- -----------------------------------------------------------------
            -- 3. Web: TypeScript, JavaScript & React (ts_ls)
            -- -----------------------------------------------------------------
            vim.lsp.config["ts_ls"] = {
                cmd = { "typescript-language-server", "--stdio" },
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
                capabilities = capabilities,
                settings = {
                    javascript = {
                        inlayHints = {
                            includeInlayEnumMemberValueHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayVariableTypeHints = true,
                        },
                    },
                    typescript = {
                        inlayHints = {
                            includeInlayEnumMemberValueHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayVariableTypeHints = true,
                        },
                    },
                },
            }

            -- -----------------------------------------------------------------
            -- 4. Web: Tailwind CSS
            -- -----------------------------------------------------------------
            vim.lsp.config["tailwindcss"] = {
                cmd = { "tailwindcss-language-server", "--stdio" },
                filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
                root_markers = {
                    "tailwind.config.js",
                    "tailwind.config.ts",
                    "tailwind.config.cjs",
                    "tailwind.config.mjs",
                    "postcss.config.js",
                    "package.json",
                    ".git",
                },
                capabilities = capabilities,
            }

            -- -----------------------------------------------------------------
            -- 5. Web: HTML & CSS
            -- -----------------------------------------------------------------
            vim.lsp.config["html"] = {
                cmd = { "vscode-html-language-server", "--stdio" },
                filetypes = { "html", "templ" },
                root_markers = { "package.json", ".git" },
                capabilities = capabilities,
            }

            vim.lsp.config["cssls"] = {
                cmd = { "vscode-css-language-server", "--stdio" },
                filetypes = { "css", "scss", "less" },
                root_markers = { "package.json", ".git" },
                capabilities = capabilities,
            }

            -- -----------------------------------------------------------------
            -- 6. Web: ESLint
            -- -----------------------------------------------------------------
            vim.lsp.config["eslint"] = {
                cmd = { "vscode-eslint-language-server", "--stdio" },
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                root_markers = {
                    ".eslintrc",
                    ".eslintrc.js",
                    ".eslintrc.cjs",
                    ".eslintrc.json",
                    "eslint.config.js",
                    "eslint.config.mjs",
                    "package.json",
                    ".git",
                },
                capabilities = capabilities,
            }

            -- -----------------------------------------------------------------
            -- 7. Web: Emmet (High-speed HTML/JSX abbreviations)
            -- -----------------------------------------------------------------
            vim.lsp.config["emmet_language_server"] = {
                cmd = { "emmet-language-server", "--stdio" },
                filetypes = { "css", "html", "javascriptreact", "typescriptreact", "sass", "scss", "less" },
                root_markers = { "package.json", ".git" },
                capabilities = capabilities,
            }

            -- -----------------------------------------------------------------
            -- 8. Python: Pyright & Ruff
            -- -----------------------------------------------------------------
            vim.lsp.config["pyright"] = {
                cmd = { "pyright-langserver", "--stdio" },
                filetypes = { "python" },
                root_markers = {
                    "pyproject.toml",
                    "setup.py",
                    "setup.cfg",
                    "requirements.txt",
                    "Pipfile",
                    "pyrightconfig.json",
                    ".git",
                },
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = "basic",
                        },
                    },
                },
            }

            vim.lsp.config["ruff"] = {
                cmd = { "ruff", "server" },
                filetypes = { "python" },
                root_markers = {
                    "pyproject.toml",
                    "ruff.toml",
                    ".ruff.toml",
                    "setup.py",
                    "setup.cfg",
                    "requirements.txt",
                    ".git",
                },
                capabilities = capabilities,
            }

            -- -----------------------------------------------------------------
            -- 9. Go: Gopls
            -- -----------------------------------------------------------------
            vim.lsp.config["gopls"] = {
                cmd = { "gopls" },
                filetypes = { "go", "gomod", "gowork" },
                root_markers = { "go.work", "go.mod", ".git" },
                capabilities = capabilities,
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                            shadow = true,
                        },
                        staticcheck = true,
                        completeUnimported = true,
                        usePlaceholders = true,
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                    },
                },
            }

            -- -----------------------------------------------------------------
            -- 10. Lua: Lua-Language-Server
            -- -----------------------------------------------------------------
            vim.lsp.config["lua_ls"] = {
                cmd = { "lua-language-server" },
                filetypes = { "lua" },
                root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            }

            -- -----------------------------------------------------------------
            -- 11. Markdown: Marksman Language Server
            -- -----------------------------------------------------------------
            vim.lsp.config["marksman"] = {
                cmd = { "marksman", "server" },
                filetypes = { "markdown", "markdown.mdx" },
                root_markers = { ".marksman.toml", ".git" },
                capabilities = capabilities,
            }

            -- Enable all configured language servers (rust-analyzer is managed by rustaceanvim)
            vim.lsp.enable({
                "clangd",
                "neocmake",
                "ts_ls",
                "tailwindcss",
                "html",
                "cssls",
                "eslint",
                "emmet_language_server",
                "pyright",
                "ruff",
                "gopls",
                "lua_ls",
                "marksman",
            })
        end,
    },
}
