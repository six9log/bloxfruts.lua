-- LocalScript (coloque em StarterGui ou StarterPlayerScripts no Roblox Studio)
-- Propósito: exemplo educativo para simular ganho de XP e level-up localmente.
-- NÃO usar em jogos online para automatizar jogabilidade real.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Estado local (apenas no cliente, para testes)
local level = 1
local xp = 0
local xpToNext = function(l) return 100 + (l - 1) * 50 end -- fórmula simples

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XPTrainerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Simulador de XP (modelo educativo)"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

local levelLabel = Instance.new("TextLabel")
levelLabel.Size = UDim2.new(0.5, -15, 0, 30)
levelLabel.Position = UDim2.new(0, 10, 0, 46)
levelLabel.BackgroundTransparency = 1
levelLabel.TextColor3 = Color3.fromRGB(200,200,200)
levelLabel.Font = Enum.Font.SourceSans
levelLabel.Text = "Nível: "..tostring(level)
levelLabel.TextScaled = true
levelLabel.Parent = frame

local xpLabel = Instance.new("TextLabel")
xpLabel.Size = UDim2.new(0.5, -15, 0, 30)
xpLabel.Position = UDim2.new(0.5, 5, 0, 46)
xpLabel.BackgroundTransparency = 1
xpLabel.TextColor3 = Color3.fromRGB(200,200,200)
xpLabel.Font = Enum.Font.SourceSans
xpLabel.Text = "XP: "..tostring(xp).."/"..tostring(xpToNext(level))
xpLabel.TextScaled = true
xpLabel.Parent = frame

local gainButton = Instance.new("TextButton")
gainButton.Size = UDim2.new(1, -20, 0, 36)
gainButton.Position = UDim2.new(0, 10, 0, 86)
gainButton.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
gainButton.TextColor3 = Color3.fromRGB(255,255,255)
gainButton.Font = Enum.Font.SourceSansBold
gainButton.Text = "Ganhar 30 XP (simulado)"
gainButton.Parent = frame

local autoToggle = Instance.new("TextButton")
autoToggle.Size = UDim2.new(1, -20, 0, 28)
autoToggle.Position = UDim2.new(0, 10, 0, 128)
autoToggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
autoToggle.TextColor3 = Color3.fromRGB(255,255,255)
autoToggle.Font = Enum.Font.SourceSans
autoToggle.Text = "Auto-treino: DESLIGADO"
autoToggle.Parent = frame

local autoEnabled = false
local autoXPPerTick = 10
local autoInterval = 1 -- segundos
local accumulated = 0

local function updateLabels()
	xpLabel.Text = "XP: "..tostring(math.floor(xp)).."/"..tostring(xpToNext(level))
	levelLabel.Text = "Nível: "..tostring(level)
end

local function tryLevelUp()
	while xp >= xpToNext(level) do
		xp = xp - xpToNext(level)
		level = level + 1
		-- feedback local (pode adicionar efeitos visuais)
		print("Level up! Novo nível:", level)
	end
	updateLabels()
end

gainButton.MouseButton1Click:Connect(function()
	xp = xp + 30
	tryLevelUp()
end)

autoToggle.MouseButton1Click:Connect(function()
	autoEnabled = not autoEnabled
	autoToggle.Text = "Auto-treino: "..(autoEnabled and "LIGADO" or "DESLIGADO")
	autoToggle.BackgroundColor3 = autoEnabled and Color3.fromRGB(40,150,70) or Color3.fromRGB(60,60,60)
end)

-- Loop local para auto-treino (apenas no cliente)
local last = tick()
RunService.Heartbeat:Connect(function(dt)
	if autoEnabled then
		accumulated = accumulated + dt
		if accumulated >= autoInterval then
			local times = math.floor(accumulated / autoInterval)
			accumulated = accumulated - times * autoInterval
			xp = xp + (autoXPPerTick * times)
			tryLevelUp()
		end
	end
end)

-- Inicializa labels
updateLabels()
