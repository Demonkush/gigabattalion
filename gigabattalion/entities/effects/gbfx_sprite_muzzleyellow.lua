function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local pos = data:GetOrigin()
	local scale = data:GetScale()
	
	local part = emit:Add ("sprites/glow04_noz", pos)
	part:SetVelocity(Vector(0,0,0))
	part:SetDieTime(0.1+(scale/768))
	part:SetStartSize(scale)
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