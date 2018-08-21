AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize( )
	
	self:SetModel( "models/weapons/w_rif_ak47.mdl" )
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

		if ( not Caller:GetNWBool( "Jill_Default_Quest_7_Accepted", false ) ) then return end
		Caller.LostGun = Caller.LostGun or 0

		self:Remove()

		local files, folder = file.Find( "jilldir/entities/lost/*", "DATA" )

		for k, v in pairs( files ) do
				
			self.Needed = self.Needed + 1

		end

		if ( Caller.LostGun == self.Needed ) then

			Caller:SetNWBool( "Jill_Default_Quest_7_Accepted", false )
			Caller:SetNWBool( "Jill_Default_Quest_7_Completed", true )
			Caller.LostGun = 0

			Caller:MessageClient( "good", "I think I have all the guns now, let's get back to jill." )

			hook.Call( "Fluffy_QuestSystem_OnObjectiveCompleted", nil, Caller, "Jill_Default_Quest_7");

		end

		Caller.LostGun = Caller.LostGun + 1
		
	end
	
end