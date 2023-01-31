-- nvim-cmp setup
local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
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
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
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
    -- Common lsp mappings.
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
    local telescope = require('telescope.builtin')
    local nmap = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = 0, desc = desc })
    end
    nmap("gd", telescope.lsp_definitions, "[G]o to [d]efinition")
    nmap("gt", telescope.lsp_type_definitions, "[G]o to [t]ype definition")
    nmap("gi", telescope.lsp_implementations, "[G]o to implementations")
    nmap("gr", telescope.lsp_references, "[G]o to references")
    nmap("gS", telescope.lsp_workspace_symbols, "[G]o to workspace [s]ymbols")
    nmap("gs", telescope.lsp_document_symbols, "[G]o to document [s]ymbols")
    nmap("<leader>p", vim.lsp.buf.signature_help, "Signature help")
    nmap("<leader>cf", vim.lsp.buf.format, "[C]ode [f]ormat")
    nmap("<leader>cr", vim.lsp.buf.rename, "[C]ode [r]ename")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [a]ction")
    nmap("<M-l>", vim.diagnostic.goto_next, "Next diagnostic")
    nmap("<M-h>", vim.diagnostic.goto_prev, "Prev diagnostic")
    nmap("<leader>df", vim.diagnostic.open_float, "Show [d]iagnostic in [f]loating window")
    nmap("<leader>dl", telescope.diagnostics, "Show diagnostics")
end

local lsp_on_attach_rust = function(_, bufnr)
    lsp_on_attach_common(_, bufnr)
    vim.keymap.set("n", "<F6>",
        function()
            vim.cmd.wall()
            require('rrlynx.rust').cargo_build()
        end,
        { buffer = 0, desc = "Run cargo build" })

    vim.keymap.set("n", "<F7>",
        function()
            local triple = vim.fn.input("Target triple: ");
            if #triple == 0 then
                triple = nil
            end
            lspconfig.rust_analyzer.setup {
                settings = {
                    ["rust-analyzer"] = { cargo = { target = triple } }
                }
            }
        end,
        { buffer = 0, desc = "Set target triple" })
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
