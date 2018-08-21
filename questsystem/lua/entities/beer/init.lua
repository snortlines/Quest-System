AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize( )
	
	self:SetModel( "models/props/cs_militia/caseofbeer01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self.Needed = 0
	self.Have = 0

end

function ENT:OnTakeDamage( dmg )

	return false

end 	

function ENT:AcceptInput( Name, Activator, Caller )	

	if ( Name == "Use" and Caller:IsPlayer() ) then

		if ( not Caller:GetNWBool( "Jill_Default_Quest_2_Accepted", false ) ) then return end
		Caller.Beer = Caller.Beer or 0

		local files, folder = file.Find( "jilldir/entities/beer/*", "DATA" )

		for k, v in pairs( files ) do
				
			self.Needed = self.Needed + 1

		end

		Caller.Beer = Caller.Beer + 1

		if ( Caller.Beer == self.Needed ) then
			
			Caller:SetNWBool( "Jill_Default_Quest_2_Accepted", false )
			Caller:SetNWBool( "Jill_Default_Quest_2_Completed", true )			
			Caller.Beer = 0

			Caller:MessageClient( "good", "This looks like the case of beer(s) jill wanted, let's get it back to her." )

			hook.Call( "Fluffy_QuestSystem_OnObjectiveCompleted", nil, Caller, "Jill_Default_Quest_2");

		end

		self:Remove()

	end
	
end