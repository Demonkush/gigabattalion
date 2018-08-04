function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local pos = data:GetOrigin()
	
	local part = emit:Add ("sprites/glow04_noz", pos)
	part:SetVelocity(Vector(0,0,0))
	part:SetDieTime(1)
	part:SetStartSize(512)
	part:SetColor( 255, 115, 115 ) 
	part:SetEndSize(0)
	part:SetRoll(math.Rand(0,360))
	part:SetRollDelta(0)
	part:SetAirResistance(0)

	for i=1,25 do
		local part = emit:Add ("sprites/glow04_noz", pos)
		part:SetVelocity(VectorRand()*1024)
		part:SetDieTime(2)
		part:SetStartSize(math.random(35,100))
		part:SetColor( 255, 115, 115 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
	end
	for i=1,10 do
		local part = emit:Add ("sprites/glow04_noz", pos)
		part:SetVelocity(VectorRand()*1024)
		part:SetDieTime(2)
		part:SetStartSize(math.random(35,55))
		part:SetColor( 255, 115, 115 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(155)
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end