GIGABAT.Functions.AddScenario("deltanis",
	"Alta Deltanis",
	{x=240,y=345},
	function()
		GIGABAT.Functions.ModifyEnvironment(
			{
				topcolor = Vector(.1,0,0),
				bottomcolor = Vector(.2,0,0),
				suncolor = Vector(.1,.1,.1),
				sunsize = 0.5,
				duskcolor = Vector(0.6,0.2,0),
				duskscale = 0.5,
				duskintensity = 0.5
			},
			{
				sunsize = 25,
				suncolor = Vector(0.25,0.05,0.0),
				overlaysize = 20,
				overlaycolor = Vector(1,1,1),
				angles = Angle(0,-138,-44)
			},
			{
				fogstart = 1,
				fogend = 10000,
				density = 0.85,
				color = Vector(0.5,0.0,0.0)
			}
		)

		local station = ents.Create("gigabat_worldobject")
		station:SetModel("models/gigabattalion/structure005.mdl")
		station:SetPos(Vector(0,0,0))
		station:Spawn()

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