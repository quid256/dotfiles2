local vim = vim

package.loaded["util"] = nil

Util = require("util")

-- print(vim.inspect(Util))
Util.plug_install {
    -- 'vim-airline/vim-airline',
    "itchyny/lightline.vim",
    "~/.vim/bundle/earthy-vim", -- my color scheme
    -- 'lifepillar/vim-gruvbox8',
    -- 'arcticicestudio/nord-vim',
    'lifepillar/vim-colortemplate',
    'folke/lsp-colors.nvim',
    'folke/lsp-trouble.nvim',

    -- 'tpope/vim-fugitive',

    'KabbAmine/vCoolor.vim',
    'norcalli/nvim-colorizer.lua',

    -- Useful for setting up keybinds
    "folke/which-key.nvim",
    "lambdalisue/fern.vim",
    "lambdalisue/fern-git-status.vim",
    "lambdalisue/nerdfont.vim",
    "lambdalisue/fern-renderer-nerdfont.vim",
    "lambdalisue/fern-hijack.vim",
    "airblade/vim-rooter",

    -- Random useful things, I should look into this (right now here as a dependency)
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",
    -- "glepnir/dashboard-nvim",
    "nvim-telescope/telescope.nvim",

    -- LSP / syntax highlighting stuff
    "neovim/nvim-lspconfig", -- nvim base LSP configs
    "kabouzeid/nvim-lspinstall", -- LSP auto-installation
    "hrsh7th/nvim-compe", -- completions
    { "nvim-treesitter/nvim-treesitter", ["do"] = ":TSUpdate" },
    "lukas-reineke/format.nvim",

    "lervag/vimtex",
    "sbdchd/neoformat",

    "machakann/vim-sandwich",
    "felipesere/pie-highlight.vim",
    "vmchale/dhall-vim",

    "mhinz/vim-signify",
    "idbrii/detectindent",

    { "turbio/bracey.vim", ["do"] = "npm install --prefix server" },

    -- {"oberblastmeister/neuron.nvim", branch = "unstable"},
}


Util.options.global {
    encoding = "utf-8",
    -- Leave 2 chars above/below while scrolling
    scrolloff = 2,
    -- Various other settings
    mouse = "a", -- get the mouse to work
    -- cursorline = false,
    modeline = true,
    pastetoggle = "<Insert>",
    termguicolors = true,
    completeopt = "menuone,noselect",
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

    foldmethod="expr",
    foldexpr="nvim_treesitter#foldexpr()"
}

Util.options.buffer {
    tabstop = 4,
    softtabstop = 4,
    expandtab = true,
    shiftwidth = 4
}

Util.vars.global {
    enable_bold_font = 1,
    enable_italic_font = 1,
    -- earthy_uniform_status_lines = 0,
    -- airline_powerline_fonts = 1,
    -- airline_skip_empty_sections = 1,

    dashboard_default_executive = "telescope",
    ["fern#renderer"] = "nerdfont",

    mapleader = " ",
    rooter_patterns = {".git", ".vscode", "PROJECT_ROOT", "neuron.dhall"},
    lightline = {colorscheme = "earthy_ct"},

    vimtex_quickfix_enabled = false,
    vimtex_compiler_method = "tectonic",
    vimtex_view_method = "mupdf",

    earthy_ct_plugin_hi_groups = 1,

    signify_sign_add = "▍",
    signify_sign_change = "▍",
    signify_sign_delete = "▁",
    signify_sign_delete_first_line = "▔",
}

-- Some minor tweaks to the nvim terminal
vim.api.nvim_exec(
    [[
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

--; cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? 'BufferClose' : 'q'
--; cnoreabbrev <expr> x getcmdtype() == ":" && getcmdline() == 'x' ? 'up \| BufferClose' : 'x'

-- Set up syntax highlighting with treesitter for relevant languages
require "nvim-treesitter.configs".setup {
    ensure_installed = {
        "lua",
        "c",
        "rust",
        "python",
        "go",
        "javascript",
        "html",
        "css",
    }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    }
}

-- Do this this way so that there's no reloading when you re-run this file (that seems to cause issues)
require "lsp_config"

vim.api.nvim_exec("colorscheme earthy_ct", false)

require "compe".setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = "enable",
    documentation = true,
    source = {
        path = true,
        buffer = true,
        calc = true,
        nvim_lsp = true,
        nvim_lua = true,
        vsnip = true
    }
}

local wk = require("which-key")
wk.setup {
    triggers = {"<leader>", "<localleader>", "z"}
}

function GetHighlightGroups()
    local syntax_ids = vim.fn.synstack(vim.fn.line('.'), vim.fn.col('.'))

    for i, syn_id in ipairs(syntax_ids) do
        local name = vim.fn.synIDattr(syn_id, "name")
        local translated = vim.fn.synIDattr(vim.fn.synIDtrans(syn_id), "name")
        print("Level "..i..": name<"..name.."> trans<"..translated..">")
    end

    if #syntax_ids == 0 then
        print("No highlight groups found!")
    end
end

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
        [" "] = {"<cmd>edit #<cr>", "Go to Previous Buffer"},
        g = {
            g = {[[<cmd>lua require'hl_show'.show_hl_captures()<cr>]], "Show highlight groups 2"},
        },
        t = { "<cmd>tabe term://.//zsh<cr>", "Term in Tab"},
        -- h = { "<cmd>BufferPrevious<cr>", "Next Tab"},
        -- l = { "<cmd>BufferNext<cr>", "Previous Tab"},
        -- t = { "<cmd>BufferPick<cr>", "Pick Tab"},
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
    { "n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>" },
    { "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>" },
    { "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>" },
    { "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>" },
    { "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>" },
    { "n", ";", "<cmd>lua require'telescope.builtin'.buffers{ show_all_buffers = true }<CR>" },

    -- {'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>'},
    -- { "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>" },
    -- {'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>'},
    -- {'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>'},
    -- {'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>'},
    -- {'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>'},
    -- {'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>'},
    -- {'n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'},
    -- {'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>'},
    -- {'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>'},
    -- {'n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>'},
}

vim.api.nvim_exec([[
augroup Format
    autocmd!

    autocmd BufWritePre *.go silent! FormatWrite
    autocmd BufReadPost,BufNewFile *.tex setlocal tw=90 colorcolumn=90
augroup END
]], false)


    -- autocmd BufWritePost * FormatWrite

    -- autocmd BufWritePost *.tex silent! VimtexCompile
require("format").setup {
    ["*"] = {
        { cmd = { "sed -i 's/[ \t]*$//'" } } -- remove trailing whitespace
    },
    -- lua = {
    --     {
    --         cmd = {
    --             function( file)
    --                 return string.format( "luafmt -l %s -w replace %s", vim.bo.textwidth, file)
    --             end
    --         }
    --     }
    -- },
    go = {
        {
            cmd = { "gofmt -w", "goimports -w" },
            tempfile_postfix = ".tmp"
        }
    },
    javascript = {
        { cmd = { "prettier -w", "./node_modules/.bin/eslint --fix" } }
    },
    python = {
        { cmd = { "black" } }
    },
    rust = {
        { cmd = { "rustfmt --emit files", } }
    }
}


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

-- require'neuron'.setup{}

vim.fn.sign_define(
    "LspDiagnosticsSignError",
    {texthl = "LspDiagnosticsSignError", text = "", numhl = "LspDiagnosticsSignError"}
)
vim.fn.sign_define(
    "LspDiagnosticsSignWarning",
    {texthl = "LspDiagnosticsSignWarning", text = "", numhl = "LspDiagnosticsSignWarning"}
)
vim.fn.sign_define(
    "LspDiagnosticsSignHint",
    {texthl = "LspDiagnosticsSignHint", text = "", numhl = "LspDiagnosticsSignHint"}
)
vim.fn.sign_define(
    "LspDiagnosticsSignInformation",
    {texthl = "LspDiagnosticsSignInformation", text = "", numhl = "LspDiagnosticsSignInformation"}
)

require("trouble").setup{}
