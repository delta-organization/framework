local I18N = {}
I18N.__index = I18N

function I18N.new()
	local self = setmetatable({}, I18N)
	self.languages = {}
	return self
end

function I18N:registerLang(langKey, lang)
	self.languages[langKey] = lang
end

function I18N:loadDirectory(dir)
	local files = file.Find(dir .. "/*", "LUA")

	for _, fileName in ipairs(files) do
		local langName = fileName:Replace(".lua", "")
		local lang = include(dir .. "/" .. fileName)
		if not lang or not istable(lang) then return end

		self:registerLang(langName, lang)
	end
end

function I18N:languageRegistered(lang)
	return self.languages[lang] ~= nil
end

function I18N:getActiveLang()
	return self.activeLang
end

function I18N:setActiveLang(langKey)
	self.activeLang = langKey
end

function I18N:getLang()
	local active = self:getActiveLang()
	if not active or not self.languages[active] then return {} end

	return self.languages[active]
end

local string_Explode = string.Explode
local string_format = string.format
local istable = istable
local ipairs = ipairs

function I18N:getString(key, ...)
	local fullKey = key
	local lang, splitted = self:getLang(), string_Explode(".", key)
	
	if #splitted > 1 then
		for _, k in ipairs(splitted) do
			if not lang[k] then return fullKey end

			lang = lang[k]
		end
	end

	local str = istable(lang) and lang[key] or lang

	if not str then return key end
	if #{...} then return str end

	return string_format(key, ...)
end

--[[ 
function I18N:getString(key, ...)
	local lang = self:getLang()
	local strKey, splitted = key, string_Explode(".", key)

	if #splitted > 1 then
		for _, k in ipairs(splitted) do
			
		end
	end

	local str = lang[strKey]

	if not str then return key end
	if #{...} == 0 then return str end

	return string_format(str, ...)
end ]]

DeltaLib.i18n = I18N