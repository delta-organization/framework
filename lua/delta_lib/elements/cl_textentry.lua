local PANEL = {}

AccessorFunc(PANEL, "s_Placeholder", "Placeholder", FORCE_STRING)

local draw_RoundedBox = draw.RoundedBox

function PANEL:Init()
  self:DockPadding(8, 8, 8, 8)

  self.textentry = self:Add("DTextEntry")
  self.textentry:Dock(FILL)

  self.textentry.OnValueChange = function(pnl, ...)
    self:OnValueChange(...)
  end
end

function PANEL:SetIcon(id, right)
  if type(id) == "IMaterial" then
    -- no imgur id
  end

  
end

function PANEL:Paint(w, h)
  draw_RoundedBox(6, 0, 0, w, h, DeltaLib.Theme.Navbar)
end

function PANEL:SetUpdateOnType(bool)
  self.textentry:SetUpdateOnType(bool)
end

function PANEL:GetValue()
  return self.textentry:GetValue()
end

function PANEL:SetValue(val)
  self.textentry:SetValue(val)
end

function PANEL:OnValueChange(...)
  -- Override
end

vgui.Register("DeltaLib.TextEntry", PANEL, "EditablePanel")