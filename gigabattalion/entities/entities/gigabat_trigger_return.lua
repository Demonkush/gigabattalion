ENT.Type = "brush"

function ENT:Initialize()
	self:SetTrigger(true)
end

function ENT:Touch(ent)
	if ent:GetClass() == "gigabat_ship" then
		local ply = ent:GetOwner()
		if IsValid(ply) then
			local ang = (self:GetPos()-ent:GetPos()):Angle()
			ply:SetEyeAngles(Angle(ang.p,ang.y,0))
		end
	end
	local pushables = {"gigabat_asteroid","gigabat_asteroid_attack","gigabat_station","gigabat_debris"}
	if table.HasValue(pushables,ent:GetClass()) then
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocity( (self:GetPos()-phys:GetPos())*55 )
		end
	end
end