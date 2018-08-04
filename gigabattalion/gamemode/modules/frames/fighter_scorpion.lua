-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"fighter_scorpion",
	"Scorpion",
	"models/gigabattalion/fighter06.mdl",
	{
		primarymultifire = false,
		secondarymultifire = false,
		hull = 125,
		shield = 120,
		maxspeed = 870,
		acceleration = 20,
		dragspeed = 0.4,
		turnspeed = 20,
		enginesound = "npc/dog/dog_idlemode_loop1.wav",
		garagescale = 0.3,
		tokencost = 3
	},
	{
		{weapon="shotgun_delta",attach="gun1",slot="primary"},
		{weapon="shotgun_delta",attach="gun2",slot="primary"},
		{weapon="laser_heavydelta",attach="gun3",slot="secondary"},
	},
	{
		{effect="gbfx_sprite_thrusterred",attach="thruster1"},	
		{effect="gbfx_sprite_thrusterred",attach="thruster2"},	
	}
)