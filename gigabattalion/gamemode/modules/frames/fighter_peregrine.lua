-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"fighter_peregrine",
	"Peregrine",
	"models/gigabattalion/fighter04.mdl",
	{
		primarymultifire = true,
		secondarymultifire = false,
		hull = 135,
		shield = 135,
		maxspeed = 900,
		acceleration = 35,
		dragspeed = 0.35,
		turnspeed = 15,
		enginesound = "ambient/levels/citadel/portal_beam_loop1.wav",
		garagescale = 0.3,
		tokencost = 3
	},
	{
		{weapon="bullet_gatling",attach="gun1",slot="primary"},
		{weapon="bullet_gatling",attach="gun2",slot="primary"},
		{weapon="rocket_hellfire",attach="gun3",slot="secondary"},
		{weapon="rocket_hellfire",attach="gun4",slot="secondary"},
	},
	{
		{effect="gbfx_sprite_thrusteryellow",attach="thruster1"},	
		{effect="gbfx_sprite_thrusteryellow",attach="thruster2"},	
		{effect="gbfx_sprite_thrusteryellowsmall",attach="thruster3"},	
		{effect="gbfx_sprite_thrusteryellowsmall",attach="thruster4"},	
	}
)