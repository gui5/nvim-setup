-- UI Components & Themes (Moonfly, Lualine, Which-Key, Dressing)

return {
    -- Moonfly Theme (Default)
    {
        "bluz71/vim-moonfly-colors",
        name = "moonfly",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.moonflyTransparent = false
            vim.g.moonflyUnderlineMatchParen = true
            vim.g.moonflyVirtualTextColor = true
            vim.cmd("colorscheme moonfly")
        end,
    },

    -- File icons
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        opts = { default = true },
    },

    -- UI Enhancements for input/select menus
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
        opts = {
            input = {
                border = "rounded",
            },
            select = {
                builtin = {
                    border = "rounded",
                },
            },
        },
    },

    -- Which-Key (Keybinding discovery and cheat sheet)
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "modern",
            spec = {
                { "<leader>c", group = "Code / Clangd / CMake", icon = "󰅩 " },
                { "<leader>d", group = "Debug (DAP / GDB / LLDB)", icon = " " },
                { "<leader>f", group = "Find (Telescope)", icon = " " },
                { "<leader>g", group = "Git / Diffview", icon = "󰊢 " },
                { "<leader>r", group = "Run / Sanitizers / Make", icon = "󰑮 " },
                { "<leader>s", group = "Splits & Windows", icon = "󱂬 " },
                { "<leader>t", group = "Terminal & Toggles", icon = " " },
                { "<leader>b", group = "Buffers & Tabs", icon = "󰈔 " },
                { "<leader>x", group = "Trouble Diagnostics", icon = "󰔫 " },
                { "<leader>h", group = "Harpoon Quick Menu", icon = "󱡁 " },
            },
        },
    },

    -- Statusline with Lualine (Moonfly Theme)
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            -- Helper for active LSP client names
            local function lsp_status()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then
                    return "No LSP"
                end
                local names = {}
                for _, client in ipairs(clients) do
                    table.insert(names, client.name)
                end
                return "󰒋 " .. table.concat(names, ", ")
            end

            return {
                options = {
                    theme = "moonfly",
                    globalstatus = true,
                    component_separators = { left = "|", right = "|" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = { statusline = { "dapui_scopes", "dapui_breakpoints", "dapui_stacks", "dapui_watches" } },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { lsp_status, "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            }
        end,
    },

    -- CSS, SCSS & Tailwind Color Highlighter (Modern Neovim 0.12)
    {
        "brenoprata10/nvim-highlight-colors",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            render = "background",
            enable_named_colors = true,
            enable_tailwind = true,
        },
    },
}
