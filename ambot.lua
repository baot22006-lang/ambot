--// CIRCULAR AIMBOT MENU | BẢO ĐẸP TRAI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// CONFIG
local Config = {
    Enabled = false,
    AimNPC = true,
    AimPlayer = false,
    Smooth = 0.1,
    HoldKey = Enum.UserInputType.MouseButton2,
    MaxDistance = 600
}

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BaoDepTraiMenu"

local circle = Instance.new("Frame", gui)
circle.Size = UDim2.new(0,140,0,140)
circle.Position = UDim2.new(0,60,0,250)
circle.BackgroundColor3 = Color3.fromRGB(30,30,30)
circle.Active = true
circle.Draggable = true

local uic = Instance.new("UICorner", circle)
uic.CornerRadius = UDim.new(1,0) -- TRÒN

--// TITLE
local title = Instance.new("TextLabel", circle)
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,5)
title.Text = "Bảo đẹp trai"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,215,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

--// BUTTON MAKER
local function MakeBtn(text, y)
    local b = Instance.new("TextButton", circle)
    b.Size = UDim2.new(0,110,0,28)
    b.Position = UDim2.new(0.5,-55,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0,12)
    return b
end

local btnAim = MakeBtn("AIM : OFF", 40)
local btnNPC = MakeBtn("NPC", 72)
local btnPLR = MakeBtn("PLAYER", 104)

btnAim.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    btnAim.Text = Config.Enabled and "AIM : ON" or "AIM : OFF"
end)

btnNPC.MouseButton1Click:Connect(function()
    Config.AimNPC = true
    Config.AimPlayer = false
end)

btnPLR.MouseButton1Click:Connect(function()
    Config.AimPlayer = true
    Config.AimNPC = false
end)

--// AIM LOGIC
local function GetTarget()
    local closest, dist = nil, Config.MaxDistance

    local function Check(char)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local d = (Camera.CFrame.Position - hrp.Position).Magnitude
            if d < dist then
                dist = d
                closest = hrp
            end
        end
    end

    if Config.AimPlayer then
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                Check(p.Character)
            end
        end
    end

    if Config.AimNPC then
        for _,m in pairs(workspace:GetChildren()) do
            if m:IsA("Model") and m:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(m) then
                Check(m)
            end
        end
    end

    return closest
end

--// HOLD AIM
local holding = false
UIS.InputBegan:Connect(function(i)
    if i.UserInputType == Config.HoldKey then holding = true end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Config.HoldKey then holding = false end
end)

--// LOOP
RunService.RenderStepped:Connect(function()
    if not Config.Enabled or not holding then return end
    local target = GetTarget()
    if target then
        local cam = Camera.CFrame
        local aim = CFrame.new(cam.Position, target.Position)
        Camera.CFrame = cam:Lerp(aim, Config.Smooth)
    end
end)
