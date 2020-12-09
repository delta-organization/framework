local PANEL = {}

local draw_RoundedBox = draw.RoundedBox
local draw_RoundedBoxEx = draw.RoundedBoxEx
local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawTexturedRect = surface.DrawTexturedRect

local closeMaterial = Material("nil", "noclamp smooth")
DeltaLib:DownloadImgur("6AjIb0Q"):onResolved(function(mat)
  closeMaterial = mat
end)

DeltaLib:MakeFont("DeltaLib.Frame.Title", 24)

function PANEL:Init()
  self.header = self:Add("Panel")
  self.header:Dock(TOP)

  self.header.Paint = function(pnl, w, h)
    draw_RoundedBoxEx(6, 0, 0, w, h, DeltaLib.Theme.Header, true, true, false, false)
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
  
  self.header.closeBtn.Paint = function(pnl, w, h)
    surface_SetMaterial(closeMaterial)
    surface_SetDrawColor(color_white)
    surface_DrawTexturedRect(12, 12, w - 24, h - 24)
  end
  self.header.closeBtn.DoClick = function(pnl)
    self:Remove()
  end
end

function PANEL:SetTitle(title)
  self.header.title:SetText(title)
  self.header.title:SizeToContentsX()
end

function PANEL:Paint(w, h)
  local aX, aY = self:LocalToScreen()

  BSHADOWS.BeginShadow()
    draw_RoundedBox(6, aX, aY, w, h, DeltaLib.Theme.Background)
  BSHADOWS.EndShadow(1, 1, 1)
end

function PANEL:PerformLayout(w, h)
  self.header:SetTall(40)
end

vgui.Register("DeltaLib.Frame", PANEL, "EditablePanel")

local TPANEL = {}

function TPANEL:Init()
  self.sidebar = vgui.Create("DeltaLib.Sidebar", self)
  self.sidebar:Dock(LEFT)
  self.sidebar:SetBody(self)
  self.sidebar:AddTab("pog", "rEpoowi", "Panel")
  self.sidebar:AddTab("pog", "RkCJMR3", "Panel")
  self.sidebar:AddTab("pog", "3r0i6Hi", "Panel")
end

function TPANEL:PerformLayout(w, h)
  self.sidebar:SetWide(w*.2)
end

vgui.Register("testpanel", TPANEL)

concommand.Add("pogchamp", function()
  local m = vgui.Create("DeltaLib.Frame")
  m:SetSize(1000, 800)
  m:Center()
  m:MakePopup()
  m:SetTitle("Pog Champers")

  m.navbar = m:Add("DeltaLib.Navbar")
  m.navbar:Dock(TOP)
  m.navbar:SetTall(55)
  m.navbar:SetBody(m)
  m.navbar:AddTab("INVENTORY", "testpanel")
  m.navbar:AddTab("SHOP", "testpanel")
  m.navbar:AddTab("SETTINGS", "Panel")
  m.navbar:AddTab("ADMIN", "Panel", true)
  m.navbar:AddTab("PLAYERS", "Panel", true)
end)