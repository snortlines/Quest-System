--[[---------------------------------------------------------
	Name: Jill Chat Functions
	Desc: Heres where you'll find the chat commands
-----------------------------------------------------------]]

JILL = JILL or {}
JILL.ChatCommands = {}

function JILL.ChatCommands.SaveNPC( ply, text )

	text = string.lower( text )
	local FoundNPCS = 0

	if ( string.sub( text, 1, 8 ) == "!savenpc" or string.sub( text, 1, 8 ) == "/savenpc" ) then

		if ( not ply:IsSuperAdmin() ) then ply:MessageClient( "bad", JILL.ChatAccessDenied ) return end

		if ( not file.IsDir( "jilldir", "DATA" ) ) then
			
			file.CreateDir( "jilldir", "DATA" )

		end

		for k, v in pairs( ents.GetAll() ) do

			if ( v:GetClass() == "jill" ) then

				FoundNPCS = FoundNPCS + 1
				
				if ( FoundNPCS == 0 ) then
					
					ply:MessageClient( "bad", JILL.NoNPC )

					return 	

				end

				local pos = v:GetPos()
				local ang = v:GetAngles()
				local nid = v.ID
				local nheader = v.Header
				local nmodel = v.NModel

				if ( not nid or nid == nil ) then ply:MessageClient( "bad", "Skipping NPC as custom ID does not exist" ) continue end
				if ( not file.IsDir( "jilldir/" .. nid, "DATA" ) ) then file.CreateDir( "jilldir/" .. nid, "DATA" ) end

				file.Write( "jilldir/" .. nid .. "/pos.txt", tostring( pos ) )
				file.Write( "jilldir/" .. nid .. "/ang.txt", tostring( ang ) )
				file.Write( "jilldir/" .. nid .. "/header.txt", tostring( nheader ) )
				file.Write( "jilldir/" .. nid .. "/model.txt", tostring( nmodel ) )
				file.Write( "jilldir/" .. nid .. "/npc_id.txt", tostring( nid ) )

				ply:MessageClient( "good", "Saved: " .. nid )

			end

		end

	end
	
end
hook.Add( "PlayerSay", "JILL:SaveChatCommand", JILL.ChatCommands.SaveNPC )

util.AddNetworkString( "Jill::QuestHelpGUI" )
function JILL.ChatCommands.SaveEntityPosition( ply, text )

	text = string.lower( text )

	if ( string.sub( text, 1, 10 ) == "!questhelp" or string.sub( text, 1, 10 ) == "/questhelp" ) then

		if ( not ply:IsSuperAdmin() ) then ply:MessageClient( "bad", JILL.ChatAccessDenied ) return end

		for k, v in pairs( JILL.Help ) do

			JILL.UpdateClientsHelpTable( ply, k )

		end

		for k, v in pairs( JILL.InternalHelpButtons ) do

			JILL.UpdateClientsInternalTable( ply, k )

		end

		net.Start( "Jill::QuestHelpGUI" ) net.WriteEntity( ply ) net.Send( ply )

	end 

end
hook.Add( "PlayerSay", "JILL:SaveEntities", JILL.ChatCommands.SaveEntityPosition )