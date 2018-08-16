GIGABAT.Functions.AddScenario("phaseway",
	"Gamma Phaseway",
	{x=300,y=380},
	function()
		GIGABAT.Functions.ModifyEnvironment(
			{
				topcolor = Vector(0,0,0),
				bottomcolor = Vector(0.4,0.7,0.17),
				suncolor = Vector(0.1,0.2,0),
				sunsize = 2,
				duskcolor = Vector(0.1,0.3,0.4),
				duskscale = 0.54,
				duskintensity = 0.46
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
				density = 0.39,
				color = Vector(0.3,0.7,0.17)
			}
		)

		-- Spawnpoints
		for k, v in pairs(ents.FindByClass("info_player_start")) do
			v:Remove()
		end
		for i=1,32 do
			local pos = Vector(288, 11, 12729)
			local a = pos+AngleRand():Forward()*math.Rand(16,128)
			local spawn = ents.Create("info_player_start")
			spawn:SetPos(a)
			spawn:SetAngles(Vector(0,0,-1):Angle())
			spawn:Spawn()
		end

		-- Powerups
		local spawns = {
			Vector( 171, -57, -8771 ),
			Vector( 10769, 8320, -1843 ),
			Vector( -10111, 2764, -1839 ),
			Vector( 703, -10911, -2473 ),
			Vector( 118, -153, 12964 ),
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
			{num=1.0,pos=Vector(328, -594, 12220)},
			{num=2.0,pos=Vector(611, -3915, 9380)},
			{num=3.0,pos=Vector(1037, -7273, 5586)},
			{num=4.0,pos=Vector(711, -10140, -255)},
			{num=5.0,pos=Vector(596, -9643, -3757)},
			{num=6.0,pos=Vector(654, -5845, -7407)},
			{num=7.0,pos=Vector(55, -343, -8832)},
			{num=8.0,pos=Vector(-3252, 746, -8242)},
			{num=9.0,pos=Vector(-6103, 1417, -6199)},
			{num=10.0,pos=Vector(-9585, 2290, -2597)},
			{num=11.0,pos=Vector(-8842, 2492, 1075)},
			{num=12.0,pos=Vector(-7879, 2212, 4782)},
			{num=13.0,pos=Vector(-5492, 1573, 7812)},
			{num=14.0,pos=Vector(-612, 138, 12033)},
			{num=15.0,pos=Vector(2042, 1414, 10809)},
			{num=16.0,pos=Vector(5338, 4065, 8205)},
			{num=17.0,pos=Vector(8475, 6244, 5334)},
			{num=18.0,pos=Vector(10167, 7777, 589)},
			{num=19.0,pos=Vector(9518, 7332, -3688)},
			{num=20.0,pos=Vector(7121, 5223, -6565)},
			{num=21.0,pos=Vector(41, -217, -8936)},
			{num=22.0,pos=Vector(315, -301, -167)},
			{num=23.0,pos=Vector(566, -625, 4918)}
		}
		GIGABAT.Waypoints = table.Copy(raw)

		-- Objects
		local station = ents.Create("gigabat_station")
		station:SetPos(Vector(397, -263, 2323))
		station:Spawn()

		local structures = {}
		structures[1] = {model="models/gigabattalion/structure004.mdl",pos=Vector(814, -9367, 1469),ang=Angle(21, 63, -7)}
		structures[2] = {model="models/gigabattalion/structure004.mdl",pos=Vector(5216, 4002, 8143),ang=Angle(46, -94, 38)}
		structures[3] = {model="models/gigabattalion/structure004.mdl",pos=Vector(-8585, 2334, 2187),ang=Angle(9, 38, 12)}
		structures[4] = {model="models/gigabattalion/structure004.mdl",pos=Vector(-4996, 1389, 8230),ang=Angle(-46, 159, 4)}
		structures[5] = {model="models/gigabattalion/structure004.mdl",pos=Vector(775, -5281, 7901),ang=Angle(-40, -59, -15)}
		structures[6] = {model="models/gigabattalion/structure004.mdl",pos=Vector(-7459, 1737, -4847),ang=Angle(-45, -14, -0)}
		structures[7] = {model="models/gigabattalion/structure004.mdl",pos=Vector(9559, 7169, 2433),ang=Angle(-3, -38, 22)}
		structures[8] = {model="models/gigabattalion/structure004.mdl",pos=Vector(8099, 6125, -5251),ang=Angle(-3, -52, -47)}
		structures[9] = {model="models/gigabattalion/structure004.mdl",pos=Vector(658, -7892, -5299),ang=Angle(-10, 11, -136)}
		structures[10] = {model="models/gigabattalion/structure001.mdl",pos=Vector(164, -91, 12525),ang=Angle(36, -80, 43)}
		structures[11] = {model="models/gigabattalion/structure001.mdl",pos=Vector(545, 62, -8836),ang=Angle(-0, -95, 0)}

		for a, b in pairs(structures) do
			local structure = ents.Create("gigabat_worldobject")
			structure:SetModel(b.model)
			structure:SetPos(b.pos)
			structure:SetAngles(b.ang)
			structure:Spawn()
		end

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
		for i=1,5 do
			local rando = math.random(2048,8046)
			local randir = AngleRand():Forward()*rando
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