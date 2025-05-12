local success1, result1 = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))
end)
if success1 then
    result1()
else
    warn("Không thể tải script từ sirius.menu")
end

local success2, RayfieldLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
end)
if not success2 then
    warn("Không thể tải Rayfield Library. Kiểm tra kết nối hoặc URL.")
    return
end
local Rayfield = RayfieldLib

local Window = Rayfield:CreateWindow({
    Name = "Sinon Hub Beta",
    LoadingTitle = "Đang Tải...",
    LoadingSubtitle = "by Kỳ Anh",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "AutoLevelSettings"
    },
    Discord = {
       Enabled = false
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Auto Level", 4483362458)
local SettingsTab = Window:CreateTab("Cài Đặt", 4483362458)

_G.AutoLevel = false
_G.SelectWeapon = "Dark Blade"

MainTab:CreateToggle({
    Name = "Bật/Tắt Auto Cày Cấp",
    CurrentValue = false,
    Flag = "AutoLevelToggle",
    Callback = function(Value)
        _G.AutoLevel = Value
    end,
})

SettingsTab:CreateInput({
    Name = "Nhập tên vũ khí",
    PlaceholderText = "Ví dụ: Dark Blade",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        _G.SelectWeapon = Text
    end,
})

-- Auto Haki
SettingsTab:CreateToggle({
    Name = "Bật Auto Haki",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoHaki = Value
    end,
})

-- Auto Skill
SettingsTab:CreateToggle({
    Name = "Auto Skill Z",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoZ = Value
    end,
})

SettingsTab:CreateToggle({
    Name = "Auto Skill X",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoX = Value
    end,
})

SettingsTab:CreateToggle({
    Name = "Auto Skill C",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoC = Value
    end,
})

-- Auto Farm Boss (giả lập đơn giản)
MainTab:CreateToggle({
    Name = "Auto Farm Boss (Thử nghiệm)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoBoss = Value
    end,
})

-- Auto chiêu thực thi
spawn(function()
    while wait(1) do
        pcall(function()
            if _G.AutoZ then keypress(0x5A) wait(0.1) keyrelease(0x5A) end -- Z
            if _G.AutoX then keypress(0x58) wait(0.1) keyrelease(0x58) end -- X
            if _G.AutoC then keypress(0x43) wait(0.1) keyrelease(0x43) end -- C
        end)
    end
end)

-- Auto Haki mỗi 5 giây
spawn(function()
    while wait(5) do
        if _G.AutoHaki then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
        end
    end
end)

-- Auto Observation Haki (liên tục dùng shift dodge)
SettingsTab:CreateToggle({
    Name = "Auto Observation Haki (né liên tục)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoObservation = Value
    end,
})

spawn(function()
    while wait(0.5) do
        if _G.AutoObservation then
            pcall(function()
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Q", false, game)
                wait(0.05)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "Q", false, game)
            end)
        end
    end
end)

-- Auto Elite Hunter (chỉ tìm boss Elite, không kill)
MainTab:CreateToggle({
    Name = "Auto Elite Hunter (Boss Elite)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoElite = Value
    end,
})

spawn(function()
    while wait(5) do
        if _G.AutoElite then
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if string.find(v.Name, "Elite") and v:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                end
            end
        end
    end
end)

-- Auto Sea Event (teleport tới thuyền Sea Beast nếu phát hiện)
MainTab:CreateToggle({
    Name = "Auto Sea Event (Thử nghiệm)",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoSea = Value
    end,
})

spawn(function()
    while wait(2) do
        if _G.AutoSea then
            for _, v in pairs(workspace:GetChildren()) do
                if string.find(v.Name, "Sea") and v:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                end
            end
        end
    end
end)

local ShopTab = Window:CreateTab("Shop & World", 4483362458)

ShopTab:CreateInput({
    Name = "Nhập Code và Nhận",
    PlaceholderText = "Ví dụ: EXPBOOST",
    RemoveTextAfterFocusLost = true,
    Callback = function(code)
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RedeemCode", code)
        end)
    end,
})

ShopTab:CreateButton({
    Name = "Teleport Old World",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
    end,
})

ShopTab:CreateButton({
    Name = "Teleport New World",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
    end,
})

ShopTab:CreateButton({
    Name = "Teleport Third Sea",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
    end,
})

-- Tab Status And Server
local StatusTab = Window:CreateTab("Status / Server", 4483362458)
StatusTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
})
StatusTab:CreateButton({
    Name = "Hop Server",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/3aLZzrYb"))()
    end,
})

-- Tab Local Player
local LocalTab = Window:CreateTab("Local Player", 4483362458)
LocalTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})
LocalTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 200},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,
})

-- Tab Sea Event
local SeaTab = Window:CreateTab("Sea Event", 4483362458)
SeaTab:CreateToggle({
    Name = "Auto Kill Sea Beast",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoSeaKill = v
    end,
})

-- Tab Upgrade Race
local RaceTab = Window:CreateTab("Race Upgrade", 4483362458)
RaceTab:CreateButton({
    Name = "Teleport đến NPC Race V4",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2603, 38, -12652)
    end,
})

-- Tab Get & Upgrade Items
local ItemsTab = Window:CreateTab("Items / Upgrade", 4483362458)
ItemsTab:CreateButton({
    Name = "Auto Enchant Item (thử nghiệm)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/DFBDa5hG"))()
    end,
})

-- Tab Fruit and Raid
local FruitTab = Window:CreateTab("Fruit / Raid", 4483362458)
FruitTab:CreateButton({
    Name = "Mở Blox Fruit Menu",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
    end,
})

-- Tab Volcano Event
local VolcanoTab = Window:CreateTab("Volcano Event", 4483362458)
VolcanoTab:CreateToggle({
    Name = "Auto Kill Tiki Boss",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoTiki = v
    end,
})

-- Tab Farm Settings
local FarmSettingTab = Window:CreateTab("Farm Settings", 4483362458)

FarmSettingTab:CreateDropdown({
    Name = "Select Method Farm",
    Options = {"Level Farm", "Boss Farm", "Material Farm"},
    CurrentOption = "Level Farm",
    Callback = function(Value)
        _G.FarmMethod = Value
    end,
})

FarmSettingTab:CreateSlider({
    Name = "Distance Aura Farm",
    Range = {10, 500},
    Increment = 10,
    CurrentValue = 300,
    Callback = function(Value)
        _G.AuraDistance = Value
    end,
})

FarmSettingTab:CreateToggle({
    Name = "Ignore Attack Katakuri",
    CurrentValue = false,
    Callback = function(Value)
        _G.IgnoreKatakuri = Value
    end,
})

FarmSettingTab:CreateToggle({
    Name = "Hop Find Katakuri",
    CurrentValue = false,
    Callback = function(Value)
        _G.HopKatakuri = Value
    end,
})

-- Tab Farming Mastery
local MasteryTab = Window:CreateTab("Tab Farming", 4483362458)

MasteryTab:CreateToggle({
    Name = "Farm Material",
    CurrentValue = false,
    Callback = function(Value)
        _G.FarmMaterial = Value
    end,
})

MasteryTab:CreateDropdown({
    Name = "Select Method Farm Mastery",
    Options = {"Blox Fruit", "Sword", "Gun", "Fighting Style"},
    CurrentOption = "Blox Fruit",
    Callback = function(Value)
        _G.MasteryType = Value
    end,
})

MasteryTab:CreateSlider({
    Name = "Health % (Dừng đánh nếu dưới %)",
    Range = {10, 100},
    Increment = 5,
    CurrentValue = 30,
    Callback = function(Value)
        _G.StopIfLowHP = Value
    end,
})

MasteryTab:CreateToggle({
    Name = "Farm Mastery",
    CurrentValue = false,
    Callback = function(Value)
        _G.FarmMastery = Value
    end,
})
