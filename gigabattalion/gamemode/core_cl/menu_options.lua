GIGABAT.Panels.Options = nil

function GIGABAT.Functions.OpenOptions()
	local frame = vgui.Create("DFrame")
	frame:SetSize(640,480)
	frame:ShowCloseButton()
	frame:SetTitle("")
	frame:SetDraggable(false)
	frame:Center()
	frame.Paint = function(self)
		surface.SetDrawColor(Color(0,0,0,215))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end
	frame:SetAlpha(0)
	frame:AlphaTo(255,0.25,0)

	local title = vgui.Create("DLabel",frame)
	title:SetTextColor(Color(255,255,255,255))
	title:SetPos(5,5)
	title:SetText("Options")
	title:SetFont("DermaLarge")
	title:SizeToContents()

	local container = vgui.Create("DScrollPanel",frame)
	container:SetPos(0,32)
	container:SetSize(frame:GetWide(),frame:GetTall()-64)

	local margin = 0
	local function CreateCheckBox(parent,x,y,a,b)
		local checked = GetConVar(b):GetString()
		local icon = Material("icon16/cross.png")
		if checked == "true" then icon = Material("icon16/accept.png") end
		local checkbox = vgui.Create("DButton",parent)
		checkbox:SetPos(x,y+margin)
		checkbox:SetSize(32,32)
		checkbox:SetText("")
		checkbox.DoClick = function()
			if checked == "true" then
				checked = "false"
				GetConVar(b):SetString("false")
				icon = Material("icon16/cross.png")
			elseif checked == "false" then
				checked = "true"
				GetConVar(b):SetString("true")
				icon = Material("icon16/accept.png")
			end
		end
		checkbox.Paint = function(self)
			surface.SetDrawColor(Color(55,55,55,55))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
			surface.SetDrawColor(Color(155,155,155,155))
			surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
			surface.SetDrawColor(Color(255,255,255,255))
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
		end
		local label = vgui.Create("DLabel",parent)
		label:SetPos(x+40,y+margin+2)
		label:SetFont("GBShipMenuFontSmall")
		label:SetText(a)
		label:SizeToContents()
		margin = margin + 40
	end

	CreateCheckBox(container,32,32,"Toggle Crosshair",		"gigabat_crosshair")
	CreateCheckBox(container,32,32,"Toggle Crosshair Lead",	"gigabat_crosshairlead")
	CreateCheckBox(container,32,32,"Toggle HUD",			"gigabat_drawhud")
	CreateCheckBox(container,32,32,"Toggle Chatbox",		"gigabat_togglechat")

	local exit = vgui.Create("DButton",frame)
	exit:SetText("Exit")
	exit:SetFont("DermaLarge")
	exit:SizeToContents()
	exit:SetPos(frame:GetWide()-exit:GetWide(),5)
	exit:SetTextColor(Color(255,255,255,255))
	exit.OnCursorEntered = function() surface.PlaySound("garrysmod/ui_hover.wav") end
	exit.DoClick = function() frame:AlphaTo(0,0.5,0,function() frame:Remove() gui.EnableScreenClicker(false) end) end
	exit.Paint = function(self)
		if self:IsHovered() then
			self:SetTextColor(Color(255,55,55,255))
		else
			self:SetTextColor(Color(255,255,255,255))
		end
	end

	gui.EnableScreenClicker(true)
end