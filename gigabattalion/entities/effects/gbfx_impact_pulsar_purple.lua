function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local pos = data:GetOrigin()

	local part = emit:Add ("sprites/glow04_noz", pos)
	part:SetVelocity(Vector(0,0,0))
	part:SetDieTime(.5)
	part:SetStartSize(512)
	part:SetColor( 155, 115, 255 ) 
	part:SetEndSize(0)
	part:SetRoll(math.Rand(0,360))
	part:SetRollDelta(0)
	part:SetAirResistance(0)	

	for i=1,15 do 
		local part = emit:Add ("sprites/glow04_noz", pos)
		part:SetVelocity(VectorRand()*256)
		part:SetDieTime(1)
		part:SetStartSize(math.random(55,75))
		part:SetColor( 155, 115, 255 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(55)
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end