GIGABAT.Functions.AddGametype("classic",
	"Classic",
	{
		"asteroid_field",
		"derelict",
		"derelict2",
		"metalith",
	},
	function()
		GIGABAT.Config.ObjectiveTitle = "Destroy"
		GIGABAT.Config.ObjectiveTask = "Gain score by destroying asteroids and players!"

		GIGABAT.Config.Round.SpawnPowerups = true
		GIGABAT.Config.Round.SpawnAsteroids = true
		GIGABAT.Config.Round.SpawnAttackAsteroids = true
		GIGABAT.Config.Round.SpawnStars = true
		GIGABAT.Config.Round.ScoreFromAsteroids = 1
		GIGABAT.Config.Round.ScoreFromKills = 5
		
		GIGABAT.Functions.CreateSpawns()
	end,
	function(ply)
		for k, v in pairs(player.GetAll()) do
			GIGABAT.Functions.PlayerSpawn(v)
		end
	end)