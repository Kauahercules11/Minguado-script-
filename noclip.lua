-- LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoclipGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 90)
frame.Position = UDim2.new(0.4, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Botão toggle
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -10, 0, 40)
button.Position = UDim2.new(0, 5, 0, 5)
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "Noclip: OFF"
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Parent = frame

-- TextBox para alterar tecla
local textbox = Instance.new("TextBox")
textbox.Size = UDim2.new(1, -10, 0, 30)
textbox.Position = UDim2.new(0, 5, 0, 50)
textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.PlaceholderText = "Digite a tecla (ex: F)"
textbox.Text = "F"
textbox.Font = Enum.Font.SourceSans
textbox.TextSize = 18
textbox.ClearTextOnFocus = false
textbox.Parent = frame

-- Variáveis
local noclip = false
local toggleKey = Enum.KeyCode.F -- tecla padrão

-- Atualizar tecla ao escrever no TextBox
textbox.FocusLost:Connect(function(enterPressed)
	if textbox.Text ~= "" then
		local input = string.upper(textbox.Text) -- coloca em maiúsculo
		if Enum.KeyCode[input] then
			toggleKey = Enum.KeyCode[input]
		else
			textbox.Text = "Tecla inválida"
			wait(1)
			textbox.Text = "F"
			toggleKey = Enum.KeyCode.F
		end
	end
end)

-- Função do toggle
local function toggleNoclip()
	noclip = not noclip
	if noclip then
		button.Text = "Noclip: ON"
		button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		button.Text = "Noclip: OFF"
		button.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	end
end

-- Clique no botão
button.MouseButton1Click:Connect(toggleNoclip)

-- Atalho do teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == toggleKey then
		toggleNoclip()
	end
end)

-- Loop do noclip
RunService.Stepped:Connect(function()
	if noclip and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	else
		if player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end)

-- Garantir que funcione após respawn
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
end)
