AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	
	self:SetModel( "models/props_lab/bindergreen.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self.Needed = 0

end

function ENT:OnTakeDamage( dmg )

	return false

end 	

function ENT:AcceptInput( Name, Activator, Caller )	

	if ( Name == "Use" and Caller:IsPlayer() ) then

		if ( not Caller:GetNWBool( "Jill_Default_Quest_1_Accepted", false ) ) then return end
		Caller.Books = Caller.Books or 0

		local files, folder = file.Find( "jilldir/entities/book/*", "DATA" )

		for k, v in pairs( files ) do
				
			self.Needed = self.Needed + 1

		end

		Caller.Books = Caller.Books + 1

		if ( Caller.Books == self.Needed ) then
			
			Caller:SetNWBool( "Jill_Default_Quest_1_Accepted", false )
			Caller:SetNWBool( "Jill_Default_Quest_1_Completed", true )			
			Caller.Books = 0

			Caller:MessageClient( "good", "This looks like book(s) jill wanted, let's get it back to her." )

			hook.Call( "Fluffy_QuestSystem_OnObjectiveCompleted", nil, Caller, "Jill_Default_Quest_1");

		end

		self:Remove()
		
	end
	
end