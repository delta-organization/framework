local PANEL = {}

local draw_RoundedBox = draw.RoundedBox
local draw_RoundedBoxEx = draw.RoundedBoxEx
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect

DeltaLib:MakeFont("DeltaLib.Frame.Title", 24)

function PANEL:Init()
  self.header = self:Add("Panel")
  self.header:Dock(TOP)

  self.header.Paint = function(pnl, w, h)
    draw_RoundedBoxEx(6, 0, 0, w, h, DeltaLib.Theme.Header, true, true, false, false)

    surface_SetDrawColor(Color(70, 70, 70))
    surface_DrawRect(0, h - 2, w, 2)
  end
  self.header.PerformLayout = function(pnl, w, h)
    pnl.closeBtn:SetWide(h)
  end

  self.header.title = self.header:Add("DLabel")
  self.header.title:Dock(LEFT)
  self.header.title:DockMargin(10, 0, 0, 0)
  self.header.title:SetFont("DeltaLib.Frame.Title")
  self.header.title:SetTextColor(color_white)

  self.header.closeBtn = self.header:Add("DButton")
  self.header.closeBtn:Dock(RIGHT)
  self.header.closeBtn:SetText("")
  
  self.header.closeBtn.iconColor = color_white

  self.header.closeBtn.Paint = function(pnl, w, h)
    DeltaLib:DrawImgur(12, 12, w - 24, h - 24, pnl.iconColor, "6AjIb0Q")
  end
  self.header.closeBtn.DoClick = function(pnl)
    self:AlphaTo(0, 0.2, 0, function() self:Remove() end)
    self:SetKeyboardInputEnabled(false)
    self:SetMouseInputEnabled(false)
  end
  self.header.closeBtn.OnCursorEntered = function(pnl)
    DeltaLib:LerpColor(pnl, "iconColor", Color(200, 200, 200))
  end
  self.header.closeBtn.OnCursorExited = function(pnl)
    DeltaLib:LerpColor(pnl, "iconColor", color_white)
  end
end

function PANEL:SetTitle(title)
  self.header.title:SetText(title)
  self.header.title:SizeToContentsX()
end

function PANEL:Paint(w, h)
  local aX, aY = self:LocalToScreen()

  DeltaLib.Shadows.BeginShadow()
    draw_RoundedBox(6, aX, aY, w, h, DeltaLib.Theme.Background)
  DeltaLib.Shadows.EndShadow(1, 1, 1)
end

function PANEL:PerformLayout(w, h)
  self.header:SetTall(40)
end

vgui.Register("DeltaLib.Frame", PANEL, "EditablePanel")