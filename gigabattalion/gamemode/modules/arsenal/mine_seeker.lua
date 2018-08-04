-- id, name, stats, attack
GIGABAT.Functions.AddArsenal(
	"mine_seeker",
	"Seeker Mine",
	{
		usesammo = true,
		usesenergy = false,
		ammo = 2,
		energy = 0,
		reload = 7,
		style = "ballistic",
		dly =0.5,
	},
	function(gun)
		local ply = gun:GetOwner()
		local ship = ply.Ship

		local mine = ents.Create("gigabat_ammo_spacemine")
		mine:SetPos(gun:GetPos())
		mine:SetAngles(AngleRand())
		mine.Owner = ply
		mine:SetOwner(ply)
		mine:Spawn()

		local dir = (Angle(math.random(-5,5),math.random(-5,5),0)+ship:GetAngles()):Forward()
		local phys = mine:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableGravity(false)
			phys:AddVelocity(dir*256)
		end
	end
)