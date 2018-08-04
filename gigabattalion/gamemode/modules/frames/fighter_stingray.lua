-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"fighter_stingray",
	"Stingray",
	"models/gigabattalion/fighter01.mdl",
	{
		primarymultifire = true,
		secondarymultifire = false,
		hull = 95,
		shield = 100,
		maxspeed = 935,
		acceleration = 15,
		dragspeed = 0.375,
		turnspeed = 15,
		enginesound = "ambient/levels/citadel/portal_beam_loop1.wav",
		garagescale = 0.32,
		tokencost = 0
	},
	{
		{weapon="pulsar_basic",attach="gun1",slot="primary"},
		{weapon="pulsar_basic",attach="gun2",slot="primary"},
		{weapon="pulsar_basic",attach="gun3",slot="primary"},
		{weapon="pulsar_basic",attach="gun4",slot="primary"},
		{weapon="blaster_arc",attach="gun5",slot="secondary"},
	},
	{
		{effect="gbfx_sprite_thrusterblue",attach="thruster1"},	
	}
)