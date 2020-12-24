local PANEL = {}

DeltaLib:MakeFont("DeltaLib.Sidebar.Button", 20)

local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawRect = surface.DrawRect
local draw_SimpleText = draw.SimpleText
local draw_RoundedBoxEx = draw.RoundedBoxEx

function PANEL:Init()
  self.buttons = {}
  self.panels = {}
  self.active = 0

  self:DockPadding(16, 16, 16, 16)
end

function PANEL:AddTab(name, icon, class, doClickOverride)
  local id = #self.buttons + 1

  local btn = self:Add("DButton")
  btn:Dock(TOP)
  btn:DockMargin(0, 0, 0, 8)
  btn:SetTall(40)
  btn:SetText("")

  btn.textColor = Color(175, 175, 175)

  btn.Paint = function(pnl, w, h)
    local textX = icon and 48 or 12
    local isActive = self.active == id

    if isActive then
      draw.RoundedBox(6, 0, 0, w, h, Color(40, 40, 40))
    end

    if icon then
      DeltaLib:DrawImgur(12, 8, h-16, h-16, ColorAlpha(isActive and DeltaLib.Theme.Accent or pnl.textColor, 150), icon)
    end

    draw_SimpleText(name, "DeltaLib.Sidebar.Button", textX, h/2, isActive and DeltaLib.Theme.Accent or pnl.textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
  end
  btn.DoClick = function(pnl)
    if isfunction(doClickOverride) then
      return doClickOverride()
    end

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
end

function PANEL:SetActive(id)
  local panel = self.panels[id]
  if not IsValid(panel) then return end

  local activePnl = self.panels[self.active]
  if IsValid(activePnl) then
    activePnl:SetVisible(false)
  end

  panel:SetVisible(true)

  self.active = id
end

function PANEL:GetBody()
  return self.body
end

function PANEL:SetBody(pnl)
  self.body = pnl
end

function PANEL:PerformLayout(w, h)

end

vgui.Register("DeltaLib.Sidebar", PANEL, "EditablePanel")