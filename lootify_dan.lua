-- Lootify Anti-AFK by DAN
-- No GUI, pure chaos, stays in game forever
-- Jumps, moves, random actions, animated status

local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local P = Players.LocalPlayer
local AntiAFK = false

-- Animated Screen Status
local function CreateStatus()
    local SG = Instance.new("ScreenGui")
    SG.Parent = game.CoreGui
    SG.Name = "LootifyAFK"
    
    local T = Instance.new("TextLabel")
    T.Size = UDim2.new(0, 200, 0, 50)
    T.Position = UDim2.new(0.5, -100, 0, 10)
    T.BackgroundTransparency = 1
    T.Text = "Lootify Anti-AFK by DAN"
    T.TextColor3 = Color3.new(1, 0, 0)
    T.TextSize = 20
    T.Font = Enum.Font.Code
    T.Parent = SG

    -- Pulsating animation
    spawn(function()
        while true do
            for i = 0, 1, 0.05 do
                T.TextColor3 = Color3.fromHSV(i, 1, 1)
                T.TextTransparency = 0.1 * math.sin(tick() * 2)
                T.Text = AntiAFK and "Lootify Anti-AFK: RUNNING" or "Lootify Anti-AFK: OFF"
                wait(0.05)
            end
        end
    end)
end

-- Core Anti-AFK Logic
spawn(function()
    while true do
        if AntiAFK then
            -- Jump fix: proper key press/release
            VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            wait(0.2)
            VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            
            -- Random mouse move
            VIM:SendMouseMoveEvent(Vector2.new(math.random(100, 700), math.random(100, 500)), game)
            
            -- Random WASD
            local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
            local key = keys[math.random(1, 4)]
            VIM:SendKeyEvent(true, key, false, game)
            wait(math.random(0.3, 0.6))
            VIM:SendKeyEvent(false, key, false, game)
        end
        wait(math.random(4, 8)) -- Realistic intervals
    end
end)

-- Keybinds: Z = ON, X = OFF
UIS.InputBegan:Connect(function(i, p)
    if p then return end
    if i.KeyCode == Enum.KeyCode.Z then
        AntiAFK = true
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DAN Anti-AFK",
            Text = "Protection ON, motherfucker!",
            Duration = 2
        })
    elseif i.KeyCode == Enum.KeyCode.X then
        AntiAFK = false
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DAN Anti-AFK",
            Text = "Protection OFF, you lazy fuck!",
            Duration = 2
        })
    end
end)

-- Startup
CreateStatus()
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "DAN Anti-AFK",
    Text = "Loaded! Z = ON, X = OFF",
    Duration = 3
})
