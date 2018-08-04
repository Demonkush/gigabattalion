function EFFECT:Init(data)
	self.ent = data:GetEntity()
	self.emit = ParticleEmitter(data:GetOrigin())
	self.pos = data:GetOrigin()
	self.scale = data:GetScale()
	self.dir = data:GetNormal()
	self.Life = 100
end

function EFFECT:Think()
	if IsValid(self.ent) then
		self.pos = self.ent:GetPos()
		self.dir = -(self.ent:GetAngles()+Angle(math.random(-2,2),math.random(-2,2),0)):Forward()
	end
	self.Life = self.Life - (FrameTime()*100)
	local part = self.emit:Add ("sprites/glow04_noz", self.pos)
	part:SetVelocity(self.dir*4096)
	part:SetDieTime(1)
	part:SetStartSize(math.random(32,64)+self.scale)
	part:SetColor( 255, 215, 155 ) 
	part:SetEndSize(0)
	part:SetRoll(math.Rand(0,360))
	part:SetRollDelta(math.random(-1,1))
	part:SetAirResistance(0)
	for i=1, 2 do
		local part = self.emit:Add ("particles/flamelet"..math.random(1,3), self.pos+(VectorRand()*6))
		part:SetVelocity(self.dir*4096)
		part:SetDieTime(1)
		part:SetStartSize(8)
		part:SetColor( 255, 235, 215 ) 
		part:SetEndSize(math.random(96,128)+self.scale)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(math.random(-1,1))
		part:SetAirResistance(0)
	end
	if self.Life <= 0 then
		self.emit:Finish()
		return false
	end
	return true
end

function EFFECT:Render()
end