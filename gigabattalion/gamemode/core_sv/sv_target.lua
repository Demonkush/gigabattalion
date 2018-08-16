function GIGABAT.Functions.SendTarget(ply,ent)
	if !IsValid(ply) then return end
	ply.gb_Target = ent
	if IsValid(ply.Ship) then ply.Ship.NextUpdateTarget = CurTime() + GIGABAT.Config.TargetUpdateInterval end
	net.Start("GigabatReceiveTarget")
		net.WriteEntity(ent)
	net.Send(ply)
end

function GIGABAT.Functions.UpdateTarget(ply)
	if !IsValid(ply.gb_Target) then return end
	if ply.gb_Target:GetClass() == "gigabat_ship" then
		if ply.gb_Target.Powerups.Stealth then return end
	end
	local ship = ply.Ship
	if IsValid(ship) then
		local dir = (ship:GetPos()-ply.gb_Target:GetPos())
		local tr = util.QuickTrace(ship:GetPos(),-dir*999999,function(ent) if ent:GetOwner() != ply then return true end end)
		if IsValid(tr.Entity) then
			if tr.Entity != ply.gb_Target then
				GIGABAT.Functions.ClearTarget(ply)
			end
		else
			GIGABAT.Functions.ClearTarget(ply)
		end
	end
end

function GIGABAT.Functions.TraceTarget(ply)
	local ship = ply.Ship
	if IsValid(ship) then
		local tr = util.TraceHull({
			start = ship:GetPos(),
			endpos = ply:EyeAngles():Forward()*999999,
			filter = function(ent) if ent:GetOwner() != ply then return true end end,
			mins = Vector( -128, -128, -128 ),
			maxs = Vector( 128, 128, 128 ),
			mask = MASK_SHOT_HULL
		})
		if IsValid(tr.Entity) then
			if table.HasValue(GIGABAT.Config.TargetableEntities,tr.Entity:GetClass()) then
				if tr.Entity:GetClass() == "gigabat_ship" then
					if tr.Entity.Powerups.Stealth then return end
					if tr.Entity.SpawnProtection then return end
				end
				if tr.Entity == ply.gb_Target then
					GIGABAT.Functions.ClearTarget(ply)
				else
					GIGABAT.Functions.SendTarget(ply,tr.Entity)
					return
				end
			else
				GIGABAT.Functions.ClearTarget(ply)
			end
		else	
			GIGABAT.Functions.ClearTarget(ply)
		end
	end
end

function GIGABAT.Functions.ClearTarget(ply)
	ply.gb_Target = nil
	net.Start("GigabatReceiveTarget") net.Send(ply)
end