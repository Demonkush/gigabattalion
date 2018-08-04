-- id, name, stats, attack
GIGABAT.Functions.AddArsenal(
	"blaster_plasma",
	"Plasma Blaster",
	{
		usesammo = false,
		usesenergy = true,
		ammo = 0,
		energy = 5,
		reload = 3,
		style = "energy",
		dmg = {5,10},
		dly = 1.25,
	},
	function(gun)
		local ply = gun:GetOwner()
		local ship = ply.Ship
		gun:EmitSound("gigabat.laser.heavyshoot")

		local fx = EffectData()
		fx:SetOrigin(gun:GetPos())
		fx:SetScale(256)
		util.Effect("gbfx_sprite_muzzlegreen",fx)

		local rocket = ents.Create("gigabat_ammo_plasmablaster")
		rocket:SetPos(gun:GetPos()+(-ship:GetForward()*96))
		rocket:SetAngles(ship:GetAngles())
		rocket.Owner = ply
		rocket:SetOwner(ply)
		rocket:Spawn()

		local phys = rocket:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableGravity(false)
			phys:AddVelocity(-ship:GetForward()*999999)
		end
	end
)