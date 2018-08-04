ENT.Type = "anim"

if SERVER then 
	AddCSLuaFile() 

	function ENT:Initialize()
		self.Entity:SetModel("models/gigabattalion/asteroid_special01.mdl")
		self.Entity:SetColor(Color(255,255,255,255))
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)	
		self.Entity:SetSolid(SOLID_VPHYSICS)

		self:SetCollisionGroup(COLLISION_GROUP_NONE)

		local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableGravity(false)
			phys:Wake()
		end

		self.HP = 1000
		self.Exploded = false
		self.LastAttacker = nil
		self.NextHealthPoke = 0

		self.Turrets = {}

		self:CreateTurret(Vector(0,0,400),Angle(0,0,0))
		self:CreateTurret(Vector(0,0,-400),Angle(0,180,0))
	end

	function ENT:CreateTurret(pos,ang)
		local turretbase = ents.Create("gigabat_asteroid_attack_turret")
		turretbase:SetPos(self:GetPos()+pos)
		turretbase:SetAngles(ang)
		turretbase.Angles = ang
		turretbase.Offset = pos
		turretbase:Spawn()
		constraint.NoCollide(self,turretbase,0,0)
		turretbase:SetNWEntity("BaseEntity",self)
		table.insert(self.Turrets,turretbase)
	end

	function ENT:FixTurrets()
		for a, b in pairs(self.Turrets) do
			if IsValid(b) then
				local pos = self:GetPos()+(self:GetUp()*b.Offset.z)
				b:SetPos(pos)
				b:SetAngles(self:GetAngles()+b.Angles)
			end
		end
	end

	function ENT:Think()
		self:FixTurrets()
	end

	function ENT:OnRemove()
		for k, v in pairs(self.Turrets) do
			if IsValid(v) then
				v:Remove()
			end
		end
		table.Empty(self.Turrets)
	end

	function ENT:PhysicsCollide(data, physobj)

	end

	function ENT:SVHealthPoke()
		if self.NextHealthPoke > CurTime() then return end
		if self.Exploded == true then return end
		self:EmitSound("physics/concrete/boulder_impact_hard3.wav",90,155)
		net.Start("Asteroid_HealthPoke")
			net.WriteEntity(self)
		net.Broadcast()
		self.NextHealthPoke = CurTime()+0.2
	end

	function ENT:OnTakeDamage(dmg)
		if IsValid(self) then
			self.LastAttacker = dmg:GetAttacker()
			self.HP = self.HP - dmg:GetDamage()
			self:SVHealthPoke()
			if self.HP <= 0 then 
				self:Explode()
			end
		end
	end

	function ENT:SpawnClusters()
		for i=1,2 do
			local asteroid = ents.Create("gigabat_asteroid")
			asteroid:SetPos(self:GetPos()+(VectorRand()*(512)))
			asteroid:SetAngles(AngleRand())
			asteroid:SetModel("models/gigabattalion/asteroid_medium.mdl")
			asteroid:Spawn()		
			asteroid.AsteroidSize = 2
			local phys = asteroid:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity(VectorRand()*256)
			end
		end
	end

	function ENT:Explode()
		if self.Exploded == true then return end
		self.Exploded = true
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(3)
		util.Effect("gbfx_explode_asteroid",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(3)
		fx2:SetAngles(Angle(255,235,215))
		util.Effect("gbfx_3d_blast",fx2)
		for i=1,3 do
			local fx3 = EffectData() fx3:SetOrigin(self:GetPos()) fx3:SetScale(3)
			fx3:SetAngles(Angle(255,235,215))
			util.Effect("gbfx_3d_ring",fx3)
		end

		self:EmitSound("ambient/explosions/explode_1.wav",100,80)

		local att = self.LastAttacker
		if IsValid(att) then
			if att:IsPlayer() then
				att.gb_Stats.asteroids = att.gb_Stats.asteroids + 1
				GIGABAT.Functions.AddScore(att,GIGABAT.Config.Round.ScoreFromAsteroids*2)
			end
		end

		self:SpawnClusters()

		if GIGABAT.Config.Round.SpawnPowerups == true then
			local rand = math.random(1,10)
			if rand > 5 then
				GIGABAT.Functions.SpawnPowerup(self:GetPos())
			end
		end

		timer.Simple(0.3,function()
			if IsValid(self) then
				self:Remove()
			end
		end)
	end
end

if CLIENT then
	function ENT:Initialize()
		self.HealthPokeScale = 0
	end
	function ENT:CLHealthPoke()
		if IsValid(self.HealthPokeObj) then
			self.HealthPokeObj:Remove()
			self.HealthPokeObj = nil
		end
		self.HealthPokeScale = 0
		self.HealthPokeObj = ClientsideModel(self:GetModel(),RENDERGROUP_TRANSLUCENT)
		self.HealthPokeObj:SetAngles(self:GetAngles())
		self.HealthPokeObj:SetPos(self:GetPos())
		self.HealthPokeObj:SetColor(Color(255,0,0,255))
		self.HealthPokeObj:SetModelScale(self:GetModelScale()+0.01)
	end
	function ENT:Draw()
		self:DrawModel()
		if IsValid(self.HealthPokeObj) then
			local scale = self.HealthPokeScale
			self.HealthPokeObj:SetColor(Color(
				255,
				math.Clamp(scale,0,215),
				math.Clamp(scale,0,155),
				scale
			))
		end
	end
	function ENT:Think()
		if IsValid(self.HealthPokeObj) then
			self.HealthPokeObj:SetAngles(self:GetAngles())
			self.HealthPokeObj:SetPos(self:GetPos())
			if self.HealthPokeScale < 255 then
				local rate = FrameTime()*1024
				self.HealthPokeScale = math.Clamp(self.HealthPokeScale + rate,0,255)
			else
				self.HealthPokeObj:Remove()
				self.HealthPokeObj = nil
			end
		end
	end
	function ENT:OnRemove()
		if IsValid(self.HealthPokeObj) then
			self.HealthPokeObj:Remove()
			self.HealthPokeObj = nil
		end
	end
end