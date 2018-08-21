--[[---------------------------------------------------------
You should probably not edit anything in here.
-----------------------------------------------------------]]

include( "shared.lua" )

--[[---------------------------------------------------------
	Name: Font Creation
-----------------------------------------------------------]]
surface.CreateFont( "QuestTextFont", { font = "Arial", size = 16 } )
surface.CreateFont( "Header", { font = "Arial", size = 22 } )

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

//<3 FPtje
local function charWrap(text, pxWidth)
    local total = 0

    text = text:gsub(".", function(char)
        total = total + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if total >= pxWidth then
            total = 0
            return "\n" .. char
        end

        return char
    end)

    return text, total
end

function JILL.textWrap(text, font, pxWidth)
    local total = 0

    surface.SetFont(font)

    local spaceSize = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                total = 0
            end

            local wordlen = surface.GetTextSize(word)
            total = total + wordlen


            -- Wrap around when the max width is reached
            if wordlen >= pxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, pxWidth)
                total = splitPoint
                return splitWord
            elseif total < pxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                total = wordlen - spaceSize
                return '\n' .. string.sub(word, 2)
            end

            total = wordlen
            return '\n' .. word
        end)

    return text
end

local PANEL = {}

JILL.Multiplier = 0

function PANEL:CreateQuestButton( parent, questName, id, func )

	func = func or function() return end

	local Star = Material( JILL.QuestMaterial )
	local Taken = JILL.EveryoneCanQuest and LocalPlayer():GetNWBool( id .. "_Taken", false ) or JILL.Quests[ id ][ "taken" ]
	local Completed = LocalPlayer():GetNWBool( id .. "_Completed", false )

	self.QuestButton = vgui.Create( "DButton", parent )
	self.QuestButton:SetPos( xPos( 0 ), yPos( .1 ) + yPos( JILL.Multiplier ) )
	self.QuestButton:SetSize( self:GetWide(), ySize( .07 ) )
	self.QuestButton:SetText( "" )

	self.QuestButton.Paint = function( q, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.SetMaterial( Star )
		surface.DrawTexturedRect( xPos( .02 ), yPos( .015 ), 16, 16 )

		draw.DrawText( questName, "QuestTextFont", xPos( .05 ), yPos( .015 ), JILL.ButtonTextColor, TEXT_ALIGN_LEFT )

		if ( q:IsHovered() and Completed ) then
			
			draw.RoundedBox( 0, 0, 0, xSize( .005 ), h, Color( 0, 131, 255, 255 ) )

		elseif ( q:IsHovered() and not Taken ) then

			draw.RoundedBox( 0, 0, 0, xSize( .005 ), h, JILL.ButtonAvailable )

		elseif ( q:IsHovered() and Taken ) then

			draw.RoundedBox( 0, 0, 0, xSize( .005 ), h, JILL.ButtonNotAvailable )

		end

		draw.RoundedBox( 0, 0, yPos( .065 ), w, ySize( .002 ), Color( 21, 21, 21, 255 ) )
		draw.RoundedBox( 0, 0, yPos( .067 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

	end

	self.QuestButton.DoClick = func

	JILL.Multiplier = JILL.Multiplier + .069

end

function PANEL:CreateQuestFrame( Q )

	local Description = JILL.textWrap( JILL.Quests[ Q ][ "description" ], "QuestTextFont", 380 )
	local Objective = JILL.textWrap( JILL.Quests[ Q ][ "objective" ], "QuestTextFont", 380 )
	local Reward = JILL.Quests[ Q ][ "reward" ]
	local RealReward = ""

	for k, v in pairs( Reward ) do
		
		if ( JILL.Convert[ k ] ) then

			RealReward = RealReward .. JILL.Convert[ k ] .. v .. "\n"

		end

	end

	self.QuestFrame = vgui.Create( "DFrame" )
	self.QuestFrame:SetPos( xPos( .02 ), yPos( .25 ) )
	self.QuestFrame:SetSize( xSize( .5 ), ySize( 1.260 ) )
	self.QuestFrame:SetTitle( JILL.FrameTitle )
	self.QuestFrame:ShowCloseButton( false )
	self.QuestFrame:SetDraggable( false )
	self.QuestFrame:MakePopup()
	self.QuestFrame.Paint = function( p, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, JILL.FrameColor )

		draw.DrawText( "Description", "QuestTextFont", xPos( .005 ), yPos( .06 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		draw.DrawText( "Quest Objective", "QuestTextFont", xPos( .005 ), yPos( .56 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		draw.DrawText( "Reward", "QuestTextFont", xPos( .005 ), yPos( .86 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

		draw.DrawText( Description, "QuestTextFont", xPos( .005 ), yPos( .11 ), Color( 255, 255, 255, 220 ), TEXT_ALIGN_LEFT )
		draw.DrawText( Objective, "QuestTextFont", xPos( .005 ), yPos( .61 ), Color( 255, 255, 255, 220 ), TEXT_ALIGN_LEFT )
		draw.DrawText( RealReward, "QuestTextFont", xPos( .005 ), yPos( .91 ), Color( 255, 255, 255, 220 ), TEXT_ALIGN_LEFT )

		draw.RoundedBox( 0, xPos( 0 ), yPos( .103 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )
		draw.RoundedBox( 0, xPos( 0 ), yPos( .5 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )
		draw.RoundedBox( 0, xPos( 0 ), yPos( .8 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )
		draw.RoundedBox( 0, xPos( 0 ), yPos( .603 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )
		draw.RoundedBox( 0, xPos( 0 ), yPos( .903 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )
		draw.RoundedBox( 0, xPos( 0 ), yPos( 1.1 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

		//Bottom
		draw.RoundedBox( 0, xPos( 0 ), yPos( 1.194 ), w, ySize( .002 ), Color( 21, 21, 21, 255 ) )
		draw.RoundedBox( 0, xPos( 0 ), yPos( 1.195 ), w, ySize( .002 ), Color( 38, 38, 38, 255 ) )

		surface.SetDrawColor( Color( 21, 21, 21, 255 ) )
		surface.DrawOutlinedRect( 0, yPos( .1 ), w, ySize( .4 ) )

		surface.DrawOutlinedRect( 0, yPos( .6 ), w, ySize( .2 ) )

		surface.DrawOutlinedRect( 0, yPos( .9 ), w, ySize( .2 ) )

	end

	local frame = self.QuestFrame 

	if ( LocalPlayer():GetNWBool( Q .. "_Completed", false ) ) then

		self.Completed = vgui.Create( "Button", self.QuestFrame )
		self.Completed:SetPos( xPos( .35 ), yPos( 1.197 ) )
		self.Completed:SetSize( xSize( .15 ), ySize( .07 ) )
		self.Completed:SetText( "" )
		self.Completed.Paint = function( p, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )
			surface.SetDrawColor( Color( 38, 38, 38, 255 ) )
			surface.DrawOutlinedRect( 0, 0, w, h )

			if ( p:IsHovered() ) then
				
				draw.RoundedBox( 0, 0, 0, xSize( .005 ), h - 2, Color( 0, 255, 0, 255 ) )

			end

			draw.DrawText( "Deliver", "QuestTextFont", xPos( .075 ), yPos( .010 ), Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER )

		end

		self.Completed.DoClick = function()

			LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )

			frame:Remove()

			net.Start( "Jill:QuestCompleted" )
				net.WriteString( Q )
			net.SendToServer()

		end

	else

		self.Accept = vgui.Create( "Button", self.QuestFrame )
		self.Accept:SetPos( xPos( 0 ), yPos( 1.197 ) )
		self.Accept:SetSize( xSize( .15 ), ySize( .07 ) )
		self.Accept:SetText( "" )
		self.Accept.Paint = function( p, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )
			surface.SetDrawColor( Color( 38, 38, 38, 255 ) )
			surface.DrawOutlinedRect( 0, 0, w, h )

			if ( p:IsHovered() ) then
				
				draw.RoundedBox( 0, 0, 0, xSize( .005 ), h - 2, Color( 0, 255, 0, 255 ) )

			end

			draw.DrawText( JILL.AcceptText, "QuestTextFont", xPos( .075 ), yPos( .010 ), Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER )

		end

		self.Accept.DoClick = function()

			LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )

			frame:Remove()

			net.Start( "Jill:QuestAccepted" )
				net.WriteEntity( LocalPlayer() )
				net.WriteString( Q )
			net.SendToServer()

		end

		self.Decline = vgui.Create( "Button", self.QuestFrame )
		self.Decline:SetPos( xPos( .35 ), yPos( 1.197 ) )
		self.Decline:SetSize( xSize( .15 ), ySize( .07 ) )
		self.Decline:SetText( "" )
		self.Decline.Paint = function( p, w, h )

			draw.RoundedBox( 0, 0, 0, w, h, JILL.ButtonColor )
			surface.SetDrawColor( Color( 38, 38, 38, 255 ) )
			surface.DrawOutlinedRect( 0, 0, w, h )

			if ( p:IsHovered() ) then
				
				draw.RoundedBox( 0, 0, 0, xSize( .005 ), h - 2, Color( 255, 0, 0, 255  ) )

			end

			draw.DrawText( JILL.DeclineText, "QuestTextFont", xPos( .075 ), yPos( .010 ), Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER )

		end

		self.Decline.DoClick = function()

			LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )
			
			frame:Remove()

			vgui.Create( "JillQuestUI" )

		end

	end

end

function PANEL:Init()
	local oldExitText = JILL.ExitText

	JILL.Multiplier = 0

	self:SetPos( xPos( .02 ), yPos( .25 ) )
	self:SetSize( xSize( .5 ), ySize( 1.260 ) )
	self:SetTitle( JILL.FrameTitle )
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

		draw.DrawText( JILL.ExitText, "QuestTextFont", xPos( .245 ), yPos( .010 ), Color( 150, 150, 150, 255 ), TEXT_ALIGN_CENTER )

	end

	self.Exit.DoClick = function()

		LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )
		
		self:Remove()

	end

	for k, v in SortedPairsByMemberValue( JILL.Quests, "order" ) do

		if ( not v[ "shoulddraw" ] ) then continue end

		self:CreateQuestButton( self, v[ "titel" ], k, function()

			LocalPlayer():ConCommand( "play UI/buttonclickrelease.wav" )

			if ( not JILL.EveryoneCanQuest and JILL.Quests[ k ][ "taken" ] and not LocalPlayer():GetNWBool(k .. "_Completed", false) or LocalPlayer():GetNWBool( k .. "_Taken", false ) and not LocalPlayer():GetNWBool( k .. "_Completed", false ) ) then
				
				JILL.ExitText = JILL.AlreadyTaken

				timer.Simple( 2, function()

					JILL.ExitText = oldExitText

				end )

				return

			end

			self:Remove() 
			self:CreateQuestFrame( k ) 

		end )

	end

end
derma.DefineControl( "JillQuestUI", "", PANEL, "DFrame" )

net.Receive( "Jill::QuestSystem2::SendQuestUI", function( _, ply )

	vgui.Create( "JillQuestUI" )

end )

surface.CreateFont( "3D2DJillHeader", { font = "Arial", size = 50, weight = 1 } )

function ENT:Draw()

	self:DrawModel()

	if ( IsValid( self ) && LocalPlayer():GetPos():Distance( self:GetPos() ) < 500 ) then

		 local ang = Angle( 0, ( LocalPlayer():GetPos() - self:GetPos() ):Angle()[ "yaw" ], ( LocalPlayer():GetPos() - self:GetPos() ):Angle()[ "pitch" ] ) + Angle( 0, 90, 90 )

		cam.IgnoreZ( false )
		cam.Start3D2D( self:LocalToWorld( self:OBBCenter() ) + Vector( 0, 0, 45 ), ang, .10 )

			draw.SimpleTextOutlined( self:GetNPCHeader(), "3D2DJillHeader", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, .5, Color( 0, 0, 0, 255 ) )

		cam.End3D2D()

	end

end

net.Receive( "Jill::UpdateClient", function()

	local Title = net.ReadString()
	local QuestID = net.ReadString()
	local Description = net.ReadString()
	local Objective = net.ReadString()
	local Reward = net.ReadTable()
	local ShouldDraw = net.ReadBool()
	local Taken = net.ReadBool()
	local Order = net.ReadInt( 32 )
	local Completed = net.ReadBool()

	JILL.Quests[ QuestID ] = { titel = Title, completed = Completed, taken = Taken, order = Order, description = Description, objective = Objective, reward = Reward, shoulddraw = ShouldDraw }

end )