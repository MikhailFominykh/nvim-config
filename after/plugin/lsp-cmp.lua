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

local rust_analyzer_settings = {
    android = {
        cargo = {
            target = "aarch64-linux-android",
            extraEnv = {
                RUST_LOG = "error"
            },
            buildScripts = {
                enable = false,
                invocationLocation = "root",
                overrideCommand = { "cargo", "ndk", "-t", "aarch64-linux-android", "check", "--quiet",
                    "--message-format=json", "--lib" }
            }
        },
        check = {
            checkOnSave = false,
            overrideCommand = { "cargo", "ndk", "-t", "aarch64-linux-android", "check", "--quiet",
                "--message-format=json", "--lib" }
        },
        imports = {
            granularity = {
                group = "module",
            },
            prefix = "self",
        },
    },
    windows = {
        cargo = {
            target = "x86_64-pc-windows-msvc",
            extraEnv = {
                RUST_LOG = "error"
            },
            buildScripts = {
                enable = false,
            },
        },
        check = {
            checkOnSave = false,
        },
        imports = {
            granularity = {
                group = "module",
            },
            prefix = "self",
        },
    },
}

local lsp_on_attach_rust = nil

local setup_rust_analyzer_with_target = function(target)
    local settings = rust_analyzer_settings[target]
    if settings then
        lspconfig.rust_analyzer.setup {
            capabilities = cmp_capabilities,
            on_attach = lsp_on_attach_rust,
            settings = {
                ["rust-analyzer"] = settings,
            }
        }
        require("rrlynx.rust").build_target = target
    else
        print("Unknown target: " .. target)
    end
end

lsp_on_attach_rust = function(_, bufnr)
    print("Attach rust_analyzer to buffer ", bufnr)
    lsp_on_attach_common(_, bufnr)

    vim.keymap.set("n", "<F6>",
        function()
            vim.cmd.wall()
            require('rrlynx.rust').cargo_build()
        end,
        { buffer = bufnr, desc = "Run cargo build" })

    vim.keymap.set("n", "<F7>",
        function()
            vim.cmd.wall();
            require("rrlynx.rust").run_build_cmd();
        end,
        { buffer = bufnr, desc = "Run build.cmd" })

    vim.keymap.set("n", "<F8>",
        function()
            require("rrlynx.select-list").select(
                "Build target",
                { "windows", "android" },
                function(selected)
                    vim.lsp.stop_client(vim.lsp.get_active_clients({ name = "rust_analyzer" }))
                    setup_rust_analyzer_with_target(selected.value)
                end)
        end,
        { buffer = bufnr, desc = "Select Rust build target" })
end

-- setup_rust_analyzer_with_target("windows")
setup_rust_analyzer_with_target("windows")

-- lua setup
lspconfig.lua_ls.setup {
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

lspconfig.clangd.setup {
    capabilities = cmp_capabilities,
    on_attach = lsp_on_attach_common
}
