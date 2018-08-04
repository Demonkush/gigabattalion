GIGABAT.Functions.AddScenario("derelict2",
	"Derelict C81D",
	{x=215,y=215},
	function()
		GIGABAT.Functions.ModifyEnvironment(
			{
				topcolor = Vector(0.01,0,0.015),
				bottomcolor = Vector(0.07,0,0.07),
				suncolor = Vector(0,0.1,0.2),
				sunsize = 2,
				duskcolor = Vector(0.1,0.2,0.3),
				duskscale = 0.44,
				duskintensity = 0.76
			},
			{
				sunsize = 20,
				suncolor = Vector(1,1,1),
				overlaysize = 20,
				overlaycolor = Vector(1,1,1),
				angles = Angle(0,-50,-44)
			},
			{
				fogstart = 1,
				fogend = 15000,
				density = 0.70,
				color = Vector(0.35,0.15,0.55)
			}
		)

		-- Powerups
		local spawns = {
			Vector(-8272, -8038, 2633),
			Vector(7858, -8822, -5753),
			Vector(-176, 9050, -1582),
			Vector(505, -1354, -1325),
		}
		timer.Create("GigabatPowerupSpawner",30,0,function()
			local rand = math.random(1,#spawns)
			for a, b in pairs(ents.FindInSphere(spawns[rand],64)) do
				if b:GetClass() == "gigabat_powerup" then
					b:Remove()
				end
			end
			local powerup = ents.Create("gigabat_powerup")
			powerup:SetPos(spawns[rand])
			powerup:Spawn()
			powerup:SetNWInt("Powerup","powerup_overdrive")
		end)

		-- Waypoints
		local raw = {
			{num=1.0,pos=Vector(529, -2933, -1598)},
			{num=2.0,pos=Vector(527, 2278, -1573)},
			{num=3.0,pos=Vector(76, 5340, -1709)},
			{num=4.0,pos=Vector(-2588, 8214, -1712)},
			{num=5.0,pos=Vector(-5318, 3567, -558)},
			{num=6.0,pos=Vector(-6612, -1461, 2266)},
			{num=7.0,pos=Vector(-7245, -5360, 2792)},
			{num=8.0,pos=Vector(-5120, -8231, 2632)},
			{num=9.0,pos=Vector(-1272, -7646, 842)},
			{num=10.0,pos=Vector(484, -3268, -1446)},
			{num=11.0,pos=Vector(473, 2061, -1495)},
			{num=12.0,pos=Vector(43, 5210, -1649)},
			{num=13.0,pos=Vector(2132, 8133, -1702)},
			{num=14.0,pos=Vector(6002, 4968, -2643)},
			{num=15.0,pos=Vector(6991, -1512, -4354)},
			{num=16.0,pos=Vector(6828, -5779, -5894)},
			{num=17.0,pos=Vector(4326, -8900, -6254)},
			{num=18.0,pos=Vector(1375, -6946, -3708)},
			{num=19.0,pos=Vector(702, -4500, -1967)}
		}
		GIGABAT.Waypoints = table.Copy(raw)

		local station = ents.Create("gigabat_station")
		station:SetPos(Vector(8845, 6331, 5110))
		station:Spawn()

		local structure = ents.Create("gigabat_worldobject")
		structure:SetModel("models/gigabattalion/structure003.mdl")
		structure:SetPos(Vector(517, -343, -1503))
		structure:SetAngles(Angle(0,0,0))
		structure:Spawn()	

		local structure = ents.Create("gigabat_worldobject")
		structure:SetModel("models/gigabattalion/structure001.mdl")
		structure:SetPos(Vector(-24, 8146, -1703))
		structure:SetAngles(Angle(0,0,0))
		structure:Spawn()	

		local structure = ents.Create("gigabat_worldobject")
		structure:SetModel("models/gigabattalion/structure001.mdl")
		structure:SetPos(Vector(-7367, -8139, 2706))
		structure:SetAngles(Angle(0,0,0))
		structure:Spawn()	

		local structure = ents.Create("gigabat_worldobject")
		structure:SetModel("models/gigabattalion/structure001.mdl")
		structure:SetPos(Vector(6743, -8828, -6158))
		structure:SetAngles(Angle(0,0,0))
		structure:Spawn()	

		for i=1,10 do
			local rando = math.random(4096,8046)
			local randir = AngleRand():Forward()*rando
			local structure = ents.Create("gigabat_debris")
			structure:SetModel("models/gigabattalion/junk001.mdl")
			structure:SetPos(randir)
			structure:SetAngles(AngleRand())
			structure:Spawn()
			structure.Destructible = true
		end
		for i=1,15 do
			local rando = math.random(4096,8046)
			local randir = AngleRand():Forward()*rando
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
	end)