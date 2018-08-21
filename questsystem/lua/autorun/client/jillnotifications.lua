--[[---------------------------------------------------------
	Name: Jill Notifications
	Desc: Heres where we made the notifications.
-----------------------------------------------------------]]

JILL = JILL or {}

local types = { 

	[ "good" ] = Color( 0, 255, 0, 255 ),
	[ "bad" ] = Color( 255, 0, 0, 255 ),
	[ "neutral" ] = Color( 255, 255, 255, 255 )

}

net.Receive( "JillPrint", function( _, ply )

	local typ = string.lower( net.ReadString() )
	local str = net.ReadString()

	if ( types[ typ ] ) then
		
		chat.AddText( Color( 30, 30, 30, 255 ), "[", types[ typ ], "*", Color( 30, 30, 30, 255 ), "] ", types[ typ ], str )

	end

end )