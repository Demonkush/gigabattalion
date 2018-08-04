if SERVER then AddCSLuaFile() end
ENT.Type = "anim"

if SERVER then
	function ENT:Initialize()   
		self:SetModel("models/gigabattalion/asteroid.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:DrawShadow(false)

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetMass(500)
			phys:EnableGravity(false)
			phys:SetAngleDragCoefficient(55)
			phys:Wake()
		end

		-- NWVars
		self:SetNWBool("Boosting",false)
		self:SetNWBool("Afterburner",false)
		self:SetNWInt("Speed",0)
		self:SetNWInt("Fuel",100)
		self:SetNWInt("Energy",100)
		self:SetNWInt("Armor",100)
		self:SetNWInt("Shield",100)
		self:SetNWInt("Rotation",0)
		self:SetNWBool("OnFire",false)

		self.BoostSFX = "ambient/levels/citadel/portal_beam_loop1.wav"
		self:BuildSounds()

		-- Variables
		self.DragSpeed 			= 1
		self.DragMod 			= 0
		self.TurnSpeed 			= 1
		self.Acceleration 		= 1
		self.Speed 				= 0
		self.Energy 			= 100 
		self.Fuel 				= 100
		self.MaxArmor 			= 100
		self.MaxFuel 			= 100
		self.MaxEnergy 			= 100
		self.MaxSpeed 			= 2555
		self.MaxShield 			= 100
		self.ShieldNextRegen 	= 0
		self.EnergyNextRegen 	= 0
		self.FuelNextRegen		= 0
		self.Exploded 			= false
		self.Exploding 			= false
		self.OnFire 			= false
		self.SpawnProtection 	= true
		self.Afterburner 		= false
		self.AfterburnerDelay 	= 0
		self.LastAttacker 		= nil

		self.PrimaryTable 		= {}
		self.PrimaryAlternate 	= 1
		self.PrimaryCurrent 	= "gun1"
		self.LastPrimaryDelay 	= 0
		self.SecondaryTable 	= {}
		self.SecondaryAlternate = 1
		self.SecondaryCurrent 	= "gun1"
		self.LastSecondaryDelay = 0
		self.NextAttack 		= 0
		self.NextTarget 		= 0
		self.NextUpdateTarget 	= 0
		self.NextBurn 			= 0
		self.NextReload 		= 0
		self.NextPowerup		= 0
		self.NextShieldPoke 	= 0
		self.NextWaypoint 		= 0
		self.Rotation = 0

		self.Powerups = {
			Overdrive 		= false,
			Overpower 		= false,
			Stealth 		= false,
			ShieldBattery 	= false,
			AmmoSupply 		= false
		}

		timer.Simple(5,function()
			if IsValid(self) then
				self.SpawnProtection = false	
				if IsValid(self:GetOwner()) then GIGABAT.Functions.Notification("Weapons Enabled",Color(85,65,35),self:GetOwner(),false) end
			end
		end)

		self.Weapons = {}
	end

	function ENT:ChangeBoostSound(snd)
		self.BoostSFX = snd
		self:BuildSounds()
	end

	function ENT:BuildSounds()
		local filter = RecipientFilter()
		filter:AddAllPlayers()
		self.BoostSound = CreateSound(self,self.BoostSFX,filter)
		self.BoostSound:Stop()
		self.BoostSound:ChangeVolume(0)
		self.BoostSound:ChangePitch(0)
		self.BoostSwitch = false
		self.AfterburnerSound = CreateSound(self,"ambient/levels/labs/teleport_rings_loop2.wav",filter)
		self.AfterburnerSound:Stop()
		self.AfterburnerSound:ChangeVolume(0)
		self.AfterburnerSound:ChangePitch(0)
		self.AfterburnerSwitch = false
	end

	function ENT:Alternate(mode)
		if mode == "primary" then
			local total = #self.PrimaryTable
			if total > 0 then
				self.PrimaryAlternate = self.PrimaryAlternate + 1
				if self.PrimaryAlternate > total then self.PrimaryAlternate = 1 end
				self.PrimaryCurrent = self.PrimaryTable[self.PrimaryAlternate]
			end
		end
		if mode == "secondary" then
			local total = #self.SecondaryTable
			if total > 0 then
				self.SecondaryAlternate = self.SecondaryAlternate + 1
				if self.SecondaryAlternate > total then self.SecondaryAlternate = 1 end
				self.SecondaryCurrent = self.SecondaryTable[self.SecondaryAlternate]
			end
		end
	end

	function ENT:SwitchBoost(bool)
		if bool then if self.BoostSwitch then return end
			self:SetNWBool("Boosting",true)
			self.BoostSwitch = true
			self.BoostSound:ChangeVolume(0)
			self.BoostSound:ChangePitch(0)
			self.BoostSound:Play()
		elseif !bool then if !self.BoostSwitch then return end
			self:SetNWBool("Boosting",false)
			self.BoostSwitch = false
			if self.BoostSound != nil then self.BoostSound:Stop() end
			self:SetNWBool("Afterburner",false)
			if self.AfterburnerSound != nil then
				self.AfterburnerSound:ChangeVolume(0)
				self.AfterburnerSound:ChangePitch(0)
				self.AfterburnerSound:Stop()
			end
		end
	end

	function ENT:FixGunPositions()
		local ang = self:GetAngles()
		for a, b in pairs(self.Weapons) do
			if IsValid(b) then
				local att = self:LookupAttachment(b.Attach)
				local attach = self:GetAttachment(att).Pos
				b:SetPos(attach)
				b:SetAngles(self:GetAngles())
			end
		end
	end

	function ENT:FixAngles()
		if self.Speed < 5 then return end
		local phys = self:GetPhysicsObject()
		local ang = self:GetOwner():EyeAngles()
		local drag = self.DragSpeed + GIGABAT.Config.GlobalDragSpeed
		if IsValid(phys) then
			phys:SetAngles(LerpAngle(drag,phys:GetAngles(),ang+Angle(180,0,180+self:GetNWInt("Rotation"))))
		end
	end

	function ENT:StopAfterburner()
		if !self.Afterburner then return end
		self.Afterburner = false
		self:SetNWBool("Afterburner",false)
		self.AfterburnerSound:ChangeVolume(0)
		self.AfterburnerSound:ChangePitch(0)
		self.AfterburnerSound:Stop()
	end
	
	function ENT:StartAfterburner()
		if self.Afterburner then return end
		self.Afterburner = true
		self:SetNWBool("Afterburner",true)
		self.AfterburnerSound:ChangeVolume(1)
		self.AfterburnerSound:ChangePitch(1)
		self.AfterburnerSound:Play()
	end
	
	function ENT:Think()
		if self.Exploding then return end
		local ply = self:GetOwner()
		if IsValid(ply) then
			ply:SetPos(self:GetPos())
			self:FixGunPositions()
			self:FixAngles()
			local phys = self:GetPhysicsObject()
			if IsValid(phys) then
				-- ACTION: Attack
				if !self.SpawnProtection then
					if ply:KeyDown(IN_ATTACK) then GIGABAT.Functions.Shoot(self,IN_ATTACK) end
					if ply:KeyDown(IN_ATTACK2) then GIGABAT.Functions.Shoot(self,IN_ATTACK2) end
				end
				-- TICK: Check for Target
				if self.NextUpdateTarget < CurTime() then
					if IsValid(ply.gb_Target) then
						GIGABAT.Functions.UpdateTarget(ply)
					end
					self.NextUpdateTarget = CurTime() + 0.2
				end
				-- ACTION: Target
				if ply:KeyDown(IN_JUMP) then
					if self.NextTarget < CurTime() then
						GIGABAT.Functions.TraceTarget(ply)
						self.NextTarget = CurTime() + 0.5
					end
				end
				-- ACTION: Force Reload
				if ply:KeyDown(IN_RELOAD) then
					if self.NextReload < CurTime() then
						GIGABAT.Functions.Notification("Reloading All Weapons",Color(85,65,35),self:GetOwner(),false)
						for a, b in pairs(self.Weapons) do
							if IsValid(b) then
								b:Reload(self)
							end
						end
						self.NextReload = CurTime() + 7
					end
				end
				-- TICK: Powerup Pickup
				self:PickupPowerup()
				-- TICK: Waypoint Detect
				self:DetectWaypoints()
				-- TICK: OnFire
				if self.OnFire then self:Burn() end
				-- TICK: Regenerate Shields
				if self.ShieldNextRegen < CurTime() then
					self:SetNWInt("Shield",math.Clamp(self:GetNWInt("Shield")+1,0,self.MaxShield))
					self.ShieldNextRegen = CurTime() + 0.1
				end
				-- TICK: Regenerate Energy
				if self.EnergyNextRegen < CurTime() then
					self.Energy = math.Clamp(self.Energy+2,0,self.MaxEnergy)
					self:SetNWInt("Energy",self.Energy)
					self.EnergyNextRegen = CurTime() + 0.1
				end
				-- TICK: Regenerate Fuel
				if self.FuelNextRegen < CurTime() then
					self.Fuel = math.Clamp(self.Fuel+1,0,self.MaxFuel)
					self:SetNWInt("Fuel",self.Fuel)
					self.FuelNextRegen = CurTime() + 0.1
				end
				-- TICK: Modulate Engine Sound based on Speed
				local vol = math.Clamp(self.Speed/10,0,200)
				if self.BoostSound != nil then
					self.BoostSound:ChangeVolume(vol/16)
					self.BoostSound:ChangePitch(vol)
				end
				-- ACTION: Rotate Left
				if ply:KeyDown(IN_MOVELEFT) then
					self.Rotation = self.Rotation + self.TurnSpeed
					self:SetNWInt("Rotation",self.Rotation)
				end
				-- ACTION: Rotate Right
				if ply:KeyDown(IN_MOVERIGHT) then
					self.Rotation = self.Rotation - self.TurnSpeed		
					self:SetNWInt("Rotation",self.Rotation)
				end
				-- ACTION: Slow Down
				if ply:KeyDown(IN_BACK) then
					if ply:KeyDown(IN_DUCK) then
						if self.Fuel > 5 && self.Speed > 5 then
							self.Speed = math.Clamp(self.Speed-100,0,math.huge)
							if !self.Powerups.Overdrive then
								self.FuelNextRegen = CurTime() + 2
								self.Fuel = math.Clamp(self.Fuel-1,0,self.MaxFuel)
								self:SetNWInt("Fuel",self.Fuel)
							end
						end
					else self.Speed = math.Clamp(self.Speed-self.Acceleration,0,math.huge) end
				end
				-- ACTION: Boost / Afterburner
				if ply:KeyDown(IN_FORWARD) then
					self:SwitchBoost(true)
					if self.Speed > self.MaxSpeed then
						self.Speed = math.Clamp(self.Speed-10,0,math.huge)
					else
						self.Speed = math.Clamp(self.Speed+self.Acceleration+GIGABAT.Config.GlobalSpeed,0,self.MaxSpeed)
					end
					if self.AfterburnerDelay < CurTime() then
						if self.Fuel > 0 then
							if ply:KeyDown(IN_FORWARD) && ply:KeyDown(IN_SPEED) then
								if !GIGABAT.Config.InfiniteFuel then
									if !self.Powerups.Overdrive then
										self.Fuel = self.Fuel - 1
										self:SetNWInt("Fuel",self.Fuel)
									end
								end
								self.Speed = math.Clamp(self.Speed+(self.Acceleration*5),0,self.MaxSpeed*GIGABAT.Config.GlobalBoostSpeed)
								self:StartAfterburner()
								self.FuelNextRegen = CurTime() + 2
							else
								self:StopAfterburner()
							end
						else
							self:StopAfterburner()
							self.FuelNextRegen = CurTime() + 3
							self.AfterburnerDelay = CurTime() + 5
						end
					end
				else
					self:StopAfterburner()
					if self.Speed > self.MaxSpeed then self.Speed = math.Clamp(self.Speed-10,0,math.huge) end
				end
				if self.Speed <= 1 then self:SwitchBoost(false) end
				phys:AddVelocity(-self:GetAngles():Forward()*self.Speed)
				self:SetNWInt("Speed",self.Speed)
			end
		end
		self:NextThink(CurTime()+0.1)
		return true
	end

	local collisionfilter = {"gigabat_ship","gigabat_asteroid","gigabat_debris","gigabat_station"}
	function ENT:PhysicsCollide(data)
		if self.SpawnProtection then return end
		if !self.Exploding then
			if IsValid(data.HitEntity) then
				if table.HasValue(collisionfilter,data.HitEntity:GetClass()) then
					if GIGABAT.Config.CollideInstakill == true then
						if data.Speed > 2048 then
							self:EmitSound("vehicles/v8/vehicle_impact_heavy"..math.random(1,4)..".wav",95,85)
							self:Explode()
							if data.HitEntity:GetClass() == "gigabat_asteroid" then
								self.LastAttacker = data.HitEntity
								self.LastAttackerWeapon = ""
							end
							return
						end
					end
					if data.Speed > 768 then
						self:TakeDamage(math.Round(data.Speed/25))
						self:EmitSound("vehicles/v8/vehicle_impact_heavy"..math.random(1,4)..".wav",85,115)
					end
				end
				if data.Speed > 512 then
					local normal = data.HitNormal
					self:EmitSound("vehicles/v8/vehicle_impact_heavy"..math.random(1,4)..".wav",75,155)
					local phys = self:GetPhysicsObject()
					if IsValid(phys) then
						local ang = normal:Angle()
						phys:SetVelocity(normal*64)
						phys:SetAngles(ang)
						self:TakeDamage(math.Round(data.Speed/100))
					end
				end
			end
		end
	end

	function ENT:OnRemove()
		self:RemovePowerupTimers()
		self.BoostSound:ChangeVolume(0)
		self.BoostSound:ChangePitch(0)
		self.BoostSound:Stop()
		self.AfterburnerSound:ChangeVolume(0)
		self.AfterburnerSound:ChangePitch(0)
		self.AfterburnerSound:Stop()
		for k,v in pairs(self.Weapons) do if IsValid(v) then v:Remove() end end
		self.Weapons = nil
	end

	function ENT:StartExplode()
		if self.Exploded then return end
		if self.Exploding then return end
		self.Exploding = true
		self:SwitchBoost(false)
		self:EmitSound("weapons/physcannon/physcannon_charge.wav",85,75)
		local grow = 0
		timer.Create("GigabatDeathEffects"..self:EntIndex(),0.05,32,function()
			if IsValid(self) then
				grow = grow + 1
				local pos = self:GetPos()+(VectorRand()*math.random(2,grow*5))
				local fx = EffectData() fx:SetOrigin(pos) fx:SetScale(grow/16)
				fx:SetAngles(Angle(255,215+grow,155+grow))
				util.Effect("gbfx_3d_blast",fx)
			end
		end)
		timer.Simple(2,function() if IsValid(self) then self:Explode() end end)
	end

	function ENT:Explode()
		if self.Exploded then return end
		self.Exploded = true
		if IsValid(self) then
			local ply = self:GetOwner()
			local att = ply
			if !IsValid(ply) then att = self end
			for _, v in pairs(ents.FindInSphere(self:GetPos(),512)) do
				if v != self then
					local dmg = DamageInfo()
					dmg:SetAttacker(att)
					dmg:SetInflictor(self)
					dmg:SetDamage(50)
					v:TakeDamageInfo(dmg)
				end
			end
			self:EmitSound("weapons/mortar/mortar_explode1.wav",95,125)
			local fx1 = EffectData() fx1:SetOrigin(self:GetPos()) fx1:SetScale(2)
			fx1:SetAngles(Angle(255,255,255))
			util.Effect("gbfx_explode_dragon",fx1)
			local fx2 = EffectData() fx2:SetOrigin(self:GetPos()) fx2:SetScale(4)
			fx2:SetAngles(Angle(255,235,215))
			util.Effect("gbfx_3d_blast",fx2)
			local fx3 = EffectData() fx3:SetOrigin(self:GetPos()) fx3:SetScale(4)
			fx3:SetAngles(Angle(255,215,195))
			util.Effect("gbfx_3d_ring",fx3)
			timer.Simple(0.1,function()
				if IsValid(ply) then if ply:Alive() then ply:Kill() end end
				self:Remove()
			end)
		end
	end 
	function ENT:PickupPowerup()
		if self.NextPowerup > CurTime() then return end
		self.NextPowerup = CurTime() + 0.5
		for a, b in pairs(ents.FindInSphere(self:GetPos(),512)) do
			if b:GetClass() == "gigabat_powerup" then
				b:Grab(self)
			end
		end
	end
	function ENT:DetectWaypoints()
		if self.NextWaypoint > CurTime() then return end
		self.NextWaypoint = CurTime() + 0.1
		local ply = self:GetOwner()
		if !IsValid(ply) then return end
		for a, b in pairs(ents.FindInSphere(self:GetPos(),768)) do
			if b:GetClass() == "gigabat_waypoint" then
				if b:GetNWInt("Waypoint") == ply:GetNWInt("Gigabat_Waypoint") then			
					GIGABAT.Functions.SetNextWaypoint(ply)
					return
				end
			end
		end
	end
	function ENT:Overdrive(time)
		timer.Remove("GBShipOverdrive"..self:EntIndex())
		net.Start("Ship_Overdrive")
			net.WriteEntity(self)
			net.WriteInt(time,32)
		net.Broadcast()
		self.Powerups.Overdrive = true
		GIGABAT.Functions.Notification("Power-UP! [Overdrive]",Color(65,85,35),self:GetOwner(),false)
		timer.Create("GBShipOverdrive"..self:EntIndex(),time,1,function()
			GIGABAT.Functions.Notification("Power-up expired! [Overdrive]",Color(35,35,35),self:GetOwner(),false)
			self.Powerups.Overdrive = false
		end)
	end
	function ENT:Overpower(time)
		timer.Remove("GBShipOverpower"..self:EntIndex())
		net.Start("Ship_Overpower")
			net.WriteEntity(self)
			net.WriteInt(time,32)
		net.Broadcast()
		self.Powerups.Overpower = true
		GIGABAT.Functions.Notification("Power-UP! [Overpower]",Color(65,85,35),self:GetOwner(),false)
		timer.Create("GBShipOverpower"..self:EntIndex(),time,1,function()
			GIGABAT.Functions.Notification("Power-up expired! [Overpower]",Color(35,35,35),self:GetOwner(),false)
			self.Powerups.Overpower = false
		end)
	end
	function ENT:Stealth(time)
		timer.Remove("GBShipStealth"..self:EntIndex())
		net.Start("Ship_Stealth")
			net.WriteEntity(self)
			net.WriteInt(time,32)
		net.Broadcast()
		self.Powerups.Stealth = true
		GIGABAT.Functions.Notification("Power-UP! [Stealth]",Color(65,85,35),self:GetOwner(),false)
		timer.Create("GBShipStealth"..self:EntIndex(),time,1,function()
			GIGABAT.Functions.Notification("Power-up expired! [Stealth]",Color(35,35,35),self:GetOwner(),false)
			self.Powerups.Stealth = false
		end)
	end
	function ENT:AmmoSupply(time)
		timer.Remove("GBShipAmmoSupply"..self:EntIndex())
		net.Start("Ship_AmmoSupply")
			net.WriteEntity(self)
			net.WriteInt(time,32)
		net.Broadcast()
		self.Powerups.AmmoSupply = true
		GIGABAT.Functions.Notification("Power-UP! [Ammo Supply]",Color(65,85,35),self:GetOwner(),false)
		timer.Create("GBShipAmmoSupply"..self:EntIndex(),time,1,function()
			GIGABAT.Functions.Notification("Power-up expired! [Ammo Supply]",Color(35,35,35),self:GetOwner(),false)
			self.Powerups.AmmoSupply = false
		end)
	end
	function ENT:ShieldBattery(time)
		timer.Remove("GBShipShieldBattery"..self:EntIndex())		
		net.Start("Ship_ShieldBattery")
			net.WriteEntity(self)
			net.WriteInt(time,32)
		net.Broadcast()
		self.Powerups.ShieldBattery = true
		GIGABAT.Functions.Notification("Power-UP! [Shield Battery]",Color(65,85,35),self:GetOwner(),false)
		timer.Create("GBShipShieldBattery"..self:EntIndex(),time,1,function()
			GIGABAT.Functions.Notification("Power-up expired! [Shield Battery]",Color(35,35,35),self:GetOwner(),false)
			self.Powerups.ShieldBattery = false
		end)
	end
	function ENT:RemovePowerupTimers()
		timer.Remove("GBShipOverdrive"..self:EntIndex())
		timer.Remove("GBShipOverpower"..self:EntIndex())
		timer.Remove("GBShipStealth"..self:EntIndex())
		timer.Remove("GBShipAmmoSupply"..self:EntIndex())
		timer.Remove("GBShipShieldBattery"..self:EntIndex())
	end
	
	function ENT:StateBurn(attacker,time)
		if self.SpawnProtection then return end
		if self.OnFire then return end
		self.LastAttacker = attacker
		self.OnFire = true
		self:SetNWBool("OnFire",true)
		if timer.Exists("GigabatStateBurn"..self:EntIndex()) then timer.Remove("GigabatStateBurn"..self:EntIndex()) end
		timer.Create("GigabatStateBurn"..self:EntIndex(),time,1,function() self.OnFire = false self:SetNWBool("OnFire",false) end)
	end

	function ENT:Burn(time)
		if self.Exploded then return end
		if self.Exploding then return end
		if self.NextBurn > CurTime() then return end
		self.NextBurn = CurTime() + 0.2
		local dmg = DamageInfo()
		dmg:SetDamage(math.random(1,2))
		dmg:SetDamageStyle("ballistic")
		dmg:SetAttacker(self)
		dmg:SetInflictor(self)
		self:TakeDamageInfo(dmg)
	end

	function ENT:SVShieldPoke()
		if self.NextShieldPoke > CurTime() then return end
		if self.Exploded then return end
		if self.Exploding then return end
		self:EmitSound("ambient/levels/labs/electric_explosion5.wav",80,135)
		net.Start("Ship_ShieldPoke")
			net.WriteEntity(self)
		net.Broadcast()
		self.NextShieldPoke = CurTime()+0.2
	end
end

if CLIENT then
	function ENT:RemoveBody()
		if IsValid(self.Body) then self.Body:Remove() end
	end
	function ENT:CreateBody()
		self.Body = ClientsideModel(self:GetModel(),RENDERGROUP_TRANSLUCENT)
		self.Body:SetPos(self:GetPos())
		self.Thrusters = {}
		for a, b in pairs(self:GetAttachments()) do if string.match(b.name,"thruster") then table.insert(self.Thrusters,b.id) end end
		self.Body:SetMaterial("Models/effects/vol_light001")
		if IsValid(self:GetOwner()) then
			local skin = self:GetOwner():GetNWString("Gigabat_Skin")
			GIGABAT.Functions.ApplySkin(self.Body,skin)
		end
		timer.Simple(5,function()
			if IsValid(self) then
				local fx = EffectData()
				fx:SetOrigin(self:GetPos())
				fx:SetScale(512)
				util.Effect("gbfx_sprite_muzzleblue",fx)
				self.Protection = false
				if !self.Stealthed then
					self.Body:SetMaterial()
				end
			end
		end)
	end
	function ENT:Stealth(time)
		if !IsValid(self.Body) then return end
		timer.Remove("GigabatStealth"..self:EntIndex())
		self.Stealthed = true
		self.Body:SetMaterial("Models/effects/vol_light001")
		timer.Create("GigabatStealth"..self:EntIndex(),time,1,function()
			if IsValid(self) then
				self.Stealthed = false
				self.Body:SetMaterial()
				if IsValid(self:GetOwner()) then
					local skin = self:GetOwner():GetNWString("Gigabat_Skin")
					GIGABAT.Functions.ApplySkin(self.Body,skin)
				end
			end
		end)
	end
	function ENT:Initialize()   
		self:RemoveBody()
		self:CreateBody()
		self.Emitter = ParticleEmitter(self:GetPos())
		self.CriticalScale = 0
		self.ShieldPokeScale = 0
		self.NextEmit = 0
		self.NextEmit2 = 0
		self.Protection = true
		self.Stealthed = false
	end

	function ENT:Think()
		if IsValid(self.Body) then
			self.Body:SetPos(self:GetPos())
			if IsValid(self:GetOwner()) then self.Body:SetAngles(LerpAngle(FrameTime()*4,self.Body:GetAngles(),self:GetAngles())) end
			if IsValid(self.ShieldPokeObj) then
				self.ShieldPokeObj:SetAngles(self.Body:GetAngles())
				self.ShieldPokeObj:SetPos(self.Body:GetPos())
				if self.ShieldPokeScale < 255 then
					local rate = FrameTime()*768
					self.ShieldPokeScale = math.Clamp(self.ShieldPokeScale + rate,0,255)
				else
					self.ShieldPokeObj:Remove()
					self.ShieldPokeObj = nil
				end
			end
		end
	end

	local glow = Material("sprites/glow04_noz")
	local typeang = 0 
	function ENT:Draw()
		if FrameTime() <= 0 then return end
		if IsValid(self:GetOwner()) then
			if self:GetOwner():IsTyping() then
				typeang = typeang + 1
				if typeang > 360 then typeang = 0 end
				cam.Start3D2D(self:GetPos()+Vector(0,0,128),Angle(0,typeang,90),1)
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(Material("gigabattalion/ui/typing.png"))
					surface.DrawTexturedRect(-64,-32,128,64)
				cam.End3D2D()
				cam.Start3D2D(self:GetPos()+Vector(0,0,128),Angle(0,typeang+180,90),1)
					surface.SetDrawColor(Color(255,255,255,255))
					surface.SetMaterial(Material("gigabattalion/ui/typing.png"))
					surface.DrawTexturedRect(-64,-32,128,64)
				cam.End3D2D()
			end
		end
		if IsValid(self.ShieldPokeObj) then
			local scale = self.ShieldPokeScale
			self.ShieldPokeObj:SetColor(Color(math.Clamp(scale,0,215),math.Clamp(scale,0,235),255,scale))
		end
		if IsValid(self.Body) then
			if self.Protection then
				render.SetMaterial(glow)
				render.DrawSprite(self.Body:GetPos(),64,64,Color(math.random(155,255),math.random(155,255),math.random(155,255),255))	
				return		
			end
			if self.Stealthed then return end
			if self:GetNWInt("Armor") <= 0 then
				self.CriticalScale = self.CriticalScale + FrameTime()*256
				render.SetMaterial(glow)
				render.DrawSprite(self.Body:GetPos(),self.CriticalScale*2,self.CriticalScale*2,Color(255,185,135,math.random(0,255)))	
			end
			if self:GetNWBool("OnFire") then
				local rando = math.random(1,3)
				if rando == 1 then
					local flames = self.Emitter:Add("particles/flamelet"..math.random(1,3),self.Body:GetPos()+(VectorRand()*32))
					flames:SetVelocity(VectorRand()*math.random(32,128))
					flames:SetDieTime(1)
					flames:SetStartAlpha(255)
					flames:SetEndAlpha(0)
					flames:SetStartSize(math.random(5,55))
					flames:SetRoll(math.random(0,360))
					flames:SetEndSize(0)
					flames:SetAirResistance(55)
					flames:SetColor(255,235,215,255)
				end				
			end
			local afterburner = self:GetNWBool("Afterburner")
			if self:GetNWBool("Boosting") == true then
				local thrustsize = math.Clamp(self:GetNWInt("Speed")/2,1,55)
				if afterburner == true then thrustsize = thrustsize*10 end
				local thrustrand = math.Rand(thrustsize,thrustsize*2)
				local frame = GIGABAT.Frames[self:GetOwner():GetNWString("Gigabat_Frame")]
				if istable(frame) then
					if RealTime() > self.NextEmit then
						for a,b in pairs(frame.thrusters) do
							local attach = self.Body:LookupAttachment(b.attach)
							if istable(self.Body:GetAttachment(attach)) then
								local thrustpos = self.Body:GetAttachment(attach).Pos
								local fx = EffectData()
								fx:SetOrigin(thrustpos)
								fx:SetScale(thrustrand)
								local speed = self:GetNWInt("Speed")/7.5
								if speed > 50 then fx:SetRadius(speed) else fx:SetRadius(0) end
								fx:SetNormal(self.Body:GetAngles():Forward())
								util.Effect(b.effect,fx)
								if self:GetNWInt("Armor") < 50 then
									local rando = math.random(1,3)
									if rando == 1 then
										local flames = self.Emitter:Add("particles/flamelet"..math.random(1,3),thrustpos)
										flames:SetVelocity(self:GetAngles():Forward()*1024)
										flames:SetDieTime(1)
										flames:SetStartAlpha(255)
										flames:SetEndAlpha(0)
										flames:SetStartSize(math.random(5,55))
										flames:SetRoll(math.random(0,360))
										flames:SetEndSize(0)
										flames:SetAirResistance(55)
										flames:SetColor(255,235,215,255)
									end
								end
							end
						end
						self.NextEmit = RealTime() + 0.025
					end
				end
			end
			local thrustsize = math.Clamp(self:GetNWInt("Speed")/10,1,35)
			local thrustrand = math.Rand(thrustsize*3,thrustsize*5)
			if afterburner then
				for a,b in pairs(self.Thrusters) do
					local pos = self.Body:GetAttachment(b).Pos
					render.SetMaterial(glow)
					render.DrawSprite(pos,thrustrand*2,thrustrand*2,Color(255,215,195,255))
				end
			end
		end
		if self:GetOwner() == LocalPlayer() then
			if self:GetNWInt("Speed")/7.5 > 50 then
				local starpos = EyePos()+(EyeAngles():Forward()*2048)
				if RealTime() > self.NextEmit2 then
					local stars = self.Emitter:Add("sprites/glow04_noz",starpos+(VectorRand()*1024))
					stars:SetVelocity(self:GetAngles():Forward()*2048)
					stars:SetDieTime(0.6)
					stars:SetStartAlpha(215)
					stars:SetStartLength(0)
					stars:SetEndLength(self:GetNWInt("Speed")*2)
					stars:SetEndAlpha(0)
					stars:SetStartSize(math.random(3,8))
					stars:SetRoll(math.random(0,360))
					stars:SetEndSize(1)
					stars:SetAirResistance(55)
					stars:SetColor(155,215,255,255)
					self.NextEmit2 = RealTime() + 0.01
				end
			end
		end
		if self:GetNWInt("Speed")/7.5 > 100 then
			GIGABAT.Functions.StartMotionBlur()
			GIGABAT.Functions.ModifyMotionBlur(self:GetNWInt("Speed")/5000,self:GetNWInt("Speed")/5000,0.01)
		else
			GIGABAT.Functions.StopMotionBlur()
		end
	end

	function ENT:OnRemove()
		timer.Remove("GigabatStealth"..self:EntIndex()) 
		self:RemoveBody()	
		if IsValid(self.ShieldPokeObj) then self.ShieldPokeObj:Remove() end
	end

	function ENT:CLShieldPoke()
		if IsValid(self.ShieldPokeObj) then self.ShieldPokeObj:Remove() end
		self.ShieldPokeScale = 0
		self.ShieldPokeObj = ClientsideModel(self:GetModel(),RENDERGROUP_TRANSLUCENT)
		self.ShieldPokeObj:SetAngles(self:GetAngles())
		self.ShieldPokeObj:SetPos(self:GetPos())
		self.ShieldPokeObj:SetMaterial("models/props_combine/portalball001_sheet")
		self.ShieldPokeObj:SetColor(Color(155,235,255,125))
		self.ShieldPokeObj:SetModelScale(self:GetModelScale()+0.3)
	end	
end