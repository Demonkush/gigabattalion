-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"heavy_dragon",
	"Dragon",
	"models/gigabattalion/heavy05.mdl",
	{
		primarymultifire = false,
		secondarymultifire = false,
		hull = 195,
		shield = 135,
		maxspeed = 855,
		acceleration = 30,
		dragspeed = 0.25,
		turnspeed = 17,
		enginesound = "npc/combine_gunship/dropship_engine_distant_loop1.wav",
		garagescale = 0.25,
		tokencost = 3
	},
	{
		{weapon="pulsar_delta",attach="gun1",slot="primary"},
		{weapon="pulsar_delta",attach="gun2",slot="primary"},
		{weapon="ship_dragon",attach="gun3",slot="secondary"},	
	},
	{
		{effect="gbfx_sprite_thrusterred",attach="thruster1"},	
		{effect="gbfx_sprite_thrusterred",attach="thruster2"},
		{effect="gbfx_sprite_thrusterred",attach="thruster3"},	
	}
)