-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"heavy_cerberus",
	"Cerberus",
	"models/gigabattalion/heavy02.mdl",
	{
		primarymultifire = false,
		secondarymultifire = false,
		hull = 275,
		shield = 175,
		maxspeed = 825,
		acceleration = 25,
		dragspeed = 0.25,
		turnspeed = 10,
		enginesound = "npc/combine_gunship/engine_rotor_loop1.wav",
		garagescale = 0.25,
		tokencost = 3
	},
	{
		{weapon="laser_heavyplasma",attach="gun1",slot="primary"},
		{weapon="laser_heavyplasma",attach="gun2",slot="primary"},
		{weapon="laser_heavyplasma",attach="gun3",slot="primary"},
		{weapon="mine_seeker",attach="gun4",slot="secondary"},
	},
	{
		{effect="gbfx_sprite_thrustergreen",attach="thruster1"},	
		{effect="gbfx_sprite_thrustergreen",attach="thruster2"},
	}
)