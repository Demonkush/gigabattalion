GIGABAT.Waypoints = {}
function GIGABAT.Functions.PlaceWaypoint(ship)
	local pos = ship:GetPos()
	local num = #GIGABAT.Waypoints + 1

	local waypoints = #ents.FindByClass("gigabat_waypoint")
	local waypoint = ents.Create("gigabat_waypoint")
	waypoint:SetPos(pos)
	waypoint:Spawn()
	waypoint:SetNWInt("Waypoint",num)

	table.insert(GIGABAT.Waypoints,{num=num,pos=pos})

	GIGABAT.Functions.SaveWaypoints()
end

function GIGABAT.Functions.SpawnWaypoints()
	for k, v in pairs(ents.FindByClass("gigabat_waypoint")) do v:Remove() end
	for a, b in pairs(GIGABAT.Waypoints) do
		local waypoint = ents.Create("gigabat_waypoint")
		waypoint:SetPos(b.pos)
		waypoint:Spawn()
		waypoint:SetNWInt("Waypoint",b.num)
	end
end

function GIGABAT.Functions.SaveWaypoints()
	local scenario = GIGABAT.Config.Scenario
	local path = "gigabattalion/"..scenario.."_waypoints.txt"	
	local info = util.TableToJSON(GIGABAT.Waypoints)
	if !file.Exists("gigabattalion","DATA") then file.CreateDir("gigabattalion") end
	file.Write(path,info)
end

function GIGABAT.Functions.LoadWaypoints()
	local scenario = GIGABAT.Config.Scenario
	local path = "gigabattalion/"..scenario.."_waypoints.txt"
	if file.Exists(path,"DATA") then
		local load = file.Read(path,"DATA")
		local waypoints = util.JSONToTable(load)
		GIGABAT.Waypoints = table.Copy(waypoints)
	end
end

function GIGABAT.Functions.SpawnAtWaypoint(ply)
	local ship = ply.Ship
	local waypoint = nil
	local plypoint = ply:GetNWInt("Gigabat_Waypoint")
	plypoint = plypoint-1
	if plypoint <= 0 then
		plypoint = #ents.FindByClass("gigabat_waypoint")
	end
	for a, b in pairs(ents.FindByClass("gigabat_waypoint")) do
		if b:GetNWInt("Waypoint") == plypoint then
			waypoint = b
		end
	end
	if waypoint == nil then return end
	ship:SetPos(waypoint:GetPos())
end

function GIGABAT.Functions.FinishLap(ply)
	ply:SetNWInt("Gigabat_Waypoint",1)
	GIGABAT.Functions.AddScore(ply,15)
	GIGABAT.Functions.Notification("Lap completed!",Color(85,75,35),ply,false)	
	ply.Ship:EmitSound("npc/roller/mine/rmine_predetonate.wav",65)
end

function GIGABAT.Functions.SetNextWaypoint(ply)
	local waypoint = ply:GetNWInt("Gigabat_Waypoint")
	local waypoints = #GIGABAT.Waypoints
	if waypoints <= 1 then return end
	if waypoint+1 > waypoints then
		GIGABAT.Functions.FinishLap(ply)
		waypoint = 0
	end
	ply.Ship:EmitSound("npc/roller/mine/rmine_chirp_quest1.wav",75,75)
	ply:SetNWInt("Gigabat_Waypoint",waypoint+1)
end