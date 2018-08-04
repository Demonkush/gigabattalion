local ang = Angle(0,0,0)
local sky = nil
hook.Add("PostDraw2DSkyBox","GIGABATDrawSky",function()
	cam.Start3D( Vector( 0, 0, 0 ),EyeAngles() )
		if IsValid(sky) then
			render.Model({model=sky:GetModel(),pos=Vector(0,0,0),angle=ang},sky)
		else
			sky = ClientsideModel("models/gigabattalion/space_sphere.mdl",RENDERGROUP_TRANSLUCENT)
		end
		ang = ang + Angle(FrameTime()/10,ang.y,ang.r)
	cam.End3D()
end)