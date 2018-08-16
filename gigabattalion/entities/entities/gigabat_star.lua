if SERVER then AddCSLuaFile() end
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Star"

if SERVER then
	function ENT:Initialize()
		self.Entity:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
		self.Entity:SetColor( Color( 255, 255, 255, 255 ) )
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)	
		self.Entity:SetSolid(SOLID_VPHYSICS)

		self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )

		local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:EnableGravity(false)
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		end

		self:SetAngles(AngleRand())

		self.gb_Target = nil
		self.NextTarget = 0

		local types = {"photon","plasma","delta"}
		self:SetNWString("StarType",table.Random(types))
	end

	local startable = {}
	startable["photon"] = {explode=function(ent)
		ent:EmitSound("ambient/explosions/explode_3.wav",90,145)
		local fx = EffectData() fx:SetOrigin(ent:GetPos()) 
		util.Effect("gbfx_explode_photon",fx)
		local fx2 = EffectData() fx2:SetOrigin(ent:GetPos()) fx2:SetScale(5)
		fx2:SetAngles(Angle(255,215,155))
		util.Effect("gbfx_3d_blast",fx2)
		for i=1,3 do
			local fx3 = EffectData() fx3:SetOrigin(ent:GetPos()) fx3:SetScale(5)
			fx3:SetAngles(Angle(255,215,155))
			util.Effect("gbfx_3d_ring",fx3)
		end
		local att = ent
		if IsValid(ent.Owner) then
			att = ent.Owner
		end
		for _, v in ipairs(ents.FindInSphere( ent:GetPos(), 1024 )) do
			if v != ent then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker( att )
				dmginfo:SetInflictor( ent )
				dmginfo:SetDamage( math.random(35,45) )
				v:TakeDamageInfo( dmginfo )
			end
		end
	end}
	startable["plasma"] = {explode=function(ent)
		ent:EmitSound("ambient/explosions/explode_3.wav",90,145)
		local fx = EffectData() fx:SetOrigin(ent:GetPos()) 
		util.Effect("gbfx_explode_plasma",fx)
		local fx2 = EffectData() fx2:SetOrigin(ent:GetPos()) fx2:SetScale(3)
		fx2:SetAngles(Angle(215,255,155))
		util.Effect("gbfx_3d_blast",fx2)
		for i=1,3 do
			local fx3 = EffectData() fx3:SetOrigin(ent:GetPos()) fx3:SetScale(3)
			fx3:SetAngles(Angle(215,255,155))
			util.Effect("gbfx_3d_ring",fx3)
		end
		local att = ent
		if IsValid(ent.Owner) then
			att = ent.Owner
		end
		for _, v in ipairs(ents.FindInSphere( ent:GetPos(), 512 )) do
			if v != ent then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker( att )
				dmginfo:SetInflictor( ent )
				dmginfo:SetDamage( math.random(75,85) )
				v:TakeDamageInfo( dmginfo )
			end
		end
	end} 
	startable["delta"] = {explode=function(ent)
		ent:EmitSound("ambient/explosions/explode_3.wav",90,145)
		local fx = EffectData() fx:SetOrigin(ent:GetPos()) 
		util.Effect("gbfx_explode_delta",fx)
		local fx2 = EffectData() fx2:SetOrigin(ent:GetPos()) fx2:SetScale(4)
		fx2:SetAngles(Angle(255,115,115))
		util.Effect("gbfx_3d_blast",fx2)
		for i=1,3 do
			local fx3 = EffectData() fx3:SetOrigin(ent:GetPos()) fx3:SetScale(4)
			fx3:SetAngles(Angle(255,115,115))
			util.Effect("gbfx_3d_ring",fx3)
		end
		local att = ent
		if IsValid(ent.Owner) then
			att = ent.Owner
		end
		for _, v in ipairs(ents.FindInSphere( ent:GetPos(), 768 )) do
			if v != ent then
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker( att )
				dmginfo:SetInflictor( ent )
				dmginfo:SetDamage( math.random(55,65) )
				v:TakeDamageInfo( dmginfo )
				local dir = -(ent:GetPos()-v:GetPos()):Angle():Forward()*4096
				if v:GetClass() == "gigabat_ship" then
					local phys = v:GetPhysicsObject()
					if IsValid(phys) then
						phys:SetVelocity(dir)
						phys:SetAngles(dir:Angle())
					end
					if IsValid(v:GetOwner()) then
						v:GetOwner():SetEyeAngles(Angle(dir.p,dir.y,0))
					end
				end
			end
		end
	end} 

	function ENT:Think() 
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity(self:GetForward()*99999)
		end
		local startype = self:GetNWString("StarType")
		if startype == "plasma" then
			local target = self.gb_Target
			if IsValid(target) then
				local phys = self:GetPhysicsObject()
				if IsValid(phys) then
					local dir = -(self:GetPos()-target:GetPos()):Angle():Forward()
					phys:AddVelocity(dir*2)
				end
				for a, b in pairs(ents.FindInSphere(self:GetPos(),300)) do
					if b:GetClass() == "gigabat_ship" then
						self:Explode()
					end
				end
			else
				if self.NextTarget < CurTime() then
					for a, b in pairs(ents.FindInSphere(self:GetPos(),768)) do
						if b:GetClass() == "gigabat_ship" then
							self.gb_Target = b
						end
					end
					self.NextTarget = CurTime() + 0.5
				end
			end
		end
		if startype == "photon" then
			if self.NextTarget < CurTime() then
				for a, b in pairs(ents.FindInSphere(self:GetPos(),768)) do
					if b:GetClass() == "gigabat_ship" then
						self:Explode()
					end
				end
				self.NextTarget = CurTime() + 0.5
			end
		end
		if startype == "delta" then
			if self.NextTarget < CurTime() then
				for a, b in pairs(ents.FindInSphere(self:GetPos(),768)) do
					if b:GetClass() == "gigabat_ship" then
						self:Explode()
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

		local star = self:GetNWString("StarType")
		if istable(startable[star]) then
			startable[star].explode(self)
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

	local startable = {}
	startable["photon"] = Color(255,215,155)
	startable["plasma"] = Color(215,255,155)
	startable["delta"] = Color(255,115,115)

	local glow = Material("sprites/glow04_noz")
	function ENT:Draw()
		if RealTime() > self.NextEmit then
			local emitter = self.Emitter
			emitter:SetPos(self:GetPos())

			local col = Color(255,255,255)
			local startype = self:GetNWString("StarType")
			if startype != nil then
				col = startable[startype] or Color(255,255,255)
			end

			local thrustrand = math.random(2024,4048)
			render.SetMaterial(glow)
			render.DrawSprite(self:GetPos(),thrustrand,thrustrand,col)

			local particle = emitter:Add("sprites/glow04_noz", self:GetPos() )
			particle:SetVelocity( VectorRand()*2048 )
			particle:SetDieTime(1)
			particle:SetStartAlpha(215)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.random(256,512))
			particle:SetEndSize(1)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetAirResistance(512)
			particle:SetColor( col.r, col.g, col.b )
			self.NextEmit = RealTime() + 0.05
		end
	end
end