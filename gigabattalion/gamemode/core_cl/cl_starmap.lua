--[[-------------------------------------------------------------------------
STARMAP - Scenario Selection System
---------------------------------------------------------------------------]]
GIGABAT.Starmap = {}
GIGABAT.Starmap.Panel = nil
GIGABAT.Starmap.GamePanel = nil
GIGABAT.Starmap.StarPanel = nil
GIGABAT.Starmap.GameDataReceived = false
GIGABAT.Starmap.ScenarioDataReceived = false

GIGABAT.Starmap.GameData = {}
GIGABAT.Starmap.ScenarioData = {}
local selectsound = "ui/buttonclickrelease.wav"
local hoversound = "garrysmod/ui_hover.wav"

local votedelay = 0
local function SendScenarioVote(vote)
	if votedelay > CurTime() then return end
	votedelay = CurTime() + 1
	net.Start("GigabatSendScenarioVote")
		net.WriteInt(vote,32)
	net.SendToServer()
end
local function SendGameTypeVote(vote)
	if votedelay > CurTime() then return end
	votedelay = CurTime() + 1
	net.Start("GigabatSendGameVote")
		net.WriteInt(vote,32)
	net.SendToServer()
end

function GIGABAT.Functions.CloseStarmap()
	gui.EnableScreenClicker(false)
	if IsValid(GIGABAT.Chat.Panel) then GIGABAT.Chat.Panel:AlphaTo(0,0.5,0,GIGABAT.Chat.Panel:Remove()) end
	if IsValid(GIGABAT.Starmap.Panel) then 
		GIGABAT.Starmap.Panel:SetAlpha(255)
		GIGABAT.Starmap.Panel:AlphaTo(0,0.5,0,function()
			GIGABAT.Starmap.Panel:Remove() 
		end)
	end
end

function GIGABAT.Functions.StarmapGamevote()
	if IsValid(GIGABAT.Starmap.GamePanel) then return end
	GIGABAT.Starmap.GamePanel = vgui.Create("DPanel",GIGABAT.Starmap.Panel)
	local panel = GIGABAT.Starmap.GamePanel
		panel:SetSize(640,480)
		panel:Center()
		panel.Paint = function(self)
			surface.SetDrawColor(Color(55,55,55,85))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		end

	local function CreateGameButton(parent,id,x,y,w,h,gamedata)
		local button = vgui.Create("DButton",parent)
		button:SetPos(x,y)
		button:SetSize(w,h)
		button:SetFont("DermaLarge")
		button:SetText(gamedata.name.." [0]")
		button.OnCursorEntered = function() surface.PlaySound(hoversound) end
		button.DoClick = function()
			GIGABAT.Functions.Notification({txt="Selected: "..gamedata.name,color=Vector(55,55,75)})	
			SendGameTypeVote(id)
		end
		button:SetTextColor(Color(215,255,155))
		button.Paint = function(self)
			surface.SetDrawColor(Color(85,85,85,85))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		end

		button.Think = function()
			local gamedata = GIGABAT.Starmap.GameData[id]
			button:SetText(gamedata.name.." - "..#gamedata.votes.." votes")
		end
	end

	local margin = 65
	for a, b in pairs(GIGABAT.Starmap.GameData) do
		CreateGameButton(panel,a,5,margin,panel:GetWide()-10,32,b)
		margin = margin + 75
	end

	local exit = vgui.Create("DButton",panel)
		exit:SetText("Exit")
		exit:SetFont("DermaLarge")
		exit:SizeToContents()
		exit:SetPos(panel:GetWide()-exit:GetWide(),5)
		exit:SetTextColor(Color(255,255,255,255))
		exit.OnCursorEntered = function() surface.PlaySound("garrysmod/ui_hover.wav") end
		exit.DoClick = function() panel:Remove() end
		exit.Paint = function(self)
			if self:IsHovered() then
				self:SetTextColor(Color(255,55,55,255))
			else
				self:SetTextColor(Color(255,255,255,255))
			end
		end
end

function GIGABAT.Functions.FillStarmap()
	if IsValid(GIGABAT.Starmap.GamePanel) then
		GIGABAT.Starmap.GamePanel:Remove()
	end

	if IsValid(GIGABAT.Starmap.StarPanel) then return end
	GIGABAT.Starmap.StarPanel = vgui.Create("DPanel",GIGABAT.Starmap.Panel)
	local panel = GIGABAT.Starmap.StarPanel
		panel:SetSize(640,480)
		panel:Center()
		panel.Paint = function() end	
		
	local ob1 = vgui.Create("DImage",panel)
		ob1:SetPos(45,100)
		ob1:SetSize(64,64)
		ob1:SetImage("gigabattalion/starmap/starmap_object1.png")

	local ob2 = vgui.Create("DImage",panel)
		ob2:SetPos(215,215)
		ob2:SetSize(32,32)
		ob2:SetImage("gigabattalion/starmap/starmap_object2.png")

	local ob2 = vgui.Create("DImage",panel)
		ob2:SetPos(100,45)
		ob2:SetSize(32,32)
		ob2:SetImage("gigabattalion/starmap/starmap_object2.png")


	local ob3 = vgui.Create("DImage",panel)
		ob3:SetPos(200,45)
		ob3:SetSize(32,32)
		ob3:SetImage("gigabattalion/starmap/starmap_object3.png")

	local ob4 = vgui.Create("DImage",panel)
		ob4:SetPos(125,315)
		ob4:SetSize(32,32)
		ob4:SetImage("gigabattalion/starmap/starmap_object4.png")

	local function CreateStarNode(id,data)
		local x,y = data.starpos.x,data.starpos.y
		local name = data.name
		local star = vgui.Create("DButton",panel)
			star:SetPos(x,y)
			star:SetSize(16,16)
			star.OnCursorEntered = function() surface.PlaySound(hoversound) end
			star.Paint = function(self)
				surface.SetDrawColor(Color(215,215,215,215))
				surface.DrawRect(0,0,self:GetWide(),self:GetTall())
			end
			star.DoClick = function()
				GIGABAT.Functions.Notification({txt="Selected: "..data.name,color=Vector(55,55,75)})
				SendScenarioVote(id)
			end
		local starname = vgui.Create("DLabel",panel)
			starname:SetPos(x+16,y-16)
			starname:SetText(name.." - "..#data.votes)
			starname:SetFont("GBShipMenuFontSmall")
			starname:SizeToContents()

		star.Think = function()
			local scenariodata = GIGABAT.Starmap.ScenarioData[id]
			starname:SetText(name.." - "..#scenariodata.votes)
			starname:SizeToContents()
		end
	end

	for a, b in pairs(GIGABAT.Starmap.ScenarioData) do
		CreateStarNode(a,b)
	end
end

function GIGABAT.Functions.BuildStarmap()
	if IsValid(GIGABAT.Starmap.Panel) then
		GIGABAT.Functions.CloseStarmap()
		return
	end
	
	GIGABAT.Starmap.Panel = vgui.Create("DFrame")
	local frame = GIGABAT.Starmap.Panel
		frame:SetSize(ScrW(),ScrH())
		frame:SetTitle("")
		frame:ShowCloseButton(false)
		frame:SetDraggable(false)
		frame:SetPos(0,0)
		frame.Paint = function(self)
			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		end
		frame:SetAlpha(0)
		frame:AlphaTo(255,0.5,0)
		GIGABAT.Functions.ShowChat()

	local starmap = vgui.Create("DModelPanel",frame)
		starmap:Dock(FILL)
		starmap:SetModel("models/gigabattalion/space_sphere.mdl")
		starmap.LayoutEntity = function()
			local ent = starmap:GetEntity()
			local ang = Angle(ent:GetAngles().p-0.001,ent:GetAngles().y-0.001,ent:GetAngles().r-0.001)
			ent:SetAngles(ang)
		end

	local initial = vgui.Create("DLabel",frame)
		initial:SetFont("DermaLarge")
		initial:SetText("Loading Star Map...")
		initial:SizeToContents()
		initial:Center()
		initial:AlphaTo(0,1,3,function() initial:Remove() end)

	if GIGABAT.Starmap.ScenarioDataReceived then
		GIGABAT.Functions.FillStarmap()
	else
		if GIGABAT.Starmap.GameDataReceived then
			GIGABAT.Functions.StarmapGamevote()
		end
	end

	local exit = vgui.Create("DButton",frame)
		exit:SetText("Exit")
		exit:SetFont("DermaLarge")
		exit:SizeToContents()
		exit:SetPos(ScrW()-exit:GetWide(),5)
		exit:SetTextColor(Color(255,255,255,255))
		exit.OnCursorEntered = function() surface.PlaySound("garrysmod/ui_hover.wav") end
		exit.DoClick = function() GIGABAT.Functions.CloseStarmap() end
		exit.Paint = function(self)
			if self:IsHovered() then
				self:SetTextColor(Color(255,55,55,255))
			else
				self:SetTextColor(Color(255,255,255,255))
			end
		end

	gui.EnableScreenClicker(true)
end

net.Receive("GigabatSendStarmap",function(len,pl) 
	GIGABAT.Functions.BuildStarmap()
end)
net.Receive("GigabatSendGameVoteData",function(len,pl) 
	local gamedata = net.ReadTable()
	GIGABAT.Starmap.GameDataReceived = true
	GIGABAT.Starmap.GameData = table.Copy(gamedata)
	if IsValid(GIGABAT.Starmap.Panel) then GIGABAT.Functions.StarmapGamevote() end
end)
net.Receive("GigabatSendScenarioVoteData",function(len,pl) 
	local scenariodata = net.ReadTable()
	GIGABAT.Starmap.ScenarioDataReceived = true
	GIGABAT.Starmap.ScenarioData = table.Copy(scenariodata)
	if IsValid(GIGABAT.Starmap.Panel) then GIGABAT.Functions.FillStarmap() end
end)