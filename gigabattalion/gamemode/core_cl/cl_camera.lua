GIGABAT.Camera = {}
GIGABAT.Camera.Ship = nil
GIGABAT.Camera.Target = nil
GIGABAT.Camera.Zoom = 1000
local oldang = Angle(0,0,0)
local oldpos = Vector(0,0,0)
local function SendCockpitSwitch(bool)
	net.Start("GigabatSendCockpitSwitch")
		net.WriteBool(bool)
	net.SendToServer()
end
function GM:PlayerBindPress(ply,bind,pressed)
	if bind == "invnext" then GIGABAT.Camera.Zoom = math.Clamp(GIGABAT.Camera.Zoom+100,100,4096) end
	if bind == "invprev" then GIGABAT.Camera.Zoom = math.Clamp(GIGABAT.Camera.Zoom-100,100,4096) end
end
local ignore = {"gigabat_ship","gigabat_gun"}
local function GigabatCalcview(ply,pos,angles,fov)
	local view = {}
	local ship = GIGABAT.Camera.Ship
	if IsValid(ship) then
		local dir = (angles:Up()*(GIGABAT.Camera.Zoom/4))+(angles:Forward()*-GIGABAT.Camera.Zoom)
		local tr = util.QuickTrace(ship:GetPos(),dir,function(ent) if !table.HasValue(ignore,ent:GetClass()) then return true end end)
		pos = LerpVector(FrameTime()*10,oldpos,tr.HitPos)

		view.origin = LerpVector(FrameTime(),oldpos,pos)
		view.angles = LerpAngle(FrameTime(),oldang,angles)
		view.fov = fov
		view.drawviewer = false

		oldang = angles
		oldpos = pos
	end
	return view
end
hook.Add("CalcView","GigabatCalcview",GigabatCalcview)

net.Receive("GigabatReceiveSpectateShip",function(len,pl)
	local a = net.ReadEntity()
	if !IsValid(a) then return end
	GIGABAT.Camera.Ship = a
	GIGABAT.Functions.StopMotionBlur()
end)

net.Receive("GigabatReceiveTarget",function(len,pl)
	local a = net.ReadEntity()
	if !IsValid(a) then GIGABAT.Camera.Target = nil return end
	GIGABAT.Camera.Target = a
end)

net.Receive("GigabatSendShipHide",function(len,pl)
	local ship = net.ReadEntity()
	local toggle = net.ReadBool()
	if IsValid(ship) then
		if toggle == true then
			if IsValid(ship.Body) then ship:RemoveBody() end
		else
			if !IsValid(ship.Body) then ship:CreateBody() end
		end
	end
end)