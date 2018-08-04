ENT.Type = "anim"

if SERVER then 
	AddCSLuaFile() 

	function ENT:Initialize()
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

		self.Exploded = false
		self.Destructible = false
		self.HP = 100
		self.Size = 2
	end

	function ENT:OnTakeDamage(dmg)
		if self.Destructible == false then return end
		self.HP = self.HP - dmg:GetDamage()
		if self.HP <= 0 then
			self:Explode()
		end
	end

	function ENT:Explode()
		if self.Exploded == true then return end
		self.Exploded = true
		local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(self.Size)
		util.Effect("gbfx_explode_asteroid",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(self.Size)
		fx2:SetAngles(Angle(255,235,215))
		util.Effect("gbfx_3d_blast",fx2)
		for i=1,3 do
			local fx3 = EffectData() fx3:SetOrigin(self:GetPos()) fx3:SetScale(self.Size)
			fx3:SetAngles(Angle(255,235,215))
			util.Effect("gbfx_3d_ring",fx3)
		end

		self:EmitSound("ambient/explosions/explode_1.wav",100,140/(self.Size/2))

		self:Remove()
	end
end