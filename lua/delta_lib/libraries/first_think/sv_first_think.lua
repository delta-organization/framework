util.AddNetworkString("DeltaLib.PlayerFirstThink")

net.Receive("DeltaLib.PlayerFirstThink", function(_, ply)
  hook.Run("DeltaLib.PlayerFirstThink", ply)
end)