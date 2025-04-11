-- Lootify Anti-AFK by DAN - Stay in Game Forever
-- Simulates jumps, mouse moves, and random actions
-- Lightweight, bindable, GUI. Made for XENO

local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local P = Players.LocalPlayer
local AntiAFK = false

-- GUI (Kavo, small and sexy)
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local W = Lib.CreateLib("DAN Anti-AFK - Lootify", "Midnight")

-- Main Tab
local MT = W:NewTab("AFK")
local MS = MT:NewSection("Stay Alive")
MS:NewToggle("Anti-AFK [Z]", "Never get kicked", function(s)
    AntiAFK = s
    MS:NewLabel(s and "AFK Proof!" or "AFK Off")
end)

-- Core Anti-AFK Logic
spawn(function()
    while true do
        if AntiAFK then
            -- Simulate jump
            VIM:SendKeyEvent(true, "Space", false, game)
            wait(math.random(0.1, 0.3))
            VIM:SendKeyEvent(false, "Space", false, game)
            -- Random mouse move
            VIM:SendMouseMoveEvent(Vector2.new(math.random(1, 800), math.random(1, 600)), game)
            -- Random WASD press
            local keys = {"W", "A", "S", "D"}
            local key = keys[math.random(1, 4)]
            VIM:SendKeyEvent(true, key, false, game)
            wait(math.random(0.2, 0.5))
            VIM:SendKeyEvent(false, key, false, game)
        end
        wait(math.random(5, 10)) -- Random intervals for realism
    end
end)

-- Bind (Z key)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(i, p)
    if p then return end
    if i.KeyCode == Enum.KeyCode.Z then
        AntiAFK = not AntiAFK
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DAN Anti-AFK",
            Text = AntiAFK and "AFK Protection ON" or "AFK Protection OFF",
            Duration = 2
        })
    end
end)

-- Startup Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "DAN Anti-AFK",
    Text = "Loaded! Press Z to toggle.",
    Duration = 3
})
