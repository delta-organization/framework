local scrH = ScrH()
hook.Add("OnScreenSizeChanged", "DeltaLib.UpdateScreenHeight", function()
  scrH = ScrH()
end)

local math_Round = math.Round
function DeltaLib:Scale(num)
  return math_Round(scrH / 1080 * num)
end

function DeltaLib:MakeFont(name, size, weight)
  weight = weight or 500

  surface.CreateFont(name, {
    font = "Nunito Sans",
    size = size,
    weight = weight
  })
end

function DeltaLib:AddPanelHook(pnl, hookName, hookFunc)
  hook.Add(hookName, pnl, function(pnl, ...)
    return hookFunc(...)
  end)
end

-- Credits: https://gist.github.com/theawesomecoder61/d2c3a3d42bbce809ca446a85b4dda754
local math_rad = math.rad
local math_cos = math.cos
local math_sin = math.sin
local surface_SetDrawColor = surface.SetDrawColor
local draw_NoTexture = draw.NoTexture
local surface_DrawPoly = surface.DrawPoly

function DeltaLib:PrecacheArc(x, y, ang, p, rad, seg)
	local cir = {}
	cir[1] = {x = x, y = y}

	for i = 0, seg do
		local a = math_rad((i / seg) * -p + ang)
		cir[#cir + 1] = {x = x + math_sin(a) * rad, y = y + math_cos(a) * rad}
	end

	return cir
end

function DeltaLib:DrawPrecachedArc(arc, color)
	surface_SetDrawColor(color)
	draw_NoTexture()
	surface_DrawPoly(arc)
end

function DeltaLib:DrawArc(x, y, ang, p, rad, seg, color)
	self:DrawPrecachedArc(
		self:PrecacheArc(x, y, ang, p, rad, seg), color
	)
end

-- Gotta love how many functions stencils need
local render_ClearStencil = render.ClearStencil
local render_SetStencilEnable = render.SetStencilEnable
local render_SetStencilWriteMask = render.SetStencilWriteMask
local render_SetStencilTestMask = render.SetStencilTestMask
local render_SetStencilFailOperation = render.SetStencilFailOperation
local render_SetStencilPassOperation = render.SetStencilPassOperation
local render_SetStencilZFailOperation = render.SetStencilZFailOperation
local render_SetStencilCompareFunction = render.SetStencilCompareFunction
local render_SetStencilReferenceValue = render.SetStencilReferenceValue
local STENCILOPERATION_REPLACE = STENCILOPERATION_REPLACE
local STENCILOPERATION_KEEP = STENCILOPERATION_KEEP
local STENCILCOMPARISONFUNCTION_NEVER = STENCILCOMPARISONFUNCTION_NEVER
local STENCILCOMPARISONFUNCTION_EQUAL = STENCILCOMPARISONFUNCTION_EQUAL
local STENCILCOMPARISONFUNCTION_NOTEQUAL = STENCILCOMPARISONFUNCTION_NOTEQUAL

-- Credits to: https://github.com/Lexicality/stencil-tutorial
function DeltaLib:Mask(maskFunc, drawFunc)
	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_KEEP)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	maskFunc()

	render.SetStencilFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)

	drawFunc()

	render.SetStencilEnable(false)
	render.ClearStencil()
end


function DeltaLib:MaskInverse(maskFunc, drawFunc)
  render_ClearStencil()
	render_SetStencilEnable(true)

	render_SetStencilWriteMask(1)
	render_SetStencilTestMask(1)

	render_SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render_SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render_SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render_SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render_SetStencilReferenceValue(1)

	maskFunc()

	render_SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render_SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render_SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render_SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)
	render_SetStencilReferenceValue(0)

	drawFunc()

	render_SetStencilEnable(false)
	render_ClearStencil()
end