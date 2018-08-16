AddCSLuaFile("shared.lua")
include("shared.lua")
resource.AddWorkshop("1447357771") -- GIGABAT Gamemode on the Workshop ( for Content )

function GM:Initialize()
	perf = {} perf.MaxVelocity = 5000 physenv.SetPerformanceSettings(perf)	
	timer.Simple(1,function()
		GIGABAT.Functions.SetupEnvironment()
		GIGABAT.Functions.LoadNextGameInfo()
		GIGABAT.Functions.RoundInit()
	end)
end

function GM:PlayerInitialSpawn(ply) 
	ply:RemoveSuit()
	ply:SetNWInt("Gigabat_Score",0)
	ply:SetNWInt("Gigabat_Tokens",0)
	ply:SetNWInt("Gigabat_Waypoint",1)
	ply:SetNWBool("Gigabat_Spectating",true)
	ply:SetNWString("Gigabat_Frame",GIGABAT.Config.DefaultShip)
	ply:SetNWString("Gigabat_Skin",GIGABAT.Config.DefaultSkin)
	ply.gb_OwnedShips = {GIGABAT.Config.DefaultShip}
	ply.gb_OwnedSkins = {GIGABAT.Config.DefaultSkin}
	ply.gb_Ready = false
	ply.gb_Target = nil
	ply.gb_Loaded = false
	ply.gb_ScoreBuild = 0
	ply.gb_RTVd = false
	ply.NextSpawn = 0
	ply.EnteredGarage = true
	ply.gb_Stats = {
		shotsfired 		= 0,
		kills 			= 0,
		asteroids 		= 0,
		deaths 			= 0
	}
	ply:SetTeam(1)
	timer.Simple(1,function() 
		if IsValid(ply) then 
			GIGABAT.Functions.PlayerDataSync(ply) 
			GIGABAT.Functions.PlayerGameSync(ply) 
		end 
	end)
	local scenario = GIGABAT.Scenario[GIGABAT.Config.Scenario].name
	local gametype = GIGABAT.Gametypes[GIGABAT.Config.GameType].name
	GIGABAT.Functions.LoadPlayerData(ply)
	ply:Spectate(OBS_MODE_ROAMING)
end

function GM:PlayerDeathThink(ply)
	if ply.EnteredGarage then return end
	if !ply.NextSpawn then ply.NextSpawn = 1 end
    if (CurTime()>=ply.NextSpawn) then
        GIGABAT.Functions.PlayerSpawn(ply)
		ply.NextSpawn = math.huge
    end
end

function GM:PlayerSpawn(ply) ply:Spectate(OBS_MODE_ROAMING) end
function GM:PlayerDisconnected(ply)
	GIGABAT.Functions.SavePlayerData(ply)
	if IsValid(ply.Ship) then ply.Ship:Remove() end
end

function GM:PlayerDeath(victim,inflictor,attacker)
	if IsValid(victim.Ship) then
		if IsValid(victim.Ship.LastAttacker) then
			if victim.Ship.LastAttacker:IsPlayer() then attacker = victim.Ship.LastAttacker end
		end
	end
end
function GM:DoPlayerDeath(ply,att,dmg)
	ply.NextSpawn = CurTime()+GIGABAT.Config.RespawnDuration
	net.Start("GigabatSendDeath")
		net.WriteInt(GIGABAT.Config.RespawnDuration,32)
	net.Send(ply)
	if IsValid(ply.Ship) then
		local lastattacker = ply.Ship.LastAttacker
		if IsValid(lastattacker) then
			if lastattacker:IsPlayer() then
				att = lastattacker
				if att != ply then
					if !GIGABAT.Config.Round.TeamBased then
						GIGABAT.Functions.Notification(att:Name().." killed "..ply:Name().."!",Color(65,35,35),nil,true)	
						att:AddFrags(1)
						GIGABAT.Functions.AddScore(att,GIGABAT.Config.Round.ScoreFromKills)
						att.gb_Stats.kills = att.gb_Stats.kills + 1
					else
						if att:Team() != ply:Team() then
							GIGABAT.Functions.Notification(att:Name().." killed "..ply:Name().."!",Color(65,35,35),nil,true)	
							att:AddFrags(1)
							GIGABAT.Functions.AddScore(att,GIGABAT.Config.Round.ScoreFromKills)
							att.gb_Stats.kills = att.gb_Stats.kills + 1
						else
							GIGABAT.Functions.Notification(att:Name().." betrayed "..ply:Name().."!",Color(65,35,35),nil,true)	
							att:AddFrags(-1)
							GIGABAT.Functions.AddScore(att,-GIGABAT.Config.Round.ScoreFromKills)
							att.gb_Stats.kills = att.gb_Stats.kills - 1
						end
					end
				end
			end
			if lastattacker:GetClass() == "gigabat_asteroid" then
				GIGABAT.Functions.Notification(ply:Name().." was killed by an asteroid!",Color(65,35,35),nil,true)
			end
			if lastattacker == ply then
				GIGABAT.Functions.Notification(ply:Name().." self-destructed!",Color(65,35,35),nil,true)
			end
			net.Start("GigabatSendKiller")
				net.WriteEntity(lastattacker)
				net.WriteString(ply.Ship.LastAttackerWeapon)
			net.Send(ply)
		else
			GIGABAT.Functions.Notification(ply:Name().." died!",Color(65,35,35),nil,true)
			net.Start("GigabatSendKiller")
				net.WriteEntity(nil)
				net.WriteString("")
			net.Send(ply)
		end
		ply.Ship:Explode()
	end
	ply:AddDeaths(1)
	ply.gb_Stats.deaths = ply.gb_Stats.deaths + 1
	GIGABAT.Functions.ClearTarget(ply)
	GIGABAT.Functions.SendShipSpec(ply,nil)
end

function GM:ShowHelp(ply) 
	if GIGABAT.Round.State == GIGABAT_ROUND_CHANGING then 
		GIGABAT.Functions.SendStarmap(ply)
		return 
	end
	GIGABAT.Functions.PlayerDataSync(ply)
	net.Start("GigabatSendMenu")
	net.Send(ply)
end

concommand.Add("gigabat_settokens",function(ply,cmd,args)
	if ply:IsSuperAdmin() then
		local target = tostring(args[1])
		local tokens = tonumber(args[2])
	
		for a, b in pairs(player.GetAll()) do
			if tostring(b:SteamID()) == target then
				b:SetNWInt("Gigabat_Tokens",tokens)
				GIGABAT.Functions.SavePlayerData(b)
			end
		end
	end
end)