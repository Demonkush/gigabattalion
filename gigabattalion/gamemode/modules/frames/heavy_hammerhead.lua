-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"heavy_hammerhead",
	"Hammerhead",
	"models/gigabattalion/heavy01.mdl",
	{
		primarymultifire = false,
		secondarymultifire = false,
		hull = 200,
		shield = 125,
		maxspeed = 850,
		acceleration = 15,
		dragspeed = 0.22,
		turnspeed = 18,
		enginesound = "ambient/tones/lab_loop1.wav",
		garagescale = 0.25,
		tokencost = 3
	},
	{
		{weapon="laser_heavypurple",attach="gun1",slot="primary"},
		{weapon="laser_heavypurple",attach="gun2",slot="primary"},
		{weapon="rocket_hellfire",attach="gun3",slot="secondary"},
		{weapon="rocket_hellfire",attach="gun4",slot="secondary"},
	},
	{
		{effect="gbfx_sprite_thrusterpurple",attach="thruster1"},	
		{effect="gbfx_sprite_thrusterpurple",attach="thruster2"},
	}
)