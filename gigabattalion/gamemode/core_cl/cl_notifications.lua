GIGABAT.Notifications = {}
function GIGABAT.Functions.Notification(data)
	local txt = data.txt
	local dly = math.Clamp(#txt/2,2,7)
	local color = data.color

	for k, v in pairs(GIGABAT.Notifications) do
		if IsValid(v) then
			local x,y = v:GetPos()
			v:MoveTo(x,y-40,1,0)
		end
	end

	local frame = vgui.Create("DFrame")
	frame:SetTitle("")
	frame:SetPos(0,ScrH()-200)
	frame:ShowCloseButton(false)
	frame:SetDraggable(false)
	frame:SetAlpha(0)
	frame:AlphaTo(255,0.5,0)
	frame:AlphaTo(0,1,dly,function() frame:Remove() table.RemoveByValue(GIGABAT.Notifications,frame) end)
	frame.Paint = function(self) 
		surface.SetDrawColor(Color(color.x,color.y,color.z,215))
		surface.DrawRect(0,0,self:GetWide(),self:GetTall())

		surface.SetDrawColor(Color(155,155,155,215))
		surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
	end
	table.insert(GIGABAT.Notifications,frame)

	local function BuildTxt(pnl,txt,dly)
		local count = 0
		if !IsValid(pnl) then return end
		local r = math.random(1,999999)
		timer.Create("GigabatIFITimer"..r,dly,#txt,function()
			if IsValid(frame) then
				count = count + 1
				pnl:SetText(pnl:GetText()..""..txt[count])
				pnl:SizeToContents()
				pnl:CenterHorizontal()
			end
		end)
	end

	local label = vgui.Create("DLabel",frame)
	label:SetText(txt)
	label:SetFont("GBShipMenuFontSmall")
	label:SizeToContents()
	frame:SetSize(label:GetWide()+32,32)
	label:Center()
	frame:CenterHorizontal()
	label:SetText("")

	BuildTxt(label,txt,0.075)
end
net.Receive("GigabatSendNotification",function(len,pl)
	local a = net.ReadString()
	local b = net.ReadVector()
	GIGABAT.Functions.Notification({txt=a,color=b})	
end)