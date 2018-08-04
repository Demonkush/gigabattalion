GIGABAT.ScoreNotifications = {}
function GIGABAT.Functions.ScoreNotification(score)
	local dly = math.Clamp(#score/4,2,7)

	for k, v in pairs(GIGABAT.ScoreNotifications) do
		if IsValid(v) then
			local x,y = v:GetPos()
			v:MoveTo(x,y-40,1,0)
		end
	end

	local frame = vgui.Create("DFrame")
	frame:SetTitle("")
	frame:SetPos(0,ScrH()/2-200)
	frame:ShowCloseButton(false)
	frame:SetDraggable(false)
	frame:SetAlpha(0)
	frame:AlphaTo(255,0.5,0)
	frame:AlphaTo(0,1,dly,function() frame:Remove() table.RemoveByValue(GIGABAT.ScoreNotifications,frame) end)
	frame.Paint = function(self) end
	table.insert(GIGABAT.ScoreNotifications,frame)

	local label = vgui.Create("DLabel",frame)
	label:SetText("+"..score)
	label:SetFont("GBShipMenuFontSmall")
	label:SizeToContents()
	frame:SetSize(label:GetWide()+32,32)
	label:Center()
	frame:CenterHorizontal()
end
net.Receive("GigabatSendScoreNotification",function(len,pl)
	local a = net.ReadString()
	GIGABAT.Functions.ScoreNotification(a)	
end)