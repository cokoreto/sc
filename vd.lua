loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

local map = workspace:WaitForChild("Map")
local scannedContainers = {}
local function setupGenerator(generator)
    if not generator or not generator:IsA("Model") then return end
    if generator:GetAttribute("GeneratorGuiSetup") then return end
    generator:SetAttribute("GeneratorGuiSetup", true)
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
local function scanContainer(container)
    if scannedContainers[container] then return end
    scannedContainers[container] = true
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("Model") and child.Name == "Generator" then
            setupGenerator(child)
        end
    end
    container.ChildAdded:Connect(function(child)
        if child:IsA("Model") and child.Name == "Generator" then
            setupGenerator(child)
        end
    end)
end
local directGeneratorFound = false
for _, child in ipairs(map:GetChildren()) do
    if child:IsA("Model") and child.Name == "Generator" then
        directGeneratorFound = true
        break
    end
end
if directGeneratorFound then
    scanContainer(map)
else
    for _, child in ipairs(map:GetChildren()) do
        if child:IsA("Folder") then
            scanContainer(child)
        end
    end
end
map.ChildAdded:Connect(function(child)
    if child:IsA("Folder") then
        scanContainer(child)
    elseif child:IsA("Model") and child.Name == "Generator" then
        scanContainer(map)
        setupGenerator(child)
    end
end)
