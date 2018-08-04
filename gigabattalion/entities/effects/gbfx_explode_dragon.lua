function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local pos = data:GetOrigin()

	local part = emit:Add ("sprites/glow04_noz", pos)
	part:SetVelocity(Vector(0,0,0))
	part:SetDieTime(.5)
	part:SetStartSize(1024)
	part:SetColor( 255, 155, 115 ) 
	part:SetEndSize(0)
	part:SetRoll(math.Rand(0,360))
	part:SetRollDelta(0)
	part:SetAirResistance(0)

	for i=1,5 do
		local part = emit:Add ("particles/flamelet"..math.random(1,3), pos)
		part:SetVelocity(VectorRand()*512)
		part:SetDieTime(1)
		part:SetStartSize(math.random(65,200))
		part:SetColor( 255, 215, 155 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
	end
	for i=1,2 do
		local part = emit:Add ("sprites/glow04_noz", pos)
		part:SetVelocity(VectorRand()*512)
		part:SetDieTime(2)
		part:SetStartSize(math.random(35,100))
		part:SetColor( 255, 155, 115 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
	end
	emit:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end