return {
  "catppuccin/nvim",
  name = "catppuccin",
  opts = {
    flavour = "mocha",
    transparent_background = true,
    color_overrides = {
      all = {
        text = "#ffffff",
      },
      mocha = {
        base = "#000000",
        --         		base = "#12121a",
        --         		mantle = "#12121a",
        --         		crust = "#12121a",
      },
    },
  },
  vim.keymap.set("n", "<leader>A", function()
    local cat = require "catppuccin"
    cat.options.transparent_background = not cat.options.transparent_background
    cat.compile()
    vim.cmd.colorscheme "catppuccin-mocha"
  end),
}
