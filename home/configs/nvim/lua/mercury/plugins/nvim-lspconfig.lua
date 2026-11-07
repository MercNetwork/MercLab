-- ~/.config/nvim/lua/mercury/plugins/lsp/nvim-lspconfig.lua

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo" },

    dependencies = {
      "saghen/blink.cmp",
    },

    keys = {
      -- ------------------------------------------------------------
      -- 1. LSP Navigation & Information (Standard Mappings)
      -- ------------------------------------------------------------
      { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
      { "gi", vim.lsp.buf.implementation, desc = "Go to Implementation" },
      { "gt", vim.lsp.buf.type_definition, desc = "Go to Type Definition" },

      -- ------------------------------------------------------------
      -- 3. Diagnostics & Error Handling Inline Overlays
      -- ------------------------------------------------------------
      { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics Modal" },
      {
        "[d",
        function()
          vim.diagnostic.jump({ count = -1, float = true })
        end,
        desc = "Previous Diagnostic",
      },
      {
        "]d",
        function()
          vim.diagnostic.jump({ count = 1, float = true })
        end,
        desc = "Next Diagnostic",
      },

      -- ------------------------------------------------------------
      -- 4. UI Layer / Workspace Feature Toggles (<leader>u)
      -- ------------------------------------------------------------
      {
        "<leader>uh",
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
          vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
        end,
        desc = "Toggle Inlay Hints",
      },
    },

    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.diagnostic.config({
        float = {
          border = "rounded",
          source = "if_many",
        },
      })

      local servers = {
        -- ------------------------------------------------------------
        -- Systems & Compiled Languages
        -- ------------------------------------------------------------
        clangd = { filetypes = { "c", "cpp" } },
        jdtls = {},
        gopls = {
          filetypes = { "go" },
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              analyses = {
                unusedparams = true,
              },
            },
          },
        },
        rust_analyzer = {
          filetypes = { "rust" },
          settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },

        -- ------------------------------------------------------------
        -- Data & Scientific
        -- ------------------------------------------------------------
        ruff = { filetypes = { "python" } },
        ty = {
          cmd = { "ty", "server" },
          filetypes = { "python" },
          root_markers = { "pyproject.toml", "setup.py", ".git" },
        },
        julials = { filetypes = { "julia" } },
        matlab_ls = {
          filetypes = { "matlab" },
          settings = {
            MATLAB = {
              indexWorkspace = true,
              installPath = "",
            },
          },
          single_file_support = true,
        },

        -- ------------------------------------------------------------
        -- Web & Frontend Ecosystem
        -- ------------------------------------------------------------
        vtsls = {
          filetypes = {
            "javascript",
            "typescript",
            "typescriptreact",
          },
        },
        svelte = {},
        vue_ls = {},
        html = {},
        cssls = {},
        jsonls = {},
        eslint = {},

        -- ------------------------------------------------------------
        -- Document & Typesetting Workspaces
        -- ------------------------------------------------------------
        marksman = { filetypes = { "markdown" } },
        tinymist = {
          filetypes = { "typst" },
          settings = {
            exportPdf = "onSave",
            semanticTokens = "enable",
            formatterMode = "typstyle",
            rootPath = os.getenv("TYPST_ROOT") or vim.fs.root(0, { ".git", "flake.nix" }) or nil,
          },
        },
        texlab = {
          settings = {
            texlab = {
              filetypes = { "tex" },
              settings = {
                texlab = {
                  formatterLineLength = 80,
                  bibtexFormatter = "texlab",
                  latexFormatter = "texlab",
                },
              },
            },
          },
        },

        -- ------------------------------------------------------------
        -- Configuration, Scripting & Data Formats
        -- ------------------------------------------------------------
        nixd = { filetypes = { "nix" } },
        bashls = { filetypes = { "sh", "bash" } },
        dockerls = { filetypes = { "dockerfile" } },
        docker_compose_language_service = { filetypes = { "yaml.docker-compose" } },
        qmlls = { filetypes = { "ini", "qml" } },
        taplo = {},
        nginx_language_server = {},
        yamlls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              hint = { enable = true },
            },
          },
        },
      }

      -- Configure every server, then enable only the ones whose binary is
      -- installed (the `langs.*` Home Manager modules put them on PATH).
      -- Filetypes come from nvim-lspconfig's defaults unless set above.
      for name, cfg in pairs(servers) do
        cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
        vim.lsp.config(name, cfg)

        local resolved = vim.lsp.config[name]
        local cmd = resolved and resolved.cmd
        if type(cmd) == "function" or (type(cmd) == "table" and cmd[1] and vim.fn.executable(cmd[1]) == 1) then
          vim.lsp.enable(name)
        end
      end

      local group = vim.api.nvim_create_augroup("MercuryLsp", { clear = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, {
              bufnr = args.buf,
            })
          end
        end,
      })
    end,
    -- Auto-configure and register every server with Blink capabilities
    -- 1. Inject Blink capabilities into ALL language servers globally
    --   vim.lsp.config("*", {
    --     capabilities = capabilities,
    --   })
    --
    --   -- 2. Register configs and auto-enable them for their filetypes
    --   for name, cfg in pairs(servers) do
    --     vim.lsp.config(name, cfg)
    --     vim.lsp.enable(name)
    --   end
    --
    --   -- Automatic Inlay Hints attachment on support
    --   local group = vim.api.nvim_create_augroup("MercuryLsp", { clear = true })
    --   vim.api.nvim_create_autocmd("LspAttach", {
    --     group = group,
    --     callback = function(args)
    --       local client = vim.lsp.get_client_by_id(args.data.client_id)
    --       if client and client:supports_method("textDocument/inlayHint") then
    --         vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    --       end
    --     end,
    --   })
    -- end,
  },
}
