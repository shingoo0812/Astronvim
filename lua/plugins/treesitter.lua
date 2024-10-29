-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "c",
      "c_sharp",
      "gdscript",
      "godot_resource",
      "gdshader",
      "glsl",
      "html",
      -- add more arguments for adding more treesitter parsers
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = false },
  },
}
