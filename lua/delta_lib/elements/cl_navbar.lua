local PANEL = {}

local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local draw_RoundedBox = draw.RoundedBox

DeltaLib:MakeFont("DeltaLib.Navbar.Button", 22)

function PANEL:Init()
  self:DockPadding(8, 8, 8, 8)

  self.buttons = {}
  self.panels = {}
  self.active = 0
end

function PANEL:AddTab(name, class, dockRight)
  local id = #self.buttons + 1

  local btn = self:Add("DButton")
  btn:Dock(dockRight and RIGHT or LEFT)
  btn:DockMargin(dockRight and 8 or 0, 0, dockRight and 0 or 8, 0)
  btn:SetText(name)
  btn:SetFont("DeltaLib.Navbar.Button")
  btn:SizeToContentsX(20)

  btn.textColor = Color(175, 175, 175)
  btn.boxAlpha = 0

  btn.Paint = function(pnl, w, h)
    pnl:SetTextColor(self.active == id and color_white or pnl.textColor)

    draw_RoundedBox(6, 0, 0, w, h, Color(60, 60, 60, pnl.boxAlpha))
  end
  btn.DoClick = function(pnl)
    self:SetActive(id)
  end
  btn.OnCursorEntered = function(pnl)
    DeltaLib:LerpColor(pnl, "textColor", Color(220, 220, 220))
  end
  btn.OnCursorExited = function(pnl)
    DeltaLib:LerpColor(pnl, "textColor", Color(175, 175, 175))
  end

  self.buttons[id] = btn

  local pnl = self:GetBody():Add(class)
  pnl:Dock(FILL)
  pnl:SetVisible(false)

  self.panels[id] = pnl
  return id
end

function PANEL:SetActive(id, noAnim)
  local panel = self.panels[id]
  if not IsValid(panel) then return end

  local activePnl = self.panels[self.active]
  if IsValid(activePnl) then
    activePnl:SetVisible(false)

    if not noAnim then
      DeltaLib:LerpValue(self.buttons[self.active], "boxAlpha", 0)
    end
  end

  panel:SetVisible(true)

  if not noAnim then
    DeltaLib:LerpValue(self.buttons[id], "boxAlpha", 255)
  end

  self.active = id
end

function PANEL:GetBody()
  return self.body
end

function PANEL:SetBody(pnl)
  self.body = pnl
end

function PANEL:Paint(w, h)
  surface_SetDrawColor(DeltaLib.Theme.Header)
  surface_DrawRect(0, 0, w, h)
end

vgui.Register("DeltaLib.Navbar", PANEL, "EditablePanel")