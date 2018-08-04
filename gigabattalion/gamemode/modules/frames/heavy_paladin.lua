-- id, name, model, stats, loadout(weapon,offset), thrusters
GIGABAT.Functions.AddFrame(
	"heavy_paladin",
	"Paladin",
	"models/gigabattalion/heavy06.mdl",
	{
		primarymultifire = false,
		secondarymultifire = false,
		hull = 100,
		shield = 250,
		maxspeed = 820,
		acceleration = 20,
		dragspeed = 0.35,
		turnspeed = 10,
		enginesound = "ambient/tones/lab_loop1.wav",
		garagescale = 0.25,
		tokencost = 3
	},
	{
		{weapon="laser_photon",attach="gun1",slot="primary"},
		{weapon="laser_photon",attach="gun2",slot="primary"},
		{weapon="laser_photon",attach="gun3",slot="primary"},
		{weapon="laser_photon",attach="gun4",slot="primary"},
		{weapon="beam_photon",attach="gun5",slot="secondary"},
	},
	{
		{effect="gbfx_sprite_thrusterblue_big",attach="thruster1"},	
		{effect="gbfx_sprite_thrusterblue_big",attach="thruster2"},
	}
)