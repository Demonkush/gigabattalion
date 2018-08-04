util.AddNetworkString("GigabatUnlockShip")
util.AddNetworkString("GigabatUnlockShipAccept")
util.AddNetworkString("GigabatUnlockSkin")
util.AddNetworkString("GigabatUnlockSkinAccept")

function GIGABAT.Functions.UnlockShip(ply,a)
	local ship = GIGABAT.Frames[a]
	local ply_tokens = ply:GetNWInt("Gigabat_Tokens")
	local ship_tokens = ship.stats.tokencost

	if table.HasValue(ply.gb_OwnedShips,a) then return end 
	if ply_tokens >= ship_tokens then
		table.insert(ply.gb_OwnedShips,a)
		GIGABAT.Functions.Notification("Purchased the "..ship.name.."!",Color(85,105,35),ply,false)	
		ply:SetNWInt("Gigabat_Tokens",ply:GetNWInt("Gigabat_Tokens")-ship_tokens)
		GIGABAT.Functions.SavePlayerData(ply)
		GIGABAT.Functions.PlayerDataSync(ply)
	else
		GIGABAT.Functions.Notification("Not enough tokens!",Color(65,35,35),ply,false)	
	end
end

function GIGABAT.Functions.UnlockSkin(ply,a)
	local skin = GIGABAT.Skins[a]
	local ply_tokens = ply:GetNWInt("Gigabat_Tokens")
	local skin_tokens = skin.tokencost

	if table.HasValue(ply.gb_OwnedSkins,a) then return end 
	if ply_tokens >= skin_tokens then
		table.insert(ply.gb_OwnedSkins,a)
		GIGABAT.Functions.Notification("Purchased skin! ["..skin.name.."]",Color(85,105,35),ply,false)	
		ply:SetNWInt("Gigabat_Tokens",ply:GetNWInt("Gigabat_Tokens")-skin_tokens)
		GIGABAT.Functions.SavePlayerData(ply)
		GIGABAT.Functions.PlayerDataSync(ply)
	else
		GIGABAT.Functions.Notification("Not enough tokens!",Color(65,35,35),ply,false)	
	end
end

net.Receive("GigabatUnlockShip",function(len,pl)
	local ship = net.ReadString()
	GIGABAT.Functions.UnlockShip(pl,ship)
end)

net.Receive("GigabatUnlockSkin",function(len,pl)
	local skin = net.ReadString()
	GIGABAT.Functions.UnlockSkin(pl,skin)
end)