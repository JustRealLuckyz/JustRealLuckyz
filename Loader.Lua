
-- JustRealLuckyz Hub
-- Mobile UI | made by JustRealLuckyz

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "JustRealLuckyzHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(230, 310)
frame.Position = UDim2.new(0, 15, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(24, 20, 35)
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextButton")
title.Size = UDim2.new(1, -45, 0, 42)
title.Text = "JUSTREALLUCKYZ HUB"
title.TextColor3 = Color3.fromRGB(210, 170, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(35, 35)
minimize.Position = UDim2.new(1, -40, 0, 4)
minimize.Text = "-"
minimize.TextSize = 22
minimize.Parent = frame

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(10, 48)
content.Size = UDim2.new(1, -20, 1, -75)
content.BackgroundTransparency = 1
content.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 7)
layout.Parent = content

local minimized = false
minimize.Activated:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    frame.Size = minimized
        and UDim2.fromOffset(230, 42)
        or UDim2.fromOffset(230, 310)
    minimize.Text = minimized and "+" or "-"
end)

-- Arrastar com toque
local dragging, start, origin
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        start = input.Position
        origin = frame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - start
        frame.Position = UDim2.new(
            origin.X.Scale, origin.X.Offset + delta.X,
            origin.Y.Scale, origin.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local states = {}
local highlights = {}

local function clearESP()
    for _, item in pairs(highlights) do
        item:Destroy()
    end
    table.clear(highlights)
end

local function rootOf(model)
    return model and (
        model:FindFirstChild("HumanoidRootPart")
        or model.PrimaryPart
    )
end

local function espPlayers()
    clearESP()
    if not states.players then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h = Instance.new("Highlight")
            h.Adornee = p.Character
            h.FillColor = Color3.fromRGB(180, 100, 255)
            h.FillTransparency = 0.65
            h.Parent = gui
            table.insert(highlights, h)
        end
    end
end

local function espEggs()
    clearESP()
    if not states.eggs then return end

    for _, obj in ipairs(Workspace:GetDescendants()) do
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

local function button(name, callback, toggle)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(55, 42, 75)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 12
    b.Text = name .. (toggle and " [OFF]" or "")
    b.Parent = content
    Instance.new("UICorner", b)

    local active = false
    b.Activated:Connect(function()
        if toggle then
            active = not active
            b.Text = name .. (active and " [ON]" or " [OFF]")
            b.BackgroundColor3 = active
                and Color3.fromRGB(110, 65, 160)
                or Color3.fromRGB(55, 42, 75)
            callback(active)
        else
            callback()
        end
    end)
end

button("ESP Player", function(v)
    states.players = v
    espPlayers()
end, true)

button("ESP Eggs", function(v)
    states.eggs = v
    espEggs()
end, true)

button("Show Lines", function(v)
    states.lines = v
    -- Linhas exigem attachments nos personagens.
    warn("Show Lines: " .. tostring(v))
end, true)

button("Show Players", function()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(names, p.DisplayName)
    end
    warn(table.concat(names, ", "))
end)

button("Auto Steal - Spawn", function()
    local character = player.Character
    local root = rootOf(character)
    local spawn = Workspace:FindFirstChildWhichIsA(
        "SpawnLocation", true
    )

    if root and spawn then
        root.CFrame = spawn.CFrame + Vector3.new(0, 4, 0)
    else
        warn("Spawn não encontrado.")
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

print("JustRealLuckyz Hub carregado!")
