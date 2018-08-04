GM.Name = "GIGABATTALION"
GM.Author = "Demonkush"
GM.Website = "http://www.tachyongaming.net"

AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")


function GM:PlayerFootstep() return true end

-- SHARED
GIGABAT = {}
GIGABAT.Config = {}
AddCSLuaFile("sh_config.lua")
include("sh_config.lua")

GIGABAT.Functions = {}
GIGABAT.Languages = {}
GIGABAT.Panels = {}

GIGABAT.Frames = {}
GIGABAT.Arsenal = {}
GIGABAT.Gametypes = {}
GIGABAT.Scenario = {}
GIGABAT.Skins = {}

GIGABAT.Config.Version = "1.0"

GIGABAT.Config.GameType = "classic"
GIGABAT.Config.Scenario = "asteroid_field"

GIGABAT.Config.ObjectiveTitle = "Objective"
GIGABAT.Config.ObjectiveTask = "Complete the Objective!"

GIGABAT.Config.TargetableEntities = {
	"gigabat_ship",
	"gigabat_asteroid",
	"gigabat_debris",
	"gigabat_asteroid_attack"
}

team.SetUp(1,"Mercenaries",Color(75,75,75))
team.SetUp(2,"The Federation",Color(75,0,0))
team.SetUp(3,"The Coalition",Color(0,55,75))

local gmname = "gigabattalion"
if SERVER then
	local cl_add = file.Find(gmname.."/gamemode/core_cl/*","LUA")
	for cla,clb in pairs(cl_add) do
		AddCSLuaFile(gmname.."/gamemode/core_cl/"..clb)
	end
	local sv_load = file.Find(gmname.."/gamemode/core_sv/*","LUA")
	for sva,svb in pairs(sv_load) do
		include(gmname.."/gamemode/core_sv/"..svb)
	end
end
if CLIENT then
	local cl_load = file.Find(gmname.."/gamemode/core_cl/*","LUA")
	for cla,clb in pairs(cl_load) do
		include(gmname.."/gamemode/core_cl/"..clb)
	end
end

--[[-------------------------------------------------------------------------
FRAMES
---------------------------------------------------------------------------]]
function GIGABAT.Functions.AddFrame(id,a,b,c,d,e)
	GIGABAT.Frames[id] = {name=a,model=b,stats=c,loadout=d,thrusters=e}
end

local frameload = file.Find(gmname.."/gamemode/modules/frames/*","LUA")
for framea,frameb in pairs(frameload) do
	AddCSLuaFile(gmname.."/gamemode/modules/frames/"..frameb)
	include(gmname.."/gamemode/modules/frames/"..frameb)
end

--[[-------------------------------------------------------------------------
ARSENAL
---------------------------------------------------------------------------]]
function GIGABAT.Functions.AddArsenal(id,a,b,c)
	GIGABAT.Arsenal[id] = {name=a,stats=b,attack=c}
end

local arsload = file.Find(gmname.."/gamemode/modules/arsenal/*","LUA")
for arsa,arsb in pairs(arsload) do
	AddCSLuaFile(gmname.."/gamemode/modules/arsenal/"..arsb)
	include(gmname.."/gamemode/modules/arsenal/"..arsb)
end

--[[-------------------------------------------------------------------------
SKINS
---------------------------------------------------------------------------]]
function GIGABAT.Functions.AddSkin(id,a,b,c)
	GIGABAT.Skins[id] = {name=a,tokencost=b,textures=c}
end

function GIGABAT.Functions.GetSkin(skin)
	for a, b in pairs(GIGABAT.Skins) do
		if skin == a then
			return b
		end
	end
end

function GIGABAT.Functions.ApplySkin(ent,skin)
	local skin = GIGABAT.Functions.GetSkin(skin)

	local path = "gigabattalion/skins/"
	local mdl = ent:GetModel()
	mdl = string.TrimRight(mdl,".mdl") mdl = string.TrimLeft(mdl,"models/gigabattalion/")
	mdl = "gigabattalion/models/"..mdl
	for a, b in pairs(ent:GetMaterials()) do
		ent:SetSubMaterial(a-1,nil)
		if b == mdl.."/hulltest" then
			ent:SetSubMaterial(a-1,path..skin.textures.hull)
		end
		if b == mdl.."/engine_trim" then
			ent:SetSubMaterial(a-1,path..skin.textures.engine)
		end
		if b == mdl.."/satellite_ring" then
			ent:SetSubMaterial(a-1,path..skin.textures.trim)
		end
		if b == mdl.."/windowtest" then
			ent:SetSubMaterial(a-1,path..skin.textures.window)
		end
	end
end

local skinload = file.Find(gmname.."/gamemode/modules/skins/*","LUA")
for skina,skinb in pairs(skinload) do
	AddCSLuaFile(gmname.."/gamemode/modules/skins/"..skinb)
	include(gmname.."/gamemode/modules/skins/"..skinb)
end

--[[-------------------------------------------------------------------------
GAMETYPES
---------------------------------------------------------------------------]]
function GIGABAT.Functions.AddGametype(id,a,b,c,d)
	GIGABAT.Gametypes[id] = {name=a,scenarios=b,oninit=c,onround=d}
end

local gtload = file.Find(gmname.."/gamemode/modules/gametypes/*","LUA")
for gta,gtb in pairs(gtload) do
	AddCSLuaFile(gmname.."/gamemode/modules/gametypes/"..gtb)
	include(gmname.."/gamemode/modules/gametypes/"..gtb)
end

-- Round Configuration ( modified by gametypes )
GIGABAT.Config.Round = {}
GIGABAT.Config.Round.TeamBased = false
GIGABAT.Config.Round.SurvivalEnabled = false
GIGABAT.Config.Round.SurvivalWaves = 0
GIGABAT.Config.Round.SurvivalWave = 0
GIGABAT.Config.Round.SpawnPowerups = false
GIGABAT.Config.Round.SpawnAsteroids = false
GIGABAT.Config.Round.SpawnAttackAsteroids = false
GIGABAT.Config.Round.SpawnStars = false
GIGABAT.Config.Round.ScoreFromAsteroids = 0
GIGABAT.Config.Round.ScoreFromKills = 0
GIGABAT.Config.Round.ScoreFromLives = 0

--[[-------------------------------------------------------------------------
SCENARIO
---------------------------------------------------------------------------]]
function GIGABAT.Functions.AddScenario(id,a,b,c)
	GIGABAT.Scenario[id] = {name=a,starpos=b,oninit=c}
end

local sceneload = file.Find(gmname.."/gamemode/modules/scenario/*","LUA")
for scenea,sceneb in pairs(sceneload) do
	AddCSLuaFile(gmname.."/gamemode/modules/scenario/"..sceneb)
	include(gmname.."/gamemode/modules/scenario/"..sceneb)
end