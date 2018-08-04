function GIGABAT.Functions.BuildLoadout(ship)
	if !IsValid(ship) then return end
	local data = GIGABAT.Functions.GetFrame(ship:GetNWString("Gigabat_Frame"))

	for a, b in pairs(data.loadout) do
		GIGABAT.Functions.AddWeapon(ship,b.weapon,b.attach,b.slot)
	end
end

function GIGABAT.Functions.GetArsenal(wep)
	for a, b in pairs(GIGABAT.Arsenal) do
		if wep == a then return b end
	end
end

function GIGABAT.Functions.FireBullet(bullet,att,inf)
	if !IsValid(att) then return end
	if !IsValid(inf) then return end
	local trace = nil

	local function FireBullet(bullet,trace)
		if bullet.Tracer then
			local tracer = EffectData()
			tracer:SetOrigin(trace.HitPos)
			tracer:SetStart(bullet.StartPos)
			util.Effect(bullet.Tracer,tracer)
		end

		if !trace.HitSky then
			if bullet.Impact then
				local impact = EffectData()
				impact:SetOrigin(trace.HitPos)
				impact:SetNormal(trace.HitNormal)
				util.Effect(bullet.Impact,impact)		
			end
		end
		
		if trace.Hit then
			if IsValid(trace.Entity) then
				local dmg = DamageInfo()
				dmg:SetDamage(bullet.Damage)
				dmg:SetInflictor(inf)
				dmg:SetAttacker(att)
				dmg:SetDamageStyle(bullet.DamageStyle)
				trace.Entity:TakeDamageInfo(dmg)

				if bullet.Force then
					local ang = (bullet.StartPos-trace.HitPos):Angle()
					local phys = trace.Entity:GetPhysicsObject()
					if IsValid(phys) then
						phys:AddVelocity(-ang:Forward()*(bullet.Force))
					end
				end
			end
		end
	end
	
	for i=1,bullet.Amount do
		local dir = (bullet.Direction:Angle()+Angle(math.random(-bullet.Spread,bullet.Spread),math.random(-bullet.Spread,bullet.Spread),0)):Forward()
		if bullet.Hull > 0 then
			local tr = util.TraceHull({
				start = bullet.StartPos,
				endpos = bullet.StartPos+(dir*bullet.Distance),
				filter = bullet.Filter,
				mins = Vector(-bullet.Hull,-bullet.Hull,-bullet.Hull),
				maxs = Vector(bullet.Hull,bullet.Hull,bullet.Hull),
				mask = MASK_SHOT_HULL
			})
			trace = table.Copy(tr)
			FireBullet(bullet,trace)
		else
			local tr = util.TraceLine({
				start = bullet.StartPos,
				endpos = bullet.StartPos+(dir*bullet.Distance),
				filter = bullet.Filter
			})
			trace = table.Copy(tr)
			FireBullet(bullet,trace)
		end
	end
end

function GIGABAT.Functions.Shoot(ship,key)
	local PrimaryMultiFire = ship.primarymultifire
	local SecondaryMultiFire = ship.secondarymultifire
	local ply = ship:GetOwner()
	for a, b in pairs(ship.Weapons) do
		if IsValid(b) then
			if key == IN_ATTACK then
				if b.Slot == "primary" then
					if PrimaryMultiFire then
						b:Shoot(ship)
					else
						if ship.LastPrimaryDelay < CurTime() then
							if ship.PrimaryCurrent == b.Attach then 
								b:Shoot(ship) 
								ship:Alternate("primary")
								ship.LastPrimaryDelay = ship.NextAttack
							end
						end
					end
				end
			end
			if key == IN_ATTACK2  then
				if b.Slot == "secondary" then
					if SecondaryMultiFire then
						b:Shoot(ship)
					else
						if ship.LastSecondaryDelay < CurTime() then
							if ship.SecondaryCurrent == b.Attach then 
								b:Shoot(ship) 
								ship:Alternate("secondary")
								ship.LastSecondaryDelay = ship.NextAttack
							end
						end
					end
				end			
			end
		end
	end
end

function GIGABAT.Functions.AddWeapon(ship,a,b,c)
	if IsValid(ship) then
		local data = GIGABAT.Functions.GetArsenal(a)
		local wep = ents.Create("gigabat_gun")
		wep:SetPos(ship:GetPos())
		wep:SetOwner(ship:GetOwner())
		wep:Spawn()
		wep.Weapon 	= a
		wep.Attach 	= b
		wep.Slot 	= c
		wep.UsesAmmo 	= data.stats.usesammo
		wep.UsesEnergy 	= data.stats.usesenergy
		wep.Energy 		= data.stats.energy
		wep.Ammo 		= data.stats.ammo
		wep.MaxAmmo 	= data.stats.ammo
		wep.ReloadTime 	= data.stats.reload
		wep.Ship = ship
		table.insert(ship.Weapons,wep)
		if c == "primary" then ship.PrimaryCurrent = b table.insert(ship.PrimaryTable,b) end
		if c == "secondary" then ship.SecondaryCurrent = b table.insert(ship.SecondaryTable,b) end
	end
end	