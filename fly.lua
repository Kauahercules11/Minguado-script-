-- LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variáveis do Fly
local flying = false
local flySpeed = 50
local flyConnection

-- Tecla padrão
local flyKey = Enum.KeyCode.F

-- Função de voar
local function toggleFly()
	flying = not flying

	if flying then
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Name = "FlyVelocity"
		bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.Parent = humanoidRootPart

		flyConnection = RunService.RenderStepped:Connect(function()
			local moveDirection = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				moveDirection = moveDirection + Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				moveDirection = moveDirection + Vector3.new(0, -1, 0)
			end

			if moveDirection.Magnitude > 0 then
				moveDirection = moveDirection.Unit
			end

			bodyVelocity.Velocity = moveDirection * flySpeed
		end)
	else
		if humanoidRootPart:FindFirstChild("FlyVelocity") then
			humanoidRootPart.FlyVelocity:Destroy()
		end
		if flyConnection then
			flyConnection:Disconnect()
		end
	end
end

-- Detecta tecla para voar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == flyKey then
		toggleFly()
	end
end)

-- Criar GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FlyConfigGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.05, 0, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = gui

local textbox = Instance.new("TextBox")
textbox.Size = UDim2.new(1, -20, 0, 40)
textbox.Position = UDim2.new(0, 10, 0, 30)
textbox.Text = "F"
textbox.TextScaled = true
textbox.ClearTextOnFocus = false
textbox.Parent = frame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0, 20)
label.Position = UDim2.new(0, 0, 0, 5)
label.Text = "Tecla para Fly:"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.BackgroundTransparency = 1
label.TextScaled = true
label.Parent = frame

-- Alterar tecla pelo textbox
textbox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local text = textbox.Text:upper()
		if Enum.KeyCode[text] then
			flyKey = Enum.KeyCode[text]
		else
			textbox.Text = flyKey.Name -- volta para a tecla válida
		end
	end
end)

-- Sistema de arrastar GUI
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
