-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = {
        "lua_ls",
        -- add more arguments for adding more language servers
      },
    },
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = {
      ensure_installed = {
        "stylua",
        -- add more arguments for adding more null-ls sources
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      ensure_installed = {
        "unity",
        -- add more arguments for adding more debuggers
      },
      -- handlers = {
      --   function(config)
      --     -- all sources with no handler get passed here
      --
      --     -- Keep original functionality
      --     require("mason-nvim-dap").default_setup(config)
      --   end,
      --   unity = function(config)
      --     config.adapters = {
      --       type = "executable",
      --       command = "/usr/bin/mono",
      --       args = {
      --         "/path/to/UnityDebug.exe",
      --       },
      --     }
      --     config.configurations = {
      --       {
      --         type = "unity",
      --         request = "launch",
      --         name = "Unity Editor",
      --         program = function() return vim.fn.input("Path to Unity project: ", vim.fn.getcwd(), "file") end,
      --         args = {
      --           "-projectPath",
      --           vim.fn.getcwd(),
      --         },
      --       },
      --     }
      --   end,
      -- },
    },
  },
}
