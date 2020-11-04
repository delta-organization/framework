local PANEL = {}

DeltaLib:MakeFont("DeltaLib.Sidebar.Button", 20)

local ColorAlpha = ColorAlpha
local draw_RoundedBoxEx = draw.RoundedBoxEx
local draw_RoundedBox = draw.RoundedBox

function PANEL:Init()
  self.buttons = {}
  self.panels = {}
  self.active = 0

  self:DockPadding(8, 8, 8, 8)
end

function PANEL:AddTab(name, icon, class, doClickOverride)
  local id = #self.buttons + 1

    local mat = Material("nil")
  if icon then
    DeltaLib:DownloadImgur(icon):onResolved(function(img)
      mat = img
    end)
  end

  local btn = self:Add("DButton")
  btn:Dock(TOP)
  btn:DockMargin(0, 0, 0, 8)
  btn:SetTall(40)
  btn:SetText("")

  btn.textColor = Color(200, 200, 200)
  btn.bgAlpha = 0

  btn.Paint = function(pnl, w, h)
    if pnl.bgAlpha > 0 then
      draw_RoundedBox(6, 0, 0, w, h, ColorAlpha(Color(50, 50, 50), pnl.bgAlpha))
    end

    local textX = icon and 40 or 8

    if icon then
      surface.SetMaterial(mat)
      surface.SetDrawColor(pnl.textColor)
      surface.DrawTexturedRect(8, 8, h-16, h-16)
    end

    draw.SimpleText(name, "DeltaLib.Sidebar.Button", textX, h/2, pnl.textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
  end
  btn.DoClick = function(pnl)
    if isfunction(doClickOverride) then
      return doClickOverride()
    end

    DeltaLib:LerpValue(pnl, "bgAlpha", 255)

    self:SetActive(id)
  end
  btn.OnCursorEntered = function(pnl)
    DeltaLib:LerpColor(pnl, "textColor", color_white)
  end
  btn.OnCursorExited = function(pnl)
    DeltaLib:LerpColor(pnl, "textColor", Color(200, 200, 200))
  end

  self.buttons[id] = btn

  local pnl = self:GetBody():Add(class)
  pnl:Dock(FILL)
  pnl:SetVisible(false)

  self.panels[id] = pnl
end

function PANEL:SetActive(id)

end

function PANEL:GetBody()
  return self.body
end

function PANEL:SetBody(pnl)
  self.body = pnl
end

function PANEL:Paint(w, h)
  draw_RoundedBoxEx(6, 0, 0, w, h, Color(40, 40, 40))
end

function PANEL:PerformLayout(w, h)

end

vgui.Register("DeltaLib.Sidebar", PANEL, "EditablePanel")