local PANEL = {}

AccessorFunc(PANEL, "i_Padding", "Padding")

function PANEL:Init()
	self.canvas = self:Add("Panel")
	self.canvas:SetMouseInputEnabled(true)

	self.canvas.PerformLayout = function()
		self:PerformLayoutInternal()
		self:InvalidateParent()
	end
    self.canvas.OnMousePressed = function(pnl, code)
        return pnl:GetParent():OnMousePressed(code)
    end

	self.bar = self:Add("DeltaLib.Scrollbar")
	self.bar:Dock( RIGHT )

	self:SetPadding(0)
	self:SetMouseInputEnabled(true)
end

function PANEL:AddItem(pnl)
	pnl:SetParent(self:GetCanvas())
end

function PANEL:OnChildAdded(child)
	self:AddItem(child)
end

function PANEL:SizeToContents()
	self:SetSize(self.pnlCanvas:GetSize())
end

function PANEL:GetScrollbar()
	return self.bar
end

function PANEL:GetCanvas()
	return self.canvas
end

function PANEL:InnerWidth()
	return self:GetCanvas():GetWide()
end

function PANEL:Rebuild()
	self:GetCanvas():SizeToChildren(false, true)

	-- Although this behaviour isn't exactly implied, center vertically too
	if ( self.m_bNoSizing && self:GetCanvas():GetTall() < self:GetTall() ) then

		self:GetCanvas():SetPos( 0, ( self:GetTall() - self:GetCanvas():GetTall() ) * 0.5 )

	end
end

function PANEL:OnMouseWheeled(delta)
	return self.bar:OnMouseWheeled(delta)
end

function PANEL:OnVScroll(offset)
	self:GetCanvas():SetPos(0, offset)
end

function PANEL:ScrollToChild(pnl)
	self:InvalidateLayout(true)

	local x, y = self:GetCanvas():GetChildPosition(pnl)
	local w, h = pnl:GetSize()

	y = y + h * 0.5
	y = y - self:GetTall() * 0.5

	self.bar:AnimateTo(y, 0.5, 0, 0.5)
end

-- Avoid an infinite loop
function PANEL:PerformLayoutInternal()
    local w, h = self:GetWide(), self:GetTall()
	local canvasH, canvasW, yPos = self:GetCanvas():GetTall(), w, 0

	self:Rebuild()

	self.bar:SetUp(h, canvasH)
	yPos = self.bar:GetOffset()

	if self.bar.Enabled then 
        canvasW = canvasW - self.bar:GetWide()
    end

	self:GetCanvas():SetPos(0, yPos)
	self:GetCanvas():SetWide(canvasW)

	self:Rebuild()

	if canvasH ~= self:GetCanvas():GetTall() then
		self.bar:SetScroll(self.bar:GetScroll())
	end
end

function PANEL:PerformLayout()
	self:PerformLayoutInternal()
end

function PANEL:Clear()
	return self:GetCanvas():Clear()
end

vgui.Register("DeltaLib.Scrollpanel", PANEL, "Panel")

concommand.Add("testtt", function()
    local frame = vgui.Create("DeltaLib.Frame")
    frame:SetSize(1000, 800)
    frame:Center()
    frame:MakePopup()

    local scroll = frame:Add("XeninUI.ScrollPanel")
    scroll:Dock(FILL)
    scroll:DockMargin(16, 16, 16, 16)
    
    for i = 1, 100 do
        local pnl = scroll:Add("DPanel")
        pnl:Dock(TOP)
        pnl:DockMargin(0, 0, 0, 8)
        pnl:SetBackgroundColor(ColorRand())
    end
end)