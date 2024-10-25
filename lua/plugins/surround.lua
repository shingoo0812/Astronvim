return {
  "kylechui/nvim-surround",
  config = function()
    --Changing keymaps that conflict with surround
    require("nvim-surround").setup {
      keymaps = {
        visual = "gs",
      },
    }
  end,
}
