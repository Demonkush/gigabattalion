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

		timer.Simple(5,function()
			if IsValid(self) then
				self:Explode()
			end
		end)
	end

	function ENT:PhysicsCollide(data, physobj)
		self.Entity:Explode()
	end

	function ENT:Explode()
		if self.Hit then return end
		self.Hit = true

		self:EmitSound("ambient/explosions/explode_9.wav",90,125)
		local fx = EffectData() fx:SetOrigin(self:GetPos()) 
		util.Effect("gbfx_explode_dragon",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(2.5)
		fx2:SetAngles(Angle(255,155,55))
		util.Effect("gbfx_3d_blast",fx2)

		local att = self
		if IsValid(self.Owner) then
			att = self.Owner
		end
		for _, v in ipairs(ents.FindInSphere( self:GetPos(), 125 )) do
			if v != self then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker( att )
				dmginfo:SetInflictor( self )
				dmginfo:SetDamage( 100 )
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
		self.Emitter:SetNearClip(24, 48)

		self:SetRenderBounds(Vector(-256, -256, -256), Vector(256, 256, 256))
		self.NextEmit = 0
	end

	local glow = Material("sprites/glow04_noz")
	function ENT:Draw()
		if RealTime() > self.NextEmit then
			local emitter = self.Emitter
			emitter:SetPos(self:GetPos())

			local thrustrand = math.random(512,1024)
			render.SetMaterial(glow)
			render.DrawSprite(self:GetPos(),thrustrand,thrustrand,Color(255,215,155,255))

			local particle = emitter:Add("particles/flamelet"..math.random(1,3), self:GetPos() )
			particle:SetVelocity( VectorRand()*256 )
			particle:SetDieTime(1)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(50,100))
			particle:SetEndSize(1)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetGravity(Vector(0,0,0))
			particle:SetAirResistance(155)
			particle:SetColor( 255, 235, 215 )
			self.NextEmit = RealTime() + 0.01
		end
	end
end