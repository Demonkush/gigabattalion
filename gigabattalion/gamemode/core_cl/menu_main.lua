GIGABAT.Menu = {}
GIGABAT.Menu.Panel = nil
GIGABAT.Menu.Open = false

local menugrad = Material("vgui/gradient_down")
function GIGABAT.Functions.OpenMenu()
	if IsValid(GIGABAT.Panels.SplashScreen) then return end
	if IsValid(GIGABAT.Garage.Core) && GIGABAT.Garage.Core:IsVisible() then return end
	if GIGABAT.Menu.Open == true then return end
	GIGABAT.Menu.Open = true

	GIGABAT.Menu.Panel = vgui.Create("DFrame")
	local frame = GIGABAT.Menu.Panel
	frame:SetSize(ScrW(),2)
	frame:SetPos(0,0)
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame.Paint = function(self)
		surface.SetDrawColor(Color(35,35,35,215))
		surface.SetMaterial(menugrad)
		surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
	end
	frame:SetAlpha(0)
	frame:AlphaTo(255,.2,0)
	frame:SizeTo(ScrW(),128,0.2,0)

	local container = vgui.Create("DScrollPanel",frame)
	container:SetPos(0,0)
	container:SetSize(frame:GetWide(),128)

	local x,y = container:GetWide()/2,container:GetTall()/2-32
	local garage = vgui.Create("DImageButton",container)
	garage:SetSize(96,96)
	garage:SetPos(x-232,y)
	garage:SetImage("gigabattalion/ui/menu_garage.png")
	garage.DoClick = function()
		surface.PlaySound("ui/buttonclickrelease.wav")
		GIGABAT.Functions.CloseMenu()
		if IsValid(GIGABAT.Garage.Core) && GIGABAT.Garage.Core:IsVisible() then return end
		GIGABAT.Functions.OpenGarage()
		net.Start("GigabatOpenedGarage") net.SendToServer()
	end

	local spectate = vgui.Create("DImageButton",container)
	spectate:SetSize(96,96)
	spectate:SetPos(x-48,y)
	spectate:SetImage("gigabattalion/ui/menu_spectate.png")
	spectate.DoClick = function()
		surface.PlaySound("ui/buttonclickrelease.wav")
		GIGABAT.Functions.CloseMenu()
		net.Start("GigabatSpectateRoam") net.SendToServer()
	end

	local options = vgui.Create("DImageButton",container)
	options:SetSize(96,96)
	options:SetPos(x+142,y)
	options:SetImage("gigabattalion/ui/menu_options.png")
	options.DoClick = function()
		surface.PlaySound("ui/buttonclickrelease.wav")
		GIGABAT.Functions.CloseMenu()
		GIGABAT.Functions.OpenOptions()
	end
	gui.EnableScreenClicker(true)
end

function GIGABAT.Functions.CloseMenu()
	if GIGABAT.Menu.Open == false then return end	
	GIGABAT.Menu.Open = false

	if IsValid(GIGABAT.Menu.Panel) then
		GIGABAT.Menu.Panel:AlphaTo(0,1,0,function() GIGABAT.Menu.Panel:Remove() end)
	end

	gui.EnableScreenClicker(false)
end

function GIGABAT.Functions.Menu()
	if GIGABAT.Menu.Open then
		GIGABAT.Functions.CloseMenu()
	else
		GIGABAT.Functions.OpenMenu()
	end
end