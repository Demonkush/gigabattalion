if SERVER then AddCSLuaFile() end
ENT.Type = "anim"

if SERVER then
	function ENT:Initialize()   
		self:SetModel("models/dav0r/hoverball.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:DrawShadow(false)

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableCollisions(false)
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			phys:EnableGravity(false)
			phys:Wake()
		end

		self:SetNWInt("Armor",25)
		self.Weapon = "weapon_laser"
		self.Offset = Vector(0,0,0)
		self.NextAttack = 0
		self.Ammo = 0
		self.MaxAmmo = 10
		self.Energy = 0
		self.UsesAmmo = false
		self.UsesEnergy = false
		self.ReloadTime = 3
		self.Reloading = false
		self.Ship = nil
	end

	function ENT:Reload(ship)
		if self.UsesEnergy then return end
		local reloadtime = self.ReloadTime
		self.Reloading = true
		if IsValid(ship) then
			if ship.Powerups.AmmoSupply then reloadtime = 0.5 end
		end
		timer.Simple(reloadtime,function()
			if IsValid(self) then
				self.Ammo = self.MaxAmmo
				self.Reloading = false
			end
		end)
	end

	function ENT:Shoot(ship)
		if self.Reloading then return end
		if self.NextAttack > CurTime() then return end
		local ply = ship:GetOwner()
		local stats = GIGABAT.Arsenal[self.Weapon].stats
		if !GIGABAT.Config.InfiniteAmmo then
			if self.UsesAmmo then
				self.Ammo = math.Clamp(self.Ammo - 1,0,self.MaxAmmo)
				if self.Ammo <= 0 then self:Reload(ship) end
			end
			if !ship.Powerups.Overpower then
				if self.UsesEnergy then
					if ship.Energy < self.Energy then self.NextAttack = CurTime() + stats.dly return end
					ship.EnergyNextRegen = CurTime() + 2
					ship.Energy = math.Clamp(ship.Energy-self.Energy,0,ship.MaxEnergy)
					ship:SetNWInt("Energy",math.Clamp(ship.Energy-1,0,ship.MaxEnergy))
				end
			end
		end
		GIGABAT.Arsenal[self.Weapon].attack(self)
		if IsValid(ply) then ply.gb_Stats.shotsfired = ply.gb_Stats.shotsfired + 1 end
		self.NextAttack = CurTime() + stats.dly
		if IsValid(ship) then ship.NextAttack = CurTime() + stats.dly end
	end

	function ENT:OnRemove()
		self:StopSound("gigabat.beam.loop")
	end
end

if CLIENT then function ENT:Draw() end end