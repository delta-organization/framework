local PANEL = {}

function PANEL:Init()
  self.fields = {}
  self.data = {}

  self.layout = self:Add("DIconLayout")
  self.layout:Dock(FILL)
end

function PANEL:AddField(key, name, type, fraction)
  fraction = fraction or 1

  local pnl = self.layout:Add("Panel")
  pnl.fraction = fraction

  pnl.GetValue = function(pnl)

  end
end

function PANEL:GetData()
  return self.data
end

function PANEL:SetData(tbl)
  self.data = tbl
end

function PANEL:GetValidationSchema()
  return self.validator and self.validator:GetSchema()
end

function PANEL:SetValidationSchema(schema)
  if not self.validator then
    self.validator = DeltaLib.Validation.Validator.new()
  end

  self.validator:SetSchema(schema)
end

function PANEL:ValidateData()
  if not self.validator then return true end

  local result, errors = self.validator:validate(self:GetData())

  return result
end

function PANEL:Submit(func)
  
end

function PANEL:PerformLayout(w, h)
  for _, pnl in ipairs(self.fields) do
    
  end
end

vgui.Register("DeltaLib.Form", PANEL, "EditablePanel")