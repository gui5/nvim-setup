-- DAP (Debug Adapter Protocol) Multi-Language Configuration (C/C++, Go, Python)

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "theHamsta/nvim-dap-virtual-text",
            "leoluz/nvim-dap-go",
            "mfussenegger/nvim-dap-python",
        },
        keys = {
            { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
            { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
            { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
            { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
            {
                "<leader>dB",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "Debug: Set Conditional Breakpoint",
            },
            {
                "<leader>dL",
                function()
                    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
                end,
                desc = "Debug: Set Log Point",
            },
            { "<leader>dc", function() require("dap").run_to_cursor() end, desc = "Debug: Run to Cursor" },
            { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug: Open REPL" },
            { "<leader>dl", function() require("dap").run_last() end, desc = "Debug: Run Last" },
            { "<leader>dx", function() require("dap").terminate() end, desc = "Debug: Terminate" },
            { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
            -- Go Debugging
            { "<leader>dgt", function() require("dap-go").debug_test() end, desc = "Debug: Go Current Test" },
            { "<leader>dgl", function() require("dap-go").debug_last_test() end, desc = "Debug: Go Last Test" },
            -- Python Debugging
            { "<leader>dpt", function() require("dap-python").test_method() end, desc = "Debug: Python Test Method" },
            { "<leader>dpc", function() require("dap-python").test_class() end, desc = "Debug: Python Test Class" },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Setup Virtual Text
            require("nvim-dap-virtual-text").setup({
                commented = true,
                highlight_changed_variables = true,
            })

            -- Setup DAP UI
            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.35 },
                            { id = "breakpoints", size = 0.20 },
                            { id = "stacks", size = 0.25 },
                            { id = "watches", size = 0.20 },
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = {
                            { id = "repl", size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        size = 10,
                        position = "bottom",
                    },
                },
            })

            -- Automatically open/close DAP UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Customize Breakpoint Signs
            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
            vim.fn.sign_define("DapLogPoint", { text = "ℹ", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
            vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "CursorLine", numhl = "DiagnosticOk" })

            -- Native GDB Adapter (Linux / Ubuntu standard)
            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
            }

            -- LLDB DAP Adapter (macOS standard & available on Linux)
            dap.adapters.lldb = function(callback, _)
                local lldb_cmd = "lldb-dap"
                if vim.fn.executable("lldb-dap") == 0 then
                    if vim.fn.executable("lldb-vscode") == 1 then
                        lldb_cmd = "lldb-vscode"
                    elseif vim.fn.executable("/opt/homebrew/opt/llvm/bin/lldb-dap") == 1 then
                        lldb_cmd = "/opt/homebrew/opt/llvm/bin/lldb-dap"
                    elseif vim.fn.executable("/usr/local/opt/llvm/bin/lldb-dap") == 1 then
                        lldb_cmd = "/usr/local/opt/llvm/bin/lldb-dap"
                    end
                end
                callback({
                    type = "executable",
                    command = lldb_cmd,
                    name = "lldb",
                })
            end

            -- Select default adapter: on macOS default to lldb; on Linux default to gdb if available, else lldb
            local is_mac = vim.fn.has("mac") == 1
            local default_adapter = is_mac and "lldb" or (vim.fn.executable("gdb") == 1 and "gdb" or "lldb")

            -- C and C++ Configurations
            local cpp_config = {
                {
                    name = "Launch Executable (Default: " .. default_adapter:upper() .. ")",
                    type = default_adapter,
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtBeginningOfMainSubprogram = false,
                },
                {
                    name = "Launch with GDB",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtBeginningOfMainSubprogram = false,
                },
                {
                    name = "Launch with LLDB",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
                {
                    name = "Launch with Arguments (" .. default_adapter:upper() .. ")",
                    type = default_adapter,
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
                    end,
                    args = function()
                        local args_str = vim.fn.input("Arguments: ")
                        return vim.split(args_str, "%s+", { trimempty = true })
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtBeginningOfMainSubprogram = false,
                },
                {
                    name = "Attach to Process (GDB)",
                    type = "gdb",
                    request = "attach",
                    pid = function()
                        return tonumber(vim.fn.input("Process ID: "))
                    end,
                    cwd = "${workspaceFolder}",
                },
            }

            dap.configurations.c = cpp_config
            dap.configurations.cpp = cpp_config

            -- Golang DAP Setup
            local ok_dap_go, dap_go = pcall(require, "dap-go")
            if ok_dap_go then
                dap_go.setup()
            end

            -- Python DAP Setup
            local ok_dap_py, dap_python = pcall(require, "dap-python")
            if ok_dap_py then
                local python_path = vim.fn.exepath("python3")
                if python_path ~= "" then
                    dap_python.setup(python_path)
                end
            end
        end,
    },
}
