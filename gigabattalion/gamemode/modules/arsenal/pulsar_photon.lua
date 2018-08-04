-- id, name, stats, attack
GIGABAT.Functions.AddArsenal(
	"pulsar_photon",
	"Photon Pulsar",
	{
		usesammo = false,
		usesenergy = true,
		ammo = 0,
		energy = 0.5,
		reload = 3,
		style = "energy",
		dly = 0.1,
	},
	function(gun)
		local ply = gun:GetOwner()
		local ship = ply.Ship

		local fx = EffectData()
		fx:SetOrigin(gun:GetPos())
		fx:SetScale(64)
		util.Effect("gbfx_sprite_muzzleyellow",fx)

		gun:EmitSound("gigabat.laser.shoot",80,80)

		local att = ship
		if IsValid(ply) then att = ply end
		local ang = gun:GetAngles()
		local bullet = {}
		bullet.Attacker 	= att
		bullet.Inflictor 	= gun
		bullet.Damage		= math.random(5,7)
		bullet.Distance 	= 16000
		bullet.Amount 		= 1
		bullet.Spread 		= 0.2
		bullet.Hull 		= 32	
		bullet.StartPos 	= gun:GetPos()
		bullet.Direction 	= -ship:GetAngles():Forward()	
		bullet.Tracer 		= "gbfx_tracer_pulseyellow"
		bullet.Impact 		= "gbfx_impact_pulsar_yellow"
		bullet.Filter = function(ent) if ent:GetOwner() != att then return true end end
		
		GIGABAT.Functions.FireBullet(bullet,att,gun)
	end
)