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
  self.errorMessage = ":field is a required field."
  return self
end

function RULE:test()
  local value = self.value
  if type(value) == "string" then
    return value:Trim() != ""
  end

  return value != nil
end

DeltaLib.Validation.Rules["required"] = RULE