-- Neovim 0.12 Options Configuration

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation (standard 4 spaces for C/C++)
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.shiftround = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance & UI
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.showmode = false -- Lualine will handle mode display
opt.pumheight = 10
opt.pumblend = 10
opt.winblend = 0
opt.fillchars = { eob = " " }

-- Splits behavior
opt.splitright = true
opt.splitbelow = true

-- Undo & Backup
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.backup = false

-- Performance & Timing
opt.updatetime = 200
opt.timeoutlen = 300

-- Clipboard & Mouse (Sync with system clipboard + OSC 52 terminal fallback)
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- Ensure clipboard works across macOS, Wayland, X11, tmux, and SSH via OSC 52 if tools are absent
if vim.fn.has("mac") == 0 and vim.fn.executable("wl-copy") == 0 and vim.fn.executable("xclip") == 0 and vim.fn.executable("xsel") == 0 and vim.fn.executable("pbcopy") == 0 then
    local has_osc52, osc52 = pcall(require, "vim.ui.clipboard.osc52")
    if has_osc52 then
        vim.g.clipboard = {
            name = "OSC 52",
            copy = {
                ["+"] = osc52.copy("+"),
                ["*"] = osc52.copy("*"),
            },
            paste = {
                ["+"] = osc52.paste("+"),
                ["*"] = osc52.paste("*"),
            },
        }
    end
end

-- Completion options (popup option is supported in Neovim 0.12)
opt.completeopt = { "menu", "menuone", "noselect" }

-- Neovim 0.12 Modern Diagnostics Configuration
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 2,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
})

-- Disable unused legacy remote providers (all plugins in this setup use native Lua)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

