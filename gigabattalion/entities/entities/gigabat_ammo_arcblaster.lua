if SERVER then AddCSLuaFile() end
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Rocket"

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
	end

	function ENT:Think() 
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(phys:GetVelocity()*5)
		end
	end


	function ENT:PhysicsCollide(data, physobj)
		self.Entity:Explode()
	end

	function ENT:Explode()
		if self.Hit then return end
		self.Hit = true

		self:EmitSound("ambient/explosions/explode_3.wav",90,145)
		local fx = EffectData() fx:SetOrigin(self:GetPos()) 
		util.Effect("gbfx_explode_arc",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(2)
		fx2:SetAngles(Angle(115,215,255))
		util.Effect("gbfx_3d_blast",fx2)

		local att = self
		if IsValid(self.Owner) then
			att = self.Owner
		end
		for _, v in ipairs(ents.FindInSphere( self:GetPos(), 200 )) do
			if v != self then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker( att )
				dmginfo:SetInflictor( self )
				dmginfo:SetDamage( math.random(30,35) )
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
		if RealTime() > self.NextEmit then
			local emitter = self.Emitter
			emitter:SetPos(self:GetPos())

			local thrustrand = math.random(256,512)
			render.SetMaterial(glow)
			render.DrawSprite(self:GetPos(),thrustrand,thrustrand,Color(155,215,255,255))

			local particle = emitter:Add("sprites/glow04_noz", self:GetPos() )
			particle:SetVelocity( VectorRand()*128 )
			particle:SetDieTime(0.5)
			particle:SetStartAlpha(215)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(65,75))
			particle:SetEndSize(1)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetAirResistance(155)
			particle:SetColor( 155, 215, 255 )
			self.NextEmit = RealTime() + 0.01
		end
	end
end