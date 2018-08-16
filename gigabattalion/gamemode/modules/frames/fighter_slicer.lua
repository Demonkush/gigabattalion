-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"fighter_slicer",
	"Slicer",
	"models/gigabattalion/fighter03.mdl",
	{
		primarymultifire = false,
		secondarymultifire = false,
		hull = 85,
		shield = 85,
		maxspeed = 915,
		acceleration = 25,
		dragspeed = 0.25,
		turnspeed = 20,
		enginesound = "ambient/levels/citadel/portal_beam_loop1.wav",
		garagescale = 0.32,
		tokencost = 3
	},
	{
		{weapon="pulsar_photon",attach="gun1",slot="primary"},
		{weapon="pulsar_photon",attach="gun2",slot="primary"},
		{weapon="pulsar_photon",attach="gun3",slot="primary"},
		{weapon="blaster_photon",attach="gun4",slot="secondary"},
		{weapon="blaster_photon",attach="gun5",slot="secondary"},
	},
	{
		{effect="gbfx_sprite_thrusteryellow",attach="thruster1"},	
		{effect="gbfx_sprite_thrusteryellowsmall",attach="thruster2"},	
		{effect="gbfx_sprite_thrusteryellowsmall",attach="thruster3"},	
	}
)