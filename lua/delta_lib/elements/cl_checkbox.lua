local PANEL = {}

AccessorFunc(PANEL, "c_IconColor", "IconColor")

DeltaLib:MakeFont("DeltaLib.Checkbox.Label", 20)

local ColorAlpha = ColorAlpha

function PANEL:Init()
  self.selected = false

  self.checkbox = self:Add("DButton")
  self.checkbox:Dock(LEFT)
  self.checkbox.iconAlpha = 0

  self.checkbox.Paint = function(pnl, w, h)
    local iconSize = h * .8
    DeltaLib:DrawImgur(w*.5 - iconSize*.5, h*.5 - iconSize*.5, iconSize, iconSize, ColorAlpha(self:GetIconColor(), pnl.iconAlpha), "FqaLBYt")
  end
  self.checkbox.DoClick = function(pnl)
    self:SetValue(not self:GetValue())
  end
end

function PANEL:SetLabel(txt)
  if IsValid(self.label) then
    self.label:SetText(txt)
    self.label:SizeToContentsX()
    return
  end

  self.label = self:Add("DLabel")
  self.label:Dock(LEFT)
  self.label:DockMargin(8, 0, 0, 0)
  self.label:SetText(txt)
  self.label:SetFont("DeltaLib.Checkbox.Label")
  self.label:SetTextColor(color_white)
  self.label:SizeToContentsX()
end

function PANEL:GetValue()
  return self.selected
end

function PANEL:SetValue(bool, noAnim)
  self.selected = bool

  if not noAnim then
    DeltaLib:LerpValue(self.checkbox, "iconAlpha", bool and 255 or 0)
  end
end

function PANEL:PerformLayout(w, h)
  self.checkbox:SetWide(self.checkbox:GetTall())
end

vgui.Register("DeltaLib.Checkbox", PANEL)