local ply = FindMetaTable("Player")

function ply:IsSpec()
	return (self:Team() == TEAM_SPEC)
end

function ply:IsSpectating()
	return (self:Team() == TEAM_SPEC)
end

if SERVER then

	function ply:SetStaySpec( set )
		ply.stayspec = set
	end
	
	function ply:GetStaySpec()
		return ply.stayspec or false
	end

end