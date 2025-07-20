--[[
    DearEmocGui v6.0 - Mobil Optimizasyonlu ve Hata Düzeltmeli
    Düzeltmeler:
        1. Toggle'ların çoklu tıklamada bozulması sorunu çözüldü
        2. Yazı renkleri daha okunaklı hale getirildi
        3. Dropdown'ların ZIndex'i arttırıldı
        4. Sekme geçişlerinde renk güncelleme sorunu çözüldü
        5. Mobil için yatay (landscape) düzen eklendi
    Yenilikler:
        - Mobil için optimize edilmiş yatay arayüz
        - Daha açık renk paleti
        - Toggle'lar için state yönetimi iyileştirildi
        - Elementler arası boşluklar artırıldı
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

-- Pencere Oluşturma (Mobil Optimizasyonlu)
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
    function Window.CreateTab(tabName)
        local Tab = {}
        local TabElements = {}
        
        -- Sekme Butonu
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.BackgroundColor3 = ColorPalette.Element
        TabButton.BorderSizePixel = 0
        TabButton.Size = isMobile and UDim2.new(0.9, 0, 0, 40) or UDim2.new(0, 100, 0, 34)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = tabName
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
        
        -- Buton
        function Tab.CreateButton(btnName, callback, accentColor)
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
            Button.Text = btnName
            Button.TextColor3 = ColorPalette.Text
            Button.TextSize = isMobile and 14 or 15
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
        
        -- Toggle (State yönetimi düzeltildi)
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
            ApplyGradient(ToggleButton, 
                default and ColorPalette.Success or ColorPalette.Disabled, 
                default and ColorPalette.Success:lerp(Color3.new(0, 0, 0), 0.2) or ColorPalette.Disabled:lerp(Color3.new(0, 0, 0), 0.2)
            )
            
            -- State yönetimi için değişken
            local currentState = default
            
            ToggleButton.MouseButton1Click:Connect(function()
                currentState = not currentState
                
                Tween(ToggleButton, {
                    Position = currentState and UDim2.new(0.5, 0, 0, 1) or UDim2.new(0, 1, 0, 1)
                }, 0.2, Enum.EasingStyle.Back)
                
                task.wait(0.1)
                ApplyGradient(ToggleButton, 
                    currentState and ColorPalette.Success or ColorPalette.Disabled, 
                    currentState and ColorPalette.Success:lerp(Color3.new(0, 0, 0), 0.2) or ColorPalette.Disabled:lerp(Color3.new(0, 0, 0), 0.2)
                )
                
                callback(currentState)
            end)
            
            return ToggleHolder
        end
        
        -- Label
        function Tab.CreateLabel(labelText, isHeader)
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
            Label.TextColor3 = isHeader and ColorPalette.Accent or ColorPalette.LightText
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
        
        -- Dropdown Menü (ZIndex arttırıldı)
        function Tab.CreateDropdown(dropdownName, options, defaultOption, callback)
            local DropdownHolder = Instance.new("Frame")
            DropdownHolder.Name = "DropdownHolder"
            DropdownHolder.BackgroundTransparency = 1
            DropdownHolder.Size = UDim2.new(1, 0, 0, isMobile and 60 or 50)
            DropdownHolder.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.Font = Enum.Font.Gotham
            Label.Text = dropdownName
            Label.TextColor3 = ColorPalette.Text
            Label.TextSize = isMobile and 14 or 15
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = DropdownHolder
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.BackgroundColor3 = ColorPalette.Element
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Position = UDim2.new(0, 0, 0, 25)
            DropdownButton.Size = UDim2.new(1, 0, 0, isMobile and 35 or 25)
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.Text = defaultOption or "Seçiniz"
            DropdownButton.TextColor3 = ColorPalette.Text
            DropdownButton.TextSize = isMobile and 13 or 14
            DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
            DropdownButton.ZIndex = 20
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
            DropdownFrame.Position = UDim2.new(0, 0, 0, isMobile and 65 or 55)
            DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
            DropdownFrame.Visible = false
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.ZIndex = 50 -- Yüksek ZIndex
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
                OptionButton.Size = UDim2.new(1, 0, 0, isMobile and 35 or 30)
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.Text = "  " .. option
                OptionButton.TextColor3 = ColorPalette.Text
                OptionButton.TextSize = isMobile and 13 or 14
                OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                OptionButton.ZIndex = 60 -- Yüksek ZIndex
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
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, #options * (isMobile and 35 or 30))}, 0.2)
                else
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                end
            end)
            
            return DropdownHolder
        end
        
        table.insert(Tabs, Tab)
        return Tab
    end
    
    -- Pencereyi açma animasyonu
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Tween(MainFrame, {Size = UDim2.new(0, windowWidth, 0, windowHeight)}, 0.4, Enum.EasingStyle.Back)
    Tween(MainFrame, {Position = UDim2.new(0.3, 0, 0.3, 0)}, 0.4, Enum.EasingStyle.Back)
    
    return Window
end

return DearEmocGui
