--[[-------------------------------------------------------------------------
Menu Animations
---------------------------------------------------------------------------]]
GIGABAT.FX = {}
GIGABAT.FX.Panel = nil
local ms_top,ms_bottom = nil,nil
local function ParticleSplash()
	for i=1,100 do
		local size = math.random(128,256)
		local velocity = {x=math.random(-5,5),y=math.random(-2,4)}
		local rot = math.random(0,360)
		local spin = math.random(-25,25)
		local life = math.random(32,96)
		GIGABAT.Functions.Particle(
			{x=math.random(0,ScrW())-(size/2),y=ScrH()/2-(size/2)},
			{w=size,h=size},
			{w=2,h=2},
			{x=velocity.x,y=velocity.y},
			{x=0,y=15},
			rot,spin,
			life,
			Color(255,215,155,255),
			"sprites/glow04_noz"
		)
	end

	GIGABAT.Functions.Particle(
		{x=0,y=ScrH()/2-32},
		{w=ScrW(),h=32},
		{w=0,h=0},
		{x=0,y=0},
		{x=0,y=0},
		0,0,
		128,
		Color(255,215,155,255),
		"vgui/gradient_up"
	)
	GIGABAT.Functions.Particle(
		{x=0,y=ScrH()/2},
		{w=ScrW(),h=32},
		{w=0,h=0},
		{x=0,y=0},
		{x=0,y=0},
		0,0,
		128,
		Color(255,215,155,255),
		"vgui/gradient_down"
	)
end
function GIGABAT.Functions.Transition(mode)
	local function RemoveTransitionPanels()
		if IsValid(GIGABAT.FX.Panel) then
			GIGABAT.FX.Panel:Remove()
			GIGABAT.FX.Panel = nil
		end
		if IsValid(ms_top) then
			ms_top:Remove()
			ms_top = nil
		end
		if IsValid(ms_bottom) then
			ms_bottom:Remove()
			ms_bottom = nil
		end
	end

	local function CreateTransitionPanels()
		RemoveTransitionPanels()
		GIGABAT.FX.Panel = vgui.Create("DFrame")
		GIGABAT.FX.Panel:SetSize(ScrW(),ScrH())
		GIGABAT.FX.Panel:SetPos(0,0)
		GIGABAT.FX.Panel:SetTitle("")
		GIGABAT.FX.Panel:ShowCloseButton(false)
		GIGABAT.FX.Panel.Paint = function(self) end

		ms_top = vgui.Create("DPanel",GIGABAT.FX.Panel)
		ms_top:SetSize(ScrW(),ScrH()/2)
		ms_top:SetPos(0,-ScrH()/2)
		ms_top.Paint = function(self) 
			surface.SetDrawColor(Color(255,255,255,255))
			surface.SetMaterial(Material("gigabattalion/ui/menuswitch_top.png"))
			surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
		end

		local logo = vgui.Create("DImage",ms_top)
		logo:SetPos(ms_top:GetWide()-512,0)
		logo:SetSize(512,256)
		logo:SetImage("gigabattalion/ui/logo.png")

		ms_bottom = vgui.Create("DPanel",GIGABAT.FX.Panel)
		ms_bottom:SetSize(ScrW(),ScrH()/2)
		ms_bottom:SetPos(0,ScrH())
		ms_bottom.Paint = function(self) 
			surface.SetDrawColor(Color(255,255,255,255))
			surface.SetMaterial(Material("gigabattalion/ui/menuswitch_bottom.png"))
			surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
		end
	end

	local function OpenTransition()
		if !IsValid(GIGABAT.FX.Panel) then return end
		ms_top:SetPos(0,0)
		ms_top:AlphaTo(0,1,1)
		ms_top:MoveTo(0,-ScrH()/2,1,0,-1,function() RemoveTransitionPanels() end)

		ms_bottom:SetPos(0,ScrH()/2)
		ms_bottom:AlphaTo(0,1,1)
		ms_bottom:MoveTo(0,ScrH(),1,0,-1)

		surface.PlaySound("plats/hall_elev_door.wav")
	end
	
	local function CloseTransition()
		if !IsValid(GIGABAT.FX.Panel) then return end
		ms_top:SetPos(0,-ScrH()/2)
		ms_top:MoveTo(0,0,1,0,-1)

		ms_bottom:SetPos(0,ScrH())
		ms_bottom:MoveTo(0,ScrH()/2,1,0,-1,
		function() 
			ParticleSplash() 
			surface.PlaySound("doors/door_metal_large_chamber_close1.wav")
		end)
	end

	CreateTransitionPanels()

	if mode == false then
		OpenTransition()
	end

	if mode == true then
		CloseTransition()
	end
end

net.Receive("GigabatSendTransition",function(len,pl)
	local mode = net.ReadBool()
	GIGABAT.Functions.Transition(mode)
end)