return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  event = "User AstroFile",
  cmd = { "TodoQuickFix" },
  keys = {
    { "<leader>T", "<cmd>TodoTelescope<cr>", desc = "Open TODOs in Telescope" },
  },
}
