DeltaLib.Validation = DeltaLib.Validation || {}
DeltaLib.Validation.Rules = DeltaLib.Validation.Rules || {}

local RULE = {}
RULE.__index = RULE

function RULE.new(field, value, params)
  local self = setmetatable({}, RULE)
  self.field = field
  self.value = value
  self.params = params
  self.errorMessage = ":field is invalid."
  return self
end

function RULE:formatErrorMessage()
  local msg = self.errorMessage

  msg = msg:Replace(":field", self.field)

  for i, param in ipairs(self.params) do
    msg = msg:Replace(":param" .. i, param)
  end

  return msg
end

function RULE:test()
  return true
end

DeltaLib.Validation.Rule = RULE