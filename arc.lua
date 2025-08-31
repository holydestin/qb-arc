--// QB Throwing Arc Script w/ Rayfield UI
-- make sure Rayfield is loaded before this

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- settings
local showArc = false
local arcParts = {}
local steps = 30 -- how many dots
local gravity = workspace.Gravity
local throwPower = 100 -- tweak this

-- function to clear old arc
local function clearArc()
    for _, part in ipairs(arcParts) do
        part:Destroy()
    end
    arcParts = {}
end

-- function to draw arc
local function drawArc(startPos, direction, power)
    clearArc()

    local velocity = direction.Unit * power
    local dt = 0.1

    for i = 1, steps do
        local t = i * dt
        local pos = startPos + velocity * t + Vector3.new(0, -0.5 * gravity * t * t, 0)

        local dot = Instance.new("Part")
        dot.Shape = Enum.PartType.Ball
        dot.Size = Vector3.new(0.3, 0.3, 0.3)
        dot.Anchored = true
        dot.CanCollide = false
        dot.Color = Color3.fromRGB(255, 255, 0)
        dot.Material = Enum.Material.Neon
        dot.Position = pos
        dot.Parent = workspace

        table.insert(arcParts, dot)
    end
end

-- update loop
RunService.RenderStepped:Connect(function()
    if showArc then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local startPos = char.HumanoidRootPart.Position + Vector3.new(0,3,0)
            local dir = (mouse.Hit.Position - startPos).Unit
            drawArc(startPos, dir, throwPower)
        end
    else
        clearArc()
    end
end)

-- Rayfield UI toggle
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "QB System",
    LoadingTitle = "QB Throw Arc",
    LoadingSubtitle = "by XO Holy",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "QBArc",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

local Tab = Window:CreateTab("QB Tools", 4483362458)
Tab:CreateToggle({
    Name = "Show Throw Arc",
    CurrentValue = false,
    Flag = "ThrowArc",
    Callback = function(Value)
        showArc = Value
    end,
})
