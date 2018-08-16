-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"heavy_orion",
	"Orion",
	"models/gigabattalion/heavy08.mdl",
	{
		primarymultifire = true,
		secondarymultifire = true,
		hull = 250,
		shield = 150,
		maxspeed = 830,
		acceleration = 30,
		dragspeed = 0.25,
		turnspeed = 15,
		enginesound = "ambient/levels/citadel/field_loop2.wav",
		garagescale = 0.2,
		tokencost = 3
	},
	{
		{weapon="pulsar_basic",attach="gun1",slot="primary"},
		{weapon="pulsar_basic",attach="gun2",slot="primary"},
		{weapon="pulsar_basic",attach="gun3",slot="primary"},
		{weapon="pulsar_basic",attach="gun4",slot="primary"},
		{weapon="blaster_arc",attach="gun5",slot="secondary"},
		{weapon="blaster_arc",attach="gun6",slot="secondary"},
	},
	{
		{effect="gbfx_sprite_thrusterwhite",attach="thruster1"},	
		{effect="gbfx_sprite_thrusterwhite",attach="thruster2"},
		{effect="gbfx_sprite_thrusterwhite_big",attach="thruster3"},
	}
)