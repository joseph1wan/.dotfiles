local ts = require("nvim-treesitter")

local parsers = {
  "lua", "vim", "vimdoc", "python", "go", "javascript", "typescript",
  "tsx", "json", "yaml", "html", "dockerfile", "graphql", "bash", "markdown",
}

for _, parser in ipairs(parsers) do
  ts.install(parser)
end

local patterns = {}
for _, parser in ipairs(parsers) do
  for _, ft in ipairs(vim.treesitter.language.get_filetypes(parser)) do
    table.insert(patterns, ft)
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = patterns,
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
