-- Lootify Anti-AFK by DAN
-- Fixed jumps (no one-time bullshit), 2s cooldown, jump check, fuck yeah

local Players = game:GetService("Players")
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

-- Jump Check Function
local function CheckJump(char)
    local humanoid = char and char:FindFirstChild("Humanoid")
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if humanoid and rootPart then
        local startY = rootPart.Position.Y
        wait(0.3) -- Time for jump to happen
        local endY = rootPart.Position.Y
        return endY > startY + 0.5 -- Check if Y increased (jumped)
    end
    return false
end

-- Jump Logic (separate loop)
spawn(function()
    while true do
        if AntiAFK then
            local char = P.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                -- Reset state to ensure jump
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                wait(0.1) -- Small delay to clear state
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                
                -- Check if jump worked
                if not CheckJump(char) then
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "DAN Anti-AFK",
                        Text = "Jump fucked up, fix your shit!",
                        Duration = 2
                    })
                end
            else
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "DAN Anti-AFK",
                    Text = "Can't jump, you dead or stuck, fucker!",
                    Duration = 2
                })
            end
        end
        wait(2) -- Jump every 2 seconds
    end
end)

-- Other Anti-AFK Logic (mouse, WASD)
spawn(function()
    while true do
        if AntiAFK then
            local VIM = game:GetService("VirtualInputManager")
            -- Random mouse move
            VIM:SendMouseMoveEvent(Vector2.new(math.random(100, 700), math.random(100, 500)), game)
            
            -- Random WASD
            local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
            local key = keys[math.random(1, 4)]
            VIM:SendKeyEvent(true, key, false, game)
            wait(0.3)
            VIM:SendKeyEvent(false, key, false, game)
        end
        wait(2) -- Sync with jumps
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
