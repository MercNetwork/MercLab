-- ~/.config/nvim/lua/mercury/plugins/lsp/completion.lua

return {
  {
    "aznhe21/actions-preview.nvim",
    keys = {
      {
        "<leader>ca",
        function()
          require("actions-preview").code_actions()
        end,
        desc = "Code Action",
        mode = { "n", "v" },
      },
    },
    opts = {
      backend = { "nui" },
    },
  },
}
