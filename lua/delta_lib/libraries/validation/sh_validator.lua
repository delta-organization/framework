DeltaLib.Validation = DeltaLib.Validation || {}

local VALIDATOR = {}
VALIDATOR.__index = VALIDATOR

function VALIDATOR.new(schema)
  local self = setmetatable({}, VALIDATOR)
  self:setSchema(schema)
  return self
end

function VALIDATOR:getSchema()
  return self.schema
end

function VALIDATOR:setSchema(schema)
  if not istable(schema) then return end

  for k, rules in pairs(schema) do
    if isstring(rules) then
      rules = string.Replace(rules, " ", "")
      schema[k] = string.Explode("|", rules, false)
    else
      continue
    end
  end

  self.schema = schema
end

function VALIDATOR:validate(data)
  local errors = {}

  for k, rules in pairs(self:getSchema()) do
    local value = data[k]
    if not value then continue end

    errors[k] = errors[k] or {}

    for _, rule in ipairs(rules) do
      local colPos = string.find(rule, ":", nil, false)
      local name, params = rule, {}

      if colPos then
        name = string.sub(rule, 1, colPos - 1)
        params = string.Explode(",", string.sub(rule, colPos + 1, #rule), false)
      end

      print("-------------------")
      print(name, #params)
      PrintTable(params)
      print("-------------------\n")
    end
  end

  return #errors == 0, errors
end

DeltaLib.Validation.Validator = VALIDATOR