GIGABAT.Functions.AddScenario("startrack",
	"Startrack Altari",
	{x=200,y=280},
	function()
		GIGABAT.Functions.ModifyEnvironment(
			{
				topcolor = Vector(0,0,0),
				bottomcolor = Vector(0.7,0.3,0.17),
				suncolor = Vector(0.2,0.1,0),
				sunsize = 2,
				duskcolor = Vector(0.3,0.1,0.4),
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
				color = Vector(0.7,0.3,0.17)
			}
		)

		-- Spawnpoints
		for k, v in pairs(ents.FindByClass("info_player_start")) do
			v:Remove()
		end
		for i=1,32 do
			local a = AngleRand():Forward()*math.Rand(16,128)
			local spawn = ents.Create("info_player_start")
			spawn:SetPos(a)
			spawn:SetAngles(Vector(0,0,1):Angle())
			spawn:Spawn()
		end

		-- Powerups
		local spawns = {
			Vector( -332, -200, 1288 ),
			Vector( 292, -425, 8422 ),
			Vector( 7100, 167, 4577 ),
			Vector( 2007, 579, -9171 ),
			Vector( -6823, 622, -5119 ),
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
			{num=1.0,pos=Vector(-46, 276, -168)},
			{num=2.0,pos=Vector(46, 291, 3348)},
			{num=3.0,pos=Vector(-180, -552, 7096)},
			{num=4.0,pos=Vector(2198, -409, 9639)},
			{num=5.0,pos=Vector(5643, -300, 8574)},
			{num=6.0,pos=Vector(7213, -6, 3163)},
			{num=7.0,pos=Vector(6027, 419, -3999)},
			{num=8.0,pos=Vector(3288, 711, -8908)},
			{num=9.0,pos=Vector(-1625, 657, -9029)},
			{num=10.0,pos=Vector(-5150, 174, -8604)},
			{num=11.0,pos=Vector(-6640, 275, -4246)},
			{num=12.0,pos=Vector(-6617, 405, 3207)},
			{num=13.0,pos=Vector(-2743, -343, 9511)},
			{num=14.0,pos=Vector(1816, -456, 9656)},
			{num=15.0,pos=Vector(4819, -432, 8633)},
			{num=16.0,pos=Vector(7100, -68, 4192)},
			{num=17.0,pos=Vector(6373, 513, -4633)},
			{num=18.0,pos=Vector(3191, 675, -8910)},
			{num=19.0,pos=Vector(548, 704, -7774)},
			{num=20.0,pos=Vector(173, 409, -2983)}
		}
		GIGABAT.Waypoints = table.Copy(raw)

		-- Objects
		local station = ents.Create("gigabat_station")
		station:SetPos(Vector(3543, 6780, -271))
		station:Spawn()

		local structure = ents.Create("gigabat_worldobject")
		structure:SetModel("models/gigabattalion/structure_startrackaltari.mdl")
		structure:SetPos(Vector(-6532, 314, -4083))
		structure:SetAngles(Angle(0,0,0))
		structure:Spawn()

		local structure = ents.Create("gigabat_worldobject")
		structure:SetModel("models/gigabattalion/structure_startrackaltari.mdl")
		structure:SetPos(Vector(151, 282, -236))
		structure:SetAngles(Angle(0,0,0))
		structure:Spawn()

		local structure = ents.Create("gigabat_worldobject")
		structure:SetModel("models/gigabattalion/structure_startrackaltari.mdl")
		structure:SetPos(Vector(7163, 6, 3058))
		structure:SetAngles(Angle(0,0,0))
		structure:Spawn()		

		local structure = ents.Create("gigabat_worldobject")
		structure:SetModel("models/gigabattalion/structure001.mdl")
		structure:SetPos(Vector(645, 661, -8854))
		structure:SetAngles(Angle(0,0,0))
		structure:Spawn()		

		local structure = ents.Create("gigabat_worldobject")
		structure:SetModel("models/gigabattalion/structure001.mdl")
		structure:SetPos(Vector(-263, -412, 9560))
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