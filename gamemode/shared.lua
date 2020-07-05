GM.Name 	= "Prophunt"
GM.Author 	= "Cptn.Sheep"
GM.Email 	= "N/A"
GM.Website 	= "https://github.com/akersda"
GM.Version 	= "1.0.0"

team.SetUp(1, "Spectators", Color(120, 120, 120))
TEAM_SPEC = 1
TEAM_SPECTATOR = 1
TEAM_SPECTATORS = 1

team.SetUp(2, "Hunter", Color(255, 150, 50))
TEAM_T = 2
TEAM_HUNTER = 2
TEAM_HUNTERS = 2

team.SetUp(3, "Prop", Color(50, 150, 255))
TEAM_CT = 3
TEAM_PROP = 3
TEAM_PROPS = 3

GM.Teams = {
	[2] = true,
	[3] = true
}

GM.States = {
	[1] = "Start waiting",
	[2] = "Playing round",
	[3] = "Round over",
	[4] = "Map vote"
}

function GM:GetPlaying()
	local players = {}
	for k,pl in pairs( player.GetAll() ) do
		if self.Teams[pl:Team()] == true then
			table.insert(players, pl)
		end
	end
	return players
end

function GM:GetPlayingCount()
	return #self:GetPlaying()
end
