local round_think_freq = 4




AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_player.lua")
AddCSLuaFile("meta_player.lua")

for k, file in pairs(file.Find( "prop_hunt/gamemode/ph_gui/*.lua", "LUA" )) do
	AddCSLuaFile("ph_gui/"..file)
end

include("shared.lua")
include("meta_player.lua")

GM.RoundLimit = CreateConVar("gm_roundlimit", 10, FCVAR_NOTIFY, "Number of rounds." )
GM.StartWaitTime = CreateConVar("gm_mapstartwait", 5, FCVAR_NOTIFY, "Time to start round after mapchange." )
GM.RoundLength = CreateConVar("gm_roundtime", 30, FCVAR_NOTIFY, "Time length per round." )
GM.RoundWait = CreateConVar("gm_roundwait", 5, FCVAR_NOTIFY, "Wait time between rounds." )

function GM:Initialize()

end

GM.Convars = {
	["RoundLimit"] = GM.RoundLimit:GetInt(),
	["StartWaitTime"] = GM.StartWaitTime:GetInt(),
	["RoundLength"] = GM.RoundLength:GetInt(),
	["RoundWait"] = GM.RoundWait:GetInt(),
}

function GM:RefreshConvars()
	self.Convars = {
		["RoundLimit"] = self.RoundLimit:GetInt(),
		["StartWaitTime"] = self.StartWaitTime:GetInt(),
		["RoundLength"] = self.RoundLength:GetInt(),
		["RoundWait"] = self.RoundWait:GetInt(),
	}
end

local rtcount = 1

function GM:Think()
	if rtcount >= round_think_freq then
		self:RoundThink()
		rtcount = 1
	else
		rtcount = rtcount + 1
	end
end

include("sv_rounds.lua")
include("sv_player.lua")
