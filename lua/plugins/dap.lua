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
    vim.api.nvim_set_keymap("n", "<F5>", ":DapContinue<CR>", { silent = true, noremap = true })
    vim.api.nvim_set_keymap("n", "<F10>", ":DapStepOver<CR>", { silent = true, noremap = true })
    vim.api.nvim_set_keymap("n", "<F11>", ":DapStepInto<CR>", { silent = true, noremap = true })
    vim.api.nvim_set_keymap("n", "<F12>", ":DapStepOut<CR>", { silent = true, noremap = true })
    vim.api.nvim_set_keymap("n", "<leader>Db", ":DapToggleBreakpoint<CR>", { silent = true, noremap = true })
    vim.api.nvim_set_keymap(
      "n",
      "<leader>B",
      ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))<CR>',
      { silent = true, noremap = true }
    )
    vim.api.nvim_set_keymap(
      "n",
      "<leader>lp",
      ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
      { silent = true, noremap = true }
    )
    vim.api.nvim_set_keymap("n", "<leader>Dr", ':lua require("dap").repl.open()<CR>', { silent = true, noremap = true })
    vim.api.nvim_set_keymap("n", "<leader>Dl", ':lua require("dap").run_last()<CR>', { silent = true, noremap = true })
    vim.api.nvim_set_keymap("n", "<leader>Do", ':lua require("dapui").toggle()<CR>', { noremap = true })
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
