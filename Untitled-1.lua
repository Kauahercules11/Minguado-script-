local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TopRightImageGui"
screenGui.Parent = playerGui

local imageLabelzin = Instance.new("ImageLabel")
imageLabelzin.Name = "TopRightImage"
imageLabelzin.Size = UDim2.new(0, 100, 0, 100) -- Adjust size as needed
imageLabelzin.Position = UDim2.new(1, 0, 0, 10) -- Position in the top-right corner
imageLabelzin.AnchorPoint = Vector2.new(1, 0)
imageLabelzin.Image = "rbxassetid://101508399268505"
imageLabelzin.BackgroundTransparency = 1
imageLabelzin.Parent = screenGui

-- Configurações
local musicIds = {
	"rbxassetid://139180290547887", -- Música 1
	"rbxassetid://135044782381777", -- Musica 2
	"rbxassetid://109711802939963", -- Música 3
	"rbxassetid://96816544737438",-- Musica 4
	"rbxassetid://88031675362294" -- Musica 5
}
local currentMusicIndex = 4
local currentSound = nil
local musicVolume = 0.5
local buuhCount = 0
local isMinimized = false
local animationSpeed = 1
local isExplaining = false
local loopExplanation = false
local playTimeStart = os.time()

-- Elementos da GUI
local screenGui, mainFrame = nil, nil
local welcomeMessage = nil
local messageFrame = nil

-- FUNÇÃO PARA FORMATAR TEMPO --
local function formatTime(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- FUNÇÃO PARA ATUALIZAR TEMPO DE JOGO --
local function updatePlayTime()
	if not mainFrame then return end
	for _, child in ipairs(mainFrame:GetChildren()) do
		if child.Name == "PlayTimeCounter" then
			local elapsed = os.time() - playTimeStart
			child.Text = "Tempo de jogo: "..formatTime(elapsed)
			break
		end
	end
end

-- FUNÇÃO PARA REMOVER TODAS AS MÚSICAS (EXCETO A ATUAL) --
local function removeAllOtherMusic()
	if not currentSound then return 0 end

	local soundsRemoved = 0
	for _, sound in ipairs(workspace:GetDescendants()) do
		if sound:IsA("Sound") and sound ~= currentSound then
			sound:Destroy()
			soundsRemoved = soundsRemoved + 1
		end
	end

	return soundsRemoved
end

-- FUNÇÃO PARA CONFIGURAR MÚSICA --
local function setupMusic()
	if not player.Character then player.CharacterAdded:Wait() end
	local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")

	if currentSound then 
		currentSound:Destroy()
		currentSound = nil
	end

	currentSound = Instance.new("Sound")
	currentSound.Name = "BackgroundMusic"
	currentSound.Looped = true
	currentSound.Volume = musicVolume
	currentSound.SoundId = musicIds[currentMusicIndex]
	currentSound.Parent = humanoidRootPart
	currentSound:Play()
end

-- FUNÇÃO PARA ATUALIZAR CONTADOR DE BUUH --
local function updateBuuhCounter()
	if not mainFrame then return end
	for _, child in ipairs(mainFrame:GetChildren()) do
		if child.Name == "BuuhCounter" then
			child.Text = "Buuhs: "..buuhCount
			break
		end
	end
end

-- FUNÇÃO PARA ANIMAÇÃO --
local function startExplanation()
	if isExplaining then return end
	isExplaining = true

	local character = player.Character
	if not character then 
		isExplaining = false
		return 
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not rootPart then 
		isExplaining = false
		return 
	end

	local pointingAnim = Instance.new("Animation")
	pointingAnim.AnimationId = "rbxassetid://148840371"
	local pointingTrack = humanoid:LoadAnimation(pointingAnim)

	while loopExplanation and isExplaining do
		pointingTrack:Play()
		pointingTrack:AdjustSpeed(animationSpeed * 1.5)

		local startTime = os.clock()
		local duration = 1 / animationSpeed

		while (os.clock() - startTime < duration) and loopExplanation do
			if not rootPart then break end
			rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, math.rad((os.clock()-startTime)/duration*720), 0)
			task.wait()
		end

		if humanoid and loopExplanation then
			humanoid.Jump = true
			task.wait(0.2 / animationSpeed)
			if humanoid and loopExplanation then 
				humanoid.Jump = true 
			end
		end

		pointingTrack:Stop()
	end

	pointingTrack:Stop()
	isExplaining = false
end

-- FUNÇÃO PARA MENSAGEM INICIAL --
local function createWelcomeMessage()
	if welcomeMessage and welcomeMessage.Parent then return end

	welcomeMessage = Instance.new("TextLabel")
	welcomeMessage.Name = "WelcomeMessage"
	welcomeMessage.Size = UDim2.new(1, 0, 1, 0)
	welcomeMessage.Position = UDim2.new(0, 0, 0, 0)
	welcomeMessage.Text = "Muito obrigado mesmo de coração por usar o script do minguado😍❤️"
	welcomeMessage.TextColor3 = Color3.new(1, 1, 1)
	welcomeMessage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	welcomeMessage.BackgroundTransparency = 0.3
	welcomeMessage.TextSize = 24
	welcomeMessage.ZIndex = 10
	welcomeMessage.Parent = screenGui

	welcomeMessage.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			for i = 0.3, 1, 0.05 do
				welcomeMessage.BackgroundTransparency = i
				welcomeMessage.TextTransparency = i
				task.wait(0.05)
			end
			welcomeMessage:Destroy()
		end
	end)
end

-- FUNÇÃO PARA MENSAGEM ESPECIAL --
local function showSpecialMessage()
	if messageFrame and messageFrame.Parent then 
		messageFrame:Destroy()
	end

	messageFrame = Instance.new("Frame")
	messageFrame.Size = UDim2.new(0, 300, 0, 200)
	messageFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
	messageFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	messageFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	messageFrame.BorderSizePixel = 0
	messageFrame.Parent = screenGui

	local messageText = Instance.new("TextLabel")
	messageText.Size = UDim2.new(0.9, 0, 0.7, 0)
	messageText.Position = UDim2.new(0.05, 0, 0.05, 0)
	messageText.Text = "❤️❤️Eu agradeço muito mesmo por você utilizar o script, e além disto o Minguado fez parte das nossas infâncias, este script não foi feito para humilhar o minguado por animações aleatórias, mas sim para mostrar o nosso amor por ele❤️👑 e o script pode ser atualizado 1 vez por mês(TALVEZ) então se inscreva-se no canal amigão! tamo junto por você estar aqui❤️❤️"
	messageText.TextColor3 = Color3.new(1, 1, 1)
	messageText.BackgroundTransparency = 1
	messageText.TextWrapped = true
	messageText.TextSize = 14
	messageText.Parent = messageFrame

	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0.4, 0, 0.15, 0)
	closeButton.Position = UDim2.new(0.3, 0, 0.8, 0)
	closeButton.Text = "Sim..."
	closeButton.TextColor3 = Color3.new(1, 1, 1)
	closeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	closeButton.Parent = messageFrame

	closeButton.MouseButton1Click:Connect(function()
		messageFrame:Destroy()
	end)

	local draggingMsg = false
	local dragStartMsg, frameStartMsg = nil, nil

	messageFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingMsg = true
			dragStartMsg = input.Position
			frameStartMsg = messageFrame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if draggingMsg and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStartMsg
			messageFrame.Position = UDim2.new(
				frameStartMsg.X.Scale, frameStartMsg.X.Offset + delta.X,
				frameStartMsg.Y.Scale, frameStartMsg.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingMsg = false
		end
	end)
end

-- FUNÇÃO PRINCIPAL DA GUI --
local function createGUI()
	if screenGui and screenGui.Parent then 
		screenGui:Destroy()
	end

	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MusicControls"
	screenGui.Parent = player.PlayerGui

	-- FRAME PRINCIPAL
	mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 250, 0, 420)
	mainFrame.Position = UDim2.new(0.5, -125, 0.7, 0)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
	mainFrame.BackgroundTransparency = 0.3
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui

	-- CABEÇALHO
	local headerContainer = Instance.new("Frame")
	headerContainer.Name = "HeaderContainer"
	headerContainer.Size = UDim2.new(1, -10, 0, 30)
	headerContainer.Position = UDim2.new(0, 5, 0, 5)
	headerContainer.BackgroundTransparency = 1
	headerContainer.Parent = mainFrame

	local minguadoImage = Instance.new("ImageLabel")
	minguadoImage.Name = "MinguadoImage"
	minguadoImage.Size = UDim2.new(0, 30, 0, 30)
	minguadoImage.Position = UDim2.new(0, 0, 0.5, -15)
	minguadoImage.Image = "rbxassetid://137148443564940"
	minguadoImage.BackgroundTransparency = 1
	minguadoImage.Parent = headerContainer

	local rgbText = Instance.new("TextLabel")
	rgbText.Name = "RGBText"
	rgbText.Size = UDim2.new(0, 120, 0, 30)
	rgbText.Position = UDim2.new(0, 35, 0.5, -15)
	rgbText.Text = "Minguado script👑"
	rgbText.TextColor3 = Color3.new(1, 1, 1)
	rgbText.BackgroundTransparency = 1
	rgbText.TextSize = 14
	rgbText.Font = Enum.Font.GothamBold
	rgbText.TextXAlignment = Enum.TextXAlignment.Left
	rgbText.Parent = headerContainer

	spawn(function()
		local hue = 0
		while true do
			hue = (hue + 0.01) % 1
			rgbText.TextColor3 = Color3.fromHSV(hue, 1, 1)
			task.wait(0.05)
		end
	end)

	local minimizeButton = Instance.new("TextButton")
	minimizeButton.Name = "MinimizeButton"
	minimizeButton.Size = UDim2.new(0, 60, 0, 25)
	minimizeButton.Position = UDim2.new(1, -60, 0.5, -12.5)
	minimizeButton.Text = "↓"
	minimizeButton.TextColor3 = Color3.new(1, 1, 1)
	minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	minimizeButton.BorderSizePixel = 0
	minimizeButton.Parent = headerContainer

	minimizeButton.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		minimizeButton.Text = isMinimized and "↗" or "↓"

		for _, child in ipairs(mainFrame:GetChildren()) do
			if child ~= headerContainer then
				child.Visible = not isMinimized
			end
		end

		mainFrame.Size = isMinimized and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 420)
	end)

	local buttons = {
		{Text = "🔊", Y = 0.1, Func = function()
			if currentSound then
				currentSound.Playing = not currentSound.Playing
				for _, child in ipairs(mainFrame:GetChildren()) do
					if child:IsA("TextButton") and (child.Text == "🔊" or child.Text == "🔇") then
						child.Text = currentSound.Playing and "🔊" or "🔇"
					end
				end
			end
		end, Desc = "Mutar/Desmutar música"},

		{Text = "▶️ Próxima", Y = 0.18, Func = function()
			currentMusicIndex = currentMusicIndex % #musicIds + 1
			setupMusic()
		end, Desc = "Trocar música"},

		{Text = "👋 Animação", Y = 0.26, Func = startExplanation, Desc = "Iniciar animação"},

		{Text = "🔁 Loop", Y = 0.34, Func = function()
			loopExplanation = not loopExplanation
			for _, child in ipairs(mainFrame:GetChildren()) do
				if child:IsA("TextButton") and child.Text:find("🔁") then
					child.Text = loopExplanation and "🔁 Parar Loop" or "🔁 Loop"
					child.BackgroundColor3 = loopExplanation and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(60, 60, 60)
				end
			end
			if loopExplanation and not isExplaining then 
				startExplanation() 
			end
		end, Desc = "Ativar/desativar loop"},

		{Text = "👻 Falar Buuh", Y = 0.42, Func = function()
			buuhCount = buuhCount + 1
			updateBuuhCounter()
			local buuhEvent = Instance.new("RemoteEvent")
			buuhEvent.Name = "BuuhEvent_"..tostring(math.random(1, 10000))
			buuhEvent.Parent = ReplicatedStorage
			buuhEvent:FireServer("Buuh!")
			task.delay(1, function() buuhEvent:Destroy() end)
		end, Desc = "Falar Buuh (+1 contador)"},

		{Text = "X2 Buuh", Y = 0.5, Func = function()
			buuhCount = buuhCount >= 15 and buuhCount * 2 or buuhCount + 15
			updateBuuhCounter()
		end, Desc = "Multiplicar Buuhs (min. 15)"},

		{Text = "❌ Limpar Músicas", Y = 0.58, Func = function()
			local removed = removeAllOtherMusic()
			local notification = Instance.new("TextLabel")
			notification.Size = UDim2.new(0.9, 0, 0.08, 0)
			notification.Position = UDim2.new(0.05, 0, 0.9, 0)
			notification.Text = "Removidas "..removed.." músicas!"
			notification.TextColor3 = Color3.new(1, 1, 1)
			notification.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			notification.Parent = mainFrame
			task.delay(3, function() notification:Destroy() end)
		end, Desc = "Remove todas as músicas do jogo (exceto a atual)"},

		{Text = "Mensagem(LEIA)", Y = 0.66, Func = showSpecialMessage, Desc = "Mostrar mensagem especial"}
	}

	for _, btn in ipairs(buttons) do
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0.9, 0, 0.08, 0)
		button.Position = UDim2.new(0.05, 0, btn.Y, 0)
		button.Text = btn.Text
		button.TextColor3 = Color3.new(1, 1, 1)
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		button.BorderSizePixel = 0
		button.Parent = mainFrame
		button.MouseButton1Click:Connect(btn.Func)

		local tooltip = Instance.new("TextLabel")
		tooltip.Size = UDim2.new(1, 0, 0, 16)
		tooltip.Position = UDim2.new(0, 0, 0, -16)
		tooltip.Text = btn.Desc
		tooltip.TextColor3 = Color3.new(1, 1, 1)
		tooltip.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		tooltip.Visible = false
		tooltip.Parent = button

		button.MouseEnter:Connect(function() tooltip.Visible = true end)
		button.MouseLeave:Connect(function() tooltip.Visible = false end)
	end

	local buuhCounter = Instance.new("TextLabel")
	buuhCounter.Name = "BuuhCounter"
	buuhCounter.Size = UDim2.new(0.9, 0, 0.05, 0)
	buuhCounter.Position = UDim2.new(0.05, 0, 0.74, 0)
	buuhCounter.Text = "Buuhs: 0"
	buuhCounter.TextColor3 = Color3.new(1, 1, 1)
	buuhCounter.BackgroundTransparency = 1
	buuhCounter.TextYAlignment = Enum.TextYAlignment.Top
	buuhCounter.Parent = mainFrame

	local playTimeCounter = Instance.new("TextLabel")
	playTimeCounter.Name = "PlayTimeCounter"
	playTimeCounter.Size = UDim2.new(0.9, 0, 0.05, 0)
	playTimeCounter.Position = UDim2.new(0.05, 0, 0.79, 0)
	playTimeCounter.Text = "Tempo de jogo: 00:00:00"
	playTimeCounter.TextColor3 = Color3.new(1, 1, 1)
	playTimeCounter.BackgroundTransparency = 1
	playTimeCounter.TextYAlignment = Enum.TextYAlignment.Top
	playTimeCounter.Parent = mainFrame

	local speedControl = Instance.new("Frame")
	speedControl.Size = UDim2.new(0.9, 0, 0.1, 0)
	speedControl.Position = UDim2.new(0.05, 0, 0.84, 0)
	speedControl.BackgroundTransparency = 1
	speedControl.Parent = mainFrame

	local speedLabel = Instance.new("TextLabel")
	speedLabel.Size = UDim2.new(0.4, 0, 1, 0)
	speedLabel.Text = "Velocidade:"
	speedLabel.TextColor3 = Color3.new(1, 1, 1)
	speedLabel.BackgroundTransparency = 1
	speedLabel.TextXAlignment = Enum.TextXAlignment.Left
	speedLabel.Parent = speedControl
	speedLabel.Position = UDim2.new(0.05, 0, -0.30, 0)

	local speedBox = Instance.new("TextBox")
	speedBox.Size = UDim2.new(0.3, 0, 0.5, 0)
	speedBox.Position = UDim2.new(0.4, 0, 0, 0)
	speedBox.PlaceholderText = "1-10"
	speedBox.Text = tostring(animationSpeed)
	speedBox.TextColor3 = Color3.new(0, 0, 0)
	speedBox.BackgroundColor3 = Color3.new(1, 1, 1)
	speedBox.Parent = speedControl

	local speedButton = Instance.new("TextButton")
	speedButton.Size = UDim2.new(0.3, 0, 0.5, 0)
	speedButton.Position = UDim2.new(0.72, 0, 0, 0)
	speedButton.Text = "Aplicar"
	speedButton.TextColor3 = Color3.new(1, 1, 1)
	speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	speedButton.Parent = speedControl

	speedButton.MouseButton1Click:Connect(function()
		local newSpeed = tonumber(speedBox.Text)
		if newSpeed and newSpeed > 0 and newSpeed <= 10 then
			animationSpeed = newSpeed
			speedBox.Text = tostring(animationSpeed)
		else
			speedBox.Text = "Inválido!"
			task.wait(0.7)
			speedBox.Text = tostring(animationSpeed)
		end
	end)

	local volumeControl = Instance.new("Frame")
	volumeControl.Size = UDim2.new(0.9, 0, 0.1, 0)
	volumeControl.Position = UDim2.new(0.05, 0, 0.94, 0)
	volumeControl.BackgroundTransparency = 1
	volumeControl.Parent = mainFrame

	local volumeLabel = Instance.new("TextLabel")
	volumeLabel.Size = UDim2.new(0.4, 0, 1, 0)
	volumeLabel.Text = "Volume (0-10):"
	volumeLabel.TextColor3 = Color3.new(1, 1, 1)
	volumeLabel.BackgroundTransparency = 1
	volumeLabel.TextXAlignment = Enum.TextXAlignment.Left
	volumeLabel.Parent = volumeControl
	volumeLabel.Position = UDim2.new(0.05, 0, -0.50, 0)

	local volumeBox = Instance.new("TextBox")
	volumeBox.Size = UDim2.new(0.3, 0, 0.5, 0)
	volumeBox.Position = UDim2.new(0.4, 0, -0.30, 0)
	volumeBox.PlaceholderText = "0.0-10.9"
	volumeBox.Text = tostring(musicVolume)
	volumeBox.TextColor3 = Color3.new(0, 0, 0)
	volumeBox.BackgroundColor3 = Color3.new(1, 1, 1)
	volumeBox.Parent = volumeControl

	local volumeButton = Instance.new("TextButton")
	volumeButton.Size = UDim2.new(0.3, 0, 0.5, 0)
	volumeButton.Position = UDim2.new(0.72, 0, -0.30, 0)
	volumeButton.Text = "Aplicar"
	volumeButton.TextColor3 = Color3.new(1, 1, 1)
	volumeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	volumeButton.Parent = volumeControl

	volumeButton.MouseButton1Click:Connect(function()
		local newVolume = tonumber(volumeBox.Text)
		if newVolume and newVolume >= 0 and newVolume <= 10 then
			musicVolume = newVolume
			if currentSound then
				currentSound.Volume = musicVolume
			end
			volumeBox.Text = tostring(musicVolume)
		else
			volumeBox.Text = "Inválido!"
			task.wait(0.7)
			volumeBox.Text = tostring(musicVolume)
		end
	end)

	local dragging = false
	local dragStart, frameStart = nil, nil

	headerContainer.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			frameStart = mainFrame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(
				frameStart.X.Scale, frameStart.X.Offset + delta.X,
				frameStart.Y.Scale, frameStart.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	spawn(function()
		while true do
			updateBuuhCounter()
			updatePlayTime()
			task.wait(1)
		end
	end)

	createWelcomeMessage()
end

-- INICIALIZAÇÃO
player.CharacterAdded:Connect(function()
	setupMusic()
	createGUI()
end)

if player.Character then
	setupMusic()
	createGUI()
end
