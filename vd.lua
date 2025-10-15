local map = workspace:WaitForChild("Map")

local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
if not success then
    warn("InfiniteYield gagal dieksekusi:", err)
end

local function setupGenerator(generator)
    local billboard = generator:FindFirstChild("GeneratorProgressGui")
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "GeneratorProgressGui"
        billboard.Adornee = generator.PrimaryPart or generator:FindFirstChildWhichIsA("BasePart")
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 4, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = generator
    end

    local textLabel = billboard:FindFirstChild("ProgressLabel")
    if not textLabel then
        textLabel = Instance.new("TextLabel")
        textLabel.Name = "ProgressLabel"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextScaled = false
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextStrokeTransparency = 0.7
        textLabel.TextSize = 16
        textLabel.Parent = billboard
    end

    local function updateProgress()
        local rawProgress = generator:GetAttribute("RepairProgress") or 0
        local progress = math.ceil(rawProgress)
        textLabel.Text = "⚙️" .. tostring(progress) .. "%"
        if progress >= 100 then
            textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        end
    end

    generator:GetAttributeChangedSignal("RepairProgress"):Connect(updateProgress)
    updateProgress()
end

for _, child in ipairs(map:GetChildren()) do
    if child:IsA("Model") and child.Name == "Generator" then
        setupGenerator(child)
    end
end

map.ChildAdded:Connect(function(child)
    if child:IsA("Model") and child.Name == "Generator" then
        setupGenerator(child)
    end
end)
