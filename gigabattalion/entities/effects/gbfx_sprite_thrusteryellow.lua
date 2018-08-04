function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local pos = data:GetOrigin()
	local scale = data:GetScale()
	local dir = data:GetNormal()
	local length = data:GetRadius()

	if length > 50 then
		pos = pos + (-dir*(length))
	end

	local part = emit:Add ("sprites/glow04_noz", pos)
	if length > 50 then
		part:SetVelocity(dir*(length*8))
		part:SetDieTime(math.Clamp(length/scale/2,0.3,0.5))
		part:SetStartSize((length+scale)/5)
		part:SetStartLength(length*3)
	else
		part:SetVelocity(dir*scale)
		part:SetDieTime(0.5)
		part:SetStartSize(scale/5)
	end
	part:SetColor( 255, 235, 155 ) 
	part:SetEndSize(0)
	part:SetRoll(math.Rand(0,360))
	part:SetRollDelta(0)
	part:SetAirResistance(0)

	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end