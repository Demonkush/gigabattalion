--[[-------------------------------------------------------------------------
Configuration ( defaults, might be modified by gametypes )
---------------------------------------------------------------------------]]
-- DEFAULT SHIP SETTINGS --
GIGABAT.Config.DefaultShip = "fighter_stingray"
GIGABAT.Config.DefaultSkin = "common"

-- GAME SETTINGS --
GIGABAT.Config.ScorePerToken = 25 -- How much score does a player need to gain a token?
GIGABAT.Config.RespawnDuration = 5 -- How long does it take for a player to respawn?
GIGABAT.Config.TargetUpdateInterval = 3 -- How long to check if you have lost your target?

GIGABAT.Config.GlobalSpeed 		= 0     -- Modifies base ship speed.  (Add)
GIGABAT.Config.GlobalBoostSpeed = 2     -- Modifies ship boost speed. (Multiply)
GIGABAT.Config.GlobalDragSpeed 	= 0     -- Modifies ship drag speed.  (Add)

GIGABAT.Config.CollideInstakill = true  -- Should you die instantly on extreme collision?
GIGABAT.Config.InfiniteAmmo 	= false -- Should weapons drain energy / ammo?
GIGABAT.Config.InfiniteFuel 	= false -- Should afterburner drain fuel?