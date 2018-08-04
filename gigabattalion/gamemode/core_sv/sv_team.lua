function GIGABAT.Functions.SortTeams()
	local plys = table.Copy(player.GetAll())
	local t1,t2 = {},{}
	for a, b in pairs(plys) do
		if #t1 > #t2 then
			table.insert(t2,b)
		end
		if #t1 < #t2 then
			table.insert(t1,b)
		end
		if #t1 == #t2 then
			local rand = math.random(1,2)
			if rand == 1 then
				table.insert(t1,b)
			end
			if rand == 2 then
				table.insert(t2,b)
			end
		end
	end
	print("-= Team 1 =-")
	PrintTable(t1)
	print("\n")
	print("-= Team 2 =-")
	PrintTable(t2)
end