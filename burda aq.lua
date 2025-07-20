-- GuiLib: Profesyonel Mobil & PC Uyumlu Roblox GUI Kütüphanesi
local GuiLib = {Windows = {}, ZIndex = 100, Configs = {}, CurrentTheme = "Karanlık"}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Cihaz Tipini Belirle
local IS_MOBILE = UserInputService.TouchEnabled
local IS_PC = UserInputService.MouseEnabled

-- Gelişmiş Temalar
local Themes = {
    ["Karanlık"] = {
        Background = Color3.fromRGB(25, 25, 35),
        Header = Color3.fromRGB(45, 45, 60),
        Text = Color3.fromRGB(240, 240, 240),
        Button = Color3.fromRGB(65, 65, 85),
        ButtonHover = Color3.fromRGB(85, 85, 110),
        ToggleOn = Color3.fromRGB(0, 170, 127),
        ToggleOff = Color3.fromRGB(70, 70, 90),
        Border = Color3.fromRGB(60, 60, 80),
        SliderBar = Color3.fromRGB(80, 80, 100),
        SliderFill = Color3.fromRGB(0, 170, 127),
        Dropdown = Color3.fromRGB(55, 55, 75),
        DropdownItem = Color3.fromRGB(65, 65, 85),
        Textbox = Color3.fromRGB(50, 50, 70),
        Keybind = Color3.fromRGB(60, 60, 80),
        Notify = Color3.fromRGB(40, 40, 55)
    },
    ["Açık"] = {
        Background = Color3.fromRGB(240, 240, 245),
        Header = Color3.fromRGB(200, 200, 210),
        Text = Color3.fromRGB(30, 30, 30),
        Button = Color3.fromRGB(180, 180, 190),
        ButtonHover = Color3.fromRGB(160, 160, 175),
        ToggleOn = Color3.fromRGB(0, 200, 83),
        ToggleOff = Color3.fromRGB(170, 170, 180),
        Border = Color3.fromRGB(150, 150, 160),
        SliderBar = Color3.fromRGB(170, 170, 180),
        SliderFill = Color3.fromRGB(0, 200, 83),
        Dropdown = Color3.fromRGB(190, 190, 200),
        DropdownItem = Color3.fromRGB(180, 180, 190),
        Textbox = Color3.fromRGB(200, 200, 210),
        Keybind = Color3.fromRGB(170, 170, 185),
        Notify = Color3.fromRGB(220, 220, 230)
    },
    ["Mavi"] = {
        Background = Color3.fromRGB(25, 35, 50),
        Header = Color3.fromRGB(40, 60, 90),
        Text = Color3.fromRGB(220, 230, 255),
        Button = Color3.fromRGB(50, 80, 120),
        ButtonHover = Color3.fromRGB(70, 100, 140),
        ToggleOn = Color3.fromRGB(0, 150, 200),
        ToggleOff = Color3.fromRGB(60, 80, 110),
        Border = Color3.fromRGB(40, 60, 90),
        SliderBar = Color3.fromRGB(70, 90, 120),
        SliderFill = Color3.fromRGB(0, 150, 200),
        Dropdown = Color3.fromRGB(45, 65, 95),
        DropdownItem = Color3.fromRGB(55, 75, 105),
        Textbox = Color3.fromRGB(40, 60, 90),
        Keybind = Color3.fromRGB(60, 80, 110),
        Notify = Color3.fromRGB(30, 50, 75)
    }
}

-- Z-Index Yönetimi
local function IncrementZIndex()
    GuiLib.ZIndex = GuiLib.ZIndex + 1
    return GuiLib.ZIndex
end

-- Animasyonlu Renk Değişimi
local function TweenColor(object, property, targetColor, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, {[property] = targetColor})
    tween:Play()
    return tween
end

-- Mobil için optimize sürükleme
local function Draggify(frame, handle)
    local dragging, dragStart, startPos
    local connection
    
    local function updatePosition(input)
        local currentTheme = Themes[GuiLib.CurrentTheme]
        local delta
        if IS_MOBILE then
            local touch = input.Touches[1]
            if touch then
                delta = touch.Position - dragStart
            end
        else
            delta = input.Position - dragStart
        end
        
        if delta then
            frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            frame.ZIndex = IncrementZIndex()
            
            -- Mobil için dokunma efekti
            if IS_MOBILE then
                local ripple = Instance.new("Frame")
                ripple.Size = UDim2.new(0, 0, 0, 0)
                ripple.Position = UDim2.new(0, input.Position.X - frame.AbsolutePosition.X, 0, input.Position.Y - frame.AbsolutePosition.Y)
                ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ripple.BackgroundTransparency = 0.8
                ripple.ZIndex = frame.ZIndex + 10
                ripple.Parent = frame
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = ripple
                
                TweenService:Create(ripple, TweenInfo.new(0.4), {
                    Size = UDim2.new(0, 100, 0, 100),
                    Position = UDim2.new(0.5, -50, 0.5, -50),
                    BackgroundTransparency = 1
                }):Play()
                
                delay(0.5, function()
                    ripple:Destroy()
                end)
            end
            
            connection = RunService.Heartbeat:Connect(function()
                if dragging then
                    if IS_MOBILE and UserInputService:GetTouchCount() > 0 then
                        updatePosition(UserInputService:GetTouchInput(0))
                    elseif not IS_MOBILE then
                        updatePosition(UserInputService:GetMouseLocation())
                    end
                end
            end)
        end
    end)
    
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end)
end

-- Modern UI Elementleri
local function CreateRoundedFrame(parent, size, position, zIndex, theme)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = theme.Background
    frame.Size = size
    frame.Position = position
    frame.ZIndex = zIndex
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, IS_MOBILE and 8 or 6)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Border
    stroke.Thickness = 1
    stroke.Parent = frame
    
    return frame
end

-- Mobil için büyük butonlar
local function CreateMobileButton(text, parent, position, zIndex, callback, theme)
    local buttonSize = IS_MOBILE and UDim2.new(1, -20, 0, 45) or UDim2.new(1, 0, 0, 32)
    local button = CreateRoundedFrame(parent, buttonSize, position, zIndex, theme)
    button.BackgroundColor3 = theme.Button
    
    local buttonText = Instance.new("TextLabel")
    buttonText.Text = text
    buttonText.Font = IS_MOBILE and Enum.Font.GothamBold or Enum.Font.Gotham
    buttonText.TextSize = IS_MOBILE and 16 or 13
    buttonText.TextColor3 = theme.Text
    buttonText.Size = UDim2.new(1, -20, 1, 0)
    buttonText.Position = UDim2.new(0, 10, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.ZIndex = button.ZIndex
    buttonText.Parent = button
    
    local buttonClick = Instance.new("TextButton")
    buttonClick.Size = UDim2.new(1, 0, 1, 0)
    buttonClick.BackgroundTransparency = 1
    buttonClick.Text = ""
    buttonClick.ZIndex = button.ZIndex + 1
    buttonClick.Parent = button
    
    buttonClick.MouseButton1Click:Connect(callback)
    
    buttonClick.MouseEnter:Connect(function()
        if not IS_MOBILE then
            TweenColor(button, "BackgroundColor3", theme.ButtonHover)
        end
    end)
    
    buttonClick.MouseLeave:Connect(function()
        if not IS_MOBILE then
            TweenColor(button, "BackgroundColor3", theme.Button)
        end
    end)
    
    -- Mobil için basma efekti
    if IS_MOBILE then
        buttonClick.TouchTap:Connect(function()
            TweenColor(button, "BackgroundColor3", theme.ButtonHover, 0.1):Wait()
            TweenColor(button, "BackgroundColor3", theme.Button, 0.1)
        end)
    end
    
    return button
end

-- Dinamik tema uygulama
local function ApplyTheme(object, theme)
    if object:IsA("Frame") or object:IsA("TextButton") then
        if object.Name == "Header" then
            object.BackgroundColor3 = theme.Header
        elseif object.Name == "Button" then
            object.BackgroundColor3 = theme.Button
        elseif object.Name == "ToggleFrame" then
            object.BackgroundColor3 = theme[object.BackgroundColor3 == theme.ToggleOn and "ToggleOn" or "ToggleOff"]
        end
    end
    
    if object:IsA("TextLabel") or object:IsA("TextButton") then
        object.TextColor3 = theme.Text
    end
    
    if object:IsA("UIStroke") then
        object.Color = theme.Border
    end
    
    for _, child in ipairs(object:GetChildren()) do
        ApplyTheme(child, theme)
    end
end

-- Ana Pencere Oluşturma (Geliştirilmiş)
function GuiLib:CreateWindow(title, configKey)
    local Window = {Tabs = {}, Elements = {}, ConfigKey = configKey}
    local currentTheme = Themes[self.CurrentTheme]
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GuiLib_" .. title
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Mobil için tam ekran modu
    local mainSize = IS_MOBILE and UDim2.new(1, -20, 0.8, 0) or UDim2.new(0, 400, 0, 450)
    local mainPosition = IS_MOBILE and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, -200, 0.5, -225)
    
    local mainZIndex = IncrementZIndex()
    local mainFrame = CreateRoundedFrame(screenGui, mainSize, mainPosition, mainZIndex, currentTheme)
    mainFrame.AnchorPoint = IS_MOBILE and Vector2.new(0.5, 0.5) or Vector2.new(0, 0)
    
    -- Başlık Çubuğu (Geliştirilmiş)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "Header"
    titleBar.Size = UDim2.new(1, 0, 0, IS_MOBILE and 40 or 32)
    titleBar.BackgroundColor3 = currentTheme.Header
    titleBar.ZIndex = mainZIndex + 1
    titleBar.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Text = title
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = IS_MOBILE and 18 or 14
    titleText.TextColor3 = currentTheme.Text
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.BackgroundTransparency = 1
    titleText.ZIndex = titleBar.ZIndex
    titleText.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = IS_MOBILE and 24 or 18
    closeButton.TextColor3 = currentTheme.Text
    closeButton.Size = UDim2.new(0, IS_MOBILE and 40 or 32, 1, 0)
    closeButton.Position = UDim2.new(1, -IS_MOBILE and 40 or 32, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.ZIndex = titleBar.ZIndex
    closeButton.Parent = titleBar
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        if configKey then
            self:SaveConfig(configKey)
        end
    end)
    
    -- Mobil için kapatma efekti
    if IS_MOBILE then
        closeButton.TouchTap:Connect(function()
            TweenColor(closeButton, "TextColor3", Color3.new(1, 0.5, 0.5), 0.1):Wait()
            closeButton.TextColor3 = currentTheme.Text
            screenGui:Destroy()
        end)
    end
    
    -- Minimize Butonu
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Text = "-"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = IS_MOBILE and 24 or 18
    minimizeButton.TextColor3 = currentTheme.Text
    minimizeButton.Size = UDim2.new(0, IS_MOBILE and 40 or 32, 1, 0)
    minimizeButton.Position = UDim2.new(1, -IS_MOBILE and 80 or 64, 0, 0)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.ZIndex = titleBar.ZIndex
    minimizeButton.Parent = titleBar
    
    local minimized = false
    local originalSize = mainFrame.Size
    local minimizedSize = UDim2.new(0, IS_MOBILE and 200 or 160, 0, titleBar.Size.Y.Offset)
    
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        for _, tab in pairs(Window.Tabs) do
            for _, element in pairs(tab.Elements) do
                element.Visible = not minimized
            end
        end
        
        if minimized then
            mainFrame.Size = minimizedSize
        else
            mainFrame.Size = originalSize
        end
    end)
    
    -- Tema Değiştirme Butonu
    local themeButton = Instance.new("TextButton")
    themeButton.Text = "🎨"
    themeButton.Font = Enum.Font.GothamBold
    themeButton.TextSize = IS_MOBILE and 20 or 16
    themeButton.TextColor3 = currentTheme.Text
    themeButton.Size = UDim2.new(0, IS_MOBILE and 40 or 32, 1, 0)
    themeButton.Position = UDim2.new(1, -IS_MOBILE and 120 or 96, 0, 0)
    themeButton.BackgroundTransparency = 1
    themeButton.ZIndex = titleBar.ZIndex
    themeButton.Parent = titleBar
    
    themeButton.MouseButton1Click:Connect(function()
        local themes = {"Karanlık", "Açık", "Mavi"}
        local currentIndex = table.find(themes, self.CurrentTheme) or 1
        local nextIndex = currentIndex % #themes + 1
        self:SetTheme(themes[nextIndex])
    end)
    
    Draggify(mainFrame, titleBar)
    
    -- Tab Butonları (Geliştirilmiş)
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -20, 0, IS_MOBILE and 40 or 32)
    tabContainer.Position = UDim2.new(0, 10, 0, IS_MOBILE and 50 or 40)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ZIndex = mainZIndex
    tabContainer.Parent = mainFrame
    
    -- İçerik Alanı
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -20, 1, -IS_MOBILE and 100 or 90)
    contentFrame.Position = UDim2.new(0, 10, 0, IS_MOBILE and 100 or 82)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = IS_MOBILE and 10 or 6
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.ZIndex = mainZIndex
    contentFrame.Parent = mainFrame
    
    -- Tab Oluşturma Fonksiyonu (Geliştirilmiş)
    function Window:CreateTab(tabName)
        local Tab = {Elements = {}}
        
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "Button"
        tabButton.Text = tabName
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = IS_MOBILE and 16 or 13
        tabButton.Size = UDim2.new(0.3, -5, 1, 0)
        tabButton.Position = UDim2.new(#self.Tabs * 0.3, (#self.Tabs * 5), 0, 0)
        tabButton.BackgroundColor3 = currentTheme.Button
        tabButton.TextColor3 = currentTheme.Text
        tabButton.AutoButtonColor = false
        tabButton.ZIndex = mainZIndex + 1
        tabButton.Parent = tabContainer
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 4)
        buttonCorner.Parent = tabButton
        
        local content = Instance.new("Frame")
        content.Size = UDim2.new(1, 0, 1, 0)
        content.BackgroundTransparency = 1
        content.Visible = (#self.Tabs == 0)
        content.ZIndex = mainZIndex
        content.Parent = contentFrame
        
        tabButton.MouseButton1Click:Connect(function()
            for _, frame in pairs(contentFrame:GetChildren()) do
                if frame:IsA("Frame") then
                    frame.Visible = false
                end
            end
            content.Visible = true
        end)
        
        -- Buton Hover Efekti
        tabButton.MouseEnter:Connect(function()
            if not IS_MOBILE then
                TweenColor(tabButton, "BackgroundColor3", currentTheme.ButtonHover)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if not IS_MOBILE then
                TweenColor(tabButton, "BackgroundColor3", currentTheme.Button)
            end
        end)
        
        -- Element Yüksekliği Takibi
        local elementYPosition = 5
        
        -- Buton Oluşturma (Geliştirilmiş)
        function Tab:CreateButton(settings)
            local button = CreateMobileButton(settings.Text, content, UDim2.new(0, 0, 0, elementYPosition), mainZIndex + 1, settings.Callback, currentTheme)
            elementYPosition += IS_MOBILE and 50 or 37
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, elementYPosition)
            table.insert(self.Elements, button)
            return button
        end
        
        -- Toggle Oluşturma (Geliştirilmiş)
        function Tab:CreateToggle(settings)
            local toggle = CreateRoundedFrame(content, UDim2.new(1, 0, 0, IS_MOBILE and 45 or 32), UDim2.new(0, 0, 0, elementYPosition), mainZIndex + 1, currentTheme)
            toggle.BackgroundColor3 = currentTheme.Button
            
            local label = Instance.new("TextLabel")
            label.Text = settings.Text
            label.Font = Enum.Font.Gotham
            label.TextSize = IS_MOBILE and 16 or 13
            label.TextColor3 = currentTheme.Text
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = toggle.ZIndex
            label.Parent = toggle
            
            local toggleFrame = CreateRoundedFrame(toggle, UDim2.new(0, IS_MOBILE and 60 or 50, 0, IS_MOBILE and 30 or 24), UDim2.new(1, -IS_MOBILE and 70 or 60, 0.5, -IS_MOBILE and 15 or 12), toggle.ZIndex + 1, currentTheme)
            toggleFrame.Name = "ToggleFrame"
            toggleFrame.BackgroundColor3 = settings.Default and currentTheme.ToggleOn or currentTheme.ToggleOff
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(1, 0, 1, 0)
            toggleButton.BackgroundTransparency = 1
            toggleButton.Text = ""
            toggleButton.ZIndex = toggleFrame.ZIndex + 1
            toggleButton.Parent = toggleFrame
            
            toggleButton.MouseButton1Click:Connect(function()
                settings.Default = not settings.Default
                TweenColor(toggleFrame, "BackgroundColor3", settings.Default and currentTheme.ToggleOn or currentTheme.ToggleOff)
                settings.Callback(settings.Default)
                
                if Window.ConfigKey then
                    GuiLib.Configs[Window.ConfigKey] = GuiLib.Configs[Window.ConfigKey] or {}
                    GuiLib.Configs[Window.ConfigKey][settings.Text] = settings.Default
                end
            end)
            
            -- Mobil için toggle efekti
            if IS_MOBILE then
                toggleButton.TouchTap:Connect(function()
                    settings.Default = not settings.Default
                    TweenColor(toggleFrame, "BackgroundColor3", settings.Default and currentTheme.ToggleOn or currentTheme.ToggleOff)
                    settings.Callback(settings.Default)
                end)
            end
            
            elementYPosition += IS_MOBILE and 50 or 37
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, elementYPosition)
            
            table.insert(self.Elements, toggle)
            return toggle
        end
        
        -- Keybind Oluşturma (Sadece PC)
        if IS_PC then
            function Tab:CreateKeybind(settings)
                local keybind = CreateRoundedFrame(content, UDim2.new(1, 0, 0, IS_MOBILE and 45 or 32), UDim2.new(0, 0, 0, elementYPosition), mainZIndex + 1, currentTheme)
                keybind.BackgroundColor3 = currentTheme.Keybind
                
                local label = Instance.new("TextLabel")
                label.Text = settings.Text
                label.Font = Enum.Font.Gotham
                label.TextSize = IS_MOBILE and 16 or 13
                label.TextColor3 = currentTheme.Text
                label.Size = UDim2.new(0.7, 0, 1, 0)
                label.Position = UDim2.new(0, 15, 0, 0)
                label.BackgroundTransparency = 1
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = keybind.ZIndex
                label.Parent = keybind
                
                local keyButton = Instance.new("TextButton")
                keyButton.Text = settings.Key or "Tıkla"
                keyButton.Font = Enum.Font.Gotham
                keyButton.TextSize = IS_MOBILE and 16 or 13
                keyButton.TextColor3 = currentTheme.Text
                keyButton.Size = UDim2.new(0, IS_MOBILE and 80 or 60, 0, IS_MOBILE and 35 or 25)
                keyButton.Position = UDim2.new(1, -IS_MOBILE and 90 or 70, 0.5, -IS_MOBILE and 17.5 or 12.5)
                keyButton.BackgroundColor3 = currentTheme.Button
                keyButton.ZIndex = keybind.ZIndex + 1
                keyButton.Parent = keybind
                
                local keyCorner = Instance.new("UICorner")
                keyCorner.CornerRadius = UDim.new(0, 4)
                keyCorner.Parent = keyButton
                
                local listening = false
                
                keyButton.MouseButton1Click:Connect(function()
                    listening = true
                    keyButton.Text = "..."
                end)
                
                UserInputService.InputBegan:Connect(function(input)
                    if listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            settings.Key = input.KeyCode.Name
                            keyButton.Text = input.KeyCode.Name
                            listening = false
                        end
                    elseif settings.Key and input.KeyCode.Name == settings.Key then
                        settings.Callback()
                    end
                end)
                
                elementYPosition += IS_MOBILE and 50 or 37
                contentFrame.CanvasSize = UDim2.new(0, 0, 0, elementYPosition)
                
                table.insert(self.Elements, keybind)
                return keybind
            end
        end
        
        -- Bildirim Sistemi
        function Tab:CreateNotify(message, duration)
            local notify = CreateRoundedFrame(screenGui, UDim2.new(0, IS_MOBILE and 300 or 250, 0, IS_MOBILE and 50 or 40), UDim2.new(1, -IS_MOBILE and 320 or 270, 0.1, 0), mainZIndex + 100, currentTheme)
            notify.BackgroundColor3 = currentTheme.Notify
            notify.Position = UDim2.new(1, -IS_MOBILE and 320 or 270, 0.1, 0)
            
            local label = Instance.new("TextLabel")
            label.Text = message
            label.Font = Enum.Font.Gotham
            label.TextSize = IS_MOBILE and 16 or 14
            label.TextColor3 = currentTheme.Text
            label.Size = UDim2.new(1, -20, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.ZIndex = notify.ZIndex + 1
            label.Parent = notify
            
            -- Animasyonlu giriş
            TweenService:Create(notify, TweenInfo.new(0.3), {
                Position = UDim2.new(1, -IS_MOBILE and 320 or 270, 0.15, 0)
            }):Play()
            
            delay(duration or 3, function()
                TweenService:Create(notify, TweenInfo.new(0.3), {
                    Position = UDim2.new(1, -IS_MOBILE and 320 or 270, 0.1, 0),
                    BackgroundTransparency = 1
                }):Play()
                delay(0.3, function() notify:Destroy() end)
            end)
        end
        
        table.insert(self.Tabs, Tab)
        return Tab
    end
    
    table.insert(self.Windows, Window)
    return Window
end

-- Tema Değiştirme Fonksiyonu
function GuiLib:SetTheme(themeName)
    if not Themes[themeName] then return end
    self.CurrentTheme = themeName
    local theme = Themes[themeName]
    
    for _, window in ipairs(self.Windows) do
        for _, element in pairs(window) do
            if element and element.Parent then
                ApplyTheme(element, theme)
            end
        end
    end
end

-- Konfigürasyon Yönetimi
function GuiLib:SaveConfig(configKey)
    if not configKey then return end
    local data = self.Configs[configKey] or {}
    local json = HttpService:JSONEncode(data)
    
    if writefile then
        pcall(function()
            writefile(configKey .. ".json", json)
        end)
    end
end

function GuiLib:LoadConfig(configKey)
    if not configKey then return {} end
    if self.Configs[configKey] then return self.Configs[configKey] end
    
    if readfile and isfile(configKey .. ".json") then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(configKey .. ".json"))
        end)
        
        if success then
            self.Configs[configKey] = result
            return result
        end
    end
    
    self.Configs[configKey] = {}
    return {}
end

-- Mobil için kapatma tuşu
if IS_MOBILE then
    local mobileClose = Instance.new("ScreenGui")
    mobileClose.Name = "MobileClose"
    mobileClose.Parent = Players.LocalPlayer.PlayerGui
    
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 24
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Size = UDim2.new(0, 60, 0, 60)
    closeButton.Position = UDim2.new(1, -70, 1, -70)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Parent = mobileClose
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = closeButton
    
    closeButton.TouchTap:Connect(function()
        for _, gui in ipairs(Players.LocalPlayer.PlayerGui:GetChildren()) do
            if gui.Name:find("GuiLib_") then
                gui:Destroy()
            end
        end
    end)
end

return GuiLib