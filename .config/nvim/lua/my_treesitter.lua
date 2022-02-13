local feats_to_lang = {
    lang_lua = "lua",
    lang_python = "python",
    lang_go = "go",
    lang_rust = "rust",
}

local function setup_treesitter(features)
    local langs_to_install = {}
    for feat, lang in pairs(feats_to_lang) do
        if features[feat] then
            table.insert(langs_to_install, lang)
        end
    end

    require("nvim-treesitter.configs").setup {
        ensure_installed = langs_to_install,
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        }
    }
end

return setup_treesitter
