AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize( )
	
	self:SetModel( "models/props_junk/garbage_takeoutcarton001a.mdl" )
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

		if ( not Caller:GetNWBool( "Jill_Default_Quest_4_Accepted", false ) ) then return end
		Caller.Noodles = Caller.Noodles or 0

		local files, folder = file.Find( "jilldir/entities/noodles/*", "DATA" )

		for k, v in pairs( files ) do
				
			self.Needed = self.Needed + 1

		end

		Caller.Noodles = Caller.Noodles + 1

		if ( Caller.Noodles == self.Needed ) then
			
			Caller:SetNWBool( "Jill_Default_Quest_4_Accepted", false )
			Caller:SetNWBool( "Jill_Default_Quest_4_Completed", true )			
			Caller.Noodles = 0

			Caller:MessageClient( "good", "This looks like noodles(s) jill wanted, let's get it back to her." )

			hook.Call( "Fluffy_QuestSystem_OnObjectiveCompleted", nil, Caller, "Jill_Default_Quest_4");

		end

		self:Remove()

	end
	
end