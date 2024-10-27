return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "mxsdev/nvim-dap-vscode-js",
    "mfussenegger/nvim-dap-python",
    {
      "microsoft/vscode-js-debug",
      build = "npm install --legacy-peer-deps && npm run compile",
    },
  },
  lazy = true,
  config = function()
    local dap, dapui = require "dap", require "dapui"
    -- If using nvim dap, start dapui automatically
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    -- Change path for conda environment or virtual environment
    local function get_conda_executable(bin_name)
      local conda_env = os.getenv "CONDA_PREFIX"
      local home = string.format("%s/miniconda3", os.getenv "HOME")
      if conda_env and conda_env ~= home then
        print "Using Conda Environment"
        print(home)
        return string.format("%s/bin/%s", conda_env, bin_name)
      elseif virtual_env then
        print "Using Virtual Environment"
        return string.format("%s/bin/%s", virtual_env, bin_name)
      else
        print "Using System Python"
        print(bin_name)
        return bin_name
      end
    end

    -- Python dap configuration
    local python_command = get_conda_executable "python"
    require("dap-python").setup(python_command)

    -- Debugger settings for each language
    local debug_configs = {
      cpp = function()
        dap.adapters.cppdbg = {
          id = "cppdbg",
          type = "executable",
          command = get_conda_executable "lldb-vscode", -- using lldb in conda
        }
        dap.configurations.cpp = {
          {
            name = "Launch C++",
            type = "cppdbg",
            request = "launch",
            program = "${fileDirname}/${fileBasenameNoExtension}",
            cwd = "${workspaceFolder}",
            stopOnEntry = true,
            args = {},
          },
        }
      end,

      cs = function()
        dap.adapters.coreclr = {
          type = "executable",
          command = get_conda_executable "netcoredbg", -- using netcoredbg in conda
          args = { "--interpreter=vscode" },
        }
        dap.configurations.cs = {
          {
            type = "coreclr",
            name = "Launch - netcoredbg",
            request = "launch",
            -- program = ${file},
            program = function()
              return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
              -- return vim.fn.input "Path to dll: "
              -- return "/mnt/h/Work/Programming/C#/Tutorial/bin/Debug/net8.0/Tutorial.dll"
            end,
            env = {

              ASPNETCORE_ENVIRONMENT = function() return vim.fn.input("ASPNETCORE_ENVIRONMENT: ", "Development") end,
              ASPNETCORE_URLS = function()
                -- todo: request input from ui
                return "http://localhost:5050"
              end,
            },
            cwd = function() return vim.fn.input("Workspace folder: ", vim.fn.getcwd() .. "/", "file") end,
          },
        }
      end,

      unity = function()
        local vstuc_path = "/mnt/c/Users/shing/.vscode/extensions/visualstudiotoolsforunity.vstuc-1.0.4/bin/"
        dap.adapters.vstuc = {
          type = "executable",
          command = "dotnet",
          args = { vstuc_path .. "UnityDebugAdapter.dll", "--project", vim.fn.getcwd() .. "/Assembly-CSharp.csproj" },

          name = "Attach to Unity",
        }
        dap.configurations.cs = {
          {
            type = "vstuc",
            request = "attach",
            name = "Attach to Unity",
            logFile = vim.fs.joinpath(vim.fn.stdpath "data") .. "/vstuc.log",
            projectPath = function()
              local path = vim.fn.expand "%:p"
              while true do
                local new_path = vim.fn.fnamemodify(path, ":h")
                if new_path == path then return "" end
                path = new_path
                local assets = vim.fn.glob(path .. "/Assets")
                if assets ~= "" then return path end
              end
            end,
            endPoint = function()
              local system_obj = vim.system({ "dotnet", vstuc_path .. "UnityAttachProbe.dll" }, { text = true })
              local probe_result = system_obj:wait(2000).stdout
              if probe_result == nil or #probe_result == 0 then
                print "No endpoint found (is unity running?)"
                return ""
              end
              for json in vim.gsplit(probe_result, "\n") do
                if json ~= "" then
                  local probe = vim.json.decode(json)
                  for _, p in pairs(probe) do
                    if p.isBackground == false then return p.address .. ":" .. p.debuggerPort end
                  end
                end
              end
              return ""
            end,
          },
        }
        -- dap.adapters.unity = {
        --   type = "executable",
        --   -- command = get_conda_executable "omnisharp-mono",
        --   command = "/home/vpam/.cache/omnisharp-vim/omnisharp-roslyn/run",
        --   args = {
        --     "/mnt/c/Users/shing/.vscode/extensions/visualstudiotoolsforunity.vstuc-1.0.4/bin/UnityDebugAdapter.dll",
        --
        --     -- "/mnt/c/Users/shing/.vscode/extensions/shinganeuler.vscode-unity-debug-3.0.13/External/MonoDevelop.Debugger.dll",
        --     --
        --   },
        -- }
        --
        -- dap.configurations.cs = {
        --   {
        --     type = "unity",
        --     request = "attach",
        --     name = "Unity Editor",
        --     path = vim.fn.getcwd() .. "/Library/EditorInstance.json",
        --   },
        -- }
      end,

      -- JavaScript and TypeScript DAP Configuration
      javascript = function()
        require("dap-vscode-js").setup {
          node_path = "node",
          debugger_path = vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter",
          adapters = { "pwa-node" },
        }
      end,

      typescript = function()
        dap.configurations.typescript = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end,

      go = function()
        dap.adapters.go = {
          type = "server",
          port = "${port}",
          executable = {
            command = "dlv",
            args = { "dap", "-l", "127.0.0.1:${port}" },
          },
        }

        dap.configurations.go = {
          {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${file}",
          },
        }
      end,
    }

    -- Setting up debuggers for each language
    local function setup_debugger(language)
      if debug_configs[language] then
        debug_configs[language]()
      else
        print("Debugger configuration for " .. language .. " not found.")
      end
    end

    -- Set up a debugger for the language you need
    setup_debugger "cpp"
    setup_debugger "cs"
    setup_debugger "unity"
    setup_debugger "javascript"
    setup_debugger "typescript"
    setup_debugger "go"

    -- Register DAP-related key mappings with which-key and descriptions
    -- local wk = require "which-key"
    --
    -- wk.add {
    --   { "<F5>", "<cmd>DapContinue<cr>", desc = "Continue Debugging" },
    --   { "<F10>", "<cmd>DapStepOver<cr>", desc = "Step Over" },
    --   { "<F11>", "<cmd>DapStepInto<cr>", desc = "Step Into" },
    --   { "<F12>", "<cmd>DapStepOut<cr>", desc = "Step Out" },
    --   { "<leader>D1", "<cmd>DapContinue<cr>", desc = "Continue Debugging" },
    --   { "<leader>D2", "<cmd>DapStepOver<cr>", desc = "Step Over" },
    --   { "<leader>D3", "<cmd>DapStepInto<cr>", desc = "Step Into" },
    --   { "<leader>D4", "<cmd>DapStepOut<cr>", desc = "Step Out" },
    --   { "<M-k>", '<cmd>lua require("dapui").eval()<cr>', desc = "Dapui Eval" },
    --   { "<leader>D", group = "DAP" },
    --   { "<leader>Db", group = "Breakpoint" },
    --   { "<leader>Dbt", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
    --   {
    --     "<leader>Dbc",
    --     '<cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))<CR>',
    --     desc = "Set Breakpoint Condition",
    --   },
    --   {
    --     "<leader>Dl",
    --     '<cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
    --     desc = "Set Log Point",
    --   },
    --   { "<leader>Do", "<cmd>lua dap.repl.open()<CR>", desc = "Open REPL" },
    --   { "<leader>Dr", "<cmd>lua dap.run_last()<CR>", desc = "Run Last" },
    --   { "<leader>dt", "<cmd>lua dapui.toggle()<cr>", desc = "toggle dap ui" },
    -- }
    --
    -- DAP UI
    dapui.setup {
      icons = { expanded = "▾", collapsed = "▸" },
      layouts = {
        {
          elements = {
            { id = "watches", size = 0.20 },
            { id = "stacks", size = 0.20 },
            { id = "breakpoints", size = 0.20 },
            { id = "scopes", size = 0.40 },
          },
          size = 64,
          position = "right",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.20,
          position = "bottom",
        },
      },
    }
  end,
}
