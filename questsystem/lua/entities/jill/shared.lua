ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.AutomaticFrameAdvance = true
local PLAYER = FindMetaTable( "Player" )

function ENT:SetAutomaticFrameAdvance( bUsingAnim )

	self.AutomaticFrameAdvance = bUsingAnim
	
end

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "NPCHeader" )
	self:NetworkVar( "String", 1, "NPCUniqueID" )

end