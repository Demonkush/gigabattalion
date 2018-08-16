GIGABAT.Functions.AddGametype("rally",
	"Rally",
	{
		"startrack",
		"derelict2",
		"phaseway"
	},
	function()
		GIGABAT.Config.ObjectiveTitle = "Follow the Waypoints"
		GIGABAT.Config.ObjectiveTask = "Finish laps by following the waypoints!"
		GIGABAT.Config.GlobalSpeed 		= 2
		GIGABAT.Config.GlobalBoostSpeed = 4
		GIGABAT.Config.GlobalDragSpeed 	= 0.2	
		GIGABAT.Config.Round.SpawnAttackAsteroids = true
		GIGABAT.Config.Round.SpawnStars = true
		GIGABAT.Config.Round.ScoreFromKills = 5
	end,
	function()
		for k, v in pairs(player.GetAll()) do
			GIGABAT.Functions.PlayerSpawn(v)
		end

		GIGABAT.Functions.SpawnWaypoints()
	end)