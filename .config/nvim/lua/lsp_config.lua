-- LSP stuff
-- TODO this entire thing is very sketchy. Really don't know what's going on...
local lsp_install = require('lspinstall')
lsp_install.setup()

local lsp_config = require('lspconfig')
for _, lsp in pairs(lsp_install.installed_servers()) do
    if lsp_config[lsp].setup then
        if lsp == "typescript" then
            lsp_config[lsp].setup{ root_dir=vim.loop.cwd }
        else
            lsp_config[lsp].setup{}
        end
    end
end


lsp_config.gopls.setup{}
lsp_config.texlab.setup{
    -- Temporary setup to fix the texlab bug
    cmd = { "/home/chris/Development/texlab/texlab/target/release/texlab" },
    settings = {
        texlab = {
            build = {
                executable = "/home/chris/scripts/tectonic-wrapper.sh",
                -- executable = "tectonic",
                args = { "%f", "--synctex", "--keep-logs"},
            }
        }
    }
}

vim.api.nvim_exec([[
augroup nvim_latex
    autocmd BufWritePost *.tex silent TexlabBuild
augroup END
]], false)

