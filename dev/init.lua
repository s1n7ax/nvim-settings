local cwd = vim.fn.getcwd()
vim.opt.runtimepath:prepend(cwd)

--[[
-- plugin name will be used to reload the loaded modules
--]]
local package_name = 'settings'

-- add the escape character to special characters
--  local escape_pattern = function (text)
--  return text:gsub("([^%w])", "%%%1")
--  end

-- unload loaded modules by the matching text
function Unload_packages()
	for module_name, _ in pairs(package.loaded) do
		if string.find(module_name, '^' .. package_name) then
			package.loaded[module_name] = nil
		end
	end
end

-- executes the run method in the package
local run_action = function()
	local Settings = require(package_name)

	local a = Settings:new("test")
	a:save_settings({ name = 'nisala' })
	vim.pretty_print(a:get_settings())
	a:save_settings({ name = 'srinesh' })
	vim.pretty_print(a:get_settings())
end

-- unload and run the function from the package
function Reload_and_run()
	Unload_packages()
	run_action()
end

local set_keymap = vim.api.nvim_set_keymap

set_keymap('n', '<leader><leader>r', '<cmd>luafile dev/init.lua<cr>', {})
set_keymap('n', '<leader><leader>w', '<cmd>lua Reload_and_run()<cr>', {})
set_keymap('n', '<leader><leader>u', '<cmd>lua Unload_packages()<cr>', {})
