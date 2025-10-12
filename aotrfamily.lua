local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local clickX, clickY = 1000, 560
local gui = Instance.new("ScreenGui")
gui.Name = "AutoRollFloatingTextUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
local text = Instance.new("TextLabel")
text.AnchorPoint = Vector2.new(0.5, 0)
text.Position = UDim2.new(0.5, 0, 0, 20)
text.Size = UDim2.new(0, 180, 0, 40)
text.BackgroundTransparency = 1
text.Text = "Roll: OFF"
text.TextColor3 = Color3.new(1, 1, 1)
text.Font = Enum.Font.GothamBold
text.TextSize = 28
text.Parent = gui
local autoRollEnabled = false
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.G then
        autoRollEnabled = not autoRollEnabled
        text.Text = "Roll: " .. (autoRollEnabled and "ON" or "OFF")
        text.TextColor3 = autoRollEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    end
end)
spawn(function()
    while true do
        if autoRollEnabled then
            VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, game, 0)
        end
        wait(0.1)
    end
end)
