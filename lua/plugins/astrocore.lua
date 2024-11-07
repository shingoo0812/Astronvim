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
      shell = "/usr/bin/zsh",
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
        encoding = "utf-8",
        fileencodings = "utf-8",
        fileencoding = "utf-8",
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        OmniSharp_server_use_net6 = 1,
      },
    },
    ale_linters = {
      cs = { "OmniSharp" },
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
        ["<leader>s<"] = {
          ":%s/<<C-r><C-w>>/<C-r><C-w>/gI<Left><Left><Left><cr>gc",
          desc = "Search And Replace The Word Under The Cursor",
        },
        ["<leader>s("] = {
          ":%s/(<C-r><C-w>)/<C-r><C-w>/gI<Left><Left><Left><cr>gc",
          desc = "Search And Replace The Word Under The Cursor",
        },

        ["<leader>trp"] = { "<cmd>Pantran<cr>", desc = "Launch Pantran for translation" },
        -- pane Resize
        ["<A-n>"] = { ":vertical resize +2<cr>", desc = "resize pane to left" },
        ["<A-.>"] = { ":vertical resize -2<cr>", desc = "resize pane to right" },
        ["<A-m>"] = { ":resize -2<cr>gc", desc = "resize pane to up" },
        ["<A-,>"] = { ":resize +2<cr>gc", desc = "resize pane to down" },
        ["<A-=>"] = { "<C-w>=", desc = "Resize equal" },
        -- split
        ["<A-]>"] = { "<C-w>v", desc = "Split window vertically" },
        ["<A-[>"] = { "<C-w>s", desc = "Split window horizontally" },
        -- Copilot
        ["<leader>k"] = { "", desc = "Copilot" },
        ["<C-[>"] = { ":Copilot suggestion<cr>gc", desc = "Copilot suggestion" },
        ["<leader>kc"] = { "<cmd>CopilotChat<cr>", desc = "CopilotChat open" },
        ["<leader>kx"] = { "<cmd>CopilotChatClose<cr>", desc = "CopilotChat close" },
        ["<leader>kf"] = { "<cmd>CopilotChatFix<cr>", desc = "CopilotChatFix open" },
        -- Move Line
        ["<A-J>"] = { "<CMD>MOVE .+1<cr>==" },
        ["<A-k>"] = { "<Cmd>move .-2<cr>==" },
        ["<C-a>"] = { "^", desc = "Move to head" },
        ["<C-e>"] = { "$", desc = "Move to end" },
        -- Keymaps for diffget. Useful when resolving conflicts
        ["<gh>"] = { "<Cmd>diffget //2<cr>gc", desc = "Grab changes from the left (LOCAL)" },
        ["<gl>"] = { "<Cmd>diffget //3<cr>gc", desc = "Grab changes from the right (INCOMING)" },
        ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
        ["<leader>gv"] = { "<cmd>e ~/dotfiles/linux/nvim<cr>", desc = "Open Nvim conf location" },
        ["<leader>gz"] = { "<cmd>e ~/dotfiles/linux/zsh<cr>", desc = "Open zsh conf location" },
        ["<leader>gh"] = { "<cmd>e ~/dotfiles/<cr>", desc = "Open dotfiles location" },
        ["<leader>lc"] = {
          "<cmd>redir > ./message.txt | silent messages | redir END<CR>",
          desc = "Save messages to message.txt",
        },
        ["<leader>r"] = { "<cmd>:AstroReload<cr>", desc = "Astro Reload" },
      },
      v = {
        ["d"] = { '"_d' },
      },
      i = {
        ["jk"] = { "<esc>", desc = "Normal Mode" },
        ["<C-o>"] = { "<esc>o", desc = "Go to normal mode, create new line" },
        ["<C-a>"] = { "<esc>^", desc = "Move to head" },
        ["<C-e>"] = { "<esc>$", desc = "Move to end" },
        ["<C-h>"] = { "<Left>", desc = "Move to right" },
        ["<C-j>"] = { "<Down>", desc = "Move to down" },
        ["<C-k>"] = { "<Up>", desc = "Move to up" },
        ["<C-l>"] = { "<Right>", desc = "Move to left" },
      },
      x = {
        -- Move Line
        ["<A-k>"] = { ":move '<-2<cr>gcgv=gv" },
        ["<C-a>"] = { "^", desc = "Move to head" },
        ["<C-e>"] = { "$h", desc = "Move to end" },
        ["<A-j>"] = { ":move '>+1<cr>gcgv=gv" },
      },
    },
  },
}
