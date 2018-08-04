--[[-------------------------------------------------------------------------
ROUND SYSTEM
---------------------------------------------------------------------------]]
GIGABAT_ROUND_INACTIVE 	= 1
GIGABAT_ROUND_ACTIVE 	= 2
GIGABAT_ROUND_CHANGING 	= 3

GIGABAT.Round = {}
GIGABAT.Round.State = GIGABAT_ROUND_INACTIVE
GIGABAT.Round.MinPlayers = 2
GIGABAT.Round.Time = 420

function GIGABAT.Functions.RoundInit()
	timer.Create("GIGABATCheckRound",3,0,GIGABAT.Functions.CheckRound)
end

local starting = false
function GIGABAT.Functions.CheckRound()
	local plys = #player.GetAll()
	if GIGABAT.Round.State == GIGABAT_ROUND_ACTIVE then
		if plys == 0 then GIGABAT.Functions.EndRound() end
		if plys < GIGABAT.Round.MinPlayers then GIGABAT.Functions.ResetRound() end
	end
	if GIGABAT.Round.State == GIGABAT_ROUND_INACTIVE then
		local function IsEnoughPlayers()
			local players = {}
			for a, b in pairs(player.GetAll()) do
				if b.gb_Ready then
					table.insert(players,b)
				end
			end
			if #players >= GIGABAT.Round.MinPlayers then
				return true
			end
			return false
		end
		if IsEnoughPlayers() then
			if starting then return end
			starting = true
			GIGABAT.Functions.Notification("Round is starting!",Color(55,55,55),nil,true)
			timer.Simple(5,function()
				starting = false
				if IsEnoughPlayers() then
					GIGABAT.Functions.StartRound()
				else
					GIGABAT.Functions.ResetRound()
				end
			end)
		end
	end
end

function GIGABAT.Functions.StartRound()
	if GIGABAT.Round.State == GIGABAT_ROUND_ACTIVE then return end
	GIGABAT.Round.State = GIGABAT_ROUND_ACTIVE
	timer.Create("GIGABATRoundTimer",GIGABAT.Round.Time,1,function()
		GIGABAT.Functions.EndRound()
	end)
	GIGABAT.Functions.Notification("Round has started!",Color(55,55,85),nil,true)

	for k, v in pairs(player.GetAll()) do
		v:SetNWInt("Gigabat_Score",0)
	end

	GIGABAT.Gametypes[GIGABAT.Config.GameType].onround()
	net.Start("GigabatSendRoundTimer")
		net.WriteInt(timer.TimeLeft("GIGABATRoundTimer"),32)
	net.Broadcast()
	timer.Simple(0.1,function()
		net.Start("GigabatSendIngameInfoText") net.Broadcast()
	end)
end

function GIGABAT.Functions.ResetRound()
	GIGABAT.Round.State = GIGABAT_ROUND_INACTIVE
	GIGABAT.Functions.Notification("Game reset!",Color(55,55,55),nil,true)

	net.Start("GigabatSendRoundTimer")
		net.WriteInt(0,32)
	net.Broadcast()
end

function GIGABAT.Functions.EndRound()
	if GIGABAT.Round.State == GIGABAT_ROUND_CHANGING then return end
	GIGABAT.Round.State = GIGABAT_ROUND_CHANGING
	local plys = #player.GetAll()
	if plys > 0 then GIGABAT.Functions.BeginVote() end
	timer.Remove("GIGABATRoundTimer")

	net.Start("GigabatSendRoundTimer")
		net.WriteInt(0,32)
	net.Broadcast()
end