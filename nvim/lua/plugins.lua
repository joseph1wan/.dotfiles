local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n" .. out, "ErrorMsg" } }, true, {})
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },

    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      build = ":TSUpdate",
      lazy = false,
      config = function() require("treesitter-config") end,
    },

    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function() require("telescope-config") end,
      keys = {
        { "<C-p>", function() require("telescope.builtin").find_files() end, desc = "Find files" },
        { "\\", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
        { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
        { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
      },
    },

    {
      "stevearc/conform.nvim",
      cmd = { "ConformInfo" },
      keys = {
        { "<leader>f", function() require("conform").format({ async = true, lsp_fallback = true }) end,
          mode = { "n", "v" }, desc = "Format buffer/selection" },
      },
      config = function() require("conform-config") end,
    },

    {
      "mfussenegger/nvim-lint",
      event = { "BufReadPost", "BufNewFile", "BufWritePost" },
      config = function() require("lint-config") end,
    },
  },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false },
})
