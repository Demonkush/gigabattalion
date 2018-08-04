GIGABAT.Functions.AddScenario("asteroid_field",
	"Orv Cluster",
	{x=125,y=315},
	function()
		GIGABAT.Functions.ModifyEnvironment(
			{
				topcolor = Vector(0.11,0.04,0.02),
				bottomcolor = Vector(0.01,0,0),
				suncolor = Vector(0.60,0.13,0.06),
				sunsize = 0.3,
				duskcolor = Vector(0.50,0.09,0),
				duskscale = 0.74,
				duskintensity = 0.56
			},
			{
				sunsize = 35,
				suncolor = Vector(0.36,0.29,0.16),
				overlaysize = 20,
				overlaycolor = Vector(1,0.63,0.42),
				angles = Angle(0,45,0)
			},
			{
				fogstart = 1,
				fogend = 15000,
				density = 0.72,
				color = Vector(0.54,0.28,0.15)
			}
		)

		local station = ents.Create("gigabat_station")
		station:SetPos(Vector(0,0,0))
		station:Spawn()

		for i=1,15 do
			local rando = math.random(2048,8046)
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

		for i=1,15 do
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