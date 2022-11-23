vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "<leader><leader>x", "<cmd>w<cr><cmd>source %<cr>")

require('telescope').setup {
  defaults = {
    prompt_prefix = "$ ",
  }
}
require('telescope').load_extension('fzf')
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "lua", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  highlight = {
    enable = true,
    disable = { "help" },
    additional_vim_regex_highlighting = false,
  },
  indent = {
      enable = true
  }
}

-- nvim-cmp setup
local cmp = require('cmp')
local lspkind = require('lspkind')
cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    formatting = {
        format = lspkind.cmp_format {
            mode = 'text',
            maxwidth = 50,
            ellipsis_char = '...',
            menu = {
                buffer = '[buf]',
                nvim_lsp = '[LSP]',
                nvim_lua = '[api]',
                path = '[path]',
                luasnip = '[snip]',
            }
        }
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<cr>'] = cmp.mapping.confirm({ select = true })
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lua' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
    },
    {
        { name = 'buffer' }
    })
}

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- rust analyzer setup
local lspconfig = require('lspconfig')

local lsp_on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })
    vim.keymap.set("n", "<leader>df", vim.diagnostic.goto_next, { buffer = 0 })
    vim.keymap.set("n", "<leader>db", vim.diagnostic.goto_prev, { buffer = 0 })
end

lspconfig.rust_analyzer.setup {
    capabilities = cmp_capabilities,
    on_attach = lsp_on_attach,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    }
}

-- rust utilites setup


-- sumneko_lua setup
lspconfig.sumneko_lua.setup {
    capabilities = cmp_capabilities,
    on_attach = lsp_on_attach,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT"
            },
            diagnostics = {
                globals = { "vim" }
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            },
            telemetry = {
                enable = false
            }
        }
    }
}
