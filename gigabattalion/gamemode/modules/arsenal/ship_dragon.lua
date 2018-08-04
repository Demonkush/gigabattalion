GIGABAT.Functions.AddArsenal(
	"ship_dragon",
	"Dragon",
	{
		usesammo = false,
		usesenergy = true,
		ammo = 0,
		energy = 25,
		reload = 3,
		style = "energy",
		dly = 7,
	},
	function(gun)
		local ply = gun:GetOwner()
		local ship = ply.Ship

		local fx = EffectData()
		fx:SetOrigin(gun:GetPos())
		fx:SetEntity(gun)
		util.Effect("gbfx_beam_fire",fx)

		gun:EmitSound("gigabat.beam.loop",75,75)

		timer.Simple(5,function()
			if IsValid(gun) then
				gun:StopSound("gigabat.beam.loop")
			end
		end)

		local id = "gigabatdragonbeam"..gun:EntIndex()
		timer.Create(id,0.1,50,function()
			if IsValid(gun) then
				local tr = util.TraceLine({
					start = gun:GetPos(),
					endpos = gun:GetPos()+(-gun:GetAngles():Forward()*6000),
					filter = function( ent ) if ent:GetOwner() != gun:GetOwner() then return true end end
				})

				local fx = EffectData() fx:SetOrigin(gun:GetPos()) fx:SetScale(225)
				util.Effect("gbfx_sprite_muzzlered",fx)

				if tr.Hit then
					local fx2 = EffectData() fx2:SetOrigin(tr.HitPos) fx2:SetScale(400)
					util.Effect("gbfx_sprite_muzzlered",fx2)
					local fx3 = EffectData() fx3:SetOrigin(tr.HitPos) fx3:SetScale(2.5)
					util.Effect("gbfx_explode_dragon",fx3)

					local att = gun
					if IsValid(gun:GetOwner()) then
						att = gun:GetOwner()
					end
					for _, v in ipairs(ents.FindInSphere( tr.HitPos, 175 )) do
						local dmginfo = DamageInfo()
						dmginfo:SetAttacker( att )
						dmginfo:SetInflictor( gun )
						dmginfo:SetDamage( math.random(20,25) )
						v:TakeDamageInfo( dmginfo )

						if IsValid(v:GetOwner()) then
							if v:GetClass() == "gigabat_ship" then
								v:StateBurn(ply,6)
							end
						end
					end
				end
			else
				timer.Remove(id)
			end
		end)
	end
)