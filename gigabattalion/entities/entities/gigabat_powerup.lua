ENT.Type = "anim"

if SERVER then 
	AddCSLuaFile() 
	function ENT:Initialize()
		self.Entity:SetModel("models/weapons/W_missile_launch.mdl")
		self.Entity:SetColor(Color(255,215,155,255))
		self.Entity:PhysicsInit(SOLID_NONE)
		self.Entity:SetMoveType(MOVETYPE_NONE)	
		self.Entity:SetSolid(SOLID_NONE)
		timer.Simple(60,function() if IsValid(self) then self:Remove() end end)
		self.Powerup = "powerup_overdrive"
		self:SetNWString("Powerup","powerup_overdrive")
	end

	function ENT:Grab(ship)
		if self.Powerup == "powerup_overdrive" then ship:Overdrive(25) ship:SetNWInt("Fuel",ship.MaxFuel)
		elseif self.Powerup == "powerup_overpower" then ship:Overpower(15) ship:SetNWInt("Energy",ship.MaxEnergy)
		elseif self.Powerup == "powerup_stealth" then ship:Stealth(25)
		elseif self.Powerup == "powerup_ammosupply" then ship:AmmoSupply(15)
		elseif self.Powerup == "powerup_repairpack" then
			local maxhp = ship.MaxArmor
			ship:SetNWInt("Armor",math.Clamp(ship:GetNWInt("Armor")+50,0,maxhp))
			GIGABAT.Functions.Notification("Repair Pack! +50 Hull",Color(65,85,35),ship:GetOwner(),false)
		elseif self.Powerup == "powerup_shieldbattery" then ship:ShieldBattery(15) ship:SetNWInt("Shield",ship.MaxShield) end
		self:Remove()
	end
end

if CLIENT then
	local mat = Material("gigabattalion/powerups/powerup_overdrive.png")
	function ENT:Initialize() 
		self.Rotation = 0 
		timer.Simple(1,function()
			if IsValid(self) then
				mat = Material("gigabattalion/powerups/"..self:GetNWString("Powerup")..".png")
			end
		end)
	end
	function ENT:Draw()
		self.Rotation = self.Rotation + (FrameTime()*100)
		local ang = Angle(0,self.Rotation,0)
		render.SetMaterial(mat)
		render.DrawQuadEasy(self:GetPos(),ang:Forward(),256,256,Color(255,255,255,215),180)
		render.DrawQuadEasy(self:GetPos(),-ang:Forward(),256,256,Color(255,255,255,215),180)
	end
end