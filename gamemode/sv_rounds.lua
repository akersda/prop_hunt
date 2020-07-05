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
	print("[PH] Finishing round " .. self.RoundNum .. ". " .. team.GetName( winteam ) .. " win.")
end

local mapstart = true
function GM:RoundThink()
	if self.RoundState == 2 then
		if self.RoundTime >= self.Convars["RoundLength"] then
			self:FinishRound()
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
	elseif player.GetCount() > 1 and self.RoundState == 1 and mapstart then
		mapstart = false
		timer.Simple( self.Convars["StartWaitTime"], function() 
			self:SetUpRound()
			mapstart = true
		end)
	end
	if player.GetCount() <= 1 and self.RoundState != 1 then
		self.RoundState = 1
		self.RoundTime = 0
		SetGlobalFloat( "RoundTime", 0.0 )
		SetGlobalInt( "RoundState", 1 )
	end
end