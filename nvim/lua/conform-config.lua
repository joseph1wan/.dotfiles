require("conform").setup({
  formatters_by_ft = {
    -- Minimal starter entry — extend once per-project formatters are
    -- confirmed, in the later LSP/tooling follow-up.
    lua = { "stylua" },
  },
  -- Manual-format only for now (keymap lives in plugins.lua);
  -- add format_on_save here once formatters_by_ft is fleshed out.
})
