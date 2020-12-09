net.Receive("DeltaLib.Notification", function()
	local msg = net.ReadString()
	local notifyType = net.ReadUInt(3)
	local length = net.ReadUInt(3)

	notification.AddLegacy(msg, notifyType, length)
end)

net.Receive("DeltaLib.SimpleChatMessage", function()
	local msg = net.ReadString()
	local prefix = net.ReadString()
	local prefixCol = net.ReadColor()

	chat.AddText(prefixCol, prefix, Color(200, 200, 200), msg)
end)

net.Receive("DeltaLib.ChatMessage", function()
	local args = {}
	
	for i = 1, net.ReadUInt(4) do
		table.insert(args, Either(net.ReadBool(), net.ReadColor(), net.ReadString()))
	end

	chat.AddText(args)
end)