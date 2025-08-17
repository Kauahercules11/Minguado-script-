-- LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MorphGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 100)
frame.Position = UDim2.new(0.5, -150, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true -- necessário para arrastar
frame.Draggable = false -- vamos criar drag manual (mais preciso)
frame.Parent = screenGui

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.8, 0, 0.5, 0)
textBox.Position = UDim2.new(0.1, 0, 0.1, 0)
textBox.PlaceholderText = "Digite o nome do jogador"
textBox.Text = ""
textBox.TextScaled = true
textBox.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.5, 0, 0.3, 0)
button.Position = UDim2.new(0.25, 0, 0.65, 0)
button.Text = "Transformar"
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.TextScaled = true
button.Parent = frame

-- Função de Morph
local function morphInto(targetName)
	local targetPlayer = Players:FindFirstChild(targetName)
	if targetPlayer and targetPlayer.Character then
		local targetChar = targetPlayer.Character
		local newChar = targetChar:Clone()

		-- Aplicar no player local
		local currentChar = player.Character or player.CharacterAdded:Wait()
		local humRoot = currentChar:FindFirstChild("HumanoidRootPart")

		-- Posição para spawnar o novo corpo
		local pos = humRoot and humRoot.CFrame

		player.Character = newChar
		newChar.Parent = workspace
		newChar:MoveTo(pos and pos.Position or Vector3.new(0,5,0))

		-- Garantir controle
		local hum = newChar:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:BuildRigFromAttachments()
		end
	end
end

-- Evento do botão
button.MouseButton1Click:Connect(function()
	local targetName = textBox.Text
	if targetName ~= "" then
		morphInto(targetName)
	end
end)

-- ==========================
-- SISTEMA DE DRAG DO FRAME
-- ==========================
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
