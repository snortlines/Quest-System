AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString( "UpdateReward" )

function ENT:Initialize( )
	
	self:SetModel( "models/props/cs_office/plant01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

end

function ENT:OnTakeDamage( dmg )

	return false

end 	

function ENT:AcceptInput( Name, Activator, Caller )	

	if ( Name == "Use" and Caller:IsPlayer() ) then

		if ( not Caller:GetNWBool( "Jill_Default_Quest_6_Accepted", false ) ) then return end

		self:Remove()

		Caller.JillPlants = Caller.JillPlants or 0
		Caller.JillPlants = Caller.JillPlants + 1

		if ( Caller.JillPlants == 1  ) then

			Caller:MessageClient( "bad", "Jill said that the alarm would go off when I picked the first one up. I should hurry." )

			for k, v in pairs( player.GetAll() ) do
					
				if ( JILL.PoliceNotifications[ v:Team() ] ) then

					v:MessageClient( "bad", "Attention please! There has been a security breach within our station, please, all units respond." )

					v:EmitSound( "npc/overwatch/radiovoice/allteamsrespondcode3.wav" )

				end

			end

			Caller:MessageClient( "good", "I got one! I could continue gathering more drugs for more money or I could back out and deliver the quest." )

			Caller:SetNWBool( "Jill_Default_Quest_6_Completed", true )

			hook.Call( "Fluffy_QuestSystem_OnObjectiveCompleted", nil, Caller, "Jill_Default_Quest_6");

		end

		JILL.Quests[ "Jill_Default_Quest_6" ][ 1 ][ 1 ][ "reward" ] = { [ "darkrp_money" ] = JILL.Quests[ "Jill_Default_Quest_6" ][ 1 ][ 1 ][ "reward" ][ "darkrp_money" ] + JILL.CocainePlantReward }

	end

end