GIGABAT.Functions.AddScenario("derelict",
	"Derelict N19B",
	{x=100,y=45},
	function()
		GIGABAT.Functions.ModifyEnvironment(
			{
				topcolor = Vector(0,0,0),
				bottomcolor = Vector(0,0.27,0.27),
				suncolor = Vector(0.2,0.1,0),
				sunsize = 2,
				duskcolor = Vector(1,0.65,0.13),
				duskscale = 0.74,
				duskintensity = 0.56
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
				color = Vector(0.95,0.91,0.69)
			}
		)

		local station = ents.Create("gigabat_station")
		station:SetPos(Vector(0,0,0))
		station:Spawn()

		local positions = {Vector(8000,4000,0),Vector(-4000,-8000,-4000)}
		for a,b in pairs(positions) do
			local structure = ents.Create("gigabat_debris")
			structure:SetModel("models/gigabattalion/structure001.mdl")
			structure:SetPos(b)
			structure:SetAngles(AngleRand())
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
	end)