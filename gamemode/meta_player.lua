local ply = FindMetaTable("Player")

function ply:IsSpec()
	return (ply:Team() == TEAM_SPEC)
end

function ply:IsSpectating()
	return (ply:Team() == TEAM_SPEC)
end