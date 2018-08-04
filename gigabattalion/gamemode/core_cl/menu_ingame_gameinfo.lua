GIGABAT.IngameInfo = {}
GIGABAT.IngameInfo.Panel = nil

function GIGABAT.Functions.IngameInfo()
	GIGABAT.IngameInfo.Panel = vgui.Create("DFrame")
	local igi = GIGABAT.IngameInfo.Panel
	igi:SetSize(640,100)
	igi:SetTitle("")
	igi:SetDraggable(false)
	igi:ShowCloseButton(false)
	igi:SetPos(0,100)
	igi:CenterHorizontal()
	igi:SetAlpha(0)
	igi:AlphaTo(255,1,0)
	igi.Paint = function() end

	local scenariotxt = vgui.Create("DLabel",igi)
	scenariotxt:SetFont("GBShipMenuFontSmall")
	scenariotxt:SetText("")
	scenariotxt:SetPos(0,32)
	scenariotxt:CenterHorizontal()

	local gametypetxt = vgui.Create("DLabel",igi)
	gametypetxt:SetFont("GBShipMenuFontSmall")
	gametypetxt:SetText("")
	gametypetxt:SetPos(0,64)
	gametypetxt:CenterHorizontal()

	local function BuildTxt(pnl,txt,dly)
		local count = 0
		if !IsValid(pnl) then return end
		local r = math.random(1,999999)
		timer.Create("GigabatIFITimer"..r,dly,#txt,function()
			if IsValid(igi) then
				count = count + 1
				pnl:SetText(pnl:GetText()..""..txt[count])
				pnl:SizeToContents()
				pnl:CenterHorizontal()
			end
		end)
	end

	local scenarioname = GIGABAT.Scenario[GIGABAT.Config.Scenario].name
	BuildTxt(scenariotxt,"Now Entering: "..scenarioname,0.1)
	BuildTxt(gametypetxt,"Mission: "..GIGABAT.Config.ObjectiveTask,0.1)

	timer.Simple(7,function() igi:AlphaTo(0,1,0,function() igi:Remove() end) end)
end
net.Receive("GigabatSendIngameInfoText",function()
	GIGABAT.Functions.IngameInfo()
end)