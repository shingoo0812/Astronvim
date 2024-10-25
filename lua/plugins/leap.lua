return {
  "ggandor/leap.nvim",
  config = function()
    local leap = require "leap"

    vim.keymap.set(
      "x",
      "S",
      function() leap.leap { target_windows = { vim.fn.win_getid() }, inclusive_up = true } end,
      { silent = true }
    )
    vim.keymap.set(
      "x",
      "s",
      function() leap.leap { target_windows = { vim.fn.win_getid() }, inclusive_op = true } end,
      { silent = true }
    )
  end,
}
