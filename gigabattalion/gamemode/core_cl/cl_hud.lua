CreateClientConVar("gigabat_crosshairlead","true",true,false)
CreateClientConVar("gigabat_crosshair","true",true,false)
local targetmat = Material("gigabattalion/ui/gigabat_targettest.png")
local crosshair = Material("gigabattalion/ui/crosshair.png")
local crosshairrot = 0
local crosshairfilter = {"gigabat_asteroid","gigabat_station","gigabat_debris"}
local lic = Color(255,55,55,75)
local hudbracket = Material("gigabattalion/ui/hud_bracket.png")
local deathalpha = 0
local damagealpha = 0
local killerplayer = nil
local killerwep = ""
local killermsg = ""
gigabat_deathmsg = "Press F1 to access the menu!"
local function GigabatDrawHUD()
	local drawhud = GetConVar("gigabat_drawhud"):GetString()
	local ply = LocalPlayer()
	if !ply:Alive() then
		deathalpha = math.Clamp(deathalpha + FrameTime()*200,0,55)
	else
		deathalpha = math.Clamp(deathalpha - FrameTime()*100,0,55)
	end

	if damagealpha > 0 then
		damagealpha = math.Clamp(damagealpha - FrameTime()*256,0,100)
		surface.SetDrawColor(255,0,0,damagealpha)
		surface.DrawRect(0,0,ScrW(),ScrH())
	end

	if deathalpha > 0 then
		surface.SetDrawColor(0,0,0,deathalpha)
		surface.DrawRect(0,0,ScrW(),ScrH())
		surface.SetDrawColor(100,100,100,deathalpha)
		surface.DrawRect(0,ScrH()/2-75,ScrW(),150)	
		if IsValid(killerplayer) then
			if killerplayer == ply then
				gigabat_deathmsg = "You self-destructed!"
			else
				if killerplayer:IsPlayer() then
					if killerwep == "" then
						gigabat_deathmsg = "You were "..killermsg.." by "..killerplayer:Name().." !"
					else
						gigabat_deathmsg = killerplayer:Name().." "..killermsg.." you with a "..killerwep.."!"
					end
				else
					if killerplayer:GetClass() == "gigabat_asteroid" then
						gigabat_deathmsg = "You were "..killermsg.." by an asteroid!"
					end
				end
			end
		end
		draw.Text({text=gigabat_deathmsg,font="DermaLarge",pos={ScrW()/2,ScrH()/2},xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_CENTER,color=Color(255,55,55,deathalpha*5)})	
		if timer.Exists("GigabatRespawnTimer") then
			local respawntime = timer.TimeLeft("GigabatRespawnTimer")
			if respawntime > 0 then
				draw.Text({text="Respawning in "..string.NiceTime(respawntime).."...",font="DermaLarge",pos={ScrW()/2,ScrH()/2+32},xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_CENTER,color=Color(155,155,155,deathalpha*5)})
			end	
		end
		return
	end

	if timer.Exists("GigabatRoundTimerCL") then
		local roundtime = timer.TimeLeft("GigabatRoundTimerCL")
		if roundtime > 0 then
			draw.Text({text="Time Left: "..math.Round(roundtime),font="DermaLarge",pos={ScrW()/2,128},xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_CENTER,color=Color(155,155,155,215)})
		end			
	end

	local ship = GIGABAT.Camera.Ship
	if IsValid(ship) then
		if IsValid(ship.Body) then
			local ang = ship.Body:GetAngles()
			local tr = util.QuickTrace(ship:GetPos()+(ship:GetForward()*-128),-ang:Forward()*2048,function(ent) if table.HasValue(crosshairfilter,ent:GetClass()) then return true end end)
			local ts = tr.HitPos:ToScreen()
			local color = Color(255,255,255,75)
			for a, b in pairs(ents.FindByClass("gigabat_waypoint")) do
				if b:GetNWInt("Waypoint") == ply:GetNWInt("Gigabat_Waypoint") then
					local waypos = b:GetPos():ToScreen()
					local mult = ship:GetPos():DistToSqr(b:GetPos())/10000
					size = math.Clamp(64/mult,128,256)
					surface.SetDrawColor(Color(255,215,115,155))
					surface.SetMaterial(targetmat)
					surface.DrawTexturedRect(waypos.x-(size/2),waypos.y-(size/2),size,size)
					surface.DrawLine(ScrW()/2,ScrH()/2,waypos.x,waypos.y)
				end
			end
			if IsValid(tr.Entity) then
				if table.HasValue(GIGABAT.Config.TargetableEntities,tr.Entity:GetClass()) then
					color = Color(255,55,55,75)
				end
			end
			if GetConVar("gigabat_crosshairlead"):GetString() == "true" then
				surface.SetDrawColor(Color(255,255,255,25))
				surface.SetMaterial(crosshair)
				surface.DrawTexturedRect(ScrW()/2-8,ScrH()/2-8,16,16)
				surface.DrawLine(ScrW()/2,ScrH()/2,ts.x,ts.y)
			end
			if GetConVar("gigabat_crosshair"):GetString() == "true" then
				surface.SetDrawColor(color)
				surface.SetMaterial(crosshair)
				surface.DrawTexturedRect(ts.x-16,ts.y-16,32,32)
				local tr2 = util.QuickTrace(ship:GetPos()+(ship:GetForward()*-128),-ang:Forward()*99999,function(ent) if table.HasValue(crosshairfilter,ent:GetClass()) then return true end end)	
				local ts = tr2.HitPos:ToScreen()
				surface.SetDrawColor(Color(255,255,255,25))
				surface.SetMaterial(crosshair)
				surface.DrawTexturedRect(ts.x-8,ts.y-8,16,16)
			end
			if drawhud == "true" then
				local tr1 = util.QuickTrace(ship:GetPos()+(ship:GetForward()*-128),-ang:Forward()*4096,true)
				if tr1.HitSky then
					lic.r = lic.r + (FrameTime()*512)
					if lic.r > 255 then lic.r = 0 end
					draw.Text({text="Leaving Battlefield!",font="DermaLarge",pos={ScrW()/2,ScrH()/2-65},xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_CENTER,color=lic})
				end

				if ship.Protection then draw.Text({text="Spawn Protection",font="GBShipMenuFontSmall",pos={ScrW()/2,ScrH()/2-205},xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_CENTER,color=Color(155,215,255,215)}) end
				if ship:GetNWInt("Armor") < 50 then draw.Text({text="Hull Critical",font="GBShipMenuFontSmall",pos={ScrW()/2,ScrH()/2-165},xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_CENTER,color=Color(255,55,55,215)}) end

				local fuel = ship:GetNWInt("Fuel")
				if fuel < 25 then
					local fueltxt = "Low Fuel"
					if fuel == 0 then fueltxt = "Fuel Depleted" end
					draw.Text({text=fueltxt,font="GBShipMenuFontSmall",pos={ScrW()/2,ScrH()/2+165},xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_CENTER,color=Color(255,215,155,215)})
				end

				local energy = ship:GetNWInt("Energy")
				if energy < 25 then
					local energytxt = "Low Energy"
					if energy == 0 then energytxt = "Energy Depleted" end
					draw.Text({text=energytxt,font="GBShipMenuFontSmall",pos={ScrW()/2,ScrH()/2+205},xalign=TEXT_ALIGN_CENTER,yalign=TEXT_ALIGN_CENTER,color=Color(155,215,255,215)})
				end
			end
		end

		-- HUD
		if drawhud == "true" then
			local offset = 256 + (GIGABAT.Camera.Zoom/10)
			surface.SetDrawColor(Color(255,255,255,math.Clamp((GIGABAT.Camera.Zoom/15),0,65)))
			surface.SetMaterial(hudbracket)
			surface.DrawTexturedRectRotated(ScrW()/2-offset,ScrH()/2+(offset/5),128,256,0)
			surface.DrawTexturedRectRotated(ScrW()/2+offset,ScrH()/2+(offset/5),128,256,180)

			local armor = ship:GetNWInt("Armor")
			local color = Color(255,235,215,155)
			if armor <= 50 then color = Color(255,115,115,155) end
			surface.SetDrawColor(Color(255,235,215,155))
			surface.SetMaterial(Material("vgui/gradient_down"))
			local val = math.Clamp(armor*2,0,100)
			surface.DrawTexturedRectRotated(ScrW()/2-offset+64,ScrH()/2+(offset/5)-(val/2)+1,16,val,180)
			surface.DrawTexturedRectRotated(ScrW()/2-offset+64,ScrH()/2+(offset/5)+(val/2)-1,16,val,0)
			draw.Text({text=armor.." :Hull",font="DermaLarge",pos={ScrW()/2-offset+40,ScrH()/2+(offset/5)-4},xalign=TEXT_ALIGN_RIGHT,yalign=TEXT_ALIGN_CENTER,color=color})

			local shield = ship:GetNWInt("Shield")
			surface.SetDrawColor(Color(215,235,255,155))
			surface.SetMaterial(Material("vgui/gradient_down"))
			local val = math.Clamp(shield,0,100)
			surface.DrawTexturedRectRotated(ScrW()/2+offset-64,ScrH()/2+(offset/5)-(val/2)+1,16,val,180)
			surface.DrawTexturedRectRotated(ScrW()/2+offset-64,ScrH()/2+(offset/5)+(val/2)-1,16,val,0)
			draw.Text({text="Shield: "..shield,font="DermaLarge",pos={ScrW()/2+offset-40,ScrH()/2+(offset/5)-4},xalign=TEXT_ALIGN_LEFT,yalign=TEXT_ALIGN_CENTER,color=Color(215,235,255,155)})
			
			local energy = ship:GetNWInt("Energy")
			draw.Text({text="Energy: "..energy,font="GBShipMenuFontSmall",pos={ScrW()/2+offset-40,ScrH()/2+(offset/5)-64},xalign=TEXT_ALIGN_LEFT,yalign=TEXT_ALIGN_CENTER,color=Color(215,235,255,155)})

			surface.SetDrawColor(Color(255,215,155,155))
			surface.SetMaterial(Material("vgui/gradient_down"))
			local speed = math.Round(ship:GetVelocity():Length()/7.5)
			local val = math.Clamp(speed,0,125)
			surface.DrawTexturedRectRotated(ScrW()/2+offset-82,ScrH()/2+(offset/5)-(val/2),16,val,180)
			surface.DrawTexturedRectRotated(ScrW()/2+offset-82,ScrH()/2+(offset/5)+(val/2),16,val,0)
			surface.DrawTexturedRectRotated(ScrW()/2-offset+82,ScrH()/2+(offset/5)-(val/2),16,val,180)
			surface.DrawTexturedRectRotated(ScrW()/2-offset+82,ScrH()/2+(offset/5)+(val/2),16,val,0)
			local fuel = math.Round(ship:GetNWInt("Fuel"))		
			draw.Text({text=fuel.." :Fuel",font="GBShipMenuFontSmall",pos={ScrW()/2-offset+40,ScrH()/2+(offset/5)-64},xalign=TEXT_ALIGN_RIGHT,yalign=TEXT_ALIGN_CENTER,color=Color(255,235,215,155)})
		end
	end
	local target = GIGABAT.Camera.Target
	if IsValid(target) then
		crosshairrot = crosshairrot + 0.5
		local pos = target:GetPos():ToScreen()
		local scale = target:GetPos():DistToSqr(ply:GetPos())/10000
		scale = math.Clamp(64*scale,1,128)
		surface.SetDrawColor(Color(255,55,55,scale))
		surface.SetMaterial(targetmat)
		surface.DrawTexturedRectRotated(pos.x,pos.y,scale,scale,crosshairrot)
	end
end
GIGABAT.Chat = {}
GIGABAT.Chat.Panel = nil
function GIGABAT.Functions.ShowChat()
	if GetConVar("gigabat_togglechat"):GetString() == "false" then return end
	if !IsValid(GIGABAT.Chat.Panel) then
		GIGABAT.Chat.Panel = vgui.Create("DFrame")
		GIGABAT.Chat.Panel:SetSize(400,200)
		GIGABAT.Chat.Panel:SetPos(15,ScrH()-215)
		GIGABAT.Chat.Panel:SetTitle("")
		GIGABAT.Chat.Panel:SetDraggable(true)
		GIGABAT.Chat.Panel:ShowCloseButton(false)
		GIGABAT.Chat.Panel:MakePopup()
		GIGABAT.Chat.Panel:SetAlpha(0)
		GIGABAT.Chat.Panel:AlphaTo(255,0.5,0)
		local msgs = vgui.Create("DPanel",GIGABAT.Chat.Panel)
		msgs:SetPos(2,2)
		msgs:SetSize(GIGABAT.Chat.Panel:GetWide()-4,GIGABAT.Chat.Panel:GetTall()-27)
		GIGABAT.Chat.Panel.msgs = msgs
		local msgs_txt = vgui.Create("RichText",msgs)
		msgs_txt:Dock(FILL)
		msgs.msgs_txt = msgs_txt
		msgs_txt.Paint = function(self)
			surface.SetDrawColor(Color(0,0,0,245))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
			surface.SetDrawColor(Color(155,155,155,155))
			surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
		end
		function msgs_txt:PerformLayout()
			self:SetFontInternal("GBShipMenuFontSmall")
		end
	end
	if !IsValid(GIGABAT.Chat.Panel.TextEntry) then
		local txt = vgui.Create("DTextEntry",GIGABAT.Chat.Panel)
		txt:SetText("")
		txt:SetSize(GIGABAT.Chat.Panel:GetWide()-4,23)
		txt:SetPos(2,GIGABAT.Chat.Panel:GetTall()-25)
		txt:SetTextColor(Color(0,0,0,255))
		txt.OnEnter = function(self)
			local message = tostring(self:GetValue())
			if #message == 0 then return end
			RunConsoleCommand("say",message)
			self:SetText("")
			self:SetValue("")
			chat.Close()
		end
		GIGABAT.Chat.Panel.TextEntry = txt		
		function txt:PerformLayout()
			self:SetFontInternal("DermaDefaultBold")
		end
	end

	GIGABAT.Chat.Panel:Show()
end
function GM:StartChat(team)
	if IsValid(GIGABAT.Starmap.Panel) then return true end
	if IsValid(GIGABAT.Panels.SplashScreen) then return true end
	if IsValid(GIGABAT.Garage.Core) && GIGABAT.Garage.Core:IsVisible() then 
		return true 
	end
	return false
end
net.Receive("GigabatSendDeath",function(len,pl)
	local nextspawn = net.ReadInt(32)
	timer.Create("GigabatRespawnTimer",nextspawn,1,function() nextspawn = 0 end)
end)
net.Receive("GigabatSendDamage",function(len,pl)
	if LocalPlayer():Alive() then damagealpha = 255 end
end)
net.Receive("GigabatSendKiller",function(len,pl)
	local killer = net.ReadEntity()
	local wep = net.ReadString()
	killerplayer = killer
	killerwep = wep
	local randos = {"annihilated","destroyed","terminated","retired","pwned","wrecked","eradicated","removed","deleted"}
	local rand = math.random(1,#randos)
	killermsg = randos[rand]
end)
hook.Add("OnPlayerChat","GigabatOnChat",function(ply,strText,bTeam,bDead)
	if IsValid(GIGABAT.Chat.Panel) then
		local plyname = ply:Name()
		local chatpanel = GIGABAT.Chat.Panel.msgs.msgs_txt
		chatpanel:InsertColorChange(255,255,155,255)
		chatpanel:AppendText(plyname..": ")
		chatpanel:InsertColorChange(255,255,255,255)
		chatpanel:AppendText(strText.."\n")
	end
end)
hook.Add("PostDrawHUD","GigabatDrawHUD",GigabatDrawHUD)
hook.Add("HUDShouldDraw","GigabatHideHUD",function(name) 
	if name == "CHudCrosshair" then return false end 
end)