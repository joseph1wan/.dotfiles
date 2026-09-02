local lint = require("lint")

-- Empty until specific linters are confirmed installed for your projects.
lint.linters_by_ft = {}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
  callback = function() lint.try_lint() end,
})
