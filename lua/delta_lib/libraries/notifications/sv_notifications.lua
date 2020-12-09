util.AddNetworkString("DeltaLib.Notification")
util.AddNetworkString("DeltaLib.SimpleChatMessage")
util.AddNetworkString("DeltaLib.ChatMessage")

function DeltaLib:SendNotification(ply, msg, notifyType, length)
	notifyType = notifyType or NOTIFY_GENERIC
	length = length or 2

	net.Start("DeltaLib.Notification")
		net.WriteString(message)
		net.WriteUInt(notifyType, 3)
		net.WriteUInt(length, 3)
	net.Send(ply)
end

function DeltaLib:SendSimpleChatMessage(ply, msg, msgColor, prefix, prefixCol)
	prefix = prefix or "Delta"
	prefixCol = prefixCol or Color(255, 0, 0)

	net.Start("DeltaLib.ChatMessage")
		net.WriteString(msg)
		net.WriteString(prefix)
		net.WriteColor(prefixCol)
	net.Send(ply)
end	

function DeltaLib:SendChatMessage(ply, ...)
	local args = {...}

	net.Start("DeltaLib.ChatMessage")
		net.WriteUInt(#args, 4)
		for _, arg in ipairs(args) do
			local isColor = IsColor(arg)

			net.WriteBool(isColor)
			if isColor then
				net.WriteColor(arg)
			else
				net.WriteString(tostring(arg))
			end
		end
	net.Send(ply)
end