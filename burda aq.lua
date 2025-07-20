-- GuiLib: Profesyonel Roblox GUI Kütüphanesi
local GuiLib = {Windows = {}, ZIndex = 100, Configs = {}}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Geliştirilmiş Temalar
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
        Textbox = Color3.fromRGB(50, 50, 70)
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
        Textbox = Color3.fromRGB(200, 200, 210)
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
end

-- Optimize Sürükleme Fonksiyonu
local function Draggify(frame, handle)
    local dragging, dragStart, startPos
    local connection
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            frame.ZIndex = IncrementZIndex()
            
            connection = RunService.Heartbeat:Connect(function()
                if dragging then
                    local mouse = UserInputService:GetMouseLocation()
                    local delta = Vector2.new(mouse.X, mouse.Y) - dragStart
                    frame.Position = UDim2.new(
                        startPos.X.Scale, 
                        startPos.X.Offset + delta.X, 
                        startPos.Y.Scale, 
                        startPos.Y.Offset + delta.Y
                    )
                end
            end)
        end
    end)
    
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end)
end

-- Modern UI Elementleri
local function CreateRoundedFrame(parent, size, position, zIndex)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Themes["Karanlık"].Background
    frame.Size = size
    frame.Position = position
    frame.ZIndex = zIndex
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Themes["Karanlık"].Border
    stroke.Thickness = 1
    stroke.Parent = frame
    
    return frame
end

-- Ana Pencere Oluşturma (Geliştirilmiş)
function GuiLib:CreateWindow(title, configKey)
    local Window = {Tabs = {}, Elements = {}, ConfigKey = configKey}
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GuiLib_" .. title
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local mainZIndex = IncrementZIndex()
    local mainFrame = CreateRoundedFrame(screenGui, UDim2.new(0, 360, 0, 420), UDim2.new(0.5, -180, 0.5, -210), mainZIndex)
    
    -- Başlık Çubuğu (Geliştirilmiş)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = Themes["Karanlık"].Header
    titleBar.ZIndex = mainZIndex + 1
    titleBar.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Text = title
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 14
    titleText.TextColor3 = Themes["Karanlık"].Text
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Position = UDim2.new(0, 12, 0, 0)
    titleText.Size = UDim2.new(0.7, 0, 1, 0)
    titleText.BackgroundTransparency = 1
    titleText.ZIndex = titleBar.ZIndex
    titleText.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.TextColor3 = Themes["Karanlık"].Text
    closeButton.Size = UDim2.new(0, 32, 1, 0)
    closeButton.Position = UDim2.new(1, -32, 0, 0)
    closeButton.BackgroundTransparency = 1
    closeButton.ZIndex = titleBar.ZIndex
    closeButton.Parent = titleBar
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        if configKey then
            self:SaveConfig(configKey)
        end
    end)
    
    -- Minimize Butonu
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Text = "-"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 18
    minimizeButton.TextColor3 = Themes["Karanlık"].Text
    minimizeButton.Size = UDim2.new(0, 32, 1, 0)
    minimizeButton.Position = UDim2.new(1, -64, 0, 0)
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.ZIndex = titleBar.ZIndex
    minimizeButton.Parent = titleBar
    
    local minimized = false
    local originalSize = mainFrame.Size
    local minimizedSize = UDim2.new(0, 360, 0, 32)
    
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
    
    Draggify(mainFrame, titleBar)
    
    -- Tab Butonları (Geliştirilmiş)
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -20, 0, 32)
    tabContainer.Position = UDim2.new(0, 10, 0, 40)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ZIndex = mainZIndex
    tabContainer.Parent = mainFrame
    
    -- İçerik Alanı
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -20, 1, -90)
    contentFrame.Position = UDim2.new(0, 10, 0, 82)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 6
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.ZIndex = mainZIndex
    contentFrame.Parent = mainFrame
    
    -- Tab Oluşturma Fonksiyonu (Geliştirilmiş)
    function Window:CreateTab(tabName)
        local Tab = {Elements = {}}
        
        local tabButton = Instance.new("TextButton")
        tabButton.Text = tabName
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 13
        tabButton.Size = UDim2.new(0.3, -5, 1, 0)
        tabButton.Position = UDim2.new(#self.Tabs * 0.3, (#self.Tabs * 5), 0, 0)
        tabButton.BackgroundColor3 = Themes["Karanlık"].Button
        tabButton.TextColor3 = Themes["Karanlık"].Text
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
            TweenColor(tabButton, "BackgroundColor3", Themes["Karanlık"].ButtonHover)
        end)
        
        tabButton.MouseLeave:Connect(function()
            TweenColor(tabButton, "BackgroundColor3", Themes["Karanlık"].Button)
        end)
        
        -- Element Yüksekliği Takibi
        local elementYPosition = 5
        
        -- Buton Oluşturma (Geliştirilmiş)
        function Tab:CreateButton(settings)
            local button = CreateRoundedFrame(content, UDim2.new(1, 0, 0, 32), UDim2.new(0, 0, 0, elementYPosition), mainZIndex + 1)
            button.BackgroundColor3 = Themes["Karanlık"].Button
            
            local buttonText = Instance.new("TextLabel")
            buttonText.Text = settings.Text
            buttonText.Font = Enum.Font.Gotham
            buttonText.TextSize = 13
            buttonText.TextColor3 = Themes["Karanlık"].Text
            buttonText.Size = UDim2.new(1, -10, 1, 0)
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
            
            buttonClick.MouseButton1Click:Connect(settings.Callback)
            
            -- Hover Efekti
            buttonClick.MouseEnter:Connect(function()
                TweenColor(button, "BackgroundColor3", Themes["Karanlık"].ButtonHover)
            end)
            
            buttonClick.MouseLeave:Connect(function()
                TweenColor(button, "BackgroundColor3", Themes["Karanlık"].Button)
            end)
            
            elementYPosition += 37
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, elementYPosition)
            
            table.insert(self.Elements, button)
            return button
        end
        
        -- Toggle Oluşturma (Geliştirilmiş)
        function Tab:CreateToggle(settings)
            local toggle = CreateRoundedFrame(content, UDim2.new(1, 0, 0, 32), UDim2.new(0, 0, 0, elementYPosition), mainZIndex + 1)
            toggle.BackgroundColor3 = Themes["Karanlık"].Button
            
            local label = Instance.new("TextLabel")
            label.Text = settings.Text
            label.Font = Enum.Font.Gotham
            label.TextSize = 13
            label.TextColor3 = Themes["Karanlık"].Text
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = toggle.ZIndex
            label.Parent = toggle
            
            local toggleFrame = CreateRoundedFrame(toggle, UDim2.new(0, 50, 0, 24), UDim2.new(1, -60, 0.5, -12), toggle.ZIndex + 1)
            toggleFrame.BackgroundColor3 = settings.Default and Themes["Karanlık"].ToggleOn or Themes["Karanlık"].ToggleOff
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(1, 0, 1, 0)
            toggleButton.BackgroundTransparency = 1
            toggleButton.Text = ""
            toggleButton.ZIndex = toggleFrame.ZIndex + 1
            toggleButton.Parent = toggleFrame
            
            toggleButton.MouseButton1Click:Connect(function()
                settings.Default = not settings.Default
                TweenColor(toggleFrame, "BackgroundColor3", settings.Default and Themes["Karanlık"].ToggleOn or Themes["Karanlık"].ToggleOff)
                settings.Callback(settings.Default)
                
                if Window.ConfigKey then
                    GuiLib.Configs[Window.ConfigKey] = GuiLib.Configs[Window.ConfigKey] or {}
                    GuiLib.Configs[Window.ConfigKey][settings.Text] = settings.Default
                end
            end)
            
            elementYPosition += 37
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, elementYPosition)
            
            table.insert(self.Elements, toggle)
            return toggle
        end
        
        -- Slider Oluşturma
        function Tab:CreateSlider(settings)
            local slider = CreateRoundedFrame(content, UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, elementYPosition), mainZIndex + 1)
            slider.BackgroundColor3 = Themes["Karanlık"].Button
            
            local label = Instance.new("TextLabel")
            label.Text = settings.Text
            label.Font = Enum.Font.Gotham
            label.TextSize = 13
            label.TextColor3 = Themes["Karanlık"].Text
            label.Size = UDim2.new(1, -20, 0, 20)
            label.Position = UDim2.new(0, 10, 0, 5)
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = slider.ZIndex
            label.Parent = slider
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Text = tostring(settings.Default)
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.TextSize = 13
            valueLabel.TextColor3 = Themes["Karanlık"].Text
            valueLabel.Size = UDim2.new(0, 40, 0, 20)
            valueLabel.Position = UDim2.new(1, -50, 0, 5)
            valueLabel.BackgroundTransparency = 1
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.ZIndex = slider.ZIndex
            valueLabel.Parent = slider
            
            local track = CreateRoundedFrame(slider, UDim2.new(1, -20, 0, 10), UDim2.new(0, 10, 0, 30), slider.ZIndex)
            track.BackgroundColor3 = Themes["Karanlık"].SliderBar
            
            local fill = CreateRoundedFrame(track, UDim2.new(0, 0, 1, 0), UDim2.new(0, 0, 0, 0), track.ZIndex + 1)
            fill.BackgroundColor3 = Themes["Karanlık"].SliderFill
            
            local thumb = CreateRoundedFrame(track, UDim2.new(0, 15, 0, 15), UDim2.new(0, -7, 0.5, -7), track.ZIndex + 2)
            thumb.BackgroundColor3 = Themes["Karanlık"].Text
            
            local function updateValue(value)
                local percent = (value - settings.Min) / (settings.Max - settings.Min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                thumb.Position = UDim2.new(percent, -7, 0.5, -7)
                valueLabel.Text = string.format("%.1f", value)
                settings.Callback(value)
                
                if Window.ConfigKey then
                    GuiLib.Configs[Window.ConfigKey] = GuiLib.Configs[Window.ConfigKey] or {}
                    GuiLib.Configs[Window.ConfigKey][settings.Text] = value
                end
            end
            
            local sliding = false
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    local xPos = input.Position.X - track.AbsolutePosition.X
                    local percent = math.clamp(xPos / track.AbsoluteSize.X, 0, 1)
                    local value = settings.Min + (settings.Max - settings.Min) * percent
                    updateValue(value)
                end
            end)
            
            track.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            
            track.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local xPos = input.Position.X - track.AbsolutePosition.X
                    local percent = math.clamp(xPos / track.AbsoluteSize.X, 0, 1)
                    local value = settings.Min + (settings.Max - settings.Min) * percent
                    updateValue(value)
                end
            end)
            
            updateValue(settings.Default)
            elementYPosition += 55
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, elementYPosition)
            
            table.insert(self.Elements, slider)
            return slider
        end
        
        -- Dropdown Oluşturma
        function Tab:CreateDropdown(settings)
            local dropdown = CreateRoundedFrame(content, UDim2.new(1, 0, 0, 32), UDim2.new(0, 0, 0, elementYPosition), mainZIndex + 1)
            dropdown.BackgroundColor3 = Themes["Karanlık"].Button
            
            local label = Instance.new("TextLabel")
            label.Text = settings.Text
            label.Font = Enum.Font.Gotham
            label.TextSize = 13
            label.TextColor3 = Themes["Karanlık"].Text
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = dropdown.ZIndex
            label.Parent = dropdown
            
            local arrow = Instance.new("TextLabel")
            arrow.Text = "▼"
            arrow.Font = Enum.Font.Gotham
            arrow.TextSize = 13
            arrow.TextColor3 = Themes["Karanlık"].Text
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -30, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.TextXAlignment = Enum.TextXAlignment.Center
            arrow.ZIndex = dropdown.ZIndex
            arrow.Parent = dropdown
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Text = settings.Options[settings.Default] or ""
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.TextSize = 13
            valueLabel.TextColor3 = Themes["Karanlık"].Text
            valueLabel.Size = UDim2.new(0.3, -30, 1, 0)
            valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.ZIndex = dropdown.ZIndex
            valueLabel.Parent = dropdown
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(1, 0, 1, 0)
            dropdownButton.BackgroundTransparency = 1
            dropdownButton.Text = ""
            dropdownButton.ZIndex = dropdown.ZIndex + 1
            dropdownButton.Parent = dropdown
            
            local listFrame
            local listOpen = false
            
            local function toggleList()
                listOpen = not listOpen
                
                if listOpen then
                    listFrame = CreateRoundedFrame(content, UDim2.new(1, 0, 0, #settings.Options * 30), UDim2.new(0, 0, 0, elementYPosition + 37), mainZIndex + 10)
                    listFrame.BackgroundColor3 = Themes["Karanlık"].Dropdown
                    listFrame.ZIndex = mainZIndex + 10
                    
                    for i, option in ipairs(settings.Options) do
                        local item = CreateRoundedFrame(listFrame, UDim2.new(1, -10, 0, 25), UDim2.new(0, 5, 0, (i-1)*30 + 5), listFrame.ZIndex + 1)
                        item.BackgroundColor3 = Themes["Karanlık"].DropdownItem
                        
                        local itemText = Instance.new("TextLabel")
                        itemText.Text = option
                        itemText.Font = Enum.Font.Gotham
                        itemText.TextSize = 12
                        itemText.TextColor3 = Themes["Karanlık"].Text
                        itemText.Size = UDim2.new(1, -10, 1, 0)
                        itemText.Position = UDim2.new(0, 10, 0, 0)
                        itemText.BackgroundTransparency = 1
                        itemText.ZIndex = item.ZIndex
                        itemText.Parent = item
                        
                        local itemButton = Instance.new("TextButton")
                        itemButton.Size = UDim2.new(1, 0, 1, 0)
                        itemButton.BackgroundTransparency = 1
                        itemButton.Text = ""
                        itemButton.ZIndex = item.ZIndex + 1
                        itemButton.Parent = item
                        
                        itemButton.MouseButton1Click:Connect(function()
                            valueLabel.Text = option
                            settings.Callback(option, i)
                            listOpen = false
                            listFrame:Destroy()
                            
                            if Window.ConfigKey then
                                GuiLib.Configs[Window.ConfigKey] = GuiLib.Configs[Window.ConfigKey] or {}
                                GuiLib.Configs[Window.ConfigKey][settings.Text] = i
                            end
                        end)
                        
                        itemButton.MouseEnter:Connect(function()
                            TweenColor(item, "BackgroundColor3", Themes["Karanlık"].ButtonHover)
                        end)
                        
                        itemButton.MouseLeave:Connect(function()
                            TweenColor(item, "BackgroundColor3", Themes["Karanlık"].DropdownItem)
                        end)
                    end
                else
                    if listFrame then
                        listFrame:Destroy()
                        listFrame = nil
                    end
                end
            end
            
            dropdownButton.MouseButton1Click:Connect(toggleList)
            elementYPosition += 37
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, elementYPosition)
            
            table.insert(self.Elements, dropdown)
            return dropdown
        end
        
        table.insert(self.Tabs, Tab)
        return Tab
    end
    
    table.insert(self.Windows, Window)
    return Window
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

-- Tema Değiştirme Fonksiyonu
function GuiLib:SetTheme(themeName)
    if not Themes[themeName] then return end
    
    for _, window in ipairs(self.Windows) do
        -- Tüm pencereleri yeniden çiz
    end
end

return GuiLib