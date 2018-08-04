-- id, name, stats, attack
GIGABAT.Functions.AddArsenal(
	"rocket_hellfire",
	"Hellfire Rocket Pod",
	{
		usesammo = true,
		usesenergy = false,
		ammo = 3,
		energy = 0,
		reload = 4,
		style = "ballistic",
		dmg = {5,10},
		dly =0.1,
	},
	function(gun)
		local ply = gun:GetOwner()
		local ship = ply.Ship
		gun:EmitSound("gigabat.rocket.shoot2")

		local rocket = ents.Create("gigabat_ammo_hellfirerocket")
		rocket:SetPos(gun:GetPos()+(-ship:GetForward()*96))
		rocket:SetAngles(ship:GetAngles())
		rocket.Owner = ply
		rocket:SetOwner(ply)
		rocket:Spawn()

		local dir = -(Angle(math.random(-5,5),math.random(-5,5),0)+ship:GetAngles()):Forward()

		local phys = rocket:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableGravity(false)
			phys:AddVelocity(dir*25000)
		end
	end
)