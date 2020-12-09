local RULE = {}
RULE.__index = RULE

setmetatable(RULE, {
  __index = DeltaLib.Validation.Rule
})

function RULE.new(field, value, params)
  local self = setmetatable({}, RULE)
  self.field = field
  self.value = value
  self.params = params
  self.size = params[1]
  self.errorMessage = ":field must have a size of :param1."
  return self
end

function RULE:test()
  local value, size = self.value, self.size
  local valueType = type(value)

  if valueType == "string" then
    return #value == size
  elseif valueType == "number" then
    return value == size
  elseif valueType == "table" then
    return table.Count(value) == size
  end

  return false
end

DeltaLib.Validation.Rules["size"] = RULE