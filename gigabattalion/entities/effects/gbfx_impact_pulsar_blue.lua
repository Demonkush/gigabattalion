function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local pos = data:GetOrigin()

	local part = emit:Add ("sprites/glow04_noz", pos)
	part:SetVelocity(Vector(0,0,0))
	part:SetDieTime(.25)
	part:SetStartSize(100)
	part:SetColor( 155, 215, 255 ) 
	part:SetEndSize(0)
	part:SetRoll(math.Rand(0,360))
	part:SetRollDelta(0)
	part:SetAirResistance(0)	

	for i=1,5 do 
		local part = emit:Add ("sprites/glow04_noz", pos)
		part:SetVelocity(VectorRand()*128)
		part:SetDieTime(.5)
		part:SetStartSize(math.random(35,55))
		part:SetColor( 155, 215, 255 ) 
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