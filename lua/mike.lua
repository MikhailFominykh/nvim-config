vim.keymap.set("n", "<leader><leader>x", "<cmd>w<cr><cmd>source %<cr>")
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "<leader>q", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
    if buftype == "quickfix" then
        vim.cmd "cclose"
    else
        vim.cmd "copen"
    end
end)

require('telescope').setup {
    defaults = {
        prompt_prefix = "$ ",
    }
}
require('telescope').load_extension('fzf')
require('nvim-treesitter.configs').setup {
    ensure_installed = { "c", "lua", "rust", "vim" },

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
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    }
}

-- nvim-cmp setup
local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')
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
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lua' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
    },
        {
            { name = 'buffer', keyword_length = 3 }
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

local lsp_on_attach_common = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
    local telescope = require('telescope.builtin')
    vim.keymap.set("n", "gd", telescope.lsp_definitions, { buffer = 0 })
    vim.keymap.set("n", "gt", telescope.lsp_definitions, { buffer = 0 })
    vim.keymap.set("n", "gi", telescope.lsp_implementations, { buffer = 0 })
    vim.keymap.set("n", "gr", telescope.lsp_references, { buffer = 0 })
    vim.keymap.set("n", "gws", telescope.lsp_workspace_symbols, { buffer = 0 })
    vim.keymap.set("n", "gs", telescope.lsp_document_symbols, { buffer = 0 })
    vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { buffer = 0 })
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = 0 })
    vim.keymap.set("n", "<leader>df", vim.diagnostic.goto_next, { buffer = 0 })
    vim.keymap.set("n", "<leader>db", vim.diagnostic.goto_prev, { buffer = 0 })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
end

local lsp_on_attach_rust = function(_, bufnr)
    lsp_on_attach_common(_, bufnr)
    vim.keymap.set("n", "<F6>",
        function()
            vim.cmd "wall"
            require('rust').cargo_build()
        end,
        { buffer = 0 })
end

lspconfig.rust_analyzer.setup {
    capabilities = cmp_capabilities,
    on_attach = lsp_on_attach_rust,
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

-- sumneko_lua setup
lspconfig.sumneko_lua.setup {
    capabilities = cmp_capabilities,
    on_attach = lsp_on_attach_common,
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
