--[[---------------------------------------------------------
	Name: Jill Config.
-----------------------------------------------------------]]

JILL = JILL or {}
JILL.Quests = JILL.Quests or {}
JILL.Help = JILL.Help or {}
JILL.InternalHelpButtons = JILL.InternalHelpButtons or {}

--[[---------------------------------------------------------
	Name: Menu
	Desc: Here is all the menu things you can configure.
		  Everything from text, color, etc.
-----------------------------------------------------------]]

//The material we're going to use next to the Quest Button
JILL.QuestMaterial = "icon16/star.png" //Default is: icon16/star.png - famfamfam has all the icons, google it.

//What color should our quest buttons be?
JILL.ButtonColor = Color( 32, 32, 32, 255 ) //Default is grey( 32, 32, 32, 255 )

//What should the text color be, for our buttons?
JILL.ButtonTextColor = Color( 255, 255, 255, 220 ) //Default is white( 255, 255, 255, 220 )

//If we hover over the quest button and the quest is not taken, what color should we display?
JILL.ButtonAvailable = Color( 0, 255, 0, 255 ) //Default is green( 0, 255, 0, 255 )

//If we hover over the quest button and the quest is taken, what color should we display?
JILL.ButtonNotAvailable = Color( 255, 0, 0, 255 ) //Default is red( 255, 0, 0, 255 )

//What should the title of our frame be?
JILL.FrameTitle = "Quests" //Default is "Jill's Quests"

//What color should our frame be?
JILL.FrameColor = Color( 28, 28, 28, 255 ) //Default is grey-ish( 28, 28, 28, 255 )

//What should we display for the Accept Button on the quest.
JILL.AcceptText = "Accept" //Default is "Accept"

//What should we display for the Decline Button on the quest.
JILL.DeclineText = "Decline" //Default is "Decline"

//What should we display for the Exit Button
JILL.ExitText = "Wrong person, sorry.<Leave>" //Default is "Wrong person, sorry.<Leave>"

//If the quest is taken or on cooldown, what should the error text say?
JILL.AlreadyTaken = "Quest is already taken or on cooldown!" //Default is "Quest is already taken or on cooldown!"

--[[---------------------------------------------------------
	Name: Quest NPC
	Desc: Here is everything you can configure.
	      Everything from, text, model, etc.
-----------------------------------------------------------]]

//The model we should use for our Quest NPC
JILL.NPCModel = "models/mossman.mdl" //Default is "models/mossman.mdl" <Deprecated>

//Quest cooldown in seconds - 300 seconds in 5 minutes.
JILL.QuestCooldown = 300 //Default is 300; If you would like to set a custom cooldown for a quest then please read the README.txt file which was provided within the purchase.

//How many seconds does the user have to complete the quest?
JILL.QuestCompletionTime = 600 //Default is 600; If you would like to set a custom completion time for a quest then please read the README.txt file which was provided within the purchase.

//Can everyone do quests or just one per quest?
JILL.EveryoneCanQuest = true //Default = false; This will probably use a lot of entities unless you're going to create your own quests.

//For the 'Break and Entry' Quest. How much more money should the player get the more he picks up?
JILL.CocainePlantReward = 1250

//How many quests can the player have?
JILL.QuestLimit = 0 // 0 = Unlimited

//Convert our Rewards to Reward names
JILL.Convert = { [ "darkrp_money" ] = "Money: ", [ "weapon" ] = "Weapon: ", [ "pointshop_points" ] = "Pointshop Points: ", [ "vrondakis_xp" ] = "XP: " }
	
//Our reward functions. If I'm not supporting an addon you have, you can easly make your own reward functions.
//Remember to use them in your quests! For your quests, you can do: reward = { [ "yourcustomthing" ] = 50 }
//Look at the example blow on how to use it.
JILL.RewardFunctions =
{
	[ "darkrp_money" ] 	   = function( self, reward ) self:addMoney( reward ) end,
	[ "weapon" ]       	   = function( self, reward ) self:Give( reward ) end,
	[ "pointshop_points" ] = function( self, reward ) self:PS_GivePoints( reward ) end,
	[ "vrondakis_xp" ]     = function( self, reward ) self:addXP( reward ) end,
	//EXAMPLE BELOW ON HOW TO USE.
	//[ "custom_xp" ] 	   = function( self, reward ) self:custom_addxp_meta_function( reward ) end,
}

--[[---------------------------------------------------------
	Name: Quest Help
	Desc: Here is everything you can configure.
	      Everything from, text, etc.
-----------------------------------------------------------]]

//The save text, text.
JILL.SaveText = "Save" //Default is "Save"

//For the go back button
JILL.GoBack = "<- Go Back" //Default is "<- Go Back"

//For the exit button
JILL.QuestHelpExit = "Exit" //Default is "Exit"

//For the Quest Help Title
JILL.QuestHelpTitle = "Quest Tool" // Default is "Jill's Quest Tool"

//This is for the Usage Header which is located above the description in the Quest Help Menu
JILL.QuestHelpUsage = "Usage" // Default is "Usage"

//This is for the Helper Text
JILL.HelperText_One = "Please specify the entity you would like to set the position for." //Default is "Please specify the entity you would like to set the position for."

//This is for the Helper Text
JILL.HelperText_Two = "Available entities:" //Default is "Available entities:"

//This is for the Helper Text
JILL.AvailableEntities = "Book\nBeer\nNoodles\nLost\nJillplant" //Default is "Book\nBeer\nNoodles\nSkull\nJillplant"

//The text we should draw for the Spawn Entity Button.
JILL.SpawnEntityText = "Spawn Entity" //Default is "Spawn Entity"

//This is for the error text
JILL.Error_One = "Specify Entity Above!" //Default is "Specify Entity Above!"

//This is for the error text
JILL.Error_Two = "Can't find Entity!" //Default is "Can't find Entity!"

//If we try to save items but have not yet spawned the NPC what should w display?
JILL.Error_Three = "You need to spawn & save the NPC before you can set up the item spawns" //Default is "You need to spawn & save the NPC before you can set up the item spawns"

--[[---------------------------------------------------------
	Name: Quest Chat Commands
	Desc: Here is everything you can configure.
	      Everything from, text, etc.
-----------------------------------------------------------]]

//If you don't have access to this command this is the error you'll get
JILL.ChatAccessDenied = "You are unable to run this command. #SYSTEM_ACCESS_DENIED." //Default is "You are unable to run this command. #SYSTEM_ACCESS_DENIED."

//If we try to spawn the NPC and we haven't spawned one yet, what should we display?
JILL.NoNPC = "You have not spawned the NPC yet." //Default is "You have not spawned the NPC yet."

--[[---------------------------------------------------------
	Name: Misc
-----------------------------------------------------------]]

JILL.Initialize = function()

	if ( engine.ActiveGamemode() != "darkrp" ) then return end
	
	JILL.PoliceTeams = { [ TEAM_POLICE ] = true, [ TEAM_CHIEF ] = true } // This is for our 'You're a rebel you' Quest.
	JILL.PoliceNotifications = { [ TEAM_POLICE ] = true, [ TEAM_CHIEF ] = true } // This is for our 'Break and Entry' Quest. What Police Officer can see the Police Department raid warning?

end
hook.Add( "InitPostEntity", "Jill::CreateTables", JILL.Initialize )