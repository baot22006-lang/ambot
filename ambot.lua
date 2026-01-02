--// AIMBOT NPC + PLAYER | BLOX FRUITS
--// By ChatGPT (Template)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// SETTINGS
local Settings = {
    Enabled = false,
    AimNPC = true,
    AimPlayer = false,
    MaxDistance = 500,
    AimPart = "HumanoidRootPart"
}

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AimbotGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,180)
frame.Position = UDim2.new(0,20,0,200)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local function Button(text, posY, callback)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-10,0,35)
    b.Position = UDim2.new(0,5,0,posY)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(callback)
end

Button("AIMBOT : OFF", 5, function(self)
    Settings.Enabled = not Settings.Enabled
    self.Text = Settings.Enabled and "AIMBOT : ON" or "AIMBOT : OFF"
end)

Button("AIM NPC", 45, function()
    Settings.AimNPC = true
    Settings.AimPlayer = false
end)

Button("AIM PLAYER", 85, function()
    Settings.AimPlayer = true
    Settings.AimNPC = false
end)

Button("BUDDY X", 125, function()
    -- ép dùng chiêu X
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        game:GetService("VirtualInputManager"):SendKeyEvent(true,"X",false,game)
        task.wait()
        game:GetService("VirtualInputManager"):SendKeyEvent(false,"X",false,game)
    end
end)

--// GET NEAREST TARGET
local function GetNearestTarget()
    local nearest, dist = nil, Settings.MaxDistance

    local function Check(model)
        local hrp = model:FindFirstChild(Settings.AimPart)
        local hum = model:FindFirstChild("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local d = (Camera.CFrame.Position - hrp.Position).Magnitude
            if d < dist then
                dist = d
                nearest = hrp
            end
        end
    end

    if Settings.AimPlayer then
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                Check(p.Character)
            end
        end
    end

    if Settings.AimNPC then
        for _,m in pairs(workspace:GetDescendants()) do
            if m:IsA("Model") and m:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(m) then
                Check(m)
            end
        end
    end

    return nearest
end

--// AIM LOOP
RunService.RenderStepped:Connect(function()
    if not Settings.Enabled then return end
    local target = GetNearestTarget()
    if target then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
    end
end)
