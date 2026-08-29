-- Neovim 0.12 Autocommands

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general_group = augroup("GeneralSettings", { clear = true })
local cpp_group = augroup("CppSettings", { clear = true })

-- Highlight on yank (Neovim 0.11+ / 0.12 uses vim.hl.on_yank)
autocmd("TextYankPost", {
    group = general_group,
    callback = function()
        if vim.hl and vim.hl.on_yank then
            vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
        else
            vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
        end
    end,
    desc = "Highlight text on yank",
})

-- Auto-resize splits on window resize
autocmd("VimResized", {
    group = general_group,
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
    desc = "Auto-resize splits when window is resized",
})

-- Close helper windows with <q>
autocmd("FileType", {
    group = general_group,
    pattern = {
        "help",
        "lspinfo",
        "man",
        "qf",
        "query",
        "checkhealth",
        "dap-float",
        "notify",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true, desc = "Close helper window" })
    end,
    desc = "Close helper windows with q",
})

-- Remember last cursor position
autocmd("BufReadPost", {
    group = general_group,
    callback = function(event)
        local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(event.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
    desc = "Go to last cursor location when reopening a buffer",
})

-- C & C++ specific buffer settings
autocmd("FileType", {
    group = cpp_group,
    pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
    callback = function()
        vim.bo.commentstring = "// %s"
        vim.opt_local.cinoptions = ":0,g0,t0,(0,W4"
        vim.opt_local.formatoptions:remove({ "r", "o" }) -- Don't automatically insert comments when pressing enter or o
    end,
    desc = "C/C++ specific options",
})
