function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local pos = data:GetOrigin()

	local part = emit:Add ("sprites/glow04_noz", pos)
	part:SetVelocity(Vector(0,0,0))
	part:SetDieTime(.5)
	part:SetStartSize(150)
	part:SetColor( 215, 215, 115 ) 
	part:SetEndSize(0)
	part:SetRoll(math.Rand(0,360))
	part:SetRollDelta(0)
	part:SetAirResistance(0)	

	for i=1,3 do 
		local part = emit:Add ("sprites/glow04_noz", pos)
		part:SetVelocity(VectorRand()*1024)
		part:SetDieTime(.25)
		part:SetStartSize(math.random(100,155))
		part:SetColor( 215, 215, 115 ) 
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