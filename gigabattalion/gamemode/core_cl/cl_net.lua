net.Receive("Asteroid_HealthPoke",function(len,pl)
	local ent = net.ReadEntity()
	if IsValid(ent) then
		if ent.HealthPokeScale then
			ent:CLHealthPoke()
		end
	end
end)
net.Receive("Ship_ShieldPoke",function(len,pl)
	local ent = net.ReadEntity()
	if IsValid(ent) then
		if ent.ShieldPokeScale then
			ent:CLShieldPoke()
		end
	end
end)
net.Receive("Ship_Stealth",function(len,pl)
	local ent = net.ReadEntity()
	local time = net.ReadInt(32)
	if IsValid(ent) then
		ent:Stealth(time)
	end
end)
net.Receive("GigabatSendGameInfo",function(len,pl)
	local gameinfo = net.ReadTable()
	local objective = net.ReadTable()
	local round = net.ReadTable()
	GIGABAT.GameInfo = table.Copy(gameinfo)
	GIGABAT.Config.ObjectiveTitle = objective.title
	GIGABAT.Config.ObjectiveTask = objective.task
	GIGABAT.Config.Round = table.Copy(round)
	GIGABAT.Config.Scenario = gameinfo.scenario
	GIGABAT.Config.GameType = gameinfo.gametype
end)
net.Receive("GigabatSendRoundTimer",function(len,pl)
	local time = net.ReadInt(32)
	if time > 0 then
		timer.Create("GigabatRoundTimerCL",time,1,function() end)
	else
		timer.Remove("GigabatRoundTimerCL")
	end
end)
net.Receive("GigabatSendMenu",function(len,pl)
	GIGABAT.Functions.Menu()
end)
net.Receive("GigabatSendData",function(len,pl)
	local stats = net.ReadTable() 
	local ships = net.ReadTable()
	local skins = net.ReadTable()
	LocalPlayer().gb_Stats = table.Copy(stats)
	LocalPlayer().gb_OwnedShips = table.Copy(ships)
	LocalPlayer().gb_OwnedSkins = table.Copy(skins)
end)

net.Receive("GigabatSendGarage",function(len,pl)
	if IsValid(GIGABAT.Garage.Core) && GIGABAT.Garage.Core:IsVisible() then return end
	GIGABAT.Functions.OpenGarage()
end)