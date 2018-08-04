-- id, name, stats, attack
GIGABAT.Functions.AddArsenal(
	"bullet_gatling",
	"Gatling",
	{
		usesammo = true,
		usesenergy = false,
		ammo = 60,
		energy = 0,
		reload = 3,
		style = "ballistic",
		dmg = {5,10},
		dly = 0.1,
	},
	function(gun)
		local ply = gun:GetOwner()
		local ship = ply.Ship

		gun:EmitSound("gigabat.gatling.shoot")

		local att = gun
		if IsValid(ply) then att = ply end
		local ang = gun:GetAngles()
		local bullet = {}
		bullet.Num 	= 1
		bullet.Src 	= gun:GetPos()
		bullet.Dir 	= -ship:GetAngles():Forward()
		bullet.Spread 	= Vector(0.03,0.03,0)
		bullet.Tracer	= 1
		bullet.TracerName = "AirboatGunHeavyTracer"
		bullet.Force	= 1
		bullet.Damage	= math.random(4,7)
		bullet.Callback = function(abc,tr,dmg)
			dmg:SetAttacker(att)
			if tr.Entity:GetOwner() == ply then
				dmg:SetDamage(0)
			end
		end

		gun:FireBullets(bullet)
	end
)