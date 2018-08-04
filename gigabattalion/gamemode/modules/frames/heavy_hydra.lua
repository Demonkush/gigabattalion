-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"heavy_hydra",
	"Hydra",
	"models/gigabattalion/heavy04.mdl",
	{
		primarymultifire = false,
		secondarymultifire = true,
		hull = 250,
		shield = 125,
		maxspeed = 835,
		acceleration = 30,
		dragspeed = 0.3,
		turnspeed = 10,
		enginesound = "npc/combine_gunship/dropship_onground_loop1.wav",
		garagescale = 0.25,
		tokencost = 3
	},
	{
		{weapon="laser_heavyplasma",attach="gun1",slot="primary"},
		{weapon="laser_heavyplasma",attach="gun2",slot="primary"},
		{weapon="laser_heavyplasma",attach="gun3",slot="primary"},
		{weapon="blaster_plasma",attach="gun4",slot="secondary"},
		{weapon="blaster_plasma",attach="gun5",slot="secondary"},		
	},
	{
		{effect="gbfx_sprite_thrustergreen",attach="thruster1"},	
		{effect="gbfx_sprite_thrustergreen",attach="thruster2"},
		{effect="gbfx_sprite_thrustergreen",attach="thruster3"},	
		{effect="gbfx_sprite_thrustergreen",attach="thruster4"},
	}
)