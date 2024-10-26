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
    local conda_env = os.getenv "CONDA_PREFIX"
    local command
    if conda_env then
      command = string.format("%s/bin/python", conda_env)
    else
      local virtual_env = os.getenv "VIRTUAL_ENV"
      command = virtual_env and string.format("%s/bin/python", virtual_env) or "python"
    end

    require("dap-python").setup(command)
    -- Register DAP-related key mappings with which-key and descriptions
    --
    -- Register DAP-related key mappings with which-key and descriptions
    local wk = require "which-key"

    wk.add {
      { "<F5>", "<cmd>DapContinue<cr>", desc = "Continue Debugging" },
      { "<F10>", "<cmd>DapStepOver<cr>", desc = "Step Over" },
      { "< F11 >", "<cmd>DapStepInto<cr>", desc = "Step Into" },
      { "<F12>", "<cmd>DapStepOut<cr>", desc = "Step Out" },
      { "<leader>D", group = "DAP" },

      { "<leader>Db", group = "Breakpoint" },

      { "<leader>Dbt", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
      {
        "<leader>Dbc",
        '<cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))<CR>',
        desc = "Set Breakpoint Condition",
      },
      {
        "<leader>Dl",
        '<cmd>lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
        desc = "Set Log Point",
      },
      { "<leader>Do", '<cmd>lua require("dap").repl.open()<CR>', desc = "Open REPL" },

      { "<leader>Dr", '<cmd>lua require("dap").run_last()<CR>', desc = "Run Last" },
      { "<leader>Dt", '<cmd>lua require("dap").toggle()<CR>', desc = "Toggle DAP UI" },
      -- ["<leader>D"] = {
      --   name = "Debugging",
      --   b = { ":DapToggleBreakpoint<CR>", "Toggle Breakpoint" },
      --   B = {
      --     ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))<CR>',
      --     "Set Breakpoint Condition",
      --   },
      --   lp = {
      --     ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
      --     "Set Log Point",
      --   },
      --   r = { ':lua require("dap").repl.open()<CR>', "Open REPL" },
      --   l = { ':lua require("dap").run_last()<CR>', "Run Last" },
      --   o = { ':lua require("dapui").toggle()<CR>', "Toggle DAP UI" },
      -- },
    }

    require("dapui").setup {
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
