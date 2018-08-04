if SERVER then AddCSLuaFile() end
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Darkmatter Rocket"

if SERVER then
	function ENT:Initialize()
		self.Entity:SetModel("models/weapons/W_missile_launch.mdl")
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

		timer.Simple(2,function()
			if IsValid(self) then
				self:Explode()
			end
		end)

		self.Exploding = false
	end

	function ENT:Think()
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(phys:GetVelocity()*5)
		end
		if self.Exploding then
			local fx = EffectData() fx:SetOrigin(self:GetPos()) fx:SetScale(3)
			fx:SetAngles(Angle(215,155,255))
			util.Effect("gbfx_3d_ring",fx)
			self:DealDamage()
		end
		return false
	end
	function ENT:DealDamage()
		local att = self
		if IsValid(self.Owner) then
			att = self.Owner
		end
		for _, v in ipairs(ents.FindInSphere( self:GetPos(), 512 )) do
			if v != self then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker( att )
				dmginfo:SetInflictor( self )
				dmginfo:SetDamage( math.random(8,15) )
				v:TakeDamageInfo( dmginfo )

				local phys = v:GetPhysicsObject()
				if IsValid(phys) then
					local force = phys:GetMass()/2048
					phys:SetVelocity((self:GetPos()-phys:GetPos())/force)
				end
			end
		end
	end

	function ENT:PhysicsCollide(data, physobj)
		self.Entity:Explode()
	end

	function ENT:Explode()
		if self.Exploding then return end
		self.Exploding = true

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
			phys:EnableCollisions(false)
		end

		self:EmitSound("ambient/explosions/explode_3.wav",90,50)
		local fx = EffectData() fx:SetOrigin(self:GetPos()) 
		util.Effect("gbfx_explode_rocket",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(2)
		fx2:SetAngles(Angle(215,155,255))
		util.Effect("gbfx_3d_blast",fx2)
		for i=1,2 do
			local fx3 = EffectData() fx3:SetOrigin(self:GetPos()) fx3:SetScale(2)
			fx3:SetAngles(Angle(215,155,255))
			util.Effect("gbfx_3d_ring",fx3)
		end

		local att = self
		if IsValid(self.Owner) then
			att = self.Owner
		end
		for _, v in ipairs(ents.FindInSphere( self:GetPos(), 256 )) do
			if v != self then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker( att )
				dmginfo:SetInflictor( self )
				dmginfo:SetDamage( math.random(45,65) )
				v:TakeDamageInfo( dmginfo )
			end
		end

		timer.Simple(3,function() if IsValid(self) then self:Remove() end end)
	end
end

if CLIENT then
	function ENT:Initialize()
		self:DrawShadow(false)
		self.Emitter = ParticleEmitter(self:GetPos())
		self.Emitter:SetNearClip(24, 48)

		self:SetRenderBounds(Vector(-256, -256, -256), Vector(256, 256, 256))
		self.NextEmit = 0
	end

	local glow = Material("sprites/glow04_noz")
	function ENT:Draw()
		local thrustrand = math.random(128,400)
		render.SetMaterial(glow)
		render.DrawSprite(self:GetPos(),thrustrand,thrustrand,Color(215,155,255,255))

		if RealTime() > self.NextEmit then
			local emitter = self.Emitter
			emitter:SetPos(self:GetPos())

			local ang = AngleRand():Forward()*math.random(128,256)
			local pos = self:GetPos()+ang
			local particle = emitter:Add("sprites/glow04_noz", pos )
			particle:SetVelocity( (pos-self:GetPos())*-8 )
			particle:SetDieTime(0.2)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(25,128))
			particle:SetEndSize(15)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetGravity(Vector(0,0,0))
			particle:SetAirResistance(155)
			particle:SetColor( 215, 155, 255 )
			self.NextEmit = RealTime() + 0.01
		end
	end
end