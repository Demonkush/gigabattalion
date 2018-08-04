GIGABAT.Functions.AddScenario("metalith",
	"Metalith",
	{x=40,y=95},
	function()
		GIGABAT.Functions.ModifyEnvironment(
			{
				topcolor = Vector(0,0,0),
				bottomcolor = Vector(0.07,0.05,0.09),
				suncolor = Vector(0,0,0),
				sunsize = 2,
				duskcolor = Vector(0.34,0.62,0.67),
				duskscale = 0.74,
				duskintensity = 0.56
			},
			{
				sunsize = 35,
				suncolor = Vector(0.16,0.25,0.36),
				overlaysize = 20,
				overlaycolor = Vector(0.72,0.44,1),
				angles = Angle(0,-138,-44)
			},
			{
				fogstart = 1,
				fogend = 15000,
				density = 0.5,
				color = Vector(0.69,0.74,0.95)
			}
		)

		local station = ents.Create("gigabat_worldobject")
		station:SetModel("models/gigabattalion/structure002.mdl")
		station:SetPos(Vector(0,0,0))
		station:Spawn()

		for i=1,3 do
			local rando = math.random(6096,8046)
			local randir = AngleRand():Forward()*rando
			local asteroidatk = ents.Create("gigabat_asteroid_attack")
			asteroidatk:SetPos(randir)
			asteroidatk:SetAngles(AngleRand())
			asteroidatk:Spawn()
		end
		for i=1,5 do
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