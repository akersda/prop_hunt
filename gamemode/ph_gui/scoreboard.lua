local scoreb = {}

function GM:ScoreboardShow()
	local gmtab = PROPHUNT
	scoreb = vgui.Create( "Panel" )
	scoreb:SetSize(400,200)
	scoreb:Center()
	function scoreb:Paint(w,h)
		draw.RoundedBox( 4, 0, 0, w, w, Color(10,10,12,50) )
		draw.Text({
			text = gmtab.States[GetGlobalInt( "RoundState", 1 )] .. "  " .. GetGlobalInt( "RoundNum", 0 ) .. "   " .. math.Round(GetGlobalFloat( "RoundTime", 0.0 ),1),
			pos = {4,4},
			font = "DermaLarge"
		})
		local ypos = 20
		for k, ply in pairs( player.GetAll() ) do
			ypos = ypos + 10
			draw.Text({
				text = ply:Nick() .. " | " .. ply:Team(),
				pos = {4,ypos},
				font = "DermaDefault"
			})
		end
	end
end

function GM:ScoreboardHide()
	scoreb:Remove()
end