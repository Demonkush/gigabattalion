-- id, name, stats, attack
GIGABAT.Functions.AddArsenal(
	"laser_photon",
	"Photon Laser",
	{
		usesammo = false,
		usesenergy = true,
		ammo = 0,
		energy = 3,
		reload = 3,
		style = "energy",
		dly = 0.2,
	},
	function(gun)
		local ply = gun:GetOwner()
		local ship = ply.Ship

		local fx = EffectData()
		fx:SetOrigin(gun:GetPos())
		fx:SetScale(256)
		util.Effect("gbfx_sprite_muzzleyellow",fx)

		gun:EmitSound("gigabat.laser.shoot",80,175)

		local att = ship
		if IsValid(ply) then att = ply end
		local ang = gun:GetAngles()
		local bullet = {}
		bullet.Attacker 	= att
		bullet.Inflictor 	= gun
		bullet.Damage		= math.random(12,18)
		bullet.Distance 	= 999999
		bullet.Amount 		= 1
		bullet.Spread 		= 0.01
		bullet.Hull 		= 64	
		bullet.StartPos 	= gun:GetPos()
		bullet.Direction 	= -ship:GetAngles():Forward()	
		bullet.Tracer 		= "gbfx_tracer_laseryellow"
		bullet.Impact 		= "gbfx_impact_pulsar_yellow"
		bullet.Filter = function(ent) if ent:GetOwner() != att then return true end end

		GIGABAT.Functions.FireBullet(bullet,att,gun)
	end
)