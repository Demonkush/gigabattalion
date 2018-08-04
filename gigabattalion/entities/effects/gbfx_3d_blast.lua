function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.Scale = data:GetScale()
	self.Color = data:GetAngles()

	self.Alpha = 75
	self.AlphaRate = 1.4 / (self.Scale)	
	self.Size = 7

	self.blast = ClientsideModel("models/dav0r/hoverball.mdl",RENDERGROUP_TRANSLUCENT)
	self.blast:SetPos(self.Pos)
	self.blast:SetAngles(AngleRand())
	self.blast:SetMaterial("tdebugwhite")
	self.blast:SetModelScale(self.Size*self.Scale)
	self.blast:SetColor(Color(self.Color.p,self.Color.y,self.Color.r,self.Alpha))
	self.blast:SetRenderMode( RENDERMODE_TRANSALPHA )

	self:DrawShadow(false)
end

function EFFECT:Think()
	if IsValid(self.blast) then
		self.Alpha = self.Alpha - (FrameTime()*(self.AlphaRate*255))
		self.Size = self.Size + (FrameTime()*25)
		if self.Alpha < 1 then
			self.blast:Remove()
			return false
		end
	else
		return false
	end
	return true
end

function EFFECT:Render()
	if IsValid(self.blast) then
		self.blast:SetModelScale(self.Size*self.Scale)
		self.blast:SetColor(Color(self.Color.p,self.Color.y,self.Color.r,self.Alpha))
	end
end