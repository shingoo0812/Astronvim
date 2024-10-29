-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        -- "lua_ls",
        "omnisharp",
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
    config = function()
      require("lspconfig").omnisharp.setup {
        cmd = {
          "dotnet",
          "/home/shingo/omnisharp-roslyn/bin/Debug/OmniSharp.Roslyn/net6.0/OmniSharp.Roslyn.dll", -- Adjust this path as needed
          -- "~/.cache/omnisharp-vim/omnisharp-roslyn/OmniSharp.Roslyn.dll",
        },
        -- Additional settings can go here
        useGlobalMono = "never", -- Ensure it uses .NET 6 SDK
      }
    end,
  },
}
