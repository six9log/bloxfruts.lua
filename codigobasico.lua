--[[ 
  ENVIRONMENT_OFS_TEST_2025 - CORREÇÃO DE FARM PROGRESSIVO
  Ajustes: Fly (não cair), Auto-Quest e Attack Fix
]]

local _0x1 = game:GetService("Players")
local _0x2 = game:GetService("TweenService")
local _0x3 = game:GetService("RunService")
local _0x4 = game:GetService("ReplicatedStorage")
local _0x5 = _0x1.LocalPlayer
local _0x6 = _0x5:WaitForChild("PlayerGui")

local _0x7 = false
local _0x8 = false

-- TABELA DE QUESTS (AJUSTADA)
local _0x9 = {
    {L = 0, N = "Bandit Quest Giver", Q = "BanditQuest", E = "Bandit", ID = 1},
    {L = 10, N = "Monkey Quest Giver", Q = "MonkeyQuest", E = "Monkey", ID = 1}
}

-- 1. INTERFACE (MANTIDA)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BF_SECURE_TEST"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = _0x6

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 200, 0, 220)
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
EspBtn.Size = UDim2.new(0.9, 0, 0, 40)
EspBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
EspBtn.Text = "ESP: OFF"
EspBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
EspBtn.Parent = Main

local FarmBtn = Instance.new("TextButton")
FarmBtn.Size = UDim2.new(0.9, 0, 0, 40)
FarmBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
FarmBtn.Text = "AUTO FARM: OFF"
FarmBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
FarmBtn.Parent = Main

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.9, 0, 0, 40)
CloseBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
CloseBtn.Text = "FECHAR TOTALMENTE"
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = Main

-- 2. FUNÇÃO DE ESTABILIZAÇÃO (IMPEDIR QUEDA)
local function _fly(char, state)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bv = hrp:FindFirstChild("FarmVelocity")
    if state then
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Name = "FarmVelocity"
            bv.Velocity = Vector3.new(0,0,0)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = hrp
        end
    else
        if bv then bv:Destroy() end
    end
end

-- 3. LÓGICA DE FARM CORRIGIDA
local function _0xB()
    while _0x8 do
        local l = _0x5.Data.Level.Value
        local d = _0x9[1]
        for _, v in ipairs(_0x9) do if l >= v.L then d = v end end
        
        local c = _0x5.Character
        if c and c:FindFirstChild("HumanoidRootPart") then
            _fly(c, true) -- Ativa anti-queda

            -- VERIFICA SE ESTÁ COM QUEST
            local temQuest = _0x5.PlayerGui.Main:FindFirstChild("Quest")
            
            if not temQuest then
                -- VAI AO NPC E PEGA QUEST
                local npc = workspace.NPCs:FindFirstChild(d.N)
                if npc then
                    c.HumanoidRootPart.CFrame = npc.WorldPivot * CFrame.new(0, 0, 2)
                    -- INVOKE DO BLOX FRUITS PARA QUEST (PONTO DE TESTE PARA SEU AC)
                    _0x4.Remotes.CommF_:InvokeServer("StartQuest", d.Q, d.ID)
                end
            else
                -- VAI AO MOB E BATE
                local mob = nil
                for _, e in ipairs(workspace.Enemies:GetChildren()) do
                    if e.Name == d.E and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                        mob = e break
                    end
                end

                if mob then
                    -- Fica 10 studs acima (Distância segura)
                    c.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                    
                    -- AUTO CLICK (REVISADO)
                    local tool = c:FindFirstChildOfClass("Tool") or _0x5.Backpack:FindFirstChildOfClass("Tool")
                    if tool then 
                        if tool.Parent ~= c then tool.Parent = c end
                        tool:Activate() 
                        -- Dispara o remote de dano do jogo (Ajuste o nome conforme seu teste)
                        _0x4.Remotes.Validator:FireServer(math.random(1,100)) 
                    end
                end
            end
        end
        task.wait(0.1)
    end
    if _0x5.Character then _fly(_0x5.Character, false) end
end

-- 4. CONEXÕES (IGUAIS)
EspBtn.MouseButton1Click:Connect(function()
    _0x7 = not _0x7
    EspBtn.Text = _0x7 and "ESP: ON" or "ESP: OFF"
    EspBtn.BackgroundColor3 = _0x7 and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

FarmBtn.MouseButton1Click:Connect(function()
    _0x8 = not _0x8
    FarmBtn.Text = _0x8 and "AUTO FARM: ON" or "AUTO FARM: OFF"
    FarmBtn.BackgroundColor3 = _0x8 and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(80, 80, 80)
    if _0x8 then task.spawn(_0xB) end
end)

CloseBtn.MouseButton1Click:Connect(function()
    _0x8 = false _0x7 = false
    ScreenGui:Destroy()
end)

_0x3.Heartbeat:Connect(function() 
    if _0x7 then 
        for _, v in ipairs(_0x1:GetPlayers()) do
            if v ~= _0x5 and v.Character and not v.Character:FindFirstChild("ESPAura") then
                local a = Instance.new("Highlight")
                a.Name = "ESPAura"
                a.FillColor = Color3.new(1,0,0)
                a.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                a.Parent = v.Character
            end
        end
    end 
end)
