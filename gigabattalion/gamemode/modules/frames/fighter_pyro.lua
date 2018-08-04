-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"fighter_pyro",
	"Pyro",
	"models/gigabattalion/fighter08.mdl",
	{
		primarymultifire = true,
		secondarymultifire = true,
		hull = 145,
		shield = 115,
		maxspeed = 875,
		acceleration = 20,
		dragspeed = 0.25,
		turnspeed = 20,
		enginesound = "npc/combine_gunship/engine_rotor_loop1.wav",
		garagescale = 0.35,
		tokencost = 3
	},
	{
		{weapon="pulsar_photon",attach="gun1",slot="primary"},
		{weapon="pulsar_photon",attach="gun2",slot="primary"},
		{weapon="ship_pyro",attach="gun3",slot="secondary"},
		{weapon="ship_pyro",attach="gun4",slot="secondary"},
	},
	{
		{effect="gbfx_sprite_thrusterred",attach="thruster1"},	
		{effect="gbfx_sprite_thrusterred",attach="thruster2"},	
	}
)