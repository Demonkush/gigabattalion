ENT.Type = "anim"

if SERVER then 
	AddCSLuaFile() 
	function ENT:Initialize()
		self.Entity:SetModel("models/weapons/W_missile_launch.mdl")
		self.Entity:SetColor(Color(255,255,255,255))
		self.Entity:PhysicsInit(SOLID_NONE)
		self.Entity:SetMoveType(MOVETYPE_NONE)	
		self.Entity:SetSolid(SOLID_NONE)
	end
end

if CLIENT then
	function ENT:Draw()

	end
end