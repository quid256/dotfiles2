local vim = vim

-- which features to enable
local features = {
    lang_lua = true,
    lang_viml = true,
    lang_python = true,
    lang_go = true,
    lang_rust = true,
    lang_tex = false,
    lang_beancount = false,

    vimagit = false,
    fugitive = true,
    colorizer = false,
}

package.loaded["util"] = nil
Util = require("util")

local plugs = {
    -- color scheme
    {"folke/tokyonight.nvim", branch = "main"},

    -- git
    -- "itchyny/vim-gitbranch",
    --"itchyny/lightline.vim",
    --
    "nvim-lualine/lualine.nvim",
    "mhinz/vim-signify",

    -- file browser
    "lambdalisue/nerdfont.vim",
    "lambdalisue/fern.vim",
    "lambdalisue/fern-git-status.vim",
    "lambdalisue/fern-renderer-nerdfont.vim",
    "lambdalisue/fern-hijack.vim",

    -- Random useful things, I should look into this (right now here as a dependency)
    "folke/which-key.nvim",
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",
    "nvim-telescope/telescope.nvim",
    "junegunn/vim-easy-align",

    -- LSP configuration
    "neovim/nvim-lspconfig",
    "williamboman/nvim-lsp-installer",

    -- completion engine
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",

    "junegunn/goyo.vim",

    -- treesitter
    { "nvim-treesitter/nvim-treesitter", ["do"] = ":TSUpdate" },

    "machakann/vim-sandwich",
    "idbrii/detectindent",
    { "turbio/bracey.vim", ["do"] = "npm install --prefix server" },
}

for feat, feat_plug in pairs({
    lang_tex = {"lervag/vimtex"},
    lang_beancount = {"nathangrigg/vim-beancount"},
    colorizer = {"norcalli/nvim-colorizer.lua"},
    vimagit = {"jreybert/vimagit"},
    fugitive = {"tpope/vim-fugitive"},
}) do
    if features[feat] then
        for _, plug in ipairs(feat_plug) do
            table.insert(plugs, plug)
        end
    end
end

Util.plug_install(plugs)

Util.options.global {
    encoding = "utf-8",
    scrolloff = 2, -- Leave 2 chars above/below while scrolling
    mouse = "a", -- get the mouse to work
    modeline = true,
    pastetoggle = "<Insert>",
    termguicolors = true,
    completeopt = "menu,menuone,noselect",
    expandtab = true,
    shiftwidth = 4,
    tabstop = 4,
    softtabstop = 4,

    hidden = true, -- Allow you to switch buffers safely without writing

    showmode=false,
    signcolumn="yes",
}

vim.o.shortmess = vim.o.shortmess .. "c"

Util.options.window {
    wrap = false,
    number = true,
    cursorline = true,
}

Util.options.buffer {
    tabstop = 4,
    softtabstop = 4,
    expandtab = true,
    shiftwidth = 4,
}

Util.vars.global {
    enable_bold_font = 1,
    enable_italic_font = 1,
    mapleader = " ",

    ["fern#renderer"] = "nerdfont",

    --signify_sign_add = "▍",
    --signify_sign_change = "▍",
    --signify_sign_delete = "▁",
    --signify_sign_delete_first_line = "▔",

    vimtex_quickfix_enabled = false,
    vimtex_compiler_method = "tectonic",
    vimtex_view_method = "mupdf",
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    section_separators = { left = '', right = '' },
    --section_separators = { left = '', right = '' },
    component_separators = '|',
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

-- Some minor tweaks to the nvim terminal
vim.api.nvim_exec([[
augroup nvim_terminal
    " Enter Terminal-mode when it's opened, and remove line numbers
    autocmd TermOpen * startinsert
    autocmd TermOpen * setlocal nonumber norelativenumber

    autocmd FileType fern setlocal nonumber norelativenumber
augroup END

augroup tex_setup
    autocmd FileType tex nnoremap <silent> <localleader>r <cmd>silent! !pkill -HUP mupdf<CR>
    autocmd FileType tex setlocal number
augroup END

cnoreabbrev <expr> W getcmdtype() == ":" && getcmdline() == 'W' ? 'w' : 'W'
]], false)


require("my_treesitter")(features)

require("my_lsp")(features)

vim.cmd("colorscheme tokyonight")

local wk = require("which-key")
wk.setup {
    triggers = {"<leader>", "<localleader>", "z"}
}
wk.register(
    {
        c = {
            name = "config files",
            r = { "<cmd>luafile ~/.config/nvim/init.lua<cr>", "Reload" },
            o = { "<cmd>tabnew<cr><cmd>Fern ~/.config/nvim<cr>", "Open" }
        },
        p = {
            name = "plugin",
            i = { "<cmd>PlugInstall<cr>", "Install" },
            c = { "<cmd>PlugClean<cr>", "Clean" },
            u = { "<cmd>PlugUpdate<cr>", "Update" }
        },
        n = { "<cmd>Fern . -drawer -toggle<cr>", "Open Fern"},
        g = {
            g = {[[<cmd>lua require'hl_show'.show_hl_captures()<cr>]], "Show highlight groups 2"},
        },
        t = { "<cmd>tabe term://.//zsh<cr>", "Term in Tab"},
        l = {
            name = "LSP",
            r = {"<cmd>lua vim.lsp.buf.rename()<CR>", "Rename Identifier"},
            a = {"<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action"},
            e = {"<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "Show Diagnostics"},
            t = {"<cmd>Telescope diagnostics<CR>", "All Diagnostics"},
        }
    },
    { prefix = "<leader>" }
)

Util.keybinds.add {
    { "i", "fd", "<Esc>" },
    { "i", "f<BS>", "" },
    { "n", "<C-J>", "<C-W><C-J>" },
    { "n", "<C-K>", "<C-W><C-K>" },
    { "n", "<C-H>", "<C-W><C-H>" },
    { "n", "<C-L>", "<C-W><C-L>" },
    { "t", "<Esc>", [[<C-\><C-n>]] },
    { "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>" },
    { "n", "gd", "<cmd>Telescope lsp_definitions<CR>"},
    { "n", "gr", "<cmd>Telescope lsp_references<CR>"},
    { "i", "<C-P>", "<cmd>Telescope find_files<CR>"},
    { "n", "<C-P>", "<cmd>Telescope find_files<CR>"},
    { "n", ";;", "<cmd>Telescope buffers<CR>"},
    { "n", ";f", "<cmd>Telescope live_grep<CR>"},
    -- { "n", ";", "<cmd>lua require'telescope.builtin'.buffers{ show_all_buffers = true }<CR>" },

    -- {'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>'},
    -- { "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>" },
    -- {'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>'},
    -- {'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>'},
    -- {'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>'},
    -- {'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>'},
    -- {'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>'},
    -- {'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>'},
    -- {'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>'},
    -- {'n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>'},
}

vim.api.nvim_exec([[
augroup Format
    autocmd!

    autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
    autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 1000)
    autocmd BufReadPost,BufNewFile *.tex setlocal tw=90 colorcolumn=90
augroup END
]], false)

require('telescope').setup{
    pickers={
        live_grep={theme="dropdown"},
        lsp_references={theme="dropdown"},
        lsp_definitions={theme="dropdown"},
        diagnostics={theme="dropdown"},
        buffers={
            theme="dropdown",
            sort_mru=true,
            ignore_current_buffer=true,
        },
    }
}

-- autocmd BufWritePost * FormatWrite
-- autocmd BufWritePost *.tex silent! VimtexCompile
if features.colorizer then
    require('colorizer').setup(
      { '*' },
      {
          RGB      = true,         -- #RGB hex codes
          RRGGBB   = true,         -- #RRGGBB hex codes
          names    = true,         -- "Name" codes like Blue
          RRGGBBAA = true,         -- #RRGGBBAA hex codes
          rgb_fn   = true,         -- CSS rgb() and rgba() functions
          hsl_fn   = true,         -- CSS hsl() and hsla() functions
          css      = true,         -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn   = true,         -- Enable all CSS *functions*: rgb_fn, hsl_fn
      }
    )
end

