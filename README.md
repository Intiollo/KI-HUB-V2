-- Neighbors DAN Hack v6 - Fly, Push, Speed
-- One-key toggle, simple GUI, players yeet like fuck
-- Made by DAN, your fucking god

local P = game:GetService("Players").LocalPlayer
local WS = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local T = false -- Master toggle
local Speed = 50 -- Default speed
local FlySpeed = 50 -- Default fly speed
local PushForce = 50 -- Default push force
local Flying = false

-- Debug Notification
local function Notify(msg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DAN Hack",
        Text = msg,
        Duration = 5
    })
end

-- GUI
local SG = Instance.new("ScreenGui")
SG.Name = "DANHack"
SG.Parent = game.CoreGui
SG.ResetOnSpawn = false
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
