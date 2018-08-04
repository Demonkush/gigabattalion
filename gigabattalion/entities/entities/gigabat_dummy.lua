if SERVER then AddCSLuaFile() end
ENT.Type = "anim"

if SERVER then
	function ENT:Initialize()   
		self:SetModel("models/gigabattalion/asteroid.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:DrawShadow(false)

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(500)
			phys:EnableGravity(false)
			phys:Wake()
		end

		self:SetNWInt("Armor",100)

		self.Exploded = false
	end

	function ENT:Think()
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:AddVelocity(self:GetAngles():Forward()*15)
		end
	end

	function ENT:OnTakeDamage(dmg)
		self:SetNWInt("Armor",self:GetNWInt("Armor") - dmg:GetDamage())
		if self:GetNWInt("Armor") <= 0 then 
			self:Explode()
		end
	end

	function ENT:Explode()
		if self.Exploded == true then return end
		self.Exploded = true
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(1.5)
		fx2:SetAngles(Angle(255,155,55))
		util.Effect("gbfx_3d_blast",fx2)

		timer.Simple(0.3,function()
			if IsValid(self) then
				self:Remove()
				if IsValid(self:GetOwner()) then
					self:GetOwner():Kill()
				end
			end
		end)
	end
end

if CLIENT then
	function ENT:Initialize()   
		if IsValid(self.Body) then
			self.Body:Remove()
			self.Body = nil
		end

		self.Body = ClientsideModel("models/gigabattalion/body.mdl",RENDERGROUP_TRANSLUCENT)
		self.Body:SetPos(self:GetPos())
		self.Body:SetMaterial("gigabattalion/basemetal")
	end

	function ENT:Think()
		if IsValid(self.Body) then
			self.Body:SetPos(self:GetPos())
			if IsValid(self:GetOwner()) then
				self.Body:SetAngles(LerpAngle(FrameTime()*2,self.Body:GetAngles(),self:GetOwner():EyeAngles()+Angle(180,0,180)))
			end
		end
	end

	function ENT:OnRemove()
		if IsValid(self.Body) then
			self.Body:Remove()
			self.Body = nil
		end		
	end

	function ENT:Draw()

	end
end