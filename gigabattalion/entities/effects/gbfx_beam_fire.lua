local tracermat = Material("gigabattalion/fx/tracer_laser.png")
function EFFECT:Init(data)
	self.StartPos = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.Entity = data:GetEntity()

	self.Width = 128
	self.Life = 768
	self.Decay = 128

	self.OldPos = Vector(0,0,0)

	self.Entity:SetRenderBoundsWS(self.StartPos,self.EndPos)

	local diff = self.EndPos-self.StartPos
	self.Dir = diff:GetNormal()
end

function EFFECT:Think()
	self.Life = self.Life-(FrameTime()*self.Decay)
	if IsValid(self.Entity) then
		self:SetPos(self.Entity:GetPos())
		local tr = util.TraceLine({
			start = self.Entity:GetPos(),
			endpos = self.Entity:GetPos()+(-self.Entity:GetAngles():Forward()*6000),
			filter = function( ent ) if ent:GetOwner() != self.Entity:GetOwner() then return true end end
		})
		self.StartPos = self.Entity:GetPos()
		if self.OldPos == Vector(0,0,0) then
			self.EndPos = tr.HitPos
		else
			self.EndPos = LerpVector(FrameTime()*8,self.OldPos,tr.HitPos)
		end
		self.OldPos = self.EndPos
	else
		return false
	end
	return self.Life > 0
end

function EFFECT:Render()
	render.SetMaterial(tracermat)
	render.DrawBeam(self.StartPos,self.EndPos,self.Width/2,0,1,Color(255,235,215,self.Life))
	render.DrawBeam(self.StartPos,self.EndPos,self.Width*2,0,1,Color(255,155,55,self.Life))
end