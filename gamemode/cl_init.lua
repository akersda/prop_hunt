include("shared.lua")
include("meta_player.lua")
include("cl_player.lua")

for k, file in pairs(file.Find( "prop_hunt/gamemode/ph_gui/*.lua", "LUA" )) do
	include("ph_gui/"..file)
end