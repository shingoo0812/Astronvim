return {
  "voldikss/vim-translator",
  config = function()
    local keys = {
      { "<leader>tr", "", desc = "Translate Replace" },
      -- Replace to Japanese
      {
        "<leader>trj",
        function()
          vim.api.nvim_feedkeys("vg_", "n", false)
          -- Execute the conversion command after a short delay.
          vim.defer_fn(function() vim.api.nvim_feedkeys(":TranslateR --target_lang=ja\n", "n", false) end, 100) -- 100ms delay
        end,
        mode = "n",
        desc = "Replace to Japanese",
      },
      -- Replace to English
      {
        "<leader>tre",
        function()
          vim.api.nvim_feedkeys("vg_", "n", false)
          -- Run translator command after a short delay
          vim.defer_fn(function() vim.api.nvim_feedkeys(":TranslateR --target_lang=en\n", "n", false) end, 100) -- 100ms delay
        end,
        mode = "n",
        desc = "Replace to English",
      },
      { "<leader>tre", ":'<,'>TranslateR --target_lang=en<CR>", mode = "v", desc = "Replace to English" },
    }

    for _, key in ipairs(keys) do
      local mode = key.mode or "n" -- Default is normal mode
      vim.keymap.set(mode, key[1], key[2], { desc = key.desc })
    end
  end,
}
