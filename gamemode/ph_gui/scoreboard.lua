local scoreb = {}

function GM:ScoreboardShow()
	local gmtab = self
	scoreb = vgui.Create( "Panel" )
	scoreb:SetSize(400,200)
	scoreb:Center()
	function scoreb:Paint(w,h)
		draw.Text({
			text = gmtab.States[GetGlobalInt( "RoundState", 1 )] .. "  " .. GetGlobalInt( "RoundNum", 0 ) .. "   " .. math.Round(GetGlobalFloat( "RoundTime", 0.0 ),1),
			pos = {4,4},
			font = "DermaLarge"
		})
	end
end

function GM:ScoreboardHide()
	scoreb:Remove()
end