-- Treesitter Configuration for C, C++, Rust, Web (React/TS/JS), Python, Go, and tooling

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        priority = 900,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-context",
            "windwp/nvim-ts-autotag",
        },
        config = function()
            local ts = require("nvim-treesitter")
            local site_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site")
            ts.setup({
                install_dir = site_dir,
            })

            -- Ensure required parsers for C, C++, Rust, Web, Python, Go, and tools are installed
            local target_parsers = {
                -- C & C++
                "c",
                "cpp",
                "cmake",
                "make",
                "ninja",
                -- Rust
                "rust",
                "ron",
                -- Config & Scripting
                "lua",
                "vim",
                "vimdoc",
                "bash",
                "json",
                "json5",
                "yaml",
                "toml",
                -- Markdown & Docs
                "markdown",
                "markdown_inline",
                "latex",
                "dockerfile",
                -- Web (React, TypeScript, JavaScript, HTML, CSS)
                "javascript",
                "typescript",
                "tsx",
                "html",
                "css",
                "scss",
                -- Python
                "python",
                -- Go (Golang)
                "go",
                "gomod",
                "gowork",
                "gosum",
            }

            -- Ensure query directory symlinks exist in site/queries for all target parsers
            local runtime_queries = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "nvim-treesitter", "runtime", "queries")
            local site_queries = vim.fs.joinpath(site_dir, "queries")
            if vim.fn.isdirectory(runtime_queries) == 1 then
                vim.fn.mkdir(site_queries, "p")
                for _, lang in ipairs(target_parsers) do
                    local src = vim.fs.joinpath(runtime_queries, lang)
                    local dest = vim.fs.joinpath(site_queries, lang)
                    if vim.fn.isdirectory(src) == 1 and vim.fn.isdirectory(dest) == 0 and not vim.uv.fs_lstat(dest) then
                        pcall(vim.uv.fs_symlink, src, dest)
                    end
                end
            end

            local ok_cfg, ts_cfg = pcall(require, "nvim-treesitter.config")
            if ok_cfg then
                local installed = ts_cfg.get_installed()
                local to_install = {}
                for _, p in ipairs(target_parsers) do
                    if not vim.tbl_contains(installed, p) then
                        table.insert(to_install, p)
                    end
                end
                if #to_install > 0 then
                    pcall(function()
                        require("nvim-treesitter.install").install(to_install, { summary = false })
                    end)
                end
            end

            -- Enable treesitter highlighting automatically for supported buffers
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
                desc = "Start treesitter highlighting",
            })

            -- Setup JSX/HTML Auto-closing and Auto-renaming tags
            local ok_autotag, autotag = pcall(require, "nvim-ts-autotag")
            if ok_autotag then
                autotag.setup({
                    opts = {
                        enable_close = true,
                        enable_rename = true,
                        enable_close_on_slash = true,
                    },
                })
            end

            -- Setup Textobjects mappings
            local ok_select, ts_select = pcall(require, "nvim-treesitter-textobjects.select")
            local ok_move, ts_move = pcall(require, "nvim-treesitter-textobjects.move")

            if ok_select then
                local select_maps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    ["al"] = "@loop.outer",
                    ["il"] = "@loop.inner",
                    ["ai"] = "@conditional.outer",
                    ["ii"] = "@conditional.inner",
                }

                for key, query in pairs(select_maps) do
                    vim.keymap.set({ "o", "x" }, key, function()
                        ts_select.select_textobject(query, "textobjects")
                    end, { desc = "Select " .. query })
                end
            end

            if ok_move then
                vim.keymap.set({ "n", "x", "o" }, "]m", function()
                    ts_move.goto_next_start("@function.outer", "textobjects")
                end, { desc = "Next function start" })
                vim.keymap.set({ "n", "x", "o" }, "[m", function()
                    ts_move.goto_previous_start("@function.outer", "textobjects")
                end, { desc = "Previous function start" })
                vim.keymap.set({ "n", "x", "o" }, "]]", function()
                    ts_move.goto_next_start("@class.outer", "textobjects")
                end, { desc = "Next class start" })
                vim.keymap.set({ "n", "x", "o" }, "[[", function()
                    ts_move.goto_previous_start("@class.outer", "textobjects")
                end, { desc = "Previous class start" })
            end

            -- Setup Treesitter Context header
            pcall(function()
                require("treesitter-context").setup({
                    enable = true,
                    max_lines = 3,
                    min_window_height = 20,
                    trim_scope = "outer",
                    mode = "cursor",
                })
            end)
        end,
    },
}
