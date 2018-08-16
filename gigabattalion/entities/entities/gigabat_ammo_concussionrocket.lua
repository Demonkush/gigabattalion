if SERVER then AddCSLuaFile() end
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Concussion Rocket"

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
		local ply = self:GetOwner()
		if IsValid(ply) then
			local target = ply.gb_Target
			if IsValid(target) then
				if table.HasValue(GIGABAT.Config.TargetableEntities,target:GetClass()) then
					if target:GetOwner() != ply then
						local phys = self:GetPhysicsObject()
						if IsValid(phys) then
							local dir = -(self:GetPos()-target:GetPos())
							phys:AddVelocity(dir/2)
						end
					end
				end
			end
		end
		return false
	end


	function ENT:PhysicsCollide(data, physobj)
		self.Entity:Explode()
	end

	function ENT:Explode()
		if self.Hit then return end
		self.Hit = true

		self:EmitSound("ambient/explosions/explode_9.wav",90,90)
		local fx = EffectData() fx:SetOrigin(self:GetPos()) 
		util.Effect("gbfx_explode_rocket",fx)
		local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(3)
		fx2:SetAngles(Angle(215,215,215))
		util.Effect("gbfx_3d_blast",fx2)
		for i=1,2 do
			local fx3 = EffectData() fx3:SetOrigin(self:GetPos()) fx3:SetScale(3)
			fx3:SetAngles(Angle(215,215,215))
			util.Effect("gbfx_3d_ring",fx3)
		end

		local att = self
		if IsValid(self.Owner) then
			att = self.Owner
		end
		for _, v in ipairs(ents.FindInSphere( self:GetPos(), 175 )) do
			if v != self then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker( att )
				dmginfo:SetInflictor( self )
				dmginfo:SetDamage( math.random(55,75) )
				v:TakeDamageInfo( dmginfo )
				local phys = v:GetPhysicsObject()
				if IsValid(phys) then
					local dir = -(self:GetPos()-v:GetPos()):Angle():Forward()*512
					phys:AddVelocity(dir)
				end
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
		local thrustrand = math.random(64,256)
		render.SetMaterial(glow)
		render.DrawSprite(self:GetPos(),thrustrand,thrustrand,Color(215,215,215,255))

		local dir = -self:GetVelocity()
		if RealTime() > self.NextEmit then
			local emitter = self.Emitter
			emitter:SetPos(self:GetPos())

			local particle = emitter:Add("sprites/glow04_noz", self:GetPos() )
			particle:SetVelocity(dir*2)
			particle:SetDieTime(0.2)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(25,75))
			particle:SetStartLength(512)
			particle:SetEndSize(1)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetGravity(Vector(0,0,0))
			particle:SetAirResistance(155)
			particle:SetColor( 215, 215, 215 )
			self.NextEmit = RealTime() + 0.01
		end
	end
end