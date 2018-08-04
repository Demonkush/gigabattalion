-- id, name, stats, attack
GIGABAT.Functions.AddArsenal(
	"ship_pyro",
	"Flamer",
	{
		usesammo = false,
		usesenergy = true,
		ammo = 0,
		energy = 7,
		reload = 3,
		style = "ballistic",
		dmg = {5,10},
		dly = 3,
	},
	function(gun)
		local ply = gun:GetOwner()
		local ship = ply.Ship
		local count = 0
		gun:EmitSound("ambient/fire/ignite.wav",75,85)

		timer.Remove("GigabatPyro"..gun:EntIndex())
		timer.Create("GigabatPyro"..gun:EntIndex(),0.1,10,function()
			if IsValid(ship) then
				local dir = -(ship:GetAngles()+Angle(math.random(-2,2),math.random(-2,2),0)):Forward()
				count = count + 1
				if count == 1 then
					local fx = EffectData()
					fx:SetEntity(gun)
					fx:SetOrigin(gun:GetPos())
					fx:SetScale(count)
					fx:SetNormal(dir)
					util.Effect("gbfx_sprite_flamer",fx)
				end
				local trace = util.TraceHull({
					start = gun:GetPos(),
					endpos = gun:GetPos() + ( dir * 2048 ),
					filter = function(ent) if ent:GetOwner() != ply then return true end end,
					mins = Vector( -64, -64, -64 ),
					maxs = Vector( 64, 64, 64 ),
					mask = MASK_SHOT_HULL		
				})

				for a, b in pairs(ents.FindInSphere(trace.HitPos,128)) do
					local dmg = DamageInfo()
					dmg:SetDamage(math.random(7,10))
					dmg:SetAttacker(ply)
					dmg:SetInflictor(gun)
					b:TakeDamageInfo(dmg)

					if IsValid(b:GetOwner()) then
						if b:GetClass() == "gigabat_ship" then
							b:StateBurn(ply,6)
						end
					end
				end
			end
		end)
	end
)