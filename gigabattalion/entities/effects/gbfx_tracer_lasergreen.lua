local tracermat = Material("gigabattalion/fx/tracer_laser.png")
function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()

	self.Width = 32
	self.Life = 255
	self.Decay = 1024

	self.Entity:SetRenderBoundsWS(self.StartPos,self.EndPos)

	local diff = self.EndPos-self.StartPos
	self.Dir = diff:GetNormal()
end

function EFFECT:Think()
	self.Life = self.Life-(FrameTime()*self.Decay)
	return self.Life > 0
end

function EFFECT:Render()
	render.SetMaterial(tracermat)
	render.DrawBeam(self.StartPos,self.EndPos,self.Width,0,1,Color(155,255,115,self.Life))
end