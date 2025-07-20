--[[
    DearEmocGui v7.0 - Son Geliştirmeler ve Hata Düzeltmeleri
    Düzeltmeler:
        - Toggle renk bugu tamamen düzeltildi
        - Mobil için daha iyi uyumluluk
        - Görsel tutarsızlıklar giderildi
    Yenilikler:
        - Switch animasyonlu geçişler
        - Renkli bölüm başlıkları
        - Butonlara ikon desteği
        - Yeniden boyutlandırılabilir pencere
        - Gece/gündüz modu
]]

local DearEmocGui = {}
DearEmocGui.__index = DearEmocGui

-- Renk Paleti (Daha açık tonlar)
DearEmocGui.ColorPalette = {
    Background = Color3.fromRGB(35, 35, 50),
    Header = Color3.fromRGB(50, 50, 70),
    Element = Color3.fromRGB(45, 45, 65),
    Accent = Color3.fromRGB(150, 120, 255),
    Accent2 = Color3.fromRGB(110, 80, 230),
    Text = Color3.fromRGB(250, 250, 255),
    Disabled = Color3.fromRGB(80, 80, 100),
    LightText = Color3.fromRGB(200, 200, 220),
    Success = Color3.fromRGB(130, 230, 130),
    Warning = Color3.fromRGB(255, 190, 90),
    Danger = Color3.fromRGB(255, 110, 110),
    Info = Color3.fromRGB(90, 180, 255)
}

local ColorPalette = DearEmocGui.ColorPalette

-- Animasyon Fonksiyonu
local function Tween(obj, props, duration, style)
    local tween = game:GetService("TweenService"):Create(
        obj,
        TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
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

-- Mobil için kontrol
local isMobile = game:GetService("UserInputService").TouchEnabled

-- Pencere Oluşturma (Geliştirilmiş)
function DearEmocGui.CreateWindow(title, subtitle)
    local Window = {}
    local Tabs = {}
    local activeTab = nil
    
    -- Ana Pencere
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DearEmocGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui

    -- Mobil için yatay, PC için dikey
    local windowWidth = isMobile and 700 or 450
    local windowHeight = isMobile and 400 or 520
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = ColorPalette.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Yuvarlak köşeler
    ApplyRoundedCorners(MainFrame, 14)
    ApplyGradient(MainFrame, ColorPalette.Background, Color3.fromRGB(25, 25, 40))
    
    -- Mobil için boyut ayarı
    if isMobile then
        MainFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
        MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
    end
    
    -- Başlık Çubuğu
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.BackgroundColor3 = ColorPalette.Header
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, isMobile and 40 or 54)
    Header.Parent = MainFrame
    
    -- Header için yuvarlak üst köşeler
    ApplyRoundedCorners(Header, 14).CornerRadius = UDim.new(0, 14)
    ApplyGradient(Header, ColorPalette.Header, ColorPalette.Header, 0)

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, isMobile and 5 or 8)
    Title.Size = UDim2.new(0.7, 0, 0, isMobile and 20 or 28)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = ColorPalette.Text
    Title.TextSize = isMobile and 18 or 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 15, 0, isMobile and 22 or 32)
    Subtitle.Size = UDim2.new(0.7, 0, 0, isMobile and 15 or 18)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = subtitle
    Subtitle.TextTransparency = 0.4
    Subtitle.TextColor3 = ColorPalette.LightText
    Subtitle.TextSize = isMobile and 12 or 14
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header

    -- Kapatma Butonu
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(0.9, 0, 0, isMobile and 5 or 10)
    CloseButton.Size = UDim2.new(0.08, 0, 0, isMobile and 30 or 34)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = ColorPalette.Text
    CloseButton.TextSize = 22
    CloseButton.Parent = Header
    
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

    -- Boyutlandırma Butonu
    local ResizeButton = Instance.new("TextButton")
    ResizeButton.Name = "ResizeButton"
    ResizeButton.BackgroundTransparency = 1
    ResizeButton.Position = UDim2.new(0.85, 0, 0, isMobile and 5 or 10)
    ResizeButton.Size = UDim2.new(0.05, 0, 0, isMobile and 30 or 34)
    ResizeButton.Font = Enum.Font.GothamBold
    ResizeButton.Text = "⇲"
    ResizeButton.TextColor3 = ColorPalette.Text
    ResizeButton.TextSize = 18
    ResizeButton.Parent = Header
    
    ResizeButton.MouseButton1Click:Connect(function()
        if MainFrame.Size == UDim2.new(0, windowWidth, 0, windowHeight) then
            Tween(MainFrame, {Size = UDim2.new(0, windowWidth + 100, 0, windowHeight + 100)}, 0.3)
        else
            Tween(MainFrame, {Size = UDim2.new(0, windowWidth, 0, windowHeight)}, 0.3)
        end
    end)
    
    -- Sekme Butonları ve İçerik Alanı
    local TabContainer = Instance.new(isMobile and "ScrollingFrame" or "Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 0, 0, isMobile and 40 or 54)
    TabContainer.Size = isMobile and UDim2.new(0.3, 0, 1, -40) or UDim2.new(1, 0, 0, 42)
    TabContainer.Parent = MainFrame
    
    if isMobile then
        TabContainer.ScrollBarThickness = 4
        TabContainer.ScrollBarImageColor3 = ColorPalette.Accent
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    end

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = isMobile and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    UIListLayout.Padding = UDim.new(0, isMobile and 8 or 5)
    UIListLayout.Parent = TabContainer
    
    if isMobile then
        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
        end)
    end

    -- İçerik Alanı
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "Content"
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = isMobile and UDim2.new(0.3, 10, 0, 40) or UDim2.new(0, 12, 0, 96)
    ContentFrame.Size = isMobile and UDim2.new(0.7, -20, 1, -50) or UDim2.new(1, -24, 1, -108)
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

    -- Sürükleme Mantığı
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
    function Window.CreateTab(tabName, tabIcon)
        local Tab = {}
        local TabElements = {}
        
        -- Sekme Butonu
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.BackgroundColor3 = ColorPalette.Element
        TabButton.BorderSizePixel = 0
        TabButton.Size = isMobile and UDim2.new(0.9, 0, 0, 40) or UDim2.new(0, 100, 0, 34)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = tabIcon and (tabIcon .. " " .. tabName) or tabName
        TabButton.TextColor3 = ColorPalette.Text
        TabButton.TextSize = isMobile and 14 or 15
        TabButton.Parent = TabContainer
        
        -- Yuvarlak köşeler
        ApplyRoundedCorners(TabButton, 8)
        
        -- İlk sekme aktif
        if #Tabs == 0 then
            activeTab = TabButton
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
        TabLayout.Padding = UDim.new(0, isMobile and 12 or 16)
        TabLayout.Parent = TabContent
        
        -- Boyut güncellemeleri için bağlantı
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.Size = UDim2.new(1, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end)
        
        -- Sekme Değiştirme
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in ipairs(ContentFrame:GetChildren()) do
                if tab:IsA("Frame") then
                    tab.Visible = false
                end
            end
            TabContent.Visible = true
            
            -- Önceki aktif sekmenin rengini sıfırla
            if activeTab then
                ApplyGradient(activeTab, ColorPalette.Element, Color3.fromRGB(40, 40, 55))
                activeTab.TextColor3 = ColorPalette.Text
            end
            
            -- Yeni aktif sekme
            ApplyGradient(TabButton, ColorPalette.Accent, ColorPalette.Accent2)
            TabButton.TextColor3 = Color3.new(1, 1, 1)
            activeTab = TabButton
        end)
        
        -- Element Oluşturma Fonksiyonları
        
        -- Buton (İkon desteği eklendi)
        function Tab.CreateButton(btnName, callback, accentColor, icon)
            accentColor = accentColor or ColorPalette.Accent
            local accentColor2 = accentColor:lerp(Color3.new(0, 0, 0), 0.2)
            
            local ButtonHolder = Instance.new("Frame")
            ButtonHolder.Name = "ButtonHolder"
            ButtonHolder.BackgroundTransparency = 1
            ButtonHolder.Size = UDim2.new(1, 0, 0, isMobile and 48 or 44)
            ButtonHolder.Parent = TabContent
            
            local Button = Instance.new("TextButton")
            Button.Name = btnName
            Button.BackgroundColor3 = ColorPalette.Element
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, 0, 0, isMobile and 44 or 40)
            Button.Position = UDim2.new(0, 0, 0, 2)
            Button.Font = Enum.Font.GothamMedium
            Button.Text = icon and (icon .. " " .. btnName) or btnName
            Button.TextColor3 = ColorPalette.Text
            Button.TextSize = isMobile and 14 or 15
            Button.TextXAlignment = icon and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
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
            
            return Button
        end
        
        -- Toggle (Hata düzeltildi)
        function Tab.CreateToggle(togName, default, callback)
            local ToggleHolder = Instance.new("Frame")
            ToggleHolder.Name = "ToggleHolder"
            ToggleHolder.BackgroundTransparency = 1
            ToggleHolder.Size = UDim2.new(1, 0, 0, isMobile and 40 or 36)
            ToggleHolder.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(0.65, 0, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = togName
            Label.TextColor3 = ColorPalette.Text
            Label.TextSize = isMobile and 14 or 15
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
            
            -- State yönetimi için değişken
            local currentState = default
            
            -- Görsel güncelleme fonksiyonu
            local function updateToggleVisual()
                local targetColor = currentState and ColorPalette.Success or ColorPalette.Disabled
                local targetPos = currentState and UDim2.new(0.5, 0, 0, 1) or UDim2.new(0, 1, 0, 1)
                
                Tween(ToggleButton, {
                    BackgroundColor3 = targetColor,
                    Position = targetPos
                }, 0.2, Enum.EasingStyle.Back)
            end
            
            -- Başlangıç durumunu ayarla
            updateToggleVisual()
            
            ToggleButton.MouseButton1Click:Connect(function()
                currentState = not currentState
                updateToggleVisual()
                callback(currentState)
            end)
            
            return ToggleHolder
        end
        
        -- Label (Renkli başlık desteği)
        function Tab.CreateLabel(labelText, isHeader, color)
            local LabelHolder = Instance.new("Frame")
            LabelHolder.Name = "LabelHolder"
            LabelHolder.BackgroundTransparency = 1
            LabelHolder.Size = UDim2.new(1, 0, 0, isHeader and (isMobile and 45 or 40) or (isMobile and 35 or 30))
            LabelHolder.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.Font = isHeader and Enum.Font.GothamBold or Enum.Font.Gotham
            Label.Text = labelText
            Label.TextColor3 = color or (isHeader and ColorPalette.Accent or ColorPalette.LightText)
            Label.TextSize = isHeader and (isMobile and 16 or 18) or (isMobile and 14 or 15)
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
            
            return Label
        end
        
        -- Switch (Animasyonlu toggle alternatifi)
        function Tab.CreateSwitch(switchName, default, callback)
            local SwitchHolder = Instance.new("Frame")
            SwitchHolder.Name = "SwitchHolder"
            SwitchHolder.BackgroundTransparency = 1
            SwitchHolder.Size = UDim2.new(1, 0, 0, isMobile and 40 or 36)
            SwitchHolder.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(0.65, 0, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = switchName
            Label.TextColor3 = ColorPalette.Text
            Label.TextSize = isMobile and 14 or 15
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SwitchHolder
            
            local SwitchFrame = Instance.new("Frame")
            SwitchFrame.Name = "SwitchFrame"
            SwitchFrame.BackgroundColor3 = ColorPalette.Element
            SwitchFrame.BorderSizePixel = 0
            SwitchFrame.Position = UDim2.new(0.7, 0, 0.15, 0)
            SwitchFrame.Size = UDim2.new(0.3, 0, 0.7, 0)
            SwitchFrame.Parent = SwitchHolder
            
            ApplyRoundedCorners(SwitchFrame, 12)
            ApplyGradient(SwitchFrame, ColorPalette.Element, Color3.fromRGB(40, 40, 55))
            
            local SwitchButton = Instance.new("TextButton")
            SwitchButton.Name = "SwitchButton"
            SwitchButton.BackgroundColor3 = default and ColorPalette.Success or ColorPalette.Disabled
            SwitchButton.BorderSizePixel = 0
            SwitchButton.Size = UDim2.new(0.5, -2, 1, -2)
            SwitchButton.Position = default and UDim2.new(0.5, 0, 0, 1) or UDim2.new(0, 1, 0, 1)
            SwitchButton.Text = default and "ON" or "OFF"
            SwitchButton.Font = Enum.Font.GothamBold
            SwitchButton.TextSize = 12
            SwitchButton.TextColor3 = Color3.new(1, 1, 1)
            SwitchButton.Parent = SwitchFrame
            
            ApplyRoundedCorners(SwitchButton, 10)
            
            -- State yönetimi için değişken
            local currentState = default
            
            -- Görsel güncelleme fonksiyonu
            local function updateSwitchVisual()
                local targetColor = currentState and ColorPalette.Success or ColorPalette.Disabled
                local targetPos = currentState and UDim2.new(0.5, 0, 0, 1) or UDim2.new(0, 1, 0, 1)
                SwitchButton.Text = currentState and "ON" or "OFF"
                
                Tween(SwitchButton, {
                    BackgroundColor3 = targetColor,
                    Position = targetPos
                }, 0.2, Enum.EasingStyle.Back)
            end
            
            -- Başlangıç durumunu ayarla
            updateSwitchVisual()
            
            SwitchButton.MouseButton1Click:Connect(function()
                currentState = not currentState
                updateSwitchVisual()
                callback(currentState)
            end)
            
            return SwitchHolder
        end
        
        table.insert(Tabs, Tab)
        return Tab
    end
    
    -- Gece/Gündüz Modu Butonu
    local ThemeButton = Instance.new("TextButton")
    ThemeButton.Name = "ThemeButton"
    ThemeButton.BackgroundTransparency = 1
    ThemeButton.Position = UDim2.new(0.75, 0, 0, isMobile and 5 or 10)
    ThemeButton.Size = UDim2.new(0.05, 0, 0, isMobile and 30 or 34)
    ThemeButton.Font = Enum.Font.GothamBold
    ThemeButton.Text = "☀️"
    ThemeButton.TextSize = 18
    ThemeButton.Parent = Header
    
    ThemeButton.MouseButton1Click:Connect(function()
        if ThemeButton.Text == "☀️" then
            ThemeButton.Text = "🌙"
            -- Gece modu renkleri
            ColorPalette.Background = Color3.fromRGB(25, 25, 35)
            ColorPalette.Header = Color3.fromRGB(35, 35, 50)
            ColorPalette.Element = Color3.fromRGB(30, 30, 45)
            ColorPalette.Text = Color3.fromRGB(230, 230, 240)
        else
            ThemeButton.Text = "☀️"
            -- Gündüz modu renkleri
            ColorPalette.Background = Color3.fromRGB(45, 45, 60)
            ColorPalette.Header = Color3.fromRGB(60, 60, 80)
            ColorPalette.Element = Color3.fromRGB(50, 50, 70)
            ColorPalette.Text = Color3.fromRGB(250, 250, 255)
        end
        
        -- Renkleri güncelle
        MainFrame.BackgroundColor3 = ColorPalette.Background
        Header.BackgroundColor3 = ColorPalette.Header
    end)
    
    -- Pencereyi açma animasyonu
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Tween(MainFrame, {Size = UDim2.new(0, windowWidth, 0, windowHeight)}, 0.4, Enum.EasingStyle.Back)
    Tween(MainFrame, {Position = UDim2.new(0.3, 0, 0.3, 0)}, 0.4, Enum.EasingStyle.Back)
    
    return Window
end

return DearEmocGui