local tracermat = Material("gigabattalion/fx/tracer_pulse.png")
function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()

	self.Length = 1024
	self.Speed = 16000
	self.Time = 0

	self.Entity:SetRenderBoundsWS(self.StartPos,self.EndPos)

	local diff = self.EndPos-self.StartPos
	self.Dir = diff:GetNormal()
	self.Life = (diff:Length()+self.Length)/self.Speed
end

function EFFECT:Think()
	self.Life = self.Life-FrameTime()
	self.Time = self.Time+FrameTime()
	return self.Life > 0
end

function EFFECT:Render()
	local tracerEnd = self.Speed*self.Time
	local tracerStart = tracerEnd-self.Length
	
	tracerStart = math.max(0,tracerStart)
	tracerEnd = math.max(0,tracerEnd)

	local startPos = self.StartPos+self.Dir*tracerStart
	local endPos = self.StartPos+self.Dir*tracerEnd

	render.SetMaterial(tracermat)
	render.DrawBeam(startPos,endPos,64,0,1,Color(255,115,115,255))

	render.SetMaterial(tracermat)
	render.DrawBeam(startPos,endPos,32,0,1,Color(255,215,215,125))
end