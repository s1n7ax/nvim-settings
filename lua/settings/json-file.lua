local M = {}

function M:new(path)
	assert(path, "path should be passed to JsonFile")

	local o = {
		path = path,
	}

	setmetatable(o, self)
	self.__index = self

	o:create_settings_file_if_doesnt_exists()

	return o
end

function M:write(value)
	local file = io.open(self.path, "w")

	if not file then
		error(string.format("settings.json not found at %s", self.path))
	end

	file:write(vim.json.encode(value))
	file:close()

	self.settings_obj = value
end

function M:read()
	if self.settings_obj then
		return self.settings_obj
	end

	local file = io.open(self.path, "r")

	if not file then
		error(string.format("settings.json not found at %s", M.path))
	end

	local json = vim.json.decode(file:read())
	file:close()

	self.settings_obj = json

	return json
end

function M:create_settings_file_if_doesnt_exists()
	if self:settings_file_exists() == 0 then
		self:create_settings_file()
	end
end

function M:create_settings_file()
	self:write(vim.empty_dict())
end

function M:settings_file_exists()
	return vim.fn.filereadable(self.path)
end

return M
