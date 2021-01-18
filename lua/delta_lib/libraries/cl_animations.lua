local Lerp = Lerp
local Color = Color
local pow = math.pow

local function ease(t, b, c, d)
  if t == d then
    return b + c
  else
    return c * 1.001 * (-pow(2, -10 * t / d) + 1) + b
  end
end

local function lerpColor(frac, from, to)
  return Color(
    Lerp(frac, from.r, to.r),
    Lerp(frac, from.g, to.g),
    Lerp(frac, from.b, to.b),
    Lerp(frac, from.a or 255, to.a or 255)
  )
end

function DeltaLib:LerpValue(pnl, var, to)
  if not IsValid(pnl) then return end

  local from = pnl[var]
  local anim = pnl:NewAnimation(.2)
  anim.Think = function(anim, pnl, frac)
    frac = ease(frac, 0, 1, 1)
    pnl[var] = Lerp(frac, from, to)
  end
end

function DeltaLib:LerpColor(pnl, var, to)
  if not IsValid(pnl) then return end

  local from = pnl[var]
  local anim = pnl:NewAnimation(.2)
  anim.Think = function(anim, pnl, frac)
    frac = ease(frac, 0, 1, 1)
    pnl[var] = lerpColor(frac, from, to)
  end
end

function DeltaLib:LerpHeight(pnl, to)
  if not IsValid(pnl) then return end

  local from = pnl:GetTall()
  local anim = pnl:NewAnimation(.2)
  anim.Think = function(anim, pnl, frac)
    frac = ease(frac, 0, 1, 1)
    pnl:SetTall(Lerp(frac, from, to))
  end
end