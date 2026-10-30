
--========================================
-- FALSIFIQUE UM OVO
-- made by JustRealLuckyz
--========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local old = game:GetService("CoreGui"):FindFirstChild("JustRealLuckyzHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "JustRealLuckyzHub"
gui.ResetOnSpawn = false

local success = pcall(function()
    gui.Parent = game:GetService("CoreGui")
end)

if not success or not gui.Parent then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(205, 260)
frame.Position = UDim2.new(0.5, -102, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 29)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -42, 0, 38)
title.Position = UDim2.fromOffset(8, 0)
title.BackgroundTransparency = 1
title.Text = "JUSTREALLUCKYZ HUB"
title.TextColor3 = Color3.fromRGB(190, 130, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.Parent = frame

local minimized = false
local normalSize = frame.Size

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(30, 30)
minimize.Position = UDim2.new(1, -35, 0, 4)
minimize.Text = "−"
minimize.TextSize = 22
minimize.TextColor3 = Color3.new(1,1,1)
minimize.BackgroundColor3 = Color3.fromRGB(75, 45, 115)
minimize.Parent = frame

Instance.new("UICorner", minimize)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -70)
content.Position = UDim2.fromOffset(10, 45)
content.BackgroundTransparency = 1
content.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.Parent = content

local states = {
    ESP = false,
    Lines = false,
    Players = false
}

local function createButton(name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(48, 48, 65)
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 12
    button.Text = name .. " [OFF]"
    button.Parent = content

    Instance.new("UICorner", button)

    local active = false

    button.MouseButton1Click:Connect(function()
        active = not active
        button.Text = name ..
            (active and " [ON]" or " [OFF]")

        button.BackgroundColor3 = active
            and Color3.fromRGB(100, 55, 155)
            or Color3.fromRGB(48, 48, 65)

        callback(active)
    end)

    return button
end

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    content.Visible = not minimized
    frame.Size = minimized
        and UDim2.fromOffset(205, 42)
        or normalSize

    minimize.Text = minimized and "+" or "−"
end)

-- ESP
local visuals = {}

local function clearVisuals()
    for _, objects in pairs(visuals) do
        for _, object in ipairs(objects) do
            if object and object.Parent then
                object:Destroy()
            end
        end
    end
    table.clear(visuals)
end

local function getRoot(character)
    return character and (
        character:FindFirstChild("HumanoidRootPart")
        or character.PrimaryPart
    )
end

local function addESP(model, label, color)
    if visuals[model] or not model.Parent then return end

    local root = getRoot(model)
    if not root then return end

    local objects = {}

    local highlight = Instance.new("Highlight")
    highlight.Adornee = model
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.FillTransparency = 0.7
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = gui
    table.insert(objects, highlight)

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = root
    billboard.Size = UDim2.fromOffset(140, 25)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = gui
    table.insert(objects, billboard)

    local text = Instance.new("TextLabel")
    text.Size = UDim2.fromScale(1,1)
    text.BackgroundTransparency = 1
    text.Text = label
    text.TextColor3 = color
    text.TextStrokeTransparency = 0.2
    text.Font = Enum.Font.GothamBold
    text.TextSize = 12
    text.Parent = billboard

    if states.Lines then
        local localRoot = getRoot(LocalPlayer.Character)

        if localRoot then
            local a0 = Instance.new("Attachment")
            a0.Parent = localRoot

            local a1 = Instance.new("Attachment")
            a1.Parent = root

            local beam = Instance.new("Beam")
            beam.Attachment0 = a0
            beam.Attachment1 = a1
            beam.Width0 = 0.05
            beam.Width1 = 0.025
            beam.Color = ColorSequence.new(color)
            beam.Parent = gui

            table.insert(objects, a0)
            table.insert(objects, a1)
            table.insert(objects, beam)
        end
    end

    visuals[model] = objects
end

local function refreshESP()
    clearVisuals()

    if not states.ESP then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            addESP(
                player.Character,
                player.DisplayName,
                Color3.fromRGB(190, 120, 255)
            )
        end
    end

    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("Model")
            and string.find(string.lower(object.Name), "egg") then

            addESP(
                object,
                "OVO",
                Color3.fromRGB(255, 210, 70)
            )
        end
    end
end

createButton("ESP Player + Ovos", function(value)
    states.ESP = value
    refreshESP()
end)

createButton("Show Lines", function(value)
    states.Lines = value
    refreshESP()
end)

-- Lista de jogadores
local playerList = Instance.new("Frame")
playerList.Size = UDim2.fromOffset(190, 180)
playerList.Position = UDim2.new(1, 8, 0, 0)
playerList.BackgroundColor3 = Color3.fromRGB(25,25,35)
playerList.Visible = false
playerList.Parent = frame

Instance.new("UICorner", playerList)

local playerText = Instance.new("TextLabel")
playerText.Size = UDim2.new(1,0,1,0)
playerText.BackgroundTransparency = 1
playerText.TextColor3 = Color3.new(1,1,1)
playerText.Font = Enum.Font.Gotham
playerText.TextSize = 11
playerText.TextWrapped = true
playerText.TextYAlignment = Enum.TextYAlignment.Top
playerText.Parent = playerList

local function updatePlayers()
    local names = {}

    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(names, player.DisplayName)
    end

    playerText.Text = table.concat(names, "\n")
end

createButton("Show Players", function(value)
    states.Players = value
    playerList.Visible = value
    updatePlayers()
end)

-- Auto Steal: teleporte local único para SpawnLocation
createButton("Auto Steal", function(value)
    if not value then return end

    local character = LocalPlayer.Character
    local root = getRoot(character)

    if not root then return end

    local spawn = Workspace:FindFirstChildWhichIsA(
        "SpawnLocation", true
    )

    if spawn then
        root.CFrame = spawn.CFrame + Vector3.new(0, 4, 0)
    else
        warn("SpawnLocation não encontrado.")
    end
end)

-- Auto Collect: botão demonstrativo
createButton("Auto Collect", function(value)
    warn("Auto Collect ainda precisa da lógica oficial do jogo.")
end)

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, -10, 0, 15)
credit.Position = UDim2.new(0, 5, 1, -18)
credit.BackgroundTransparency = 1
credit.Text = "made by JustRealLuckyz"
credit.TextColor3 = Color3.fromRGB(155,145,175)
credit.Font = Enum.Font.Gotham
credit.TextSize = 9
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.Parent = frame

Players.PlayerAdded:Connect(function()
    task.wait(1)
    updatePlayers()
    refreshESP()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.3)
    updatePlayers()
    refreshESP()
end)

print("JustRealLuckyz Hub carregado!")
