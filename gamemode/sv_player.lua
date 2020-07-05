function GM:ShouldCollide( ent1, ent2 )
	if ( IsValid( ent1 ) and IsValid( ent2 ) and ent1:IsPlayer() and ent2:IsPlayer() ) then
		return false
	end
end

local playerstoadd = player.GetAll() or {}
function GM:PlayerInitialSpawn( ply )
	table.insert( playerstoadd, ply )
	ply:SetTeam( TEAM_SPEC )
end

hook.Add( "StartRound", "Round_setupplayer", function()
	local huntnum = team.NumPlayers( TEAM_HUNTER )
	local propnum = team.NumPlayers( TEAM_PROP )
	-- add players
	for k, ply in pairs( playerstoadd ) do
		if huntnum > propnum then
			ply:SetTeam( TEAM_PROP )
			propnum = propnum + 1
			ply:Spawn()
		else
			ply:SetTeam( TEAM_HUNTER )
			huntnum = huntnum + 1
			ply:Spawn()
		end
		print("[PH] Player join: " .. ply:Nick())
	end
	-- check for balance
	local pdiff = math.ceil( math.abs( huntnum - propnum ) / 2 )
	local largeteam = TEAM_PROP
	if huntnum > propnum then largeteam = TEAM_HUNTER end
	if pdiff == 1 then
		local splay = table.Random( team.GetPlayers( largeteam ) )
		splay.keep = true
		print("[PH] Team balance: Attempting to keep " .. splay:Nick())
	elseif pdiff > 1 then
		for i = 1,pdiff do
			local splay = table.Random( team.GetPlayers( largeteam ) )
			splay.keep = true
			print("[PH] Team balance: Attempting to keep " .. splay:Nick())
		end
	end
	-- switch teams
	for k, ply in pairs( PROPHUNT:GetPlaying() ) do
		if ply.keep == true then
			print("[PH] Team balance: Keeping " .. ply:Nick())
			ply.keep = false
			ply:Spawn()
		else
			if ply:Team() == TEAM_PROP then
				ply:SetTeam( TEAM_HUNTER )
				ply:Spawn()
			else
				ply:SetTeam( TEAM_PROP )
				ply:Spawn()
			end
		end
	end
	playerstoadd = {}
end)