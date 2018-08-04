--[[-------------------------------------------------------------------------
2D Particle System
---------------------------------------------------------------------------]]
GIGABAT.Particles = {}

function GIGABAT.Functions.ClearAllParticles()
	for a,b in pairs(GIGABAT.Particles) do
		if IsValid(b) then
			b:Remove()
			b = nil
		end
	end
	table.Empty(GIGABAT.Particles)
end

function GIGABAT.Functions.Particle(a,b,c,d,e,f,g,h,i,j)
	local part = vgui.Create("DFrame")
	part:SetTitle("") part:SetDraggable(false) part:ShowCloseButton(false)
	part.pos 		= a
	part.size 		= b
	part.shrink 	= c
	part.vel 		= d
	part.gravity 	= e
	part.rot 		= f
	part.spin 		= g
	part.life 		= h
	part.col 		= i
	part.spr 		= Material(j)
	part:SetPos(part.pos.x-(part.size.w/2),part.pos.y-(part.size.h/2))
	part:SetSize(part.size.w,part.size.h)
	part.Paint = function(self)
		surface.SetDrawColor(self.col)
		surface.SetMaterial(self.spr)
		surface.DrawTexturedRectRotated(self.size.w/2,self.size.h/2,self.size.w,self.size.h,self.rot)
	end
	part.Think = function() GIGABAT.Functions.ParticleThink(part) end

	table.insert(GIGABAT.Particles,part)
end
function GIGABAT.Functions.TestParticle()
	GIGABAT.Functions.Particle({x=ScrW()/2,y=ScrH()/2},{w=64,h=64},{w=1,h=1},{x=3,y=1},{x=0,y=1},5,5,256,Color(255,155,55,255),"sprites/glow04_noz")
end
function GIGABAT.Functions.ParticleThink(part)
	if IsValid(part) then
		part.life = part.life - FrameTime()*100
		if part.life < 0 then
			part:Remove()
			table.RemoveByValue(GIGABAT.Particles,part)
		end
	end

	if IsValid(part) then
		part.pos.x = part.pos.x + (FrameTime()*part.vel.x*100)
		part.pos.y = part.pos.y + (FrameTime()*part.vel.y*100)

		if part.shrink.w != 0 then
			part.size.w = math.Clamp(part.size.w - part.shrink.w,0,math.huge)
		end
		if part.shrink.h != 0 then
			part.size.h = math.Clamp(part.size.h - part.shrink.h,0,math.huge)
		end

		part:SetPos(part.pos.x,part.pos.y)

		part.vel.x = part.vel.x + (part.gravity.x/100)
		part.vel.y = part.vel.y + (part.gravity.y/100)

		part.col.a = part.life
		part.rot = part.rot + part.spin
	end
end