-- Some HTML helper functions
local function HTML_Option( value, text, selected )
	if( selected == true ) then
		return [[<option value="]] .. value .. [[" selected>]] .. text .. [[</option>]]
	else
		return [[<option value="]] .. value .. [[">]] .. text .. [[</option>"]]
	end
end

local function HTML_Select_On_Off( name, defaultValue )
	return [[<select name="]] .. name .. [[">]]
		.. HTML_Option("1", "On",  defaultValue == 1 )
		.. HTML_Option("0", "Off", defaultValue == 0 )
		.. [[</select>]]
end

local function HTML_Select_Version( name, defaultValue )
	return [[<select name="]] .. name .. [[">]]
		.. HTML_Option("0",  "Latest Version", defaultValue == 0 )
		.. HTML_Option("61", "1.5.2", defaultValue == 1 )
		.. HTML_Option("60", "1.5.0", defaultValue == 2 )
		.. HTML_Option("49", "1.4.5", defaultValue == 3 )
		.. HTML_Option("47", "1.4.2", defaultValue == 4 )
		.. HTML_Option("39", "1.3.2", defaultValue == 5 )
		.. HTML_Option("29", "1.2.5", defaultValue == 6 )
		.. [[</select>]]
end


local function ShowGeneralSettings( Request )
	local Content = ""
	local InfoMsg = nil
	
	local SettingsIni = cIniFile()
	if not(SettingsIni:ReadFile("settings.ini")) then
		InfoMsg = "<b style=\"color: red;\">ERROR: Could not read settings.ini!</b>"
	end
	
	if (Request.PostParams["general_submit"] ~= nil) then
		
		SettingsIni:SetValue("Server", "Description",Request.PostParams["Server_Description"],false )
		if( tonumber( Request.PostParams["Server_MaxPlayers"] ) ~= nil ) then
			SettingsIni:SetValue("Server", "MaxPlayers", Request.PostParams["Server_MaxPlayers"], false )
		end
		if( tonumber( Request.PostParams["Server_Port"] ) ~= nil ) then
			if( tonumber( Request.PostParams["Server_Port"] ) > 0 ) then
				SettingsIni:SetValue("Server", "Port", Request.PostParams["Server_Port"], false )
			end
		end
		if( tonumber( Request.PostParams["Server_PortsIPv6"] ) ~= nil ) then
			SettingsIni:SetValue("Server", "PortsIPv6", Request.PostParams["Server_PortsIPv6"], false )
		end
		if( tonumber( Request.PostParams["Server_Version"] ) ~= nil ) then
			SettingsIni:SetValue("Server", "PrimaryServerVersion", Request.PostParams["Server_Version"], false )
		end
		if( tonumber( Request.PostParams["Authentication_Authenticate"] ) ~= nil ) then
			SettingsIni:SetValue("Authentication", "Authenticate", Request.PostParams["Authentication_Authenticate"], false )
		end

		if not(SettingsIni:WriteFile("settings.ini")) then
			InfoMsg =  [[<b style="color: red;">ERROR: Could not write to settings.ini!</b>]]
		else
			InfoMsg = [[<b style="color: green;">INFO: Successfully saved changes to settings.ini</b>]]
		end
	end
	
	
	Content = Content .. [[
	<form method="POST">
	<h4>General Settings</h4>]]
	
	if( InfoMsg ~= nil ) then
		Content = Content .. "<p>" .. InfoMsg .. "</p>"
	end
	Content = Content .. [[
	<table>
	<th colspan="2">Server</th>
	<tr><td style="width: 50%;">Description:</td>
	<td><input type="text" name="Server_Description" value="]] .. SettingsIni:GetValue("Server", "Description") .. [["></td></tr>
	<tr><td>Max Players:</td>
	<td><input type="text" name="Server_MaxPlayers" value="]] .. SettingsIni:GetValue("Server", "MaxPlayers") .. [["></td></tr>
	<tr><td>Port:</td>
	<td><input type="text" name="Server_Port" value="]] .. SettingsIni:GetValue("Server", "Port") .. [["></td></tr>
	<tr><td>PortsIPv6:</td>
	<td><input type="text" name="Server_PortsIPv6" value="]] .. SettingsIni:GetValue("Server", "PortsIPv6") .. [["></td></tr>
	<tr><td>Shown Version:</td>
	<td>]] .. HTML_Select_Version("Server_Version", SettingsIni:GetValueI("Server", "PrimaryServerVersion") ) .. [[</td></tr>
	</table><br />
	
	<table>
	<th colspan="2">Authentication</th>
	<tr><td style="width: 50%;">Authenticate:</td>
	<td>]] .. HTML_Select_On_Off("Authentication_Authenticate", SettingsIni:GetValueI("Authentication", "Authenticate") ) .. [[</td></tr>
	</table><br />
	
	<input type="submit" value="Save Settings" name="general_submit"> WARNING: Any changes made here might require a server restart in order to be applied!
	</form>]]
	
	return Content
end


local function ShowMonstersSettings( Request )
	local Content = ""
	local InfoMsg = nil
	
	local SettingsIni = cIniFile()
	if not(SettingsIni:ReadFile("settings.ini")) then
		InfoMsg = "<b style=\"color: red;\">ERROR: Could not read settings.ini!</b>"
	end
	
	if( Request.PostParams["monsters_submit"] ~= nil ) then
		
		if( tonumber( Request.PostParams["Monsters_AnimalsOn"] ) ~= nil ) then
			SettingsIni:SetValue("Monsters", "AnimalsOn", Request.PostParams["Monsters_AnimalsOn"], false )
		end
		if( tonumber( Request.PostParams["Monsters_AnimalSpawnInterval"] ) ~= nil ) then
			SettingsIni:SetValue("Monsters", "AnimalSpawnInterval", Request.PostParams["Monsters_AnimalSpawnInterval"], false )
		end
		SettingsIni:SetValue("Monsters", "Types", Request.PostParams["Monsters_Types"], false )
		if not(SettingsIni:WriteFile("settings.ini")) then
			InfoMsg =  "<b style=\"color: red;\">ERROR: Could not write to settings.ini!</b>"
		else
			InfoMsg = "<b style=\"color: green;\">INFO: Successfully saved changes to settings.ini</b>"
		end
	end
	
	Content = Content .. "<form method=\"POST\">"
	
	Content = Content .. "<h4>Monsters Settings</h4>"
	if( InfoMsg ~= nil ) then
		Content = Content .. "<p>" .. InfoMsg .. "</p>"
	end
	
	Content = Content .. [[
	<table>
	<th colspan="2">Monsters</th>
	<tr><td style="width: 50%;">Animals On:</td>
	<td>]] .. HTML_Select_On_Off("Monsters_AnimalsOn", SettingsIni:GetValueI("Monsters", "AnimalsOn") ) .. [[</td></tr>
	<tr><td>Animal Spawn Interval:</td>
	<td><input type="text" name="Monsters_AnimalSpawnInterval" value="]] .. SettingsIni:GetValue("Monsters", "AnimalSpawnInterval") .. [["></td></tr>
	<tr><td>Monster Types:</td>
	<td><input type="text" name="Monsters_Types" value="]] .. SettingsIni:GetValue("Monsters", "Types") .. [["></td></tr>
	</table><br />
	<input type="submit" value="Save Settings" name="monsters_submit"> WARNING: Any changes made here might require a server restart in order to be applied!
	</form>]]
	
	return Content
end

local function ShowWorldsSettings( Request )
	local Content = ""
	local InfoMsg = nil
	local bSaveIni = false
	
	local SettingsIni = cIniFile()
	if not(SettingsIni:ReadFile("settings.ini")) then
		InfoMsg = [[<b style="color: red;">ERROR: Could not read settings.ini!</b>]]
	end
	
	if( Request.PostParams["RemoveWorld"] ~= nil ) then
		Content = Content .. Request.PostParams["RemoveWorld"]
		local WorldIdx = string.sub( Request.PostParams["RemoveWorld"], string.len("Remove ") )
		local KeyIdx = SettingsIni:FindKey("Worlds")
		local WorldName = SettingsIni:GetValue( KeyIdx, WorldIdx )
		if( SettingsIni:DeleteValueByID( KeyIdx, WorldIdx ) == true ) then
			InfoMsg = "<b style=\"color: green;\">INFO: Successfully removed world " .. WorldName .. "!</b><br />"
			bSaveIni = true
		end
	end
	
	if( Request.PostParams["AddWorld"] ~= nil ) then
		if( Request.PostParams["WorldName"] ~= nil and Request.PostParams["WorldName"] ~= "" ) then
			SettingsIni:SetValue("Worlds", "World", Request.PostParams["WorldName"], true )
			InfoMsg = "<b style=\"color: green;\">INFO: Successfully added world " .. Request.PostParams["WorldName"] .. "!</b><br />"
			bSaveIni = true
		end
	end
	
	if( Request.PostParams["worlds_submit"] ~= nil ) then
		SettingsIni:SetValue("Worlds", "DefaultWorld", Request.PostParams["Worlds_DefaultWorld"], false )
		if( Request.PostParams["Worlds_World"] ~= nil ) then
			SettingsIni:SetValue("Worlds", "World", Request.PostParams["Worlds_World"], true )
		end
		bSaveIni = true
	end
	
	if( bSaveIni == true ) then
		if( InfoMsg == nil ) then InfoMsg = "" end
		if not(SettingsIni:WriteFile("settings.ini")) then
			InfoMsg = InfoMsg .. "<b style=\"color: red;\">ERROR: Could not write to settings.ini!</b>"
		else
			InfoMsg = InfoMsg .. "<b style=\"color: green;\">INFO: Successfully saved changes to settings.ini</b>"
		end
	end
	
	Content = Content .. "<h4>Worlds Settings</h4>"
	if( InfoMsg ~= nil ) then
		Content = Content .. "<p>" .. InfoMsg .. "</p>"
	end
	
	Content = Content .. [[
	<form method="POST">
	<table>
	<th colspan="2">Worlds</th>
	<tr><td style="width: 50%;">Default World:</td>
	<td><input type="Submit" name="Worlds_DefaultWorld" value="]] .. SettingsIni:GetValue("Worlds", "DefaultWorld") .. [["></td></tr>]]
	
	local KeyIdx = SettingsIni:FindKey("Worlds")
	local NumValues = SettingsIni:GetNumValues( KeyIdx )
	for i = 0, NumValues-1 do
		local ValueName = SettingsIni:GetValueName(KeyIdx, i )
		if( ValueName == "World" ) then
			local WorldName = SettingsIni:GetValue(KeyIdx, i)
			Content = Content .. [[
			<tr><td>]] .. ValueName .. [[:</td><td><div style="width: 100px; display: inline-block;">]] .. WorldName .. [[</div><input type="submit" value="Remove ]] .. i .. [[" name="RemoveWorld"></td></tr>]]
		end
	end
	
	Content = Content .. [[
	<tr><td>Add World:</td>
	<td><input type='text' name='WorldName'><input type='submit' name='AddWorld' value='Add World'></td></tr>
	</table><br />
	
	<input type="submit" value="Save Settings" name="worlds_submit"> WARNING: Any changes made here might require a server restart in order to be applied!
	</form>]]
	return Content
end





local function SelectWorldButton( WorldName )
	return "<form method='POST'><input type='hidden' name='WorldName' value='"..WorldName.."'><input type='submit' name='SelectWorld' value='Select'></form>"
end





g_SelectedWorld = {}





function ShowWorldSettings( Request )
	local Content = ""
	local InfoMsg = nil
	local SettingsIni = cIniFile()
	
	if not(SettingsIni:ReadFile("settings.ini")) then
		InfoMsg = [[<b style="color: red;">ERROR: Could not read settings.ini!</b>]]
	end
	
	local WORLD;
	
	if (not g_SelectedWorld[Request.Username]) then
		g_SelectedWorld[Request.Username] = cRoot:Get():GetDefaultWorld()
		WORLD = g_SelectedWorld[Request.Username]:GetName()
	else
		WORLD = g_SelectedWorld[Request.Username]:GetName()
	end
		
	if (Request.PostParams["WorldName"] ~= nil) then		-- World is selected!
		WORLD = Request.PostParams["WorldName"]
		g_SelectedWorld[Request.Username] = cRoot:Get():GetWorld(WORLD)
	end
	
	if (Request.PostParams['WorldIniContent'] ~= nil) then
		local File = io.open(g_SelectedWorld[Request.Username]:GetIniFileName(), "w")
		File:write(Request.PostParams['WorldIniContent'])
		File:close()
	end
	
	Content = Content .. "<h4>World for operations: " .. WORLD .. "</h4>"
	Content = Content .. "<table>"
	local WorldNum = 0
	cRoot:Get():ForEachWorld(
		function(World)
			WorldNum = WorldNum + 1
			Content = Content .. "<tr>"
			Content = Content .. "<td style='width: 10px;'>" .. WorldNum .. ".</td>"
			Content = Content .. "<td>" .. World:GetName() .. "</td>"
			Content = Content .. "<td>" .. SelectWorldButton(World:GetName()) .. "</td>"
			Content = Content .. "</tr>"
		end
	)
	Content = Content .. "</table>"

	local WorldIniContent = cFile:ReadWholeFile(g_SelectedWorld[Request.Username]:GetIniFileName())
	Content = Content .. [[<br />
	
	<form method="post">
	<textarea style="width: 100%; height: 500px;" name="WorldIniContent">]] .. WorldIniContent .. [[</textarea>
	<input type="submit" value="Save Settings" name="world_submit"> WARNING: Any changes made here might require a server restart in order to be applied!
	</form>]]
	return Content
end



function HandleRequest_ServerSettings( Request )
	local Content = ""

	Content = Content .. [[
	<p><b>Server Settings</b></p>
	<table>
	<tr>
	<td><a href="?tab=General">General</a></td>
	<td><a href="?tab=Monsters">Monsters</a></td>
	<td><a href="?tab=Worlds">Worlds</a></td>
	<td><a href="?tab=World">World</a></td>
	</tr>
	</table>
	<br />]]
	
	if( Request.Params["tab"] == "Monsters" ) then
		Content = Content .. ShowMonstersSettings( Request )
	elseif( Request.Params["tab"] == "Worlds" ) then
		Content = Content .. ShowWorldsSettings( Request )
	elseif( Request.Params["tab"] == "World" ) then
		Content = Content .. ShowWorldSettings( Request )
	else
		Content = Content .. ShowGeneralSettings( Request ) -- Default to general settings
	end
	
	return Content
end