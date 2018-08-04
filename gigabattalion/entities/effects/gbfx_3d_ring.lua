function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.Scale = data:GetScale()
	self.Color = data:GetAngles()
	self.Dir = AngleRand():Forward()
	self.Alpha = 75
	self.AlphaRate = 1.1 / (self.Scale)	
	self.Size = 1
end

function EFFECT:Think()
	if self.Size > 75 then
		self.Alpha = self.Alpha - (FrameTime()*(self.AlphaRate*255))
	end
	self.Size = self.Size + ((FrameTime()*768)*self.Scale)
	if self.Alpha < 1 then
		return false
	end

	return true
end

local mat = Material("gigabattalion/fx/ring_normal.png","nocull")
function EFFECT:Render()
	local col = Color(self.Color.p,self.Color.y,self.Color.r,self.Alpha)
	render.SetMaterial(mat)
	render.DrawQuadEasy(self.Pos,self.Dir,self.Size,self.Size,col)
	render.DrawQuadEasy(self.Pos,-self.Dir,self.Size,self.Size,col)
end