DeltaLib.Validation.Rules = DeltaLib.Validation.Rules || {}

local RULE = {}
RULE.__index = RULE

function RULE.new()

end

--[[ function RULE:getName()
  return self.name
end

function RULE:setName(name)
  self.name = name  
end

function RULE:register()
  DeltaLib.Validation.Rules[self:getName()] = self
end ]]

DeltaLib.Validation.Rule = RULE