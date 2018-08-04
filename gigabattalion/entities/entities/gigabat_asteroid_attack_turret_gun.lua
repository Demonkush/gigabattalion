ENT.Type = "anim"

if SERVER then 
	AddCSLuaFile() 

	function ENT:Initialize()
		self.Entity:SetModel("models/gigabattalion/asteroid_turret.mdl")
		self.Entity:SetColor(Color(255,255,255,255))
		self.Entity:PhysicsInit(SOLID_NONE)	
		self.Entity:SetSolid(SOLID_NONE)

		self.NextShoot = 0
	end

	function ENT:Shoot()
		if self.NextShoot > CurTime() then return end
		local base = self:GetNWEntity("BaseEntity")
		if IsValid(base) then
			local lookup = self:LookupAttachment("gun1")
			local attach = self:GetAttachment(lookup)
			local fx = EffectData()
			local pos = attach.Pos
			fx:SetOrigin(pos)
			fx:SetScale(64)
			util.Effect("gbfx_sprite_muzzlered",fx)

			local att = base
			self:EmitSound("gigabat.laser.shoot")
			local ang = self:GetAngles()
			local bullet = {}
			bullet.Attacker 	= att
			bullet.Inflictor 	= self
			bullet.Damage		= 3
			bullet.Distance 	= 4096
			bullet.Amount 		= 1
			bullet.Spread 		= 5
			bullet.Hull 		= 32	
			bullet.StartPos 	= pos+(-ang:Forward()*64)
			bullet.Direction 	= -ang:Forward()	
			bullet.Tracer 		= "gbfx_tracer_pulsered"
			bullet.Impact 		= "gbfx_impact_pulsar_red"
			local filter = {base,base:GetNWEntity("BaseEntity")}
			bullet.Filter = function(ent) 
				if !table.HasValue(filter,ent) then
					return true 
				end
			end
			GIGABAT.Functions.FireBullet(bullet,att,self)
		end
	end
end