-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"fighter_bumblebee",
	"Bumblebee",
	"models/gigabattalion/fighter02.mdl",
	{
		primarymultifire = false,
		secondarymultifire = false,
		hull = 95,
		shield = 125,
		maxspeed = 935,
		acceleration = 20,
		dragspeed = 0.4,
		turnspeed = 25,
		enginesound = "npc/manhack/mh_engine_loop1.wav",
		garagescale = 0.35,
		tokencost = 3
	},
	{
		{weapon="pulsar_delta",attach="gun1",slot="primary"},
		{weapon="pulsar_delta",attach="gun2",slot="primary"},
		{weapon="pulsar_delta",attach="gun3",slot="primary"},
		{weapon="pulsar_delta",attach="gun4",slot="primary"},
	},
	{
		{effect="gbfx_sprite_thrusterred",attach="thruster1"},	
	}
)