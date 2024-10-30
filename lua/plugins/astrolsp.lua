-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
          "cs",
          "lua_ls",
          "lua",
          "sh",
          "python",
          "gdscript",
          "godot_resource",
          "gdshader",
          "glsl",
          "html",
          "zsh",
          ".zshrc",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 2000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
      -- "omnisharp",
    },
    -----------------------------------------------------------------------------------
    -- customize language server configuration options passed to `lspconfig`
    -----------------------------------------------------------------------------------
    ---@diagnostic disable: missing-fields
    config = {
      clangd = { capabilities = { offsetEncoding = "utf-8" } },
      omnisharp = {
        capabilities = { offsetEncoding = "utf-8" },
        -- UnitySetting
        settings = {
          omnisharp = {
            useModernNet = true, --[[ enableRoslynAnalyzers = false ]]
          },
          -- omnisharp_mono = {
          --   useModernNet = true, --[[ enableRoslynAnalyzers = false ]]
          -- },
        },
      },

      zsh = { capabilities = { offsetEncoding = "utf-8" } },
      lua_lsp = { capabilities = { offsetEncoding = "utf-8" } },
      gdscript = { capabilities = { offsetEncoding = "utf-8" } },
    },
    -----------------------------------------------------------------------------------
    -- customize how language servers are attached
    -----------------------------------------------------------------------------------
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
      --
      --Zls
      zsh = function(_, opts)
        opts.cmd = {
          "~/.local/share/nvim/mason/packages/beautysh",
          "--languageserver",
          "--hostPID",
          tostring(vim.fn.getpid()),
        }
        require("lspconfig").zls.setup(opts)
      end,
      -- Unity
      omnisharp = function(_, opts)
        -- Custom configuration of omni sharp server
        opts.cmd = {
          -- "/home/shingo/omnisharp-roslyn/bin/Debug/OmniSharp.Roslyn/net6.0/OmniSharp.Roslyn.dll",
          "dotnet",
          "--languageserver",
          "--hostPID",
          tostring(vim.fn.getpid()),
        }
        require("lspconfig").omnisharp.setup(opts)
      end,
    },
    -----------------------------------------------------------------------------------
    -- Configure buffer local auto commands to add when attaching a language server
    -----------------------------------------------------------------------------------
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    -----------------------------------------------------------------------------------
    -- mappings to be set up on attaching of a language server
    -----------------------------------------------------------------------------------
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    -- on_attach = function(client, bufnr)
    -- this would disable semanticTokensProvider for all clients
    -- client.server_capabilities.semanticTokensProvider = nil
    -- end,
    -----------------------------------------------------------------------------------
    -- Custom on_attach function for Unity Projects
    -- If it is Unity Projects, set useModernNet to false.
    -----------------------------------------------------------------------------------
    on_attach = function(client, bufnr)
      local capabilities = client.server_capabilities
      local common = require "user.common" -- Common function calls
      if capabilities.textDocument and capabilities.textDocument.completion then
        capabilities.textDocument.completion.completionItem.snippetSupport = true
      else
        -- print "Completion capabilities not available for this LSP client."
      end

      local completion_items = common.get_completion_items()

      require("cmp").register_source("user_functions", {
        complete = function(_, _, callback) callback(completion_items) end,
      })

      local is_unity_project = vim.fn.glob "ProjectSettings/ProjectVersion.txt" ~= "" -- If it is not null
      if is_unity_project then
        client.config.settings.omnisharp.useModernNet = false
        client.notify "workspace/didChangeConfiguration"
        vim.cmd "ModifyCSProjFile"
      end
    end,
    -----------------------------------------------------------------------------------
    -- Modify Unity Configuration. Change to unix notation folder path.
    -----------------------------------------------------------------------------------
    vim.cmd [[
      command! ModifyCSProjFile call ModifyCSProjFile()
      function! ModifyCSProjFile()
          call system("find . -maxdepth 2 -name \"*.csproj\" | xargs sed -i -e 's/C:/\\/mnt\\/c/g'")
          call system("find . -maxdepth 2 -name \"*.csproj\" | xargs sed -i -e 's/D:/\\/mnt\\/d/g'")
          if exists(':YcmCompleter')
              execute "YcmCompleter ReloadSolution"
          endif
      endfunction
    ]],
  },
}
