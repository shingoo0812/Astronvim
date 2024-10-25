return {
  --Changing keymaps that conflict with surround
  require("nvim-surround").setup {
    keymaps = {
      visual = "gs",
    },
  },
}
