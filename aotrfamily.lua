local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local titleLabel = player.PlayerGui.Interface.Customisation.Family.Family.Title
local clickX, clickY = 1000, 560
local yesButtonX, yesButtonY = 582, 340
local autoRollEnabled = false
local filterTier = ""

local rarityOrder = {"Common", "Rare", "Epic", "Legedary", "Mythical"}
local rarityIndex = {}
for i, v in ipairs(rarityOrder) do
    rarityIndex[v] = i
end

local function getTierFromText(text)
    local match = string.match(text, "%((.-)%)")
    return match or ""
end

local gui = Instance.new("ScreenGui")
gui.Name = "AutoRollUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 120)
frame.Position = UDim2.new(0, 30, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -16, 0, 28)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "AOTR @chocoreto"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 90, 0, 24)
toggle.Position = UDim2.new(0, 8, 0, 32)
toggle.Text = "Auto Roll: OFF"
toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 14
toggle.Parent = frame

toggle.MouseButton1Click:Connect(function()
    autoRollEnabled = not autoRollEnabled
    toggle.Text = "Auto Roll: " .. (autoRollEnabled and "ON" or "OFF")
end)

local textbox = Instance.new("TextBox")
textbox.Size = UDim2.new(0, 140, 0, 24)
textbox.Position = UDim2.new(0, 8, 0, 64)
textbox.PlaceholderText = "Enter Rarity (e.g. Epic)"
textbox.Text = ""
textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.Font = Enum.Font.Gotham
textbox.TextSize = 14
textbox.Parent = frame

textbox.FocusLost:Connect(function()
    filterTier = textbox.Text or ""
end)

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 24, 0, 24)
minimize.Position = UDim2.new(1, -32, 0, 2)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 16
minimize.Parent = frame

local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in ipairs(frame:GetChildren()) do
        if child ~= title and child ~= minimize then
            child.Visible = not minimized
        end
    end
    frame.Size = minimized and UDim2.new(0, 260, 0, 34) or UDim2.new(0, 260, 0, 120)
end)

local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
end

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Vector2.new(frame.Position.X.Offset, frame.Position.Y.Offset)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

task.spawn(function()
    while true do
        if autoRollEnabled and filterTier ~= "" then
            local currentText = titleLabel.Text
            local currentTier = getTierFromText(currentText)
            if rarityIndex[currentTier] and rarityIndex[filterTier] and rarityIndex[currentTier] >= rarityIndex[filterTier] then
                autoRollEnabled = false
                toggle.Text = "Auto Roll: OFF"
            else
                VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
                task.wait(1)
                VirtualInputManager:SendMouseButtonEvent(yesButtonX, yesButtonY, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(yesButtonX, yesButtonY, 0, false, game, 0)
            end
        end
        wait(4)
    end
end)
