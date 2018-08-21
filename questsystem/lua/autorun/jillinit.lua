--[[-------------------------------------------------------------------
	Name: Jill Init.
	Desc: You can edit the Quests but do NOT edit anything else,
	      unless you want to translate everything to your own language.
	      Quests are located at line: 152 and below.
---------------------------------------------------------------------]]

if ( CLIENT ) then return end

JILL = JILL or {}
JILL.Init = {}
JILL.Init.Client = FindMetaTable( "Player" )

util.AddNetworkString( "JillPrint" )
function JILL.Init.Client:MessageClient( typ, str )

	if ( str == "" or str == nil ) then return end

	net.Start( "JillPrint" )
		net.WriteString( typ )
		net.WriteString( str )
	net.Send( self )

end

util.AddNetworkString( "Jill::UpdateClient" )
function JILL.UpdateClientsTable( ply, QuestID )

	local Repeatable = JILL.Quests[ QuestID ][ 1 ][ 1 ][ "repeatable" ] or false
	local QuestNPC = JILL.Quests[ QuestID ][ 1 ][ 1 ][ "npc" ] or { [ "all" ] = true }
	local Result = QuestNPC[ "all" ] or QuestNPC[ ply.CurrentNPCID ]
	local ShouldDraw = true

	if ( ply:GetPData( QuestID .. "_Completed", false ) and not Repeatable ) then

		ShouldDraw = false

	end

	ShouldDraw = Result

	net.Start( "Jill::UpdateClient" )
		net.WriteString( JILL.Quests[ QuestID ][ "quest" ] )
		net.WriteString( JILL.Quests[ QuestID ][ "questid" ] )
		net.WriteString( JILL.Quests[ QuestID ][ 1 ][ 1 ][ "description" ] or "#ERROR_STRING_DESCRIPTION_NULL" )
		net.WriteString( JILL.Quests[ QuestID ][ 1 ][ 1 ][ "objective" ] or "#ERROR_STRING_OBJECTIVE_NULL" )
		net.WriteTable( JILL.Quests[ QuestID ][ 1 ][ 1 ][ "reward" ] or "#ERROR_STRING_REWARD_NULL" )
		net.WriteBool( ShouldDraw )
		net.WriteBool( JILL.Quests[ QuestID ][ "taken" ] )
		net.WriteInt( JILL.Quests[ QuestID ][ "order" ], 32 )
		net.WriteBool( tobool( JILL.Quests[ QuestID ][ "completed" ] ) )
	net.Send( ply )

end

util.AddNetworkString( "Jill::UpdateHelpTable" )
function JILL.UpdateClientsHelpTable( ply, HelpID )

	if ( not ply:IsAdmin() or not ply:IsSuperAdmin() ) then return end

	net.Start( "Jill::UpdateHelpTable" )
		net.WriteString( JILL.Help[ HelpID ][ "helptitle" ] )
		net.WriteString( JILL.Help[ HelpID ][ "helpid" ] )
		net.WriteInt( JILL.Help[ HelpID ][ "order" ], 32 )
	net.Send( ply )

end

util.AddNetworkString( "Jill::UpdateInternalTable" )
function JILL.UpdateClientsInternalTable( ply, itemID )

	if ( not ply:IsAdmin() or not ply:IsSuperAdmin() ) then return end

	net.Start( "Jill::UpdateInternalTable" )
		net.WriteString( JILL.InternalHelpButtons[ itemID ][ "itemtitle" ] )
		net.WriteString( JILL.InternalHelpButtons[ itemID ][ "itemid" ] )
		net.WriteString( JILL.InternalHelpButtons[ itemID ][ 1 ][ 1 ][ "usage" ] or "#ERROR_STRING_USAGE_NULL" )
		net.WriteInt( JILL.InternalHelpButtons[ itemID ][ "order" ], 32 )
	net.Send( ply )

end

local Order = 0

function JILL.CreateQuest( identifier, title, ... )

	title = title or "Unknown"

	if ( JILL.Quests[ identifier ] ) then return end 

	local QuestData = { ... }

	JILL.Quests[ identifier ] = { questid = identifier, quest = title, taken = false, completed = false, order = Order, QuestData }

	Order = Order + 1

end

local HelpOrder = 0

function JILL.CreateHelpButton( identifier, title, ... )

	title = title or "Unknown"

	if ( JILL.Help[ identifier ] ) then return end 

	local HelpData = { ... }

	JILL.Help[ identifier ] = { helpid = identifier, helptitle = title, order = HelpOrder, HelpData }

	HelpOrder = HelpOrder + 1

end

local InternalOrder = 0

function JILL.CreateInternalHelpButton( identifier, title, ... )

	title = title or "Unknown"

	if ( JILL.InternalHelpButtons[ identifier ] ) then return end 

	local HelpData = { ... }

	JILL.InternalHelpButtons[ identifier ] = { itemid = identifier, itemtitle = title, order = InternalOrder, HelpData }

	InternalOrder = InternalOrder + 1

end

table.Empty( JILL.Quests )

--[[---------------------------------------------------------
	Name: Help Buttons
	Desc: Create the Help Buttons under this line.
		  This is for the Quest Help GUI <!questhelp>
-----------------------------------------------------------]]
JILL.CreateHelpButton( "help_1", "In-Game Tools" )

--[[---------------------------------------------------------
	Name: Internal Help Buttons
	Desc: Create the Internal Help Buttons under this line.
		  This is for the Quest Help GUI <!questhelp>
-----------------------------------------------------------]]
JILL.CreateInternalHelpButton( "Quest_Item_Book", "Quest Item Positioner", {

	usage = "Spawn the entity(As many as you like, the more you spawn, the more the player has to collect.) then exit out of the menu, once you're done with that you can then place them wherever you want, once you're happy with the location please re-type the entity into the text box and click save."

} )

JILL.CreateInternalHelpButton( "Quest_Item_Creation", "Quest NPC Creation", {

	usage = "Fill in the form below to create your npc. See the jillquests file to create custom quests for this specific npc."

} )

JILL.CreateInternalHelpButton( "Quest_Item_Editor", "Quest NPC Editor", {

	usage = "You can make changes to this npc by editing the form below."

} )

--[[---------------------------------------------------------
	Name: Quest
	Desc: Create the Quests under this line.
		  This is for the Quest NPC
-----------------------------------------------------------]]
JILL.CreateQuest( "Jill_Default_Quest_1", "Retreive The Book", {

	description = "Woah, glad someone came up to me! It seems that I have lost my favorite book. If you could be a peach and find it for me I'll be willing to give you some money for it. What do you think?", 
	objective = "Find Jill's favorite book in return for some money.",
	reward = { [ "darkrp_money" ] = 1000 },
 	entity = "book",
 	npc = { [ "all" ] = true },
 	repeatable = true,

} )

JILL.CreateQuest( "Jill_Default_Quest_2", "Cases of Beer", {

	description = "Hello! I'm going to host a party this weekend but we're all out of alcohol, if you could get a few cases of beer for us you're definitely invited! I'll throw in a few hundred bucks too. You down?", 
	objective = "Retrieve 3 cases of beer from all around the city",
	reward = { [ "darkrp_money" ] = 1000 },
	entity = "beer",
	npc = { [ "all" ] = true },
	repeatable = true,

} )

JILL.CreateQuest( "Jill_Default_Quest_3", "Skulls...", {

	description = "I don't like to admit it but I have quite the obsession for skulls. I need some more to complete my collection, if you could get me some fresh ones I'd be happy to give you some money in return. Whatcha say?", 
	objective = "Kill 5 players and take their skulls & retrieve them back to Jill.",
	reward = { [ "darkrp_money" ] = 2500 },
	refusetype = "blacklist",
	refuse = { [ "Civil Protection" ] = true, [ "Civil Protection Chief" ] = true },
	entity = "skull",
	repeatable = true,
	npc = { [ "all" ] = true },
	OnAccept = function( ply )

		hook.Add( "PlayerDeath", "Jill_Default_Quest_3_PlayerDeath", function( victim, inflictor, attacker )

			if ( not IsValid( victim ) or not IsValid( attacker ) ) then return end
			if ( not attacker:GetNWBool( "Jill_Default_Quest_3_Accepted", false ) ) then return end

			local skull = ents.Create( "skull" )
			skull:SetPos( Vector( victim:GetPos().x, victim:GetPos().y, victim:GetPos().z + 100 ) )
			skull:Spawn()
			skull:Activate()

			local phys = skull:GetPhysicsObject()

			if ( IsValid( phys ) ) then
				
				phys:Wake()

			end

		end )

	end,
	OnComplete = function( ply )

		hook.Remove( "PlayerDeath", "Jill_Default_Quest_3_PlayerDeath" )

	end

} )

JILL.CreateQuest( "Jill_Default_Quest_4", "Starvation", {

	description = "Hey! Glad you came along, I've been standing here for some time and and I'm very hungry, you think you could bring some food back for me?", 
	objective = "Bring a couple of noodle boxes back to Jill.",
	reward = { [ "darkrp_money" ] = 1000 },
	entity = "noodles",
	npc = { [ "all" ] = true },
	repeatable = true,

} )

JILL.CreateQuest( "Jill_Default_Quest_5", "You're a rebel you", {

	description = "A few weeks ago I was caught with a blunt in my hands, the guy that tipped the Police off was actually a Civil Police Officer. I need you take one of the Police Officers down then come back to me un-noticed.", 
	objective = "Kill one Police Officer then come back to Jill to get your reward.",
	reward = { [ "darkrp_money" ] = 7500 },
	refuse = { [ "Civil Protection" ] = true, [ "Civil Protection Chief" ] = true },
	entity = "NULL",
	repeatable = true,
	npc = { [ "all" ] = true },
	OnAccept = function()

		hook.Add( "PlayerDeath", "Jill_Default_Quest_5_PlayerDeath", function( victim, inflictor, attacker )

			if ( not IsValid( victim ) or not IsValid( attacker ) ) then return end
			if ( not attacker:GetNWBool( "Jill_Default_Quest_5_Accepted", false ) ) then return end

			if ( JILL.PoliceTeams[ victim:Team() ] ) then
				
				attacker:SetNWBool( "Jill_Default_Quest_5_Accepted", false )
				attacker:SetNWBool( "Jill_Default_Quest_5_Completed", true )

				attacker:MessageClient( "good", "That Police Officer got what he deserved, let's get back to jill." )				

			end

		end )

	end,
	OnComplete = function()

		hook.Remove( "PlayerDeath", "Jill_Default_Quest_5_PlayerDeath" )

	end

} )

JILL.CreateQuest( "Jill_Default_Quest_6", "Break and Entry", {

	description = "You there! You seem like the type of guy that knows how to handle a gun. A couple of days ago the government raided our place and took all of our drugs - I Was the only one who managed to get out and now I'm requesting your help. I need you to Break and Entry into the Police Department retrieve our drugs and bring them back to me.", 
	objective = "Theres tons of cocaine plants in the Police Department - The more you take the more you get. There is a lot of security and once you get one bag the alarm will go off. You should probably carry a gun for this one.",
	reward = { [ "darkrp_money" ] = 5000 },
	refuse = { [ "Civil Protection" ] = true, [ "Civil Protection Chief" ] = true },
	entity = "jillplant",
	repeatable = true,
	npc = { [ "all" ] = true },
	OnComplete = function( ply )

		for k, v in pairs( ents.GetAll() ) do
			
			if ( v:GetClass() == "jillplant" ) then
				
				v:Remove()

			end

		end

		ply:SetNWBool( "Jill_Default_Quest_6_Accepted", false )
		ply.JillPlants = 0
		JILL.Quests[ "Jill_Default_Quest_6" ][ 1 ][ 1 ][ "reward" ] = { [ "darkrp_money" ] = 5000 }

	end

} )

JILL.CreateQuest( "Jill_Default_Quest_7", "Lost Gun", {

	description = "Hey there! After the hunting season I kind of lost my gun. It's a really old gun so if you find it you can keep it!", 
	objective = "Find Jill's lost gun.",
	reward = { [ "weapon" ] = "weapon_ak472" },
	refuse = { [ "Civil Protection" ] = true, [ "Civil Protection Chief" ] = true },
	entity = "lost",
	npc = { [ "all" ] = true },
	repeatable = true,

} )

-------------------------------------------------------------