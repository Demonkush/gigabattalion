CreateClientConVar("gigabat_garagebackdrop","garage",true,false)
CreateClientConVar("gigabat_selectedship",GIGABAT.Config.DefaultShip,true,false)
CreateClientConVar("gigabat_selectedskin",GIGABAT.Config.DefaultSkin,true,false)
LocalPlayer().gb_Stats = {}
LocalPlayer().gb_OwnedShips = {GIGABAT.Config.DefaultShip}
LocalPlayer().gb_OwnedSkins = {GIGABAT.Config.DefaultSkin}

GIGABAT.Garage = {}
GIGABAT.Garage.Core = nil
GIGABAT.Garage.Container = nil
GIGABAT.Garage.SelectedShip = nil
GIGABAT.Garage.SelectedSkin = nil
GIGABAT.Garage.Backdrops = {}
GIGABAT.Garage.Backdrops["none"] = {model="models/dav0r/hoverball.mdl",offset=Vector(0,0,0)}
GIGABAT.Garage.Backdrops["garage"] = {model="models/gigabattalion/garage.mdl",offset=Vector(0,0,-90)}
GIGABAT.Garage.Backdrops["space"] = {model="models/gigabattalion/space_sphere.mdl",offset=Vector(0,0,0)}
local exitsound = "buttons/combine_button2.wav"
local selectsound = "ui/buttonclickrelease.wav"
local hoversound = "garrysmod/ui_hover.wav"
local notifcolor = Vector(35,55,75)

function GIGABAT.Functions.CloseGarage(nt)
	if IsValid(GIGABAT.Garage.Core) then
		if IsValid(GIGABAT.Chat.Panel) then GIGABAT.Chat.Panel:AlphaTo(0,0.5,0,GIGABAT.Chat.Panel:Remove()) end
		GIGABAT.Functions.Transition(true)
		timer.Simple(3,function()
			if IsValid(GIGABAT.Garage.Core) then
				GIGABAT.Garage.Core:Remove()
				GIGABAT.Garage.Core = nil
			end
			GIGABAT.Functions.Transition(false)
			gui.EnableScreenClicker(false)
			net.Start("GigabatReceiveGarage") 
				net.WriteBool(nt)
			net.SendToServer()
			if nt then
				GIGABAT.Functions.IngameInfo() 
			end
			gigabat_deathmsg = "You have been destroyed!"
		end)
	end
end

function GIGABAT.Functions.GarageInit()
	GIGABAT.Garage.Core = vgui.Create("DFrame")
	local core = GIGABAT.Garage.Core
		core:SetPos(0,0)
		core:SetSize(ScrW(),ScrH())
		core:SetTitle("")
		core:ShowCloseButton(false)
		core:SetDraggable(false)
		core.Paint = function(self) 
			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		end
		core:Hide()
end

function GIGABAT.Functions.OpenGarage()
	local controls_open = false
	local function ExpandInfoMenu(menu) menu:SizeTo(menu.Size.w,32,1,0) end
	local function MinimizeInfoMenu(menu) menu:SizeTo(menu.Size.w,menu.Size.h,1,0) end
	local function CreateInfoMenu(parent,title,a,b,c,d)
		local panel = vgui.Create("DPanel",parent)
			panel:SetPos(a,b)
			panel:SetSize(c,d)
			panel.Toggled = false
			panel.Size = {w=c,h=d}
			panel.Paint = function(self)
				surface.SetDrawColor(Color(55,55,55,215))
				surface.DrawRect(0,0,self:GetWide(),self:GetTall())
			end
		local info = vgui.Create("DScrollPanel",panel)
			info:SetPos(0,32)
			info:SetSize(panel:GetWide(),panel:GetTall()-32)
			panel.InfoPanel = info
		local label = vgui.Create("DLabel",panel)
			label:SetPos(2,2)
			label:SetFont("DermaLarge")
			label:SetText(title)
			label:SizeToContents()
		local mini = vgui.Create("DButton",panel)
			mini:SetSize(16,16)
			mini:SetPos(panel:GetWide()-16,0)
			mini:SetIcon("icon16/arrow_up.png")
			mini:SetText("")
			mini:SetFont("DermaLarge")
			mini.Paint = function() end
			mini.DoClick = function()
				if panel.Toggled then
					panel.Toggled = false
					MinimizeInfoMenu(panel)
					mini:SetIcon("icon16/arrow_up.png")
				elseif !panel.Toggled then
					panel.Toggled = true
					ExpandInfoMenu(panel)
					mini:SetIcon("icon16/arrow_down.png")
				end
			end
		return panel
	end

	local function CreateExitButton(parent,x,y,func)
		local exit = vgui.Create("DButton",parent)
			exit:SetText("Exit")
			exit:SetFont("DermaLarge")
			exit:SizeToContents()
			exit:SetPos(x-exit:GetWide(),y)
			exit:SetTextColor(Color(255,255,255,255))
			exit.OnCursorEntered = function() surface.PlaySound(hoversound) end
			exit.DoClick = function() func() end
			exit.Paint = function(self)
				if self:IsHovered() then
					self:SetTextColor(Color(255,55,55,255))
				else
					self:SetTextColor(Color(255,255,255,255))
				end
			end
		return exit
	end

	local function LoadInfoPanels(parent)
		local stats = LocalPlayer().gb_Stats
		local stattable = {
			shotsfired 		= {txt="Shots Fired",val=stats.shotsfired},
			asteroids 		= {txt="Asteroids",val=stats.asteroids},
			kills 			= {txt="Kills",val=stats.kills},
			deaths 			= {txt="Deaths",val=stats.deaths}
		}
		if IsValid(GIGABAT.Garage.Container.PlayerInfo) then GIGABAT.Garage.Container.PlayerInfo:Remove() end
		GIGABAT.Garage.Container.PlayerInfo = CreateInfoMenu(parent,"Player Stats",50,175,300,150)
		local margin = 5
		for a, b in pairs(stattable) do
			local value = b.val or 0
			local lbl = vgui.Create("DLabel",GIGABAT.Garage.Container.PlayerInfo.InfoPanel)
				lbl:SetPos(10,margin)
				lbl:SetFont("GBShipMenuFontSmall")
				lbl:SetText(b.txt..": "..value)
				lbl:SetTextColor(Color(155,215,255,255))
				lbl:SizeToContents()
			margin = margin + 24
		end
		local teambased = "No"
		if GIGABAT.Config.Round.TeamBased then teambased = "Yes" end
		local gametable = {
			scenario 		= {txt="Scenario",val=GIGABAT.Scenario[GIGABAT.GameInfo.scenario].name},
			gametype 		= {txt="Game Type",val=GIGABAT.Gametypes[GIGABAT.GameInfo.gametype].name},
			teambased 		= {txt="Team Based?",val=teambased},
			players 		= {txt="Players Online",val=#player.GetAll()},
		}
		if IsValid(GIGABAT.Garage.Container.GameInfo) then GIGABAT.Garage.Container.GameInfo:Remove() end
		GIGABAT.Garage.Container.GameInfo = CreateInfoMenu(parent,"Game Info",50,335,300,150)
		local margin = 5
		for a, b in pairs(gametable) do
			local value = b.val or 0
			local lbl = vgui.Create("DLabel",GIGABAT.Garage.Container.GameInfo.InfoPanel)
				lbl:SetPos(10,margin)
				lbl:SetFont("GBShipMenuFontSmall")
				lbl:SetText(b.txt..": "..value)
				lbl:SetTextColor(Color(255,215,155,255))
				lbl:SizeToContents()
				if a == "players" then
					lbl.Think = function()
						lbl:SetText(b.txt..": "..#player.GetAll())
						lbl:SizeToContents()
					end
				end
			margin = margin + 24
		end
		local shipdata = GIGABAT.Frames[GIGABAT.Garage.SelectedShip]
		local margin = 5
		if IsValid(GIGABAT.Garage.Container.LoadoutInfo) then GIGABAT.Garage.Container.LoadoutInfo:Remove() end
		GIGABAT.Garage.Container.LoadoutInfo = CreateInfoMenu(parent,"Loadout",ScrW()-285,190,256,256)		
		local loadout = shipdata.loadout
		for a, b in pairs(loadout) do
			local name = GIGABAT.Arsenal[b.weapon].name
			local lbl = vgui.Create("DLabel",GIGABAT.Garage.Container.LoadoutInfo.InfoPanel)
				lbl:SetPos(10,margin)
				lbl:SetFont("GBShipMenuFontSmall")
				lbl:SetText(name)
				lbl:SetTextColor(Color(215,255,155,255))
				lbl:SizeToContents()
			margin = margin + 24
		end
		local margin = 5
		if IsValid(GIGABAT.Garage.Container.ShipInfo) then GIGABAT.Garage.Container.ShipInfo:Remove() end
		GIGABAT.Garage.Container.ShipInfo = CreateInfoMenu(parent,"Ship Stats",ScrW()-285,465,256,256)
		local shipstats = shipdata.stats
		local stats = {
			hull = {name="Hull",val=shipstats.hull},
			shield = {name="Shield",val=shipstats.shield},
			maxspeed = {name="Max Speed",val=shipstats.maxspeed},
			acceleration = {name="Acceleration",val=shipstats.acceleration},
			dragspeed = {name="Drag Speed",val=shipstats.dragspeed},
			turnspeed = {name="Turn Speed",val=shipstats.turnspeed},
		}
		for a, b in pairs(stats) do
			local lbl = vgui.Create("DLabel",GIGABAT.Garage.Container.ShipInfo.InfoPanel)
				lbl:SetPos(10,margin)
				lbl:SetFont("GBShipMenuFontSmall")
				if a == "maxspeed" then
					local val = math.Round(b.val/7.5)
					lbl:SetText(b.name..": "..val.." ("..(val*2)..")")
				else
					lbl:SetText(b.name..": "..b.val)
				end
				lbl:SetTextColor(Color(215,255,155,255))
				lbl:SizeToContents()
			margin = margin + 24
		end
	end

	local function OpenItemMenu(type)
		if !IsValid(GIGABAT.Garage.Core) then return end
		local core = GIGABAT.Garage.Core
		if controls_open then return end
		controls_open = true
		local function PanelFadeIn(panel)
			if IsValid(panel) then panel:SetAlpha(0) panel:AlphaTo(255,0.25) end
		end
		local function PanelFadeOut(panel)
			if IsValid(panel) then panel:SetAlpha(255) panel:AlphaTo(0,0.25,0,function() panel:Remove() end) end
		end
		if type == "objective" then	
			local objectivepanel = vgui.Create("DPanel",core)
				objectivepanel:SetSize(640,240)
				objectivepanel:Center()
				objectivepanel.Paint = function(self)
					surface.SetDrawColor(Color(0,0,0,215))
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				end
				PanelFadeIn(objectivepanel)
			local objectivelabel = vgui.Create("DLabel",objectivepanel)
				objectivelabel:SetTextColor(Color(255,255,255,255))
				objectivelabel:SetPos(5,5)
				objectivelabel:SetText("Objective")
				objectivelabel:SetFont("DermaLarge")
				objectivelabel:SizeToContents()
			local objective_obj = vgui.Create("DLabel",objectivepanel)
				objective_obj:SetPos(0,55)
				objective_obj:SetFont("GBShipMenuFont")
				objective_obj:SetText(GIGABAT.Config.ObjectiveTitle)
				objective_obj:SetColor(Color(255,255,255,255))
				objective_obj:SizeToContents()
				objective_obj:CenterHorizontal()
			local objective_txt = vgui.Create("DLabel",objectivepanel)
				objective_txt:SetPos(0,125)
				objective_txt:SetFont("GBShipMenuFontSmall")
				objective_txt:SetText(GIGABAT.Config.ObjectiveTask)
				objective_txt:SetColor(Color(255,255,255,255))
				objective_txt:SizeToContents()
				objective_txt:CenterHorizontal()
			CreateExitButton(objectivepanel,objectivepanel:GetWide(),5,function()
				surface.PlaySound(exitsound)
				controls_open = false
				PanelFadeOut(objectivepanel)
			end)
		end
		if type == "howtoplay" then	
			local howtoplaypanel = vgui.Create("DPanel",core)
				howtoplaypanel:SetSize(640,640)
				howtoplaypanel:Center()
				howtoplaypanel.Paint = function(self)
					surface.SetDrawColor(Color(0,0,0,245))
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				end
				PanelFadeIn(howtoplaypanel)
			local howtoplaylabel = vgui.Create("DLabel",howtoplaypanel)
				howtoplaylabel:SetTextColor(Color(255,255,255,255))
				howtoplaylabel:SetPos(5,5)
				howtoplaylabel:SetText("How to Play")
				howtoplaylabel:SetFont("DermaLarge")
				howtoplaylabel:SizeToContents()
			local strs = {
				"In GIGABATTALION, you pilot space combat ships in\n different scenarios, completing different objectives\n based on gametype.",
				"For example, in the Asteroids gametype you will\n destroy asteroids to gain score, which will in turn\n reward you with Tokens after 25 points by default.",
				"Your statistics, owned ships, and owned skins save permanently.\n Use Tokens to buy new ships and skins!",
				"2 Players are needed to start a round.\n You wont earn tokens unless the round starts!",
				"F1 opens the main menu, this gives you\n access to the Garage and Options menus.",
				"Refer to the Controls button in the\n Garage to understand the control systems.",
			}
			local margin = 64
			for i=1,#strs do
				local howtoplay_txt = vgui.Create("DLabel",howtoplaypanel)
					howtoplay_txt:SetText(strs[i])
					howtoplay_txt:SetFont("GBShipMenuFontSmall")
					howtoplay_txt:SetSize(640,50)
					howtoplay_txt:SizeToContents()
					howtoplay_txt:SetPos(0,margin)
					howtoplay_txt:SetColor(Color(255,255,255,255))
					howtoplay_txt:CenterHorizontal()
				margin = margin + 96
			end
			CreateExitButton(howtoplaypanel,howtoplaypanel:GetWide(),5,function()
				surface.PlaySound(exitsound)
				controls_open = false
				PanelFadeOut(howtoplaypanel)
			end)
		end
		if type == "controls" then	
			local controlspanel = vgui.Create("DPanel",core)
				controlspanel:SetSize(ScrW()*0.7,ScrH()/1.75)
				controlspanel:Center()
				controlspanel.Paint = function(self)
					surface.SetDrawColor(Color(0,0,0,215))
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				end
				PanelFadeIn(controlspanel)
			local controls = vgui.Create("DImage",controlspanel)
				controls:SetPos(5,50)
				controls:SetImage("gigabattalion/ui/controls.png")
				controls:SetSize(controlspanel:GetWide()-10,controlspanel:GetTall()-55)
			CreateExitButton(controlspanel,controlspanel:GetWide(),5,function()
				surface.PlaySound(exitsound)
				controls_open = false
				PanelFadeOut(controlspanel)
			end)
		end
		if type == "unlock" then	
			local unlockmode = "ships"
			local unlockpanel = vgui.Create("DPanel",core)
				unlockpanel:SetSize(640,480)
				unlockpanel:Center()
				unlockpanel.Paint = function(self)
					surface.SetDrawColor(Color(0,0,0,155))
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				end
				PanelFadeIn(unlockpanel)
			local shipvar = GetConVar("gigabat_selectedship"):GetString()
			local shipdata = GIGABAT.Frames[shipvar]
			local skinvar = GetConVar("gigabat_selectedskin"):GetString()
			local skindata = GIGABAT.Skins[skinvar]
			local unlocklabel = vgui.Create("DLabel",unlockpanel)
				unlocklabel:SetTextColor(Color(255,255,255,255))
				unlocklabel:SetPos(5,5)
				unlocklabel:SetText("Unlock Ship")
				unlocklabel:SetFont("DermaLarge")
				unlocklabel:SizeToContents()
			local unlockskinlist = nil
			local unlockshiplist = nil
			local unlockinfo = nil
			--[[-------------------------------------------------------------------------
			SKIN UNLOCK
			---------------------------------------------------------------------------]]
			local function BuildSkinUnlockInfo(skin,data)
				unlockinfo = vgui.Create("DPanel",unlockpanel)
					unlockinfo:SetPos(255,64)
					unlockinfo:SetSize(375,406)
					unlockinfo.Paint = function(self)
						surface.SetDrawColor(Color(105,105,105,155))
						surface.DrawRect(0,0,self:GetWide(),self:GetTall())
					end			
				local unlocked = table.HasValue(LocalPlayer().gb_OwnedSkins,skin)
				local unlockbutton = vgui.Create("DButton",unlockinfo)
					unlockbutton:SetPos(unlockinfo:GetWide()/2-100,75)
					unlockbutton:SetSize(200,40)
					if unlocked then
						unlockbutton:SetText("Unlocked!")
					else
						unlockbutton.OnCursorEntered = function() surface.PlaySound(hoversound) end
						unlockbutton:SetText("Unlock")
					end
					unlockbutton:SetTextColor(Color(255,255,255,255))
					unlockbutton:SetFont("DermaLarge")
					unlockbutton.Paint = function(self)
						if !unlocked then
							if self.Hovered then
								surface.SetDrawColor(Color(115,115,115,115))
							else
								surface.SetDrawColor(Color(0,0,0,115))
							end
						else
							surface.SetDrawColor(55,55,55,55)
						end
						surface.DrawRect(0,0,self:GetWide(),self:GetTall())					
					end
					unlockbutton.DoClick = function()
						if unlocked then return end
						if LocalPlayer():GetNWInt("Gigabat_Tokens") >= data.tokencost then
							surface.PlaySound("npc/combine_gunship/ping_search.wav")
						end
						net.Start("GigabatUnlockSkin")
							net.WriteString(skin)
						net.SendToServer()
						unlockpanel:AlphaTo(0,0.5,0,function() unlockpanel:Remove() controls_open = false end)
					end
				unlockpanel.unlockinfo = unlockinfo
				local info_skintitle = vgui.Create("DLabel",unlockinfo)
					info_skintitle:SetPos(0,0)
					info_skintitle:SetFont("GBShipMenuFontSmall")
					info_skintitle:SetText(data.name)
					info_skintitle:SizeToContents()
					info_skintitle:SetPos((unlockinfo:GetWide()/2)-(info_skintitle:GetWide()/2),0)
				local info_skintokens = vgui.Create("DLabel",unlockinfo)
					info_skintokens:SetPos(0,28)
					info_skintokens:SetFont("GBShipMenuFontSmall")
					info_skintokens:SetColor(Color(215,255,155,255))
					info_skintokens:SetText("Token Cost: "..data.tokencost)
					info_skintokens:SizeToContents()
					info_skintokens:SetPos((unlockinfo:GetWide()/2)-(info_skintokens:GetWide()/2),28)
				local skin_tex1 = vgui.Create("DImage",unlockinfo)
					skin_tex1:SetImage("gigabattalion/skins/"..data.textures.hull)
					skin_tex1:SetSize(128,128)
					skin_tex1:SetPos(54,128)
				local skin_tex2 = vgui.Create("DImage",unlockinfo)
					skin_tex2:SetImage("gigabattalion/skins/"..data.textures.engine)
					skin_tex2:SetSize(128,128)
					skin_tex2:SetPos(196,128)
				local skin_tex3 = vgui.Create("DImage",unlockinfo)
					skin_tex3:SetImage("gigabattalion/skins/"..data.textures.trim)
					skin_tex3:SetSize(128,128)
					skin_tex3:SetPos(196,266)
				local skin_tex4 = vgui.Create("DImage",unlockinfo)
					skin_tex4:SetImage("gigabattalion/skins/"..data.textures.window)
					skin_tex4:SetSize(128,128)
					skin_tex4:SetPos(54,266)
			end	
			local function UpdateSkinInfoPanel(a)
				local tab = GIGABAT.Skins[a]
				unlockpanel.unlockinfo:Remove()
				BuildSkinUnlockInfo(a,tab)
			end
			unlockskinlist = vgui.Create("DScrollPanel",unlockpanel)
				unlockskinlist:SetPos(5,100)
				unlockskinlist:SetSize(240,370)
				unlockskinlist.Paint = function(self)
					surface.SetDrawColor(Color(55,55,55,215))
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
			end
			local sbar = unlockskinlist:GetVBar()
			function sbar:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(0,0,0,215)) end
			function sbar.btnUp:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(25,25,25)) end
			function sbar.btnDown:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(25,25,25)) end
			function sbar.btnGrip:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(75,75,75)) end
			local margin = 0
			for a, b in pairs(GIGABAT.Skins) do
				local unlocked = table.HasValue(LocalPlayer().gb_OwnedSkins,a)
				local skinbutton = vgui.Create("DButton",unlockskinlist)
				skinbutton:SetText(b.name)
				skinbutton:SetSize(unlockskinlist:GetWide()-4,32)
				skinbutton:SetPos(2,margin)
				skinbutton:SetFont("GBShipMenuFontSmall")
				skinbutton:SetTextColor(Color(255,255,255,255))
				skinbutton.Paint = function(self)
					if self.Hovered then
						surface.SetDrawColor(Color(115,115,115,55))
					else
						surface.SetDrawColor(Color(0,0,0,55))
						if unlocked then surface.SetDrawColor(Color(75,115,55,115)) end
					end
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
					surface.SetDrawColor(Color(115,115,115,55))
					surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
				end
				skinbutton.DoClick = function()
					if IsValid(unlockshiplist) then unlockshiplist:Hide() end
					UpdateSkinInfoPanel(a)
				end
				margin = margin + 34
			end
			unlockskinlist:Hide()
			--[[-------------------------------------------------------------------------
			SHIP UNLOCK
			---------------------------------------------------------------------------]]
			local function BuildShipUnlockInfo(ship,data)
				unlockinfo = vgui.Create("DPanel",unlockpanel)
					unlockinfo:SetPos(255,64)
					unlockinfo:SetSize(375,406)
					unlockinfo.Paint = function(self)
						surface.SetDrawColor(Color(105,105,105,155))
						surface.DrawRect(0,0,self:GetWide(),self:GetTall())
					end			
				local unlocked = table.HasValue(LocalPlayer().gb_OwnedShips,ship)
					local unlockbutton = vgui.Create("DButton",unlockinfo)
					unlockbutton:SetPos(155,90)
					unlockbutton:SetSize(200,40)
					if unlocked then
						unlockbutton:SetText("Unlocked!")
					else
						unlockbutton.OnCursorEntered = function() surface.PlaySound(hoversound) end
						unlockbutton:SetText("Unlock")
					end
					unlockbutton:SetTextColor(Color(255,255,255,255))
					unlockbutton:SetFont("DermaLarge")
					unlockbutton.Paint = function(self)
						if !unlocked then
							if self.Hovered then
								surface.SetDrawColor(Color(115,115,115,115))
							else
								surface.SetDrawColor(Color(0,0,0,115))
							end
						else
							surface.SetDrawColor(55,55,55,55)
						end
						surface.DrawRect(0,0,self:GetWide(),self:GetTall())					
					end
					unlockbutton.DoClick = function()
						if unlocked then return end
						if LocalPlayer():GetNWInt("Gigabat_Tokens") >= data.stats.tokencost then
							surface.PlaySound("npc/combine_gunship/ping_search.wav")
						end
						net.Start("GigabatUnlockShip")
							net.WriteString(ship)
						net.SendToServer()
						unlockpanel:AlphaTo(0,0.5,0,function() unlockpanel:Remove() controls_open = false end)
					end
				unlockpanel.unlockinfo = unlockinfo
				local info_shipbg = vgui.Create("DPanel",unlockinfo)
					info_shipbg:SetPos(5,5)
					info_shipbg:SetSize(128,128)
					info_shipbg.Paint = function(self)
						surface.SetDrawColor(0,0,0,85)
						surface.DrawRect(0,0,self:GetWide(),self:GetTall())
					end
				local info_ship = vgui.Create("DModelPanel",unlockinfo)
					info_ship:SetPos(5,5)
					info_ship:SetSize(128,128)
					info_ship:SetModel(data.model)
					info_ship:SetCamPos(Vector(38,0,18))
					info_ship:SetLookAt(Vector(0,0,0))
					info_ship:GetEntity():SetModelScale(data.stats.garagescale)
				local info_shiptitle = vgui.Create("DLabel",unlockinfo)
					info_shiptitle:SetPos(140,0)
					info_shiptitle:SetFont("GBShipMenuFontSmall")
					info_shiptitle:SetText(data.name)
					info_shiptitle:SizeToContents()
				local info_shiptokens = vgui.Create("DLabel",unlockinfo)
					info_shiptokens:SetPos(140,28)
					info_shiptokens:SetFont("GBShipMenuFontSmall")
					info_shiptokens:SetColor(Color(215,255,155,255))
					info_shiptokens:SetText("Token Cost: "..data.stats.tokencost)
					info_shiptokens:SizeToContents()
				local info_shiploadout = vgui.Create("DLabel",unlockinfo)
					info_shiploadout:SetPos(5,132)
					info_shiploadout:SetText("Loadout")
					info_shiploadout:SetFont("GBShipMenuFontSmall")
					info_shiploadout:SetColor(Color(255,255,255))
					info_shiploadout:SizeToContents()
				local info_shiploadout_list = vgui.Create("DScrollPanel",unlockinfo)
					info_shiploadout_list:SetSize(unlockinfo:GetWide()-10,110)
					info_shiploadout_list:SetPos(5,155)
					info_shiploadout_list.Items = {}
					info_shiploadout_list.Paint = function(self)
						surface.SetDrawColor(0,0,0,85)
						surface.DrawRect(0,0,self:GetWide(),self:GetTall())
					end
				local margin = 0
				local weapons = data.loadout
				for a, b in pairs(weapons) do
					local wepanel = vgui.Create("DPanel",info_shiploadout_list)
						wepanel:SetPos(0,margin)
						wepanel:SetSize(info_shiploadout_list:GetWide()-16,30)
						wepanel.Paint = function(self)
							surface.SetDrawColor(Color(0,0,0,255))
							surface.DrawRect(0,0,self:GetWide(),self:GetTall())
							surface.SetDrawColor(Color(215,155,55,215))
							surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
						end
					table.insert(info_shiploadout_list.Items,wepanel)
					local weapon = GIGABAT.Arsenal[b.weapon]
					local weplabel = vgui.Create("DLabel",wepanel)
						weplabel:SetText(weapon.name)
						weplabel:SetPos(2,1)
						weplabel:SetColor(Color(215,255,155,255))
						weplabel:SetFont("GBShipMenuFontSmall")
						weplabel:SizeToContents()
					margin = margin + 32
				end
				local sbar = info_shiploadout_list:GetVBar()
				function sbar:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(0,0,0,215)) end
				function sbar.btnUp:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(25,25,25)) end
				function sbar.btnDown:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(25,25,25)) end
				function sbar.btnGrip:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(155,155,155)) end
				local info_shipstats = vgui.Create("DLabel",unlockinfo)
					info_shipstats:SetPos(5,267)
					info_shipstats:SetText("Ship Stats")
					info_shipstats:SetFont("GBShipMenuFontSmall")
					info_shipstats:SetColor(Color(255,255,255))
					info_shipstats:SizeToContents()
				local info_shipstats_list = vgui.Create("DScrollPanel",unlockinfo)
					info_shipstats_list:SetSize(unlockinfo:GetWide()-10,110)
					info_shipstats_list:SetPos(5,290)
					info_shipstats_list.Items = {}
					info_shipstats_list.Paint = function(self)
						surface.SetDrawColor(0,0,0,85)
						surface.DrawRect(0,0,self:GetWide(),self:GetTall())
					end
				local margin = 0
				local function BuildDataTable(data)
					local tab = {
						hull = {name="Hull",val=data.stats.hull},
						shield = {name="Shield",val=data.stats.shield},
						maxspeed = {name="Max Speed",val=data.stats.maxspeed},
						acceleration = {name="Acceleration",val=data.stats.acceleration},
						dragspeed = {name="Drag Speed",val=data.stats.dragspeed},
						turnspeed = {name="Turn Speed",val=data.stats.turnspeed},
					}
					return tab
				end
				local stats = BuildDataTable(data)
				for a, b in pairs(stats) do
					local statpanel = vgui.Create("DPanel",info_shipstats_list)
						statpanel:SetPos(0,margin)
						statpanel:SetSize(info_shipstats_list:GetWide()-16,30)
						statpanel.Paint = function(self)
							surface.SetDrawColor(Color(0,0,0,255))
							surface.DrawRect(0,0,self:GetWide(),self:GetTall())
							surface.SetDrawColor(Color(215,155,55,215))
							surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
						end
					table.insert(info_shipstats_list.Items,statpanel)

					local statlabel = vgui.Create("DLabel",statpanel)
						if a == "maxspeed" then
							local val = math.Round(b.val/7.5)
							statlabel:SetText(b.name..": "..val.." ("..(val*2)..")")
						else
							statlabel:SetText(b.name..": "..b.val)
						end
						statlabel:SetPos(2,1)
						statlabel:SetColor(Color(215,255,155,255))
						statlabel:SetFont("GBShipMenuFontSmall")
						statlabel:SizeToContents()
					margin = margin + 32
				end		
				local sbar = info_shipstats_list:GetVBar()
				function sbar:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(0,0,0,215)) end
				function sbar.btnUp:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(25,25,25)) end
				function sbar.btnDown:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(25,25,25)) end
				function sbar.btnGrip:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(155,155,155)) end
			end	
			BuildShipUnlockInfo(shipvar,shipdata)
			local function UpdateShipInfoPanel(ship)
				local tab = GIGABAT.Frames[ship]
				unlockpanel.unlockinfo:Remove()
				BuildShipUnlockInfo(ship,tab)
			end
			unlockshiplist = vgui.Create("DScrollPanel",unlockpanel)
				unlockshiplist:SetPos(5,100)
				unlockshiplist:SetSize(240,370)
				unlockshiplist.icons = {}
				unlockshiplist.Paint = function(self)
					surface.SetDrawColor(Color(55,55,55,215))
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				end
			local sbar = unlockshiplist:GetVBar()
			function sbar:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(0,0,0,215)) end
			function sbar.btnUp:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(25,25,25)) end
			function sbar.btnDown:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(25,25,25)) end
			function sbar.btnGrip:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(75,75,75)) end
			local row = 0
			local marginx,marginy = 0,0
			for a, b in pairs(GIGABAT.Frames) do
				local unlocked = table.HasValue(LocalPlayer().gb_OwnedShips,a)
				local ship = vgui.Create("DPanel",unlockshiplist)
					ship:SetPos(marginx,marginy)
					ship:SetSize(72,72)
					ship.Paint = function() end
				local icon = vgui.Create("SpawnIcon",ship)
					icon:SetPos(-28,-28)
					icon:SetSize(128,128)
					icon:SetModel(b.model)
					table.insert(unlockshiplist.icons,icon)
				local button = vgui.Create("DButton",ship)
					button:SetPos(0,0)
					button:SetSize(72,72)
					button:SetText("")
					button.DoClick = function() 
						if IsValid(unlockskinlist) then unlockskinlist:Hide() end
						surface.PlaySound(selectsound)
						UpdateShipInfoPanel(a) 
					end
					button.OnCursorEntered = function() surface.PlaySound(hoversound) end
					button.Paint = function(self) 
						if self.Hovered then
							surface.SetDrawColor(Color(115,115,115,55))
						else
							surface.SetDrawColor(Color(0,0,0,55))
							if unlocked then surface.SetDrawColor(Color(75,115,55,115)) end
						end
						surface.DrawRect(0,0,self:GetWide(),self:GetTall())
						surface.SetDrawColor(Color(115,115,115,55))
						surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
					end
				row = row + 1
				marginx = marginx + 74
				if row > 2 then
					row = 0
					marginx = 0
					marginy = marginy + 74
				end
			end
			local unlockswitch = vgui.Create("DButton",unlockpanel)
				unlockswitch:SetPos(5,64)
				unlockswitch:SetSize(240,32)
				unlockswitch:SetText("Skin List")
				unlockswitch:SetTextColor(Color(255,255,255,255))
				unlockswitch:SetFont("DermaLarge")
				unlockswitch.OnCursorEntered = function() surface.PlaySound(hoversound) end
				unlockswitch.Paint = function(self)
					if self.Hovered then
						surface.SetDrawColor(Color(55,55,55,55))
					else
						surface.SetDrawColor(Color(155,155,155,155))
					end
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				end
				unlockswitch.DoClick = function()
					surface.PlaySound("ui/buttonclick.wav")
					if unlockmode == "ships" then
						unlockshiplist:Hide()
						unlockskinlist:Show()
						unlocklabel:SetText("Unlock Skin") unlocklabel:SizeToContents()
						unlockswitch:SetText("Ship List")
						unlockmode = "skins"
					elseif unlockmode == "skins" then
						unlockshiplist:Show()
						unlockskinlist:Hide()
						unlocklabel:SetText("Unlock Ship") unlocklabel:SizeToContents()
						unlockswitch:SetText("Skin List")
						unlockmode = "ships"
					end
				end

			local exit = CreateExitButton(unlockpanel,unlockpanel:GetWide(),5,function()
				surface.PlaySound(exitsound)
				controls_open = false
				PanelFadeOut(unlockpanel)
			end)
			local fix = vgui.Create("DImageButton",unlockpanel)
				fix:SetImage("icon16/wrench.png")
				fix:SetSize(16,16)
				fix:SetTooltip("Rebuild Icons")
				fix:SetPos(unlockpanel:GetWide()-exit:GetWide()-32,10)
				fix.DoClick = function() for a, b in pairs(unlockshiplist.icons) do b:RebuildSpawnIcon() end end
		end
		if type == "ships" then
			local shippanel = vgui.Create("DPanel",core)
				shippanel:SetSize(640,480)
				shippanel:Center()
				shippanel.Paint = function(self)
					surface.SetDrawColor(Color(0,0,0,155))
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				end
				PanelFadeIn(shippanel)
			local shiplabel = vgui.Create("DLabel",shippanel)
				shiplabel:SetTextColor(Color(255,255,255,255))
				shiplabel:SetPos(5,5)
				shiplabel:SetText("Ship Select")
				shiplabel:SetFont("DermaLarge")
				shiplabel:SizeToContents()
			local shipmenu = vgui.Create("DScrollPanel",shippanel)
				shipmenu:SetPos(5,50)
				shipmenu:SetSize(shippanel:GetWide()-10,shippanel:GetTall()-55)
				shipmenu.Paint = function(self)
					surface.SetDrawColor(Color(55,55,55,215))
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				end
			shipmenu.Icons = {}
			local marginx,marginy = 10,5
			local row = 0
			for a, b in pairs(LocalPlayer().gb_OwnedShips) do
				local shipdata = GIGABAT.Frames[b]
				local panel = vgui.Create("DPanel",shipmenu)
					panel:SetPos(marginx,marginy)
					panel:SetSize((shipmenu:GetWide()/2)-25,75)
					panel.Paint = function(self)
						surface.SetDrawColor(Color(0,0,0,215))
						surface.DrawRect(0,0,self:GetWide(),self:GetTall())
					end
				local label = vgui.Create("DLabel",panel)
					label:SetPos(80,5)
					label:SetText(shipdata.name)
					label:SetFont("DermaLarge")
					label:SetTextColor(Color(255,255,255,255))
					label:SizeToContents()
					label:CenterVertical()
				local icon = vgui.Create("SpawnIcon",panel)
					icon:SetPos(-32,-32)
					icon:SetSize(128,128)
					icon:SetModel(shipdata.model)
					table.insert(shipmenu.Icons,icon)
				local button = vgui.Create("DButton",panel)
					button:SetPos(0,0)
					button:SetSize(panel:GetWide(),panel:GetTall())
					button:SetText("")
					button.DoClick = function()
						controls_open = false
						if IsValid(GIGABAT.Garage.Container) then
							if IsValid(GIGABAT.Garage.Container.Ship) then
								surface.PlaySound(selectsound)
								GIGABAT.Garage.Container.Ship:SetModel(shipdata.model)
								GIGABAT.Garage.Container.Ship:SetModelScale(shipdata.stats.garagescale)
								GIGABAT.Garage.Container.Label:SetText(shipdata.name)
								GIGABAT.Garage.Container.Label:SizeToContents()
								GIGABAT.Functions.ApplySkin(GIGABAT.Garage.Container.Ship,GIGABAT.Garage.SelectedSkin)
							end
						end
						GIGABAT.Functions.Notification({txt="Ship Selected: "..shipdata.name,color=notifcolor})	
						GIGABAT.Garage.SelectedShip = b
						GIGABAT.Garage.Container.Label:CenterHorizontal()
						LoadInfoPanels(core)
						PanelFadeOut(shippanel)
						GetConVar("gigabat_selectedship"):SetString(GIGABAT.Garage.SelectedShip)
					end
					button.Paint = function(self) 
						if self.Hovered then
							surface.SetDrawColor(Color(155,155,155,55))
							surface.DrawRect(0,0,self:GetWide(),self:GetTall())
						end
					end
				row = row + 1
				marginx = marginx + (shipmenu:GetWide()/2)-15
				if row >= 2 then
					row = 0
					marginx = 10
					marginy = marginy + 86
				end
			end
			local exit = CreateExitButton(shippanel,shippanel:GetWide(),5,function()
				surface.PlaySound(exitsound)
				controls_open = false
				PanelFadeOut(shippanel)
			end)
			local fix = vgui.Create("DImageButton",shippanel)
				fix:SetImage("icon16/wrench.png")
				fix:SetSize(16,16)
				fix:SetTooltip("Rebuild Icons")
				fix:SetPos(shippanel:GetWide()-exit:GetWide()-32,10)
				fix.DoClick = function() for a, b in pairs(shipmenu.Icons) do b:RebuildSpawnIcon() end end
		end
		if type == "skins" then
			local skinpanel = vgui.Create("DPanel",core)
				skinpanel:SetSize(640,480)
				skinpanel:Center()
				skinpanel.Paint = function(self)
					surface.SetDrawColor(Color(0,0,0,155))
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				end
				PanelFadeIn(skinpanel)
			local skinlabel = vgui.Create("DLabel",skinpanel)
				skinlabel:SetTextColor(Color(255,255,255,255))
				skinlabel:SetPos(5,5)
				skinlabel:SetText("Skin Select")
				skinlabel:SetFont("DermaLarge")
				skinlabel:SizeToContents()
			local skinmenu = vgui.Create("DScrollPanel",skinpanel)
				skinmenu:SetPos(5,50)
				skinmenu:SetSize(skinpanel:GetWide()-10,skinpanel:GetTall()-55)
				skinmenu.Paint = function(self)
					surface.SetDrawColor(Color(55,55,55,215))
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				end
			local marginx,marginy = 10,5
			local row = 0
			for a, b in pairs(LocalPlayer().gb_OwnedSkins) do
				local skindata = GIGABAT.Skins[b]
				local panel = vgui.Create("DPanel",skinmenu)
					panel:SetPos(marginx,marginy)
					panel:SetSize((skinmenu:GetWide()/2)-25,75)
					panel.Paint = function(self)
						surface.SetDrawColor(Color(0,0,0,215))
						surface.DrawRect(0,0,self:GetWide(),self:GetTall())
					end
				local label = vgui.Create("DLabel",panel)
					label:SetPos(80,5)
					label:SetText(skindata.name)
					label:SetFont("DermaLarge")
					label:SetTextColor(Color(255,255,255,255))
					label:SizeToContents()
					label:CenterVertical()
				local icon = vgui.Create("DImage",panel)
					icon:SetSize(70,70)
					icon:SetPos(2,2)
					icon:SetImage("gigabattalion/skins/"..skindata.textures.hull)
				local button = vgui.Create("DButton",panel)
					button:SetPos(0,0)
					button:SetSize(panel:GetWide(),panel:GetTall())
					button:SetText("")
					button.DoClick = function()
						controls_open = false
						if IsValid(GIGABAT.Garage.Container) then
							if IsValid(GIGABAT.Garage.Container.Ship) then
								surface.PlaySound(selectsound)
								GIGABAT.Garage.Container.SkinLabel:SetText(skindata.name)
								GIGABAT.Garage.Container.SkinLabel:SizeToContents()
								GIGABAT.Functions.ApplySkin(GIGABAT.Garage.Container.Ship,b)
							end
						end
						GIGABAT.Functions.Notification({txt="Skin Selected: "..skindata.name,color=notifcolor})	
						GIGABAT.Garage.SelectedSkin = b
						GIGABAT.Garage.Container.SkinLabel:CenterHorizontal()
						PanelFadeOut(skinpanel)
						GetConVar("gigabat_selectedskin"):SetString(GIGABAT.Garage.SelectedSkin)
					end
					button.Paint = function(self) 
						if self.Hovered then
							surface.SetDrawColor(Color(155,155,155,55))
							surface.DrawRect(0,0,self:GetWide(),self:GetTall())
						end
					end
				row = row + 1
				marginx = marginx + (skinmenu:GetWide()/2)-15
				if row >= 2 then
					row = 0
					marginx = 10
					marginy = marginy + 86
				end
			end
			CreateExitButton(skinpanel,skinpanel:GetWide(),5,function()
				surface.PlaySound(exitsound)
				controls_open = false
				PanelFadeOut(skinpanel)
			end)			
		end
		if type == "backgrounds" then
			local bgpanel = vgui.Create("DPanel",core)
				bgpanel:SetSize(640,480)
				bgpanel:Center()
				bgpanel.Paint = function(self)
					surface.SetDrawColor(Color(0,0,0,155))
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				end
				PanelFadeIn(bgpanel)
			local bglabel = vgui.Create("DLabel",bgpanel)
				bglabel:SetTextColor(Color(255,255,255,255))
				bglabel:SetPos(5,5)
				bglabel:SetText("Backgrounds")
				bglabel:SetFont("DermaLarge")
				bglabel:SizeToContents()
			local bgmenu = vgui.Create("DScrollPanel",bgpanel)
				bgmenu:SetPos(5,50)
				bgmenu:SetSize(bgpanel:GetWide()-10,bgpanel:GetTall()-55)
				bgmenu.Paint = function(self)
					surface.SetDrawColor(Color(55,55,55,215))
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				end
			local margin = 0
			for a, b in pairs(GIGABAT.Garage.Backdrops) do
				local button = vgui.Create("DButton",bgmenu)
					button:SetPos(5,5+margin)
					button:SetSize(bgmenu:GetWide()-10,64)
					button:SetText(a)
					button:SetFont("DermaLarge")
					button:SetTextColor(Color(255,255,255,255))
					button.DoClick = function()
						controls_open = false
						GetConVar("gigabat_garagebackdrop"):SetString(a)
						if IsValid(GIGABAT.Garage.Container) then
							GIGABAT.Garage.Container:SetModel(b.model)
							if IsValid(GIGABAT.Garage.Container.Ship) then
								GIGABAT.Garage.Container.Ship:SetPos(GIGABAT.Garage.Container.Entity:GetPos()+b.offset)
							end
						end
						GIGABAT.Functions.Notification({txt="Background Selected: "..a,color=notifcolor})	
						PanelFadeOut(bgpanel)
					end
					button.Paint = function(self)
						surface.SetDrawColor(Color(215,215,215,100))
						surface.DrawRect(0,0,self:GetWide(),self:GetTall())
					end
				margin = margin + 70
			end
			CreateExitButton(bgpanel,bgpanel:GetWide(),5,function()
				surface.PlaySound(exitsound)
				controls_open = false
				PanelFadeOut(bgpanel)
			end)		
		end
	end

	local function UnhideGarage() GIGABAT.Garage.Core:Show() end
	local function CreateGarage()
		if !IsValid(GIGABAT.Garage.Core) then GIGABAT.Functions.GarageInit() end
		local core = GIGABAT.Garage.Core
		core:Show()
		gui.EnableScreenClicker(true)
		GIGABAT.Garage.SelectedShip = GIGABAT.Config.DefaultShip
		GIGABAT.Garage.SelectedSkin = GIGABAT.Config.DefaultSkin

		if LocalPlayer().gb_OwnedShips == nil then
			LocalPlayer().gb_OwnedShips = {GIGABAT.Config.DefaultShip}
		end
		if LocalPlayer().gb_OwnedSkins == nil then
			LocalPlayer().gb_OwnedSkins = {GIGABAT.Config.DefaultSkin}
		end
		if table.HasValue(LocalPlayer().gb_OwnedShips,GetConVar("gigabat_selectedship"):GetString()) then
			GIGABAT.Garage.SelectedShip = GetConVar("gigabat_selectedship"):GetString()
		end
		if table.HasValue(LocalPlayer().gb_OwnedSkins,GetConVar("gigabat_selectedskin"):GetString()) then
			GIGABAT.Garage.SelectedSkin = GetConVar("gigabat_selectedskin"):GetString()
		end
		local backdrop = "garage"
		local backdrop_offset = Vector(0,0,0)
		for a, b in pairs(GIGABAT.Garage.Backdrops) do
			if GetConVar("gigabat_garagebackdrop"):GetString() == a then
				backdrop = b.model
				backdrop_offset = b.offset
			end
		end
		GIGABAT.Garage.Container = vgui.Create("DAdjustableModelPanel",core)
		local container = GIGABAT.Garage.Container
			container.offset = backdrop_offset
			container:Dock(FILL)
			container:SetCamPos(Vector(128,0,0)+backdrop_offset)
			container:SetLookAng((backdrop_offset-container:GetCamPos()):Angle())
			container:SetModel(backdrop)
			container:SetDirectionalLight(BOX_BOTTOM, 	Color(0,0,0))		
			container:SetDirectionalLight(BOX_TOP, 		Color(215,215,215))	
			container:SetDirectionalLight(BOX_FRONT, 	Color(55,55,55))	
			container:SetDirectionalLight(BOX_BACK, 	Color(55,55,55))	
			container:SetDirectionalLight(BOX_RIGHT, 	Color(55,55,55))	
			container:SetDirectionalLight(BOX_LEFT, 	Color(55,55,55))					
			container:SetAmbientLight(Color(155,215,255,255))
			container.OnMousePressed = function(mousecode) end
			container.OnRemove = function() if IsValid(container.Ship) then container.Ship:Remove() end end
			if IsValid(container.Ship) then container.Ship:Remove() end
			local function CreateShipModel()
				local model = GIGABAT.Frames[GIGABAT.Garage.SelectedShip].model
				local scale = GIGABAT.Frames[GIGABAT.Garage.SelectedShip].stats.garagescale
				container.Ship = ClientsideModel(model,RENDERGROUP_TRANSLUCENT)
				container.Ship:SetModelScale(scale)
				GIGABAT.Functions.ApplySkin(container.Ship,GIGABAT.Garage.SelectedSkin)
			end
			container.PostDrawModel = function(ent)
				if !IsValid(container.Ship) then
					CreateShipModel()
				else
					local ang = ent:GetEntity():GetAngles()
					container.Ship:SetPos(container:GetEntity():GetPos()+container.offset)
					container.Ship:SetAngles(Angle(-25,-140-ang.y,-15))
					container.Ship:DrawModel()
				end
			end
		local ship_label = vgui.Create("DLabel",core)
			ship_label:SetText(GIGABAT.Frames[GIGABAT.Garage.SelectedShip].name)
			ship_label:SetFont("GBShipMenuFont")
			ship_label:SetTextColor(Color(255,255,255,255))
			ship_label:SizeToContents()
			ship_label:SetPos(0,128)
			ship_label:CenterHorizontal()
			container.Label = ship_label
		local ship_skinlabel = vgui.Create("DLabel",core)
			ship_skinlabel:SetText(GIGABAT.Skins[GIGABAT.Garage.SelectedSkin].name)
			ship_skinlabel:SetFont("DermaLarge")
			ship_skinlabel:SetTextColor(Color(255,255,255,255))
			ship_skinlabel:SizeToContents()
			ship_skinlabel:SetPos(0,175)
			ship_skinlabel:CenterHorizontal()
			container.SkinLabel = ship_skinlabel
		local avatar = vgui.Create("AvatarImage",core)
			avatar:SetPos(64,64)
			avatar:SetSize(96,96)
			avatar:SetPlayer(LocalPlayer(),96)
		local player_label = vgui.Create("DLabel",core)
			player_label:SetText(LocalPlayer():Name())
			player_label:SetFont("DermaLarge")
			player_label:SetTextColor(Color(185,215,255,255))
			player_label:SizeToContents()
			player_label:SetPos(174,64)
		local tokens_label = vgui.Create("DLabel",core)
			tokens_label:SetText("Tokens: "..LocalPlayer():GetNWInt("Gigabat_Tokens"))
			tokens_label:SetFont("DermaLarge")
			tokens_label:SetTextColor(Color(255,215,185,255))
			tokens_label:SizeToContents()
			tokens_label:SetPos(174,96)
			tokens_label.Think = function()
				tokens_label:SetText("Tokens: "..LocalPlayer():GetNWInt("Gigabat_Tokens"))
				tokens_label:SizeToContents()
			end
		local bottom = vgui.Create("DPanel",core)
			bottom:SetSize(640,150)
			bottom:SetPos(ScrW()/2-320,core:GetTall()-150)
			bottom.Paint = function(self)
				surface.SetDrawColor(Color(255,255,255,255))
				surface.SetMaterial(Material("gigabattalion/ui/garagebar.png"))
				surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
			end
		local selectcolor = Color(0,0,0,255)
		local normalcolor = Color(255,255,255,255)
		local pos = {x=bottom:GetWide()/2-64,y=bottom:GetTall()/2-64}
		local ships_button = vgui.Create("DButton",bottom)
			ships_button:SetSize(128,128)
			ships_button:SetPos(pos.x,pos.y)
			ships_button:SetText("")
			ships_button.OnCursorEntered = function() surface.PlaySound(hoversound) end
			ships_button.DoClick = function()
				surface.PlaySound(selectsound)
				OpenItemMenu("ships")
			end
			ships_button.Paint = function(self)
				if self:IsHovered() then
					surface.SetDrawColor(selectcolor)
				else
					surface.SetDrawColor(normalcolor)
				end
				surface.SetMaterial(Material("gigabattalion/ui/garage_ships.png"))
				surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
			end
		pos.x = pos.x - 200
		local unlock_button = vgui.Create("DButton",bottom)
			unlock_button:SetSize(128,128)
			unlock_button:SetPos(pos.x,pos.y)
			unlock_button:SetText("")
			unlock_button.OnCursorEntered = function() surface.PlaySound(hoversound) end
			unlock_button.DoClick = function()
				surface.PlaySound(selectsound)
				OpenItemMenu("unlock")
			end
			unlock_button.Paint = function(self)
				if self:IsHovered() then
					surface.SetDrawColor(selectcolor)
				else
					surface.SetDrawColor(normalcolor)
				end
				surface.SetMaterial(Material("gigabattalion/ui/garage_unlock.png"))
				surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
			end
		pos.x = pos.x + 400
		local skins_button = vgui.Create("DButton",bottom)
			skins_button:SetSize(128,128)
			skins_button:SetPos(pos.x,pos.y)
			skins_button:SetText("")	
			skins_button.OnCursorEntered = function() surface.PlaySound(hoversound) end
			skins_button.DoClick = function()
				surface.PlaySound(selectsound)
				OpenItemMenu("skins")
			end		
			skins_button.Paint = function(self)
				if self:IsHovered() then
					surface.SetDrawColor(selectcolor)
				else
					surface.SetDrawColor(normalcolor)
				end
				surface.SetMaterial(Material("gigabattalion/ui/garage_skins.png"))
				surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
			end
		local function CreateGarageTextButton(x,y,txt,clr,func)
			local button = vgui.Create("DButton",core)
				button:SetPos(x,y)
				button:SetText(txt)
				button:SetFont("DermaLarge")
				button:SetSize(200,32)
				button.Color = clr
				button:SetTextColor(Color(255,255,255,255))
				button.OnCursorEntered = function() surface.PlaySound(hoversound) end
				button.DoClick = function() func() end
				button.Paint = function(self)
					if self:IsHovered() then
						self:SetTextColor(self.Color)
					else
						self:SetTextColor(Color(255,255,255,255))
					end
				end
		end
		local margin1 = 64
		CreateGarageTextButton(core:GetWide()-256,margin1,"Exit",Color(255,115,115,255),function()
			surface.PlaySound(exitsound)
			GIGABAT.Functions.CloseGarage(false)
		end)
		margin1 = margin1 + 40
		CreateGarageTextButton(core:GetWide()-256,margin1,"Launch",Color(255,215,55,255),function()
			net.Start("GigabatSendShipSelect")
				net.WriteString(GIGABAT.Garage.SelectedShip)
				net.WriteString(GIGABAT.Garage.SelectedSkin)
			net.SendToServer()
			GetConVar("gigabat_selectedship"):SetString(GIGABAT.Garage.SelectedShip)
			GetConVar("gigabat_selectedskin"):SetString(GIGABAT.Garage.SelectedSkin)
			GIGABAT.Functions.CloseGarage(true)
		end)
		margin1 = margin1 + 40
		CreateGarageTextButton(core:GetWide()-256,margin1,"Backgrounds",Color(155,215,255,255),function()
			surface.PlaySound(selectsound)
			OpenItemMenu("backgrounds")
		end)
		local margin2 = 500
		CreateGarageTextButton(100,margin2,"Objective",Color(155,215,255,255),function()
			surface.PlaySound(selectsound)
			OpenItemMenu("objective")
		end)
		margin2 = margin2 + 40
		CreateGarageTextButton(100,margin2,"How to Play",Color(155,215,255,255),function()
			surface.PlaySound(selectsound)
			OpenItemMenu("howtoplay")
		end)
		margin2 = margin2 + 40
		CreateGarageTextButton(100,margin2,"Controls",Color(155,215,255,255),function()
			surface.PlaySound(selectsound)
			OpenItemMenu("controls")
		end)
		LoadInfoPanels(core)
		GIGABAT.Functions.Transition(false)
		GIGABAT.Functions.ShowChat()
	end
	GIGABAT.Functions.Transition(true)
	timer.Simple(2,function() CreateGarage() end)
end
timer.Simple(1,function() GIGABAT.Functions.GarageInit() end)