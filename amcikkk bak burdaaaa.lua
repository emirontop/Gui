-- GuiLibrary.lua
local GuiLibrary = {}
GuiLibrary.__index = GuiLibrary

-- Renkler
local colors = {
    background = Color3.fromRGB(30, 30, 40),
    tabBar = Color3.fromRGB(25, 25, 35),
    tab = Color3.fromRGB(40, 40, 50),
    tabHover = Color3.fromRGB(50, 50, 65),
    tabActive = Color3.fromRGB(70, 70, 90),
    section = Color3.fromRGB(40, 40, 55),
    button = Color3.fromRGB(80, 120, 200),
    buttonHover = Color3.fromRGB(100, 140, 220),
    text = Color3.fromRGB(240, 240, 240),
    accent = Color3.fromRGB(100, 200, 255),
    toggleOn = Color3.fromRGB(100, 200, 100),
    toggleOff = Color3.fromRGB(120, 120, 120),
    sliderTrack = Color3.fromRGB(70, 70, 90),
    sliderThumb = Color3.fromRGB(120, 170, 255),
}

-- Yeni pencere oluştur
function GuiLibrary.new(title, version)
    local player = game:GetService("Players").LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "GuiLibrary"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")
    
    local self = setmetatable({
        gui = gui,
        tabs = {},
        currentTab = nil,
        draggable = true,
    }, GuiLibrary)
    
    self:createMainWindow(title, version)
    return self
end

-- Ana pencere bileşenlerini oluştur
function GuiLibrary:createMainWindow(title, version)
    -- Ana konteyner
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    
    -- Ekran boyutuna göre ayarla
    local screenSize = workspace.CurrentCamera.ViewportSize
    local width = math.min(600, screenSize.X * 0.9)
    local height = math.min(500, screenSize.Y * 0.8)
    
    mainFrame.Size = UDim2.new(0, width, 0, height)
    
    -- İstenilen değişiklik: Tam ortala
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    mainFrame.BackgroundColor3 = colors.background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = self.gui
    
    -- Üst bar (sürükleme için)
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = colors.tabBar
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = colors.text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar
    
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Name = "Version"
    versionLabel.Text = version
    versionLabel.Size = UDim2.new(0, 50, 1, 0)
    versionLabel.Position = UDim2.new(0, 210, 0, 0)
    versionLabel.BackgroundTransparency = 1
    versionLabel.TextColor3 = colors.accent
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextSize = 16
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.Parent = topBar
    
    -- Kapatma butonu
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0.5, -15)
    closeButton.AnchorPoint = Vector2.new(1, 0.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeButton.Text = "X"
    closeButton.TextColor3 = colors.text
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.AutoButtonColor = false
    closeButton.Parent = topBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    -- Sekme konteyneri (kaydırmalı)
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, -20, 0, 40)
    tabContainer.Position = UDim2.new(0, 10, 0, 45)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 4
    tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContainer.ScrollingDirection = Enum.ScrollingDirection.X
    tabContainer.VerticalScrollBarInset = Enum.ScrollBarInset.None
    tabContainer.Parent = mainFrame
    
    local tabList = Instance.new("UIListLayout")
    tabList.Name = "TabList"
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 5)
    tabList.Parent = tabContainer
    
    -- İçerik alanı
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -150)
    contentFrame.Position = UDim2.new(0, 10, 0, 95)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 6
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.Parent = mainFrame
    
    local contentList = Instance.new("UIListLayout")
    contentList.Name = "ContentList"
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Padding = UDim.new(0, 15)
    contentList.Parent = contentFrame
    
    -- Alt buton
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "ButtonFrame"
    buttonFrame.Size = UDim2.new(1, -20, 0, 40)
    buttonFrame.Position = UDim2.new(0, 10, 1, -50)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = mainFrame
    
    local actionButton = Instance.new("TextButton")
    actionButton.Name = "ActionButton"
    actionButton.Size = UDim2.new(1, 0, 1, 0)
    actionButton.BackgroundColor3 = colors.button
    actionButton.BorderSizePixel = 0
    actionButton.Text = "Button isim!"
    actionButton.TextColor3 = colors.text
    actionButton.Font = Enum.Font.GothamBold
    actionButton.TextSize = 16
    actionButton.AutoButtonColor = false
    actionButton.Parent = buttonFrame
    
    -- Buton etkileşimleri
    actionButton.MouseEnter:Connect(function()
        actionButton.BackgroundColor3 = colors.buttonHover
    end)
    
    actionButton.MouseLeave:Connect(function()
        actionButton.BackgroundColor3 = colors.button
    end)
    
    -- Kapatma butonu etkileşimi
    closeButton.MouseButton1Click:Connect(function()
        self.mainFrame.Visible = false
    end)
    
    -- Sürükleme özelliği
    local dragging = false
    local dragStart, frameStart
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            frameStart = self.mainFrame.Position
        end
    end)
    
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.mainFrame.Position = UDim2.new(
                frameStart.X.Scale, 
                frameStart.X.Offset + delta.X,
                frameStart.Y.Scale, 
                frameStart.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Referansları sakla
    self.mainFrame = mainFrame
    self.tabContainer = tabContainer
    self.contentFrame = contentFrame
    self.actionButton = actionButton
end

-- Yeni sekme ekle
function GuiLibrary:addTab(name)
    local tab = {
        name = name,
        sections = {}
    }
    
    -- Sekme butonu oluştur
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name
    tabButton.AutomaticSize = Enum.AutomaticSize.X
    tabButton.Size = UDim2.new(0, 0, 1, 0)
    tabButton.BackgroundColor3 = colors.tab
    tabButton.BorderSizePixel = 0
    tabButton.Text = name
    tabButton.TextColor3 = colors.text
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 14
    tabButton.Parent = self.tabContainer
    
    -- Dolgu ekle
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.Parent = tabButton
    
    -- Sekme butonu etkileşimleri
    tabButton.MouseEnter:Connect(function()
        if self.currentTab ~= tab then
            tabButton.BackgroundColor3 = colors.tabHover
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.currentTab ~= tab then
            tabButton.BackgroundColor3 = colors.tab
        end
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        self:selectTab(tab)
    end)
    
    -- Sekmeler listesine ekle
    table.insert(self.tabs, tab)
    
    -- İlk sekmeyi seç
    if #self.tabs == 1 then
        self:selectTab(tab)
    end
    
    return tab
end

-- Sekme seç
function GuiLibrary:selectTab(tab)
    -- Güncel sekmeyi güncelle
    self.currentTab = tab
    
    -- İçeriği temizle
    for _, child in ipairs(self.contentFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Aktif sekmeyi vurgula
    for _, t in ipairs(self.tabs) do
        local tabButton = self.tabContainer:FindFirstChild(t.name)
        if tabButton then
            if t == tab then
                tabButton.BackgroundColor3 = colors.tabActive
                tabButton.Font = Enum.Font.GothamBold
            else
                tabButton.BackgroundColor3 = colors.tab
                tabButton.Font = Enum.Font.Gotham
            end
        end
    end
    
    -- Sekme içeriğini ekle
    for _, section in ipairs(tab.sections) do
        self:createSection(section)
    end
end

-- Sekmeye bölüm ekle
function GuiLibrary:addSection(tab, name)
    -- Hata kontrolü
    if not tab or type(tab) ~= "table" then
        error("Geçersiz sekme: addSection için tab bekleniyor")
    end
    
    local section = {
        name = name,
        elements = {}
    }
    
    table.insert(tab.sections, section)
    
    -- Eğer bu sekme aktifse, hemen ekle
    if self.currentTab == tab then
        self:createSection(section)
    end
    
    return section
end

-- Bölüm UI oluştur
function GuiLibrary:createSection(section)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = section.name
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.Size = UDim2.new(1, 0, 0, 0)
    sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    sectionFrame.LayoutOrder = #self.contentFrame:GetChildren()
    sectionFrame.Parent = self.contentFrame
    
    -- Bölüm başlığı
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = section.name
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = colors.accent
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = sectionFrame
    
    -- Öğeler konteyneri
    local elementsFrame = Instance.new("Frame")
    elementsFrame.Name = "Elements"
    elementsFrame.BackgroundColor3 = colors.section
    elementsFrame.Size = UDim2.new(1, 0, 0, 0)
    elementsFrame.AutomaticSize = Enum.AutomaticSize.Y
    elementsFrame.Parent = sectionFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = elementsFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.Parent = elementsFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = elementsFrame
    
    -- Öğeleri ekle
    for _, element in ipairs(section.elements) do
        if element.type == "button" then
            self:createButton(elementsFrame, element)
        elseif element.type == "toggle" then
            self:createToggle(elementsFrame, element)
        elseif element.type == "slider" then
            self:createSlider(elementsFrame, element)
        elseif element.type == "dropdown" then
            self:createDropdown(elementsFrame, element)
        elseif element.type == "label" then
            self:createLabel(elementsFrame, element)
        end
    end
end

-- Bölüme buton ekle
function GuiLibrary:addButton(section, text, callback)
    local button = {
        type = "button",
        text = text,
        callback = callback
    }
    
    table.insert(section.elements, button)
    
    -- Eğer bölüm görünürse, hemen ekle
    if self.currentTab and table.find(self.currentTab.sections, section) then
        local sectionFrame = self.contentFrame:FindFirstChild(section.name)
        if sectionFrame then
            local elementsFrame = sectionFrame:FindFirstChild("Elements")
            if elementsFrame then
                self:createButton(elementsFrame, button)
            end
        end
    end
    
    return button
end

-- Buton UI oluştur
function GuiLibrary:createButton(parent, button)
    local buttonFrame = Instance.new("TextButton")
    buttonFrame.Name = button.text
    buttonFrame.Size = UDim2.new(1, 0, 0, 35)
    buttonFrame.BackgroundColor3 = colors.button
    buttonFrame.Text = button.text
    buttonFrame.TextColor3 = colors.text
    buttonFrame.Font = Enum.Font.Gotham
    buttonFrame.TextSize = 14
    buttonFrame.AutoButtonColor = false
    buttonFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = buttonFrame
    
    -- Buton etkileşimleri
    buttonFrame.MouseEnter:Connect(function()
        buttonFrame.BackgroundColor3 = colors.buttonHover
    end)
    
    buttonFrame.MouseLeave:Connect(function()
        buttonFrame.BackgroundColor3 = colors.button
    end)
    
    buttonFrame.MouseButton1Click:Connect(function()
        if button.callback then
            button.callback()
        end
    end)
end

-- Bölüme toggle ekle
function GuiLibrary:addToggle(section, text, default, callback)
    local toggle = {
        type = "toggle",
        text = text,
        value = default or false,
        callback = callback
    }
    
    table.insert(section.elements, toggle)
    
    -- Eğer bölüm görünürse, hemen ekle
    if self.currentTab and table.find(self.currentTab.sections, section) then
        local sectionFrame = self.contentFrame:FindFirstChild(section.name)
        if sectionFrame then
            local elementsFrame = sectionFrame:FindFirstChild("Elements")
            if elementsFrame then
                self:createToggle(elementsFrame, toggle)
            end
        end
    end
    
    return toggle
end

-- Toggle UI oluştur
function GuiLibrary:createToggle(parent, toggle)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = toggle.text
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "Label"
    toggleLabel.Text = toggle.text
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.TextColor3 = colors.text
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0.3, 0, 1, 0)
    toggleButton.Position = UDim2.new(0.7, 0, 0, 0)
    toggleButton.BackgroundColor3 = toggle.value and colors.toggleOn or colors.toggleOff
    toggleButton.Text = toggle.value and "ON" or "OFF"
    toggleButton.TextColor3 = colors.text
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.TextSize = 14
    toggleButton.AutoButtonColor = false
    toggleButton.Parent = toggleFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = toggleButton
    
    -- Toggle etkileşimleri
    toggleButton.MouseButton1Click:Connect(function()
        toggle.value = not toggle.value
        toggleButton.BackgroundColor3 = toggle.value and colors.toggleOn or colors.toggleOff
        toggleButton.Text = toggle.value and "ON" or "OFF"
        
        if toggle.callback then
            toggle.callback(toggle.value)
        end
    end)
end

-- Bölüme slider ekle
function GuiLibrary:addSlider(section, text, min, max, default, callback)
    local slider = {
        type = "slider",
        text = text,
        min = min or 0,
        max = max or 100,
        value = default or 50,
        callback = callback
    }
    
    table.insert(section.elements, slider)
    
    -- Eğer bölüm görünürse, hemen ekle
    if self.currentTab and table.find(self.currentTab.sections, section) then
        local sectionFrame = self.contentFrame:FindFirstChild(section.name)
        if sectionFrame then
            local elementsFrame = sectionFrame:FindFirstChild("Elements")
            if elementsFrame then
                self:createSlider(elementsFrame, slider)
            end
        end
    end
    
    return slider
end

-- Slider UI oluştur
function GuiLibrary:createSlider(parent, slider)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = slider.text
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Text = slider.text
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.TextColor3 = colors.text
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextSize = 14
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Text = tostring(slider.value)
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Position = UDim2.new(1, -40, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = colors.accent
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, 25)
    track.BackgroundColor3 = colors.sliderTrack
    track.Parent = sliderFrame
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((slider.value - slider.min) / (slider.max - slider.min), 0, 1, 0)
    fill.BackgroundColor3 = colors.sliderThumb
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    local thumb = Instance.new("Frame")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, 20, 0, 20)
    thumb.Position = UDim2.new(fill.Size.X.Scale, -10, 0.5, -10)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.BackgroundColor3 = colors.sliderThumb
    thumb.Parent = track
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 10)
    thumbCorner.Parent = thumb
    
    -- Slider etkileşimleri
    local dragging = false
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            
            local position = input.Position.X - track.AbsolutePosition.X
            local percent = math.clamp(position / track.AbsoluteSize.X, 0, 1)
            local newValue = math.floor(slider.min + (slider.max - slider.min) * percent)
            
            slider.value = newValue
            valueLabel.Text = tostring(newValue)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            thumb.Position = UDim2.new(percent, -10, 0.5, -10)
            
            if slider.callback then
                slider.callback(newValue)
            end
        end
    end)
    
    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local position = input.Position.X - track.AbsolutePosition.X
            local percent = math.clamp(position / track.AbsoluteSize.X, 0, 1)
            local newValue = math.floor(slider.min + (slider.max - slider.min) * percent)
            
            slider.value = newValue
            valueLabel.Text = tostring(newValue)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            thumb.Position = UDim2.new(percent, -10, 0.5, -10)
            
            if slider.callback then
                slider.callback(newValue)
            end
        end
    end)
end

-- Bölüme açılır menü ekle
function GuiLibrary:addDropdown(section, text, options, default, callback)
    local dropdown = {
        type = "dropdown",
        text = text,
        options = options,
        value = default or options[1],
        callback = callback,
        open = false
    }
    
    table.insert(section.elements, dropdown)
    
    -- Eğer bölüm görünürse, hemen ekle
    if self.currentTab and table.find(self.currentTab.sections, section) then
        local sectionFrame = self.contentFrame:FindFirstChild(section.name)
        if sectionFrame then
            local elementsFrame = sectionFrame:FindFirstChild("Elements")
            if elementsFrame then
                self:createDropdown(elementsFrame, dropdown)
            end
        end
    end
    
    return dropdown
end

-- Açılır menü UI oluştur
function GuiLibrary:createDropdown(parent, dropdown)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = dropdown.text
    dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    dropdownFrame.BackgroundTransparency = 1
    dropdownFrame.Parent = parent
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(1, 0, 0, 35)
    dropdownButton.BackgroundColor3 = colors.button
    dropdownButton.Text = dropdown.text .. ": " .. dropdown.value
    dropdownButton.TextColor3 = colors.text
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.TextSize = 14
    dropdownButton.AutoButtonColor = false
    dropdownButton.Parent = dropdownFrame
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 4)
    dropdownCorner.Parent = dropdownButton
    
    local dropdownList = Instance.new("Frame")
    dropdownList.Name = "DropdownList"
    dropdownList.Size = UDim2.new(1, 0, 0, 0)
    dropdownList.Position = UDim2.new(0, 0, 0, 40)
    dropdownList.BackgroundColor3 = colors.section
    dropdownList.Visible = false
    dropdownList.Parent = dropdownFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = dropdownList
    
    -- Seçenekleri ekle
    for _, option in ipairs(dropdown.options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.BackgroundColor3 = colors.tab
        optionButton.Text = option
        optionButton.TextColor3 = colors.text
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextSize = 14
        optionButton.AutoButtonColor = false
        optionButton.Parent = dropdownList
        
        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 4)
        optionCorner.Parent = optionButton
        
        optionButton.MouseEnter:Connect(function()
            optionButton.BackgroundColor3 = colors.tabHover
        end)
        
        optionButton.MouseLeave:Connect(function()
            optionButton.BackgroundColor3 = colors.tab
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            dropdown.value = option
            dropdownButton.Text = dropdown.text .. ": " .. option
            dropdownList.Visible = false
            
            if dropdown.callback then
                dropdown.callback(option)
            end
        end)
    end
    
    -- Dropdown etkileşimleri
    dropdownButton.MouseButton1Click:Connect(function()
        dropdown.open = not dropdown.open
        dropdownList.Visible = dropdown.open
        
        -- Liste boyutunu güncelle
        dropdownList.Size = UDim2.new(1, 0, 0, #dropdown.options * 35 + (#dropdown.options - 1) * 5)
    end)
end

-- Alt buton için callback ayarla
function GuiLibrary:setActionButtonCallback(callback)
    self.actionButton.MouseButton1Click:Connect(callback)
end

-- GUI görünürlüğünü değiştir
function GuiLibrary:toggle()
    self.mainFrame.Visible = not self.mainFrame.Visible
end

return GuiLibrary