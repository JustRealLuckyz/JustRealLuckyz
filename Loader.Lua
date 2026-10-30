
-- Luckyz Hub
-- Interface mobile para Roblox Studio

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "LuckyzHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(230, 260)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Luckyz Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(35, 35)
minimize.Position = UDim2.new(1, -40, 0, 3)
minimize.Text = "-"
minimize.TextSize = 22
minimize.Parent = frame

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(0, 45)
content.Size = UDim2.new(1, 0, 1, -70)
content.BackgroundTransparency = 1
content.Parent = frame

local minimized = false

minimize.Activated:Connect(function()
    minimized = not minimized
    content.Visible = not minimized

    frame.Size = minimized
        and UDim2.fromOffset(230, 45)
        or UDim2.fromOffset(230, 260)

    minimize.Text = minimized and "+" or "-"
end)

-- Arrastar com toque ou mouse
local UIS = game:GetService("UserInputService")
local dragging, dragStart, startPosition

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = frame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging then
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart

            frame.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local function makeButton(name, y)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = UDim2.fromOffset(10, y)
    button.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Text = name .. ": OFF"
    button.Parent = content

    Instance.new("UICorner", button)

    return button
end

local espButton = makeButton("ESP Players", 5)
local eggButton = makeButton("ESP Eggs", 47)
local listButton = makeButton("Show Players", 89)

local espEnabled = false
local eggEnabled = false
local listEnabled = false

local highlights = {}
local billboards = {}

local function clearESP()
    for _, item in pairs(highlights) do
        item:Destroy()
    end

    table.clear(highlights)
end

local function updatePlayer(plr)
    if plr == player then return end

    local character = plr.Character
    if not character then return end

    if espEnabled then
        if not highlights[plr] then
            local h = Instance.new("Highlight")
            h.Adornee = character
            h.FillColor = Color3.fromRGB(40, 170, 255)
            h.FillTransparency = 0.65
            h.Parent = gui
            highlights[plr] = h
        end
    elseif highlights[plr] then
        highlights[plr]:Destroy()
        highlights[plr] = nil
    end
end

local function updateEggs()
    for _, item in pairs(highlights) do
        item:Destroy()
    end

    table.clear(highlights)

    if not eggEnabled then return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if string.find(string.lower(obj.Name), "egg")
        and (obj:IsA("Model") or obj:IsA("BasePart")) then

            local h = Instance.new("Highlight")
            h.Adornee = obj
            h.FillColor = Color3.fromRGB(255, 210, 60)
            h.FillTransparency = 0.55
            h.Parent = gui

            table.insert(highlights, h)
        end
    end
end

espButton.Activated:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "ESP Players: " .. (espEnabled and "ON" or "OFF")

    if not espEnabled then
        clearESP()
    end
end)

eggButton.Activated:Connect(function()
    eggEnabled = not eggEnabled
    eggButton.Text = "ESP Eggs: " .. (eggEnabled and "ON" or "OFF")
    updateEggs()
end)

listButton.Activated:Connect(function()
    listEnabled = not listEnabled
    listButton.Text = "Show Players: " .. (listEnabled and "ON" or "OFF")

    local names = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        table.insert(names, plr.DisplayName)
    end

    print("Luckyz Hub Players:", table.concat(names, ", "))
end)

RunService.Heartbeat:Connect(function()
    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            updatePlayer(plr)
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if highlights[plr] then
        highlights[plr]:Destroy()
        highlights[plr] = nil
    end
end)

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 18)
credit.Position = UDim2.new(0, 0, 1, -20)
credit.BackgroundTransparency = 1
credit.Text = "made by JustRealLuckyz"
credit.TextColor3 = Color3.fromRGB(170, 150, 195)
credit.TextSize = 10
credit.Parent = frame

print("Luckyz Hub carregado!")
