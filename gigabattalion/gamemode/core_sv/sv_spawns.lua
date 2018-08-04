function GIGABAT.Functions.CreateSpawns()
	for k, v in pairs(ents.FindByClass("info_player_start")) do
		v:Remove()
	end
	for i=1,32 do
		local a = AngleRand():Forward()*math.Rand(1024,2048)
		local spawn = ents.Create("info_player_start")
		spawn:SetPos(a)
		spawn:Spawn()
	end
end

--[[-------------------------------------------------------------------------
Placers
---------------------------------------------------------------------------]]
GIGABAT.Placement = {}
function GIGABAT.Functions.PlaceObject(ship,ent)
	local pos = ship:GetPos()
	table.insert(GIGABAT.Placement,{ent=ent,pos=pos})
end

function GIGABAT.Functions.SpawnObjects()
	for k, v in pairs(GIGABAT.Placement) do v:Remove() end
	for a, b in pairs(GIGABAT.Placement) do
		local object = ents.Create(b.ent)
		object:SetPos(b.pos)
		object:Spawn()
	end
end

function GIGABAT.Functions.SaveObjects()
	local scenario = GIGABAT.Config.Scenario
	local path = "gigabattalion/"..scenario.."_objects.txt"
	local info = util.TableToJSON(GIGABAT.Placement)
	if !file.Exists("gigabattalion","DATA") then file.CreateDir("gigabattalion") end
	file.Write(path,info)
end

function GIGABAT.Functions.LoadObjects()
	local scenario = GIGABAT.Config.Scenario
	local path = "gigabattalion/"..scenario.."_objects.txt"
	if file.Exists(path,"DATA") then
		local load = file.Read(path,"DATA")
		local objects = util.JSONToTable(load)
		GIGABAT.Placement = table.Copy(objects)
	end
end

--[[-------------------------------------------------------------------------
Spawners
---------------------------------------------------------------------------]]
function GIGABAT.Functions.StartAsteroidSpawner()
	if !GIGABAT.Config.Round.SpawnAsteroids then return end
	timer.Create("gigabat_asteroidspawner",30,0,function()
		local asteroid_count = #ents.FindByClass("gigabat_asteroid")
		if asteroid_count < 20 then
			for i=1,3 do
				local randir = AngleRand():Forward()*8046
				local asteroid = ents.Create("gigabat_asteroid")
				asteroid:SetPos(randir)
				asteroid:SetAngles(AngleRand())
				asteroid:SetModel("models/gigabattalion/asteroid_large.mdl")
				asteroid:Spawn()
				asteroid.AsteroidSize = 3
				local phys = asteroid:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(VectorRand()*256)
				end
			end
			local randir = AngleRand():Forward()*8046
			local asteroid = ents.Create("gigabat_asteroid")
			asteroid:SetPos(randir)
			asteroid:SetAngles(AngleRand())
			asteroid:SetModel("models/gigabattalion/asteroid_massive.mdl")
			asteroid:Spawn()
			asteroid.HP = 1000
			asteroid.AsteroidSize = 4
			local phys = asteroid:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity(VectorRand()*256)
			end
		end
	end)
end

function GIGABAT.Functions.StartAttackAsteroidSpawner()
	if !GIGABAT.Config.Round.SpawnAttackAsteroids then return end
	timer.Create("gigabat_attackasteroidspawner",30,0,function()
		local asteroid_count = #ents.FindByClass("gigabat_asteroid_attack")
		if asteroid_count < 2 then
			for i=1,2 do
				local randir = AngleRand():Forward()*8046
				local asteroid = ents.Create("gigabat_asteroid_attack")
				asteroid:SetPos(randir)
				asteroid:SetAngles(AngleRand())
				asteroid:Spawn()
				local phys = asteroid:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(VectorRand()*256)
				end
			end
		end
	end)
end

function GIGABAT.Functions.StartStarSpawner()
	if !GIGABAT.Config.Round.SpawnStars then return end
	timer.Create("gigabat_starspawner",7,0,function()
		local star_count = #ents.FindByClass("gigabat_star")
		if star_count < 3 then
			for i=1,2 do
				local randir = AngleRand():Forward()*8046
				local star = ents.Create("gigabat_star")
				star:SetPos(randir)
				star:SetAngles(AngleRand())
				star:Spawn()
				local phys = star:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocity(VectorRand()*64)
				end
			end
		end
	end)
end