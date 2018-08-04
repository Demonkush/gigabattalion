local dmg = FindMetaTable("CTakeDamageInfo")
function dmg:SetDamageStyle(a) dmg.DamageStyle = a end
function dmg:GetDamageStyle() return dmg.DamageStyle end

function GIGABAT.Functions.SendDamage(ply)
	if !IsValid(ply) then return end
	net.Start("GigabatSendDamage") net.Send(ply)
end

function GM:EntityTakeDamage(ent,dmg)
	local dmgtype = dmg:GetDamageStyle()

	if ent:GetClass() == "gigabat_ship" then
		if !ent.SpawnProtection then
			ent.LastAttacker = dmg:GetAttacker()

			if dmg:GetInflictor():GetClass() == "gigabat_asteroid" then
				ent.LastAttacker = dmg:GetInflictor()
			end

			if dmg:GetInflictor():GetClass() == "gigabat_gun" then
				ent.LastAttackerWeapon = GIGABAT.Arsenal[dmg:GetInflictor().Weapon].name
			else
				ent.LastAttackerWeapon = ""
			end
			ent.ShieldNextRegen = CurTime() + 3
			
			local shielddmg = dmg:GetDamage()
			if dmgtype == "ballistic" then shielddmg = math.Round(shielddmg / 1.5) end
			if ent.Powerups.ShieldBattery == false then
				ent:SetNWInt("Shield",math.Clamp(ent:GetNWInt("Shield")-shielddmg,0,ent.MaxShield))
			end
			if ent:GetNWInt("Shield") <= 0 then
				local hulldmg = dmg:GetDamage()
				GIGABAT.Functions.SendDamage(ent:GetOwner())
				if dmgtype == "energy" then hulldmg = math.Round(hulldmg / 1.5) end
				ent:SetNWInt("Armor",ent:GetNWInt("Armor") - hulldmg)
			else
				ent:SVShieldPoke()
			end
			if ent:GetNWInt("Armor") <= 0 then 
				ent:StartExplode()
			end
		end
	end
end