local vim = vim

package.loaded["util"] = nil
Util = require("util")

Util.plug_install {
    "itchyny/vim-gitbranch",
    "itchyny/lightline.vim",
    -- "~/.vim/bundle/earthy-vim", -- my color scheme
    {"folke/tokyonight.nvim", branch = "main"},
    -- 'lifepillar/vim-gruvbox8',
    -- 'arcticicestudio/nord-vim',
    -- 'lifepillar/vim-colortemplate',
     -- 'folke/lsp-colors.nvim',
    -- 'folke/lsp-trouble.nvim',
    -- 'tpope/vim-fugitive',
    -- 'KabbAmine/vCoolor.vim',

    'norcalli/nvim-colorizer.lua',

    -- Useful for setting up keybinds
    "folke/which-key.nvim",
    "lambdalisue/fern.vim",
    "lambdalisue/fern-git-status.vim",
    "lambdalisue/nerdfont.vim",
    "lambdalisue/fern-renderer-nerdfont.vim",
    "lambdalisue/fern-hijack.vim",
    -- "airblade/vim-rooter",

    -- Random useful things, I should look into this (right now here as a dependency)
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "kyazdani42/nvim-web-devicons",
    "nvim-telescope/telescope.nvim",

    -- LSP / syntax highlighting stuff
    "neovim/nvim-lspconfig", -- nvim base LSP configs
    "williamboman/nvim-lsp-installer",
    -- completion engine
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
    { "nvim-treesitter/nvim-treesitter", ["do"] = ":TSUpdate" },

    "jreybert/vimagit",

    "lervag/vimtex",
    -- "sbdchd/neoformat",

    "machakann/vim-sandwich",

    -- languages
    --"felipesere/pie-highlight.vim",
    -- "vmchale/dhall-vim",
    "nathangrigg/vim-beancount",

    "mhinz/vim-signify",
    "idbrii/detectindent",

    { "turbio/bracey.vim", ["do"] = "npm install --prefix server" },
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

    -- foldmethod="expr",
    -- foldexpr="nvim_treesitter#foldexpr()"
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
    -- rooter_patterns = {".git", ".vscode", "PROJECT_ROOT", "neuron.dhall"},
    lightline = {
        colorscheme = "tokyonight",
        active = {
            left = {
                {'mode', 'paste'},
                {'gitbranch', 'readonly', 'filename', 'modified'}
            }
        },
        component_function = {
            gitbranch = 'gitbranch#name',
        },
    },

    vimtex_quickfix_enabled = false,
    vimtex_compiler_method = "tectonic",
    vimtex_view_method = "mupdf",

    -- earthy_ct_plugin_hi_groups = 1,

    signify_sign_add = "▍",
    signify_sign_change = "▍",
    signify_sign_delete = "▁",
    signify_sign_delete_first_line = "▔",

}

local kind_icons = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "",
      Event = "",
      Operator = "",
      TypeParameter = ""
}


-- Completion / LSP setup
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
              latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
        end
    }
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local opts = {
        capabilities = capabilities,
    }

    server:setup(opts)
end)


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

vim.api.nvim_exec("colorscheme tokyonight", false)

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
    -- { "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>" },
    { "n", "gd", "<cmd>Telescope lsp_definitions<CR>" },
    { "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>" },
    { "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>" },
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
    {'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'},
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

-- #autocmd BufWritePre *.go silent! FormatWrite
require('telescope').setup{
    pickers={
        live_grep={
            theme="dropdown",
        },
        buffers={
            theme="dropdown",
            sort_mru=true,
            ignore_current_buffer=true,
        },
    }
}


    -- autocmd BufWritePost * FormatWrite

    -- autocmd BufWritePost *.tex silent! VimtexCompile
-- require("format").setup {
--     ["*"] = {
--         { cmd = { "sed -i 's/[ \t]*$//'" } } -- remove trailing whitespace
--     },
--     -- lua = {
--     --     {
--     --         cmd = {
--     --             function( file)
--     --                 return string.format( "luafmt -l %s -w replace %s", vim.bo.textwidth, file)
--     --             end
--     --         }
--     --     }
--     -- },
--     go = {
--         {
--             cmd = { "gofmt -w", "goimports -w" },
--             tempfile_postfix = ".tmp"
--         }
--     },
--     javascript = {
--         { cmd = { "prettier -w", "./node_modules/.bin/eslint --fix" } }
--     },
--     python = {
--         { cmd = { "black" } }
--     },
-- }


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

