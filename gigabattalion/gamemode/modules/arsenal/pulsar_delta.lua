-- id, name, stats, attack
GIGABAT.Functions.AddArsenal(
	"pulsar_delta",
	"Delta Pulsar",
	{
		usesammo = false,
		usesenergy = true,
		ammo = 0,
		energy = 1,
		reload = 3,
		style = "energy",
		dly = 0.15,
	},
	function(gun)
		local ply = gun:GetOwner()
		local ship = ply.Ship

		local fx = EffectData()
		fx:SetOrigin(gun:GetPos())
		fx:SetScale(64)
		util.Effect("gbfx_sprite_muzzlered",fx)

		gun:EmitSound("gigabat.laser.shoot",80,80)

		local att = ship
		if IsValid(ply) then att = ply end
		local ang = gun:GetAngles()
		local bullet = {}
		bullet.Attacker 	= att
		bullet.Inflictor 	= gun
		bullet.Damage		= math.random(12,14)
		bullet.Distance 	= 16000
		bullet.Amount 		= 1
		bullet.Spread 		= 0.25
		bullet.Hull 		= 32	
		bullet.Force 		= 25
		bullet.StartPos 	= gun:GetPos()
		bullet.Direction 	= -ship:GetAngles():Forward()	
		bullet.Tracer 		= "gbfx_tracer_pulsered"
		bullet.Impact 		= "gbfx_impact_pulsar_red"
		bullet.Filter = function(ent) if ent:GetOwner() != att then return true end end

		GIGABAT.Functions.FireBullet(bullet,att,gun)
	end
)