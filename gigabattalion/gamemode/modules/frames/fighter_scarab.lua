-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"fighter_scarab",
	"Scarab",
	"models/gigabattalion/heavy03.mdl",
	{
		primarymultifire = false,
		secondarymultifire = false,
		hull = 235,
		shield = 120,
		maxspeed = 865,
		acceleration = 40,
		dragspeed = 0.4,
		turnspeed = 15,
		enginesound = "ambient/machines/turbine_loop_1.wav",
		garagescale = 0.25,
		tokencost = 3
	},
	{
		{weapon="pulsar_photon",attach="gun1",slot="primary"},
		{weapon="pulsar_photon",attach="gun2",slot="primary"},
		{weapon="pulsar_photon",attach="gun3",slot="primary"},
		{weapon="pulsar_photon",attach="gun4",slot="primary"},
		{weapon="pulsar_photon",attach="gun5",slot="primary"},
		{weapon="pulsar_photon",attach="gun6",slot="primary"},
		{weapon="mine_seeker",attach="gun7",slot="secondary"},
	},
	{
		{effect="gbfx_sprite_thrusteryellow",attach="thruster1"},	
		{effect="gbfx_sprite_thrusteryellow",attach="thruster2"},
		{effect="gbfx_sprite_thrusteryellow",attach="thruster3"},	
		{effect="gbfx_sprite_thrusteryellow",attach="thruster4"},
	}
)