-- Core configuration loader

-- Set leader key to space before any plugins/keymaps load
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Prepend common user binary directories to PATH (Linux, Ubuntu, macOS Homebrew, LLVM, Go, Cargo)
local user_bins = {
    vim.fn.expand("~/.cargo/bin"),
    vim.fn.expand("~/go/bin"),
    vim.fn.expand("~/.local/bin"),
    vim.fn.expand("~/.npm-global/bin"),
    vim.fn.expand("~/.local/share/nvim/mason/bin"),
    "/opt/homebrew/bin",
    "/opt/homebrew/opt/llvm/bin",
    "/usr/local/opt/llvm/bin",
    "/usr/local/bin",
}
for _, bin_dir in ipairs(user_bins) do
    if vim.fn.isdirectory(bin_dir) == 1 and not string.find(vim.env.PATH or "", bin_dir, 1, true) then
        vim.env.PATH = bin_dir .. ":" .. (vim.env.PATH or "")
    end
end

-- Silence non-critical upstream plugin deprecation notices in Neovim 0.12
local orig_deprecate = vim.deprecate
if orig_deprecate then
    vim.deprecate = function(name, ...)
        if name and (name:find("client%.") or name:find("tbl_flatten") or name:find("get_buffers_by_client_id") or name:find("vim%.validate")) then
            return
        end
        return orig_deprecate(name, ...)
    end
end

-- Load core modules
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
