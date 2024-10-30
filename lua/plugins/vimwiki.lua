return {
  "vimwiki/vimwiki",
  config = function()
    -- Vimwikiの設定
    vim.g.vimwiki_list = {
      {
        path = "~/dotfiles/vimwiki/", -- vimwiki directory path
        path_html = "~/dotfiles/vimwiki_html/",
        syntax = "markdown", -- Sentences to use
        ext = ".md", -- Extend files
      },
    }
  end,
  event = "VimEnter",
}
