-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"fighter_piranha",
	"Piranha",
	"models/gigabattalion/fighter07.mdl",
	{
		primarymultifire = false,
		secondarymultifire = false,
		hull = 100,
		shield = 125,
		maxspeed = 890,
		acceleration = 20,
		dragspeed = 0.3,
		turnspeed = 25,
		enginesound = "ambient/levels/citadel/field_loop2.wav",
		garagescale = 0.25,
		tokencost = 3
	},
	{
		{weapon="blaster_plasma",attach="gun1",slot="primary"},
		{weapon="blaster_plasma",attach="gun2",slot="primary"},
		{weapon="rocket_seeker",attach="gun3",slot="secondary"},	
	},
	{
		{effect="gbfx_sprite_thrusterblue",attach="thruster1"},	
		{effect="gbfx_sprite_thrusterblue",attach="thruster2"},
	}
)