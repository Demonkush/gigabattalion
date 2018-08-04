function EFFECT:Init(data)
	local emit = ParticleEmitter(data:GetOrigin())
	local pos = data:GetOrigin()
	local scale = data:GetScale()

	local part = emit:Add ("sprites/glow04_noz", pos)
	part:SetVelocity(Vector(0,0,0))
	part:SetDieTime(2)
	part:SetStartSize(scale*512)
	part:SetColor( 255, 215, 195 ) 
	part:SetEndSize(0)
	part:SetRoll(math.Rand(0,360))
	part:SetRollDelta(0)
	part:SetAirResistance(0)

	for i=1,scale*10 do
		local part = emit:Add ("sprites/glow04_noz", pos)
		part:SetVelocity(VectorRand()*(scale*512))
		part:SetDieTime(4)
		part:SetStartSize(math.random(35,150))
		part:SetColor( 255, 215, 155 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
	end
	for i=1,scale*5 do
		local part = emit:Add ("sprites/glow04_noz", pos)
		part:SetVelocity(VectorRand()*scale*512)
		part:SetDieTime(7)
		part:SetStartSize(math.random(105,250))
		part:SetColor( 255, 215, 155 ) 
		part:SetEndSize(0)
		part:SetRoll(math.Rand(0,360))
		part:SetRollDelta(0)
		part:SetAirResistance(0)
	end
	for i=1,scale*3 do
		local part = emit:Add ("sprites/glow04_noz", pos)
		part:SetVelocity(VectorRand()*scale*1024)
		part:SetDieTime(2)
		part:SetStartSize(math.random(105,250))
		part:SetStartLength(1024)
		part:SetColor( 255, 215, 155 ) 
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