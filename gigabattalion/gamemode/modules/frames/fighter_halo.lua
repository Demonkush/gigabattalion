-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"fighter_halo",
	"Halo",
	"models/gigabattalion/fighter05.mdl",
	{
		primarymultifire = false,
		secondarymultifire = false,
		hull = 125,
		shield = 125,
		maxspeed = 880,
		acceleration = 20,
		dragspeed = 0.25,
		turnspeed = 15,
		enginesound = "ambient/levels/citadel/field_loop2.wav",
		garagescale = 0.35,
		tokencost = 3
	},
	{
		{weapon="laser_heavyplasma",attach="gun1",slot="primary"},
		{weapon="laser_heavyplasma",attach="gun2",slot="primary"},
		{weapon="blaster_plasma",attach="gun3",slot="secondary"},
	},
	{
		{effect="gbfx_sprite_thrusterred",attach="thruster1"},	
		{effect="gbfx_sprite_thrusterred",attach="thruster2"},	
	}
)