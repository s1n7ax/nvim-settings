local config = require("settings.config")
local JsonFile = require("settings.json-file")

local M = {
	settings_file = nil,
}

function M:new(setting_name)
	assert(setting_name, "A unique setting name should be passed to the class")
	assert(type(setting_name), "Type of the setting name should be an string")

	local o = {
		key = setting_name,
	}

	setmetatable(o, self)
	self.__index = self

	return o
end

function M:get_settings()
	local gsettings = M.get_settings_file():read()
	local local_settings = gsettings[self.key]

	if not local_settings then
		self:save_settings(vim.empty_dict())
	end

	return gsettings[self.key]
end

function M:save_settings(settings)
	local gsettings = M.get_settings_file():read()

	gsettings[self.key] = settings

	M.get_settings_file():write(gsettings)
end

function M.get_settings_file()
	if not M.settings_file then
		M.settings_file = JsonFile:new(config.file_path)
	end

	return M.settings_file
end

function M.setup(user_config)
	config = vim.tbl_extend(config, user_config)
end

function M.run() end

return M
