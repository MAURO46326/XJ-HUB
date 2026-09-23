--[[ 
    XJ HUB - MAXIMUS DARK BLUE (THE FINAL FIX)
    Status: NOCLIP LIGA/DESLIGA 100% | ANTI-TROPEÇO BLINDADO
    Atalho: RightControl
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // LIMPEZA
if CoreGui:FindFirstChild("XJ_Maximus") then CoreGui:FindFirstChild("XJ_Maximus"):Destroy() end
if workspace:FindFirstChild("XJ_Float") then workspace.XJ_Float:Destroy() end

local Original = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows
}

local Config = {
    Color = Color3.fromRGB(0, 85, 255),
    BgColor = Color3.fromRGB(10, 10, 15),
    Speed = 16,
    Jump = 50,
    FlySpeed = 50
}

local State = {
    Aimbot = false, TeamCheck = false, AutoClick = false, ESP = false,
    Fullbright = false, NoFog = false, AntiLag = false, Fly = false,
    Noclip = false, InfJump = false, SpinBot = false, Float = false,
    ClickTP = false, InstantPrompt = false, AntiAFK = false, Visible = true
}

-- // UI SETUP
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "XJ_Maximus"
Screen.ResetOnSpawn = false

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 215, 0, 580)
Main.Position = UDim2.new(0.85, -50, 0.5, -290)
Main.BackgroundColor3 = Config.BgColor
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Config.Color
Stroke.Thickness = 1.5

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Config.Color
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Header)
Title.Text = "XJ MAXIMUS | BLUE"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -45)
Scroll.Position = UDim2.new(0, 0, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- // HELPER: TEAM CHECK
local function IsAlly(p)
    if not State.TeamCheck then return false end
    if p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then return true end
    if p.TeamColor == LocalPlayer.TeamColor then return true end
    return false
end

-- // BUILDERS
local function CreateInput(text, default, ref)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(0, 195, 0, 35)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", f)
    local lbl = Instance.new("TextLabel", f)
    lbl.Text = text
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    local box = Instance.new("TextBox", f)
    box.Size = UDim2.new(0.3, 0, 0.7, 0)
    box.Position = UDim2.new(0.65, 0, 0.15, 0)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    box.Text = tostring(default)
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 10
    Instance.new("UICorner", box)
    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then Config[ref] = val end
    end)
end

local function CreateToggle(text, ref, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0, 195, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(130, 130, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)
    local ind = Instance.new("Frame", btn)
    ind.Size = UDim2.new(0, 4, 0.6, 0)
    ind.Position = UDim2.new(1, -8, 0.2, 0)
    ind.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Instance.new("UICorner", ind)
    btn.MouseButton1Click:Connect(function()
        State[ref] = not State[ref]
        btn.TextColor3 = State[ref] and Color3.new(1,1,1) or Color3.fromRGB(130, 130, 150)
        ind.BackgroundColor3 = State[ref] and Config.Color or Color3.fromRGB(40, 40, 50)
        if callback then callback(State[ref]) end
    end)
end

-- // --- MENU ---
CreateToggle("AIMBOT (M2)", "Aimbot")
CreateToggle("TEAM CHECK", "TeamCheck")
CreateToggle("AUTO CLICKER", "AutoClick")
CreateToggle("ESP WALLHACK", "ESP")
CreateInput("WALK SPEED", 16, "Speed")
CreateInput("JUMP POWER", 50, "Jump")
CreateInput("FLY SPEED", 50, "FlySpeed")
CreateToggle("INF JUMP", "InfJump")
CreateToggle("FLY MODE", "Fly", function(v)
    local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if v and r then
        local b = Instance.new("BodyVelocity", r); b.Name = "XJ_Fly"; b.MaxForce = Vector3.new(math.huge,math.huge,math.huge); b.Velocity = Vector3.new(0,0,0)
    elseif r and r:FindFirstChild("XJ_Fly") then r.XJ_Fly:Destroy() end
end)
CreateToggle("NOCLIP", "Noclip")
CreateToggle("FLOAT (ESTÁTICO)", "Float", function(v)
    if v and LocalPlayer.Character then
        local p = Instance.new("Part", workspace); p.Name="XJ_Float"; p.Size=Vector3.new(10,1,10); p.Anchored=true; p.Material=Enum.Material.ForceField; p.Color=Config.Color; p.CFrame=LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,-3.5,0)
    elseif workspace:FindFirstChild("XJ_Float") then workspace.XJ_Float:Destroy() end
end)
CreateToggle("SPINBOT", "SpinBot")
CreateToggle("FULLBRIGHT", "Fullbright", function(v)
    Lighting.Ambient = v and Color3.new(1,1,1) or Original.Ambient
    Lighting.OutdoorAmbient = v and Color3.new(1,1,1) or Original.OutdoorAmbient
    Lighting.Brightness = v and 2 or Original.Brightness
    Lighting.GlobalShadows = not v
end)
CreateToggle("NO FOG", "NoFog", function(v) Lighting.FogEnd = v and 100000 or Original.FogEnd end)
CreateToggle("ANTI-LAG", "AntiLag", function(v)
    if v then
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic
            elseif obj:IsA("Decal") then obj.Transparency = 1 end
        end
    end
end)
CreateToggle("INSTANT PROMPT", "InstantPrompt")
CreateToggle("ANTI-AFK", "AntiAFK")
CreateToggle("CLICK TP (CTRL)", "ClickTP")

local rj = Instance.new("TextButton", Scroll)
rj.Size = UDim2.new(0, 195, 0, 30); rj.Text = "REJOIN SERVER"; rj.BackgroundColor3 = Config.Color; rj.TextColor3 = Color3.new(1,1,1); rj.Font = Enum.Font.GothamBold; Instance.new("UICorner", rj)
rj.MouseButton1Click:Connect(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)

-- // LOGIC CORE
RunService.Stepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid")
    local Root = Char:FindFirstChild("HumanoidRootPart")

    -- ANTI-TROPEÇO (SMOOTH SPEED)
    if Hum then
        Hum.JumpPower = Config.Jump
        if Hum.MoveDirection.Magnitude > 0 then
            Hum.WalkSpeed = Config.Speed
        else
            Hum.WalkSpeed = 16
        end
    end

    -- NOCLIP SELETIVO (O segredo pra não tropeçar)
    for _, part in pairs(Char:GetDescendants()) do
        if part:IsA("BasePart") then
            if State.Noclip then
                part.CanCollide = false
            else
                -- Devolve colisão apenas para as partes principais (previne o bug)
                if part.Name == "HumanoidRootPart" or part.Name == "UpperTorso" or part.Name == "LowerTorso" or part.Name == "Torso" then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- LOOP AUXILIAR
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    local Root = Char.HumanoidRootPart

    if State.SpinBot then Root.CFrame *= CFrame.Angles(0, math.rad(50), 0) end
    if State.InstantPrompt then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
        end
    end
    if State.AntiAFK then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end

    -- FLY LOGIC
    if State.Fly and Root:FindFirstChild("XJ_Fly") then
        local vec = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vec += Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vec -= Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vec -= Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vec += Camera.CFrame.RightVector end
        Root.XJ_Fly.Velocity = vec * Config.FlySpeed
    end

    -- ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local high = p.Character:FindFirstChild("XJ_High")
            if State.ESP and not IsAlly(p) then
                if not high then
                    high = Instance.new("Highlight", p.Character); high.Name = "XJ_High"; high.FillColor = Config.Color
                end
            elseif high then high:Destroy() end
        end
    end
end)

-- AIMBOT & AUTO-CLICK
RunService.RenderStepped:Connect(function()
    if State.AutoClick then VirtualUser:ClickButton1(Vector2.new()) end
    if State.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target, dist = nil, 500
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and not IsAlly(v) then
                local pos, vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mag < dist then target = v.Character.Head; dist = mag end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position) end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

UserInputService.InputBegan:Connect(function(i, gp)
    if i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end
    if not gp and State.ClickTP and i.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit * CFrame.new(0, 3, 0)
    end
end)
