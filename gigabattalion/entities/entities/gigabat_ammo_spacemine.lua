if SERVER then AddCSLuaFile() end
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Mine"

if SERVER then
	function ENT:Initialize()
		self.Entity:SetModel("models/gigabattalion/spacemine.mdl")
		self.Entity:SetColor( Color( 255, 255, 255, 255 ) )
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)	
		self.Entity:SetSolid(SOLID_VPHYSICS)

		self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )

		local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		end

		timer.Simple(7,function()
			if IsValid(self) then
				self:Explode()
			end
		end)

		self.gb_Target = nil
		self.NextTarget = 0
	end

	function ENT:Think() 
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(phys:GetVelocity()*5)
		end
		if IsValid(self.gb_Target) then
			local phys = self:GetPhysicsObject()
			if IsValid(phys) then
				local dir = -(self:GetPos()-self.gb_Target:GetPos())
				phys:AddVelocity(dir/1.1)
			end
			for a, b in pairs(ents.FindInSphere(self:GetPos(),400)) do
				if b:GetClass() == "gigabat_ship" then
					self:Explode()
				end
			end
		else
			if self.NextTarget < CurTime() then
				for a, b in pairs(ents.FindInSphere(self:GetPos(),768)) do
					if b:GetClass() == "gigabat_ship" then
						if b:GetOwner() != self:GetOwner() then
							self.gb_Target = b
						end
					end
				end
				self.NextTarget = CurTime() + 0.5
			end
		end
	end


	function ENT:PhysicsCollide(data, physobj)
		self.Entity:Explode()
	end

	function ENT:Explode()
		if self.Hit then return end
		self.Hit = true

		self:EmitSound("ambient/explosions/explode_3.wav",90,75)
		local fx = EffectData() fx:SetOrigin(self:GetPos()) 
		util.Effect("gbfx_explode_delta",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(5)
		fx2:SetAngles(Angle(255,115,115))
		util.Effect("gbfx_3d_blast",fx2)
		local fx3 = EffectData() fx3:SetOrigin(self:GetPos()) fx3:SetScale(5)
		fx3:SetAngles(Angle(255,115,115))
		util.Effect("gbfx_3d_ring",fx3)

		local att = self
		if IsValid(self.Owner) then
			att = self.Owner
		end
		for _, v in ipairs(ents.FindInSphere( self:GetPos(), 512 )) do
			if v != self then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker( att )
				dmginfo:SetInflictor( self )
				dmginfo:SetDamage( math.random(75,80) )
				v:TakeDamageInfo( dmginfo )
			end
		end

		timer.Simple(0.01,function() if IsValid(self) then self:Remove() end end)
	end
end

if CLIENT then
	function ENT:Initialize()
		self:DrawShadow(false)
		self.Emitter = ParticleEmitter(self:GetPos())
		self.Emitter:SetNearClip(24,48)

		self:SetRenderBounds(Vector(-256,-256,-256), Vector(256,256,256))
		self.NextEmit = 0
	end

	local glow = Material("sprites/glow04_noz")
	function ENT:Draw()
		self:DrawModel()
		if RealTime() > self.NextEmit then
			local emitter = self.Emitter
			emitter:SetPos(self:GetPos())

			local particle = emitter:Add("sprites/glow04_noz", self:GetPos() )
			particle:SetVelocity( VectorRand()*1024 )
			particle:SetDieTime(0.1)
			particle:SetStartAlpha(155)
			particle:SetEndAlpha(0)
			particle:SetStartSize(512)
			particle:SetEndSize(1)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetAirResistance(155)
			particle:SetColor( 255, 115, 115 )
			self.NextEmit = RealTime() + 0.5
		end
	end
end