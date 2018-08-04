--[[-------------------------------------------------------------------------
Save / Load
---------------------------------------------------------------------------]]
function GIGABAT.Functions.SaveAll()
	for k, v in pairs(player.GetAll()) do
		if v.gb_Loaded then GIGABAT.Functions.SavePlayerData(v) end
	end
end

function GIGABAT.Functions.LoadPlayerData(ply)
	local id = tostring(ply:UniqueID())
	local path = "gigabattalion_playerdata/"..id..".txt"
	if file.Exists(path,"DATA") then
		local load = file.Read(path,"DATA")
		local info = util.JSONToTable(load)
		local tab = table.Copy(info)
		ply:SetNWInt("Gigabat_Tokens",tab.tokens)
		ply.gb_OwnedShips 	= table.Copy(tab.ships)
		ply.gb_OwnedSkins 	= table.Copy(tab.skins)
		ply.gb_Stats 		= table.Copy(tab.stats)
	end
	ply.gb_Loaded = true
end

function GIGABAT.Functions.SavePlayerData(ply)
	local id = tostring(ply:UniqueID())
	local path = "gigabattalion_playerdata/"..id..".txt"
	local tab = {}
	tab.tokens = ply:GetNWInt("Gigabat_Tokens")
	tab.ships = ply.gb_OwnedShips
	tab.skins = ply.gb_OwnedSkins
	tab.stats = ply.gb_Stats
	local info = util.TableToJSON(tab)
	if !file.Exists("gigabattalion_playerdata","DATA") then file.CreateDir("gigabattalion_playerdata") end
	file.Write(path,info)
end

function GIGABAT.Functions.LoadNextGameInfo()
	local path = "gigabattalion/gameinfo.txt"
	if file.Exists(path,"DATA") then
		local load = file.Read(path,"DATA")
		local info = util.JSONToTable(load)
		GIGABAT.Config.Scenario = info.scenario
		GIGABAT.Config.GameType = info.gametype
		file.Delete(path)
	end
	timer.Simple(3,function()
		GIGABAT.Scenario[GIGABAT.Config.Scenario].oninit()
		GIGABAT.Gametypes[GIGABAT.Config.GameType].oninit()
		for k, v in pairs(player.GetAll()) do GIGABAT.Functions.PlayerGameSync(v) end
		timer.Simple(2,function()
			GIGABAT.Functions.StartAsteroidSpawner()
			GIGABAT.Functions.StartAttackAsteroidSpawner()
			GIGABAT.Functions.StartStarSpawner()
		end)	
	end)
end