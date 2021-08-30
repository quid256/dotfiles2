local vim = vim

Util = {
    keybinds = {},
    options = {},
    vars = {}
}

local home = tostring(os.getenv("HOME"))

function Util.keybinds.add(keybinds)
    vim.validate{keybinds = {keybinds, "table"}}

	for _, entry in pairs(keybinds) do
		entry[4] = entry[4] or {}
        entry[4]["noremap"] = entry[4]["noremap"] or true -- c'mon, everyone like noremap
        entry[4]["silent"] = entry[4]["silent"] or true -- I'm less sure about this...

		vim.api.nvim_set_keymap(unpack(entry))
	end
end

local function set_option(option_type, id, options)
    vim.validate{
        option_type = {option_type, "string"},
        id = {id, "number"},
        options = {options, "table"}
    }

    -- Install all the packages!
	for key, value in pairs(options) do
		if id == 0 then
			vim[option_type][key] = value
		else
			vim[option_type][id][key] = value
		end
	end
end

for k, v in pairs{global = {"o", 0}, window = {"wo", 0}, buffer = {"bo", 0}} do
    Util.options[k] = function(options) set_option(v[1], v[2], options) end
end


function Util.vars.global(vals)
    vim.validate{vals = {vals, "table"}}

    for var_name, var_value in pairs(vals) do
        vim.g[var_name] = var_value
    end
end


function Util.plug_install(plugins)
    vim.validate {
        plugins = {plugins, vim.tbl_islist}
    }
    -- First, check that vim-plug is
    -- installed and install it if not
    -- not really sure how to do this correctly - FIXME
    vim.api.nvim_exec(
    [[
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync
endif
    ]], false)

    vim.fn["plug#begin"](home .. "/.config/nvim/vim-plug")

    for _, v in ipairs(plugins) do
        if type(v) == "string" then
            vim.fn["plug#"](v)
        elseif type(v) == "table" then
            local pack_name = v[1]
            assert(pack_name, "Package must be first index")

            v[1] = nil
            vim.fn["plug#"](pack_name, v)
        end
    end

    vim.fn["plug#end"]()
end

return Util
