function DeltaLib:MapTable(tbl, mapFunc)
	if not mapFunc then return tbl end

	local result = {}

	for k, v in pairs(tbl) do
		local newV, newK = mapFunc(v, k)
		result[newK or (#result + 1)] = newV
	end

	return result
end

function DeltaLib:ToTitleCase(str)
	if not isstring(str) then return "" end

	return str[1]:upper() .. str:sub(2, #str)
end

--[[
	Function for generating UUIDs
	 - Credits: https://gist.github.com/jrus/3197011
]]

local math_random = math.random
local string_gsub = string.gsub
local string_format = string.format

function DeltaLib:GenerateUUID()
  local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
  return string_gsub(template, "[xy]", function (c)
    local v = (c == "x") and math_random(0, 0xf) or math_random(8, 0xb)
    return string_format("%x", v)
  end)
end