util.AddNetworkString("GigabatReceiveSpectateShip")
util.AddNetworkString("GigabatReceiveTarget")
util.AddNetworkString("GigabatReceiveGarage")
util.AddNetworkString("GigabatSendTransition")
util.AddNetworkString("GigabatSendShipHide")
util.AddNetworkString("GigabatSendShipSelect")
util.AddNetworkString("GigabatSendGarage")
util.AddNetworkString("GigabatSendData")
util.AddNetworkString("GigabatSendKiller")
util.AddNetworkString("GigabatSendDamage")
util.AddNetworkString("GigabatSendGameInfo")
util.AddNetworkString("GigabatSendMenu")
util.AddNetworkString("GigabatSendNotification")
util.AddNetworkString("GigabatSendScoreNotification")
util.AddNetworkString("GigabatSendDeath")
util.AddNetworkString("GigabatSendStarmap")
util.AddNetworkString("GigabatSendGameVoteData")
util.AddNetworkString("GigabatSendScenarioVoteData")
util.AddNetworkString("GigabatSendGameVote")
util.AddNetworkString("GigabatSendScenarioVote")
util.AddNetworkString("GigabatSendRoundTimer")
util.AddNetworkString("GigabatSendIngameInfoText")
util.AddNetworkString("GigabatSpectateRoam")
util.AddNetworkString("GigabatUnlockShip")
util.AddNetworkString("GigabatUnlockShipAccept")
util.AddNetworkString("GigabatUnlockSkin")
util.AddNetworkString("GigabatUnlockSkinAccept")
util.AddNetworkString("GigabatOpenedGarage")
util.AddNetworkString("Asteroid_HealthPoke")
util.AddNetworkString("Ship_Overdrive")
util.AddNetworkString("Ship_Overpower")
util.AddNetworkString("Ship_Stealth")
util.AddNetworkString("Ship_AmmoSupply")
util.AddNetworkString("Ship_ShieldBattery")
util.AddNetworkString("Ship_ShieldPoke")
net.Receive("GigabatOpenedGarage",function(len,pl) pl.EnteredGarage = true end)
net.Receive("GigabatReceiveGarage",function(len,pl)
	local nt = net.ReadBool()
	pl.EnteredGarage = false
	if nt then
		pl.gb_Ready = true
		GIGABAT.Functions.PlayerSpawn(pl)
	end
end)
net.Receive("GigabatSendShipSelect",function(len,pl)
	local ship = net.ReadString()
	local skin = net.ReadString()

	if !table.HasValue(pl.gb_OwnedShips,ship) then
		ship = GIGABAT.Config.DefaultShip
	end
	if !table.HasValue(pl.gb_OwnedSkins,skin) then
		skin = GIGABAT.Config.DefaultSkin
	end
	GIGABAT.Functions.SetFrame(pl,ship)
	pl:SetNWString("Gigabat_Skin",skin)
end)