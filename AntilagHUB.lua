if not game:IsLoaded() then game.Loaded:Wait() end

local CG = game:GetService("CoreGui")
if CG:FindFirstChild("ALZ") then CG.ALZ:Destroy() end

local Cam, UIS, RS = workspace.CurrentCamera, game:GetService("UserInputService"), game:GetService("RunService")

local SG = Instance.new("ScreenGui", CG) ; SG.Name = "ALZ" ; SG.ResetOnSpawn = false

-- Кнопка открытия/закрытия
local btn = Instance.new("TextButton", SG) ; btn.Size = UDim2.new(0,45,0,45) ; btn.Position = UDim2.new(0.02,0,0.2,0)
btn.BackgroundColor3 = Color3.fromRGB(35,35,35) ; btn.Text, btn.TextColor3, btn.TextSize = "AL", Color3.fromRGB(0,255,150), 18
btn.Font = Enum.Font.SourceSansBold ; Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
local btnStroke = Instance.new("UIStroke", btn) ; btnStroke.Thickness = 2

-- Главное окно
local MF = Instance.new("Frame", SG) ; MF.Size = UDim2.new(0,250,0,310) ; MF.Position = UDim2.new(0.3,0,0.3,0)
MF.BackgroundColor3 = Color3.fromRGB(15,15,15) ; MF.Visible, MF.Active, MF.Draggable = true, true, true
Instance.new("UICorner", MF).CornerRadius = UDim.new(0,12)
local mainStroke = Instance.new("UIStroke", MF) ; mainStroke.Thickness = 2 -- RGB Обводка меню

-- Заголовок
local T = Instance.new("TextLabel", MF) ; T.Size = UDim2.new(1,0,0,40) ; T.BackgroundColor3 = Color3.fromRGB(25,25,25)
T.Text, T.TextColor3, T.TextSize, T.Font = "ANTI-LAG GUI", Color3.fromRGB(255,255,255), 15, Enum.Font.SourceSansBold
Instance.new("UICorner", T).CornerRadius = UDim.new(0,12)

local C = Instance.new("TextLabel", MF) ; C.Size = UDim2.new(1,0,0,15) ; C.Position = UDim2.new(0,0,0.13,0)
C.BackgroundTransparency = 1 ; C.Text, C.TextColor3, C.TextSize = "by zhantay", Color3.fromRGB(120,120,120), 12

local function makeB(txt, y, col)
    local b = Instance.new("TextButton", MF) ; b.Size = UDim2.new(0,210,0,32) ; b.Position = UDim2.new(0.08,0,y,0)
    b.BackgroundColor3, b.Text, b.TextColor3, b.TextSize = col, txt, Color3.fromRGB(230,230,230), 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6) 
    return b
end

local TxtBtn = makeB("Remove Textures", 0.22, Color3.fromRGB(35,35,35))
local RstBtn = makeB("Reset Resolution", 0.54, Color3.fromRGB(35,35,35))
local FpsBtn = makeB("Show FPS: OFF", 0.67, Color3.fromRGB(45,25,25)) ; FpsBtn.TextColor3 = Color3.fromRGB(255,100,100)

local SL = Instance.new("TextLabel", MF) ; SL.Size = UDim2.new(0,210,0,15) ; SL.Position = UDim2.new(0.08,0,0.35,0)
SL.BackgroundTransparency = 1 ; SL.Text, SL.TextColor3, SL.TextSize = "Render Quality: 100%", Color3.fromRGB(200,200,200), 13

local ST = Instance.new("Frame", MF) ; ST.Size = UDim2.new(0,210,0,6) ; ST.Position = UDim2.new(0.08,0,0.44,0)
ST.BackgroundColor3 = Color3.fromRGB(45,45,45) ; Instance.new("UICorner", ST)

local SB = Instance.new("TextButton", ST) ; SB.Size = UDim2.new(0,20,0,20) ; SB.Position = UDim2.new(1,-10,0,-7)
SB.BackgroundColor3, SB.Text = Color3.fromRGB(0,255,150), "" ; Instance.new("UICorner", SB)

local Stat = Instance.new("TextLabel", MF) ; Stat.Size = UDim2.new(0,210,0,40) ; Stat.Position = UDim2.new(0.08,0,0.81,0)
Stat.BackgroundTransparency = 1 ; Stat.Text, Stat.TextColor3, Stat.TextSize = "Status: Ready", Color3.fromRGB(140,140,140), 11
Stat.TextYAlignment = Enum.TextYAlignment.Top

local FL = Instance.new("TextLabel", SG) ; FL.Size = UDim2.new(0,65,0,22) ; FL.Position = UDim2.new(0.02,0,0.13,0)
FL.BackgroundColor3, FL.BackgroundTransparency = Color3.fromRGB(20,20,20), 0.3 ; FL.Visible = false
FL.Text, FL.TextColor3, FL.TextSize, FL.Font = "FPS: --", Color3.fromRGB(0,255,150), 13, Enum.Font.SourceSansBold
Instance.new("UICorner", FL)
local fpsStroke = Instance.new("UIStroke", FL) ; fpsStroke.Thickness = 1.5

--- === RGB АНИМАЦИЯ KОНТУРОВ === ---
local rgbSpeed = 0.5 -- Скорость перелива (чем больше число, тем быстрее)
RS.RenderStepped:Connect(function()
    local hue = (os.clock() * rgbSpeed) % 1
    local rgbColor = Color3.fromHSV(hue, 0.8, 1)
    
    mainStroke.Color = rgbColor
    btnStroke.Color = rgbColor
    fpsStroke.Color = rgbColor
    T.TextColor3 = rgbColor
    SB.BackgroundColor3 = rgbColor
end)

--- === ЛОГИКА СКРИПТА === ---
local drag, scale = false, 1.0

local function up()
    if _G.ZLoop then _G.ZLoop:Disconnect() ; _G.ZLoop = nil end
    if scale >= 0.98 then 
        Stat.Text = "Status: Native" 
        return 
    end
    local d = 1 / scale
    _G.ZLoop = RS.RenderStepped:Connect(function() 
        if Cam then 
            Cam.CFrame = Cam.CFrame * CFrame.new(0,0,0, d,0,0, 0,1,0, 0,0,1) 
        end 
    end)
    Stat.Text = string.format("Status: Active\nFPS Boost: +%d%%", math.floor((1 - scale) * 100))
end

local function move(i)
    local w, l = ST.AbsoluteSize.X, ST.AbsolutePosition.X
    if w <= 0 then return end
    local p = math.clamp((i.Position.X - l) / w, 0, 1)
    scale = 0.25 + (p * 0.75)
    SB.Position = UDim2.new(p, -10, 0, -7)
    SL.Text = "Render Quality: " .. math.floor(p * 100) .. "%"
    up()
end

TxtBtn.MouseButton1Click:Connect(function()
    TxtBtn.Text = "Cleaning..."
    task.spawn(function()
        pcall(function()
            settings().Rendering.QualityLevel = 1
            local c = 0
            local descs = workspace:GetDescendants()
            for i, o in ipairs(descs) do
                if o:IsA("Texture") or o:IsA("Decal") then 
                    o:Destroy() ; c = c + 1
                elseif o:IsA("BasePart") and not o:IsA("MeshPart") then 
                    o.Material = Enum.Material.SmoothPlastic
                elseif o:IsA("ParticleEmitter") or o:IsA("Trail") then 
                    o.Enabled = false 
                end
                
                if i % 300 == 0 then task.wait() end
            end
            TxtBtn.Text, TxtBtn.BackgroundColor3 = "Textures Cleared!", Color3.fromRGB(0,120,50)
            Stat.Text = "Removed: " .. c
        end)
    end)
end)

RstBtn.MouseButton1Click:Connect(function() 
    scale = 1.0 
    SB.Position = UDim2.new(1, -10, 0, -7) 
    SL.Text = "Render Quality: 100%" 
    up() 
    pcall(gcinfo) 
end)

local sfps, fcon = false, nil
FpsBtn.MouseButton1Click:Connect(function()
    sfps = not sfps
    if sfps then
        FpsBtn.Text, FpsBtn.BackgroundColor3, FpsBtn.TextColor3 = "Show FPS: ON", Color3.fromRGB(25,50,25), Color3.fromRGB(100,255,100)
        FL.Visible = true
        local lt, f = os.clock(), 0
        fcon = RS.RenderStepped:Connect(function()
            f = f + 1
            local ct = os.clock()
            if ct - lt >= 0.5 then 
                local fps = math.floor(f / (ct - lt))
                FL.Text = "FPS: " .. fps
                f, lt = 0, ct 
            end
        end)
    else
        FpsBtn.Text, FpsBtn.BackgroundColor3, FpsBtn.TextColor3 = "Show FPS: OFF", Color3.fromRGB(45,25,25), Color3.fromRGB(255,100,100)
        FL.Visible = false
        if fcon then fcon:Disconnect() ; fcon = nil end
    end
end)

SB.InputBegan:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
        drag = true 
    end 
end)

UIS.InputEnded:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
        drag = false 
    end 
end)

UIS.InputChanged:Connect(function(i) 
    if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
        move(i) 
    end 
end)

btn.MouseButton1Down:Connect(function() MF.Visible = not MF.Visible end)

task.spawn(function() 
    while task.wait(20) do 
        pcall(gcinfo) 
    end 
end)
