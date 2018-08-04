-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"heavy_golem",
	"Golem",
	"models/gigabattalion/heavy07.mdl",
	{
		primarymultifire = false,
		secondarymultifire = false,
		hull = 175,
		shield = 125,
		maxspeed = 810,
		acceleration = 40,
		dragspeed = 0.2,
		turnspeed = 20,
		enginesound = "npc/combine_gunship/engine_rotor_loop1.wav",
		garagescale = 0.25,
		tokencost = 3
	},
	{
		{weapon="shotgun_delta",attach="gun1",slot="primary"},
		{weapon="rocket_concussion",attach="gun2",slot="secondary"},
		{weapon="rocket_concussion",attach="gun3",slot="secondary"},
		{weapon="rocket_concussion",attach="gun4",slot="secondary"},
		{weapon="rocket_concussion",attach="gun5",slot="secondary"},		
	},
	{
		{effect="gbfx_sprite_thrusterred",attach="thruster1"},	
		{effect="gbfx_sprite_thrusterred",attach="thruster2"},
		{effect="gbfx_sprite_thrusterred",attach="thruster3"},	
		{effect="gbfx_sprite_thrusterred",attach="thruster4"},
	}
)