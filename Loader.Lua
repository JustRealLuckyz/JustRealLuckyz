
-- FALSIFIQUE UM OVO
-- made by JustRealLuckyz

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "JustRealLuckyzHub"
gui.ResetOnSpawn = false

local ok = pcall(function()
    gui.Parent = game:GetService("CoreGui")
end)

if not ok or not gui.Parent then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(250, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(100, 45, 180)
title.Text = "FALSIFIQUE UM OVO"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = frame

local function createButton(name, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.88, 0, 0, 35)
    button.Position = UDim2.new(0.06, 0, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 13
    button.Font = Enum.Font.Gotham
    button.Text = name .. " [OFF]"
    button.Parent = frame

    Instance.new("UICorner", button)

    local active = false

    button.MouseButton1Click:Connect(function()
        active = not active
        button.Text = name ..
            (active and " [ON]" or " [OFF]")

        if callback then
            callback(active)
        end
    end)
end

local function updateESP(enabled)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local old = player.Character:FindFirstChild("JRL_ESP")

            if old then old:Destroy() end

            if enabled then
                local highlight = Instance.new("Highlight")
                highlight.Name = "JRL_ESP"
                highlight.FillColor =
                    Color3.fromRGB(170, 70, 255)
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.DepthMode =
                    Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = player.Character
            end
        end
    end
end

createButton("ESP Player", 55, updateESP)

createButton("Show Lines", 100, function(enabled)
    print("Show Lines:", enabled)
end)

createButton("Auto Steal", 145, function(enabled)
    print("Interação manual:", enabled)
end)

createButton("Auto Collect", 190, function(enabled)
    print("Auto Collect:", enabled)
end)

createButton("Show Players", 235, function(enabled)
    if enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            print(player.DisplayName)
        end
    end
end)

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 18)
credit.Position = UDim2.new(0, 0, 1, -18)
credit.BackgroundTransparency = 1
credit.Text = "made by JustRealLuckyz"
credit.TextColor3 = Color3.fromRGB(170, 150, 190)
credit.TextSize = 10
credit.Font = Enum.Font.Gotham
credit.Parent = frame

print("JustRealLuckyz Hub carregado!")
