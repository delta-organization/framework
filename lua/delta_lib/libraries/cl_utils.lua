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
    font = "Raleway Medium",
    size = size,
    weight = weight
  })
end

function DeltaLib:AddPanelHook(pnl, hookName, hookFunc)
  hook.Add(hookName, pnl, function(pnl, ...)
    return hookFunc(...)
  end)
end