require( "T6.Lobby" )
require( "T6.Menus.PopupMenus" )
require( "T6.ListBox" )

local ChangelogsInfo = {}
local CurrentChangelogsInfo = {}

CoD.ChangelogsInfo = {}

CoD.ChangelogsInfo.new = function()
    local self = LUI.UIVerticalList.new()
    self.id = "ChangelogsInfo"

    self:setLeftRight(true, true, 0, 0)
    self:setTopBottom(true, true, 0, 0)

    local title = LUI.UIText.new()
    title:setLeftRight(true, false, 0, 0)
    title:setTopBottom(true, false, 0, 42)
    title:setRGB(CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b)
    title:setFont(CoD.fonts.Big)
    self:addElement(title)
    self.title = title

    local author = LUI.UIText.new()
    author:setLeftRight(true, false, 0, 0)
    author:setTopBottom(true, false, 0, 26)
    author:setFont(CoD.fonts.Big)
    self:addElement(author)
    self.author = author

    local description = LUI.UIText.new()
    description:setLeftRight(true, false, 0, 0)
    description:setTopBottom(true, false, 0, 26)
    description:setFont(CoD.fonts.Big)
    self:addElement(description)
    self.description = description

    local version = LUI.UIText.new()
    version:setLeftRight(true, false, 0, 0)
    version:setTopBottom(true, false, 0, 26)
    version:setFont(CoD.fonts.Big)
    self:addElement(version)
    self.version = version

    return self
end

local function modListBackEventHandler(self, parent)
    CoD.Menu.ButtonPromptBack(self, parent)
end

function LUI.createMenu.Changelogs(controller)
    local self = CoD.Menu.New("Changelogs")
    self.controller = controller

    self:setPreviousMenu("MainMenu")
    self:addSelectButton()
    self:addBackButton()
    self:addTitle("Changelogs")

    local textList = LUI.UIVerticalList.new()
    textList:setLeftRight(true, false, 0, 500)
    textList:setTopBottom(true, false, 75, 605)

    local textItem1 = LUI.UIText.new()
    textItem1:setLeftRight(true, false, 0, 0)
    textItem1:setTopBottom(true, false, 0, 26)
    textItem1:setFont(CoD.fonts.Default)
    textItem1:setText("Welcome to the ^5Project Nebula^7 changelogs!")
    textList:addElement(textItem1)

    local textItem2 = LUI.UIText.new()
    textItem2:setLeftRight(true, false, 0, 0)
    textItem2:setTopBottom(true, false, 26, 52)
    textItem2:setFont(CoD.fonts.Default)
    textItem2:setText("- Twitter/X: ^5@d8sires")
    textList:addElement(textItem2)

    local textItem2 = LUI.UIText.new()
    textItem2:setLeftRight(true, false, 0, 0)
    textItem2:setTopBottom(true, false, 26, 52)
    textItem2:setFont(CoD.fonts.Default)
    textItem2:setText("- Discord: ^5https://discord.gg/SyM6yu2VhH")
    textList:addElement(textItem2)

    local textItem2 = LUI.UIText.new()
    textItem2:setLeftRight(true, false, 0, 0)
    textItem2:setTopBottom(true, false, 26, 52)
    textItem2:setFont(CoD.fonts.Default)
    textItem2:setText("- Want to play ^5Project Nebula^7 on other clients? Join the Discord! ^1<3^7")
    textList:addElement(textItem2)


    local textItem7 = LUI.UIText.new()
    textItem7:setLeftRight(true, false, 0, 0)
    textItem7:setTopBottom(true, false, 52, 78)
    textItem7:setFont(CoD.fonts.Default)
    textItem7:setText(" ")
    textList:addElement(textItem7)

    local textItem3 = LUI.UIText.new()
    textItem3:setLeftRight(true, false, 0, 0)
    textItem3:setTopBottom(true, false, 52, 78)
    textItem3:setFont(CoD.fonts.Default)
    textItem3:setText("^5[v2.0.3] - 6/26/25")
    textList:addElement(textItem3)

    local textItem3 = LUI.UIText.new()
    textItem3:setLeftRight(true, false, 0, 0)
    textItem3:setTopBottom(true, false, 52, 78)
    textItem3:setFont(CoD.fonts.Default)
    textItem3:setText("FFA:")
    textList:addElement(textItem3)

    local textItem3 = LUI.UIText.new()
    textItem3:setLeftRight(true, false, 0, 0)
    textItem3:setTopBottom(true, false, 52, 78)
    textItem3:setFont(CoD.fonts.Default)
    textItem3:setText("- Added 'Give Streaks on Spawn' button in Self Menu.")
    textList:addElement(textItem3)

    local textItem3 = LUI.UIText.new()
    textItem3:setLeftRight(true, false, 0, 0)
    textItem3:setTopBottom(true, false, 52, 78)
    textItem3:setFont(CoD.fonts.Default)
    textItem3:setText("- Added match bonus.")
    textList:addElement(textItem3)

    local textItem3 = LUI.UIText.new()
    textItem3:setLeftRight(true, false, 0, 0)
    textItem3:setTopBottom(true, false, 52, 78)
    textItem3:setFont(CoD.fonts.Default)
    textItem3:setText("- Fixed a few menu functions.")
    textList:addElement(textItem3)

    local textItem3 = LUI.UIText.new()
    textItem3:setLeftRight(true, false, 0, 0)
    textItem3:setTopBottom(true, false, 52, 78)
    textItem3:setFont(CoD.fonts.Default)
    textItem3:setText("SND:")
    textList:addElement(textItem3)

    local textItem3 = LUI.UIText.new()
    textItem3:setLeftRight(true, false, 0, 0)
    textItem3:setTopBottom(true, false, 52, 78)
    textItem3:setFont(CoD.fonts.Default)
    textItem3:setText("- Added persistent 'Hardcore Hud' toggle in Self Menu.")
    textList:addElement(textItem3)

    local textItem3 = LUI.UIText.new()
    textItem3:setLeftRight(true, false, 0, 0)
    textItem3:setTopBottom(true, false, 52, 78)
    textItem3:setFont(CoD.fonts.Default)
    textItem3:setText("- Added match bonus.")
    textList:addElement(textItem3)

    local textItem3 = LUI.UIText.new()
    textItem3:setLeftRight(true, false, 0, 0)
    textItem3:setTopBottom(true, false, 52, 78)
    textItem3:setFont(CoD.fonts.Default)
    textItem3:setText("- Added 'Pickup Radius' array option in Self Menu.")
    textList:addElement(textItem3)

    local textItem3 = LUI.UIText.new()
    textItem3:setLeftRight(true, false, 0, 0)
    textItem3:setTopBottom(true, false, 52, 78)
    textItem3:setFont(CoD.fonts.Default)
    textItem3:setText("- Added 'Pause Timer' option in Game Settings menu.")
    textList:addElement(textItem3)
    
    local textItem3 = LUI.UIText.new()
    textItem3:setLeftRight(true, false, 0, 0)
    textItem3:setTopBottom(true, false, 52, 78)
    textItem3:setFont(CoD.fonts.Default)
    textItem3:setText(" ")
    textList:addElement(textItem3)

	local textItem12 = LUI.UIText.new()
    textItem12:setLeftRight(true, false, 0, 0)
    textItem12:setTopBottom(true, false, 52, 78)
    textItem12:setFont(CoD.fonts.Default)
    textItem12:setText("^5Wallbang Everything Tutorial:^7 (LAN Mode Private Match)")
    textList:addElement(textItem12)

    local textItem12 = LUI.UIText.new()
    textItem12:setLeftRight(true, false, 0, 0)
    textItem12:setTopBottom(true, false, 52, 78)
    textItem12:setFont(CoD.fonts.Default)
    textItem12:setText("- Join the Discord!")
    textList:addElement(textItem12)

    local textItem12 = LUI.UIText.new()
    textItem12:setLeftRight(true, false, 0, 0)
    textItem12:setTopBottom(true, false, 52, 78)
    textItem12:setFont(CoD.fonts.Default)
    textItem12:setText(" ")
    textList:addElement(textItem12)

    local textItem12 = LUI.UIText.new()
    textItem12:setLeftRight(true, false, 0, 0)
    textItem12:setTopBottom(true, false, 52, 78)
    textItem12:setFont(CoD.fonts.Default)
    textItem12:setText("^1Thank you all for 400 total downloads! - Desires")
    textList:addElement(textItem12)


    self:addElement(textList)
    self.textList = textList

    self.backButton = CoD.ButtonPrompt.new("secondary", Engine.Localize("MENU_BACK"), self, "button_prompt_back")
    self:registerEventHandler("button_prompt_back", modListBackEventHandler)

    return self
end