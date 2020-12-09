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
  self.errorMessage = ":field must be a valid model."
  return self
end

function RULE:test()
  return util.IsValidModel(tostring(this.value))  
end

DeltaLib.Validation.Rules["size"] = RULE