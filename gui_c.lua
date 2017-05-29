local edmenu = { show = 0, row = 0, input = 0, name = "default", inp = 0, cur = 0 }
local Ed = { id = {}, x = {}, y = {}, x1 = {}, y1 = {}, scale = {}, r = {}, g = {}, b = {}, a = {}, text = {}, font = {}, jus = {} }
------------------------------------------------
local topmenux = 0.5 -- Position menu X (0.0 = gauche - 0.5 = centre - 1.0 = droite)
local topmenuy = 0.1 -- Position menu Y (0.0 = haut - 0.5 = centre - 1.0 = bas)
local menuscalex = 0.3 -- Scale menu X (horizontale)
local menuscaley = 0.04 -- Scale menu Y (verticale)
------------------------------------------------
local textwidth = 0.185
local textheight = 0.206
local textscale = 0.4
------------------------------------------------
local showtemplate = false
function edMenu()
--------------Load template (test)--------------
	drawAdvText(0.4,0.925,0.185,0.206, 0.4,"Load template (test)",255,255,255,255,4)
	if CursorInZone(0.4 - (0.076 / 2), 0.925 - (0.04 / 2), 0.4 + (0.076 / 2), 0.925 + (0.04 / 2)) then
		DrawRect(0.4,0.925,0.076,0.04,76,88,102,155)
		if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
			if (showtemplate == false) then
				showtemplate = true
				DrawTemplate()
			else
				showtemplate = false
			end
		end
	else
		DrawRect(0.4,0.925,0.076,0.04,0,0,0,155)
	end
------------------------------------------------
	if edmenu.show == 1 then -- main_menu
		if edmenu.row == 0 then
			ShowInfo("Use mouse to select" , 1)
			DrawRect(topmenux,topmenuy,menuscalex,menuscaley,54,100,139,255)
			drawAdvText(topmenux,topmenuy,textwidth,textheight, textscale,"GUI Editor",255,255,255,255,1)
			if edmenu.inp > 0 then drawAdvText(topmenux,topmenuy + menuscaley,textwidth,textheight, textscale,"Continue",255,255,255,255,4)
			else drawAdvText(topmenux,topmenuy + menuscaley,textwidth,textheight, textscale,"Start new",255,255,255,255,4) end
			if edmenu.inp > 0 then drawAdvText(topmenux,topmenuy + (menuscaley * 2),textwidth,textheight, textscale,"Save project",255,255,255,255,4)
			else drawAdvText(topmenux,topmenuy + (menuscaley * 2),textwidth,textheight, textscale,"Load lastsavedui",255,255,255,255,4) end
			drawAdvText(topmenux,topmenuy + (menuscaley * 3),textwidth,textheight, textscale,"Close",255,255,255,255,4)
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + menuscaley - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + menuscaley + (menuscaley / 2)) then -- new
				DrawRect(topmenux,topmenuy + menuscaley,menuscalex,menuscaley,76,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					if edmenu.inp > 0 then
						edmenu.show = 2
						edmenu.row = 0
					else
						edmenu.input = 1
						edmenu.row = 1
						DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
						PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					end
				end
			else DrawRect(topmenux,topmenuy + menuscaley,menuscalex,menuscaley,0,0,0,155) end
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + (menuscaley * 2) - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + (menuscaley * 2) + (menuscaley / 2)) then -- save/load
				DrawRect(topmenux,topmenuy + (menuscaley * 2),menuscalex,menuscaley,78,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					if edmenu.inp > 0 then
						TriggerServerEvent("saveEd", Ed, edmenu.name)
						showLoadingPromt("Saving project...", 1000, 3)
					else
						for index,value in ipairs(lastsavedui) do
							AddElement(value.id, value.x, value.y, value.x1, value.y1, value.scale, value.r, value.g, value.b, value.a, value.text, value.font, value.jus)
							edmenu.inp = 1
						end
					end
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				end
			else DrawRect(topmenux,topmenuy + (menuscaley * 2),menuscalex,menuscaley,0,0,0,155) end
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + (menuscaley * 3) - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + (menuscaley * 3) + (menuscaley / 2)) then -- quit
				DrawRect(topmenux,topmenuy + (menuscaley * 3),menuscalex,menuscaley,78,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					Cursor(0)
					edmenu.show = 0
--					edmenu.row = 0
--					edmenu.cur = 0
--					edmenu.input = 0
--					edmenu.inp = 0
					if edmenu.inp > 0 then
						edmenu.inp = 1
					else
						edmenu.row = 0
						edmenu.cur = 0
						edmenu.input = 0
						edmenu.inp = 0
					end
					SetPlayerControl(PlayerId(), 1, 0)
					ShowInfo("You can start editor by pressing ~INPUT_FRONTEND_DELETE~", 0)
					PlaySound(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				end
			else DrawRect(topmenux,topmenuy + (menuscaley * 3),menuscalex,menuscaley,0,0,0,155) end
			if edmenu.inp > 0 then
				drawAdvText(topmenux,topmenuy + (menuscaley * 4),textwidth,textheight, textscale,"Start new",255,255,255,255,4)
				if CursorInZone(topmenux - (menuscalex / 2), topmenuy + (menuscaley * 4) - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + (menuscaley * 4) + (menuscaley / 2)) then -- new
					DrawRect(topmenux,topmenuy + (menuscaley * 4),menuscalex,menuscaley,78,88,102,155)
					if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
						edmenu.input = 1
						edmenu.row = 1
						DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
						PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					end
				else DrawRect(topmenux,topmenuy + (menuscaley * 4),menuscalex,menuscaley,0,0,0,155) end
				drawAdvText(topmenux,topmenuy + (menuscaley * 5),textwidth,textheight, textscale,"Load lastsavedui",255,255,255,255,4)
				if CursorInZone(topmenux - (menuscalex / 2), topmenuy + (menuscaley * 5) - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + (menuscaley * 5) + (menuscaley / 2)) then -- Load lastsavedui
					DrawRect(topmenux,topmenuy + (menuscaley * 5),menuscalex,menuscaley,78,88,102,155)
					if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
						for index,value in ipairs(lastsavedui) do
							AddElement(value.id, value.x, value.y, value.x1, value.y1, value.scale, value.r, value.g, value.b, value.a, value.text, value.font, value.jus)
							edmenu.inp = 1
						end
					end
				else DrawRect(topmenux,topmenuy + (menuscaley * 5),menuscalex,menuscaley,0,0,0,155) end
			end
		end
	elseif edmenu.show == 4 then
		ShowInfo("Left/Right - to select row, Up/Down - to change state", 1)
		drawAdvText(0.4625, 0.92, 0.005, 0.0028, 0.4, "~r~R", 255, 255, 255, 255, 0, 1)
		drawAdvText(0.4625, 0.94, 0.005, 0.0028, 0.4, tostring(Ed.r[edmenu.cur]), 255, 255, 255, 255, 0, 1)
		drawAdvText(0.4875, 0.92, 0.005, 0.0028, 0.4, "~g~G", 255, 255, 255, 255, 0, 1)
		drawAdvText(0.4875, 0.94, 0.005, 0.0028, 0.4, tostring(Ed.g[edmenu.cur]), 255, 255, 255, 255, 0, 1)
		drawAdvText(0.5125, 0.92, 0.005, 0.0028, 0.4, "~b~B", 255, 255, 255, 255, 0, 1)
		drawAdvText(0.5125, 0.94, 0.005, 0.0028, 0.4, tostring(Ed.b[edmenu.cur]), 255, 255, 255, 255, 0, 1)
		drawAdvText(0.5375, 0.92, 0.005, 0.0028, 0.4, "A", 255, 255, 255, 255, 0, 1)
		drawAdvText(0.5375, 0.94, 0.005, 0.0028, 0.4, tostring(Ed.a[edmenu.cur]), 255, 255, 255, 255, 0, 1)
		if edmenu.row == 1 then DrawRect(0.4625, 0.925, 0.029, 0.04, 0, 0, 0, 150) end
		if edmenu.row == 2 then DrawRect(0.4875, 0.925, 0.029, 0.04, 0, 0, 0, 150) end
		if edmenu.row == 3 then DrawRect(0.5125, 0.925, 0.029, 0.04, 0, 0, 0, 150) end
		if edmenu.row == 4 then DrawRect(0.5375, 0.925, 0.029, 0.04, 0, 0, 0, 150) end
		if IsControlJustPressed(1, 190) or IsDisabledControlJustPressed(1, 190) then -- right
			if edmenu.row < 4 then edmenu.row=edmenu.row+1 else edmenu.row = 1 end
			PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		end
		if IsControlJustPressed(1,189) or IsDisabledControlJustPressed(1, 189) then -- left
			if edmenu.row > 1 then edmenu.row=edmenu.row-1 else edmenu.row = 4 end
			PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		end
		if IsControlPressed(1, 188) or IsDisabledControlPressed(1, 188) then -- up
			if edmenu.row == 1 then
				if Ed.r[edmenu.cur] < 255 then
					Ed.r[edmenu.cur]=Ed.r[edmenu.cur]+1 
				end 
			end
			if edmenu.row == 2 then
				if Ed.g[edmenu.cur] < 255 then 
					Ed.g[edmenu.cur]=Ed.g[edmenu.cur]+1 
				end
			end
			if edmenu.row == 3 then
				if Ed.b[edmenu.cur] < 255 then
					Ed.b[edmenu.cur]=Ed.b[edmenu.cur]+1
				end
			end
			if edmenu.row == 4 then
				if Ed.a[edmenu.cur] < 255 then
					Ed.a[edmenu.cur]=Ed.a[edmenu.cur]+1
				end
			end
			PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		end
		if IsControlPressed(1,187) or IsDisabledControlPressed(1, 187) then -- down
			if edmenu.row == 1 then
				if Ed.r[edmenu.cur] > 0 then
					Ed.r[edmenu.cur]=Ed.r[edmenu.cur]-1 
				end 
			end
			if edmenu.row == 2 then
				if Ed.g[edmenu.cur] > 0 then 
					Ed.g[edmenu.cur]=Ed.g[edmenu.cur]-1 
				end
			end
			if edmenu.row == 3 then
				if Ed.b[edmenu.cur] > 0 then
					Ed.b[edmenu.cur]=Ed.b[edmenu.cur]-1
				end
			end
			if edmenu.row == 4 then
				if Ed.a[edmenu.cur] > 0 then
					Ed.a[edmenu.cur]=Ed.a[edmenu.cur]-1
				end
			end
			PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
		end
		if IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- Backspace
			edmenu.show = 2
			edmenu.row = 2
			PlaySound(-1, "CANCEL", "HUD_FREEMODE_SOUNDSET", 0, 0, 1)
		end
		if #Ed.id ~= nil then
			local i = 1
			for _,val in ipairs(Ed.id) do
				if val == 1 then
					drawAdvText(Ed.x[i],Ed.y[i] ,Ed.x1[i],Ed.y1[i],Ed.scale[i], Ed.text[i], Ed.r[i],Ed.g[i],Ed.b[i],Ed.a[i],Ed.font[i],Ed.jus[i])
				elseif val == 2 then 
					DrawRect(Ed.x[i],Ed.y[i] ,Ed.x1[i],Ed.y1[i],Ed.r[i],Ed.g[i],Ed.b[i],Ed.a[i])
				end
				i=i+1
			end
		end
	elseif edmenu.show == 2 then
		if edmenu.row == 0 then
			ShowInfo("Backspace to return", 1)
			DrawRect(topmenux,topmenuy,menuscalex,menuscaley,54,100,139,255)
			drawAdvText(topmenux,topmenuy,textwidth,textheight, textscale,"Project: "..edmenu.name,255,255,255,255,1)
			drawAdvText(topmenux,topmenuy + menuscaley,textwidth,textheight, textscale,"[+] ADD",255,255,255,255,4)
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + menuscaley - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + menuscaley + (menuscaley / 2)) then
				DrawRect(topmenux,topmenuy + menuscaley,menuscalex,menuscaley,76,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					edmenu.show = 3
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				end
			else DrawRect(topmenux,topmenuy + menuscaley,menuscalex,menuscaley,0,0,0,155) end
			if #Ed.id ~= nil then
				local i = 1
				for _,val in ipairs(Ed.id) do
					if val == 1 then 
						drawAdvText(topmenux,(topmenuy + menuscaley) + (menuscaley * i),textwidth,textheight, textscale,"Text: "..Ed.text[i],Ed.r[i],Ed.g[i],Ed.b[i],255,4)
						
					elseif val == 2 then 
						drawAdvText(topmenux,(topmenuy + menuscaley) + (menuscaley * i),textwidth,textheight, textscale,"Rect",255,255,255,255,4)
					end
					if CursorInZone(topmenux - (menuscalex / 2), topmenuy + (menuscaley * (1 + i)) - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + (menuscaley * (1 + i)) + (menuscaley / 2)) then
						DrawRect(topmenux,(topmenuy + menuscaley) + (menuscaley * i),menuscalex,menuscaley,78,88,102,155)
						if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
							PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
							edmenu.cur = i
							edmenu.row = 2
						end
					else DrawRect(topmenux,(topmenuy + menuscaley) + (menuscaley * i),menuscalex,menuscaley,0,0,0,155) end
					i=i+1
				end
			end
			if IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- Backspace
				edmenu.show = 1
				edmenu.row = 0
				edmenu.cur = 0
				PlaySound(-1, "CANCEL", "HUD_FREEMODE_SOUNDSET", 0, 0, 1)
			end
		elseif edmenu.row == 2 then
			ShowInfo("Use mouse to select", 1)
			DrawRect(topmenux,topmenuy,menuscalex,menuscaley,54,100,139,255)
			drawAdvText(topmenux,topmenuy,textwidth,textheight, textscale,"Project: "..edmenu.name,255,255,255,255,1)
			drawAdvText(topmenux,topmenuy + menuscaley,textwidth,textheight, textscale,"Move x,y",255,255,255,255,4)
			drawAdvText(topmenux,topmenuy + (menuscaley * 2),textwidth,textheight, textscale,"Color/Alpha",255,255,255,255,4)
			local justify_t1 = ""
			if Ed.jus[edmenu.cur] == 0 then justify_t1 = "center" elseif Ed.jus[edmenu.cur] == 1 then justify_t1 = "left" end
			drawAdvText(topmenux,topmenuy + (menuscaley * 3),textwidth,textheight, textscale,"Justify: "..justify_t1,255,255,255,255,4)
			drawAdvText(topmenux,topmenuy + (menuscaley * 4),textwidth,textheight, textscale,"Change text",255,255,255,255,4)
			drawAdvText(topmenux,topmenuy + (menuscaley * 5),textwidth,textheight, textscale,"Copy element",255,255,255,255,4)
			drawAdvText(topmenux,topmenuy + (menuscaley * 6),textwidth,textheight, textscale,"Delete element",255,255,255,255,4)
			drawAdvText(topmenux,topmenuy + (menuscaley * 7),textwidth,textheight, textscale,"Back",255,255,255,255,4)
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + menuscaley - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + menuscaley + (menuscaley / 2)) then -- edit
				DrawRect(topmenux,topmenuy + menuscaley,menuscalex,menuscaley,76,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					edmenu.row = 3
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				end
			else DrawRect(topmenux,topmenuy + menuscaley,menuscalex,menuscaley,0,0,0,155) end
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + (menuscaley * 2) - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + (menuscaley * 2) + (menuscaley / 2)) then -- color
				DrawRect(topmenux,topmenuy + (menuscaley * 2),menuscalex,menuscaley,76,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					PlaySound(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					edmenu.show = 4
					edmenu.row = 1
				end
			else DrawRect(topmenux,topmenuy + (menuscaley * 2),menuscalex,menuscaley,0,0,0,155) end
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + (menuscaley * 3) - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + (menuscaley * 3) + (menuscaley / 2)) then -- justify
				DrawRect(topmenux,topmenuy + (menuscaley * 3),menuscalex,menuscaley,76,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					PlaySound(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					if Ed.jus[edmenu.cur] < 1 then Ed.jus[edmenu.cur]=Ed.jus[edmenu.cur]+1 else Ed.jus[edmenu.cur] = 0 end
					local justify_t = ""
					if Ed.jus[edmenu.cur] == 0 then justify_t = "center" elseif Ed.jus[edmenu.cur] == 1 then justify_t = "left" end
					showLoadingPromt('Changed to: ' ..justify_t, 700, 3)
				end
			else DrawRect(topmenux,topmenuy + (menuscaley * 3),menuscalex,menuscaley,0,0,0,155) end
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + (menuscaley * 4) - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + (menuscaley * 4) + (menuscaley / 2)) then -- Change text
				DrawRect(topmenux,topmenuy + (menuscaley * 4),menuscalex,menuscaley,76,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					if Ed.id[edmenu.cur] == 1 then
						edmenu.input = 1
						edmenu.row = 2
						DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
						PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					else
						showLoadingPromt("Unable to Rect", 1000, 3)
					end
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				end
			else DrawRect(topmenux,topmenuy + (menuscaley * 4),menuscalex,menuscaley,0,0,0,155) end
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + (menuscaley * 5) - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + (menuscaley * 5) + (menuscaley / 2)) then -- copy
				DrawRect(topmenux,topmenuy + (menuscaley * 5),menuscalex,menuscaley,76,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					--Ed.id[],Ed.x[],Ed.y[],Ed.x1[],Ed.y1[],Ed.scale[], Ed.text[], Ed.r[],Ed.g[],Ed.b[],Ed.a[],Ed.font[],Ed.jus[]
					if Ed.id[edmenu.cur] == 1 then
						showLoadingPromt("Text has been copied", 1000, 3)
						AddElement(Ed.id[edmenu.cur],Ed.x[edmenu.cur],Ed.y[edmenu.cur],Ed.x1[edmenu.cur],Ed.y1[edmenu.cur],Ed.scale[edmenu.cur], Ed.r[edmenu.cur],Ed.g[edmenu.cur],Ed.b[edmenu.cur],Ed.a[edmenu.cur],Ed.text[edmenu.cur],Ed.font[edmenu.cur],Ed.jus[edmenu.cur])
					elseif Ed.id[edmenu.cur] == 2 then
						showLoadingPromt("Rect has been copied", 1000, 3)
						AddElement(Ed.id[edmenu.cur],Ed.x[edmenu.cur],Ed.y[edmenu.cur],Ed.x1[edmenu.cur],Ed.y1[edmenu.cur],Ed.scale[edmenu.cur], Ed.r[edmenu.cur],Ed.g[edmenu.cur],Ed.b[edmenu.cur],Ed.a[edmenu.cur],Ed.text[edmenu.cur],Ed.font[edmenu.cur],Ed.jus[edmenu.cur])
					else
						showLoadingPromt("Error. Unknown element", 1000, 3)
					end
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				end
			else DrawRect(topmenux,topmenuy + (menuscaley * 5),menuscalex,menuscaley,0,0,0,155) end
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + (menuscaley * 6) - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + (menuscaley * 6) + (menuscaley / 2)) then -- delete
				DrawRect(topmenux,topmenuy + (menuscaley * 6),menuscalex,menuscaley,76,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					DeleteElement(edmenu.cur)
					edmenu.row = 0
					edmenu.cur = 0
					PlaySound(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				end
			else DrawRect(topmenux,topmenuy + (menuscaley * 6),menuscalex,menuscaley,0,0,0,155) end
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + (menuscaley * 7) - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + (menuscaley * 7) + (menuscaley / 2)) then -- back
				DrawRect(topmenux,topmenuy + (menuscaley * 7),menuscalex,menuscaley,76,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					edmenu.row = 0
					edmenu.cur = 0
					PlaySound(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				end
			else DrawRect(topmenux,topmenuy + (menuscaley * 7),menuscalex,menuscaley,0,0,0,155) end
			if IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- Backspace
				edmenu.row = 0
				edmenu.cur = 0
				PlaySound(-1, "CANCEL", "HUD_FREEMODE_SOUNDSET", 0, 0, 1)
			end
		elseif edmenu.row == 3 then
			if Ed.id[edmenu.cur] == 1 then
				ShowInfo("Arrows to move. ~INPUT_SPRINT~ to boost", 1)
				if IsControlPressed(1, 209) or IsDisabledControlPressed(1, 209) then -- LSHIFT
					if IsControlPressed(1, 190) or IsDisabledControlPressed(1, 190) then -- right
						Ed.x[edmenu.cur]=Ed.x[edmenu.cur]+0.01
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					elseif IsControlPressed(1,189) or IsDisabledControlPressed(1, 189) then -- left
						Ed.x[edmenu.cur]=Ed.x[edmenu.cur]-0.01
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					elseif IsControlPressed(1, 188) or IsDisabledControlPressed(1, 188) then -- up
						Ed.y[edmenu.cur]=Ed.y[edmenu.cur]-0.01
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					elseif IsControlPressed(1,187) or IsDisabledControlPressed(1, 187) then -- down
						Ed.y[edmenu.cur]=Ed.y[edmenu.cur]+0.01
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					end
				else
					if IsControlPressed(1, 190) or IsDisabledControlPressed(1, 190) then -- right
						Ed.x[edmenu.cur]=Ed.x[edmenu.cur]+0.001
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					elseif IsControlPressed(1,189) or IsDisabledControlPressed(1, 189) then -- left
						Ed.x[edmenu.cur]=Ed.x[edmenu.cur]-0.001
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					elseif IsControlPressed(1, 188) or IsDisabledControlPressed(1, 188) then -- up
						Ed.y[edmenu.cur]=Ed.y[edmenu.cur]-0.001
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					elseif IsControlPressed(1,187) or IsDisabledControlPressed(1, 187) then -- down
						Ed.y[edmenu.cur]=Ed.y[edmenu.cur]+0.001
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					end
				end
				if IsControlPressed(1, 224) or IsDisabledControlPressed(1, 224) then -- lCTRL
					if IsControlPressed(1, 209) or IsDisabledControlPressed(1, 209) then -- LSHIFT
						if IsControlPressed(1, 242) or IsDisabledControlPressed(1, 242) then -- wheel_down
							Ed.scale[edmenu.cur] = Ed.scale[edmenu.cur]-0.01
						end
						if IsControlPressed(1, 241) or IsDisabledControlPressed(1, 241) then -- wheel_up
							Ed.scale[edmenu.cur] = Ed.scale[edmenu.cur]+0.01
						end
					else
						if IsControlPressed(1, 242) or IsDisabledControlPressed(1, 242) then -- wheel_down
							Ed.scale[edmenu.cur] = Ed.scale[edmenu.cur]-0.001
						end
						if IsControlPressed(1, 241) or IsDisabledControlPressed(1, 241) then -- wheel_up
							Ed.scale[edmenu.cur] = Ed.scale[edmenu.cur]+0.001
						end
					end
				else
					if IsControlPressed(1, 242) or IsDisabledControlPressed(1, 242) then -- wheel_down
						if Ed.font[edmenu.cur] > 0 then 
							Ed.font[edmenu.cur]=Ed.font[edmenu.cur]-1
							if Ed.font[edmenu.cur] == 5 then
								Ed.font[edmenu.cur] = 4
							elseif Ed.font[edmenu.cur] == 3 or Ed.font[edmenu.cur] == 2 then
								Ed.font[edmenu.cur] = 1
							end
						end
					end
					if IsControlPressed(1, 241) or IsDisabledControlPressed(1, 241) then -- wheel_up
						if Ed.font[edmenu.cur] < 7 then 
							Ed.font[edmenu.cur]=Ed.font[edmenu.cur]+1
							if Ed.font[edmenu.cur] == 5 then
								Ed.font[edmenu.cur] = 6
							elseif Ed.font[edmenu.cur] == 3 or Ed.font[edmenu.cur] == 2 then
								Ed.font[edmenu.cur] = 4
							end
						end
					end
				end
				if IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- Backspace
					edmenu.row = 0
					edmenu.cur = 0
					PlaySound(-1, "CANCEL", "HUD_FREEMODE_SOUNDSET", 0, 0, 1)
				end
			elseif Ed.id[edmenu.cur] == 2 then
				ShowInfo("Arrows to move. ~INPUT_SPRINT~ to boost", 1)
				if IsControlPressed(1, 209) or IsDisabledControlPressed(1, 209) then -- LSHIFT
					if IsControlPressed(1, 190) or IsDisabledControlPressed(1, 190) then -- right
						Ed.x[edmenu.cur]=Ed.x[edmenu.cur]+0.01
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					elseif IsControlPressed(1,189) or IsDisabledControlPressed(1, 189) then -- left
						Ed.x[edmenu.cur]=Ed.x[edmenu.cur]-0.01
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					elseif IsControlPressed(1, 188) or IsDisabledControlPressed(1, 188) then -- up
						Ed.y[edmenu.cur]=Ed.y[edmenu.cur]-0.01
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					elseif IsControlPressed(1,187) or IsDisabledControlPressed(1, 187) then -- down
						Ed.y[edmenu.cur]=Ed.y[edmenu.cur]+0.01
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					end
				else
					if IsControlPressed(1, 190) or IsDisabledControlPressed(1, 190) then -- right
						Ed.x[edmenu.cur]=Ed.x[edmenu.cur]+0.001
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					elseif IsControlPressed(1,189) or IsDisabledControlPressed(1, 189) then -- left
						Ed.x[edmenu.cur]=Ed.x[edmenu.cur]-0.001
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					elseif IsControlPressed(1, 188) or IsDisabledControlPressed(1, 188) then -- up
						Ed.y[edmenu.cur]=Ed.y[edmenu.cur]-0.001
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					elseif IsControlPressed(1,187) or IsDisabledControlPressed(1, 187) then -- down
						Ed.y[edmenu.cur]=Ed.y[edmenu.cur]+0.001
						DrawXYpos(Ed.x[edmenu.cur],Ed.y[edmenu.cur])
					end
				end
				if IsControlPressed(1, 224) or IsDisabledControlPressed(1, 224) then -- lCTRL
					if IsControlPressed(1, 209) or IsDisabledControlPressed(1, 209) then -- LSHIFT
						if IsControlPressed(1, 242) or IsDisabledControlPressed(1, 242) then -- wheel_down
							Ed.x1[edmenu.cur] = Ed.x1[edmenu.cur]-0.01
							DrawXYscale(Ed.x1[edmenu.cur],Ed.y1[edmenu.cur])
						end
						if IsControlPressed(1, 241) or IsDisabledControlPressed(1, 241) then -- wheel_up
							Ed.x1[edmenu.cur] = Ed.x1[edmenu.cur]+0.01
							DrawXYscale(Ed.x1[edmenu.cur],Ed.y1[edmenu.cur])
						end
					else
						if IsControlPressed(1, 242) or IsDisabledControlPressed(1, 242) then -- wheel_down
							Ed.x1[edmenu.cur] = Ed.x1[edmenu.cur]-0.001
							DrawXYscale(Ed.x1[edmenu.cur],Ed.y1[edmenu.cur])
						end
						if IsControlPressed(1, 241) or IsDisabledControlPressed(1, 241) then -- wheel_up
							Ed.x1[edmenu.cur] = Ed.x1[edmenu.cur]+0.001
							DrawXYscale(Ed.x1[edmenu.cur],Ed.y1[edmenu.cur])
						end
					end
				else
					if IsControlPressed(1, 209) or IsDisabledControlPressed(1, 209) then -- LSHIFT
						if IsControlPressed(1, 242) or IsDisabledControlPressed(1, 242) then -- wheel_down
							Ed.y1[edmenu.cur] = Ed.y1[edmenu.cur]-0.01
							DrawXYscale(Ed.x1[edmenu.cur],Ed.y1[edmenu.cur])
						end
						if IsControlPressed(1, 241) or IsDisabledControlPressed(1, 241) then -- wheel_up
							Ed.y1[edmenu.cur] = Ed.y1[edmenu.cur]+0.01
							DrawXYscale(Ed.x1[edmenu.cur],Ed.y1[edmenu.cur])
						end
					else
						if IsControlPressed(1, 242) or IsDisabledControlPressed(1, 242) then -- wheel_down
							Ed.y1[edmenu.cur] = Ed.y1[edmenu.cur]-0.001
							DrawXYscale(Ed.x1[edmenu.cur],Ed.y1[edmenu.cur])
						end
						if IsControlPressed(1, 241) or IsDisabledControlPressed(1, 241) then -- wheel_up
							Ed.y1[edmenu.cur] = Ed.y1[edmenu.cur]+0.001
							DrawXYscale(Ed.x1[edmenu.cur],Ed.y1[edmenu.cur])
						end
					end
				end
				if IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- Backspace
					edmenu.row = 0
					edmenu.cur = 0
					PlaySound(-1, "CANCEL", "HUD_FREEMODE_SOUNDSET", 0, 0, 1)
				end
			end
		end
		if #Ed.id ~= nil then
			local i = 1
			for _,val in ipairs(Ed.id) do
				if val == 1 then
					drawAdvText(Ed.x[i],Ed.y[i] ,Ed.x1[i],Ed.y1[i],Ed.scale[i], Ed.text[i], Ed.r[i],Ed.g[i],Ed.b[i],Ed.a[i],Ed.font[i],Ed.jus[i])
				elseif val == 2 then 
					DrawRect(Ed.x[i],Ed.y[i] ,Ed.x1[i],Ed.y1[i],Ed.r[i],Ed.g[i],Ed.b[i],Ed.a[i])
				end
				i=i+1
			end
		end
	elseif edmenu.show == 3 then
		if edmenu.row == 0 then
			ShowInfo("Select with mouse", 1)
			DrawRect(topmenux,topmenuy,menuscalex,menuscaley,54,100,139,255)
			drawAdvText(topmenux,topmenuy,textwidth,textheight, textscale,"Project: "..edmenu.name,255,255,255,255,1)
			drawAdvText(topmenux,topmenuy + menuscaley,textwidth,textheight, textscale,"Add: text",255,255,255,255,4)
			drawAdvText(topmenux,topmenuy + (menuscaley * 2),textwidth,textheight, textscale,"Add: rectangle",255,255,255,255,4)
			drawAdvText(topmenux,topmenuy + (menuscaley * 3),textwidth,textheight, textscale,"Back",255,255,255,255,4)
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + menuscaley - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + menuscaley + (menuscaley / 2)) then -- text
				DrawRect(topmenux,topmenuy + menuscaley,menuscalex,menuscaley,76,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					edmenu.show = 2
					edmenu.row = 0
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					--AddElement(1, 0.26, 0.6, 0.005, 0.0028, 0.40, 255, 255, 255, 255, "Default text", 0, 0)
					AddElement(1, 0.1, 0.4, textwidth, textheight, textscale, 255, 255, 255, 255, "Default text", 0, 0)
				end
			else DrawRect(topmenux,topmenuy + menuscaley,menuscalex,menuscaley,0,0,0,155) end
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + (menuscaley * 2) - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + (menuscaley * 2) + (menuscaley / 2)) then -- rect
				DrawRect(topmenux,topmenuy + (menuscaley * 2),menuscalex,menuscaley,78,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					edmenu.show = 2
					edmenu.row = 0
					PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					AddElement(2, 0.1, 0.4, 0.2, 0.2, 0.40, 0, 0, 0, 150, "Default", 0, 0)
				end
			else DrawRect(topmenux,topmenuy + (menuscaley * 2),menuscalex,menuscaley,0,0,0,155) end
			if CursorInZone(topmenux - (menuscalex / 2), topmenuy + (menuscaley * 3) - (menuscaley / 2), topmenux + (menuscalex / 2), topmenuy + (menuscaley * 3) + (menuscaley / 2)) then -- back
				DrawRect(topmenux,topmenuy + (menuscaley * 3),menuscalex,menuscaley,78,88,102,155)
				if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
					edmenu.show = 2
					edmenu.row = 0
					PlaySound(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
				end
			else DrawRect(topmenux,topmenuy + (menuscaley * 3),menuscalex,menuscaley,0,0,0,155) end
			if IsControlJustPressed(1, 202) or IsDisabledControlJustPressed(1, 202) then -- Backspace
				edmenu.show = 2
				edmenu.row = 0
				PlaySound(-1, "CANCEL", "HUD_FREEMODE_SOUNDSET", 0, 0, 1)
			end
		end
	end
end

function drawAdvText(x,y ,width,height,scale, text, r,g,b,a, font, jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	SetTextCentre(true)
	DrawText(x, y - (scale / 20))
--    DrawText(x - width/2, y - height/2 + 0.005)
end

function ShowInfo(text, state)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function showLoadingPromt(showText, showTime, showType)
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		N_0xaba17d7ce615adbf("STRING")
		AddTextComponentString(showText)
		N_0xbd12f8228410d9b4(showType)
		Citizen.Wait(showTime)
		N_0x10d373323e5b9c0d()
	end)
end

function AddElement(id, x, y, x1, y1, scale, r, g, b, a, text, font, jus)
	table.insert(Ed.id, id) 
	table.insert(Ed.x, x)
	table.insert(Ed.y, y)
	table.insert(Ed.x1, x1)
	table.insert(Ed.y1, y1)
	table.insert(Ed.scale, scale)
	table.insert(Ed.r, r)
	table.insert(Ed.g, g)
	table.insert(Ed.b, b)
	table.insert(Ed.a, a)
	table.insert(Ed.text, text)
	table.insert(Ed.font, font)
	table.insert(Ed.jus, jus)
	if id == 1 then showLoadingPromt("Text has been added", 1000, 3)
	elseif id == 2 then showLoadingPromt("Rectangle has been added", 1000, 3) end
end

function DeleteElement(id)
	table.remove(Ed.id, id) 
	table.remove(Ed.x, id)
	table.remove(Ed.y, id)
	table.remove(Ed.x1, id)
	table.remove(Ed.y1, id)
	table.remove(Ed.scale, id)
	table.remove(Ed.r, id)
	table.remove(Ed.g, id)
	table.remove(Ed.b, id)
	table.remove(Ed.a, id)
	table.remove(Ed.text, id)
	table.remove(Ed.font, id)
	table.remove(Ed.jus, id)
	if id == 1 then showLoadingPromt("Text has been deleted", 1000, 3)
	elseif id == 2 then showLoadingPromt("Rectangle has been deleted", 1000, 3) end
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		edMenu()
		if IsControlJustPressed(1, 214) or IsDisabledControlJustPressed(1, 214) then -- DEL
			if edmenu.show == 0 then
				Cursor(1)
				edmenu.show = 1
				if edmenu.inp > 0 then
					edmenu.inp = 1
				else
					edmenu.row = 0
					edmenu.cur = 0
					edmenu.inp = 0
					edmenu.input = 0
				end
				SetPlayerControl(PlayerId(), 0, 0)
			end
		end
		if edmenu.input == 1 then
			HideHudAndRadarThisFrame()
			if UpdateOnscreenKeyboard() == 3 then
				edmenu.input = 0
				edmenu.show = 1
				edmenu.row = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				local inputText = GetOnscreenKeyboardResult()
				if edmenu.show == 1 and edmenu.row == 1 then
					if string.len(inputText) > 0 then
						showLoadingPromt("Project "..inputText.." created...", 1500, 3)
						edmenu.inp = 1
						edmenu.cur = 0
						edmenu.name = inputText
						edmenu.show = 2
						edmenu.row = 0
						edmenu.input = 0
					else
						DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
					end
				end
				if edmenu.show == 2 and edmenu.row == 2 then
					if string.len(inputText) > 0 then
						if edmenu.cur > 0 then
							showLoadingPromt('Text changed to: '..inputText, 1500, 3)
							Ed.text[edmenu.cur] = inputText
						else
							showLoadingPromt("Error. Element is not selected!", 1500, 3)
						end
						edmenu.input = 0
					else
						DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
					end
				end
			elseif UpdateOnscreenKeyboard() == 2 then
				edmenu.input = 0
				if edmenu.show == 1 and edmenu.row == 1 then
					edmenu.show = 1
					edmenu.row = 0
				end
			end
		end
	end
end)
------------------------------Position & Scale infos------------------------------
local coordx = 0
local coordy = 0
function DrawXYpos(x,y)
	coordx = x
	coordy = y
end

local scalex = 0
local scaley = 0
function DrawXYscale(x,y)
	scalex = x
	scaley = y
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		drawAdvText(0.6, 0.92, 0.005, 0.0028, 0.40,"Scale X:~b~ "..scalex.." ~w~Y:~b~ "..scaley,255,255,255,255,4)
		drawAdvText(0.6, 0.94, 0.005, 0.0028, 0.40,"Position X:~b~ "..coordx.." ~w~Y:~b~ "..coordy,255,255,255,255,4)
	end
end)
------------------------------Drawing template------------------------------------
function DrawTemplate()
    Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if showtemplate then
				if not HasStreamedTextureDictLoaded("template") then
					RequestStreamedTextureDict("template", true)
					while not HasStreamedTextureDictLoaded("template") do
						Wait(0)
					end
				else
					DrawSprite("template", "tablet", 0.5,0.5,0.64,1.0, 0.0, 255, 255, 255, 255)
				end
			else
				break
			end
		end
	end)
end
----------------------------------------------------------------------------------
