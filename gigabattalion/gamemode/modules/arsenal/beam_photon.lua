GIGABAT.Functions.AddArsenal(
	"beam_photon",
	"Photon Beam",
	{
		usesammo = false,
		usesenergy = true,
		ammo = 0,
		energy = 15,
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
		util.Effect("gbfx_beam_yellow",fx)

		gun:EmitSound("gigabat.beam.loop",75,75)

		timer.Simple(5,function()
			if IsValid(gun) then
				gun:StopSound("gigabat.beam.loop")
			end
		end)

		local id = "gigabatphotonbeam"..gun:EntIndex()
		timer.Create(id,0.1,50,function()
			if IsValid(gun) then
				local tr = util.TraceLine({
					start = gun:GetPos(),
					endpos = gun:GetPos()+(-gun:GetAngles():Forward()*4000),
					filter = function( ent ) if ent:GetOwner() != gun:GetOwner() then return true end end
				})

				local fx = EffectData() fx:SetOrigin(gun:GetPos()) fx:SetScale(200)
				util.Effect("gbfx_sprite_muzzleyellow",fx)

				if tr.Hit then
					local fx2 = EffectData() fx2:SetOrigin(tr.HitPos) fx2:SetScale(355)
					util.Effect("gbfx_sprite_muzzleyellow",fx2)
					local fx3 = EffectData() fx3:SetOrigin(tr.HitPos) fx3:SetScale(2)
					fx3:SetAngles(Angle(255,235,115))
					util.Effect("gbfx_3d_ring",fx3)

					local att = gun
					if IsValid(gun:GetOwner()) then
						att = gun:GetOwner()
					end
					for _, v in ipairs(ents.FindInSphere( tr.HitPos, 155 )) do
						local dmginfo = DamageInfo()
						dmginfo:SetAttacker( att )
						dmginfo:SetInflictor( gun )
						dmginfo:SetDamage( math.random(15,20) )
						v:TakeDamageInfo( dmginfo )
					end
				end
			else
				timer.Remove(id)
			end
		end)
	end
)