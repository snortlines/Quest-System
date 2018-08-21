AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize( )
	
	self:SetModel( JILL.NPCModel )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE, CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()

end

function ENT:OnTakeDamage( dmg )

	return false

end 	

util.AddNetworkString( "Jill::QuestSystem2::SendQuestUI" )
function ENT:AcceptInput( Name, Activator, Caller )	

	if ( Name == "Use" and Caller:IsPlayer() ) then

		Caller.CurrentNPCID = self.ID

		for k, v in pairs( JILL.Quests ) do

			JILL.UpdateClientsTable( Caller, k )

		end

		net.Start( "Jill::QuestSystem2::SendQuestUI" ) net.Send( Caller )

	end
	
end

function JILL.Deploy()

	if ( not file.IsDir( "jilldir", "DATA" ) ) then
		
		file.CreateDir( "jilldir", "DATA" )
		file.CreateDir( "jilldir/entities/", "DATA" )

	end

	local files, folders = file.Find( "jilldir/*", "DATA" )

	for k, v in pairs( folders ) do
		
		if ( v == "entities" ) then continue end

		local pos = file.Read( "jilldir/" .. v .. "/pos.txt", "DATA" )
		local ang = file.Read( "jilldir/" .. v .. "/ang.txt", "DATA" )
		local header = file.Read( "jilldir/" .. v .. "/header.txt", "DATA" )
		local nmodel = file.Read( "jilldir/" .. v .. "/model.txt", "DATA" )
		local nid = file.Read( "jilldir/" .. v .. "/npc_id.txt", "DATA" )

		if ( not pos or not ang or not header or not nmodel or not nid ) then
			
			print( "The data for " .. tostring( v ) .. " is corrupted, please delete the folder." )
			print( "It is located in: \\garrysmod\\data\\jilldir\\" .. v .. "\\ Thank you." )

			return

		end

		local ent = ents.Create( "jill" )
		ent:SetPos( Vector( pos ) )
		ent:SetAngles( Angle( ang ) )
		ent.Header = header
		ent.NModel = nmodel
		ent.ID = nid
		ent:SetNPCHeader( header )
		ent:SetNPCUniqueID( nid )
		ent:Spawn()
		ent:SetModel( nmodel or "models/Humans/Group01/Female_01.mdl" )

	end

end
hook.Add( "InitPostEntity", "DeployJill", JILL.Deploy )

local Client = FindMetaTable( "Player" )
function Client:GiveReward( QuestID )

	if ( not self:GetNWBool( QuestID .. "_Completed", false ) ) then return end

	local Reward = JILL.Quests[ QuestID ][ 1 ][ 1 ][ "reward" ]

	for k, v in pairs( Reward ) do
		
		if ( JILL.RewardFunctions[ k ] ) then
			
			JILL.RewardFunctions[ k ]( self, v )

			self:MessageClient( "good", "You have received " .. v .. " for completing this quest." )

		end

	end

end

util.AddNetworkString( "Jill:QuestAccepted" )
net.Receive( "Jill:QuestAccepted", function( _, ply )
	
	local ent = net.ReadEntity()

	if ( not ent == ply ) then return end

	--Edited 16/08/17;
	local canContinue = false;
	for k, v in pairs( ents.GetAll() ) do
		if (v:GetClass() == "jill") then
			if (v:GetPos():Distance( ply:GetPos() ) < 250) then
				canContinue = true;
				break;
			end
		end
	end

	--Edited 16/08/17;
	if (not canContinue) then return; end

	local QuestID = net.ReadString()
	local QuestItem = JILL.Quests[ QuestID ][ 1 ][ 1 ][ "entity" ] or nil
	local RefuseQuest = JILL.Quests[ QuestID ][ 1 ][ 1 ][ "refuse" ] or nil
	local RefuseType = JILL.Quests[ QuestID ][ 1 ][ 1 ][ "refusetype" ] or "blacklist"
	local CurrentQuests = ply:GetNWInt( "JillCurrentQuests", 0 )
	local Repeatable = JILL.Quests[ QuestID ][ 1 ][ 1 ][ "repeatable" ] or false
	local CompletionTime = JILL.Quests[ QuestID ][ 1 ][ 1 ][ "completiontime" ] or JILL.QuestCompletionTime
	local CooldownTime = JILL.Quests[ QuestID ][ 1 ][ 1 ][ "cooldown" ] or JILL.QuestCooldown
	local StoredPly = ply

	if ( JILL.QuestLimit > 0 and CurrentQuests >= JILL.QuestLimit ) then ply:MessageClient( "bad", "You have reached the quest limit. Complete your current quest(s) to be able to do more!" ) return end
	if ( ply:GetNWBool( QuestID .. "_Accepted", false ) or ply:GetNWBool( QuestID .. "_Completed", false ) ) then return end
	if ( not JILL.EveryoneCanQuest and JILL.Quests[ QuestID ][ "taken" ] or ply:GetNWBool( QuestID .. "_Taken", false ) ) then ply:MessageClient( "bad", "You have already taken this quest" ) return end
	if ( ply:GetPData( QuestID .. "_Completed", false ) and not Repeatable ) then ply:MessageClient( "bad", "This is not a repeatable quest" ) return end
	if ( RefuseQuest and RefuseType == "blacklist" and RefuseQuest[ team.GetName( ply:Team() ) ] ) then ply:MessageClient( "bad", "You're unable to accept this quest due to your job." ) return end
	if ( RefuseQuest and RefuseType == "whitelist" and not RefuseQuest[ team.GetName( ply:Team() ) ] ) then ply:MessageClient( "bad", "You're unable to accept this quest due to your job." ) return end

	JILL.Quests[ QuestID ][ 1 ][ 1 ][ "OnAccept" ] = JILL.Quests[ QuestID ][ 1 ][ 1 ][ "OnAccept" ] or function() return end
	JILL.Quests[ QuestID ][ 1 ][ 1 ][ "OnAccept" ]( ply )

	if ( QuestItem and QuestItem != "NULL" ) then

		local files, folder = file.Find( "jilldir/entities/" .. QuestItem .. "/*", "DATA" )

		for k, v in pairs( files ) do

			local pos = file.Read( "jilldir/entities/" .. QuestItem .. "/" .. k .. "_pos.txt", "DATA" )

			pos = tostring( pos )

			local ent = ents.Create( QuestItem )
			ent:SetPos( Vector( pos ) )
			ent.questowner = ply
			ent:Spawn()

			local phys = ent:GetPhysicsObject()

			if ( IsValid( phys ) ) then
					
				phys:Wake()

			end

		end

	end

	if ( JILL.EveryoneCanQuest ) then

		ply:SetNWBool( QuestID .. "_Taken", true )

	else

		JILL.Quests[ QuestID ][ "taken" ] = true

	end

	ply:SetNWBool( QuestID .. "_Accepted", true )
	ply:SetNWInt( QuestID .. "_Collected", 0 )
	ply:SetNWBool( QuestID .. "_Completed", false )
	ply:SetNWInt( "JillCurrentQuests", CurrentQuests + 1 )

	hook.Call( "Fluffy_QuestSystem_OnAccept", nil, ply, QuestID )

	ply:MessageClient( "good", "You have accepted this quest." )

	local CompletionTimerIdentifier = JILL.EveryoneCanQuest and "QuestCompletionTime_" .. QuestID .. "_" .. ply:SteamID64() or "QuestCompletionTime_" .. QuestID
	local CooldownTimerIdentifier  = JILL.EveryoneCanQuest and "QuestCooldown_" .. QuestID .. "_" .. ply:SteamID64() or "QuestCooldown_" .. QuestID

	timer.Create( CompletionTimerIdentifier, CompletionTime, 1, function() 
			
		if ( not JILL.EveryoneCanQuest and JILL.Quests[ QuestID ][ "taken" ] or ply:GetNWBool( QuestID .. "_Taken", false ) ) then
				
			if ( ply:GetNWBool( QuestID .. "_Accepted", false ) or ply:GetNWBool( QuestID .. "_Completed", false ) ) then
					
				for _, v in pairs( ents.GetAll() ) do

					if ( v:GetClass() == QuestItem and v.questowner == ply ) then
							
						v:Remove()
							
					end

				end

				ply:SetNWBool( QuestID .. "_Completed", false )
				ply:SetNWBool( QuestID .. "_Accepted", false )
				ply:SetNWBool( QuestID .. "_Collected", 0 )

				-- Edited 11/11/17
				ply:SetNWFloat( "JillCurrentQuests", ply:GetNWFloat("JillCurrentQuests", 0) - 1);
				ply:MessageClient( "bad", "You were unable to complete the quest in time, therefore, this quest has been reset." )

			else

				for _, v in pairs( ents.GetAll() ) do
						
					if ( v:GetClass() == QuestItem and v.questowner == StoredPly ) then
							
						v:Remove()

					end

				end

			end

			if ( timer.Exists( CooldownTimerIdentifier ) ) then return end

			timer.Create( CooldownTimerIdentifier, CooldownTime, 1, function()

				if ( not JILL.EveryoneCanQuest and JILL.Quests[ QuestID ][ "taken" ] or ply:GetNWBool( QuestID .. "_Taken", false ) ) then
						
					ply:SetNWBool( QuestID .. "_Taken", false )
					JILL.Quests[ QuestID ][ "taken" ] = false

				end

			end )

		end

	end )

end )

util.AddNetworkString( "Jill:QuestCompleted" )
net.Receive( "Jill:QuestCompleted", function( _, ply )

	local QuestID = net.ReadString()
	local CurrentQuests = ply:GetNWInt( "JillCurrentQuests", 0 )
	local CooldownTime = JILL.Quests[ QuestID ][ 1 ][ 1 ][ "cooldown" ] or JILL.QuestCooldown
	local CooldownTimerIdentifier  = JILL.EveryoneCanQuest and "QuestCooldown_" .. QuestID .. "_" .. ply:SteamID64() or "QuestCooldown_" .. QuestID

	if ( not ply:GetNWBool( QuestID .. "_Completed", false ) ) then return end
	
	ply:GiveReward( QuestID )

	JILL.Quests[ QuestID ][ 1 ][ 1 ][ "OnComplete" ] = JILL.Quests[ QuestID ][ 1 ][ 1 ][ "OnComplete" ] or function() return end
	JILL.Quests[ QuestID ][ 1 ][ 1 ][ "OnComplete" ]( ply )

	ply:SetNWBool( QuestID .. "_Completed", false )
	ply:SetPData( QuestID .. "_Completed", true )
	ply:SetNWInt( "JillCurrentQuests", CurrentQuests - 1 )

	hook.Call( "Fluffy_QuestSystem_OnCompleted", nil, ply, QuestID )

	timer.Create( CooldownTimerIdentifier, CooldownTime, 1, function()

		if ( not JILL.EveryoneCanQuest and JILL.Quests[ QuestID ][ "taken" ] or ply:GetNWBool( QuestID .. "_Taken", false ) ) then
						
			ply:SetNWBool( QuestID .. "_Taken", false )
			JILL.Quests[ QuestID ][ "taken" ] = false

		end

	end )

end )

-- Edited 12/11/17
hook.Add("PostCleanupMap", "Jill:RestoreNPCS", function()
	JILL.Deploy();
end);