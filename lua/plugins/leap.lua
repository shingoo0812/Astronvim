return {
  "ggandor/leap.nvim",
  config = function()
    local wk = require "which-key"
    wk.add {
      mode = { "n", "x" },
      { "s", "<Plug>(leap-forward-to)", desc = "Leap forward to" },
      { "S", "<Plug>(leap-backward-to)", desc = "Leap backward to" },
    }
  end,
}
