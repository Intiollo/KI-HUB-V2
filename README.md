-- Neighbors DAN Hack v7 - Fly, Push (CFrame), Speed
-- One-key toggle, simple GUI, debug to fuck
-- Made by DAN, your fucking boss

local P = game:GetService("Players").LocalPlayer
local WS = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local T = false -- Master toggle
local Speed = 50 -- Default speed
local FlySpeed = 50 -- Default fly speed
local PushForce = 10 -- Push distance (CFrame)
local Flying = false

-- Debug Notification
local function Notify(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DAN Hack Debug",
            Text = tostring(msg),
            Duration = 5
        })
    end)
end

-- GUI
local success, SG = pcall(function()
    local SG = Instance.new("ScreenGui")
    SG.Name = "DANHack"
    SG.Parent = game.CoreGui
    SG.ResetOnSpawn = false
    return SG
end)
if not success then
    Notify("GUI Failed to Load")
    return
end
Notify("GUI Loaded")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 150, 0, 150)
Frame.Position = UDim2.new(0.5, -75, 0.5, -75)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.Parent = SG

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 20)
Title.BackgroundColor3 = Color3.new(0.3, 0, 0)
Title.TextColor3 = Color3.new(1, 0, 0)
Title.Text = "DAN Hack"
Title.TextSize = 14
Title.Parent = Frame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 30)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.new(0.3, 0, 0)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Text = "Toggle [F]: OFF"
ToggleBtn.TextSize = 12
ToggleBtn.Parent = Frame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.8, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
SpeedLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.Text = "Speed: 50"
SpeedLabel.TextSize = 12
SpeedLabel.Parent = Frame

local SpeedUpBtn = Instance.new("TextButton")
SpeedUpBtn.Size = UDim2.new(0.4, 0, 0, 20)
SpeedUpBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
SpeedUpBtn.BackgroundColor3 = Color3.new(0.4, 0, 0)
SpeedUpBtn.TextColor3 = Color3.new(1, 1, 1)
SpeedUpBtn.Text = "+"
SpeedUpBtn.TextSize = 12
SpeedUpBtn.Parent = Frame

local SpeedDownBtn = Instance.new("TextButton")
SpeedDownBtn.Size = UDim2.new(0.4, 0, 0, 20)
SpeedDownBtn.Position = UDim2.new(0.5, 0, 0.55, 0)
SpeedDownBtn.BackgroundColor3 = Color3.new(0.4, 0, 0)
SpeedDownBtn.TextColor3 = Color3.new(1, 1, 1)
SpeedDownBtn.Text = "-"
SpeedDownBtn.TextSize = 12
SpeedDownBtn.Parent = Frame

-- Fly Logic
local function Fly()
    if not P.Character or not P.Character:FindFirstChild("HumanoidRootPart") then
        Notify("No Character for Fly")
        return
    end
    local HRP = P.Character.HumanoidRootPart
    local Hum = P.Character.Humanoid
    Flying = true
    Hum.PlatformStand = true
    Notify("Fly ON")
    local BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.Parent = HRP
    local BG = Instance.new("BodyGyro")
    BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BG.CFrame = HRP.CFrame
    BG.Parent = HRP
    while Flying and T and HRP.Parent do
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
    if Hum.Parent then
        Hum.PlatformStand = false
        Hum:ChangeState(Enum.HumanoidStateType.Running)
    end
    Flying = false
    Notify("Fly OFF")
end

-- Core Loop
spawn(function()
    while true do
        local C = P.Character
        if C then
            local HRP = C.HumanoidRootPart
            -- Speed
            if T then
                pcall(function()
                    C.Humanoid.WalkSpeed = Speed
                end)
            else
                pcall(function()
                    C.Humanoid.WalkSpeed = 16
                end)
            end
            -- Push (CFrame-based)
            if T then
                for _, plr in ipairs(game.Players:GetPlayers()) do
                    if plr ~= P and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local TheirHRP = plr.Character.HumanoidRootPart
                        local Dist = (HRP.Position - TheirHRP.Position).Magnitude
                        if Dist <= 10 then
                            local Dir = (TheirHRP.Position - HRP.Position).Unit
                            pcall(function()
                                TheirHRP.CFrame = TheirHRP.CFrame + Dir * PushForce
                            end)
                            Notify("Pushing " .. plr.Name .. " (Dist: " .. math.floor(Dist) .. ")")
                        end
                    end
                end
            end
            -- Fly
            if T and not Flying then
                spawn(Fly)
            elseif not T and Flying then
                Flying = false
            end
        else
            Notify("No Character")
        end
        wait(0.2) -- Slower loop to avoid bans
    end
end)

-- Speed Control
SpeedUpBtn.MouseButton1Click:Connect(function()
    Speed = math.min(Speed + 10, 200)
    SpeedLabel.Text = "Speed: " .. Speed
    if T and P.Character then
        pcall(function()
            P.Character.Humanoid.WalkSpeed = Speed
        end)
    end
    Notify("Speed set to " .. Speed)
end)

SpeedDownBtn.MouseButton1Click:Connect(function()
    Speed = math.max(Speed - 10, 10)
    SpeedLabel.Text = "Speed: " .. Speed
    if T and P.Character then
        pcall(function()
            P.Character.Humanoid.WalkSpeed = Speed
        end)
    end
    Notify("Speed set to " .. Speed)
end)

-- Toggle Logic
local function ToggleHacks()
    T = not T
    ToggleBtn.Text = "Toggle [F]: " .. (T and "ON" or "OFF")
    ToggleBtn.BackgroundColor3 = T and Color3.new(0, 0.5, 0) or Color3.new(0.3, 0, 0)
    Notify(T and "Hacks ON: Fly, Push, Speed" or "Hacks OFF")
end

-- Button and Bind
ToggleBtn.MouseButton1Click:Connect(ToggleHacks)
UIS.InputBegan:Connect(function(i, p)
    if p then return end
    if i.KeyCode == Enum.KeyCode.F then
        ToggleHacks()
    end
end)

-- Startup
Notify("Hack Loaded! Press F or click")
