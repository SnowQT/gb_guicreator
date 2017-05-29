-- simple_cursor_driver_for_FiveReborn
mousedrw = 0				-- mousedrw-is_mouse_drawing 
mousex, mousey = 0.0,0.0	-- default_position (the_left-top_corner_of_the_screen)

function CursorInZone(zonex, zoney, zonex1, zoney1) -- made_it_bitch xD
	if mousedrw == 1 and mousex > zonex and mousex < zonex1 and mousey > zoney and mousey < zoney1 then
		return true
	elseif mousedrw == 1 and mousex_d > zonex and mousex_d < zonex1 and mousey_d > zoney and mousey_d < zoney1 then
		return true
	else
		return false
	end
end

function Cursor(show) -- easy_n_simple
	if show == 0 then mousedrw = 0
	elseif show == 1 then mousedrw = 1 end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if mousedrw == 1 then
			mousex = GetControlNormal(2,239)
			mousey = GetControlNormal(2,240)
			-- hotfix_for_disabled_ctrl
			mousex_d = GetDisabledControlNormal(2,239)
			mousey_d = GetDisabledControlNormal(2,240)
			-- draw_the_cursor
			ShowCursorThisFrame()
			-- debugging_you_can_uncomment_this
			--local mouse_txt = string.format("X:~b~ %f~n~~w~Y:~b~ %f",mousex, mousey)
			--drawTxt(0.89, 0.065, 0, 0, 0.40,mouse_txt,255,255,255,255)
			Texte("X:~b~ ".. mousex .." ~w~Y:~b~ ".. mousey,5000)
		end
	end
end)

function Texte(_texte, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(_texte)
	DrawSubtitleTimed(showtime, 1)
end