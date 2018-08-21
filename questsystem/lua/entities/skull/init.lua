AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize( )
	
	self:SetModel( "models/Gibs/HGIBS.mdl" )
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

		if ( not Caller:GetNWBool( "Jill_Default_Quest_3_Accepted", false ) ) then return end

		Caller:SetNWBool( "Jill_Default_Quest_3_Collected", Caller:GetNWBool( "Jill_Default_Quest_3_Collected" ) + 1 )

		if ( Caller:GetNWBool( "Jill_Default_Quest_3_Collected" ) >= 5 ) then
			
			Caller:SetNWBool( "Jill_Default_Quest_3_Accepted", false )
			Caller:SetNWBool( "Jill_Default_Quest_3_Completed", true )
			Caller:SetNWBool( "Jill_Default_Quest_3_Collected", 0 )

			Caller:MessageClient( "good", "This looks likes all the skulls we needed, ugh. Let's get back to jill." )

			hook.Call( "Fluffy_QuestSystem_OnObjectiveCompleted", nil, Caller, "Jill_Default_Quest_3");

		end

		self:Remove()

	end
	
end