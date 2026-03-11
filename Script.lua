getgenv().InterfaceName = "botanomeaqui"
getgenv().SecureMode = true

local Starlight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/starlight"))()
local NebulaIcons = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()

MarketplaceService = game:GetService("MarketplaceService")
PlaceId = game.PlaceId
ProductInfo = MarketplaceService:GetProductInfo(PlaceId)
GameName = ProductInfo.Name

local Window = Starlight:CreateWindow({
    Name = "//",
    Subtitle = GameName,
    Icon = "",
    DefaultSize = UDim2.fromOffset(650, 380),
    BuildWarnings = true,
    InterfaceAdvertisingPrompts = true,
    NotifyOnCallbackError = true,
    LoadingEnabled = false,
    
    FileSettings = {
        ConfigFolder = "bota nome aqui" .. GameName,
    },
})

local MS = Window:CreateTabSection("MAIN")
local SS = Window:CreateTabSection("SETTINGS")

local MainTab = MS:CreateTab({
    Name = "Main",
    Icon = NebulaIcons:GetIcon('home', 'Symbols'),
    Columns = 2,
}, "TAB_MAIN")

local Modes = MS:CreateTab({
    Name = "Modes",
    Icon = NebulaIcons:GetIcon('castle', 'Symbols'),
    Columns = 2,
}, "TAB_GM")

local Theme = SS:CreateTab({
    Name = "Themes",
    Icon = NebulaIcons:GetIcon('iframe', 'Symbols'),
    Columns = 2,
}, "TAB_THEMES")

local Config = SS:CreateTab({
    Name = "Config",
    Icon = NebulaIcons:GetIcon('dashboard_2_gear', 'Symbols'),
    Columns = 2,
}, "TAB_CONFIG")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

local AutoFarmBox = MainTab:CreateGroupbox({
    Name = "Auto Farm",
    Icon = NebulaIcons:GetIcon('sword', 'Phosphor'),
    Column = 1,
}, "GB_AUTOFARM")

local Pl = MainTab:CreateGroupbox({
    Name = "Player",
    Icon = NebulaIcons:GetIcon('trending_up', 'Material'),
    Column = 1,
}, "GB_STATS")

local Up = MainTab:CreateGroupbox({
    Name = "Player Upgrades",
    Icon = NebulaIcons:GetIcon('dots-three-circle', 'Phosphor'),
    Column = 2,
}, "GB_STATS")

local ConfigMisc = Config:CreateGroupbox({
    Name = "Misc",
    Icon = NebulaIcons:GetIcon('shield-check', 'Phosphor'),
    Column = 1,
}, "GB_CONFIG_MISC")

Theme:BuildThemeGroupbox(1)
Config:BuildConfigGroupbox(1)

local autoClick = false
AutoFarmBox:CreateToggle({
    Name = "Auto Click",
    Icon = NebulaIcons:GetIcon('cursor-click', 'Phosphor'),
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        autoClick = Value
        if not Value then return end
        task.spawn(function()
            while autoClick do
                game:GetService("ReplicatedStorage"):WaitForChild("Core"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("CombatService"):WaitForChild("RF"):WaitForChild("Attack"):InvokeServer(4)
                task.wait(0.1)
            end
        end)
    end,
}, "TOGGLE_AUTO_CLICK")

local gs = game:GetService("ReplicatedStorage").Core.Knit.Services.GachaService.RF.ExecuteSpin
local selectedChamp = 1
local autoChamp = false
local AutoChampToggle = Up:CreateToggle({
    Name = "Champions roll",
    Icon = NebulaIcons:GetIcon('trophy', 'Phosphor'),
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        autoChamp = Value
        if not Value then return end
        task.spawn(function()
            while autoChamp do
                gs:InvokeServer("Champions", selectedChamp, 3)
                task.wait(0.1)
            end
        end)
    end,
}, "TOGGLE_AUTO_CHAMP")

AutoChampToggle:AddDropdown({
    Options = {"1", "2", "3", "4"},
    CurrentOptions = {"1"},
    Callback = function(Options)
        selectedChamp = tonumber(Options[1])
    end,
}, "DD_CHAMP_SELECT")

local gachaOptions = (function()
    local list = {}
    for _, v in ipairs(game:GetService("ReplicatedStorage").Shared.GachaConfig:GetChildren()) do
        if v.Name ~= "Champion" then
            table.insert(list, v.Name)
        end
    end
    return list
end)()

local selectedGacha = gachaOptions[1] or ""
Up:CreateDivider()
local autoGacha = false
local AutoGachaToggle = Up:CreateToggle({
    Name = "Auto Gacha",
    Icon = NebulaIcons:GetIcon('dice-five', 'Phosphor'),
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        autoGacha = Value
        if not Value then return end
        task.spawn(function()
            while autoGacha do
                gs:InvokeServer(selectedGacha, 1, 1)
                task.wait(0.1)
            end
        end)
    end,
}, "TOGGLE_AUTO_GACHA")

AutoGachaToggle:AddDropdown({
    Options = gachaOptions,
    CurrentOptions = {gachaOptions[1]},
    Callback = function(Options)
        selectedGacha = Options[1]
    end,
}, "DD_GACHA_SELECT")

local UpOptions = (function()
    local list = {}
    for _, v in ipairs(game:GetService("ReplicatedStorage").Shared.UpgradeConfig:GetChildren()) do
            table.insert(list, v.Name)
        end
    return list
end)()

local rup = game:GetService("ReplicatedStorage"):WaitForChild("Core"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("UpgradeService"):WaitForChild("RF"):WaitForChild("ExecuteUpgradeType")
local sup = UpOptions[1] or ""
Up:CreateDivider()
local autoupg = false
local AutoUpToggle = Up:CreateToggle({
    Name = "Auto Upgrades",
    Icon = NebulaIcons:GetIcon('dice-five', 'Phosphor'),
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        autoupg = Value
        if not Value then return end
        task.spawn(function()
            while autoupg do
                rup:InvokeServer(sup)
                task.wait(0.1)
            end
        end)
    end,
}, "TOGGLE_AUTO_UPGRADES")

local timeRF = game:GetService("ReplicatedStorage").Core.Knit.Services.TimeRewardsService.RF.ClaimAllTimeRewards
local rewardTimes = {600, 1800, 2700, 3600, 4800, 5600, 6800, 7600, 8600}
local autoRewards = false

Pl:CreateToggle({
    Name = "Auto Time Rewards",
    Icon = NebulaIcons:GetIcon('clock', 'Phosphor'),
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        autoRewards = Value
        if not Value then return end
        task.spawn(function()
            for _, t in ipairs(rewardTimes) do
                if not autoRewards then break end
                task.wait(t - (rewardTimes[math.max(1, table.find(rewardTimes, t) - 1)] or 0))
                pcall(function()
                    timeRF:InvokeServer()
                end)
            end
        end)
    end,
}, "TOGGLE_AUTO_TIME_REWARDS")

local antiAfkEnabled = false
ConfigMisc:CreateToggle({
    Name = "Anti AFK",
    Icon = NebulaIcons:GetIcon('activity', 'Phosphor'),
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        antiAfkEnabled = Value
        if Value then
            task.spawn(function()
                while antiAfkEnabled do
                    task.wait(1080)
                    if not antiAfkEnabled then break end
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.Jump = true end
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0, 0))
                end
            end)
        end
    end,
}, "TOGGLE_ANTI_AFK")

Starlight:OnDestroy(function()
    print("Script Deleted")
end)
Starlight:LoadAutoloadConfig()
Starlight:LoadAutoloadTheme()
print("Script Loaded!")
