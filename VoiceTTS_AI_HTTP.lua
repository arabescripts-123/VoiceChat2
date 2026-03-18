-- Voice TTS + AI Chat (HTTP Version)
print("[VoiceTTS] Iniciando...")

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Habilita HttpService
local success, err = pcall(function()
    HttpService.HttpEnabled = true
end)

if not success then
    warn("[VoiceTTS] Aviso: HttpService pode estar bloqueado")
end

local SERVER_URL = "http://localhost:5000"

pcall(function()
    if game.CoreGui:FindFirstChild("VoiceTTSGui") then
        game.CoreGui:FindFirstChild("VoiceTTSGui"):Destroy()
    end
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoiceTTSGui"
ScreenGui.ResetOnSpawn = false 
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 400)
MainFrame.ClipsDescendants = true
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke")
mainStroke.Parent = MainFrame
mainStroke.Color = Color3.fromRGB(70, 45, 150)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3

-- Header bar (fundo visual apenas)
local headerBar = Instance.new("Frame")
headerBar.Parent = MainFrame
headerBar.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
headerBar.Size = UDim2.new(1, 0, 0, 36)
headerBar.BorderSizePixel = 0
headerBar.ZIndex = 1
Instance.new("UICorner", headerBar).CornerRadius = UDim.new(0, 12)
local headerFix = Instance.new("Frame")
headerFix.Parent = headerBar
headerFix.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
headerFix.Position = UDim2.new(0, 0, 1, -6)
headerFix.Size = UDim2.new(1, 0, 0, 6)
headerFix.BorderSizePixel = 0
headerFix.ZIndex = 1

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -40, 0, 36)
Title.Font = Enum.Font.GothamBold
Title.Text = "AS VoiceTTS"
Title.TextColor3 = Color3.fromRGB(200, 180, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Active = true
Title.ZIndex = 2

-- Credito
local creditLabel = Instance.new("TextLabel")
creditLabel.Parent = MainFrame
creditLabel.BackgroundTransparency = 1
creditLabel.Position = UDim2.new(0, 0, 1, -20)
creditLabel.Size = UDim2.new(1, 0, 0, 20)
creditLabel.Font = Enum.Font.GothamBold
creditLabel.Text = "By @leo.zppln"
creditLabel.TextColor3 = Color3.fromRGB(120, 100, 180)
creditLabel.TextSize = 13
creditLabel.TextTransparency = 0.3

-- Linha separadora do header
local headerLine = Instance.new("Frame")
headerLine.Parent = MainFrame
headerLine.BackgroundColor3 = Color3.fromRGB(70, 45, 150)
headerLine.Position = UDim2.new(0, 10, 0, 36)
headerLine.Size = UDim2.new(1, -20, 0, 1)
headerLine.BorderSizePixel = 0
headerLine.BackgroundTransparency = 0.5
headerLine.ZIndex = 2

-- Tabs Container
local TabsFrame = Instance.new("ScrollingFrame")
TabsFrame.Parent = MainFrame
TabsFrame.BackgroundTransparency = 1
TabsFrame.Position = UDim2.new(0, 0, 0, 40)
TabsFrame.Size = UDim2.new(1, 0, 0, 28)
TabsFrame.ScrollBarThickness = 2
TabsFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 70, 220)
TabsFrame.BorderSizePixel = 0
TabsFrame.CanvasSize = UDim2.new(0, 310, 0, 28)
TabsFrame.ScrollingDirection = Enum.ScrollingDirection.X
TabsFrame.ZIndex = 2

local activeTabColor = Color3.fromRGB(80, 50, 160)
local inactiveTabColor = Color3.fromRGB(35, 35, 50)

local function createTab(name, pos)
    local tab = Instance.new("TextButton")
    tab.Parent = TabsFrame
    tab.BackgroundColor3 = inactiveTabColor
    tab.Position = UDim2.new(0, pos, 0, 0)
    tab.Size = UDim2.new(0, 72, 0, 26)
    tab.Font = Enum.Font.GothamBold
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(170, 170, 200)
    tab.TextSize = 11
    tab.BorderSizePixel = 0
    tab.ZIndex = 3
    Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 8)
    return tab
end

local tab1 = createTab("Chat", 4)
local tab2 = createTab("Musica", 80)
local tab3 = createTab("Player", 156)
local tab4 = createTab("God", 232)

-- Content Frames
local contentY = 72
local Content1 = Instance.new("Frame")
Content1.Parent = MainFrame
Content1.BackgroundTransparency = 1
Content1.Position = UDim2.new(0, 0, 0, contentY)
Content1.Size = UDim2.new(1, 0, 1, -contentY)
Content1.Visible = true

local Content2 = Instance.new("Frame")
Content2.Parent = MainFrame
Content2.BackgroundTransparency = 1
Content2.Position = UDim2.new(0, 0, 0, contentY)
Content2.Size = UDim2.new(1, 0, 1, -contentY)
Content2.Visible = false

local Content3 = Instance.new("Frame")
Content3.Parent = MainFrame
Content3.BackgroundTransparency = 1
Content3.Position = UDim2.new(0, 0, 0, contentY)
Content3.Size = UDim2.new(1, 0, 1, -contentY)
Content3.Visible = false

local Content4 = Instance.new("Frame")
Content4.Parent = MainFrame
Content4.BackgroundTransparency = 1
Content4.Position = UDim2.new(0, 0, 0, contentY)
Content4.Size = UDim2.new(1, 0, 1, -contentY)
Content4.Visible = false

-- Rejoin estilizado
local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Parent = MainFrame
rejoinBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
rejoinBtn.Position = UDim2.new(1, -34, 0, 5)
rejoinBtn.Size = UDim2.new(0, 26, 0, 26)
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.Text = "R"
rejoinBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
rejoinBtn.TextSize = 13
rejoinBtn.BorderSizePixel = 0
rejoinBtn.ZIndex = 3
Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(1, 0)

-- Dragging
local dragging, dragInput, dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Buttons
local function createButton(name, parent, yPos)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.Font = Enum.Font.Gotham
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local indicator = Instance.new("Frame")
    indicator.Parent = btn
    indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    indicator.Position = UDim2.new(1, -25, 0.5, -8)
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.BorderSizePixel = 0
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    return btn, indicator
end

local function createSimpleButton(name, parent, yPos)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.Font = Enum.Font.Gotham
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

local function createModeButton(name, parent, xPos, yPos)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Position = UDim2.new(0, xPos, 0, yPos)
    btn.Size = UDim2.new(0, 95, 0, 30)
    btn.Font = Enum.Font.Gotham
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local indicator = Instance.new("Frame")
    indicator.Parent = btn
    indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    indicator.Position = UDim2.new(1, -20, 0.5, -6)
    indicator.Size = UDim2.new(0, 12, 0, 12)
    indicator.BorderSizePixel = 0
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    return btn, indicator
end

-- ABA 1: CHAT (Visual Moderno)
local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function addHover(btn, normalColor, hoverColor)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, tweenInfo, {BackgroundColor3 = hoverColor}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, tweenInfo, {BackgroundColor3 = normalColor}):Play()
	end)
end

-- Aplica hover no rejoin agora que addHover existe
addHover(rejoinBtn, Color3.fromRGB(160, 40, 40), Color3.fromRGB(200, 55, 55))

-- Input Box estilizado
local inputContainer = Instance.new("Frame")
inputContainer.Parent = Content1
inputContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
inputContainer.Position = UDim2.new(0, 10, 0, 5)
inputContainer.Size = UDim2.new(0, 200, 0, 34)
inputContainer.BorderSizePixel = 0
Instance.new("UICorner", inputContainer).CornerRadius = UDim.new(0, 10)
local inputStroke = Instance.new("UIStroke")
inputStroke.Parent = inputContainer
inputStroke.Color = Color3.fromRGB(90, 60, 220)
inputStroke.Thickness = 1.5
inputStroke.Transparency = 0.3

local voiceInputBox = Instance.new("TextBox")
voiceInputBox.Parent = inputContainer
voiceInputBox.BackgroundTransparency = 1
voiceInputBox.Position = UDim2.new(0, 10, 0, 0)
voiceInputBox.Size = UDim2.new(1, -15, 1, 0)
voiceInputBox.Font = Enum.Font.GothamMedium
voiceInputBox.PlaceholderText = "Digite para falar..."
voiceInputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
voiceInputBox.Text = ""
voiceInputBox.TextColor3 = Color3.fromRGB(230, 230, 255)
voiceInputBox.TextSize = 12
voiceInputBox.ClearTextOnFocus = false

voiceInputBox.Focused:Connect(function()
	TweenService:Create(inputStroke, tweenInfo, {Color = Color3.fromRGB(130, 90, 255), Transparency = 0}):Play()
end)
voiceInputBox.FocusLost:Connect(function()
	TweenService:Create(inputStroke, tweenInfo, {Color = Color3.fromRGB(90, 60, 220), Transparency = 0.3}):Play()
end)

-- BotÃ£o Falar estilizado
local voiceSendBtn = Instance.new("TextButton")
voiceSendBtn.Parent = Content1
voiceSendBtn.BackgroundColor3 = Color3.fromRGB(100, 60, 220)
voiceSendBtn.Position = UDim2.new(0, 10, 0, 44)
voiceSendBtn.Size = UDim2.new(0, 200, 0, 32)
voiceSendBtn.Font = Enum.Font.GothamBold
voiceSendBtn.Text = "Falar"
voiceSendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
voiceSendBtn.TextSize = 13
voiceSendBtn.BorderSizePixel = 0
Instance.new("UICorner", voiceSendBtn).CornerRadius = UDim.new(0, 10)
addHover(voiceSendBtn, Color3.fromRGB(100, 60, 220), Color3.fromRGB(130, 85, 255))

-- Separador
local sep1 = Instance.new("Frame")
sep1.Parent = Content1
sep1.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sep1.Position = UDim2.new(0, 20, 0, 82)
sep1.Size = UDim2.new(0, 180, 0, 1)
sep1.BorderSizePixel = 0

-- All Chat TTS estilizado
local allChatBtn = Instance.new("TextButton")
allChatBtn.Parent = Content1
allChatBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
allChatBtn.Position = UDim2.new(0, 10, 0, 90)
allChatBtn.Size = UDim2.new(0, 200, 0, 35)
allChatBtn.Font = Enum.Font.GothamBold
allChatBtn.Text = "  All Chat TTS"
allChatBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
allChatBtn.TextSize = 13
allChatBtn.TextXAlignment = Enum.TextXAlignment.Left
allChatBtn.BorderSizePixel = 0
Instance.new("UICorner", allChatBtn).CornerRadius = UDim.new(0, 10)
addHover(allChatBtn, Color3.fromRGB(45, 45, 60), Color3.fromRGB(60, 55, 80))

local allChatIndicator = Instance.new("Frame")
allChatIndicator.Parent = allChatBtn
allChatIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
allChatIndicator.Position = UDim2.new(1, -28, 0.5, -8)
allChatIndicator.Size = UDim2.new(0, 16, 0, 16)
allChatIndicator.BorderSizePixel = 0
Instance.new("UICorner", allChatIndicator).CornerRadius = UDim.new(1, 0)

-- Background Fila/New com gradiente
local modeBackground = Instance.new("Frame")
modeBackground.Parent = Content1
modeBackground.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
modeBackground.Position = UDim2.new(0, 10, 0, 130)
modeBackground.Size = UDim2.new(0, 200, 0, 42)
modeBackground.BorderSizePixel = 0
Instance.new("UICorner", modeBackground).CornerRadius = UDim.new(0, 10)
local modeStroke = Instance.new("UIStroke")
modeStroke.Parent = modeBackground
modeStroke.Color = Color3.fromRGB(60, 60, 80)
modeStroke.Thickness = 1

local function createStyledModeButton(name, parent, xPos, yPos)
	local btn = Instance.new("TextButton")
	btn.Parent = parent
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	btn.Position = UDim2.new(0, xPos, 0, yPos)
	btn.Size = UDim2.new(0, 92, 0, 30)
	btn.Font = Enum.Font.GothamBold
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(200, 200, 220)
	btn.TextSize = 12
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	addHover(btn, Color3.fromRGB(50, 50, 70), Color3.fromRGB(70, 65, 100))

	local indicator = Instance.new("Frame")
	indicator.Parent = btn
	indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	indicator.Position = UDim2.new(1, -20, 0.5, -6)
	indicator.Size = UDim2.new(0, 12, 0, 12)
	indicator.BorderSizePixel = 0
	Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

	return btn, indicator
end

local filaBtn, filaIndicator = createStyledModeButton("Fila", Content1, 14, 136)
local newBtn, newIndicator = createStyledModeButton("New", Content1, 114, 136)

-- Separador 2
local sep2 = Instance.new("Frame")
sep2.Parent = Content1
sep2.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sep2.Position = UDim2.new(0, 20, 0, 180)
sep2.Size = UDim2.new(0, 180, 0, 1)
sep2.BorderSizePixel = 0

-- Speed Label estilizado
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = Content1
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 12, 0, 188)
speedLabel.Size = UDim2.new(0, 200, 0, 15)
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.Text = "Velocidade: 1.0x"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
speedLabel.TextSize = 11
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Speed Track estilizado
local speedTrack = Instance.new("Frame")
speedTrack.Parent = Content1
speedTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
speedTrack.Position = UDim2.new(0, 12, 0, 208)
speedTrack.Size = UDim2.new(0, 196, 0, 6)
speedTrack.BorderSizePixel = 0
Instance.new("UICorner", speedTrack).CornerRadius = UDim.new(1, 0)

-- Preenchimento colorido do track
local speedFill = Instance.new("Frame")
speedFill.Parent = speedTrack
speedFill.BackgroundColor3 = Color3.fromRGB(100, 60, 220)
speedFill.Size = UDim2.new(0, 0, 1, 0)
speedFill.BorderSizePixel = 0
Instance.new("UICorner", speedFill).CornerRadius = UDim.new(1, 0)

-- Handle com glow
local speedHandle = Instance.new("Frame")
speedHandle.Parent = speedTrack
speedHandle.BackgroundColor3 = Color3.fromRGB(150, 120, 255)
speedHandle.Position = UDim2.new(0, 0, 0.5, -8)
speedHandle.Size = UDim2.new(0, 16, 0, 16)
speedHandle.BorderSizePixel = 0
Instance.new("UICorner", speedHandle).CornerRadius = UDim.new(1, 0)
local handleGlow = Instance.new("UIStroke")
handleGlow.Parent = speedHandle
handleGlow.Color = Color3.fromRGB(130, 90, 255)
handleGlow.Thickness = 2
handleGlow.Transparency = 0.4

-- ABA 2: MÃšSICA (Visual Moderno)

-- BotÃ£o toggle YouTube estilizado
local musicBtn = Instance.new("TextButton")
musicBtn.Parent = Content2
musicBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
musicBtn.Position = UDim2.new(0, 10, 0, 5)
musicBtn.Size = UDim2.new(0, 200, 0, 35)
musicBtn.Font = Enum.Font.GothamBold
musicBtn.Text = "  Musica YouTube"
musicBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
musicBtn.TextSize = 13
musicBtn.TextXAlignment = Enum.TextXAlignment.Left
musicBtn.BorderSizePixel = 0
Instance.new("UICorner", musicBtn).CornerRadius = UDim.new(0, 10)
addHover(musicBtn, Color3.fromRGB(45, 45, 60), Color3.fromRGB(60, 55, 80))

local musicIndicator = Instance.new("Frame")
musicIndicator.Parent = musicBtn
musicIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
musicIndicator.Position = UDim2.new(1, -28, 0.5, -8)
musicIndicator.Size = UDim2.new(0, 16, 0, 16)
musicIndicator.BorderSizePixel = 0
Instance.new("UICorner", musicIndicator).CornerRadius = UDim.new(1, 0)

-- Background container para busca + tocar
local musicBackground = Instance.new("Frame")
musicBackground.Parent = Content2
musicBackground.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
musicBackground.Position = UDim2.new(0, 10, 0, 45)
musicBackground.Size = UDim2.new(0, 200, 0, 90)
musicBackground.BorderSizePixel = 0
Instance.new("UICorner", musicBackground).CornerRadius = UDim.new(0, 10)
local musicBgStroke = Instance.new("UIStroke")
musicBgStroke.Parent = musicBackground
musicBgStroke.Color = Color3.fromRGB(60, 60, 80)
musicBgStroke.Thickness = 1

-- Input de busca estilizado
local musicInputContainer = Instance.new("Frame")
musicInputContainer.Parent = Content2
musicInputContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
musicInputContainer.Position = UDim2.new(0, 18, 0, 52)
musicInputContainer.Size = UDim2.new(0, 184, 0, 30)
musicInputContainer.BorderSizePixel = 0
Instance.new("UICorner", musicInputContainer).CornerRadius = UDim.new(0, 8)
local musicInputStroke = Instance.new("UIStroke")
musicInputStroke.Parent = musicInputContainer
musicInputStroke.Color = Color3.fromRGB(30, 180, 80)
musicInputStroke.Thickness = 1.5
musicInputStroke.Transparency = 0.4

local musicInputBox = Instance.new("TextBox")
musicInputBox.Parent = musicInputContainer
musicInputBox.BackgroundTransparency = 1
musicInputBox.Position = UDim2.new(0, 8, 0, 0)
musicInputBox.Size = UDim2.new(1, -12, 1, 0)
musicInputBox.Font = Enum.Font.GothamMedium
musicInputBox.PlaceholderText = "Nome da musica..."
musicInputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
musicInputBox.Text = ""
musicInputBox.TextColor3 = Color3.fromRGB(230, 230, 255)
musicInputBox.TextSize = 12
musicInputBox.ClearTextOnFocus = false

musicInputBox.Focused:Connect(function()
	TweenService:Create(musicInputStroke, tweenInfo, {Color = Color3.fromRGB(50, 220, 110), Transparency = 0}):Play()
end)
musicInputBox.FocusLost:Connect(function()
	TweenService:Create(musicInputStroke, tweenInfo, {Color = Color3.fromRGB(30, 180, 80), Transparency = 0.4}):Play()
end)

-- BotÃ£o Tocar estilizado (verde Spotify)
local musicPlayBtn = Instance.new("TextButton")
musicPlayBtn.Parent = Content2
musicPlayBtn.BackgroundColor3 = Color3.fromRGB(30, 185, 84)
musicPlayBtn.Position = UDim2.new(0, 18, 0, 90)
musicPlayBtn.Size = UDim2.new(0, 184, 0, 32)
musicPlayBtn.Font = Enum.Font.GothamBold
musicPlayBtn.Text = "Tocar"
musicPlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
musicPlayBtn.TextSize = 13
musicPlayBtn.BorderSizePixel = 0
Instance.new("UICorner", musicPlayBtn).CornerRadius = UDim.new(0, 10)
-- Sistema de hover dinâmico para musicPlayBtn (evita acumular conexões)
local musicPlayNormalColor = Color3.fromRGB(30, 185, 84)
local musicPlayHoverColor = Color3.fromRGB(45, 220, 110)

musicPlayBtn.MouseEnter:Connect(function()
	TweenService:Create(musicPlayBtn, tweenInfo, {BackgroundColor3 = musicPlayHoverColor}):Play()
end)
musicPlayBtn.MouseLeave:Connect(function()
	TweenService:Create(musicPlayBtn, tweenInfo, {BackgroundColor3 = musicPlayNormalColor}):Play()
end)

local function setMusicPlayStyle(normal, hover)
	musicPlayNormalColor = normal
	musicPlayHoverColor = hover
	musicPlayBtn.BackgroundColor3 = normal
end

-- Separador
local sepMusic = Instance.new("Frame")
sepMusic.Parent = Content2
sepMusic.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sepMusic.Position = UDim2.new(0, 20, 0, 142)
sepMusic.Size = UDim2.new(0, 180, 0, 1)
sepMusic.BorderSizePixel = 0

-- BotÃ£o Players /play estilizado
local playerPermissionBtn = Instance.new("TextButton")
playerPermissionBtn.Parent = Content2
playerPermissionBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
playerPermissionBtn.Position = UDim2.new(0, 10, 0, 150)
playerPermissionBtn.Size = UDim2.new(0, 200, 0, 35)
playerPermissionBtn.Font = Enum.Font.GothamBold
playerPermissionBtn.Text = "  Players /play"
playerPermissionBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
playerPermissionBtn.TextSize = 13
playerPermissionBtn.TextXAlignment = Enum.TextXAlignment.Left
playerPermissionBtn.BorderSizePixel = 0
Instance.new("UICorner", playerPermissionBtn).CornerRadius = UDim.new(0, 10)
addHover(playerPermissionBtn, Color3.fromRGB(45, 45, 60), Color3.fromRGB(60, 55, 80))

local playerPermissionIndicator = Instance.new("Frame")
playerPermissionIndicator.Parent = playerPermissionBtn
playerPermissionIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
playerPermissionIndicator.Position = UDim2.new(1, -28, 0.5, -8)
playerPermissionIndicator.Size = UDim2.new(0, 16, 0, 16)
playerPermissionIndicator.BorderSizePixel = 0
Instance.new("UICorner", playerPermissionIndicator).CornerRadius = UDim.new(1, 0)

-- ABA 3: PLAYER
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")
local flying, flySpeed, bodyVelocity, bodyGyro = false, 65, nil, nil
local speedEnabled, walkSpeed = false, 65
local jumpEnabled, jumpPower = false, 100
local clickTpEnabled = false
local freezeEnabled = false
local frozenCFrame = nil
local noclipEnabled = false

-- Sistema de Telecinese
local telekinesisEnabled = false
local telekinesisObject = nil
local telekinesisBodyPosition = nil
local telekinesisBodyGyro = nil
local telekinesisHighlight = nil

-- ABA 4: GODMODE
local God = {
    Enabled = false,
    HealThresh = 60,
    BaseMaxHP = 200,
    BaseWalk = 20,
    BaseJump = 60,
    AntiFall = true,
    HeartbeatCon = nil,
    HealthCon = nil
}

local function addForceField(character)
    if not character or character:FindFirstChildOfClass("ForceField") then return end
    local ff = Instance.new("ForceField")
    ff.Visible = false
    ff.Parent = character
end

local function applyHPStats(h)
    if not h then return end
    h.WalkSpeed = God.BaseWalk
    h.JumpPower = God.BaseJump
    h.MaxHealth = God.BaseMaxHP
    local th = h.MaxHealth * (God.HealThresh / 100)
    if h.Health < th then
        h.Health = h.MaxHealth
    end
end

local function enableGodOnChar(char)
    local h = char and char:FindFirstChildOfClass("Humanoid")
    if not h then return end

    if God.HeartbeatCon then God.HeartbeatCon:Disconnect() God.HeartbeatCon = nil end
    if God.HealthCon then God.HealthCon:Disconnect() God.HealthCon = nil end

    applyHPStats(h)
    addForceField(char)

    God.HealthCon = h.HealthChanged:Connect(function(health)
        if not God.Enabled then return end
        if health <= 0 then
            task.spawn(function()
                pcall(function() player:LoadCharacter() end)
            end)
        else
            applyHPStats(h)
        end
    end)

    God.HeartbeatCon = RunService.Heartbeat:Connect(function()
        if not God.Enabled then return end
        if h.Health > 0 then
            applyHPStats(h)
            addForceField(char)
            if God.AntiFall then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local v = root.Velocity
                    if v.Y < -90 then
                        local nv = Vector3.new(v.X, -50, v.Z)
                        root.Velocity = nv
                        root.AssemblyLinearVelocity = nv
                    end
                end
            end
        end
    end)
end

local function disableGod()
    if God.HeartbeatCon then God.HeartbeatCon:Disconnect() God.HeartbeatCon = nil end
    if God.HealthCon then God.HealthCon:Disconnect() God.HealthCon = nil end
end

-- Anti-Fling automÃ¡tico (proteÃ§Ã£o contra toque com players)
local MaxVel = 120
local MaxVert = 80

RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local v = root.Velocity
        if v.Magnitude > MaxVel then
            v = v.Unit * MaxVel
        end
        v = Vector3.new(v.X, math.clamp(v.Y, -MaxVert, MaxVert), v.Z)
        root.Velocity = v
        root.AssemblyLinearVelocity = v
    end)
end)

-- Anti-colisao apenas com outros players (nao com objetos do mapa)
local savedCollisions = {}

RunService.Stepped:Connect(function()
    pcall(function()
        -- Noclip manual tem prioridade
        if noclipEnabled and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            return
        end
        
        -- Desativa anti-colisao quando fly esta ligado
        if flying then
            for part in pairs(savedCollisions) do
                if part and part.Parent then
                    part.CanCollide = true
                end
            end
            savedCollisions = {}
            return
        end
        
        if not player.Character then return end
        local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        
        local nearPlayer = false
        for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if otherRoot and (myRoot.Position - otherRoot.Position).Magnitude < 10 then
                    nearPlayer = true
                    break
                end
            end
        end
        
        if nearPlayer then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    savedCollisions[part] = true
                    part.CanCollide = false
                end
            end
        else
            for part in pairs(savedCollisions) do
                if part and part.Parent then
                    part.CanCollide = true
                end
            end
            savedCollisions = {}
        end
    end)
end)

-- ABA 3: PLAYER (Visual Moderno)

local function createStyledToggle(icon, name, parent, yPos)
	local btn = Instance.new("TextButton")
	btn.Parent = parent
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Size = UDim2.new(0, 155, 0, 32)
	btn.Font = Enum.Font.GothamBold
	btn.Text = "  " .. icon .. " " .. name
	btn.TextColor3 = Color3.fromRGB(220, 220, 240)
	btn.TextSize = 12
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
	addHover(btn, Color3.fromRGB(45, 45, 60), Color3.fromRGB(60, 55, 80))

	local indicator = Instance.new("Frame")
	indicator.Parent = btn
	indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	indicator.Position = UDim2.new(1, -24, 0.5, -7)
	indicator.Size = UDim2.new(0, 14, 0, 14)
	indicator.BorderSizePixel = 0
	Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

	return btn, indicator
end

local function createStyledValueBox(parent, yPos, text)
	local container = Instance.new("Frame")
	container.Parent = parent
	container.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	container.Position = UDim2.new(0, 170, 0, yPos)
	container.Size = UDim2.new(0, 40, 0, 32)
	container.BorderSizePixel = 0
	Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
	local boxStroke = Instance.new("UIStroke")
	boxStroke.Parent = container
	boxStroke.Color = Color3.fromRGB(90, 60, 220)
	boxStroke.Thickness = 1
	boxStroke.Transparency = 0.4

	local box = Instance.new("TextBox")
	box.Parent = container
	box.BackgroundTransparency = 1
	box.Position = UDim2.new(0, 0, 0, 0)
	box.Size = UDim2.new(1, 0, 1, 0)
	box.Font = Enum.Font.GothamBold
	box.Text = text
	box.TextColor3 = Color3.fromRGB(180, 160, 255)
	box.TextSize = 12

	box.Focused:Connect(function()
		TweenService:Create(boxStroke, tweenInfo, {Color = Color3.fromRGB(130, 90, 255), Transparency = 0}):Play()
	end)
	box.FocusLost:Connect(function()
		TweenService:Create(boxStroke, tweenInfo, {Color = Color3.fromRGB(90, 60, 220), Transparency = 0.4}):Play()
	end)

	return box
end

local flyBtn, flyIndicator = createStyledToggle("", "Fly", Content3, 5)
local flySpeedBox = createStyledValueBox(Content3, 5, "65")

local speedBtn, speedIndicator = createStyledToggle("", "Speed", Content3, 42)
local speedBox = createStyledValueBox(Content3, 42, "65")

local jumpBtn, jumpIndicator = createStyledToggle("", "SuperJump", Content3, 79)
local jumpBox = createStyledValueBox(Content3, 79, "100")

-- Separador
local sepPlayer1 = Instance.new("Frame")
sepPlayer1.Parent = Content3
sepPlayer1.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sepPlayer1.Position = UDim2.new(0, 20, 0, 117)
sepPlayer1.Size = UDim2.new(0, 180, 0, 1)
sepPlayer1.BorderSizePixel = 0

local freezeBtn, freezeIndicator = createStyledToggle("", "Congelar", Content3, 123)
local noclipBtn, noclipIndicator = createStyledToggle("", "Noclip", Content3, 160)
local telekinesisBtn, telekinesisIndicator = createStyledToggle("", "Telecinese", Content3, 197)

-- Separador 2
local sepPlayer2 = Instance.new("Frame")
sepPlayer2.Parent = Content3
sepPlayer2.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sepPlayer2.Position = UDim2.new(0, 20, 0, 236)
sepPlayer2.Size = UDim2.new(0, 180, 0, 1)
sepPlayer2.BorderSizePixel = 0

-- TP Players estilizado
local tpBtn = Instance.new("TextButton")
tpBtn.Parent = Content3
tpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
tpBtn.Position = UDim2.new(0, 10, 0, 243)
tpBtn.Size = UDim2.new(0, 160, 0, 32)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.Text = "  TP Players >>"
tpBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
tpBtn.TextSize = 12
tpBtn.TextXAlignment = Enum.TextXAlignment.Left
tpBtn.BorderSizePixel = 0
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 10)
addHover(tpBtn, Color3.fromRGB(45, 45, 60), Color3.fromRGB(60, 55, 80))

-- Click TP estilizado
local clickTpBtn = Instance.new("TextButton")
clickTpBtn.Parent = Content3
clickTpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
clickTpBtn.Position = UDim2.new(0, 175, 0, 243)
clickTpBtn.Size = UDim2.new(0, 35, 0, 32)
clickTpBtn.Text = "Q"
clickTpBtn.Font = Enum.Font.GothamBold
clickTpBtn.TextColor3 = Color3.fromRGB(180, 160, 255)
clickTpBtn.TextSize = 14
clickTpBtn.BorderSizePixel = 0
Instance.new("UICorner", clickTpBtn).CornerRadius = UDim.new(0, 10)
addHover(clickTpBtn, Color3.fromRGB(50, 50, 70), Color3.fromRGB(70, 65, 100))

local clickTpIndicator = Instance.new("Frame")
clickTpIndicator.Parent = clickTpBtn
clickTpIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
clickTpIndicator.Position = UDim2.new(1, -12, 0, 3)
clickTpIndicator.Size = UDim2.new(0, 8, 0, 8)
clickTpIndicator.BorderSizePixel = 0
Instance.new("UICorner", clickTpIndicator).CornerRadius = UDim.new(1, 0)

-- Player List estilizado
local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Parent = ScreenGui
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
PlayerListFrame.Position = UDim2.new(0, 0, 0, 0)
PlayerListFrame.Size = UDim2.new(0, 200, 0, 300)
PlayerListFrame.Visible = false
PlayerListFrame.BorderSizePixel = 0
Instance.new("UICorner", PlayerListFrame).CornerRadius = UDim.new(0, 10)
local listStroke = Instance.new("UIStroke")
listStroke.Parent = PlayerListFrame
listStroke.Color = Color3.fromRGB(90, 60, 220)
listStroke.Thickness = 1
listStroke.Transparency = 0.3

local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Parent = PlayerListFrame
PlayerListScroll.BackgroundTransparency = 1
PlayerListScroll.Size = UDim2.new(1, 0, 1, 0)
PlayerListScroll.ScrollBarThickness = 3
PlayerListScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 70, 220)
PlayerListScroll.BorderSizePixel = 0

-- ABA 4: GODMODE (Visual Moderno)
local godBtn, godIndicator = createStyledToggle("", "Godmode", Content4, 5)

-- Separador
local sepGod1 = Instance.new("Frame")
sepGod1.Parent = Content4
sepGod1.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sepGod1.Position = UDim2.new(0, 20, 0, 43)
sepGod1.Size = UDim2.new(0, 180, 0, 1)
sepGod1.BorderSizePixel = 0

local healLabel = Instance.new("TextLabel")
healLabel.Parent = Content4
healLabel.BackgroundTransparency = 1
healLabel.Position = UDim2.new(0, 12, 0, 50)
healLabel.Size = UDim2.new(0, 200, 0, 15)
healLabel.Font = Enum.Font.GothamMedium
healLabel.Text = "Cura Auto: 60%"
healLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
healLabel.TextSize = 11
healLabel.TextXAlignment = Enum.TextXAlignment.Left

local healSlider = Instance.new("Frame")
healSlider.Parent = Content4
healSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
healSlider.Position = UDim2.new(0, 12, 0, 70)
healSlider.Size = UDim2.new(0, 196, 0, 6)
healSlider.BorderSizePixel = 0
Instance.new("UICorner", healSlider).CornerRadius = UDim.new(1, 0)

local healFill = Instance.new("Frame")
healFill.Parent = healSlider
healFill.BackgroundColor3 = Color3.fromRGB(220, 60, 80)
healFill.Size = UDim2.new(0.5, 0, 1, 0)
healFill.BorderSizePixel = 0
Instance.new("UICorner", healFill).CornerRadius = UDim.new(1, 0)

local healHandle = Instance.new("Frame")
healHandle.Parent = healSlider
healHandle.BackgroundColor3 = Color3.fromRGB(255, 120, 140)
healHandle.Position = UDim2.new(0.5, 0, 0.5, -8)
healHandle.Size = UDim2.new(0, 16, 0, 16)
healHandle.BorderSizePixel = 0
Instance.new("UICorner", healHandle).CornerRadius = UDim.new(1, 0)
local healGlow = Instance.new("UIStroke")
healGlow.Parent = healHandle
healGlow.Color = Color3.fromRGB(220, 60, 80)
healGlow.Thickness = 2
healGlow.Transparency = 0.4

local hpLabel = Instance.new("TextLabel")
hpLabel.Parent = Content4
hpLabel.BackgroundTransparency = 1
hpLabel.Position = UDim2.new(0, 12, 0, 85)
hpLabel.Size = UDim2.new(0, 200, 0, 15)
hpLabel.Font = Enum.Font.GothamMedium
hpLabel.Text = "Vida Maxima: 200"
hpLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
hpLabel.TextSize = 11
hpLabel.TextXAlignment = Enum.TextXAlignment.Left

local hpSlider = Instance.new("Frame")
hpSlider.Parent = Content4
hpSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
hpSlider.Position = UDim2.new(0, 12, 0, 105)
hpSlider.Size = UDim2.new(0, 196, 0, 6)
hpSlider.BorderSizePixel = 0
Instance.new("UICorner", hpSlider).CornerRadius = UDim.new(1, 0)

local hpFill = Instance.new("Frame")
hpFill.Parent = hpSlider
hpFill.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
hpFill.Size = UDim2.new(0.11, 0, 1, 0)
hpFill.BorderSizePixel = 0
Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)

local hpHandle = Instance.new("Frame")
hpHandle.Parent = hpSlider
hpHandle.BackgroundColor3 = Color3.fromRGB(100, 230, 140)
hpHandle.Position = UDim2.new(0.11, 0, 0.5, -8)
hpHandle.Size = UDim2.new(0, 16, 0, 16)
hpHandle.BorderSizePixel = 0
Instance.new("UICorner", hpHandle).CornerRadius = UDim.new(1, 0)
local hpGlow = Instance.new("UIStroke")
hpGlow.Parent = hpHandle
hpGlow.Color = Color3.fromRGB(60, 180, 100)
hpGlow.Thickness = 2
hpGlow.Transparency = 0.4

-- Separador
local sepGod2 = Instance.new("Frame")
sepGod2.Parent = Content4
sepGod2.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sepGod2.Position = UDim2.new(0, 20, 0, 127)
sepGod2.Size = UDim2.new(0, 180, 0, 1)
sepGod2.BorderSizePixel = 0

local antiFallBtn, antiFallIndicator = createStyledToggle("", "Anti-Queda", Content4, 133)

local function startFly()
    flying = true
    pcall(function()
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if not root or not humanoid then return end
        -- Se sentado, nao precisa de BodyVelocity (move o veiculo direto)
        if humanoid.Sit then return end
        humanoid.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Parent = root
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = root.CFrame
        bodyGyro.Parent = root
    end)
end

local function stopFly()
    flying = false
    pcall(function()
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid.PlatformStand = false end
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if not flying or not player.Character then return end
    pcall(function()
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if not root then return end
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
        local vel = moveDir.Magnitude > 0 and moveDir.Unit * flySpeed or Vector3.zero
        -- Se sentado, move o veiculo via CFrame
        if humanoid and humanoid.Sit and humanoid.SeatPart then
            local seat = humanoid.SeatPart
            local vehicleRoot = seat
            if seat.Parent and seat.Parent:IsA("Model") and seat.Parent.PrimaryPart then
                vehicleRoot = seat.Parent.PrimaryPart
            end
            if vel.Magnitude > 0.1 then
                vehicleRoot.CFrame = vehicleRoot.CFrame + vel * 0.03
            end
            vehicleRoot.Velocity = Vector3.zero
            vehicleRoot.AssemblyLinearVelocity = Vector3.zero
        else
            -- Fly normal no personagem
            if bodyVelocity then
                bodyVelocity.Velocity = vel
            end
            if bodyGyro then
                bodyGyro.CFrame = cam.CFrame
            end
        end
    end)
end)

local function updateSpeed()
    pcall(function()
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speedEnabled and walkSpeed or 16
            end
        end
    end)
end

local function updateJump()
    pcall(function()
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = jumpEnabled and jumpPower or 50
            end
        end
    end)
end

local function updatePlayerList()
    for _, child in pairs(PlayerListScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local yPos = 2
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            local frame = Instance.new("Frame")
            frame.Parent = PlayerListScroll
            frame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            frame.Position = UDim2.new(0, 5, 0, yPos)
            frame.Size = UDim2.new(1, -10, 0, 36)
            frame.BorderSizePixel = 0
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
            
            local img = Instance.new("ImageLabel")
            img.Parent = frame
            img.BackgroundTransparency = 1
            img.Position = UDim2.new(0, 5, 0.5, -14)
            img.Size = UDim2.new(0, 28, 0, 28)
            img.Image = "rbxthumb://type=AvatarHeadShot&id="..plr.UserId.."&w=48&h=48"
            Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 38, 0, 0)
            label.Size = UDim2.new(1, -43, 1, 0)
            label.Font = Enum.Font.GothamMedium
            label.Text = plr.Name
            label.TextColor3 = Color3.fromRGB(210, 210, 230)
            label.TextSize = 11
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local btn = Instance.new("TextButton")
            btn.Parent = frame
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.Text = ""
            
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 55, 80)}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
            end)
            
            btn.MouseButton1Click:Connect(function()
                pcall(function()
                    if player.Character and plr.Character then
                        local root = player.Character:FindFirstChild("HumanoidRootPart")
                        local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                        if root and targetRoot then
                            root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                        end
                    end
                end)
                PlayerListFrame.Visible = false
            end)
            yPos = yPos + 40
        end
    end
    PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then startFly() else stopFly() end
    flyIndicator.BackgroundColor3 = flying and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

speedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    updateSpeed()
    speedIndicator.BackgroundColor3 = speedEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

jumpBtn.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    updateJump()
    jumpIndicator.BackgroundColor3 = jumpEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

freezeBtn.MouseButton1Click:Connect(function()
    freezeEnabled = not freezeEnabled
    if freezeEnabled then
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then frozenCFrame = root.CFrame end
    end
    freezeIndicator.BackgroundColor3 = freezeEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipIndicator.BackgroundColor3 = noclipEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

telekinesisBtn.MouseButton1Click:Connect(function()
    telekinesisEnabled = not telekinesisEnabled
    telekinesisIndicator.BackgroundColor3 = telekinesisEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    if not telekinesisEnabled then
        if telekinesisObject then
            if telekinesisBodyPosition then telekinesisBodyPosition:Destroy() telekinesisBodyPosition = nil end
            if telekinesisBodyGyro then telekinesisBodyGyro:Destroy() telekinesisBodyGyro = nil end
            if telekinesisHighlight then telekinesisHighlight:Destroy() telekinesisHighlight = nil end
            telekinesisObject = nil
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if freezeEnabled and frozenCFrame then
        pcall(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = frozenCFrame
                root.Velocity = Vector3.new()
            end
        end)
    end
    
    if telekinesisEnabled and telekinesisObject then
        pcall(function()
            if not telekinesisObject.Parent or telekinesisObject.Anchored then
                if telekinesisBodyPosition then telekinesisBodyPosition:Destroy() telekinesisBodyPosition = nil end
                if telekinesisBodyGyro then telekinesisBodyGyro:Destroy() telekinesisBodyGyro = nil end
                if telekinesisHighlight then telekinesisHighlight:Destroy() telekinesisHighlight = nil end
                telekinesisObject = nil
                return
            end
            
            if telekinesisBodyPosition then
                local mouse = player:GetMouse()
                local cam = workspace.CurrentCamera
                local mouseRay = cam:ScreenPointToRay(mouse.X, mouse.Y)
                local targetPos = mouseRay.Origin + mouseRay.Direction * 25
                telekinesisBodyPosition.Position = targetPos
            end
        end)
    end
end)

-- Noclip manual agora esta integrado no Stepped acima

tpBtn.MouseButton1Click:Connect(function()
    PlayerListFrame.Visible = not PlayerListFrame.Visible
    if PlayerListFrame.Visible then
        -- Posiciona ao lado direito do MainFrame
        local pos = MainFrame.AbsolutePosition
        local size = MainFrame.AbsoluteSize
        PlayerListFrame.Position = UDim2.new(0, pos.X + size.X + 5, 0, pos.Y)
        updatePlayerList()
    end
end)

clickTpBtn.MouseButton1Click:Connect(function()
    clickTpEnabled = not clickTpEnabled
    clickTpIndicator.BackgroundColor3 = clickTpEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

flySpeedBox.FocusLost:Connect(function()
    local value = tonumber(flySpeedBox.Text)
    if value and value >= 1 and value <= 500 then
        flySpeed = value
    else
        flySpeed = 65
        flySpeedBox.Text = "65"
    end
end)

speedBox.FocusLost:Connect(function()
    local value = tonumber(speedBox.Text)
    if value and value >= 1 and value <= 500 then
        walkSpeed = value
        updateSpeed()
    else
        walkSpeed = 65
        speedBox.Text = "65"
        updateSpeed()
    end
end)

jumpBox.FocusLost:Connect(function()
    local value = tonumber(jumpBox.Text)
    if value and value >= 1 and value <= 500 then
        jumpPower = value
        updateJump()
    else
        jumpPower = 100
        jumpBox.Text = "100"
        updateJump()
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if speedEnabled then updateSpeed() end
    if jumpEnabled then updateJump() end
    if flying then startFly() end
    if God.Enabled then enableGodOnChar(player.Character) end
end)

-- Godmode Events
godBtn.MouseButton1Click:Connect(function()
    God.Enabled = not God.Enabled
    godIndicator.BackgroundColor3 = God.Enabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    if God.Enabled then
        if player.Character then enableGodOnChar(player.Character) end
    else
        disableGod()
    end
end)

antiFallBtn.MouseButton1Click:Connect(function()
    God.AntiFall = not God.AntiFall
    antiFallIndicator.BackgroundColor3 = God.AntiFall and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

local healDragging = false
healHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then healDragging = true end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then healDragging = false end
end)

UIS.InputChanged:Connect(function(input)
    if healDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UIS:GetMouseLocation()
        local trackPos = healSlider.AbsolutePosition.X
        local trackSize = healSlider.AbsoluteSize.X
        local relativePos = math.clamp(mousePos.X - trackPos, 0, trackSize)
        local percentage = relativePos / trackSize
        God.HealThresh = 20 + (percentage * 75)
        healHandle.Position = UDim2.new(percentage, 0, 0.5, -8)
        healFill.Size = UDim2.new(percentage, 0, 1, 0)
        healLabel.Text = string.format("Cura Auto: %.0f%%", God.HealThresh)
    end
end)

local hpDragging = false
hpHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then hpDragging = true end
end)

UIS.InputChanged:Connect(function(input)
    if hpDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UIS:GetMouseLocation()
        local trackPos = hpSlider.AbsolutePosition.X
        local trackSize = hpSlider.AbsoluteSize.X
        local relativePos = math.clamp(mousePos.X - trackPos, 0, trackSize)
        local percentage = relativePos / trackSize
        God.BaseMaxHP = 100 + (percentage * 900)
        hpHandle.Position = UDim2.new(percentage, 0, 0.5, -8)
        hpFill.Size = UDim2.new(percentage, 0, 1, 0)
        hpLabel.Text = string.format("Vida Maxima: %.0f", God.BaseMaxHP)
    end
end)

-- Tab System Logic com animaÃ§Ã£o
local tabs = {tab1, tab2, tab3, tab4}
local contents = {Content1, Content2, Content3, Content4}

local function switchTab(index)
	for i, t in ipairs(tabs) do
		local isActive = (i == index)
		contents[i].Visible = isActive
		TweenService:Create(t, tweenInfo, {
			BackgroundColor3 = isActive and activeTabColor or inactiveTabColor
		}):Play()
		t.TextColor3 = isActive and Color3.fromRGB(230, 220, 255) or Color3.fromRGB(170, 170, 200)
	end
end

tab1.MouseButton1Click:Connect(function() switchTab(1) end)
tab2.MouseButton1Click:Connect(function() switchTab(2) end)
tab3.MouseButton1Click:Connect(function() switchTab(3) end)
tab4.MouseButton1Click:Connect(function() switchTab(4) end)
switchTab(1)

-- Variables
local allChatEnabled = false
local PROXIMITY_DISTANCE = 50
local ttsSpeed = 1.0
local musicEnabled = false
local musicPlaying = false
local musicSearching = false
local musicToggling = false
local playerCanPlay = false

-- Queue System
local queueMode = true
local messageQueue = {}
local messageQueueNew = {}
local isProcessingQueue = false
local currentTTSId = 0
local isPlayingNew = false

-- Speed Slider Logic
local speedDragging = false

speedHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDragging = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDragging = false
        healDragging = false
        hpDragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if speedDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UIS:GetMouseLocation()
        local trackPos = speedTrack.AbsolutePosition.X
        local trackSize = speedTrack.AbsoluteSize.X
        local relativePos = math.clamp(mousePos.X - trackPos, 0, trackSize)
        local percentage = relativePos / trackSize
        
        ttsSpeed = 1.0 + (percentage * 1.5)
        speedHandle.Position = UDim2.new(percentage, 0, 0.5, -8)
        speedFill.Size = UDim2.new(percentage, 0, 1, 0)
        speedLabel.Text = string.format("Velocidade: %.1fx", ttsSpeed)
        
        task.spawn(function()
            pcall(function()
                request({
                    Url = SERVER_URL .. "/speed",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({speed = ttsSpeed})
                })
            end)
        end)
    end
end)

-- HTTP Functions
local function sendTTS(text, ttsId, priority)
    print("[DEBUG] Enviando TTS:", text, "ID:", ttsId, "Prioridade:", priority)
    task.spawn(function()
        local success, result = pcall(function()
            local response = request({
                Url = SERVER_URL .. "/tts",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode({text = text, priority = priority, speed = ttsSpeed})
            })
            return response
        end)
        if success then
            print("[TTS] Sucesso! ID:", ttsId)
        else
            warn("[TTS] Erro:", result)
        end
    end)
end

local function processNewMode()
    if isPlayingNew then return end
    isPlayingNew = true
    
    task.spawn(function()
        while allChatEnabled and not queueMode do
            if #messageQueueNew > 0 then
                -- Sempre pega a Ãºltima mensagem e descarta todas as outras
                local msg = messageQueueNew[#messageQueueNew]
                messageQueueNew = {}
                
                print("[NEW] Lendo mensagem mais recente:", msg.text)
                sendTTS(msg.text, msg.id, "low")
                
                local textLength = #msg.text
                local waitTime = math.max(1, textLength * 0.08)
                task.wait(waitTime)
                
                -- Aguarda 1 segundo antes de procurar prÃ³xima mensagem
                task.wait(1)
            else
                -- Se nÃ£o hÃ¡ mensagens, aguarda atÃ© ter
                task.wait(0.5)
            end
        end
        isPlayingNew = false
    end)
end

local function processQueue()
    if isProcessingQueue then return end
    isProcessingQueue = true
    
    task.spawn(function()
        while #messageQueue > 0 and allChatEnabled and queueMode do
            local msg = table.remove(messageQueue, 1)
            sendTTS(msg.text, msg.id, "low")
            
            local textLength = #msg.text
            local waitTime = math.max(1, textLength * 0.08)
            print("[FILA] Aguardando", waitTime, "segundos")
            task.wait(waitTime)
            
            -- Aguarda 1 segundo entre mensagens
            task.wait(1)
        end
        isProcessingQueue = false
    end)
end

local function handleTTS(text, priority)
    currentTTSId = currentTTSId + 1
    local ttsId = currentTTSId
    
    if priority == "high" then
        print("[VOICE TTS] Prioridade alta - limpando fila antiga")
        messageQueue = {}
        messageQueueNew = {}
        isProcessingQueue = false
        isPlayingNew = false
        sendTTS(text, ttsId, "high")
        
        task.spawn(function()
            task.wait(5)
            if allChatEnabled then
                if queueMode then
                    print("[FILA] Iniciando nova fila do zero")
                    processQueue()
                else
                    print("[NEW] Reiniciando modo New")
                    processNewMode()
                end
            end
        end)
    elseif queueMode then
        table.insert(messageQueue, {text = text, id = ttsId})
        print("[FILA] Adicionado:", text, "| Total:", #messageQueue)
        processQueue()
    else
        -- Modo New: usa fila separada
        table.insert(messageQueueNew, {text = text, id = ttsId})
        print("[NEW] Nova mensagem adicionada (total:", #messageQueueNew, ")")
        if not isPlayingNew then
            processNewMode()
        end
    end
end

local function isPlayerNearby(plr)
    pcall(function()
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return false end
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return false end
        return (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude <= PROXIMITY_DISTANCE
    end)
    return false
end

-- Music Functions
local function stopMusic()
    task.spawn(function()
        pcall(function()
            request({
                Url = SERVER_URL .. "/music/stop",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({})
            })
        end)
    end)
end

local function searchMusic(query, playerName)
    print("[MUSIC] Buscando:", query)
    
    if musicPlaying then
        print("[MUSIC] Parando mÃºsica anterior...")
        musicPlaying = false
        stopMusic()
        task.wait(1.5)
    end
    
    musicSearching = true
    musicPlayBtn.Text = "Buscando..."
    musicPlayBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    
    task.spawn(function()
        local success, result = pcall(function()
            return request({
                Url = SERVER_URL .. "/music/search",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({query = query, player_name = playerName})
            })
        end)
        
        if not musicSearching then
            print("[MUSIC] Busca cancelada")
            return
        end
        
        if success and result then
            print("[MUSIC] Resposta recebida:", result.StatusCode)
            local data = HttpService:JSONDecode(result.Body)
            if data.found and musicSearching then
                print("[MUSIC] Encontrada:", data.title)
                musicPlaying = true
                musicSearching = false
                musicPlayBtn.Text = "Interromper"
                musicPlayBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
                setMusicPlayStyle(Color3.fromRGB(200, 60, 60), Color3.fromRGB(230, 80, 80))
            else
                print("[MUSIC] NÃ£o encontrada")
                musicPlaying = false
                musicSearching = false
                musicPlayBtn.Text = "Tocar"
                musicPlayBtn.BackgroundColor3 = Color3.fromRGB(30, 185, 84)
                setMusicPlayStyle(Color3.fromRGB(30, 185, 84), Color3.fromRGB(45, 220, 110))
            end
        else
            warn("[MUSIC] Erro na requisiÃ§Ã£o:", result)
            musicPlaying = false
            musicSearching = false
            musicPlayBtn.Text = "Tocar"
            musicPlayBtn.BackgroundColor3 = Color3.fromRGB(30, 185, 84)
            setMusicPlayStyle(Color3.fromRGB(30, 185, 84), Color3.fromRGB(45, 220, 110))
        end
    end)
end

-- Button Events
voiceSendBtn.MouseButton1Click:Connect(function()
    local text = voiceInputBox.Text
    if text == "" or #text < 1 then
        print("[Voice TTS] Texto vazio")
        return
    end
    
    print("[Voice TTS] Enviando:", text)
    voiceInputBox.Text = ""
    
    -- Pausa All Chat TTS
    messageQueue = {}
    isProcessingQueue = false
    isPlayingNew = false
    
    task.spawn(function()
        pcall(function()
            request({
                Url = SERVER_URL .. "/stop",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({action = "stop"})
            })
        end)
        task.wait(0.3)
        handleTTS(text, "high")
    end)
end)

filaBtn.MouseButton1Click:Connect(function()
    if not queueMode then
        queueMode = true
        filaIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        newIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        print("[MODO] Fila ativado")
    end
end)

newBtn.MouseButton1Click:Connect(function()
    if queueMode then
        queueMode = false
        -- Limpa TODAS as filas imediatamente
        messageQueue = {}
        messageQueueNew = {}
        isProcessingQueue = false
        isPlayingNew = false
        filaIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        newIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        print("[MODO] New ativado - Fila cancelada e voz parada")
        
        -- Para qualquer Ã¡udio que esteja tocando
        task.spawn(function()
            pcall(function()
                request({
                    Url = SERVER_URL .. "/stop",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({action = "stop"})
                })
            end)
        end)
        
        -- Aguarda um pouco antes de iniciar modo New
        task.wait(0.3)
        
        -- Inicia modo New
        if allChatEnabled then
            processNewMode()
        end
    end
end)

allChatBtn.MouseButton1Click:Connect(function()
    allChatEnabled = not allChatEnabled
    allChatIndicator.BackgroundColor3 = allChatEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    
    if allChatEnabled then
        queueMode = true
        filaIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        newIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        print("[All Chat] Ativado - Iniciando fila nova")
    else
        -- Limpa filas imediatamente
        messageQueue = {}
        messageQueueNew = {}
        isProcessingQueue = false
        isPlayingNew = false
        filaIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        newIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        print("[All Chat] Desativado - Parando voz IMEDIATAMENTE")
        
        -- Para o Ã¡udio instantaneamente no servidor
        task.spawn(function()
            pcall(function()
                request({
                    Url = SERVER_URL .. "/stop",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({action = "stop"})
                })
            end)
        end)
    end
    
    print("[All Chat]", allChatEnabled and "Ativado" or "Desativado")
end)


musicBtn.MouseButton1Click:Connect(function()
    if musicToggling then
        print("[MUSIC] Aguarde...")
        return
    end
    
    musicToggling = true
    
    -- Muda visual imediatamente para feedback instantÃ¢neo
    musicEnabled = not musicEnabled
    musicIndicator.BackgroundColor3 = musicEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    
    -- Se desativar, para a mÃºsica imediatamente e desativa Players /play
    if not musicEnabled then
        playerCanPlay = false
        playerPermissionIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        musicPlaying = false
        musicSearching = false
        musicPlayBtn.Text = "Tocar"
        musicPlayBtn.BackgroundColor3 = Color3.fromRGB(30, 185, 84)
        setMusicPlayStyle(Color3.fromRGB(30, 185, 84), Color3.fromRGB(45, 220, 110))
        print("[MUSIC] Players /play desativado automaticamente")
        print("[MUSIC] Parando mÃºsica imediatamente")
        stopMusic()
    end
    
    print("[MUSIC]", musicEnabled and "ATIVANDO..." or "DESATIVANDO...")
    
    -- Envia para servidor em background
    task.spawn(function()
        local success, response = pcall(function()
            return request({
                Url = SERVER_URL .. "/music/toggle",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({})
            })
        end)
        
        if success and response then
            local data = HttpService:JSONDecode(response.Body)
            musicEnabled = data.enabled
            musicIndicator.BackgroundColor3 = musicEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
            print("[MUSIC]", musicEnabled and "ATIVADO!" or "DESATIVADO!")
        else
            warn("[MUSIC] Erro ao alternar estado")
            -- Reverte em caso de erro
            musicEnabled = not musicEnabled
            musicIndicator.BackgroundColor3 = musicEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        end
        
        task.wait(0.2)
        musicToggling = false
    end)
end)

playerPermissionBtn.MouseButton1Click:Connect(function()
    playerCanPlay = not playerCanPlay
    playerPermissionIndicator.BackgroundColor3 = playerCanPlay and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    print("[MUSIC] Players podem tocar:", playerCanPlay and "SIM" or "NÃƒO")
end)

musicPlayBtn.MouseButton1Click:Connect(function()
    if not musicEnabled then
        print("[MUSIC] Sistema desativado - Ative o botÃ£o 'MÃºsica YouTube' primeiro (deixe verde)")
        return
    end
    
    -- Se estÃ¡ buscando, cancela a busca
    if musicSearching then
        print("[MUSIC] Cancelando busca")
        musicSearching = false
        musicPlaying = false
        musicPlayBtn.Text = "Tocar"
        musicPlayBtn.BackgroundColor3 = Color3.fromRGB(30, 185, 84)
        setMusicPlayStyle(Color3.fromRGB(30, 185, 84), Color3.fromRGB(45, 220, 110))
        stopMusic()
        return
    end
    
    if musicPlaying then
        -- Interromper
        musicPlaying = false
        musicPlayBtn.Text = "Tocar"
        musicPlayBtn.BackgroundColor3 = Color3.fromRGB(30, 185, 84)
        setMusicPlayStyle(Color3.fromRGB(30, 185, 84), Color3.fromRGB(45, 220, 110))
        stopMusic()
        print("[MUSIC] Parado")
    else
        -- Tocar
        local query = musicInputBox.Text
        if query == "" or #query < 2 then
            print("[MUSIC] Nome muito curto")
            return
        end
        
        searchMusic(query, nil)
    end
end)

local function setupPlayerChat(plr)
    if plr == player then return end
    
    plr.Chatted:Connect(function(message)
        print("[DEBUG] Player", plr.DisplayName, "falou:", message)
        
        -- Detecta comando "/play" (case insensitive)
        local lowerMsg = string.lower(message)
        if musicEnabled and playerCanPlay and string.sub(lowerMsg, 1, 5) == "/play" then
            local songName = string.sub(message, 7)  -- Pega do caractere 7 em diante (apÃ³s "/play ")
            if #songName > 0 then
                print("[MUSIC] Comando detectado de", plr.DisplayName, ":", songName)
                musicInputBox.Text = plr.DisplayName .. " tocou: " .. songName
                searchMusic(songName, plr.DisplayName)
                return
            end
        end
        
        if allChatEnabled then
            local textToSpeak = plr.DisplayName .. " falou " .. message
            print("[DEBUG] Falando:", textToSpeak)
            handleTTS(textToSpeak, "low")
        end
    end)
end

rejoinBtn.MouseButton1Click:Connect(function()
    local TeleportService = game:GetService("TeleportService")
    local success, jobId = pcall(function()
        return game.JobId
    end)
    if success and jobId and jobId ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
    else
        TeleportService:Teleport(game.PlaceId, player)
    end
end)

for _, plr in pairs(game.Players:GetPlayers()) do
    setupPlayerChat(plr)
end

game.Players.PlayerAdded:Connect(setupPlayerChat)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z then
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            MainFrame.Size = UDim2.new(0, 220, 0, 0)
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 220, 0, 400)
            }):Play()
        end
    elseif input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then startFly() else stopFly() end
        flyIndicator.BackgroundColor3 = flying and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    elseif input.KeyCode == Enum.KeyCode.Q and clickTpEnabled then
        pcall(function()
            if not player.Character then return end
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local mouse = player:GetMouse()
            if mouse.Target then
                root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end)
    end
end)

local mouse = player:GetMouse()
mouse.Button1Down:Connect(function()
    if not telekinesisEnabled then return end
    
    pcall(function()
        if telekinesisObject then
            if telekinesisBodyPosition then telekinesisBodyPosition:Destroy() telekinesisBodyPosition = nil end
            if telekinesisBodyGyro then telekinesisBodyGyro:Destroy() telekinesisBodyGyro = nil end
            if telekinesisHighlight then telekinesisHighlight:Destroy() telekinesisHighlight = nil end
            telekinesisObject = nil
        else
            local target = mouse.Target
            if target and target:IsA("BasePart") and not target.Anchored then
                if not target:IsDescendantOf(player.Character) then
                    telekinesisObject = target
                    
                    target.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
                    
                    telekinesisBodyPosition = Instance.new("BodyPosition")
                    telekinesisBodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    telekinesisBodyPosition.P = 10000
                    telekinesisBodyPosition.D = 1000
                    telekinesisBodyPosition.Position = target.Position
                    telekinesisBodyPosition.Parent = target
                    
                    telekinesisBodyGyro = Instance.new("BodyGyro")
                    telekinesisBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    telekinesisBodyGyro.P = 5000
                    telekinesisBodyGyro.CFrame = target.CFrame
                    telekinesisBodyGyro.Parent = target
                    
                    telekinesisHighlight = Instance.new("Highlight")
                    telekinesisHighlight.FillColor = Color3.fromRGB(0, 150, 255)
                    telekinesisHighlight.FillTransparency = 0.5
                    telekinesisHighlight.OutlineColor = Color3.fromRGB(0, 100, 255)
                    telekinesisHighlight.OutlineTransparency = 0
                    telekinesisHighlight.Adornee = target
                    telekinesisHighlight.Parent = target
                end
            end
        end
    end)
end)

print("[VoiceTTS] Carregado! Z=Menu | F=Fly | Server:", SERVER_URL)
