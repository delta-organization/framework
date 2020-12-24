local LocalPlayer = LocalPlayer
local IsValid = IsValid

hook.Add("Think", "DeltaLib.FirstThink", function()
  if not IsValid(LocalPlayer()) then return end

  net.Start("DeltaLib.PlayerFirstThink")
  net.SendToServer()

  hook.Remove("Think", "DeltaLib.FirstThink")
end)