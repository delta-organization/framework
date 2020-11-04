local PANEL = {}

local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect

DeltaLib:MakeFont("DeltaLib.Navbar.Button", 22)

function PANEL:Init()
  self.buttons = {}
  self.panels = {}
  self.active = 0

  self.lineX = 0
  self.lineW = 0
end

function PANEL:AddTab(name, class, dockRight)
  local id = #self.buttons + 1

  local btn = self:Add("DButton")
  btn:Dock(dockRight and RIGHT or LEFT)
  btn:SetText(name)
  btn:SetFont("DeltaLib.Navbar.Button")
  btn:SetTextColor(Color(200, 200, 200))
  btn:SizeToContentsX(40)

  surface.SetFont("DeltaLib.Navbar.Button")
  btn.textWidth = surface.GetTextSize(name)

  btn.Paint = function(pnl, w, h)

  end
  btn.DoClick = function(pnl)
    self:SetActive(id)
  end
  btn.OnCursorEntered = function(pnl)
    if self.active ~= id then return end

    DeltaLib:LerpValue(self, "lineX", pnl:GetPos())
    DeltaLib:LerpValue(self, "lineW", pnl:GetWide())
  end
  btn.OnCursorExited = function(pnl)
    if self.active ~= id then return end

    DeltaLib:LerpValue(self, "lineX", pnl:GetPos() + (pnl:GetWide() - pnl.textWidth) / 2)
    DeltaLib:LerpValue(self, "lineW", pnl.textWidth)
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
  end

  panel:SetVisible(true)

  -- Line animation
  if not noAnim then
    local btn = self.buttons[id]

    DeltaLib:LerpValue(self, "lineX", btn:GetPos() + (btn:GetWide() - btn.textWidth) / 2)
    DeltaLib:LerpValue(self, "lineW", btn.textWidth)
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
  surface_SetDrawColor(DeltaLib.Theme.Navbar)
  surface_DrawRect(0, 0, w, h)

  surface_SetDrawColor(DeltaLib.Theme.Accent)
  surface_DrawRect(self.lineX, h - 2, self.lineW, 2)
end

vgui.Register("DeltaLib.Navbar", PANEL, "EditablePanel")