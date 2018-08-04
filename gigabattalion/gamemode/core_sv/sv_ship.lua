function GIGABAT.Functions.SendShipSpec(ply,ent)
	timer.Simple(0.1,function()
		net.Start("GigabatReceiveSpectateShip")
			net.WriteEntity(ent)
		net.Send(ply)
	end)
end

function GIGABAT.Functions.HideShip(ply,ship,toggle)
	net.Start("GigabatSendShipHide")
		net.WriteEntity(ship)
		net.WriteBool(toggle)
	net.Send(ply)
end

function GIGABAT.Functions.StatInitalize(ship)
	if !IsValid(ship) then return end
	local data = GIGABAT.Functions.GetFrame(ship:GetNWString("Gigabat_Frame"))

	ship.Stats = table.Copy(data.stats)

	ship.primarymultifire = ship.Stats.primarymultifire
	ship.secondarymultifire = ship.Stats.secondarymultifire

	ship.Name = data.Name
	ship:SetNWInt("Armor",ship.Stats.hull)
	ship.MaxArmor = ship.Stats.hull
	ship:SetNWInt("Shield",ship.Stats.shield)
	ship.MaxShield 		= ship.Stats.shield
	ship.MaxSpeed 		= ship.Stats.maxspeed
	ship.Acceleration 	= ship.Stats.acceleration
	ship.DragSpeed 		= ship.Stats.dragspeed
	ship.TurnSpeed 		= ship.Stats.turnspeed
	ship:ChangeBoostSound(ship.Stats.enginesound)
end

function GIGABAT.Functions.SetFrame(ent,frame)
	ent:SetNWString("Gigabat_Frame",frame)
end

function GIGABAT.Functions.GetFrame(frame)
	for a, b in pairs(GIGABAT.Frames) do
		if frame == a then return b end
	end
end

local powerups = {"powerup_overdrive","powerup_overpower","powerup_stealth","powerup_repairpack","powerup_ammosupply","powerup_shieldbattery"}
function GIGABAT.Functions.SpawnPowerup(pos)
	local powerup = ents.Create("gigabat_powerup")
	powerup:SetPos(pos)
	powerup:SetAngles(Angle(0,0,0))
	powerup:Spawn()
	local selection = table.Random(powerups)
	powerup.Powerup = selection
	powerup:SetNWString("Powerup",selection)
end