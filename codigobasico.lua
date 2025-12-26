--[[ 
  SIX HUB - AC TEST (VER. FINAL 2025)
  Ajustes: Auto-Quest Recursivo, Click Direto (tool:Activate) e Hitbox Expander
]]

if not game:IsLoaded() then game.Loaded:Wait() end

local _0x1 = game:GetService("Players")
local _0x2 = game:GetService("TweenService")
local _0x3 = game:GetService("RunService")
local _0x4 = game:GetService("ReplicatedStorage")
local _0x5 = _0x1.LocalPlayer
local _0x6 = _0x5:WaitForChild("PlayerGui")

local _0x7 = false -- ESP
local _0x8 = false -- Farm
local _0x9 = false -- Auto Click

-- TABELA DE QUESTS
local _0x10 = {
    {L = 0, N = "Bandit Quest Giver", Q = "BanditQuest", E = "Bandit", ID = 1},
    {L = 10, N = "Monkey Quest Giver", Q = "MonkeyQuest", E = "Monkey", ID = 1}
}

-- 1. INTERFACE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BF_SECURE_TEST_V4"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = _0x6

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 200, 0, 260)
Main.Position = UDim2.new(0.05, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui 

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "AC TEST MENU"
Title.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = Main

local EspBtn = Instance.new("TextButton")
EspBtn.Size = UDim2.new(0.9, 0, 0, 35)
EspBtn.Position = UDim2.new(0.05, 0, 0.18, 0)
EspBtn.Text = "ESP: OFF"
EspBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
EspBtn.Parent = Main

local FarmBtn = Instance.new("TextButton")
FarmBtn.Size = UDim2.new(0.9, 0, 0, 35)
FarmBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
FarmBtn.Text = "AUTO FARM: OFF"
FarmBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
FarmBtn.Parent = Main

local ClickBtn = Instance.new("TextButton")
ClickBtn.Size = UDim2.new(0.9, 0, 0, 35)
ClickBtn.Position = UDim2.new(0.05, 0, 0.52, 0)
ClickBtn.Text = "AUTO CLICK: OFF"
ClickBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ClickBtn.Parent = Main

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.9, 0, 0, 35)
CloseBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
CloseBtn.Text = "FECHAR TOTALMENTE"
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CloseBtn.Parent = Main

-- 2. FUNÇÃO ANTI-QUEDA
local function _fly(char, state)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bv = hrp:FindFirstChild("FarmVelocity")
    if state then
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Name = "FarmVelocity"
            bv.Velocity = Vector3.zero
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = hrp
        end
    elseif bv then bv:Destroy() end
end

-- 3. EXPANSÃO DE ÁREA DE DANO
local function _expandHitbox(mob)
    if mob and mob:FindFirstChild("HumanoidRootPart") then
        local hrp = mob.HumanoidRootPart
        hrp.Size = Vector3.new(50, 50, 50) 
        hrp.Transparency = 0.5
        hrp.Color = Color3.new(0, 1, 1)
        hrp.CanCollide = false
    end
end

-- 4. LÓGICA DE FARM E QUEST (CORRIGIDA)
local function _farmLoop()
    while _0x8 do
        local l = _0x5.Data.Level.Value
        local d = _0x10[1]
        for _, v in ipairs(_0x10) do if l >= v.L then d = v end end
        
        local c = _0x5.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            _fly(c, true)
            
            local temQuest = _0x5.PlayerGui.Main:FindFirstChild("Quest")
            
            if not temQuest then
                local npc = workspace:FindFirstChild(d.N, true)
                if npc then
                    c.HumanoidRootPart.CFrame = npc:GetModelCFrame() * CFrame.new(0, 0, 2)
                    task.wait(0.5) -- Delay para validação de posição do servidor
                    local questRemote = _0x4:FindFirstChild("CommF_", true)
                    if questRemote then
                        questRemote:InvokeServer("StartQuest", d.Q, d.ID)
                    end
                end
            else
                local mob = nil
                for _, e in ipairs(workspace:GetDescendants()) do
                    if e.Name == d.E and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                        mob = e break
                    end
                end

                if mob then
                    c.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                    _expandHitbox(mob) 
                    
                    if not c:FindFirstChildOfClass("Tool") then
                        local tool = _0x5.Backpack:FindFirstChildOfClass("Tool")
                        if tool then tool.Parent = c end
                    end
                    
                    local tool = c:FindFirstChildOfClass("Tool")
                    if tool and _0x9 then
                        tool:Activate()
                        -- Ataque via Remote para garantir dano no 2025
                        local combatRemote = _0x4:FindFirstChild("RigControllerEvent", true)
                        if combatRemote then
                            combatRemote:FireServer("Weapon", tool.Name)
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
    if _0x5.Character then _fly(_0x5.Character, false) end
end

-- 5. CONEXÕES
EspBtn.MouseButton1Click:Connect(function()
    _0x7 = not _0x7
    EspBtn.Text = _0x7 and "ESP: ON" or "ESP: OFF"
    EspBtn.BackgroundColor3 = _0x7 and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

FarmBtn.MouseButton1Click:Connect(function()
    _0x8 = not _0x8
    FarmBtn.Text = _0x8 and "AUTO FARM: ON" or "AUTO FARM: OFF"
    FarmBtn.BackgroundColor3 = _0x8 and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(80, 80, 80)
    if _0x8 then task.spawn(_farmLoop) end
end)

ClickBtn.MouseButton1Click:Connect(function()
    _0x9 = not _0x9
    ClickBtn.Text = _0x9 and "AUTO CLICK: ON" or "AUTO CLICK: OFF"
    ClickBtn.BackgroundColor3 = _0x9 and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 80)
end)

CloseBtn.MouseButton1Click:Connect(function()
    _0x8 = false _0x7 = false _0x9 = false
    if _0x5.Character then _fly(_0x5.Character, false) end
    ScreenGui:Destroy()
end)

-- 6. HEARTBEAT LOOP
_0x3.Heartbeat:Connect(function() 
    if _0x7 then 
        for _, v in ipairs(_0x1:GetPlayers()) do
            if v ~= _0x5 and v.Character and not v.Character:FindFirstChild("ESPAura") then
                local a = Instance.new("Highlight", v.Character)
                a.Name = "ESPAura"
                a.FillColor = Color3.new(1,0,0)
                a.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end
        end
    end 
end)
