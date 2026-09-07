-- Treesitter Configuration for C, C++, Rust, Web (React/TS/JS), Python, Go, and tooling

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        priority = 900,
        build = ":TSUpdate",
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
                "c",
                "cpp",
                "cmake",
                "make",
                "ninja",
                "rust",
                "ron",
                "lua",
                "vim",
                "vimdoc",
                "bash",
                "json",
                "json5",
                "yaml",
                "toml",
                "markdown",
                "markdown_inline",
                "latex",
                "dockerfile",
                "javascript",
                "typescript",
                "tsx",
                "html",
                "css",
                "scss",
                "python",
                "go",
                "gomod",
                "gowork",
                "gosum",
            }

            pcall(ts.install, target_parsers)

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
