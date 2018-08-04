function GIGABAT.Functions.PlayerGameSync(ply)
	local gameinfo = {scenario = GIGABAT.Config.Scenario,gametype = GIGABAT.Config.GameType}
	local objective = {title = GIGABAT.Config.ObjectiveTitle,task = GIGABAT.Config.ObjectiveTask}
	net.Start("GigabatSendGameInfo")
		net.WriteTable(gameinfo)
		net.WriteTable(objective)
		net.WriteTable(GIGABAT.Config.Round)
	net.Send(ply)
end

function GIGABAT.Functions.PlayerDataSync(ply)
	net.Start("GigabatSendData")
		net.WriteTable(ply.gb_Stats)
		net.WriteTable(ply.gb_OwnedShips)
		net.WriteTable(ply.gb_OwnedSkins)
	net.Send(ply)
end

function GIGABAT.Functions.RoamSpectate(ply)
	ply.gb_Ready = false
	if IsValid(ply.Ship) then
		ply.Ship:Remove()
	end
	ply:Spectate(OBS_MODE_ROAMING)
	GIGABAT.Functions.Notification("You are now spectating!",Color(65,65,65),ply,false)
end
net.Receive("GigabatSpectateRoam",function(len,pl)
	GIGABAT.Functions.RoamSpectate(pl)
end)

function GIGABAT.Functions.PlayerSpawn(ply)
	ply:RemoveSuit()
	if ply.EnteredGarage then return end
	local ship = ply:GetNWString("Gigabat_Frame")
	local data = GIGABAT.Functions.GetFrame(ship)
	GIGABAT.Functions.SetFrame(ply,ship)
	ply:UnSpectate()
	if IsValid(ply.Ship) then ply.Ship:Remove() end

	local entities = ents.FindByClass("info_player_start")
	local rand = math.random(1,#entities)
	local spawnpos = entities[rand]:GetPos()
	if #entities <= 0 then spawnpos = Vector(0,0,0) end
	local plywaypoint = ply:GetNWInt("Gigabat_Waypoint")
	if plywaypoint > 1 then
		plywaypoint = plywaypoint-1
		for a, b in pairs(ents.FindByClass("gigabat_waypoint")) do
			if b:GetNWInt("Waypoint") == plywaypoint then
				spawnpos = b:GetPos()
			end	
		end
	end
	if IsValid(ply) then
		ply.Ship = ents.Create("gigabat_ship")
		ply.Ship:SetPos(spawnpos)
		ply.Ship:Spawn()
		ply.Ship:SetModel(data.model)
		ply.Ship:Activate()
		ply.Ship:SetOwner(ply)
		GIGABAT.Functions.SetFrame(ply.Ship,ship)
		GIGABAT.Functions.StatInitalize(ply.Ship)
		GIGABAT.Functions.BuildLoadout(ply.Ship)
		GIGABAT.Functions.SendShipSpec(ply,ply.Ship)

		GIGABAT.Functions.Notification("Spawned as "..data.name,Color(35,55,75),ply,false)
		ply:Spawn()
		ply:Spectate(OBS_MODE_CHASE)
		ply:SpectateEntity(ply.Ship)

		if GIGABAT.Round.State == GIGABAT_ROUND_ACTIVE then
			net.Start("GigabatSendRoundTimer")
				net.WriteInt(timer.TimeLeft("GIGABATRoundTimer"),32)
			net.Send(ply)
		end
	end
end

function GIGABAT.Functions.Notification(str,col,ply,global)
	net.Start("GigabatSendNotification")
		net.WriteString(str)
		net.WriteVector(Vector(col.r,col.g,col.b))
	if global then
		net.Broadcast()
	else
		net.Send(ply)
	end
end

function GIGABAT.Functions.ScoreNotification(ply,score)
	net.Start("GigabatSendScoreNotification")
		net.WriteString(score)
	net.Send(ply)
end

function GIGABAT.Functions.AddScore(ply,score)
	if GIGABAT.Round.State != GIGABAT_ROUND_ACTIVE then return end
	if score <= 0 then return end
	ply.gb_ScoreBuild = ply.gb_ScoreBuild + score
	ply:SetNWInt("Gigabat_Score",ply:GetNWInt("Gigabat_Score")+score)
	GIGABAT.Functions.ScoreNotification(ply,score)
	if ply.gb_ScoreBuild >= GIGABAT.Config.ScorePerToken then
		ply.gb_ScoreBuild = 0
		ply:SetNWInt("Gigabat_Tokens",ply:GetNWInt("Gigabat_Tokens")+1)		
		GIGABAT.Functions.SavePlayerData(ply)
		GIGABAT.Functions.Notification("You've earned a token! Congratulations!",Color(85,75,35),ply,false)	
	end
end

function GIGABAT.Functions.SendTransition(ply,mode)
	net.Start("GigabatSendTransition")
		net.WriteBool(mode)
	net.Send(ply)
end

function GIGABAT.Functions.SendStarmap(ply)
	net.Start("GigabatSendStarmap") net.Send(ply)
end