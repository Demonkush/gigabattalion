local function GetSky() 
	if IsValid(GIGABAT.Sky.Edit_Sky) then return GIGABAT.Sky.Edit_Sky end
	for a, b in pairs(ents.FindByClass("edit_sky")) do GIGABAT.Sky.Edit_Sky = b return b end 
end
local function GetSun() 
	if IsValid(GIGABAT.Sky.Edit_Sun) then return GIGABAT.Sky.Edit_Sun end
	for a, b in pairs(ents.FindByClass("edit_sun")) do GIGABAT.Sky.Edit_Sun = b return b end 
end
local function GetFog() 
	if IsValid(GIGABAT.Sky.Edit_Fog) then return GIGABAT.Sky.Edit_Fog end
	for a, b in pairs(ents.FindByClass("edit_fog")) do GIGABAT.Sky.Edit_Fog = b return b end 
end

GIGABAT.Sky = {}
GIGABAT.Sky.Edit_Sky = nil
GIGABAT.Sky.Edit_Sun = nil
GIGABAT.Sky.Edit_Fog = nil

--sky: topcolor, bottomcolor, suncolor, sunsize, duskcolor, duskscale, duskintensity
--sun: sunsize, overlaysize, angles
--fog: fogstart, fogend, density, color
function GIGABAT.Functions.ModifyEnvironment(sky,sun,fog)
	if sky then
		local edit_sky = GetSky()
		if IsValid(edit_sky) then
			edit_sky:SetTopColor( sky.topcolor )
			edit_sky:SetBottomColor( sky.bottomcolor )

			edit_sky:SetSunColor( sky.suncolor )
			edit_sky:SetSunSize( sky.sunsize )

			edit_sky:SetDuskColor( sky.duskcolor )
			edit_sky:SetDuskScale( sky.duskscale )
			edit_sky:SetDuskIntensity( sky.duskintensity )
		end
	end
	if sun then
		local edit_sun = GetSun()
		if IsValid(edit_sun) then
			edit_sun:SetSunSize( sun.sunsize )
			edit_sun:SetSunColor( sun.suncolor )
			edit_sun:SetOverlaySize( sun.overlaysize )
			edit_sun:SetOverlayColor( sun.overlaycolor )
			edit_sun:SetAngles(sun.angles)
		end
	end
	if fog then
		local edit_fog = GetFog()
		if IsValid(edit_fog) then
			edit_fog:Remove()
			GIGABAT.Sky.Edit_Fog = ents.Create("edit_fog")
			local edit_fog = GIGABAT.Sky.Edit_Fog
			edit_fog:SetPos(Vector(0,0,-16000))
			edit_fog:Spawn()
			edit_fog:SetNoDraw(true)
			edit_fog:SetCollisionGroup(COLLISION_GROUP_WORLD)
			edit_fog:SetFogStart( fog.fogstart )
			edit_fog:SetFogEnd( fog.fogend )
			edit_fog:SetDensity( fog.density )
			edit_fog:SetFogColor( fog.color )
		end
	end
end


function GIGABAT.Functions.SetupEnvironment()
	-- SKY
	GIGABAT.Sky.Edit_Sky = ents.Create("edit_sky")
	local sky = GIGABAT.Sky.Edit_Sky
	sky:SetPos(Vector(0,0,-16000))
	sky:Spawn()
	sky:SetNoDraw(true)
	sky:SetCollisionGroup(COLLISION_GROUP_WORLD)
	sky:SetTopColor( Vector( 0, 0, 0 ) )
	sky:SetBottomColor( Vector( 0.1, 0.03, 0.01 ) )

	sky:SetSunColor( Vector( 0.7, 0.6, 0.5 ) )
	sky:SetSunSize( 0.4 )

	sky:SetDuskColor( Vector( 0.2, 0.1, 0 ) )
	sky:SetDuskScale( 0.3 )
	sky:SetDuskIntensity( 0.6 )

	sky:SetDrawStars( false )

	-- SUN
	GIGABAT.Sky.Edit_Sun = ents.Create("edit_sun")
	local sun = GIGABAT.Sky.Edit_Sun
	sun:SetPos(Vector(0,0,-16000))
	sun:Spawn()
	sun:SetNoDraw(true)
	sun:SetCollisionGroup(COLLISION_GROUP_WORLD)
	sun:SetSunSize( 25 )
	sun:SetOverlaySize( 2 )
	sun:SetAngles(Angle(0,155,0))

	-- FOG
	GIGABAT.Sky.Edit_Fog = ents.Create("edit_fog")
	local fog = GIGABAT.Sky.Edit_Fog
	fog:SetPos(Vector(0,0,-16000))
	fog:Spawn()
	fog:SetNoDraw(true)
	fog:SetCollisionGroup(COLLISION_GROUP_WORLD)
	fog:SetFogStart( 1 )
	fog:SetFogEnd( 10000 )
	fog:SetDensity( 0 )
	fog:SetFogColor( Vector( 0, 0, 0 ) )
end