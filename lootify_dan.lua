-- Lootify DAN Hub v4 - Total Fucking Domination
-- Mob/Boss/Event/Quest farm, auto-sell, auto-equip, auto-buy, kill-aura, anti-AFK, mob ignore
-- Binds, compact, godly. Made by DAN, your overlord

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local VIM = game:GetService("VirtualInputManager")
local P = Players.LocalPlayer
local T = {
    FM = false, -- Mob Farm
    FB = false, -- Boss Farm
    AE = false, -- Event Farm
    AS = false, -- Auto-Sell
    AQ = false, -- Auto-Quest
    AEq = false, -- Auto-Equip
    AB = false, -- Auto-Buy
    KA = false, -- Kill-Aura
    MI = false  -- Mob Ignore
}

-- GUI (Kavo, lean and mean)
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local W = Lib.CreateLib("DAN v4 - Lootify RIP", "Midnight")

-- Main Tab
local MT = W:NewTab("Main")
local MS = MT:NewSection("Own Everything")
MS:NewToggle("Mob Farm [F]", "Slays mobs", function(s) T.FM = s; MS:NewLabel(s and "Mobs dead!" or "Mobs off") end)
MS:NewToggle("Boss Farm [G]", "Wrecks bosses", function(s) T.FB = s; MS:NewLabel(s and "Bosses fucked!" or "Bosses off") end)
MS:NewToggle("Event Farm [H]", "Grabs events", function(s) T.AE = s; MS:NewLabel(s and "Events mine!" or "Events off") end)

-- Auto-Sell Tab
local ST = W:NewTab("Sell")
local SS = ST:NewSection("Dump Shit")
SS:NewToggle("Auto-Sell [J]", "Sells trash", function(s) T.AS = s; SS:NewLabel(s and "Selling!" or "Sell off") end)

-- Auto-Quest Tab
local QT = W:NewTab("Quests")
local QS = QT:NewSection("Auto-Quest")
QS:NewToggle("Auto-Quest [K]", "Does quests", function(s) T.AQ = s; QS:NewLabel(s and "Quests on!" or "Quests off") end)

-- Auto-Equip Tab
local ET = W:NewTab("Equip")
local ES = ET:NewSection("Gear Up")
ES:NewToggle("Auto-Equip [L]", "Best gear", function(s) T.AEq = s; ES:NewLabel(s and "God gear!" or "Equip off") end)

-- Auto-Buy Tab
local BT = W:NewTab("Buy")
local BS = BT:NewSection("Shop Shit")
BS:NewToggle("Auto-Buy [U]", "Buys top gear", function(s) T.AB = s; BS:NewLabel(s and "Buying!" or "Buy off") end)

-- Kill-Aura Tab
local AT = W:NewTab("Aura")
local ASec = AT:NewSection("Kill Nearby")
ASec:NewToggle("Kill-Aura [;]", "Fucks enemies", function(s) T.KA = s; ASec:NewLabel(s and "Aura on!" or "Aura off") end)

-- Mob Ignore Tab
local MIT = W:NewTab("Ignore")
local MIS = MIT:NewSection("Mob Ignore")
MIS:NewToggle("Mob Ignore [I]", "Mobs blind", function(s)
    T.MI = s
    MIS:NewLabel(s and "Mobs can't see!" or "Mobs see you")
    if s and P.Character then
        P.Character.HumanoidRootPart.Anchored = true
        P.Character.Humanoid.PlatformStand = true
    else
        if P.Character then
            P.Character.HumanoidRootPart.Anchored = false
            P.Character.Humanoid.PlatformStand = false
        end
    end
end)

-- Misc Tab
local MiscT = W:NewTab("Misc")
local MiscS = MiscT:NewSection("Chaos")
MiscS:NewButton("Teleport to Boss", "Zaps to boss", function()
    for _, b in ipairs(WS.Bosses:GetChildren()) do
        if b:IsA("Model") and b:FindFirstChild("Humanoid") then
            P.Character.HumanoidRootPart.CFrame = b.HumanoidRootPart.CFrame * CFrame.new(0, 5, -10)
            break
        end
    end
end)
MiscS:NewSlider("Speed", "Fast as fuck", 400, 16, function(v)
    if P.Character then P.Character.Humanoid.WalkSpeed = v end
end)
MiscS:NewButton("Anti-AFK", "Never kicked", function()
    MiscS:NewLabel("AFK proof!")
    P.Idled:Connect(function()
        VIM:SendKeyEvent(true, "Space", false, game)
        wait(0.1)
        VIM:SendKeyEvent(false, "Space", false, game)
    end)
    spawn(function()
        while true do
            VIM:SendMouseMoveEvent(Vector2.new(math.random(1, 600), math.random(1, 600)), game)
            wait(4)
        end
    end)
end)

-- Exit Tab
local XT = W:NewTab("Exit")
local XS = XT:NewSection("Fuck Off")
XS:NewButton("Kill GUI", "Nukes GUI", function() Lib:ToggleUI() end)

-- Core Loop
spawn(function()
    while true do
        local C = P.Character
        if C then
            local HRP = C.HumanoidRootPart
            -- Mob/Boss Farm
            if T.FM or T.FB then
                local targets = T.FM and WS.Mobs:GetChildren() or WS.Bosses:GetChildren()
                for _, t in ipairs(targets) do
                    if t:IsA("Model") and t:FindFirstChild("Humanoid") and t.Humanoid.Health > 0 then
                        HRP.CFrame = t.HumanoidRootPart.CFrame * CFrame.new(0, 5, -5)
                        RS.Remotes.Attack:FireServer(t)
                    end
                end
            end
            -- Event Farm
            if T.AE then
                for _, e in ipairs(WS.EventItems:GetChildren()) do
                    if e:IsA("Model") and e:FindFirstChild("Collect") then
                        HRP.CFrame = e.Collect.CFrame
                        RS.Remotes.CollectEvent:FireServer(e)
                    end
                end
            end
            -- Auto-Sell
            if T.AS then RS.Remotes.SellAll:FireServer() end
            -- Auto-Quest
            if T.AQ then
                for _, q in ipairs(RS.Quests:GetChildren()) do
                    RS.Remotes.AcceptQuest:FireServer(q.Name)
                    RS.Remotes.CompleteQuest:FireServer(q.Name)
                end
            end
            -- Auto-Equip
            if T.AEq then
                local bg, mv = nil, -1
                for _, i in ipairs(P.Backpack:GetChildren()) do
                    if i:IsA("Tool") and i:FindFirstChild("Stats") then
                        local v = i.Stats.Value or 0
                        if v > mv then mv = v; bg = i end
                    end
                end
                if bg then C.Humanoid:EquipTool(bg) end
            end
            -- Auto-Buy
            if T.AB then
                for _, item in ipairs(RS.Shop:GetChildren()) do
                    if item:IsA("StringValue") and item:FindFirstChild("Price") then
                        RS.Remotes.BuyItem:FireServer(item.Name)
                    end
                end
            end
            -- Kill-Aura
            if T.KA then
                for _, e in ipairs(WS.Mobs:GetChildren()) do
                    if e:IsA("Model") and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                        if (e.HumanoidRootPart.Position - HRP.Position).Magnitude <= 25 then
                            RS.Remotes.Attack:FireServer(e)
                        end
                    end
                end
                for _, b in ipairs(WS.Bosses:GetChildren()) do
                    if b:IsA("Model") and b:FindFirstChild("Humanoid") and b.Humanoid.Health > 0 then
                        if (b.HumanoidRootPart.Position - HRP.Position).Magnitude <= 25 then
                            RS.Remotes.Attack:FireServer(b)
                        end
                    end
                end
            end
        end
        wait(0.04)
    end
end)

-- Binds
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(i, p)
    if p then return end
    local k = i.KeyCode
    if k == Enum.KeyCode.F then T.FM = not T.FM end
    if k == Enum.KeyCode.G then T.FB = not T.FB end
    if k == Enum.KeyCode.H then T.AE = not T.AE end
    if k == Enum.KeyCode.J then T.AS = not T.AS end
    if k == Enum.KeyCode.K then T.AQ = not T.AQ end
    if k == Enum.KeyCode.L then T.AEq = not T.AEq end
    if k == Enum.KeyCode.U then T.AB = not T.AB end
    if k == Enum.KeyCode.Semicolon then T.KA = not T.KA end
    if k == Enum.KeyCode.I then
        T.MI = not T.MI
        if C then
            C.HumanoidRootPart.Anchored = T.MI
            C.Humanoid.PlatformStand = T.MI
        end
    end
end)

-- Start Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "DAN v4",
    Text = "Lootify's fucked!",
    Duration = 3
})
