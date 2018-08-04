-- id, name, stats, attack
GIGABAT.Functions.AddArsenal(
	"laser_heavydelta",
	"Heavy Delta Laser",
	{
		usesammo = false,
		usesenergy = true,
		ammo = 0,
		energy = 8,
		reload = 3,
		style = "energy",
		dly = 0.5,
	},
	function(gun)
		local ply = gun:GetOwner()
		local ship = ply.Ship

		local fx = EffectData()
		fx:SetOrigin(gun:GetPos())
		fx:SetScale(256)
		util.Effect("gbfx_sprite_muzzlered",fx)

		gun:EmitSound("gigabat.laser.heavyshoot",80,175)

		local att = ship
		if IsValid(ply) then att = ply end
		local ang = gun:GetAngles()
		local bullet = {}
		bullet.Attacker 	= att
		bullet.Inflictor 	= gun
		bullet.Damage		= 50
		bullet.Distance 	= 999999
		bullet.Amount 		= 1
		bullet.Spread 		= 0.01
		bullet.Hull 		= 64	
		bullet.Force 		= 90
		bullet.StartPos 	= gun:GetPos()
		bullet.Direction 	= -ship:GetAngles():Forward()	
		bullet.Tracer 		= "gbfx_tracer_laserred"
		bullet.Impact 		= "gbfx_impact_pulsar_red"
		bullet.Filter = function(ent) if ent:GetOwner() != att then return true end end

		GIGABAT.Functions.FireBullet(bullet,att,gun)
	end
)