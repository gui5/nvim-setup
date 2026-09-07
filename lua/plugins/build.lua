-- Build System Integration, CMake Tools, Multi-Language Runners (Floating Terminal)

return {
    {
        "Civitasv/cmake-tools.nvim",
        lazy = true,
        ft = { "c", "cpp", "cmake" },
        cmd = {
            "CMakeGenerate",
            "CMakeBuild",
            "CMakeRun",
            "CMakeDebug",
            "CMakeSelectLaunchTarget",
            "CMakeSelectBuildTarget",
            "CMakeSelectBuildType",
            "CMakeSelectKit",
            "CMakeStop",
            "CMakeOpen",
            "CMakeClose",
            "CMakeInstall",
            "CMakeClean",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "akinsho/toggleterm.nvim",
        },
        keys = {
            { "<leader>cg", "<cmd>CMakeGenerate<CR>", desc = "CMake: Generate" },
            { "<leader>cb", "<cmd>CMakeBuild<CR>", desc = "CMake: Build" },
            { "<leader>cR", "<cmd>CMakeRun<CR>", desc = "CMake: Run (Floating Terminal)" },
            { "<leader>cD", "<cmd>CMakeDebug<CR>", desc = "CMake: Debug (DAP)" },
            { "<leader>ct", "<cmd>CMakeSelectLaunchTarget<CR>", desc = "CMake: Select Launch Target" },
            { "<leader>cT", "<cmd>CMakeSelectBuildTarget<CR>", desc = "CMake: Select Build Target" },
            { "<leader>cy", "<cmd>CMakeSelectBuildType<CR>", desc = "CMake: Select Build Type" },
            { "<leader>ck", "<cmd>CMakeSelectKit<CR>", desc = "CMake: Select Kit" },
            { "<leader>cS", "<cmd>CMakeStop<CR>", desc = "CMake: Stop Current Task" },
            { "<leader>co", "<cmd>CMakeOpen<CR>", desc = "CMake: Open Console" },
        },
        opts = {
            cmake_command = "cmake",
            cmake_regenerate_on_save = false,
            cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
            cmake_build_directory = "build/${variant:buildType}",
            cmake_soft_link_compile_commands = true,
            cmake_compile_commands_from_lsp = true,
            cmake_kits_path = nil,
            cmake_variants_message = {
                short = { show = true },
                long = { show = true, max_length = 40 },
            },
            cmake_dap_configuration = {
                name = "CMake Debug (GDB)",
                type = "gdb",
                request = "launch",
                stopAtBeginningOfMainSubprogram = false,
                runInTerminal = false,
            },
            cmake_executor = {
                name = "quickfix",
                opts = {
                    show = "always",
                    position = "belowright",
                    size = 10,
                    encoding = "utf-8",
                    auto_close_when_success = false,
                },
            },
            cmake_runner = {
                name = "toggleterm",
                opts = {
                    direction = "float",
                    close_on_exit = false,
                    auto_scroll = true,
                    singleton = true,
                },
            },
        },
        config = function(_, opts)
            require("cmake-tools").setup(opts)
        end,
    },
    -- Keymaps for multi-language compilation, runners, and testing in Floating Terminal
    {
        "nvim-lua/plenary.nvim",
        dependencies = { "akinsho/toggleterm.nvim" },
        init = function()
            -- Helper to run commands in a clean floating ToggleTerm
            local function run_in_float(cmd)
                local has_tt, toggleterm = pcall(require, "toggleterm.terminal")
                if has_tt then
                    local term = toggleterm.Terminal:new({
                        cmd = cmd,
                        direction = "float",
                        close_on_exit = false,
                        float_opts = {
                            border = "rounded",
                            winblend = 0,
                        },
                    })
                    term:toggle()
                else
                    vim.cmd("split | terminal " .. cmd)
                end
            end

            -- Helper to find nearest marker file upward
            local function find_marker(marker)
                local buf_path = vim.api.nvim_buf_get_name(0)
                if buf_path == "" then
                    return nil
                end
                local matches = vim.fs.find(marker, { upward = true, path = vim.fs.dirname(buf_path) })
                return matches[1]
            end

            -- Multi-Language Compile & Run (<leader>rc)
            vim.keymap.set("n", "<leader>rc", function()
                local file = vim.fn.expand("%:p")
                local rel_file = vim.fn.expand("%")
                local output = vim.fn.expand("%:p:r")
                local ft = vim.bo.filetype
                local c_comp = (vim.fn.executable("gcc") == 1) and "gcc" or "clang"
                local cpp_comp = (vim.fn.executable("g++") == 1) and "g++ -std=c++20" or "clang++ -std=c++20"

                if ft == "c" then
                    run_in_float(c_comp .. " -Wall -Wextra -g -O0 \"" .. file .. "\" -o \"" .. output .. "\" && \"" .. output .. "\"")
                elseif ft == "cpp" then
                    run_in_float(cpp_comp .. " -Wall -Wextra -g -O0 \"" .. file .. "\" -o \"" .. output .. "\" && \"" .. output .. "\"")
                elseif ft == "rust" then
                    local cargo_toml = find_marker("Cargo.toml")
                    if cargo_toml then
                        run_in_float("cargo run --manifest-path \"" .. cargo_toml .. "\"")
                    else
                        run_in_float("rustc --edition=2021 -g \"" .. file .. "\" -o \"" .. output .. "\" && \"" .. output .. "\"")
                    end
                elseif ft == "go" then
                    local go_mod = find_marker("go.mod")
                    if go_mod then
                        local pkg_dir = vim.fs.dirname(go_mod)
                        run_in_float("cd \"" .. pkg_dir .. "\" && go run .")
                    else
                        run_in_float("go run \"" .. file .. "\"")
                    end
                elseif ft == "python" then
                    run_in_float("python3 \"" .. file .. "\"")
                elseif ft == "javascript" or ft == "javascriptreact" then
                    run_in_float("node \"" .. file .. "\"")
                elseif ft == "typescript" or ft == "typescriptreact" then
                    if vim.fn.executable("bun") == 1 then
                        run_in_float("bun \"" .. file .. "\"")
                    elseif vim.fn.executable("tsx") == 1 then
                        run_in_float("tsx \"" .. file .. "\"")
                    else
                        run_in_float("npx tsx \"" .. file .. "\"")
                    end
                elseif ft == "sh" or ft == "bash" then
                    run_in_float("bash \"" .. file .. "\"")
                elseif ft == "lua" then
                    run_in_float("nvim -l \"" .. file .. "\"")
                else
                    vim.notify("No runner configured for filetype: " .. ft, vim.log.levels.WARN)
                end
            end, { desc = "Run: Execute current file (Float)" })

            -- Multi-Language Test Runner (<leader>rt)
            vim.keymap.set("n", "<leader>rt", function()
                local ft = vim.bo.filetype
                if ft == "rust" then
                    local cargo_toml = find_marker("Cargo.toml")
                    if cargo_toml then
                        run_in_float("cargo test --manifest-path \"" .. cargo_toml .. "\" -- --nocapture")
                    else
                        run_in_float("cargo test -- --nocapture")
                    end
                elseif ft == "go" then
                    local go_mod = find_marker("go.mod")
                    if go_mod then
                        local pkg_dir = vim.fs.dirname(go_mod)
                        run_in_float("cd \"" .. pkg_dir .. "\" && go test -v ./...")
                    else
                        run_in_float("go test -v ./...")
                    end
                elseif ft == "python" then
                    local pdir = find_marker("pyproject.toml") or find_marker("setup.py")
                    if pdir then
                        local root = vim.fs.dirname(pdir)
                        run_in_float("cd \"" .. root .. "\" && pytest -v")
                    elseif vim.fn.executable("pytest") == 1 then
                        run_in_float("pytest -v")
                    else
                        run_in_float("python3 -m unittest discover -v")
                    end
                elseif ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
                    local pkg = find_marker("package.json")
                    if pkg then
                        local root = vim.fs.dirname(pkg)
                        run_in_float("cd \"" .. root .. "\" && npm test")
                    else
                        run_in_float("npm test")
                    end
                else
                    -- Default to CMake CTest
                    if vim.fn.isdirectory("build") == 1 then
                        run_in_float("ctest --test-dir build --output-on-failure")
                    else
                        run_in_float("ctest --output-on-failure")
                    end
                end
            end, { desc = "Run: Run test suite (Float)" })

            -- AddressSanitizer (<leader>ra) for C/C++
            vim.keymap.set("n", "<leader>ra", function()
                local file = vim.fn.expand("%:p")
                local output = vim.fn.expand("%:p:r") .. "_asan"
                local ft = vim.bo.filetype
                local c_comp = (vim.fn.executable("gcc") == 1) and "gcc" or "clang"
                local cpp_comp = (vim.fn.executable("g++") == 1) and "g++ -std=c++20" or "clang++ -std=c++20"

                if ft == "c" then
                    run_in_float(c_comp .. " -fsanitize=address,undefined -g -O1 -Wall -Wextra \"" .. file .. "\" -o \"" .. output .. "\" && \"" .. output .. "\"")
                elseif ft == "cpp" then
                    run_in_float(cpp_comp .. " -fsanitize=address,undefined -g -O1 -Wall -Wextra \"" .. file .. "\" -o \"" .. output .. "\" && \"" .. output .. "\"")
                else
                    vim.notify("AddressSanitizer is only for C and C++ files", vim.log.levels.WARN)
                end
            end, { desc = "Run: Compile & run with ASan (Float)" })

            -- Valgrind memory leak check (<leader>rv)
            vim.keymap.set("n", "<leader>rv", function()
                local file = vim.fn.expand("%:p")
                local output = vim.fn.expand("%:p:r")
                local ft = vim.bo.filetype
                local c_comp = (vim.fn.executable("gcc") == 1) and "gcc" or "clang"
                local cpp_comp = (vim.fn.executable("g++") == 1) and "g++ -std=c++20" or "clang++ -std=c++20"

                if vim.fn.executable("valgrind") == 1 then
                    if ft == "c" or ft == "cpp" then
                        local compiler = (ft == "c") and c_comp or cpp_comp
                        run_in_float(compiler .. " -g -O0 \"" .. file .. "\" -o \"" .. output .. "\" && valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes \"" .. output .. "\"")
                    else
                        local bin = vim.fn.input("Executable for Valgrind: ", vim.fn.getcwd() .. "/build/", "file")
                        if bin ~= "" then
                            run_in_float("valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes \"" .. bin .. "\"")
                        end
                    end
                elseif vim.fn.has("mac") == 1 then
                    vim.notify("Valgrind is not available on macOS. Running with AddressSanitizer instead...", vim.log.levels.INFO)
                    if ft == "c" or ft == "cpp" then
                        local compiler = (ft == "c") and c_comp or cpp_comp
                        run_in_float(compiler .. " -fsanitize=address,undefined -g -O1 \"" .. file .. "\" -o \"" .. output .. "\" && \"" .. output .. "\"")
                    end
                else
                    vim.notify("Valgrind is not installed. Install valgrind to use memory leak checking.", vim.log.levels.WARN)
                end
            end, { desc = "Run: Check memory leaks with Valgrind (Float)" })

            -- Quick Make in project (<leader>rm)
            vim.keymap.set("n", "<leader>rm", "<cmd>make<CR>", { desc = "Run: Execute Make" })
        end,
    },
}
