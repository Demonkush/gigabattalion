-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"fighter_witch",
	"Witch",
	"models/gigabattalion/fighter09.mdl",
	{
		primarymultifire = false,
		secondarymultifire = false,
		hull = 105,
		shield = 95,
		maxspeed = 915,
		acceleration = 20,
		dragspeed = 0.35,
		turnspeed = 20,
		enginesound = "ambient/machines/turbine_loop_1.wav",
		garagescale = 0.25,
		tokencost = 3
	},
	{
		{weapon="laser_heavypurple",attach="gun1",slot="primary"},
		{weapon="laser_heavypurple",attach="gun2",slot="primary"},
		{weapon="laser_heavypurple",attach="gun3",slot="primary"},
		{weapon="laser_heavypurple",attach="gun4",slot="primary"},
		{weapon="rocket_darkmatter",attach="gun5",slot="secondary"},
	},
	{
		{effect="gbfx_sprite_thrusterpurple",attach="thruster1"},	
		{effect="gbfx_sprite_thrusterpurple",attach="thruster2"},	
	}
)