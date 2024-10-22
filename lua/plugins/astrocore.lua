-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
      swapfile = true, -- enable swapfile at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = true, -- sets vim.opt.wrap
        shiftwidth = 4,
        tabstop = 4,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        ["d"] = { '"_d' },
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["H"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Next buffer" },
        ["L"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Previous buffer" },
        --
        -- mappings seen under group name "Buffer"
        ["<C-w>"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        -- Search and Replace
        ["<leader>sr"] = {
          ":%s/<<C-r><C-w>>/<C-r><C-w>/gI<Left><Left><Left><cr>gc",
          desc = "Search And Replace The Word Under The Cursor",
        },
        -- pane Resize
        ["<A-n>"] = { ":vertical resize +2<cr>", desc = "resize pane to left" },
        ["<A-.>"] = { ":vertical resize -2<cr>", desc = "resize pane to right" },
        ["<A-m>"] = { ":resize -2<cr>gc", desc = "resize pane to up" },
        ["<A-,>"] = { ":resize +2<cr>gc", desc = "resize pane to down" },
        ["<A-=>"] = { "<C-w>=", desc = "Resize equal" },
        -- split
        ["<A-v>"] = { "<C-w>v", desc = "Split window vertically" },
        ["<A-s>"] = { "<C-w>s", desc = "Split window horizontally" },
        -- Copilot
        ["<C-[>"] = { ":Copilot suggestion<cr>gc", desc = "Copilot suggestion" },
        ["<leader>k"] = { "", desc = "Copilot" },
        ["<leader>kc"] = { "<cmd>CopilotChat<cr>", desc = "CopilotChat open" },
        ["<leader>kx"] = { "<cmd>CopilotChatClose<cr>", desc = "CopilotChat close" },
        ["<leader>kf"] = { "<cmd>CopilotChatFix<cr>", desc = "CopilotChatFix open" },

        -- Move Line
        ["<A-J>"] = { "<CMD>MOVE .+1<cr>==" },
        ["<A-k>"] = { "<Cmd>move .-2<cr>==" },
        -- Keymaps for diffget. Useful when resolving conflicts
        ["<gh>"] = { "<Cmd>diffget //2<cr>gc", desc = "Grab changes from the left (LOCAL)" },
        ["<gl>"] = { "<Cmd>diffget //3<cr>gc", desc = "Grab changes from the right (INCOMING)" },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },
        ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
        -- TODO : create ssh-keygen command
      },
      v = {
        ["d"] = { '"_d' },
      },
      i = {
        ["jk"] = { "<esc>", desc = "Normal Mode" },
        ["<C-o>"] = { "<esc>o", desc = "Go to normal mode, create new line" },
      },
      x = {
        -- Move Line
        ["<A-j>"] = { ":move '>+1<cr>gcgv=gv" },
        ["<A-k>"] = { ":move '<-2<cr>gcgv=gv" },
      },
    },
  },
}