include("shared.lua")
CreateClientConVar("gigabat_effectquality",3,true,false)
CreateClientConVar("gigabat_drawhud","true",true,false)
CreateClientConVar("gigabat_togglechat","true",true,false)

GIGABAT.GameInfo = {}
GIGABAT.GameInfo.scenario = "asteroid_field"
GIGABAT.GameInfo.gametype = "classic"

GIGABAT.Panels.SplashScreen = nil

function GIGABAT.Functions.SplashScreen()
	GIGABAT.Panels.SplashScreen = vgui.Create("DFrame")
	local splash = GIGABAT.Panels.SplashScreen
	splash:SetSize(ScrW(),ScrH())
	splash:SetPos(0,0)
	splash:SetTitle("")
	splash:SetDraggable(false)
	splash:ShowCloseButton(false)
	splash.Paint = function(self)
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end

	local logo = vgui.Create("DImage",splash)
	logo:SetImage("gigabattalion/ui/credits.png")
	logo:SizeToContents()
	logo:Center()

	timer.Create("SplashParticles",0.025,256,function()
		if IsValid(splash) then
			local size = math.random(2,24)
			local velocity = {x=math.random(-45,45),y=0}
			local life = math.random(128,256)
			GIGABAT.Functions.Particle(
				{x=math.random(0,ScrW()),y=math.random(0,ScrH())},
				{w=size*10,h=size},
				{w=0,h=0},
				{x=velocity.x,y=velocity.y},
				{x=0,y=0},
				0,0,
				life,
				Color(155,215,255,255),
				"sprites/glow04_noz"
			)
		end
	end)

	timer.Simple(5,function()
		logo:AlphaTo(0,2,0,function()  
			GIGABAT.Functions.OpenGarage()
			timer.Simple(2,function() splash:Remove() end)
		end)
	end)
end
GIGABAT.Functions.SplashScreen()

--[[-------------------------------------------------------------------------
FONTS
---------------------------------------------------------------------------]]
surface.CreateFont("GBShipMenuFont",{
	font = "Tahoma",
	extended = false,
	size = 50,
	weight = 750,
})

surface.CreateFont("GBShipMenuFontSmall",{
	font = "Tahoma",
	extended = false,
	size = 25,
	weight = 500,
})