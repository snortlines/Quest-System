include('shared.lua')

net.Receive( "UpdateReward", function( _, ply )

	local int = net.ReadInt( 32 )

	JILL.Quests[ 8 ][ "Reward" ] = int

end )

surface.CreateFont( "3D2DJill", { font = "Arial", size = 50 } )

function ENT:Draw()

	self:DrawModel()

	if ( IsValid( self ) && LocalPlayer():GetPos():Distance( self:GetPos() ) < 500 ) then

		 local ang = Angle( 0, ( LocalPlayer():GetPos() - self:GetPos() ):Angle()[ "yaw" ], ( LocalPlayer():GetPos() - self:GetPos() ):Angle()[ "pitch" ] ) + Angle( 0, 90, 90 )

		cam.IgnoreZ( false )
		cam.Start3D2D( self:GetPos() + Vector( 0, 0, 70 ), ang, .10 )

			draw.SimpleTextOutlined( "Cocaine Plant", "3D2DJill", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, .5, Color( 0, 0, 0, 255 ) )

		cam.End3D2D()

	end

end