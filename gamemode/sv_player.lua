local playermeta = getmetatable("player")

function playermeta:JoinGame()
	local huntnum = team.NumPlayers( TEAM_HUNTER )
	local propnum = team.NumPlayers( TEAM_PROP )
	if huntnum > propnum then
		self:SetTeam( TEAM_PROP )
	else
		self:SetTeam( TEAM_HUNTER )
	end
end

function playermeta:SetGameStatus( sta )
	sta = tonumber( sta )
	self.ingame = sta
	self:SetNWInt( "ig_status", sta )
end


hook.Add( "StartRound", "Round_setupplayer", function()
	for k, ply in pairs( player.GetAll() ) do
		if ply:Team() == 2 then
			ply:SetTeam( 3 )
			ply:spawn()
			ply:SetGameStatus( 1 )
		elseif ply:Team() == 3 then
			ply:SetTeam( 2 )
			ply:spawn()
			ply:SetGameStatus( 1 )
		else
			ply:JoinGame()
			ply:spawn()
			ply:SetGameStatus( 2 )
		end
	end
end)