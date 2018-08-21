--[[---------------------------------------------------------
	Name: Jill Help Functions
	Desc: Heres where you'll find the help functions
-----------------------------------------------------------]]

JILL = JILL or {}

util.AddNetworkString( "Jill::SavePosition" )
net.Receive( "Jill::SavePosition", function( _, ply )

	if ( not ply:IsSuperAdmin() ) then return end

	local data = net.ReadTable()

	if ( not file.IsDir( "jilldir/entities/", "DATA" ) ) then
		
		ply:MessageClient( "bad", JILL.Error_Three )

		return

	end

	if ( not file.IsDir( "jilldir/entities/" .. data[ 1 ][ "ent" ]:GetClass(), "DATA" ) ) then
		
		file.CreateDir( "jilldir/entities/" .. data[ 1 ][ "ent" ]:GetClass(), "DATA" )

		ply:MessageClient( "good", "'" .. data[ 1 ][ "ent" ]:GetClass() .. "' does not exist, but was created successfully." )

	end

	local files, folders = file.Find( "jilldir/entities/" .. data[ 1 ][ "ent" ]:GetClass() .. "/*", "DATA" )

	for k, v in pairs( files ) do
		
		file.Delete( "jilldir/entities/" .. data[ 1 ][ "ent" ]:GetClass() .. "/" .. v )

	end

	for k, v in pairs( data ) do

		file.Write( "jilldir/entities/" .. v[ "ent" ]:GetClass() .. "/" .. k .. "_pos.txt", tostring( v[ "pos" ] ) )

		v[ "ent" ]:Remove()

	end

	ply:MessageClient( "good", "Successfully saved all the positions for '" .. data[ 1 ][ "ent" ]:GetClass() .. "'" )

	ply:MessageClient( "good", "Removed all " .. data[ 1 ][ "ent" ]:GetClass() .. "'s. Next time someone takes this quest the " .. data[ 1 ][ "ent" ]:GetClass() .. "'s will spawn at the saved locations."  )

end )

util.AddNetworkString( "Jill::SpawnEntity" )
net.Receive( "Jill::SpawnEntity", function( _, ply ) 

	if ( not ply:IsSuperAdmin() ) then return end

	local Vec = net.ReadVector()
	local ent = string.lower( net.ReadString() )

	local SpawnedEntity = ents.Create( tostring( ent ) )
	if ( not IsValid( SpawnedEntity ) ) then return end
	SpawnedEntity:SetPos( Vector( Vec.x, Vec.y, Vec.z ) )
	SpawnedEntity:Spawn()

end )

util.AddNetworkString( "QuestSystem::SaveNPC" )
net.Receive( "QuestSystem::SaveNPC", function( _, ply )

	if ( not ply:IsSuperAdmin() ) then return end

	local Header = net.ReadString()
	local NModel = net.ReadString()
	local ID = net.ReadString()

	local QNPC = ents.Create( "jill" )
	QNPC:SetPos( ply:GetEyeTrace().HitPos )
	QNPC.Header = Header
	QNPC.NModel = NModel
	QNPC.ID = ID
	QNPC:SetNPCHeader( Header )
	QNPC:SetNPCUniqueID( ID )
	QNPC:Spawn()
	QNPC:SetModel( NModel )

end )

util.AddNetworkString( "QuestSystem::EditNPC" )
net.Receive( "QuestSystem::EditNPC", function( _, ply )

	if ( not ply:IsSuperAdmin() ) then return end

	local npc = net.ReadEntity()
	local Header = net.ReadString()
	local NModel = net.ReadString()
	local ID = net.ReadString()

	if ( not ID or ID == nil ) then ply:MessageClient( "bad", "Skipping NPC as custom ID does not exist" ) return end

	local oldID = IsValid( npc ) and npc.ID or 0

	file.Delete( "jilldir/" .. oldID .."/header.txt", "DATA" )
	file.Delete( "jilldir/" .. oldID .."/model.txt", "DATA" )
	file.Delete( "jilldir/" .. oldID .."/npc_id.txt", "DATA" )
	file.Delete( "jilldir/" .. oldID .."/pos.txt", "DATA" )
	file.Delete( "jilldir/" .. oldID .."/ang.txt", "DATA" )
	file.Delete( "jilldir/" .. oldID, "DATA" )

	file.CreateDir( "jilldir/" .. ID, "DATA" )

	if ( IsValid( npc ) ) then
		
		local pos = npc:GetPos()
		local ang = npc:GetAngles()

		npc:SetNPCHeader( Header )
		npc:SetNPCUniqueID( ID )
		npc:SetModel( NModel )
		npc.ID = ID
		npc.Header = Header
		npc.NModel = NModel

		file.Write( "jilldir/" .. ID .. "/pos.txt", tostring( pos ) )
		file.Write( "jilldir/" .. ID .. "/ang.txt", tostring( ang ) )		
		file.Write( "jilldir/" .. ID .. "/header.txt", tostring( Header ) )
		file.Write( "jilldir/" .. ID .. "/model.txt", tostring( NModel ) )
		file.Write( "jilldir/" .. ID .. "/npc_id.txt", tostring( ID ) )

	end

	ply:MessageClient( "good", "Successfully edited: " .. ID )	

end )

util.AddNetworkString( "QuestSystem::DeleteNPC" )
net.Receive( "QuestSystem::DeleteNPC", function( _, ply )

	if ( not ply:IsSuperAdmin() ) then return end

	local ent = net.ReadEntity()
	local id = net.ReadString()

	if ( not file.IsDir( "jilldir/" .. id, "DATA" ) ) then return end

	file.Delete( "jilldir/" .. id .."/header.txt", "DATA" )
	file.Delete( "jilldir/" .. id .."/model.txt", "DATA" )
	file.Delete( "jilldir/" .. id .."/npc_id.txt", "DATA" )
	file.Delete( "jilldir/" .. id .."/pos.txt", "DATA" )
	file.Delete( "jilldir/" .. id .."/ang.txt", "DATA" )
	file.Delete( "jilldir/" .. id, "DATA" )

	if ( IsValid( ent ) ) then

		ent:Remove()

	end

	ply:MessageClient( "good", "Successfully deleted NPC: " .. id  )

end )