GM.RoundState = 1
GM.RoundTime = 0.0
GM.RoundStart = 0.0
GM.RoundNum = 0
SetGlobalFloat( "RoundTime", 0.0 )
SetGlobalInt( "RoundNum", 0 )
SetGlobalInt( "RoundState", 1 )

function GM:SetUpRound()
	game.CleanUpMap()
	self:RefreshConvars()
	self.RoundState = 2
	self.RoundTime = 0
	self.RoundStart = CurTime()
	self.RoundNum = self.RoundNum + 1
	SetGlobalInt( "RoundNum", self.RoundNum )
	SetGlobalFloat( "RoundTime", 0.0 )
	if self.RoundNum > self.Convars["RoundLimit"] then
		self.RoundState = 4
		SetGlobalInt( "RoundState", 4 )
		print("[PH] Round limit reached, forcing mapvote.")
	else
		SetGlobalInt( "RoundState", 2 )
		hook.Run( "StartRound", self.RoundNum )
		print("[PH] Setting up round " .. self.RoundNum .. ".")
	end
end

function GM:FinishRound( winteam )
	if winteam == nil then winteam = 1 end
	self.RoundState = 3
	self.RoundTime = 0
	self.RoundStart = CurTime()
	SetGlobalFloat( "RoundTime", 0.0 )
	SetGlobalInt( "RoundState", 3 )
	hook.Run( "EndRound", self.RoundNum, winteam )
	if winteam == 1 then
		print("[PH] Finishing round " .. self.RoundNum .. ". Draw.")
	else
		print("[PH] Finishing round " .. self.RoundNum .. ". " .. team.GetName( winteam ) .. " win.")
	end
end

local mapstart = true
function GM:InitSetUpRound()
	if mapstart then
		if player.GetCount() > 1 then
			mapstart = false
			timer.Simple( self.Convars["StartWaitTime"], function() 
				self:SetUpRound()
				mapstart = true
			end)
		end
	end
end

function GM:RoundThink()
	if self.RoundState == 2 then
		if self.RoundTime >= self.Convars["RoundLength"] then
			self:FinishRound( TEAM_PROP )
		elseif team.GetCount( TEAM_PROP ) == 0 and team.GetCount( TEAM_HUNTER ) == 0 then
			self:FinishRound( 1 )
		elseif team.GetCount( TEAM_PROP ) == 0 then
			self:FinishRound( TEAM_HUNTER )
		elseif team.GetCount( TEAM_HUNTER ) == 0 then
			self:FinishRound( TEAM_PROP )
		else
			self.RoundTime = math.Round( CurTime() - self.RoundStart, 2 )
			SetGlobalFloat( "RoundTime", self.RoundTime )
		end
	elseif self.RoundState == 3 then
		if self.RoundTime >= self.Convars["RoundWait"] then
			self:SetUpRound() 
		else
			self.RoundTime = math.Round( CurTime() - self.RoundStart, 2 )
			SetGlobalFloat( "RoundTime", self.RoundTime )
		end
	elseif self.RoundState == 1 then
		self:InitSetUpRound()
	end
	if PROPHUNT:GetPlayingCount() <= 1 and self.RoundState != 1 then
		print("Too few players.")
		self.RoundState = 1
		self.RoundTime = 0
		SetGlobalFloat( "RoundTime", 0.0 )
		SetGlobalInt( "RoundState", 1 )
	end
end