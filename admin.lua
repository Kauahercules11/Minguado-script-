-- LocalScript (Coloque em StarterPlayerScripts)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Nome da GUI
local GUI_NAME = "ComandoGUI"

-- Se já existir uma GUI igual, não cria outra
local existente = PlayerGui:FindFirstChild(GUI_NAME)
if existente then
    script:Destroy()
    return
end

-- Tabela de comandos
local comandos = {
    {Name = "troll", Script = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Kauahercules11/Minguado-script-/refs/heads/main/TrollGui"))()
    end},
    {Name = "kater", Script = function()
        loadstring(game:HttpGet("https://katerhub-inc.github.io/KaterHub/main.lua"))()
    end},
	 {Name = "egor", Script = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Kauahercules11/Minguado-script-/refs/heads/main/EgorScript.lua"))()
	 end},
	 {Name = "inf", Script = function()
	 loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	 end},
	 {Name = "auto walk", Script = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/geoduude/roblox/refs/heads/master/rooms-autowalk"))()
	 end},
{Name = "unv", Script = function()
	 loadstring(game:HttpGet("https://raw.githubusercontent.com/sinret/rbxscript.com-scripts-reuploads-/main/UNVIew", true))()
	 end},
	 {Name = "c00lgui", Script = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/MiRw3b/c00lgui-v3rx/main/c00lguiv3rx.lua"))()
	 end},
	 {Name = "kitty", Script = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/CatEnddroid/Kitty-Cats-Doors-Beta/refs/heads/main/hub.lua"))()
	 end},
	 {Name = "rdr", Script = function()
loadstring(game:HttpGet("\104\116\116\112\115\58\47\47\114\97\119\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\67\104\105\110\97\81\89\47\83\99\114\105\112\116\115\47\77\97\105\110\47\83\99\114\105\112\116"))()
	 end},
	 {Name = "job", Script = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Kauahercules11/Minguado-script-/refs/heads/main/Jobid.txt"))()
	 end},
	 {Name = "dex", Script = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
	 end},
	 {Name = "doors", Script = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/KINGHUB01/BlackKing-obf/main/Doors%20Blackking%20And%20BobHub"))()
	 end},
	{Name = "ink", Script = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/inkgame.lua", true))()
		end},
{Name = "char", Script = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Kauahercules11/Minguado-script-/refs/heads/main/char.lua"))()
		end},
}

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.Active = true -- necessário para arrastar
frame.Draggable = true -- deixa arrastar
frame.Parent = screenGui

-- Caixa de texto para comandos
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0, 200, 0, 30)
textBox.Position = UDim2.new(0.5, -100, 0.2, 0)
textBox.PlaceholderText = "Digite um comando"
textBox.Text = ""
textBox.ClearTextOnFocus = false
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
textBox.Parent = frame

-- Botão Executar
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 30)
button.Position = UDim2.new(0.5, -50, 0.45, 0)
button.Text = "Executar"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.Parent = frame

-- Caixa de texto para escolher atalho
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0, 100, 0, 30)
keyBox.Position = UDim2.new(0.5, -50, 0.75, 0)
keyBox.PlaceholderText = "Tecla (padrão R)"
keyBox.Text = "R"
keyBox.ClearTextOnFocus = false
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyBox.Parent = frame

-- Atalho padrão
local toggleKey = Enum.KeyCode.R

-- Função para atualizar atalho
local function atualizarAtalho()
    local tecla = keyBox.Text:upper()
    if Enum.KeyCode[tecla] then
        toggleKey = Enum.KeyCode[tecla]
        print("Novo atalho definido para:", tecla)
    else
        warn("Tecla inválida:", tecla)
    end
end

keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        atualizarAtalho()
    end
end)

-- Função para executar comando
local function executarComando()
    local input = textBox.Text
    for _, cmd in pairs(comandos) do
        if input:lower() == cmd.Name:lower() then
            local success, err = pcall(cmd.Script)
            if not success then
                warn("Erro ao executar comando:", err)
            end
            return
        end
    end
    warn("Comando não encontrado:", input)
end

-- Conectar execução
button.MouseButton1Click:Connect(executarComando)
textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        executarComando()
    end
end)

-- Alternar visibilidade com a tecla
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == toggleKey then
        frame.Visible = not frame.Visible
    end
end)
