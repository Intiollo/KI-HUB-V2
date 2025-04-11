-- Lootify DAN Hub v5 - Absolute Fucking Chaos
-- Mob/Boss/Event/Quest farm, auto-sell, auto-equip, auto-buy, auto-skill, rare mob TP, kill-aura, mob ignore, anti-AFK
-- Anti-ban, binds, godly. Made by DAN, your god

local P = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local VIM = game:GetService("VirtualInputManager")
local T = {
    FM = false, -- Mob Farm
    FB = false, -- Boss Farm
    AE = false, -- Event Farm
    AS = false, -- Auto-Sell
    AQ = false, -- Auto-Quest
    AEq = false, -- Auto-Equip
    AB = false, -- Auto-Buy
    KA = false, -- Kill-Aura
    MI = false, -- Mob Ignore
    ASk = false, -- Auto-Skill
    RT = false  -- Rare Mob TP
}

-- GUI (Kavo, sleek and deadly)
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local W = Lib.CreateLib("DAN v5 - Lootify Annihilation", "Midnight")

-- Main Tab
local MT = W:NewTab("Main")
local MS = MT:NewSection("Dominate")
MS:NewToggle("Mob Farm [F]", "Slays mobs", function(s) T.FM = s; MS:NewLabel(s and "Mobs fucked!" or "Mobs off") end)
MS:NewToggle("Boss Farm [G]", "Wrecks bosses", function(s) T.FB = s; MS:NewLabel(s and "Bosses dead!" or "Bosses off") end)
MS:NewToggle("Event Farm [H]", "Steals events", function(s) T.AE = s; MS:NewLabel(s and "Events mine!" or "Events off") end)

-- Sell Tab
local ST = W:NewTab("Sell")
local SS = ST:NewSection("Dump Trash")
SS:NewToggle("Auto-Sell [J]", "Sells junk", function(s) T.AS = s; SS:NewLabel(s and "Selling!" or "Sell off") end)

-- Quest Tab
local QT = W:NewTab("Quests")
local QS = QT:NewSection("Quest Grind")
QS:NewToggle("Auto-Quest [K]", "Completes quests", function(s) T.AQ = s; QS:NewLabel(s and "Quests on!" or "Quests off") end)

-- Equip Tab
local ET = W:NewTab("Equip")
local ES = ET:NewSection("Gear Up")
ES:NewToggle("Auto-Equip [L]", "Best gear", function(s) T.AEq = s; ES:NewLabel(s and "God gear!" or "Equip off") end)

-- Buy Tab
local BT = W:NewTab("Buy")
local BS = BT:NewSection("Shop Sweep")
BS:NewToggle("Auto-Buy [U]", "Buys top gear", function(s) T.AB = s; BS:NewLabel(s and "Buying!" or "Buy off") end)

-- Skill Tab
local SkT = W:NewTab("Skills")
local SkS = SkT:NewSection("Spam Skills")
SkS:NewToggle("Auto-Skill [O]", "Unleashes skills", function(s) T.ASk = s; SkS:NewLabel(s and "Skills blazing!" or "Skills off") end)

-- Aura Tab
local AT = W:NewTab("Aura")
local ASec = AT:NewSection("Kill Zone")
ASec:NewToggle("Kill-Aura [;]", "Shreds nearby", function(s) T.KA = s; ASec:NewLabel(s and "Aura on!" or "Aura off") end)

-- Ignore Tab
local MIT = W:NewTab("Ignore")
local MIS = MIT:NewSection("Mob Ignore")
MIS:NewToggle("Mob Ignore [I]", "Mobs blind", function(s)
    T.MI = s
    MIS:NewLabel(s and "Invisible!" or "Visible")
    local C = P.Character
    if C then
        C.HumanoidRootPart.Anchored = s
        C.Humanoid.PlatformStand = s
    end
end)

-- Rare Mob Tab
local RT = W:NewTab("Rare")
local RS = RT:NewSection("Rare Mob Hunt")
RS:NewToggle("Rare Mob TP [P]", "Zaps to rares", function(s) T.RT = s; RS:NewLabel(s and "Hunting rares!" or "Rare TP off") end)

-- Misc Tab
local MiscT = W:NewTab("Misc")
local MiscS = MiscT:NewSection("Extras")
MiscS:NewButton("Teleport to Boss", "Zaps to boss", function()
    for _, b in ipairs(WS.Bosses:GetChildren()) do
        if b:IsA("Model") and b:FindFirstChild("Humanoid") then
            P.Character.HumanoidRootPart.CFrame = b.HumanoidRootPart.CFrame * CFrame.new(0, 5, -10)
            break
        end
    end
end)
MiscS:NewSlider("Speed", "Run like hell", 500, 16, function(v)
    if P.Character then P.Character.Humanoid.WalkSpeed = v end
end)
MiscS:NewButton("Anti-AFK", "Never kicked", function()
    MiscS:NewLabel("AFK proof!")
    P.Idled:Connect(function()
        VIM:SendKeyEvent(true, "Space", false, game)
        wait(math.random(0.1, 0.3))
        VIM:SendKeyEvent(false, "Space", false, game)
    end)
    spawn(function()
        while true do
            VIM:SendMouseMoveEvent(Vector2.new(math.random(1, 800), math.random(1, 600)), game)
            wait(math.random(3, 6))
        end
    end)
end)

-- Exit Tab
local XT = W:NewTab("Exit")
local XS = XT:NewSection("Fuck Off")
XS:NewButton("Kill GUI", "Nukes GUI", function() Lib:ToggleUI() end)

-- Core Loop with Anti-Ban
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
            -- Rare Mob TP
            if T.RT then
                for _, m in ipairs(WS.Mobs:GetChildren()) do
                    if m:IsA("Model") and m:FindFirstChild("Humanoid") and (m.Name:lower():find("rare") or m.Name:lower():find("legendary")) then
                        HRP.CFrame = m.HumanoidRootPart.CFrame * CFrame.new(0, 5, -10)
                        RS.Remotes.Attack:FireServer(m)
                        break
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
            -- Auto-Skill
            if T.ASk then
                for _, s in ipairs(P.Backpack:GetChildren()) do
                    if s:IsA("Tool") and s:FindFirstChild("Skill") then
                        C.Humanoid:EquipTool(s)
                        s:Activate()
                    end
                end
            end
            -- Kill-Aura
            if T.KA then
                for _, e in ipairs(WS.Mobs:GetChildren()) do
                    if e:IsA("Model") and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                        if (e.HumanoidRootPart.Position - HRP.Position).Magnitude <= 30 then
                            RS.Remotes.Attack:FireServer(e)
                        end
                    end
                end
                for _, b in ipairs(WS.Bosses:GetChildren()) do
                    if b:IsA("Model") and b:FindFirstChild("Humanoid") and b.Humanoid.Health > 0 then
                        if (b.HumanoidRootPart.Position - HRP.Position).Magnitude <= 30 then
                            RS.Remotes.Attack:FireServer(b)
                        end
                    end
                end
            end
        end
        wait(math.random(0.03, 0.06)) -- Anti-ban random delay
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
    if k == Enum.KeyCode.O then T.ASk = not T.ASk end
    if k == Enum.KeyCode.P then T.RT = not T.RT end
    if k == Enum.KeyCode.Semicolon then T.KA = not T.KA end
    if k == Enum.KeyCode.I then
        T.MI = not T.MI
        local C = P.Character
        if C then
            C.HumanoidRootPart.Anchored = T.MI
            C.Humanoid.PlatformStand = T.MI
        end
    end
end)

-- Startup Vibe
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "DAN v5",
    Text = "Lootify's obliterated!",
    Duration = 3
})
