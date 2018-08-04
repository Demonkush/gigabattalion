function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local pos = data:GetOrigin()
	
	local part = emit:Add ("sprites/glow04_noz", pos)
	part:SetVelocity(Vector(0,0,0))
	part:SetDieTime(2)
	part:SetStartSize(512)
	part:SetColor( 155, 255, 55 ) 
	part:SetEndSize(512)
	part:SetRoll(math.Rand(0,360))
	part:SetRollDelta(0)
	part:SetAirResistance(0)

	for i=1,15 do
		local part = emit:Add ("sprites/glow04_noz", pos)
		part:SetVelocity(VectorRand()*512)
		part:SetDieTime(2)
		part:SetStartSize(math.random(65,200))
		part:SetColor( 155, 255, 55 ) 
		part:SetEndSize(25)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(55)
	end
	for i=1,15 do
		local part = emit:Add ("sprites/glow04_noz", pos)
		part:SetVelocity(VectorRand()*256)
		part:SetDieTime(4)
		part:SetStartSize(math.random(75,100))
		part:SetColor( 155, 255, 55 ) 
		part:SetEndSize(25)
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