require("T6.Lobby")
require("T6.Menus.PopupMenus")

local selfinfo = {}
CoD.Levels = {}

local function modListBackEventHandler(self, parent)
    CoD.Menu.ButtonPromptBack(self, parent)
end

CoD.Levels.generatePlayerInfo = function (f2_arg0)
	local f2_local0 = {}
	local f2_local1 = UIExpression.GetDStat(f2_arg0, "PlayerStatsList", "RANK", "StatValue")
	local f2_local2 = UIExpression.GetDStat(f2_arg0, "PlayerStatsList", "PLEVEL", "StatValue")
	f2_local0.name = UIExpression.GetSelfGamertag(f2_arg0)
	f2_local0.clanTag = UIExpression.GetClanName(f2_arg0)
	f2_local0.rank = UIExpression.GetDisplayLevelByXUID(f2_arg0, UIExpression.GetXUID(f2_arg0))
	f2_local0.codpoints = UIExpression.GetStatByName(f2_arg0, "CODPOINTS")
	f2_local0.rankImage = UIExpression.TableLookup(f2_arg0, CoD.rankIconTable, 0, f2_local1, f2_local2 + 1)
	f2_local0.emblemBackground = UIExpression.EmblemPlayerBackgroundMaterial(f2_arg0, UIExpression.GetXUID(f2_arg0), 0)
	if tonumber(f2_local0.rank) == nil then
		f2_local0.rank = "0"
	end
	return f2_local0
end

function LUI.createMenu.Levels(controller, f7_arg4)
    local self = CoD.Menu.New("Levels")
    self.controller = controller

    self:setPreviousMenu("MainMenu")
    self:addSelectButton()
    self:addBackButton()
    self:addTitle("Prestige Menu")

    self.backButton = CoD.ButtonPrompt.new("secondary", Engine.Localize("MENU_BACK"), self, "button_prompt_back")
    self:registerEventHandler("button_prompt_back", modListBackEventHandler)

    local buttonListWidth = 400  
    local buttonListTop = 100
    local buttonListHeight = 510  
    self.buttonList = CoD.ButtonList.new({
        leftAnchor = true,
        rightAnchor = false,
        left = 0,
        right = 50 + buttonListWidth,
        topAnchor = true,
        bottomAnchor = false,
        top = buttonListTop,
        bottom = buttonListTop + buttonListHeight,  
        alpha = 1
    })
    self:addElement(self.buttonList)

    local buttonListWidth2 = 400  
    local buttonListTop2 = 50
    local buttonListHeight2 = 510  
    self.buttonList2 = CoD.ButtonList.new({
        leftAnchor = true,
        rightAnchor = false,
        left = 0,
        right = 50 + buttonListWidth2,
        topAnchor = true,
        bottomAnchor = false,
        top = buttonListTop2,
        bottom = buttonListTop2 + buttonListHeight2,  
        alpha = 1
    })
    self:addElement(self.buttonList2)

    local playerInfo = CoD.Levels.generatePlayerInfo(controller)

    local callingCardContainer = LUI.UIElement.new()
    callingCardContainer:setLeftRight(false, true, -200, -10) 
    callingCardContainer:setTopBottom(true, false, 300, 350)
    self:addElement(callingCardContainer)

    local callingCard = LUI.UIImage.new()
    callingCard:setLeftRight(true, true, 2, -2) 
    callingCard:setTopBottom(true, true, 2, -2) 
    callingCard:setRGB(1, 1, 1)
    callingCard:setAlpha(1)
    if playerInfo.emblemBackground then
        callingCard:setImage(RegisterMaterial(playerInfo.emblemBackground))
    end
    callingCardContainer:addElement(callingCard)

    local callingCardBorder = CoD.Border.new(1, 1, 1, 1, 1) 
    callingCardContainer:addElement(callingCardBorder)

    local prestigeIcon = LUI.UIImage.new()
    prestigeIcon:setLeftRight(false, true, -195, -160) 
    prestigeIcon:setTopBottom(true, false, 358, 393)
    prestigeIcon:setAlpha(1)
    if playerInfo.rankImage then
        prestigeIcon:setImage(RegisterMaterial(playerInfo.rankImage))
    end
    self:addElement(prestigeIcon)

    local playerLevel = LUI.UIText.new()
    playerLevel:setLeftRight(false, true, -190, -15)
    playerLevel:setTopBottom(true, false, 376, 397) 
    playerLevel:setFont(CoD.fonts.Condensed)
    playerLevel:setAlignment(LUI.Alignment.Right)
    playerLevel:setText("Level " .. (playerInfo.rank or "0"))
    self:addElement(playerLevel)

    local prestigeNum = LUI.UIText.new()
    prestigeNum:setLeftRight(false, true, -190, -15)
    prestigeNum:setTopBottom(true, false, 355, 380) 
    prestigeNum:setFont(CoD.fonts.Condensed)
    prestigeNum:setAlignment(LUI.Alignment.Right)
    local prestige = tonumber(playerInfo.rankImage and UIExpression.GetDStat(controller, "PlayerStatsList", "PLEVEL", "StatValue") or 0)
    prestigeNum:setText(Engine.Localize("MPUI_PRESTIGE_N", prestige))
    self:addElement(prestigeNum)

    local pstats1 = LUI.UIText.new()
    pstats1:setLeftRight(true, false, 670, -35)
    pstats1:setTopBottom(true, false, 303, 320) 
    pstats1:setFont(CoD.fonts.Condensed)
    pstats1:setAlignment(LUI.Alignment.Right)
    pstats1:setText(playerInfo.name)
    self:addElement(pstats1)
    
    local unlockAllButton = self.buttonList2:addButton(Engine.Localize("UNLOCK ALL"), nil, nil) 
    unlockAllButton:registerEventHandler("button_action", function(self, event)
        Engine.Exec(self.controller, "unlockall")
        local updatedPlayerInfo = CoD.Levels.generatePlayerInfo(self.controller)
        prestigeNum:setText(Engine.Localize("MPUI_PRESTIGE_N", updatedPlayerInfo.prestige or 11)) 
        playerLevel:setText("Level " .. (updatedPlayerInfo.rank or "0"))
        local rankImage = UIExpression.TableLookup(self.controller, CoD.rankIconTable, 0, updatedPlayerInfo.rank - 1, (updatedPlayerInfo.prestige or 11) + 1)
        if rankImage and rankImage ~= "" then
            prestigeIcon:setImage(RegisterMaterial(rankImage))
        else
            prestigeIcon:setImage(RegisterMaterial("rank_prestige11")) 
        end
        if updatedPlayerInfo.emblemBackground then
            callingCard:setImage(RegisterMaterial(updatedPlayerInfo.emblemBackground))
        end
    end)

    local prestigeZeroButton = self.buttonList:addButton(Engine.Localize("Prestige 0"), nil, 0)
    prestigeZeroButton:registerEventHandler("button_action", function(self, event)
        Engine.Exec(self.controller, "statsetbyname plevel 0")
        local updatedPlayerInfo = CoD.Levels.generatePlayerInfo(self.controller)
        prestigeNum:setText(Engine.Localize("MPUI_PRESTIGE_N", 0))
        playerLevel:setText("Level " .. (updatedPlayerInfo.rank or "0"))
        local rankImage = UIExpression.TableLookup(self.controller, CoD.rankIconTable, 0, updatedPlayerInfo.rank - 1, 1)
        if rankImage and rankImage ~= "" then
            prestigeIcon:setImage(RegisterMaterial(rankImage))
            print("Prestige Icon Image after Prestige 0: " .. rankImage) 
        else
            prestigeIcon:setImage(RegisterMaterial("rank_prestige01")) 
        end
        if updatedPlayerInfo.emblemBackground then
            callingCard:setImage(RegisterMaterial(updatedPlayerInfo.emblemBackground))
        end
    end)

    for i = 1, 15 do
        local prestigeButton = self.buttonList:addButton(Engine.Localize("Prestige " .. i), nil, i)
        prestigeButton:registerEventHandler("button_action", function(self, event)
            Engine.Exec(self.controller, "statsetbyname plevel " .. i)
            local updatedPlayerInfo = CoD.Levels.generatePlayerInfo(self.controller)
            prestigeNum:setText(Engine.Localize("MPUI_PRESTIGE_N", i))
            playerLevel:setText("Level " .. (updatedPlayerInfo.rank or "0"))
            local rankImage = UIExpression.TableLookup(self.controller, CoD.rankIconTable, 0, updatedPlayerInfo.rank - 1, i + 1)
            if rankImage and rankImage ~= "" then
                prestigeIcon:setImage(RegisterMaterial(rankImage))
            else
                prestigeIcon:setImage(RegisterMaterial("rank_prestige" .. string.format("%02d", i)))
            end
        end)
    end

    --idk how to make it stop scrolling down the list :( still very new to lua

    return self
end