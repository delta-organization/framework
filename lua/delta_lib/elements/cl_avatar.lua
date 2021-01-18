local PANEL = {}

AccessorFunc(PANEL, "b_CircleShape", "CircleShape", FORCE_BOOL)

function PANEL:Init()
  self:SetCircleShape(true)

  self.avatar = self:Add("AvatarImage")
  self.avatar:Dock(FILL)
  self.avatar:SetPaintedManually(true)
end

function PANEL:SetPlayer(ply, size)
  self.avatar:SetPlayer(ply, size)
end

function PANEL:SetSteamID(sid64, size)
  self.avatar:SetSteamID(sid64, size)
end

local white = color_white
function PANEL:DrawCircle(w, h)
  if not self.circle then
    self.circle = DeltaLib:PrecacheArc(w*.5, h*.5, 0, 3, h*.5, 360)
  end

  DeltaLib:DrawPrecachedArc(self.circle, white)
end

function PANEL:Paint(w, h)
  DeltaLib:Mask(function()
    DeltaLib:DrawArc(w/2, h/2, 0, 360, h/2, 360, color_white)
  end, function()
    self.avatar:PaintManual()
  end)
end

vgui.Register("DeltaLib.Avatar", PANEL)