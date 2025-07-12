require("T6.HardwareProfileLeftRightSelector")
require("T6.HardwareProfileLeftRightSlider")
require("T6.KeyBindSelector")
require("T6.CategoryCarousel")
require("T6.Menus.OptionsControls")
require("T6.Menus.OptionsSettings")
require("T6.Menus.SafeAreaMenu")
require("T6.Menus.SystemInfoMenu")
require("T6.AudioSettingsOptions")
require("T6.BrightnessOptions")
require("T6.ButtonLayoutOptions")
require("T6.StickLayoutOptions")
CoD.MapList = {}
CoD.MapList.ButtonListWidth = 500
CoD.MapList.Width = 540
CoD.MapList.AdjustSFX = "cac_safearea"
CoD.MapList.Back = function (f1_arg0, f1_arg1)
	CoD.MapList.UpdateWindowPosition()
	Engine.Exec(f1_arg1.controller, "updategamerprofile")
	Engine.SaveHardwareProfile()
	Engine.ApplyHardwareProfileSettings()
	if CoD.isSinglePlayer == true then
		Engine.SendMenuResponse(f1_arg1.controller, "luisystem", "modal_stop")
	end
	f1_arg0:goBack(f1_arg1.controller)
end

CoD.MapList.CloseMenu = function (f2_arg0, f2_arg1)
	CoD.MapList.UpdateWindowPosition()
	Engine.Exec(f2_arg1.controller, "updategamerprofile")
	Engine.SaveHardwareProfile()
	Engine.ApplyHardwareProfileSettings()
	f2_arg0:close()
end

CoD.MapList.UpdateWindowPosition = function ()
	Engine.SetHardwareProfileValue("vid_xpos", Dvar.vid_xpos:get())
	Engine.SetHardwareProfileValue("vid_ypos", Dvar.vid_ypos:get())
	Engine.SetHardwareProfileValue("sd_xa2_device_guid", UIExpression.DvarString(nil, "sd_xa2_device_guid"))
end

CoD.MapList.Close = function (f3_arg0)
	Engine.Exec(f3_arg0:getOwner(), "updategamerprofile")
	CoD.Menu.close(f3_arg0)
end

CoD.MapList.Cargo = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_dockside")
end

CoD.MapList.Carrier = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_carrier")
end

CoD.MapList.Drone = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_drone")
end

CoD.MapList.Express = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_express")
end

CoD.MapList.Raid = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_raid")
end

CoD.MapList.Slums = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_slums")
end

CoD.MapList.Standoff = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_village")
end

CoD.MapList.Turbine = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_turbine")
end

CoD.MapList.Yemen = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_socotra")
end

CoD.MapList.Nuketown = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_nuketown_2020")
end

CoD.MapList.RandomBase = function (IngameMenuWidget, ClientInstance)
    local maps = {
        "mp_dockside",
		"mp_carrier",
        "mp_drone",
        "mp_express",
        "mp_raid",
        "mp_slums",
        "mp_village",
        "mp_turbine",
        "mp_socotra",
        "mp_nuketown_2020"
    }
    local randomMap = maps[math.random(1, #maps)]
    Engine.Exec(ClientInstance.controller, "map " .. randomMap)
end

CoD.MapList.RandomDLC = function (IngameMenuWidget, ClientInstance)
    local maps = {
        "mp_downhill",
        "mp_mirage",
        "mp_hydro",
        "mp_skate",
        "mp_concert",
        "mp_magma",
        "mp_vertigo",
        "mp_studio",
        "mp_uplink",
        "mp_bridge",
        "mp_castaway",
        "mp_paintball",
        "mp_dig",
        "mp_frostbite",
        "mp_pod",
        "mp_takeoff"
    }
    local randomMap = maps[math.random(1, #maps)]
    Engine.Exec(ClientInstance.controller, "map " .. randomMap)
end


CoD.MapList.Downhill = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_downhill")
end

CoD.MapList.Mirage = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_mirage")
end

CoD.MapList.Hydro = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_hydro")
end

CoD.MapList.Grind = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_skate")
end

CoD.MapList.Encore = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_concert")
end

CoD.MapList.Magma = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_magma")
end


CoD.MapList.Vertigo = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_vertigo")
end


CoD.MapList.Studio = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_studio")
end


CoD.MapList.Uplink = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_uplink")
end


CoD.MapList.Detour = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_bridge")
end


CoD.MapList.Cove = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_castaway")
end


CoD.MapList.Rush = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_paintball")
end


CoD.MapList.Dig = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_dig")
end


CoD.MapList.Frost = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_frostbite")
end


CoD.MapList.Pod = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_pod")
end


CoD.MapList.Takeoff = function (IngameMenuWidget, ClientInstance)
    Engine.Exec(ClientInstance.controller, "map mp_takeoff")
end


CoD.MapList.AddOptionCategories = function (f42_arg0)
	if UIExpression.IsInGame() == 0 then
		f42_arg0.systemInfoButton = CoD.ButtonPrompt.new("select", Engine.Localize("MENU_SYSTEM_INFO_CAPS"), f42_arg0, "open_system_info", nil, nil, nil, nil, "S")
		f42_arg0:addRightButtonPrompt(f42_arg0.systemInfoButton)
	end
	local f42_local0, f42_local1 = nil
	local f42_local2 = CoD.ButtonList.new()
	local f42_local3 = CoD.ButtonList.new()
	if UIExpression.IsInGame() == 0 then
		local f42_local3 = 50
		local f42_local4 = 30
		local f42_local5 = 300
		local f42_local6 = 2 * (f42_local3 + f42_local4) - f42_local4
		f42_local2:setLeftRight(false, false, -f42_local5 / 2, f42_local5 / 2)
		f42_local2:setTopBottom(false, false, -f42_local6 / 2, f42_local6 / 2 + 100)
		f42_local2:setSpacing(f42_local4)
		f42_local0 = f42_local2:addNavButton(Engine.Localize("MENU_SETTINGS_CAPS"), "open_settings")
		f42_local1 = f42_local2:addNavButton(Engine.Localize("MENU_CONTROLS_CAPS"), "open_controls")
		if not CoD.isSinglePlayer then
			f42_local0.brackets:close()
			f42_local0.m_skipAnimation = true
			f42_local1.brackets:close()
			f42_local1.m_skipAnimation = true
		end
	else
		if CoD.isSinglePlayer then
			f42_local2:setLeftRight(false, false, -CoD.ObjectiveInfoMenu.ElementWidth - CoD.ObjectiveInfoMenu.ElementSpacing / 2, -CoD.ObjectiveInfoMenu.ElementSpacing / 2)
			f42_local2:setTopBottom(true, true, CoD.ObjectiveInfoMenu.Pause_ButtonsTopAnchor, 0)
		else
			f42_local2:setLeftRight(true, false, 0, CoD.ButtonList.DefaultWidth)
			f42_local2:setTopBottom(true, true, CoD.Menu.TitleHeight + 40, 0)

			--dlc map list
			f42_local3:setLeftRight(false, true, -455, CoD.ButtonList.DefaultWidth)
			f42_local3:setTopBottom(true, true, CoD.Menu.TitleHeight + 40, 0)
		end
		if not CoD.isMultiplayer then
			f42_local2:setButtonBackingAnimationState({
				leftAnchor = true,
				rightAnchor = true,
				left = -5,
				right = 0,
				topAnchor = true,
				bottomAnchor = true,
				top = 0,
				bottom = 0,
				material = RegisterMaterial("menu_mp_small_row")
			})
		end
		f42_local1 = f42_local2:addButton(Engine.Localize("Random Base Map"))
		f42_local1:setActionEventName("map_random_base")
		f42_local0 = f42_local2:addButton(Engine.Localize("Cargo"))
		f42_local0:setActionEventName("map_cargo")
		f42_local0 = f42_local2:addButton(Engine.Localize("Carrier"))
		f42_local0:setActionEventName("map_carrier")
		f42_local1 = f42_local2:addButton(Engine.Localize("Drone"))
		f42_local1:setActionEventName("map_drone")
		f42_local1 = f42_local2:addButton(Engine.Localize("Express"))
		f42_local1:setActionEventName("map_express")
		f42_local1 = f42_local2:addButton(Engine.Localize("Raid"))
		f42_local1:setActionEventName("map_raid")
		f42_local1 = f42_local2:addButton(Engine.Localize("Slums"))
		f42_local1:setActionEventName("map_raid")
		f42_local1 = f42_local2:addButton(Engine.Localize("Standoff"))
		f42_local1:setActionEventName("map_standoff")
		f42_local1 = f42_local2:addButton(Engine.Localize("Turbine"))
		f42_local1:setActionEventName("map_turbine")
		f42_local1 = f42_local2:addButton(Engine.Localize("Yemen"))
		f42_local1:setActionEventName("map_yemen")
		f42_local1 = f42_local2:addButton(Engine.Localize("Nuketown"))
		f42_local1:setActionEventName("map_nuketown")

		f42_local1 = f42_local3:addButton(Engine.Localize("Random DLC Map"))
		f42_local1:setActionEventName("map_random_dlc")
		f42_local1 = f42_local3:addButton(Engine.Localize("Downhill"))
		f42_local1:setActionEventName("map_downhill")
		f42_local1 = f42_local3:addButton(Engine.Localize("Mirage"))
		f42_local1:setActionEventName("map_mirage")
		f42_local1 = f42_local3:addButton(Engine.Localize("Hydro"))
		f42_local1:setActionEventName("map_hydro")
		f42_local1 = f42_local3:addButton(Engine.Localize("Grind"))
		f42_local1:setActionEventName("map_grind")
		f42_local1 = f42_local3:addButton(Engine.Localize("Encore"))
		f42_local1:setActionEventName("map_encore")
		f42_local1 = f42_local3:addButton(Engine.Localize("Magma"))
		f42_local1:setActionEventName("map_magma")
		f42_local1 = f42_local3:addButton(Engine.Localize("Vertigo"))
		f42_local1:setActionEventName("map_vertigo")
		f42_local1 = f42_local3:addButton(Engine.Localize("Studio"))
		f42_local1:setActionEventName("map_studio")
		f42_local1 = f42_local3:addButton(Engine.Localize("Uplink"))
		f42_local1:setActionEventName("map_uplink")
		f42_local1 = f42_local3:addButton(Engine.Localize("Detour"))
		f42_local1:setActionEventName("map_detour")
		f42_local1 = f42_local3:addButton(Engine.Localize("Cove"))
		f42_local1:setActionEventName("map_cove")
		f42_local1 = f42_local3:addButton(Engine.Localize("Rush"))
		f42_local1:setActionEventName("map_rush")
		f42_local1 = f42_local3:addButton(Engine.Localize("Dig"))
		f42_local1:setActionEventName("map_dig")
		f42_local1 = f42_local3:addButton(Engine.Localize("Frost"))
		f42_local1:setActionEventName("map_frost")
		f42_local1 = f42_local3:addButton(Engine.Localize("Pod"))
		f42_local1:setActionEventName("map_pod")
		f42_local1 = f42_local3:addButton(Engine.Localize("Takeoff"))
		f42_local1:setActionEventName("map_takeoff")
	end
	f42_arg0:addElement(f42_local2)
	if not f42_arg0:restoreState() then
		f42_local0:processEvent({
			name = "gain_focus"
		})
	end
	f42_arg0:addElement(f42_local3)
	if not f42_arg0:restoreState() then
		f42_local0:processEvent({
			name = "gain_focus"
		})
	end
	if CoD.isSinglePlayer == true and Engine.IsMenuLevel() == true then
		f42_arg0:setPreviousMenu("CampaignMenu")
	end
	Engine.SyncHardwareProfileWithDvars()
end

LUI.createMenu.mapMenu = function (f43_arg0)
	local f43_local0 = nil
	if UIExpression.IsInGame() == 1 then
		f43_local0 = CoD.InGameMenu.New("mapMenu", f43_arg0, Engine.Localize("CHANGE MAP MENU"))
		if CoD.isSinglePlayer == true then
			f43_local0:setPreviousMenu("ObjectiveInfoMenu")
		elseif UIExpression.IsDemoPlaying(f43_arg0) ~= 0 then
			f43_local0:setPreviousMenu("Demo_InGame")
		else
			f43_local0:setPreviousMenu("class")
		end
	else
		f43_local0 = CoD.Menu.New("mapMenu")
		f43_local0.anyControllerAllowed = true
		f43_local0:addTitle(Engine.Localize("MENU_OPTIONS_CAPS"), LUI.Alignment.Center)
		if CoD.isSinglePlayer == false then
			f43_local0:addLargePopupBackground()
		end
	end
	if CoD.isSinglePlayer == true then
		Engine.SendMenuResponse(f43_arg0, "luisystem", "modal_start")
	end
	f43_local0:registerEventHandler("button_prompt_back", CoD.MapList.Back)

	local baseGame = LUI.UIText.new()
	baseGame:setLeftRight(true, false, 0, 200) 
	baseGame:setTopBottom(true, false, 55, 80) 
	baseGame:setText(Engine.Localize("Base Game Maps:"))
	baseGame:setFont(CoD.fonts.Small) -- Smaller font
	baseGame:setRGB(1, 1, 1)
	baseGame:setAlpha(0.8)
	f43_local0:addElement(baseGame)

	local dlcMaps = LUI.UIText.new()
	dlcMaps:setLeftRight(true, false, 408, 200) 
	dlcMaps:setTopBottom(true, false, 55, 80) 
	dlcMaps:setText(Engine.Localize("DLC Maps:"))
	dlcMaps:setFont(CoD.fonts.Small) 
	dlcMaps:setRGB(1, 1, 1)
	dlcMaps:setAlpha(0.8)
	f43_local0:addElement(dlcMaps)

	local notice = LUI.UIText.new()
	notice:setLeftRight(true, false, 275, 200) 
	notice:setTopBottom(true, false, 13, 33) 
	notice:setText(Engine.Localize("^1Notice:^7 If you have a map rotation set, changing the map will stop the map rotation."))
	notice:setFont(CoD.fonts.Small) 
	notice:setRGB(1, 1, 1)
	notice:setAlpha(0.8)
	f43_local0:addElement(notice)

	--map list in order
	f43_local0:registerEventHandler("map_cargo", CoD.MapList.Cargo)
	f43_local0:registerEventHandler("map_carrier", CoD.MapList.Carrier)
	f43_local0:registerEventHandler("map_drone", CoD.MapList.Drone)
	f43_local0:registerEventHandler("map_express", CoD.MapList.Express)
	f43_local0:registerEventHandler("map_raid", CoD.MapList.Raid)
	f43_local0:registerEventHandler("map_slums", CoD.MapList.Slum)
	f43_local0:registerEventHandler("map_standoff", CoD.MapList.Standoff)
	f43_local0:registerEventHandler("map_turbine", CoD.MapList.Turbine)
	f43_local0:registerEventHandler("map_yemen", CoD.MapList.Yemen)
	f43_local0:registerEventHandler("map_nuketown", CoD.MapList.Nuketown)
	f43_local0:registerEventHandler("map_random_base", CoD.MapList.RandomBase)

	--dlc maps
	f43_local0:registerEventHandler("map_random_dlc", CoD.MapList.RandomDLC)
	f43_local0:registerEventHandler("map_downhill", CoD.MapList.Downhill)
	f43_local0:registerEventHandler("map_mirage", CoD.MapList.Mirage)
	f43_local0:registerEventHandler("map_hydro", CoD.MapList.Hydro)
	f43_local0:registerEventHandler("map_grind", CoD.MapList.Grind)
	f43_local0:registerEventHandler("map_encore", CoD.MapList.Encore)
	f43_local0:registerEventHandler("map_magma", CoD.MapList.Magma)
	f43_local0:registerEventHandler("map_vertigo", CoD.MapList.Vertigo)
	f43_local0:registerEventHandler("map_studio", CoD.MapList.Studio)
	f43_local0:registerEventHandler("map_uplink", CoD.MapList.Uplink)
	f43_local0:registerEventHandler("map_detour", CoD.MapList.Detour)
	f43_local0:registerEventHandler("map_cove", CoD.MapList.Cove)
	f43_local0:registerEventHandler("map_rush", CoD.MapList.Rush)
	f43_local0:registerEventHandler("map_dig", CoD.MapList.Dig)
	f43_local0:registerEventHandler("map_frost", CoD.MapList.Frost)
	f43_local0:registerEventHandler("map_pod", CoD.MapList.Pod)
	f43_local0:registerEventHandler("map_takeoff", CoD.MapList.Takeoff)


	f43_local0:addSelectButton()
	f43_local0:addBackButton()
	CoD.MapList.AddOptionCategories(f43_local0)
	return f43_local0
end
