local PANEL = {}

function PANEL:Init()
  self:SetContentAlignment(4)
  

  self.options = {}
end

function PANEL:AddOption()

end

function PANEL:OpenMenu()

end

function PANEL:DoClick()
  self:OpenMenu()
end

function PANEL:GetValue()

end

function PANEL:SetValue()

end

function PANEL:Paint(w, h)

end

vgui.Register("DeltaLib.ComboBox", PANEL, "DButton")