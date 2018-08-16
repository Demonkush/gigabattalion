GIGABAT.Scoreboard = {}
GIGABAT.Scoreboard.Panel = nil

function GIGABAT.Functions.OpenScoreboard()
	if IsValid(GIGABAT.Scoreboard.Panel) then
		GIGABAT.Scoreboard.Panel:Remove()
	end

	GIGABAT.Scoreboard.Panel = vgui.Create("DFrame")
	local frame = GIGABAT.Scoreboard.Panel
	frame:SetSize(640,2)
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame:SetDraggable(false)
	frame:SetPos(ScrW()/2-320,ScrH()/2)
	frame:MakePopup()
	frame.Paint = function(self)
		surface.SetDrawColor(Color(0,25,35,215))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())
	end
	frame:SizeTo(
		640,
		480,
		.5
	)
	frame:MoveTo(
		ScrW()/2-320,
		ScrH()/2-240,
		.5
	)
	for i=1,32 do
		GIGABAT.Functions.Particle(
			{x=ScrW()/2-1024,y=ScrH()/2-32},
			{w=2048,h=32},
			{w=0,h=0},
			{x=0,y=6/i},
			{x=0,y=0},
			0,0,
			75/i,
			Color(155,215,255,255),
			"sprites/glow04_noz"
		)
		GIGABAT.Functions.Particle(
			{x=ScrW()/2-1024,y=ScrH()/2},
			{w=2048,h=32},
			{w=0,h=0},
			{x=0,y=-6/i},
			{x=0,y=0},
			0,0,
			75/i,
			Color(155,215,255,255),
			"sprites/glow04_noz"
		)
	end

	local title = vgui.Create("DLabel",frame)
	title:SetText("GIGABATTALION v"..GIGABAT.Config.Version)
	title:SetFont("DermaLarge")
	title:SizeToContents()
	title:SetPos(0,5)
	title:CenterHorizontal()
	local author = vgui.Create("DLabel",frame)
	author:SetText("Created by Demonkush")
	author:SetFont("DermaDefaultBold")
	author:SizeToContents()
	author:SetPos(0,32)
	author:CenterHorizontal()

	local plist = vgui.Create("DScrollPanel",frame)
	plist:SetSize(frame:GetWide()-10,383)
	plist:SetPos(5,90)
	plist.Paint = function(self) end
	local sbar = plist:GetVBar()
	function sbar:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(0,0,0,215)) end
	function sbar.btnUp:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(25,25,25)) end
	function sbar.btnDown:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(25,25,25)) end
	function sbar.btnGrip:Paint(w,h) draw.RoundedBox(0,0,0,w,h,Color(45,45,45)) end
	
	local margin = 0
	local labels = vgui.Create("DLabel",frame)
	labels:SetText("Score - Tokens - Ping")
	labels:SetFont("GBShipMenuFontSmall")
	labels:SizeToContents()
	labels:SetPos(frame:GetWide()-labels:GetWide()-32,64)
	for a, b in pairs(player.GetAll()) do
		local playercard = vgui.Create("DPanel",plist)
		playercard:SetPos(5,margin)
		playercard:SetSize(frame:GetWide()-10,64)
		playercard.Paint = function(self)
			if IsValid(b) then
				surface.SetDrawColor(team.GetColor(b:Team()))
				surface.DrawRect(0,0,self:GetWide(),self:GetTall())
			end
		end
		local avatar = vgui.Create("AvatarImage",playercard)
		avatar:SetPos(2,2)
		avatar:SetSize(60,60)
		avatar:SetPlayer(b,64)
		local avatar_button = vgui.Create("DButton",playercard)
		avatar_button:SetPos(2,2)
		avatar_button:SetSize(60,60)
		avatar_button:SetText("")
		avatar_button.DoClick = function() b:ShowProfile() end
		avatar_button.Paint = function() end

		local label = vgui.Create("DLabel",playercard)
		label:SetFont("DermaLarge")
		label:SetText(b:Name())
		label:SizeToContents()
		label:SetPos(70,2)
		local data = GIGABAT.Frames[b:GetNWString("Gigabat_Frame")]
		local label = vgui.Create("DLabel",playercard)
		label:SetFont("GBShipMenuFontSmall")
		label:SetText(data.name)
		label:SizeToContents()
		label:SetPos(70,34)

		local numar = 420
		local score = vgui.Create("DLabel",playercard)
		score:SetFont("GBShipMenuFontSmall")
		score:SetText(b:GetNWInt("Gigabat_Score"))
		score:SizeToContents()
		score:SetPos(numar,32)
		numar = numar + 80
		local token = vgui.Create("DLabel",playercard)
		token:SetFont("GBShipMenuFontSmall")
		token:SetText(b:GetNWInt("Gigabat_Tokens"))
		token:SizeToContents()
		token:SetPos(numar,32)
		numar = numar + 70
		local ping = vgui.Create("DLabel",playercard)
		ping:SetFont("GBShipMenuFontSmall")
		ping:SetText(b:Ping())
		ping:SizeToContents()
		ping:SetPos(numar,32)

		playercard.Think = function()
			if IsValid(b) then
				score:SetText(b:GetNWInt("Gigabat_Score"))
				score:SizeToContents()
				token:SetText(b:GetNWInt("Gigabat_Tokens"))
				token:SizeToContents()
				ping:SetText(b:Ping())
				ping:SizeToContents()
			end
		end

		margin = margin + 70
	end

	gui.EnableScreenClicker(true)
end

function GIGABAT.Functions.CloseScoreboard()
	if IsValid(GIGABAT.Scoreboard.Panel) then
		GIGABAT.Scoreboard.Panel:AlphaTo(0,0.25,0,function() GIGABAT.Scoreboard.Panel:Remove() end)
	end

	if IsValid(GIGABAT.Garage.Container) then return end
	gui.EnableScreenClicker(false)
end




function GM:ScoreboardShow()
	if IsValid(GIGABAT.Starmap.Panel) then return end
	GIGABAT.Functions.OpenScoreboard()
end

function GM:ScoreboardHide()
	GIGABAT.Functions.CloseScoreboard()
end