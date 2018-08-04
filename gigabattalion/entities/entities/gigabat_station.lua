ENT.Type = "anim"

if SERVER then 
	AddCSLuaFile() 

	function ENT:Initialize()
		self.Entity:SetModel("models/gigabattalion/spacestation.mdl")
		self.Entity:SetColor(Color(255,255,255,255))
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)	
		self.Entity:SetSolid(SOLID_VPHYSICS)

		self:SetCollisionGroup(COLLISION_GROUP_NONE)

		local phys = self.Entity:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableGravity(false)
			phys:Wake()
		end
	end

	function ENT:Think()
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:AddAngleVelocity((self:GetUp()*-1)+(self:GetRight()*1)+(self:GetForward()*-1))
		end
		self:NextThink(CurTime()+0.01)
		return true
	end
end