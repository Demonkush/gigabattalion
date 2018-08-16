ENT.Type = "anim"

if SERVER then 
	AddCSLuaFile() 

	function ENT:Initialize()
		self.Entity:SetModel("models/gigabattalion/asteroid_turretbase.mdl")
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

		self.HP = 150
		self.AsteroidSize = 3
		self.Exploded = false
		self.LastAttacker = nil
		self.NextHealthPoke = 0
		self.NextFindTarget = 0
		self.Target = nil
		self:CreateGun()
	end

	function ENT:FixGun()
		local attach = self:LookupAttachment("turret1")
		local att = self:GetAttachment(attach)
		local gun = self.Gun
		if IsValid(gun) then
			local diff = (att.Pos-self:GetPos()):Angle()
			gun:SetPos(self:GetPos()+diff:Forward()*32)
		end
	end

	function ENT:AttackTarget()
		local target = self.Target
		local gun = self.Gun
		if IsValid(gun) then
			gun:SetAngles((gun:GetPos()-target:GetPos()):Angle())
			gun:Shoot()
			gun.NextShoot = CurTime() + 0.01
		end
	end

	function ENT:OnRemove()
		if IsValid(self.Gun) then
			self.Gun:Remove()
		end
	end

	function ENT:FindTargets()
		if IsValid(self.Target) then
			if self.Target.SpawnProtection then self.Target = nil return end
			if self.Target.Powerups.Stealth then self.Target = nil return end
			self:AttackTarget()
			local distance = self:GetPos():DistToSqr(self.Target:GetPos())
			if distance > 80000 then
				self.Target = nil
			end
		else
			for a, b in pairs(ents.FindInSphere(self:GetPos()+(self:GetUp()*512),4096)) do
				if b:GetClass() == "gigabat_ship" then
					if IsValid(b:GetOwner()) then
						if !b.SpawnProtection && !b.Powerups.Stealth then
							self.Target = b
						end
					end
				end
			end
		end
	end

	function ENT:CreateGun()
		local attach = self:LookupAttachment("turret1")
		local att = self:GetAttachment(attach)
		self.Gun = ents.Create("gigabat_asteroid_attack_turret_gun")
		self.Gun:SetPos(att.Pos)
		self.Gun:SetAngles(self:GetUp():Angle())
		self.Gun:SetNWInt("BaseEntity",self)
		self.Gun:Spawn()
	end

	function ENT:Think()
		self:FixGun()
		self:FindTargets()
		return false
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
			self.HP = self.HP - dmg:GetDamage()
			self:SVHealthPoke()
			if self.HP <= 0 then 
				self:Explode()
			end
		end
	end

	function ENT:Explode()
		if self.Exploded == true then return end
		self.Exploded = true
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(2)
		util.Effect("gbfx_explode_asteroid",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(2)
		fx2:SetAngles(Angle(255,235,215))
		util.Effect("gbfx_3d_blast",fx2)
		for i=1,3 do
			local fx3 = EffectData() fx3:SetOrigin(self:GetPos()) fx3:SetScale(2)
			fx3:SetAngles(Angle(255,235,215))
			util.Effect("gbfx_3d_ring",fx3)
		end

		self:EmitSound("ambient/explosions/explode_1.wav",100,80)

		timer.Simple(0.3,function()
			if IsValid(self) then
				self:Remove()
			end
		end)
	end
end

if CLIENT then
	function ENT:RemoveBody()
		if IsValid(self.Body) then self.Body:Remove() end
	end
	function ENT:CreateBody()
		self.Body = ClientsideModel(self:GetModel(),RENDERGROUP_TRANSLUCENT)
		self.Body:SetPos(self:GetPos())
		self.Body:SetModelScale(1.5)
	end
	function ENT:Initialize()
		self:CreateBody()
		self.HealthPokeScale = 0
		self.oldpos = Vector(0,0,0)
	end
	function ENT:CLHealthPoke()
		if !IsValid(self.Body) then return end
		if IsValid(self.HealthPokeObj) then
			self.HealthPokeObj:Remove()
			self.HealthPokeObj = nil
		end
		self.HealthPokeScale = 0
		self.HealthPokeObj = ClientsideModel(self:GetModel(),RENDERGROUP_TRANSLUCENT)
		self.HealthPokeObj:SetAngles(self:GetAngles())
		self.HealthPokeObj:SetPos(self:GetPos())
		self.HealthPokeObj:SetColor(Color(255,0,0,255))
		self.HealthPokeObj:SetModelScale(1.51)
	end
	function ENT:Draw()
		--self:DrawModel()
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
		if IsValid(self.Body) then
			self.oldpos = self.Body:GetPos()
			self.Body:SetPos(LerpVector(FrameTime()*5,self.oldpos,self:GetPos()))
			self.Body:SetAngles(self:GetAngles())
			if IsValid(self.HealthPokeObj) then
				self.HealthPokeObj:SetAngles(self.Body:GetAngles())
				self.HealthPokeObj:SetPos(self.Body:GetPos())
				if self.HealthPokeScale < 255 then
					local rate = FrameTime()*1024
					self.HealthPokeScale = math.Clamp(self.HealthPokeScale + rate,0,255)
				else
					self.HealthPokeObj:Remove()
					self.HealthPokeObj = nil
				end
			end		
		else
			self:CreateBody()
		end
	end
	function ENT:OnRemove()
		if IsValid(self.HealthPokeObj) then
			self.HealthPokeObj:Remove()
			self.HealthPokeObj = nil
		end
		self:RemoveBody()
	end
end