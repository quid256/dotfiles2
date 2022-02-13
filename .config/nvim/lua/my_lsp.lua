local vim = vim

local kind_icons = {
      Text = "", Method = "", Function = "", Constructor = "",
      Field = "", Variable = "", Class = "ﴯ", Interface = "",
      Module = "", Property = "ﰠ", Unit = "", Value = "",
      Enum = "", Keyword = "", Snippet = "", Color = "",
      File = "", Reference = "", Folder = "", EnumMember = "",
      Constant = "", Struct = "", Event = "", Operator = "",
      TypeParameter = ""
}

local language_servers = {
    lang_lua = {"sumneko_lua", {
        Lua = {
            diagnostics = {
                globals = {'vim'}
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                }
            },
        }
    }},
    lang_viml = {"vimls", {}},
    lang_python = {"pyright", {}},
    lang_go = {"gopls", {}},
    lang_rust = {"rust_analyzer", {}},
}

local function setup_lsp(features)
    -- Completion setup
    local cmp = require'cmp'
    cmp.setup({
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end
        },
        mapping = {
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
        }, {
            { name = 'buffer' },
        }),
        formatting = {
            format = function(entry, vim_item)
                -- Kind icons
                vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
                -- Source
                vim_item.menu = ({
                  buffer = "[Buffer]",
                  nvim_lsp = "[LSP]",
                  luasnip = "[LuaSnip]",
                  nvim_lua = "[Lua]",
                  -- latex_symbols = "[LaTeX]",
                })[entry.source.name]
                return vim_item
            end
        }
    })

   local capabilities = require('cmp_nvim_lsp').update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )

    -- LSP setup
    local lsp_installer_servers = require('nvim-lsp-installer.servers')
    for feature, server_config in pairs(language_servers) do
        local server_name = server_config[1]
        local server_settings = server_config[2]

        if not features[feature] then
            goto continue
        end

        local server_available, server = lsp_installer_servers.get_server(server_name)
        if server_available then
            server:on_ready(function ()
                -- When this particular server is ready (i.e. when installation is finished or the server is already installed),
                -- this function will be invoked. Make sure not to also use the "catch-all" lsp_installer.on_server_ready()
                -- function to set up your servers, because by doing so you'd be setting up the same server twice.
                local opts = {
                    capabilities = capabilities,
                    settings = server_settings
                }
                server:setup(opts)
            end)

            if not server:is_installed() then
                print(string.format("Language server not installed: %s", server_name))
            end
        end

        ::continue::
    end

    -- overwrite the standard diagnostic signs for prettier utf-8 ones
    local diagnostic_signs = {
        DiagnosticSignError = "",
        DiagnosticSignWarn = "",
        DiagnosticSignHint = "",
        DiagnosticSignInfo = "",
    }

    for sign_name, sign in pairs(diagnostic_signs) do
        vim.fn.sign_define(
            sign_name,
            {texthl = sign_name, text = sign, numhl = sign_name}
        )
    end
end

return setup_lsp
