-- Neighbors DAN Hack v1 - Fly, Push, Speed
-- Toggle all with one key, no bullshit
-- Made by DAN, your fucking king

local P = game:GetService("Players").LocalPlayer
local WS = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local T = { Fly = false, Push = false, Speed = false }
local SpeedVal = 50 -- Default speed (changeable in GUI)
local FlySpeed = 50
local PushForce = 50
local Flying = false

-- GUI (Kavo, bloody and badass)
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local W = Lib.CreateLib("DAN Neighbors Hack", "BloodTheme")

-- Main Tab
local MT = W:NewTab("Hack")
local MS = MT:NewSection("Rule This Shit")

MS:NewToggle("Master Toggle [F]", "All hacks on/off", function(s)
    T.Fly = s
    T.Push = s
    T.Speed = s
    MS:NewLabel(s and "Hacks ON!" or "Hacks OFF")
    if not s and Flying then
        Flying = false
        if P.Character then
            P.Character.Humanoid.PlatformStand = false
            P.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
end)

MS:NewSlider("Speed", "Run like fuck", 200, 16, function(v)
    SpeedVal = v
    if T.Speed and P.Character then
        P.Character.Humanoid.WalkSpeed = v
    end
end)

MS:NewSlider("Fly Speed", "Fly like a jet", 200, 10, function(v)
    FlySpeed = v
end)

MS:NewSlider("Push Force", "Yeet players", 100, 10, function(v)
    PushForce = v
end)

-- Fly Logic
local function Fly()
    if not P.Character or not P.Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = P.Character.HumanoidRootPart
    local Hum = P.Character.Humanoid
    Flying = true
    Hum.PlatformStand = true
    local BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.Parent = HRP
    local BG = Instance.new("BodyGyro")
    BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BG.CFrame = HRP.CFrame
    BG.Parent = HRP
    while Flying and T.Fly do
        local Cam = WS.CurrentCamera
        local MoveDir = Vector3.new(0, 0, 0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then MoveDir = MoveDir + Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then MoveDir = MoveDir - Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then MoveDir = MoveDir - Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then MoveDir = MoveDir + Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then MoveDir = MoveDir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then MoveDir = MoveDir - Vector3.new(0, 1, 0) end
        BV.Velocity = MoveDir * FlySpeed
        BG.CFrame = Cam.CFrame
        wait()
    end
    BV:Destroy()
    BG:Destroy()
    Hum.PlatformStand = false
    Hum:ChangeState(Enum.HumanoidStateType.Running)
end

-- Core Loop
spawn(function()
    while true do
        local C = P.Character
        if C then
            local HRP = C.HumanoidRootPart
            -- Speed
            if T.Speed then
                C.Humanoid.WalkSpeed = SpeedVal
            else
                C.Humanoid.WalkSpeed = 16
            end
            -- Push
            if T.Push then
                for _, plr in ipairs(game.Players:GetPlayers()) do
                    if plr ~= P and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local TheirHRP = plr.Character.HumanoidRootPart
                        local Dist = (HRP.Position - TheirHRP.Position).Magnitude
                        if Dist <= 10 then
                            local Dir = (TheirHRP.Position - HRP.Position).Unit
                            TheirHRP.Velocity = Dir * PushForce
                        end
                    end
                end
            end
            -- Fly
            if T.Fly and not Flying then
                spawn(Fly)
            elseif not T.Fly then
                Flying = false
            end
        end
        wait(0.05)
    end
end)

-- Bind (F key)
UIS.InputBegan:Connect(function(i, p)
    if p then return end
    if i.KeyCode == Enum.KeyCode.F then
        T.Fly = not T.Fly
        T.Push = not T.Push
        T.Speed = not T.Speed
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DAN Hack",
            Text = T.Fly and "Hacks ON!" or "Hacks OFF",
            Duration = 2
        })
        if not T.Fly and Flying then
            Flying = false
            if P.Character then
                P.Character.Humanoid.PlatformStand = false
                P.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
end)

-- Startup
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "DAN Neighbors Hack",
    Text = "Press F to toggle all. Fly, Push, Speed!",
    Duration = 4
})
