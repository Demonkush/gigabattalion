function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local pos = data:GetOrigin()
	local scale = data:GetScale()
	local dir = data:GetNormal()
	local length = data:GetRadius()

	if length > 50 then
		pos = pos + (-dir*(length)*2)
	end

	local part = emit:Add ("sprites/glow04_noz", pos)
	if length > 50 then
		part:SetVelocity(dir*(length*32))
		part:SetDieTime(math.Clamp(length/scale/2,0.1,0.3))
		part:SetStartSize((length+scale)/4)
		part:SetStartLength(length*6)
	else
		part:SetVelocity(dir*scale)
		part:SetDieTime(0.2)
		part:SetStartSize(scale)
	end
	part:SetColor( 155, 215, 255 ) 
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