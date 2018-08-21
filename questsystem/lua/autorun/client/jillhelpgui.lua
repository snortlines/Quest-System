--[[---------------------------------------------------------
	Name: Jill Help GUI
	Desc: Heres where we made the Quest Help GUI
-----------------------------------------------------------]]

JILL = JILL or {}

--[[---------------------------------------------------------
	Name: xPos - So I don't have to type ( ScrW() / 2 ) * .1
-----------------------------------------------------------]]
local function xPos( times )

	return ( ScrW() / 2 ) * times

end

--[[---------------------------------------------------------
	Name: yPos - So I don't have to type ( ScrH() / 2 ) * .1
-----------------------------------------------------------]]
local function yPos( times )

	return ( ScrH() / 2 ) * times

end

--[[---------------------------------------------------------
	Name: xSize - So I don't have to type ( ScrW() / 2 ) * .1
-----------------------------------------------------------]]
local function xSize( times )

	return ( ScrW() / 2 ) * times

end

--[[---------------------------------------------------------
	Name: ySize - So I don't have to type ( ScrH() / 2 ) * .1
-----------------------------------------------------------]]
local function ySize( times )

	return ( ScrH() / 2 ) * times

end

local PANEL = {}

JILL.Multiplier = 0

function PANEL:CreateHelpButton( parent, questName, func )

	func = func or function() return end

	local Star = Material( JILL.QuestMaterial )
	local Taken = questID

	self.HelpButton = vgui.Create( "DButton", parent )
	self.HelpButton:SetPos( xPos( 0 ), yPos( .1 ) + yPos( JILL.Multiplier ) )
	self.HelpButton:SetSize( self:GetWide(), ySize( .07 ) )
	self.HelpButton:SetText( "" )

	self.HelpButton.Paint = function( q, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetMaterial( Star )
		surface.DrawTexturedRect( xPos( .02 ), yPos( .015 ), 16, 16 )

		draw.DrawText( questName, "QuestTextFont", xPos( .05 ), yPos( .015 ), JILL.ButtonTextColor, TEXT_ALIGN_LEFT )

		if ( q:IsHovered() ) then
			
			draw.RoundedBox( 0, 0, 0, xSize( .005 ), h, Color( 0, 255, 0, 255 ) )

		end

		draw.RoundedBox( 0, 0, yPos( .065 ), w, ySize( .002 ), Color( 21, 21, 21, 255 ) )
		draw.RoundedBox( 0, 0, yPos( .067 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

	end

	self.HelpButton.DoClick = func

	JILL.Multiplier = JILL.Multiplier + .069

end

function PANEL:PositionItemFrame( Q )

	self.ItemFrame = vgui.Create( "DFrame" )
	self.ItemFrame:SetPos( xPos( .02 ), yPos( .25 ) )
	self.ItemFrame:SetSize( xSize( .5 ), ySize( 1.260 ) )
	self.ItemFrame:SetTitle( "Jill's Quest Tool" )
	self.ItemFrame:ShowCloseButton( false )
	self.ItemFrame:SetDraggable( false )
	self.ItemFrame:MakePopup()
	self.ItemFrame.Paint = function( p, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, JILL.FrameColor )

		//Top
		draw.RoundedBox( 0, xPos( 0 ), yPos( .095 ), w, ySize( .002 ), Color( 21, 21, 21, 255 ) )
		draw.RoundedBox( 0, xPos( 0 ), yPos( .097 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

		//Bottom
		draw.RoundedBox( 0, xPos( 0 ), yPos( 1.194 ), w, ySize( .002 ), Color( 21, 21, 21, 255 ) )
		draw.RoundedBox( 0, xPos( 0 ), yPos( 1.195 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

	end

	local CurrFrame = self.ItemFrame

	self.Exit = vgui.Create( "Button", self.ItemFrame )
	self.Exit:SetPos( xPos( 0 ), yPos( 1.198 ) )
	self.Exit:SetSize( self:GetWide(), ySize( .07 ) )
	self.Exit:SetText( "" )
	self.Exit.Paint = function( p, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )

		if ( p:IsHovered() ) then
			
			draw.RoundedBox( 0, 0, 0, xSize( .005 ), h - 2, Color( 0, 255, 0, 255  ) )

		end

		draw.DrawText( JILL.GoBack, "QuestTextFont", xPos( .245 ), yPos( .010 ), Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER )

	end

	self.Exit.DoClick = function()

		LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )
		
		CurrFrame:Remove()
		self:CreateHelpFrame( Q )

	end

end

function PANEL:CreateHelpFrame( Q )

	JILL.Multiplier = 0

	self.HelpFrame = vgui.Create( "DFrame" )
	self.HelpFrame:SetPos( xPos( .02 ), yPos( .25 ) )
	self.HelpFrame:SetSize( xSize( .5 ), ySize( 1.260 ) )
	self.HelpFrame:SetTitle( "Jill's Quest Tool" )
	self.HelpFrame:ShowCloseButton( false )
	self.HelpFrame:SetDraggable( false )
	self.HelpFrame:MakePopup()
	self.HelpFrame.Paint = function( p, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, JILL.FrameColor )

		//
		draw.RoundedBox( 0, xPos( 0 ), yPos( .095 ), w, ySize( .002 ), Color( 21, 21, 21, 255 ) )
		draw.RoundedBox( 0, xPos( 0 ), yPos( .097 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

		//Bottom
		draw.RoundedBox( 0, xPos( 0 ), yPos( 1.194 ), w, ySize( .002 ), Color( 21, 21, 21, 255 ) )
		draw.RoundedBox( 0, xPos( 0 ), yPos( 1.195 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

	end

	local CurrFrame = self.HelpFrame

	for k, v in SortedPairsByMemberValue( JILL.InternalHelpButtons, "order" ) do

		self:CreateHelpButton( self.HelpFrame, v[ "titel" ], function() 

			LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )
			CurrFrame:Remove()

			local Usage = JILL.textWrap( JILL.InternalHelpButtons[ k ][ "usage" ], "QuestTextFont", 380 )
			JILL.SaveText = JILL.SaveText or "Save"

			if ( v[ "__key" ] == "Quest_Item_Book" ) then

				local ItemFrame = vgui.Create( "DFrame" )
				ItemFrame:SetPos( xPos( .02 ), yPos( .25 ) )
				ItemFrame:SetSize( xSize( .5 ), ySize( 1.260 ) )
				ItemFrame:SetTitle( JILL.QuestHelpTitle )
				ItemFrame:ShowCloseButton( false )
				ItemFrame:SetDraggable( false )
				ItemFrame:MakePopup()
				ItemFrame.Paint = function( p, w, h )

					draw.RoundedBox( 0, 0, 0, w, h, JILL.FrameColor )

					draw.DrawText( JILL.QuestHelpUsage, "QuestTextFont", xPos( .005 ), yPos( .06 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
					draw.DrawText( Usage, "QuestTextFont", xPos( .005 ), yPos( .11 ), Color( 255, 255, 255, 220 ), TEXT_ALIGN_LEFT )

					draw.DrawText( JILL.HelperText_One, "QuestTextFont", xPos( .002 ), yPos( .52 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
					draw.DrawText( JILL.HelperText_Two, "QuestTextFont", xPos( .002 ), yPos( .67 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
					draw.DrawText( JILL.AvailableEntities, "QuestTextFont", xPos( .002 ), yPos( .72 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

					draw.RoundedBox( 0, xPos( 0 ), yPos( .103 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )
					draw.RoundedBox( 0, xPos( 0 ), yPos( .5 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

					draw.RoundedBox( 0, xPos( 0 ), yPos( .65 ), w, ySize( .002 ), Color( 21, 21, 21, 255 ) )
					draw.RoundedBox( 0, xPos( 0 ), yPos( .653 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

					//Bottom
					draw.RoundedBox( 0, xPos( 0 ), yPos( 1.194 ), w, ySize( .002 ), Color( 21, 21, 21, 255 ) )
					draw.RoundedBox( 0, xPos( 0 ), yPos( 1.195 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

					surface.SetDrawColor( Color( 21, 21, 21, 255 ) )
					surface.DrawOutlinedRect( 0, yPos( .1 ), w, ySize( .4 ) )

				end

				local frame = ItemFrame

				local DTextEntity = vgui.Create( "DTextEntry", ItemFrame )
				DTextEntity:SetPos( xPos( .002 ), yPos( .578 ) )
				DTextEntity:SetSize( xSize( .2 ), ySize( .05 ) )

				local SpawnButton = vgui.Create( "DButton", ItemFrame )
				SpawnButton:SetPos( xPos( .25 ), yPos( .578 ) )
				SpawnButton:SetSize( xSize( .2 ), ySize( .05 ) )
				SpawnButton:SetText( "" )
				SpawnButton.Paint = function( q, w, h )

					draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )

					draw.DrawText( JILL.SpawnEntityText, "QuestTextFont", xPos( .035 ), yPos( .005 ), JILL.ButtonTextColor, TEXT_ALIGN_LEFT )

					if ( q:IsHovered() ) then
							
						draw.RoundedBox( 0, 0, 0, xSize( .005 ), h, Color( 0, 255, 0, 255 ) )

					end

					surface.SetDrawColor( 38, 38, 38, 255 )
					surface.DrawOutlinedRect( 0, 0, w, h )

				end

				SpawnButton.DoClick = function()

					if ( not LocalPlayer():IsAdmin() or not LocalPlayer():IsSuperAdmin() ) then return end

					LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )

					local HitPos = LocalPlayer():GetEyeTrace().HitPos

					if ( DTextEntity:GetValue() == "" or DTextEntity:GetValue() == nil ) then return false end

					net.Start( "Jill::SpawnEntity" )
						net.WriteVector( HitPos )
						net.WriteString( string.lower( DTextEntity:GetValue() ) )
					net.SendToServer()

				end				

				local Accept = vgui.Create( "Button", ItemFrame )
				Accept:SetPos( xPos( 0 ), yPos( 1.197 ) )
				Accept:SetSize( xSize( .15 ), ySize( .07 ) )
				Accept:SetText( "" )
				Accept.Paint = function( p, w, h )

					draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )
					surface.SetDrawColor( Color( 38, 38, 38, 255 ) )
					surface.DrawOutlinedRect( 0, 0, w, h )

					if ( p:IsHovered() ) then
						
						draw.RoundedBox( 0, 0, 0, xSize( .005 ), h - 2, Color( 0, 255, 0, 255  ) )

					end

					draw.DrawText( JILL.SaveText, "QuestTextFont", xPos( .075 ), yPos( .010 ), Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER )

				end

				Accept.DoClick = function()

					if ( not LocalPlayer():IsSuperAdmin() ) then return end

					LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )

					local HitPos = LocalPlayer():GetEyeTrace().HitPos
					//local SmoothHit = ( LocalPlayer():GetPos() - HitPos ):Angle():Forward()

					local Search = DTextEntity:GetValue()
					local SearchFound = 0
					local tempTable = {}
					local oldSaveText = JILL.SaveText

					if ( Search == "" or Search == nil ) then

						JILL.SaveText = JILL.Error_One

						timer.Simple( 3, function()

							JILL.SaveText = oldSaveText

						end )

						return false

					end

					for k, v in pairs( ents.GetAll() ) do

						if ( v:GetClass() == string.lower( Search ) ) then
							
							SearchFound = SearchFound + 1

							tempTable[ SearchFound ] = { ent = v, pos = v:GetPos() }

						end

					end

					if ( SearchFound > 0 ) then

						net.Start( "Jill::SavePosition" )
							net.WriteTable( tempTable )
						net.SendToServer()

						JILL.SaveText = "Success!"

						timer.Simple( 3, function()

							JILL.SaveText = oldSaveText

						end )

					else

						JILL.SaveText = "Can't find Entity!"

						timer.Simple( 3, function()

							JILL.SaveText = oldSaveText

						end )

					end

				end

				Decline = vgui.Create( "Button", ItemFrame )
				Decline:SetPos( xPos( .35 ), yPos( 1.197 ) )
				Decline:SetSize( xSize( .15 ), ySize( .07 ) )
				Decline:SetText( "" )
				Decline.Paint = function( p, w, h )

					draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )
					surface.SetDrawColor( Color( 38, 38, 38, 255 ) )
					surface.DrawOutlinedRect( 0, 0, w, h )

					if ( p:IsHovered() ) then
						
						draw.RoundedBox( 0, 0, 0, xSize( .005 ), h - 2, Color( 255, 0, 0, 255  ) )

					end

					draw.DrawText( JILL.DeclineText, "QuestTextFont", xPos( .075 ), yPos( .010 ), Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER )

				end

				Decline.DoClick = function()

					LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )
					
					frame:Remove()

					vgui.Create( "JillHelpGUI" )

				end

			elseif( v[ "__key" ] == "Quest_Item_Creation" ) then
				
				local ItemFrame = vgui.Create( "DFrame" )
				ItemFrame:SetPos( xPos( .02 ), yPos( .25 ) )
				ItemFrame:SetSize( xSize( .5 ), ySize( 1.260 ) )
				ItemFrame:SetTitle( JILL.QuestHelpTitle )
				ItemFrame:ShowCloseButton( false )
				ItemFrame:SetDraggable( false )
				ItemFrame:MakePopup()
				ItemFrame.Paint = function( p, w, h )

					draw.RoundedBox( 0, 0, 0, w, h, JILL.FrameColor )

					draw.DrawText( JILL.QuestHelpUsage, "QuestTextFont", xPos( .005 ), yPos( .06 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
					draw.DrawText( Usage, "QuestTextFont", xPos( .005 ), yPos( .11 ), Color( 255, 255, 255, 220 ), TEXT_ALIGN_LEFT )

					draw.RoundedBox( 0, xPos( 0 ), yPos( .103 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )
					draw.RoundedBox( 0, xPos( 0 ), yPos( .2 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

					//Bottom
					draw.RoundedBox( 0, xPos( 0 ), yPos( 1.194 ), w, ySize( .002 ), Color( 21, 21, 21, 255 ) )
					draw.RoundedBox( 0, xPos( 0 ), yPos( 1.195 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

					surface.SetDrawColor( Color( 21, 21, 21, 255 ) )
					surface.DrawOutlinedRect( 0, yPos( .1 ), w, ySize( .1 ) )

					draw.DrawText( "Header Text:", "QuestTextFont", xPos( .002 ), yPos( .21 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
					draw.DrawText( "Quest NPC Model:", "QuestTextFont", xPos( .002 ), yPos( .31 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
					draw.DrawText( "Unique Quest NPC ID:", "QuestTextFont", xPos( .002 ), yPos( .41 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

				end

				local frame = ItemFrame

				local DTextText = vgui.Create( "DTextEntry", ItemFrame )
				DTextText:SetPos( xPos( .002 ), yPos( .25 ) )
				DTextText:SetSize( xSize( .2 ), ySize( .05 ) )

				local DTextModel = vgui.Create( "DTextEntry", ItemFrame )
				DTextModel:SetPos( xPos( .002 ), yPos( .35 ) )
				DTextModel:SetSize( xSize( .2 ), ySize( .05 ) )

				local DTextID = vgui.Create( "DTextEntry", ItemFrame )
				DTextID:SetPos( xPos( .002 ), yPos( .45 ) )
				DTextID:SetSize( xSize( .2 ), ySize( .05 ) )

				local Accept = vgui.Create( "Button", ItemFrame )
				Accept:SetPos( xPos( 0 ), yPos( 1.197 ) )
				Accept:SetSize( xSize( .15 ), ySize( .07 ) )
				Accept:SetText( "" )
				Accept.Paint = function( p, w, h )

					draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )
					surface.SetDrawColor( Color( 38, 38, 38, 255 ) )
					surface.DrawOutlinedRect( 0, 0, w, h )

					if ( p:IsHovered() ) then
						
						draw.RoundedBox( 0, 0, 0, xSize( .005 ), h - 2, Color( 0, 255, 0, 255  ) )

					end

					draw.DrawText( JILL.SaveText, "QuestTextFont", xPos( .075 ), yPos( .010 ), Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER )

				end

				Accept.DoClick = function()

					if ( not LocalPlayer():IsSuperAdmin() ) then return end

					LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )

					local oldSaveText = JILL.SaveText
					local HeaderText = DTextText:GetValue()
					local NPCModel = DTextModel:GetValue()
					local NPCID = DTextID:GetValue()
					local babyproof = string.match( NPCID, "^[a-zA-Z0-9-_]+$" )

					if ( not babyproof or HeaderText == "" or NPCModel == "" or NPCID == "" ) then

						LocalPlayer():PrintMessage( HUD_PRINTTALK, "Don't use spaces in the NPC ID, fill all of the forms, and make sure everything is correct." )

						return

					end

					net.Start( "QuestSystem::SaveNPC" ) net.WriteString( HeaderText ) net.WriteString( NPCModel ) net.WriteString( NPCID ) net.SendToServer()

				end

				Decline = vgui.Create( "Button", ItemFrame )
				Decline:SetPos( xPos( .35 ), yPos( 1.197 ) )
				Decline:SetSize( xSize( .15 ), ySize( .07 ) )
				Decline:SetText( "" )
				Decline.Paint = function( p, w, h )

					draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )
					surface.SetDrawColor( Color( 38, 38, 38, 255 ) )
					surface.DrawOutlinedRect( 0, 0, w, h )

					if ( p:IsHovered() ) then
						
						draw.RoundedBox( 0, 0, 0, xSize( .005 ), h - 2, Color( 255, 0, 0, 255  ) )

					end

					draw.DrawText( JILL.DeclineText, "QuestTextFont", xPos( .075 ), yPos( .010 ), Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER )

				end

				Decline.DoClick = function()

					LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )
					
					frame:Remove()

					vgui.Create( "JillHelpGUI" )

				end

			elseif( v[ "__key" ] == "Quest_Item_Editor" ) then

				local currentEnt = nil

				Derma_StringRequest( "ID Retrieve", "Edit NPC(Input the unique NPC ID, please)", "", function( str )

					for _, v in pairs( ents.FindByClass( "jill" ) ) do
						
						if ( string.lower( v:GetNPCUniqueID() ) == string.lower( str ) ) then

							currentEnt = v

							local ItemFrame = vgui.Create( "DFrame" )
							ItemFrame:SetPos( xPos( .02 ), yPos( .25 ) )
							ItemFrame:SetSize( xSize( .5 ), ySize( 1.260 ) )
							ItemFrame:SetTitle( JILL.QuestHelpTitle )
							ItemFrame:ShowCloseButton( false )
							ItemFrame:SetDraggable( false )
							ItemFrame:MakePopup()
							ItemFrame.Paint = function( p, w, h )

								draw.RoundedBox( 0, 0, 0, w, h, JILL.FrameColor )

								draw.DrawText( JILL.QuestHelpUsage, "QuestTextFont", xPos( .005 ), yPos( .06 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
								draw.DrawText( Usage, "QuestTextFont", xPos( .005 ), yPos( .11 ), Color( 255, 255, 255, 220 ), TEXT_ALIGN_LEFT )

								draw.RoundedBox( 0, xPos( 0 ), yPos( .103 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )
								draw.RoundedBox( 0, xPos( 0 ), yPos( .2 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

								//Bottom
								draw.RoundedBox( 0, xPos( 0 ), yPos( 1.194 ), w, ySize( .002 ), Color( 21, 21, 21, 255 ) )
								draw.RoundedBox( 0, xPos( 0 ), yPos( 1.195 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

								surface.SetDrawColor( Color( 21, 21, 21, 255 ) )
								surface.DrawOutlinedRect( 0, yPos( .1 ), w, ySize( .1 ) )

								draw.DrawText( "Edit Header Text:", "QuestTextFont", xPos( .002 ), yPos( .21 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
								draw.DrawText( "Edit Quest NPC Model:", "QuestTextFont", xPos( .002 ), yPos( .31 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
								draw.DrawText( "Edit Unique Quest NPC ID:", "QuestTextFont", xPos( .002 ), yPos( .41 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

							end

							local frame = ItemFrame

							local DTextText = vgui.Create( "DTextEntry", ItemFrame )
							DTextText:SetPos( xPos( .002 ), yPos( .25 ) )
							DTextText:SetSize( xSize( .2 ), ySize( .05 ) )
							DTextText:SetText( v:GetNPCHeader() )

							local DTextModel = vgui.Create( "DTextEntry", ItemFrame )
							DTextModel:SetPos( xPos( .002 ), yPos( .35 ) )
							DTextModel:SetSize( xSize( .2 ), ySize( .05 ) )
							DTextModel:SetText( v:GetModel() )

							local DTextID = vgui.Create( "DTextEntry", ItemFrame )
							DTextID:SetPos( xPos( .002 ), yPos( .45 ) )
							DTextID:SetSize( xSize( .2 ), ySize( .05 ) )
							DTextID:SetText( v:GetNPCUniqueID() )

							local Accept = vgui.Create( "Button", ItemFrame )
							Accept:SetPos( xPos( 0 ), yPos( 1.197 ) )
							Accept:SetSize( xSize( .15 ), ySize( .07 ) )
							Accept:SetText( "" )
							Accept.Paint = function( p, w, h )

								draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )
								surface.SetDrawColor( Color( 38, 38, 38, 255 ) )
								surface.DrawOutlinedRect( 0, 0, w, h )

								if ( p:IsHovered() ) then
									
									draw.RoundedBox( 0, 0, 0, xSize( .005 ), h - 2, Color( 0, 255, 0, 255  ) )

								end

								draw.DrawText( JILL.SaveText, "QuestTextFont", xPos( .075 ), yPos( .010 ), Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER )

							end

							Accept.DoClick = function()

								if ( not LocalPlayer():IsSuperAdmin() ) then return end

								LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )

								local oldSaveText = JILL.SaveText
								local HeaderText = DTextText:GetValue()
								local NPCModel = DTextModel:GetValue()
								local NPCID = DTextID:GetValue()

								net.Start( "QuestSystem::EditNPC" ) net.WriteEntity( currentEnt ) net.WriteString( HeaderText ) net.WriteString( NPCModel ) net.WriteString( NPCID ) net.SendToServer()

							end

							Decline = vgui.Create( "Button", ItemFrame )
							Decline:SetPos( xPos( .35 ), yPos( 1.197 ) )
							Decline:SetSize( xSize( .15 ), ySize( .07 ) )
							Decline:SetText( "" )
							Decline.Paint = function( p, w, h )

								draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )
								surface.SetDrawColor( Color( 38, 38, 38, 255 ) )
								surface.DrawOutlinedRect( 0, 0, w, h )

								if ( p:IsHovered() ) then
									
									draw.RoundedBox( 0, 0, 0, xSize( .005 ), h - 2, Color( 255, 0, 0, 255  ) )

								end

								draw.DrawText( JILL.DeclineText, "QuestTextFont", xPos( .075 ), yPos( .010 ), Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER )

							end

							Decline.DoClick = function()

								LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )
								
								frame:Remove()

								vgui.Create( "JillHelpGUI" )

							end

							local DeleteNPC = vgui.Create( "DButton", ItemFrame )
							DeleteNPC:SetPos( xPos( .002 ), yPos( .55 ) )
							DeleteNPC:SetSize( xSize( .2 ), ySize( .05 ) )
							DeleteNPC:SetText( "" )
							DeleteNPC.Paint = function( q, w, h )

								draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )

								draw.DrawText( "Delete NPC", "QuestTextFont", xPos( .035 ), yPos( .005 ), JILL.ButtonTextColor, TEXT_ALIGN_LEFT )

								if ( q:IsHovered() ) then
										
									draw.RoundedBox( 0, 0, 0, xSize( .005 ), h, Color( 0, 255, 0, 255 ) )

								end

								surface.SetDrawColor( 38, 38, 38, 255 )
								surface.DrawOutlinedRect( 0, 0, w, h )

							end

							DeleteNPC.DoClick = function()

								if ( not LocalPlayer():IsSuperAdmin() ) then return end

								local NPCID = DTextID:GetValue()

								net.Start( "QuestSystem::DeleteNPC" ) net.WriteEntity( currentEnt ) net.WriteString( NPCID ) net.SendToServer()

								frame:Remove()

							end

						end

					end

				end )

			end

		end	)

		self.Exit = vgui.Create( "Button", self.HelpFrame )
		self.Exit:SetPos( xPos( 0 ), yPos( 1.198 ) )
		self.Exit:SetSize( self:GetWide(), ySize( .07 ) )
		self.Exit:SetText( "" )
		self.Exit.Paint = function( p, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )

			if ( p:IsHovered() ) then
				
				draw.RoundedBox( 0, 0, 0, xSize( .005 ), h - 2, Color( 0, 255, 0, 255  ) )

			end

			draw.DrawText( JILL.GoBack, "QuestTextFont", xPos( .245 ), yPos( .010 ), Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER )

		end

		self.Exit.DoClick = function()

			LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )
			
			CurrFrame:Remove()
			vgui.Create( "JillHelpGUI" )

		end

	end

end

function PANEL:Init()

	local oldExitText = JILL.ExitText

	JILL.Multiplier = 0

	self:SetPos( xPos( .02 ), yPos( .25 ) )
	self:SetSize( xSize( .5 ), ySize( 1.260 ) )
	self:SetTitle( JILL.QuestHelpTitle )
	self:ShowCloseButton( false )
	self:SetDraggable( false )
	self:MakePopup()
	self.Paint = function( p, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, JILL.FrameColor )

		//Top
		draw.RoundedBox( 0, xPos( 0 ), yPos( .095 ), w, ySize( .002 ), Color( 21, 21, 21, 255 ) )
		draw.RoundedBox( 0, xPos( 0 ), yPos( .097 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

		//Bottom
		draw.RoundedBox( 0, xPos( 0 ), yPos( 1.194 ), w, ySize( .002 ), Color( 21, 21, 21, 255 ) )
		draw.RoundedBox( 0, xPos( 0 ), yPos( 1.195 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

	end

	self.Exit = vgui.Create( "Button", self )
	self.Exit:SetPos( xPos( 0 ), yPos( 1.198 ) )
	self.Exit:SetSize( self:GetWide(), ySize( .07 ) )
	self.Exit:SetText( "" )
	self.Exit.Paint = function( p, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )

		if ( p:IsHovered() ) then
			
			draw.RoundedBox( 0, 0, 0, xSize( .005 ), h - 2, Color( 0, 255, 0, 255  ) )

		end

		draw.DrawText( JILL.QuestHelpExit, "QuestTextFont", xPos( .245 ), yPos( .010 ), Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER )

	end

	self.Exit.DoClick = function()

		LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )
		
		self:Remove()

	end

	for k, v in SortedPairsByMemberValue( JILL.Help, "order" ) do

		self:CreateHelpButton( self, v[ "titel" ], function()

			LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )

			self:Remove() 
			self:CreateHelpFrame( k ) 

		end )

	end

end
derma.DefineControl( "JillHelpGUI", "", PANEL, "DFrame" )

net.Receive( "Jill::QuestHelpGUI", function( _, ply )

	local ent = net.ReadEntity()

	if ( ent == LocalPlayer() ) then

		vgui.Create( "JillHelpGUI" )

	end

end )

net.Receive( "Jill::UpdateHelpTable", function( _, ply )

	local Title = net.ReadString()
	local HelpID = net.ReadString()
	local Order = net.ReadInt( 32 )

	JILL.Help[ HelpID ] = { titel = Title, order = Order }

end )

net.Receive( "Jill::UpdateInternalTable", function( _, ply )

	local Title = net.ReadString()
	local HelpID = net.ReadString()
	local Usage = net.ReadString()
	local Order = net.ReadInt( 32 )

	JILL.InternalHelpButtons[ HelpID ] = { titel = Title, usage = Usage, order = Order }

end )