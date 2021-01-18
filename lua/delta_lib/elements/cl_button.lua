local PANEL = {}

AccessorFunc(PANEL, "c_Color", "Color")
AccessorFunc(PANEL, "c_TextColor", "TextColor")
AccessorFunc(PANEL, "s_Icon", "Icon", FORCE_STRING)
AccessorFunc(PANEL, "f_IconFraction", "IconFraction", FORCE_NUMBER)
AccessorFunc(PANEL, "i_IconMargin", "IconMargin", FORCE_NUMBER)
AccessorFunc(PANEL, "b_Loading", "Loading", FORCE_BOOL)
AccessorFunc(PANEL, "i_Rounding", "Rounding", FORCE_NUMBER)

DeltaLib:MakeFont("DeltaLib.Button.Default", 20)

local draw_RoundedBox = draw.RoundedBox
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local draw_SimpleText = draw.SimpleText
local TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER

function PANEL:Init()
  self:SetText("")
  self:SetColor(DeltaLib.Theme.Navbar)
  self:SetFont("DeltaLib.Button.Default")
  self:SetTextColor(color_white)
  self:SetIconFraction(0.4)
  self:SetIconMargin(8)
  self:SetLoading(false)
  self:SetRounding(6)
end

function PANEL:Paint(w, h)
  draw_RoundedBox(self:GetRounding(), 0, 0, w, h, self:GetColor())

  if self:GetLoading() then
    local loadingSize = h*.7
    DeltaLib:DrawImgur(w * .5, h * .5, loadingSize, loadingSize, color_white, "s79p8Hy", CurTime() * -360 % 360)
    return true
  end

  local text, font, icon = self:GetText(), self:GetFont(), self:GetIcon()
  local hasText, hasIcon = text ~= "", icon ~= nil
  local textX = w * .5

  if hasIcon then
    local iconSize = h * self:GetIconFraction()

    local iconX
    if hasText then
      surface_SetFont(font)
      local textW = surface_GetTextSize(text)
      local margin = self:GetIconMargin()
      local fullW = iconSize + margin + textW

      iconX = w * .5 - fullW * .5
      textX = iconX + iconSize + margin
    else
      iconX = w * .5 - iconSize * .5
    end

    DeltaLib:DrawImgur(iconX, h * .5 - iconSize * .5, iconSize, iconSize, color_white, icon)
  end

  if hasText then
    draw_SimpleText(text, font, textX, h * .5, color_white, hasIcon and TEXT_ALIGN_LEFT or TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end

  return true
end

function PANEL:OnCursorEntered()

end

function PANEL:OnCursorExited()

end

vgui.Register("DeltaLib.Button", PANEL, "DButton")