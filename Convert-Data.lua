function RecupPosition(_string)
	i = string.find(_string, ":", 1) -- x
	local x = string.sub(_string, 1, i - 1)
	j = string.find(_string, ":", i + 1)
	local y = string.sub(_string, i + 1, j - 1)
	i = j
	j = string.find(_string, ":", j + 1)
	local z = string.sub(_string, i + 1, j - 1)
	local pos = {
		x = x,
		y = y,
		z = z,
	}
	return pos
end

function RecupCode(_code)
	local Tab = {
		["Z"] = "Zone",
		["S"] = "Sector",
		["TW"] = "Towns",
		["DJ"] =  "Dungeon",
		["P"] =  "House",
		["L"] = "Leeves",
		["H"] = "Merchants",
		["V"] = "Mender",
		["BO"] =  "Botanist",
		["MI"] = "Miner",
		["FI"] = "Fisherman",
		["BT"] = "Bestial",
		["G"] = "Guild",
		["EU"] =  "Aethernet" ,
		["B"] =  "Bestiary",
		["BOU"] = "UnspoilBotanist",
		["BOE"] = "EphemeralBotanist",
		["MIE"] =  "EphemeralMiner",
		["MIU"] =  "UnspoilMiner",
		["TT"] = "TripleTriad",
		["NPC"] = "NPC",
		["VE"] = "AetherCurrents",
		--
		["ZA"] = "Zone",
		["SA"] = "Sector",
		["TWA"] = "Towns",
		["DJA"] =  "Dungeon",
		["PA"] =  "House",
		["PAA"] =  "House",
		["LA"] = "Leeves",
		["HA"] = "Merchants",
		["VA"] = "Mender",
		["BOA"] =  "Botanist",
		["MIA"] = "Miner",
		["FIA"] = "Fisherman",
		["BTA"] = "Bestial",
		["GA"] = "Guild",
		["EUA"] =  "Aethernet" ,
		["BA"] =  "Bestiary",
		["BOUA"] = "UnspoilBotanist",
		["BOEA"] = "EphemeralBotanist",
		["MIEA"] =  "EphemeralMiner",
		["MIUA"] =  "UnspoilMiner",
		["TTA"] = "TripleTriad",
		["NPCA"] = "NPC",
		["VEA"] = "AetherCurrents",
		--
		["ZB"] = "Zone",
		["SB"] = "Sector",
		["TWB"] = "Towns",
		["DJB"] =  "Dungeon",
		["PB"] =  "House",
		["LB"] = "Leeves",
		["HB"] = "Merchants",
		["VB"] = "Mender",
		["BOB"] =  "Botanist",
		["MIB"] = "Miner",
		["FIB"] = "Fisherman",
		["BTB"] = "Bestial",
		["GB"] = "Guild",
		["EUB"] =  "Aethernet" ,
		["BB"] =  "Bestiary",
		["BOUB"] = "UnspoilBotanist",
		["BOEB"] = "EphemeralBotanist",
		["MIEB"] =  "EphemeralMiner",
		["MIUB"] =  "UnspoilMiner",
		["TTB"] = "TripleTriad",
		["NPCB"] = "NPC",
		["VEB"] = "AetherCurrents",
	}
	return Tab[_code]
end

function NewData(_string, _code,_file)
	local Type = RecupCode(_code)
	local Name, i = NewTrad(_string, _file)
	j = string.find(_string, ":\"", i)
	local position = string.sub(_string, i + 1, j)
	local Position = RecupPosition(position)
	--
	_file:write("{\n")
	_file:write("\tType = \""..Type.."\",\n")
	_file:write("\tName = \""..Name.."\",\n")
	_file:write("\tPositionMap = {x = 0, y = 0},\n")
	_file:write("\t--\n")
	_file:write("\tPositionIG = {x = "..Position.x..", y = "..Position.y..", z = "..Position.z.."},\n")
	_file:write("\t--\n")
	_file:write("}\n\n")
	--
end

function NewTrad(_string, _file)
	i = string.find(_string, ":", 1)
	local francais = string.sub(_string, 1, i - 1)
	j = string.find(_string, ":", i + 1)
	local englais = string.sub(_string, i + 1, j - 1)
	--
	_file:write("[\""..englais.."\"] = {\n")
	_file:write("\t[0] = nil, -- JP\n")
	_file:write("\t[1] = \""..englais.."\", -- EN\n")
	_file:write("\t[2] = nil, -- GE\n")
	_file:write("\t[3] = \""..francais.."\", -- FR\n")
	_file:write("\t[4] = nil, -- CN\n")
	_file:write("\t[6] = nil, -- KR\n")
	_file:write("}\n\n")
	--
	return englais, j
end

function CompleteFile(_string, _file)
	local i = 1
	local j = 2
	while true do
		i = string.find(_string, "\"", i)
		if not i then return nil end -- Finish
		j = string.find(_string, ":", i + 1)
		local code = string.sub(_string, i + 2, j - 2)
		print(code)
		i = string.find(_string, ":\",", i)
		local String = string.sub(_string, j + 1, i + 1)
		print(String)
		i = i + 4
		--
		if (code ~= "D") and (code ~= "ST") then
			if code == "T" then
				NewTrad(String, _file)
			else
				NewData(String, code, _file)
			end
		end
	end
end

function FindMapId(_string, i)
	local j = string.find(_string, "Data", i)
	if not j then return nil end -- Finish
	local tmp = string.sub(_string, i, j - 1)
	j = j + 5
	i = j
	j = string.find(_string, "{\n", j)
	if not j then return nil end -- Finish
	local map = string.sub(_string, i, j - 5)
	i = string.find(_string, "}\n\nData", j + 1)
	if not i then return nil end -- Finish
	local data = string.sub(_string, j + 2, i - 2)
	return map,data,i - 2
end

function main()
	-- Recup Data Navigator
	local Data = io.open("Data.lua", "r")
	-- Read it & search data
	local Reader = Data:read("*all")
	local i = 1
	while true do
		-- Find map id
		local map = nil
		local data = nil
		map, data, i = FindMapId(Reader, i)
		if (not map) or (not i) then break end -- Finish
		-- Got Map -> Create file
		local NewFile = io.open(map..".lua", "w")
		print(map)
		CompleteFile(data, NewFile)
	end
end

main()