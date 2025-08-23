task.spawn(function()
    local ok, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
    if not ok then
        warn("Gagal load Infinite Yield:", err)
    end
end)

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local COLOR_DONE = Color3.fromRGB(60, 255, 0)
local COLOR_LABEL_DONE = Color3.fromRGB(255, 0, 0)
local COLOR_LABEL_ACTIVE = Color3.fromRGB(0, 255, 0)
local COLOR_HATCH_LABEL = Color3.fromRGB(0, 255, 0)

local function clearComputerLabels()
    for _, obj in pairs(Workspace.Map:GetDescendants()) do
        if obj:IsA("BasePart") and obj:FindFirstChild("ComputerLabel") then
            obj.ComputerLabel:Destroy()
        end
    end
end

local function addComputerLabel(screen, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ComputerLabel"
    billboard.Size = UDim2.new(0, 120, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 0.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = screen
    billboard.Parent = screen

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    if color == COLOR_LABEL_DONE then
        label.Text = "💻🔴"
    else
        label.Text = "💻🟢"
    end
    label.TextColor3 = color
    label.TextStrokeTransparency = 0.5
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.Parent = billboard
end

local function addHatchLabel(part)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HatchLabel"
    billboard.Size = UDim2.new(0, 120, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 1.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = part
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "Hatch"
    label.TextColor3 = COLOR_HATCH_LABEL
    label.TextStrokeTransparency = 0.5
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.Parent = billboard
end

local function refreshHatchLabel()
    local hatch = Workspace.Map:FindFirstChild("Hatch")
    if not hatch then return end

    local part
    if hatch:IsA("BasePart") then
        part = hatch
    elseif hatch:IsA("Model") then
        part = hatch.PrimaryPart
        if not part then
            for _, d in ipairs(hatch:GetDescendants()) do
                if d:IsA("BasePart") then
                    part = d
                    break
                end
            end
        end
    end
    if not part then return end

    local existing = part:FindFirstChild("HatchLabel")
    if existing then existing:Destroy() end
    addHatchLabel(part)
end

local function refreshComputerLabels()
    clearComputerLabels()
    for _, obj in pairs(Workspace.Map:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "ComputerTable" then
            local screen = obj:FindFirstChild("Screen")
            if screen and screen:IsA("BasePart") then
                local color = screen.Color
                if color == COLOR_DONE then
                    addComputerLabel(screen, COLOR_LABEL_DONE)
                else
                    addComputerLabel(screen, COLOR_LABEL_ACTIVE)
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        refreshComputerLabels()
        refreshHatchLabel()
        task.wait(1)
    end
end)