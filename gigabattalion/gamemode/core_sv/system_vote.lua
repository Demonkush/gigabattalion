GIGABAT.Vote = {}
GIGABAT.Vote.NextScenario = "none"
GIGABAT.Vote.NextGameType = "none"
GIGABAT.Vote.RTVs = 0
GIGABAT.Vote.Delay = 0
GIGABAT.Vote.VotingGameTypes = {}
GIGABAT.Vote.VotingScenarios = {}
GIGABAT.Vote.Active = false

GIGABAT.Vote.GameVoteTime = 15
GIGABAT.Vote.ScenarioVoteTime = 15

function GIGABAT.Functions.SaveNextGameInfo()
	local path = "gigabattalion/gameinfo.txt"
	local tab = {scenario = GIGABAT.Vote.NextScenario,gametype = GIGABAT.Vote.NextGameType}
	local info = util.TableToJSON(tab)
	if !file.Exists("gigabattalion","DATA") then file.CreateDir("gigabattalion") end
	file.Write(path,info)
end

net.Receive("GigabatSendGameVote",function(len,pl)
	local gamevote = net.ReadInt(32)
	if pl.Vote != nil then
		table.RemoveByValue(GIGABAT.Vote.VotingGameTypes[pl.Vote].votes,pl)
	end
	pl.Vote = gamevote
	table.insert(GIGABAT.Vote.VotingGameTypes[pl.Vote].votes,pl)
	timer.Simple(0.1,function()
		net.Start("GigabatSendGameVoteData")
			net.WriteTable(GIGABAT.Vote.VotingGameTypes)
		net.Broadcast()
	end)
end)
function GIGABAT.Functions.BuildGameTypeList()
	local count,max = 0,3
	for a, b in pairs(GIGABAT.Gametypes) do
		if count == max then return end
		count = count + 1
		table.insert(GIGABAT.Vote.VotingGameTypes,{id=count,game=a,name=b.name,votes={}})
	end	
	GIGABAT.Functions.Notification("Open the Star Map (F1) to choose the next Game Type!",Color(55,55,75),nil,true)

	net.Start("GigabatSendGameVoteData")
		net.WriteTable(GIGABAT.Vote.VotingGameTypes)
	net.Broadcast()

	timer.Simple(GIGABAT.Vote.GameVoteTime,function() 
		table.sort(GIGABAT.Vote.VotingGameTypes, function(a,b) 
			local avotes = #a.votes
			local bvotes = #b.votes
			return avotes > bvotes 
		end)
		GIGABAT.Vote.NextGameType = GIGABAT.Vote.VotingGameTypes[1].game

		GIGABAT.Functions.BuildScenarioList() 
	end)
end

net.Receive("GigabatSendScenarioVote",function(len,pl)
	local scenariovote = net.ReadInt(32)
	if pl.Vote != nil then
		table.RemoveByValue(GIGABAT.Vote.VotingScenarios[pl.Vote].votes,pl)
	end
	pl.Vote = scenariovote
	table.insert(GIGABAT.Vote.VotingScenarios[pl.Vote].votes,pl)
	timer.Simple(0.1,function()
		net.Start("GigabatSendScenarioVoteData")
			net.WriteTable(GIGABAT.Vote.VotingScenarios)
		net.Broadcast()
	end)
end)
function GIGABAT.Functions.BuildScenarioList()
	if GIGABAT.Vote.NextGameType == "none" then
		GIGABAT.Vote.NextGameType = "dogfight"
	end
	local scenarios = GIGABAT.Gametypes[GIGABAT.Vote.NextGameType].scenarios
	for a, b in pairs(GIGABAT.Scenario) do
		if table.HasValue(scenarios,a) then
			table.insert(GIGABAT.Vote.VotingScenarios,{id=a,starpos=b.starpos,name=b.name,votes={}})
		end
	end	

	local gtname = GIGABAT.Gametypes[GIGABAT.Vote.NextGameType].name
	GIGABAT.Functions.Notification("The next Game Type will be: "..gtname.." !",Color(55,55,75),nil,true)
	GIGABAT.Functions.Notification("Open the Star Map (F1) to choose the next Scenario",Color(55,55,75),nil,true)

	net.Start("GigabatSendScenarioVoteData")
		net.WriteTable(GIGABAT.Vote.VotingScenarios)
	net.Broadcast()

	timer.Simple(GIGABAT.Vote.ScenarioVoteTime,function()
		table.sort(GIGABAT.Vote.VotingScenarios, function(a,b) 
			local avotes = #a.votes
			local bvotes = #b.votes
			return avotes > bvotes 
		end)
		GIGABAT.Vote.NextScenario = GIGABAT.Vote.VotingScenarios[1].id

		GIGABAT.Functions.EndVote() 
		-- Fallback timer
		timer.Simple(120,function() RunConsoleCommand("changelevel",game.GetMap()) end)
	end)
end

function GIGABAT.Functions.RockTheVote(ply)
	if ply.gb_RTVd then return end
	if GIGABAT.Vote.Delay > CurTime() then return end
	if GIGABAT.Round.State == 3 then return end
	if !GIGABAT.Vote.Active then
		GIGABAT.Vote.Active = true
		timer.Create("GigabatRTVTimer",30,1,function()
			GIGABAT.Functions.RTVReset()
			GIGABAT.Functions.Notification("RTV failed! Next RTV available in 5 minutes!",Color(75,35,35),nil,true)
			GIGABAT.Vote.Delay = CurTime()+300
			GIGABAT.Vote.Active = false
		end)
	end

	ply.gb_RTVd = true

	local ratio = math.Round(#player.GetAll()*0.66)
	GIGABAT.Vote.RTVs = GIGABAT.Vote.RTVs + 1
	if GIGABAT.Vote.RTVs >= ratio then
		timer.Remove("GigabatRTVTimer")
		GIGABAT.Functions.Notification("RTV successful! Game vote starting...",Color(65,75,35),nil,true)
		timer.Simple(5,function() GIGABAT.Functions.BeginVote() end)
	end
	if GIGABAT.Vote.RTVs < ratio then
		local left = ratio - GIGABAT.Vote.RTVs
		if left > 0 then
			GIGABAT.Functions.Notification(ply:Name().." rocked the vote! ("..left.." left)",Color(55,55,55),nil,true)
		end
	end
end
hook.Add("PlayerSay","GIGABATRTV", function(ply,text,public)
	if string.lower(text) == "!rtv" then
		GIGABAT.Functions.RockTheVote(ply)
		return ""
	end
end)

function GIGABAT.Functions.BeginVote()
	GIGABAT.Round.State = GIGABAT_ROUND_CHANGING
	GIGABAT.Functions.Notification("Game vote started! Opening Star Map...",Color(35,65,75),nil,true)

	timer.Simple(5,function()
		for a, b in pairs(player.GetAll()) do GIGABAT.Functions.SendStarmap(b) end
	end)

	timer.Simple(10,function() GIGABAT.Functions.BuildGameTypeList() end)
end

function GIGABAT.Functions.EndVote()
	local scenario = GIGABAT.Scenario[GIGABAT.Vote.NextScenario].name
	local gametype = GIGABAT.Gametypes[GIGABAT.Vote.NextGameType].name
	GIGABAT.Functions.Notification("The game is changing!",Color(65,85,35),nil,true)
	GIGABAT.Functions.Notification("Next game will be "..gametype.." on "..scenario,Color(65,85,35),nil,true)
	GIGABAT.Functions.SaveNextGameInfo()
	for k, v in pairs(player.GetAll()) do
		GIGABAT.Functions.SavePlayerData(v)
	end

	timer.Simple(7,function() RunConsoleCommand("changelevel",game.GetMap()) end)
end

function GIGABAT.Functions.RTVReset()
	for a, b in pairs(player.GetAll()) do b.gb_RTVd = false end
end