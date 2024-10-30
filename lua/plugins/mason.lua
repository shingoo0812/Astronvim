-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "omnisharp",
        "zls",
        -- add more arguments for adding more language servers
      },
    },
  },

  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "zls",
        -- add more arguments for adding more null-ls sources
      },
    },
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        -- "unity",
        -- add more arguments for adding more debuggers
      },
    },
  },

  -- lspconfig setup for omnisharp
  {
    "neovim/nvim-lspconfig",
  },
}
