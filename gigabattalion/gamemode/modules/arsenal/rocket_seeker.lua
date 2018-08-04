-- id, name, stats, attack
GIGABAT.Functions.AddArsenal(
	"rocket_seeker",
	"Seeker Rocket",
	{
		usesammo = true,
		usesenergy = false,
		ammo = 3,
		energy = 0,
		reload = 3,
		style = "ballistic",
		dmg = {5,10},
		dly = 0.5,
	},
	function(gun)
		local ply = gun:GetOwner()
		local ship = ply.Ship
		gun:EmitSound("gigabat.rocket.shoot")

		local rocket = ents.Create("gigabat_ammo_seekerrocket")
		rocket:SetPos(gun:GetPos()+(-ship:GetForward()*96))
		rocket:SetAngles(ship:GetAngles())
		rocket.Owner = ply
		rocket:SetOwner(ply)
		rocket:Spawn()

		local phys = rocket:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableGravity(false)
			phys:AddVelocity(-ship:GetForward()*15000)
		end
	end
)