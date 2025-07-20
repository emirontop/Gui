--[[
    DearEmocGui v5.0 - Ultimate Roblox GUI Kütüphanesi
    Eklenenler:
        - Dropdown menü
        - Slider bileşeni
        - Renk seçici
        - Bildirim sistemi
        - Gradyan renk desteği
        - Tooltip (açıklama balonları)
]]

local DearEmocGui = {}
DearEmocGui.__index = DearEmocGui

-- Renk Paleti (Geliştirilmiş)
DearEmocGui.ColorPalette = {
    Background = Color3.fromRGB(25, 25, 35),
    Header = Color3.fromRGB(40, 40, 55),
    Element = Color3.fromRGB(35, 35, 48),
    Accent = Color3.fromRGB(140, 110, 255),
    Accent2 = Color3.fromRGB(100, 70, 220),
    Text = Color3.fromRGB(245, 245, 250),
    Disabled = Color3.fromRGB(65, 65, 80),
    LightText = Color3.fromRGB(180, 180, 210),
    Success = Color3.fromRGB(120, 220, 120),
    Warning = Color3.fromRGB(255, 180, 80),
    Danger = Color3.fromRGB(255, 100, 100),
    Info = Color3.fromRGB(80, 170, 255)
}

local ColorPalette = DearEmocGui.ColorPalette

-- Animasyon Fonksiyonu (Geliştirilmiş)
local function Tween(obj, props, duration, style)
    local tween = game:GetService("TweenService"):Create(
        obj,
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    )
    tween:Play()
    return tween
end

-- Yuvarlak Köşe Fonksiyonu
local function ApplyRoundedCorners(obj, cornerRadius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius)
    corner.Parent = obj
    return corner
end

-- Gradyan Efekti Fonksiyonu
local function ApplyGradient(obj, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    gradient.Rotation = rotation or 90
    gradient.Parent = obj
    return gradient
end

-- Tooltip Fonksiyonu
local function CreateTooltip(parent, text)
    local tooltip = Instance.new("TextLabel")
    tooltip.Name = "Tooltip"
    tooltip.Text = text
    tooltip.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    tooltip.TextColor3 = ColorPalette.Text
    tooltip.TextSize = 12
    tooltip.Font = Enum.Font.Gotham
    tooltip.Position = UDim2.new(0, 0, -1.2, 0)
    tooltip.Size = UDim2.new(0, 0, 0, 25)
    tooltip.Visible = false
    tooltip.ZIndex = 100
    tooltip.AutomaticSize = Enum.AutomaticSize.X
    tooltip.Parent = parent
    
    ApplyRoundedCorners(tooltip, 6)
    
    parent.MouseEnter:Connect(function()
        tooltip.Visible = true
        Tween(tooltip, {Size = UDim2.new(0, 0, 0, 25)}, 0.2)
    end)
    
    parent.MouseLeave:Connect(function()
        tooltip.Visible = false
    end)
    
    return tooltip
end

-- Bildirim Fonksiyonu
function DearEmocGui.Notify(title, message, color, duration)
    duration = duration or 5
    
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("DearEmocGui")
    if not ScreenGui then return end
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.BackgroundColor3 = ColorPalette.Header
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(1, 10, 0.8, 0)
    notification.Size = UDim2.new(0, 300, 0, 0)
    notification.AnchorPoint = Vector2.new(1, 0)
    notification.Parent = ScreenGui
    
    ApplyRoundedCorners(notification, 8)
    ApplyGradient(notification, ColorPalette.Header, Color3.fromRGB(30, 30, 45))
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = color or ColorPalette.Accent
    titleLabel.TextSize = 16
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 12)
    titleLabel.Size = UDim2.new(1, -30, 0, 20)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local messageLabel = titleLabel:Clone()
    messageLabel.Name = "Message"
    messageLabel.Text = message
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextColor3 = ColorPalette.Text
    messageLabel.TextSize = 14
    messageLabel.TextTransparency = 0.3
    messageLabel.Position = UDim2.new(0, 15, 0, 35)
    messageLabel.Parent = notification
    
    notification.Size = UDim2.new(0, 300, 0, 0)
    Tween(notification, {Size = UDim2.new(0, 300, 0, 65)}, 0.3)
    
    task.wait(duration)
    
    Tween(notification, {Size = UDim2.new(0, 300, 0, 0)}, 0.3)
    task.wait(0.3)
    notification:Destroy()
end

-- Pencere Oluşturma (Güncellenmiş)
function DearEmocGui.CreateWindow(title, subtitle)
    local Window = {}
    local Tabs = {}
    
    -- Ana Pencere
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DearEmocGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = ColorPalette.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, 450, 0, 520)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Yuvarlak köşeler
    ApplyRoundedCorners(MainFrame, 14)
    
    -- Gradyan efekti
    ApplyGradient(MainFrame, ColorPalette.Background, Color3.fromRGB(20, 20, 30))
    
    -- Mobil için boyut ayarı
    if game:GetService("UserInputService").TouchEnabled then
        MainFrame.Size = UDim2.new(0.85, 0, 0.7, 0)
        MainFrame.Position = UDim2.new(0.075, 0, 0.15, 0)
    end
    
    -- Başlık Çubuğu (Gradyanlı)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundColor3 = ColorPalette.Header
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 54)
    Header.Parent = MainFrame
    
    -- Header için yuvarlak üst köşeler
    ApplyRoundedCorners(Header, 14).CornerRadius = UDim.new(0, 14)
    ApplyGradient(Header, ColorPalette.Header, ColorPalette.Header, 0)

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 18, 0, 8)
    Title.Size = UDim2.new(0.7, 0, 0, 28)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = ColorPalette.Text
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 18, 0, 32)
    Subtitle.Size = UDim2.new(0.7, 0, 0, 18)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = subtitle
    Subtitle.TextTransparency = 0.4
    Subtitle.TextColor3 = ColorPalette.LightText
    Subtitle.TextSize = 14
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header

    -- Kapatma Butonu (Animasyonlu)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(0.9, 0, 0.15, 0)
    CloseButton.Size = UDim2.new(0.08, 0, 0.7, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = ColorPalette.Text
    CloseButton.TextSize = 22
    CloseButton.Parent = Header
    
    CreateTooltip(CloseButton, "Kapat")
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        Tween(MainFrame, {Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {TextColor3 = ColorPalette.Danger})
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {TextColor3 = ColorPalette.Text})
    end)

    -- Sekme Butonları
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 0, 0, 54)
    TabContainer.Size = UDim2.new(1, 0, 0, 42)
    TabContainer.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.Parent = TabContainer

    -- İçerik Alanı
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "Content"
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 12, 0, 96)
    ContentFrame.Size = UDim2.new(1, -24, 1, -108)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = ColorPalette.Accent
    ContentFrame.Parent = MainFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 16)
    ContentLayout.Parent = ContentFrame

    -- Boyut güncellemeleri için bağlantı
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
    end)

    -- Sürükleme Mantığı (Geliştirilmiş)
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(MainFrame, {
                Position = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X, 
                    startPos.Y.Scale, 
                    startPos.Y.Offset + delta.Y
                )
            }, 0.1)
        end
    end)

    -- Sekme Oluşturma Fonksiyonu
    function Window.CreateTab(tabName)
        local Tab = {}
        local TabElements = {}
        
        -- Sekme Butonu (Gradyanlı)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.BackgroundColor3 = ColorPalette.Element
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(0, 100, 0, 34)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = tabName
        TabButton.TextColor3 = ColorPalette.Text
        TabButton.TextSize = 15
        TabButton.Parent = TabContainer
        
        -- Yuvarlak köşeler
        ApplyRoundedCorners(TabButton, 8)
        
        -- İlk sekme aktif
        if #Tabs == 0 then
            ApplyGradient(TabButton, ColorPalette.Accent, ColorPalette.Accent2)
            TabButton.TextColor3 = Color3.new(1, 1, 1)
        else
            ApplyGradient(TabButton, ColorPalette.Element, Color3.fromRGB(40, 40, 55))
        end
        
        -- İçerik Çerçevesi
        local TabContent = Instance.new("Frame")
        TabContent.Name = tabName
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 0, 0)
        TabContent.Visible = (#Tabs == 0)
        TabContent.Parent = ContentFrame
        
        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Padding = UDim.new(0, 16)
        TabLayout.Parent = TabContent
        
        -- Boyut güncellemeleri için bağlantı
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.Size = UDim2.new(1, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end)
        
        -- Sekme Değiştirme (Animasyonlu)
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in ipairs(ContentFrame:GetChildren()) do
                if tab:IsA("Frame") then
                    tab.Visible = false
                end
            end
            TabContent.Visible = true
            
            for _, btn in ipairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.TextColor3 = ColorPalette.Text
                    ApplyGradient(btn, ColorPalette.Element, Color3.fromRGB(40, 40, 55))
                end
            end
            
            ApplyGradient(TabButton, ColorPalette.Accent, ColorPalette.Accent2)
            TabButton.TextColor3 = Color3.new(1, 1, 1)
        end)
        
        -- Element Oluşturma Fonksiyonları
        
        -- Buton (Gradyanlı)
        function Tab.CreateButton(btnName, callback, accentColor)
            accentColor = accentColor or ColorPalette.Accent
            local accentColor2 = accentColor:lerp(Color3.new(0, 0, 0), 0.2)
            
            local ButtonHolder = Instance.new("Frame")
            ButtonHolder.Name = "ButtonHolder"
            ButtonHolder.BackgroundTransparency = 1
            ButtonHolder.Size = UDim2.new(1, 0, 0, 44)
            ButtonHolder.Parent = TabContent
            
            local Button = Instance.new("TextButton")
            Button.Name = btnName
            Button.BackgroundColor3 = ColorPalette.Element
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.Position = UDim2.new(0, 0, 0, 2)
            Button.Font = Enum.Font.GothamMedium
            Button.Text = btnName
            Button.TextColor3 = ColorPalette.Text
            Button.TextSize = 15
            Button.Parent = ButtonHolder
            
            -- Yuvarlak köşeler ve gradyan
            ApplyRoundedCorners(Button, 8)
            ApplyGradient(Button, ColorPalette.Element, Color3.fromRGB(40, 40, 55))
            
            -- Hover Animasyonu
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundTransparency = 0.7}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundTransparency = 1}, 0.2)
            end)
            
            Button.MouseButton1Click:Connect(function()
                ApplyGradient(Button, accentColor, accentColor2)
                Button.TextColor3 = Color3.new(1, 1, 1)
                task.wait(0.1)
                ApplyGradient(Button, ColorPalette.Element, Color3.fromRGB(40, 40, 55))
                Button.TextColor3 = ColorPalette.Text
                callback()
            end)
            
            CreateTooltip(Button, btnName .. " fonksiyonunu çalıştırır")
            
            return Button
        end
        
        -- Toggle (Animasyonlu)
        function Tab.CreateToggle(togName, default, callback, tooltipText)
            local ToggleHolder = Instance.new("Frame")
            ToggleHolder.Name = "ToggleHolder"
            ToggleHolder.BackgroundTransparency = 1
            ToggleHolder.Size = UDim2.new(1, 0, 0, 36)
            ToggleHolder.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(0.65, 0, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = togName
            Label.TextColor3 = ColorPalette.Text
            Label.TextSize = 15
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleHolder
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.BackgroundColor3 = ColorPalette.Element
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Position = UDim2.new(0.7, 0, 0.15, 0)
            ToggleFrame.Size = UDim2.new(0.3, 0, 0.7, 0)
            ToggleFrame.Parent = ToggleHolder
            
            -- Yuvarlak köşeler
            ApplyRoundedCorners(ToggleFrame, 12)
            ApplyGradient(ToggleFrame, ColorPalette.Element, Color3.fromRGB(40, 40, 55))
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.BackgroundColor3 = default and ColorPalette.Success or ColorPalette.Disabled
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Size = UDim2.new(0.5, -2, 1, -2)
            ToggleButton.Position = default and UDim2.new(0.5, 0, 0, 1) or UDim2.new(0, 1, 0, 1)
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            -- Yuvarlak köşeler
            ApplyRoundedCorners(ToggleButton, 10)
            ApplyGradient(ToggleButton, 
                default and ColorPalette.Success or ColorPalette.Disabled, 
                default and ColorPalette.Success:lerp(Color3.new(0, 0, 0), 0.2) or ColorPalette.Disabled:lerp(Color3.new(0, 0, 0), 0.2)
            )
            
            ToggleButton.MouseButton1Click:Connect(function()
                local newState = not (ToggleButton.BackgroundColor3 == ColorPalette.Success)
                Tween(ToggleButton, {
                    Position = newState and UDim2.new(0.5, 0, 0, 1) or UDim2.new(0, 1, 0, 1)
                }, 0.2, Enum.EasingStyle.Back)
                
                task.wait(0.1)
                ApplyGradient(ToggleButton, 
                    newState and ColorPalette.Success or ColorPalette.Disabled, 
                    newState and ColorPalette.Success:lerp(Color3.new(0, 0, 0), 0.2) or ColorPalette.Disabled:lerp(Color3.new(0, 0, 0), 0.2)
                )
                
                callback(newState)
            end)
            
            if tooltipText then
                CreateTooltip(ToggleHolder, tooltipText)
            end
            
            return ToggleHolder
        end
        
        -- Label
        function Tab.CreateLabel(labelText, isHeader, tooltipText)
            local LabelHolder = Instance.new("Frame")
            LabelHolder.Name = "LabelHolder"
            LabelHolder.BackgroundTransparency = 1
            LabelHolder.Size = UDim2.new(1, 0, 0, isHeader and 40 or 30)
            LabelHolder.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.Font = isHeader and Enum.Font.GothamBold or Enum.Font.Gotham
            Label.Text = labelText
            Label.TextColor3 = isHeader and ColorPalette.Accent or ColorPalette.LightText
            Label.TextSize = isHeader and 18 or 15
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = LabelHolder
            
            if isHeader then
                local Divider = Instance.new("Frame")
                Divider.Name = "Divider"
                Divider.BackgroundColor3 = ColorPalette.Element
                Divider.BorderSizePixel = 0
                Divider.Position = UDim2.new(0, 0, 1, -4)
                Divider.Size = UDim2.new(1, 0, 0, 1)
                Divider.Parent = LabelHolder
            end
            
            if tooltipText then
                CreateTooltip(LabelHolder, tooltipText)
            end
            
            return Label
        end
        
        -- Dropdown Menü
        function Tab.CreateDropdown(dropdownName, options, defaultOption, callback)
            local DropdownHolder = Instance.new("Frame")
            DropdownHolder.Name = "DropdownHolder"
            DropdownHolder.BackgroundTransparency = 1
            DropdownHolder.Size = UDim2.new(1, 0, 0, 50)
            DropdownHolder.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.Font = Enum.Font.Gotham
            Label.Text = dropdownName
            Label.TextColor3 = ColorPalette.Text
            Label.TextSize = 15
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = DropdownHolder
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.BackgroundColor3 = ColorPalette.Element
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Position = UDim2.new(0, 0, 0, 25)
            DropdownButton.Size = UDim2.new(1, 0, 0, 25)
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.Text = defaultOption or "Seçiniz"
            DropdownButton.TextColor3 = ColorPalette.Text
            DropdownButton.TextSize = 14
            DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
            DropdownButton.Parent = DropdownHolder
            
            ApplyRoundedCorners(DropdownButton, 6)
            ApplyGradient(DropdownButton, ColorPalette.Element, Color3.fromRGB(40, 40, 55))
            
            local Arrow = Instance.new("ImageLabel")
            Arrow.Name = "Arrow"
            Arrow.Image = "rbxassetid://6031090990"
            Arrow.BackgroundTransparency = 1
            Arrow.Position = UDim2.new(1, -25, 0.5, -8)
            Arrow.Size = UDim2.new(0, 16, 0, 16)
            Arrow.Parent = DropdownButton
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "DropdownFrame"
            DropdownFrame.BackgroundColor3 = ColorPalette.Element
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Position = UDim2.new(0, 0, 0, 55)
            DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
            DropdownFrame.Visible = false
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = DropdownHolder
            
            ApplyRoundedCorners(DropdownFrame, 6)
            ApplyGradient(DropdownFrame, ColorPalette.Element, Color3.fromRGB(40, 40, 55))
            
            local DropdownLayout = Instance.new("UIListLayout")
            DropdownLayout.Parent = DropdownFrame
            
            -- Seçenekleri oluştur
            for _, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.BackgroundTransparency = 1
                OptionButton.Size = UDim2.new(1, 0, 0, 30)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = "  " .. option
                OptionButton.TextColor3 = ColorPalette.Text
                OptionButton.TextSize = 14
                OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                OptionButton.Parent = DropdownFrame
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownButton.Text = option
                    callback(option)
                    DropdownFrame.Visible = false
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                end)
                
                OptionButton.MouseEnter:Connect(function()
                    Tween(OptionButton, {BackgroundTransparency = 0.8})
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    Tween(OptionButton, {BackgroundTransparency = 1})
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                local isOpen = DropdownFrame.Visible
                DropdownFrame.Visible = not isOpen
                
                if DropdownFrame.Visible then
                    DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, #options * 30)}, 0.2)
                else
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                end
            end)
            
            return DropdownHolder
        end
        
        -- Slider Bileşeni
        function Tab.CreateSlider(sliderName, minValue, maxValue, defaultValue, callback)
            local SliderHolder = Instance.new("Frame")
            SliderHolder.Name = "SliderHolder"
            SliderHolder.BackgroundTransparency = 1
            SliderHolder.Size = UDim2.new(1, 0, 0, 60)
            SliderHolder.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.Font = Enum.Font.Gotham
            Label.Text = sliderName
            Label.TextColor3 = ColorPalette.Text
            Label.TextSize = 15
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderHolder
            
            local ValueLabel = Label:Clone()
            ValueLabel.Name = "ValueLabel"
            ValueLabel.Text = tostring(defaultValue)
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderHolder
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Name = "SliderTrack"
            SliderTrack.BackgroundColor3 = ColorPalette.Element
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Position = UDim2.new(0, 0, 0, 25)
            SliderTrack.Size = UDim2.new(1, 0, 0, 6)
            SliderTrack.Parent = SliderHolder
            ApplyRoundedCorners(SliderTrack, 3)
            ApplyGradient(SliderTrack, ColorPalette.Element, Color3.fromRGB(40, 40, 55))
            
            local SliderProgress = Instance.new("Frame")
            SliderProgress.Name = "SliderProgress"
            SliderProgress.BackgroundColor3 = ColorPalette.Accent
            SliderProgress.BorderSizePixel = 0
            SliderProgress.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
            SliderProgress.Parent = SliderTrack
            ApplyRoundedCorners(SliderProgress, 3)
            ApplyGradient(SliderProgress, ColorPalette.Accent, ColorPalette.Accent2)
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Name = "SliderButton"
            SliderButton.BackgroundColor3 = ColorPalette.Text
            SliderButton.BorderSizePixel = 0
            SliderButton.Size = UDim2.new(0, 16, 0, 16)
            SliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -8, 0.5, -8)
            SliderButton.Text = ""
            SliderButton.Parent = SliderTrack
            ApplyRoundedCorners(SliderButton, 8)
            
            local dragging = false
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = SliderTrack.AbsolutePosition
                    local size = SliderTrack.AbsoluteSize
                    local relativeX = math.clamp(input.Position.X - pos.X, 0, size.X)
                    local value = minValue + (relativeX / size.X) * (maxValue - minValue)
                    value = math.floor(value * 100) / 100 -- 2 ondalık basamak
                    
                    SliderProgress.Size = UDim2.new(relativeX / size.X, 0, 1, 0)
                    SliderButton.Position = UDim2.new(relativeX / size.X, -8, 0.5, -8)
                    ValueLabel.Text = tostring(value)
                    callback(value)
                end
            end)
            
            return SliderHolder
        end
        
        table.insert(Tabs, Tab)
        return Tab
    end
    
    -- Pencereyi açma animasyonu
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Tween(MainFrame, {Size = UDim2.new(0, 450, 0, 520)}, 0.4, Enum.EasingStyle.Back)
    Tween(MainFrame, {Position = UDim2.new(0.3, 0, 0.3, 0)}, 0.4, Enum.EasingStyle.Back)
    
    return Window
end

return DearEmocGui