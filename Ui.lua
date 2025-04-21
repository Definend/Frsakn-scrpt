-- Place this in StarterGui > ScreenGui > LocalScript
-- Create a new ScreenGui first if needed

local UI = {}

-- Default properties
UI.Theme = {
    Background = Color3.fromRGB(30, 30, 30),
    Header = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(0, 120, 215),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    BorderSizePixel = 0,
    CornerRadius = UDim.new(0, 5)
}

-- Create main window
function UI:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = UI.Theme.Background
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UI.Theme.CornerRadius
    corner.Parent = mainFrame
    
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = UI.Theme.Header
    header.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Font = UI.Theme.Font
    titleLabel.TextColor3 = UI.Theme.TextColor
    titleLabel.Size = UDim2.new(1, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -50)
    content.Position = UDim2.new(0, 10, 0, 40)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = content
    
    -- Make window draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    return {
        ScreenGui = screenGui,
        Content = content,
        AddButton = function(self, text, callback)
            -- Button creation code
            local button = Instance.new("TextButton")
            button.Text = text
            button.Font = UI.Theme.Font
            button.TextColor3 = UI.Theme.TextColor
            button.BackgroundColor3 = UI.Theme.Accent
            button.Size = UDim2.new(1, 0, 0, 35)
            button.AutoButtonColor = false
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UI.Theme.CornerRadius
            corner.Parent = button
            
            button.MouseEnter:Connect(function()
                game:GetService("TweenService"):Create(
                    button,
                    TweenInfo.new(0.1),
                    {BackgroundTransparency = 0.2}
                ):Play()
            end)
            
            button.MouseLeave:Connect(function()
                game:GetService("TweenService"):Create(
                    button,
                    TweenInfo.new(0.1),
                    {BackgroundTransparency = 0}
                ):Play()
            end)
            
            button.MouseButton1Click:Connect(callback)
            button.Parent = self.Content
            
            return button
        end,
        
        AddToggle = function(self, text, default, callback)
            -- Toggle creation code
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, 30)
            toggleFrame.BackgroundTransparency = 1
            
            local label = Instance.new("TextLabel")
            label.Text = text
            label.Font = UI.Theme.Font
            label.TextColor3 = UI.Theme.TextColor
            label.Size = UDim2.new(0.6, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = toggleFrame
            
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(0, 50, 0, 25)
            toggle.Position = UDim2.new(1, -50, 0, 2.5)
            toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            toggle.AutoButtonColor = false
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = toggle
            
            local slider = Instance.new("Frame")
            slider.Size = UDim2.new(0, 20, 0, 20)
            slider.Position = UDim2.new(0, 3, 0.5, -10)
            slider.BackgroundColor3 = UI.Theme.TextColor
            slider.Parent = toggle
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(1, 0)
            sliderCorner.Parent = slider
            
            local state = default or false
            local function update()
                state = not state
                if state then
                    slider:TweenPosition(UDim2.new(1, -23, 0.5, -10), "Out", "Quad", 0.1)
                    toggle.BackgroundColor3 = UI.Theme.Accent
                else
                    slider:TweenPosition(UDim2.new(0, 3, 0.5, -10), "Out", "Quad", 0.1)
                    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end
                callback(state)
            end
            
            toggle.MouseButton1Click:Connect(update)
            if default then update() end
            
            toggle.Parent = toggleFrame
            toggleFrame.Parent = self.Content
            
            return toggleFrame
        end,
        
        AddSlider = function(self, text, min, max, default, callback)
            -- Slider creation code
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 50)
            sliderFrame.BackgroundTransparency = 1
            
            local label = Instance.new("TextLabel")
            label.Text = text
            label.Font = UI.Theme.Font
            label.TextColor3 = UI.Theme.TextColor
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sliderFrame
            
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, 0, 0, 5)
            track.Position = UDim2.new(0, 0, 1, -15)
            track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = track
            
            local slider = Instance.new("TextButton")
            slider.Size = UDim2.new(0, 20, 0, 20)
            slider.BackgroundColor3 = UI.Theme.Accent
            slider.AutoButtonColor = false
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(1, 0)
            sliderCorner.Parent = slider
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Text = tostring(default or min)
            valueLabel.Font = UI.Theme.Font
            valueLabel.TextColor3 = UI.Theme.TextColor
            valueLabel.Size = UDim2.new(1, 0, 0, 15)
            valueLabel.Position = UDim2.new(0, 0, 1, 5)
            valueLabel.BackgroundTransparency = 1
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = sliderFrame
            
            local sliding = false
            local function update(input)
                local pos = UDim2.new(
                    math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1),
                    0,
                    0.5,
                    -10
                )
                slider.Position = pos
                local value = math.floor(((pos.X.Scale) * (max - min)) + min)
                valueLabel.Text = tostring(value)
                callback(value)
            end
            
            slider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    update(input)
                end
            end)
            
            slider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
            
            track.Parent = sliderFrame
            slider.Parent = track
            sliderFrame.Parent = self.Content
            
            return sliderFrame
        end
    }
end

return UI
