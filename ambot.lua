--// CIRCULAR AIMBOT | BAO DEP TRAI | FIX FULL

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// CONFIG
local Config = {
    Mode = "NONE", -- NPC / PLAYER
    Smooth = 0.12,
    MaxDistance = 700
}

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BaoDepTrai_Aimbot"

local circle = Instance.new("Frame", gui)
circle.Size = UDim2.new(0,150,0,150)
circle.Position = UDim2.new(0,80,0,260)
circle.BackgroundColor3 = Color3.fromRGB(25,25,25)
circle.Active = true
circle.Draggable = true

local corner = Instance.new("UICorner", circle)
corner.CornerRadius = UDim.new(1,0)

--// TITLE
local title = Instance.new("TextLabel", circle)
title.Size = UDim2.new(1,0,0,32)
title.Position = UDim2.new(0,0,0,6)
title.Text = "Bảo đẹp trai"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,255,150)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

--// BUTTON MAKER
local function Button(text, y)
    local b = Instance.new("TextButton", circle)
    b.Size = UDim2.new(0,115,0,30)
    b.Position = UDim2.new(0.5,-57,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0,14)
    return b
end

local btnNPC = Button("NPC", 55)
local btnPLR = Button("PLAYER", 95)

local function UpdateButtons()
    btnNPC.BackgroundColor3 = (Config.Mode == "NPC")
        and Color3.fromRGB(0,180,90) or Color3.fromRGB(60,60,60)

    btnPLR.BackgroundColor3 = (Config.Mode == "PLAYER")
        and Color3.fromRGB(0,180,90) or Color3.fromRGB(60,60,60)
end

btnNPC.MouseButton1Click:Connect(function()
    Config.Mode = "NPC"
    UpdateButtons()
end)

btnPLR.MouseButton1Click:Connect(function()
    Config.Mode = "PLAYER"
    UpdateButtons()
end)

--// TARGET FIND
local function GetClosest()
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

    if Config.Mode == "PLAYER" then
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                Check(p.Character)
            end
        end
    elseif Config.Mode == "NPC" then
        for _,m in pairs(workspace:GetDescendants()) do
            if m:IsA("Model") and m:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(m) then
                Check(m)
            end
        end
    end

    return closest
end

--// AIM LOOP (LUÔN CHẠY)
RunService.RenderStepped:Connect(function()
    if Config.Mode == "NONE" then return end
    local target = GetClosest()
    if target then
        local cam = Camera.CFrame
        local aim = CFrame.new(cam.Position, target.Position)
        Camera.CFrame = cam:Lerp(aim, Config.Smooth)
    end
end)
