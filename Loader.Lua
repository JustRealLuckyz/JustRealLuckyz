
-- JustRealLuckyz Hub
-- Recursos para uso no próprio jogo

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "JustRealLuckyzHub"
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
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "JustRealLuckyz Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Parent = frame

local function makeButton(name, y)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = UDim2.fromOffset(10, y)
    button.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Text = name .. ": OFF"
    button.Parent = frame
    Instance.new("UICorner", button)
    return button
end

local espButton = makeButton("ESP Players", 50)
local eggButton = makeButton("Anti-Egg Player", 92)
local lineButton = makeButton("Show Lines", 134)
local listButton = makeButton("Show Players", 176)

local espEnabled = false
local antiEggEnabled = false
local linesEnabled = false
local listEnabled = false

local highlights = {}
local billboards = {}
local lines = {}

local function clearPlayer(plr)
    if highlights[plr] then highlights[plr]:Destroy() end
    if billboards[plr] then billboards[plr]:Destroy() end
    if lines[plr] then lines[plr]:Destroy() end
    highlights[plr] = nil
    billboards[plr] = nil
    lines[plr] = nil
end

local function updatePlayer(plr)
    if plr == player then return end

    local character = plr.Character
    if not character then return end

    local isEggPlayer = plr:GetAttribute("IsEggPlayer") == true

    if (espEnabled or (antiEggEnabled and isEggPlayer)) then
        if not highlights[plr] then
            local h = Instance.new("Highlight")
            h.Adornee = character
            h.Parent = character
            highlights[plr] = h
        end

        highlights[plr].FillColor = isEggPlayer
            and Color3.fromRGB(255, 40, 40)
            or Color3.fromRGB(40, 170, 255)

        highlights[plr].OutlineColor = Color3.new(1, 1, 1)
    elseif highlights[plr] then
        highlights[plr]:Destroy()
        highlights[plr] = nil
    end

    if listEnabled and not billboards[plr] then
        local head = character:FindFirstChild("Head")
        if head then
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.fromOffset(150, 30)
            bb.StudsOffset = Vector3.new(0, 2.5, 0)
            bb.Adornee = head
            bb.AlwaysOnTop = true
            bb.Parent = gui

            local label = Instance.new("TextLabel")
            label.Size = UDim2.fromScale(1, 1)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1, 1, 1)
            label.Text = plr.Name
            label.Parent = bb

            billboards[plr] = bb
        end
    elseif not listEnabled and billboards[plr] then
        billboards[plr]:Destroy()
        billboards[plr] = nil
    end
end

espButton.Activated:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "ESP Players: " .. (espEnabled and "ON" or "OFF")
end)

eggButton.Activated:Connect(function()
    antiEggEnabled = not antiEggEnabled
    eggButton.Text = "Anti-Egg Player: " .. (antiEggEnabled and "ON" or "OFF")
end)

lineButton.Activated:Connect(function()
    linesEnabled = not linesEnabled
    lineButton.Text = "Show Lines: " .. (linesEnabled and "ON" or "OFF")
end)

listButton.Activated:Connect(function()
    listEnabled = not listEnabled
    listButton.Text = "Show Players: " .. (listEnabled and "ON" or "OFF")
end)

Players.PlayerRemoving:Connect(clearPlayer)

RunService.Heartbeat:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        updatePlayer(plr)
    end
end)
