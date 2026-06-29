-- ============================================
-- 🚀 ELERIUM ULTRA - Next-Gen UI Library
-- ============================================
-- Features:
-- ✅ Spring physics (bouncy animations)
-- ✅ Layout animations (enter/exit)
-- ✅ Gesture composability (drag/swipe)
-- ✅ Motion values (60fps drivers)
-- ✅ Shared element transitions
-- ✅ Variants + stagger animations
-- ✅ AnimatePresence
-- ✅ Label images
-- ============================================

-- ============================================
-- 📦 CONFIGURATION
-- ============================================
local ui_options = {
    main_color = Color3.fromRGB(120, 80, 255),
    accent_color = Color3.fromRGB(0, 200, 255),
    bg_color = Color3.fromRGB(18, 18, 28),
    surface_color = Color3.fromRGB(28, 28, 42),
    text_color = Color3.fromRGB(240, 240, 255),
    text_muted = Color3.fromRGB(160, 160, 180),
    min_size = Vector2.new(520, 520),
    toggle_key = Enum.KeyCode.RightShift,
    can_resize = true,
    spring_stiffness = 120,
    spring_damping = 10,
    animation_duration = 0.3,
}

-- ============================================
-- 🎯 MOTION VALUES (60fps animation driver)
-- ============================================
local Motion = {}
Motion.__index = Motion

function Motion.new(initial)
    local self = setmetatable({}, Motion)
    self.value = initial or 0
    self.target = self.value
    self.velocity = 0
    self.listeners = {}
    self._conn = nil
    return self
end

function Motion:Spring(target, stiffness, damping)
    stiffness = stiffness or ui_options.spring_stiffness
    damping = damping or ui_options.spring_damping
    self.target = target
    
    if not self._conn then
        self._conn = game:GetService("RunService").Heartbeat:Connect(function(dt)
            local error = self.target - self.value
            local force = error * stiffness
            self.velocity = self.velocity + force * dt
            self.velocity = self.velocity * (1 - damping * dt)
            self.value = self.value + self.velocity * dt
            
            for _, cb in pairs(self.listeners) do
                cb(self.value)
            end
        end)
    end
    
    return self
end

function Motion:OnChange(callback)
    table.insert(self.listeners, callback)
    return self
end

function Motion:Stop()
    if self._conn then
        self._conn:Disconnect()
        self._conn = nil
    end
end

-- ============================================
-- 🎬 ANIMATE PRESENCE (enter/exit animations)
-- ============================================
local function AnimatePresence(object, visible, config)
    config = config or {}
    local duration = config.duration or ui_options.animation_duration
    local scale = config.scale or 0.8
    local fade = config.fade ~= false
    local spring = config.spring or false
    
    if visible then
        object.Visible = true
        
        if spring then
            -- Use spring physics
            local sizeX = Motion.new(object.AbsoluteSize.X * scale)
            local sizeY = Motion.new(object.AbsoluteSize.Y * scale)
            local opacity = Motion.new(fade and 1 or 0)
            
            sizeX:Spring(object.AbsoluteSize.X):OnChange(function(v)
                object.Size = UDim2.new(0, v, 0, object.Size.Y.Offset)
            end)
            sizeY:Spring(object.AbsoluteSize.Y):OnChange(function(v)
                object.Size = UDim2.new(0, object.Size.X.Offset, 0, v)
            end)
            if fade then
                opacity:Spring(0):OnChange(function(v)
                    object.BackgroundTransparency = v
                    if object:IsA("ImageLabel") then
                        object.ImageTransparency = v
                    end
                end)
            end
        else
            -- Use tween
            object.Size = UDim2.new(0, object.AbsoluteSize.X * scale, 0, object.AbsoluteSize.Y * scale)
            if fade then object.BackgroundTransparency = 1 end
            
            TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, object.AbsoluteSize.X, 0, object.AbsoluteSize.Y),
                BackgroundTransparency = 0,
                ImageTransparency = 0,
            }):Play()
        end
    else
        if spring then
            local sizeX = Motion.new(object.AbsoluteSize.X)
            local sizeY = Motion.new(object.AbsoluteSize.Y)
            local opacity = Motion.new(fade and 0 or 0)
            
            sizeX:Spring(object.AbsoluteSize.X * scale):OnChange(function(v)
                object.Size = UDim2.new(0, v, 0, object.Size.Y.Offset)
            end)
            sizeY:Spring(object.AbsoluteSize.Y * scale):OnChange(function(v)
                object.Size = UDim2.new(0, object.Size.X.Offset, 0, v)
            end)
            if fade then
                opacity:Spring(1):OnChange(function(v)
                    object.BackgroundTransparency = v
                    if object:IsA("ImageLabel") then
                        object.ImageTransparency = v
                    end
                end)
            end
            
            task.wait(duration)
            object.Visible = false
        else
            local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, object.AbsoluteSize.X * scale, 0, object.AbsoluteSize.Y * scale),
                BackgroundTransparency = 1,
                ImageTransparency = 1,
            })
            tween:Play()
            tween.Completed:Connect(function()
                object.Visible = false
            end)
        end
    end
end

-- ============================================
-- 🖐️ GESTURE COMPOSABILITY
-- ============================================
local Gesture = {}
Gesture.__index = Gesture

function Gesture.new(object)
    local self = setmetatable({}, Gesture)
    self.object = object
    self.dragging = false
    self.swiping = false
    self.startPos = nil
    self.startMouse = nil
    self.listeners = {
        onDrag = {},
        onSwipe = {},
        onPinch = {},
    }
    
    -- Drag detection
    object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.dragging = true
            self.startPos = object.Position
            self.startMouse = UIS:GetMouseLocation()
        end
    end)
    
    object.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.dragging = false
            
            -- Detect swipe
            local endMouse = UIS:GetMouseLocation()
            local delta = endMouse - self.startMouse
            if delta.Magnitude > 50 then
                self.swiping = true
                for _, cb in pairs(self.listeners.onSwipe) do
                    cb(delta)
                end
                self.swiping = false
            end
        end
    end)
    
    -- Track drag
    game:GetService("RunService").Heartbeat:Connect(function()
        if self.dragging then
            local currentMouse = UIS:GetMouseLocation()
            local delta = currentMouse - self.startMouse
            for _, cb in pairs(self.listeners.onDrag) do
                cb(delta)
            end
        end
    end)
    
    return self
end

function Gesture:OnDrag(callback)
    table.insert(self.listeners.onDrag, callback)
    return self
end

function Gesture:OnSwipe(callback)
    table.insert(self.listeners.onSwipe, callback)
    return self
end

-- ============================================
-- 🎨 LABEL IMAGE (text + icon combo)
-- ============================================
local function CreateLabelImage(parent, text, icon, config)
    config = config or {}
    local frame = Instance.new("Frame")
    frame.Name = "LabelImage"
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, config.height or 24)
    frame.ClipsDescendants = true
    
    -- Icon
    local iconLabel = Instance.new("ImageLabel")
    iconLabel.Name = "Icon"
    iconLabel.Parent = frame
    iconLabel.Size = UDim2.new(0, 20, 0, 20)
    iconLabel.Position = UDim2.new(0, 0, 0.5, -10)
    iconLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Image = icon or ""
    iconLabel.ImageColor3 = config.iconColor or ui_options.accent_color
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Parent = frame
    textLabel.Size = UDim2.new(1, -30, 1, 0)
    textLabel.Position = UDim2.new(0, 25, 0, 0)
    textLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.Text = text or "Label"
    textLabel.TextColor3 = config.textColor or ui_options.text_color
    textLabel.TextSize = config.textSize or 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    return frame
end

-- ============================================
-- 🎬 VARIANTS + STAGGER
-- ============================================
local function Stagger(parent, children, config)
    config = config or {}
    local staggerDelay = config.staggerDelay or 0.05
    local duration = config.duration or 0.3
    local scale = config.scale or 0.9
    
    for i, child in pairs(children) do
        task.wait(staggerDelay)
        
        -- Variant: different animations based on index
        local variant = config.variants and config.variants[i % #config.variants + 1] or "fade"
        
        child.Visible = true
        child.Size = UDim2.new(0, child.AbsoluteSize.X * scale, 0, child.AbsoluteSize.Y * scale)
        child.BackgroundTransparency = 1
        
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local properties = {
            Size = UDim2.new(0, child.AbsoluteSize.X, 0, child.AbsoluteSize.Y),
            BackgroundTransparency = 0,
        }
        
        if variant == "slide_left" then
            child.Position = UDim2.new(0, -50, 0, 0)
            properties.Position = UDim2.new(0, 0, 0, 0)
        elseif variant == "slide_right" then
            child.Position = UDim2.new(0, 50, 0, 0)
            properties.Position = UDim2.new(0, 0, 0, 0)
        elseif variant == "slide_up" then
            child.Position = UDim2.new(0, 0, 0, 50)
            properties.Position = UDim2.new(0, 0, 0, 0)
        elseif variant == "scale" then
            properties.Size = UDim2.new(0, child.AbsoluteSize.X, 0, child.AbsoluteSize.Y)
        end
        
        TweenService:Create(child, tweenInfo, properties):Play()
    end
end

-- ============================================
-- 🔄 SHARED ELEMENT TRANSITIONS
-- ============================================
local SharedElement = {}
SharedElement.__index = SharedElement

function SharedElement.new(source, target, config)
    config = config or {}
    local duration = config.duration or 0.4
    
    -- Clone source element
    local clone = source:Clone()
    clone.Parent = source.Parent
    clone.ZIndex = 1000
    
    -- Position clone over source
    clone.Position = UDim2.new(0, source.AbsolutePosition.X, 0, source.AbsolutePosition.Y)
    clone.Size = UDim2.new(0, source.AbsoluteSize.X, 0, source.AbsoluteSize.Y)
    
    -- Tween to target position
    TweenService:Create(clone, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Position = UDim2.new(0, target.AbsolutePosition.X, 0, target.AbsolutePosition.Y),
        Size = UDim2.new(0, target.AbsoluteSize.X, 0, target.AbsoluteSize.Y),
    }):Play()
    
    task.wait(duration)
    clone:Destroy()
end

-- ============================================
-- 🏗️ BUILD UI
-- ============================================
local imgui = Instance.new("ScreenGui")
imgui.Name = "imgui"
imgui.Parent = game:GetService("CoreGui")

local Prefabs = Instance.new("Frame")
Prefabs.Name = "Prefabs"
Prefabs.Parent = imgui
Prefabs.BackgroundColor3 = Color3.new(1, 1, 1)
Prefabs.Size = UDim2.new(0, 100, 0, 100)
Prefabs.Visible = false

-- ============================================
-- 🪟 GLASS WINDOW WITH SPRING PHYSICS
-- ============================================
local Window = Instance.new("ImageLabel")
Window.Name = "Window"
Window.Parent = Prefabs
Window.Active = true
Window.Selectable = true
Window.BackgroundColor3 = Color3.new(1, 1, 1)
Window.BackgroundTransparency = 0.15
Window.ClipsDescendants = true
Window.Position = UDim2.new(0, 20, 0, 20)
Window.Size = UDim2.new(0, 200, 0, 200)
Window.Image = "rbxassetid://2851926732"
Window.ImageColor3 = ui_options.bg_color
Window.ImageTransparency = 0.1
Window.ScaleType = Enum.ScaleType.Slice
Window.SliceCenter = Rect.new(12, 12, 12, 12)

-- Glow border
local WindowGlow = Instance.new("ImageLabel")
WindowGlow.Name = "GlowBorder"
WindowGlow.Parent = Window
WindowGlow.Size = UDim2.new(1, 8, 1, 8)
WindowGlow.Position = UDim2.new(0, -4, 0, -4)
WindowGlow.BackgroundColor3 = Color3.new(1, 1, 1)
WindowGlow.BackgroundTransparency = 1
WindowGlow.Image = "rbxassetid://2851926732"
WindowGlow.ImageColor3 = ui_options.main_color
WindowGlow.ImageTransparency = 0.6
WindowGlow.ZIndex = 0
WindowGlow.ScaleType = Enum.ScaleType.Slice
WindowGlow.SliceCenter = Rect.new(12, 12, 12, 12)

-- ============================================
-- 📐 RESIZER WITH GESTURE
-- ============================================
local Resizer = Instance.new("Frame")
Resizer.Name = "Resizer"
Resizer.Parent = Window
Resizer.Active = true
Resizer.BackgroundColor3 = Color3.new(1, 1, 1)
Resizer.BackgroundTransparency = 1
Resizer.BorderSizePixel = 0
Resizer.Position = UDim2.new(1, -24, 1, -24)
Resizer.Size = UDim2.new(0, 24, 0, 24)

local ResizerIcon = Instance.new("ImageLabel")
ResizerIcon.Name = "Icon"
ResizerIcon.Parent = Resizer
ResizerIcon.Size = UDim2.new(1, 0, 1, 0)
ResizerIcon.BackgroundColor3 = Color3.new(1, 1, 1)
ResizerIcon.BackgroundTransparency = 1
ResizerIcon.Image = "rbxassetid://266543268"
ResizerIcon.ImageColor3 = Color3.fromRGB(200, 200, 255)
ResizerIcon.ImageTransparency = 0.7

-- ============================================
-- 🎯 TITLE BAR
-- ============================================
local Bar = Instance.new("Frame")
Bar.Name = "Bar"
Bar.Parent = Window
Bar.BackgroundColor3 = ui_options.main_color
Bar.BackgroundTransparency = 0.15
Bar.BorderSizePixel = 0
Bar.Position = UDim2.new(0, 0, 0, 5)
Bar.Size = UDim2.new(1, 0, 0, 22)

-- Gradient overlay
local BarGradient = Instance.new("ImageLabel")
BarGradient.Name = "Gradient"
BarGradient.Parent = Bar
BarGradient.Size = UDim2.new(1, 0, 1, 0)
BarGradient.BackgroundColor3 = Color3.new(1, 1, 1)
BarGradient.BackgroundTransparency = 1
BarGradient.Image = "rbxassetid://2851928141"
BarGradient.ImageColor3 = ui_options.accent_color
BarGradient.ImageTransparency = 0.5
BarGradient.ZIndex = 0
BarGradient.ScaleType = Enum.ScaleType.Slice
BarGradient.SliceCenter = Rect.new(8, 8, 8, 8)

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Window
Title.BackgroundColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 32, 0, 4)
Title.Size = UDim2.new(0, 200, 0, 20)
Title.Font = Enum.Font.GothamBold
Title.Text = "✦ Elerium Ultra"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================
-- 📑 TABS
-- ============================================
local TabSelection = Instance.new("ImageLabel")
TabSelection.Name = "TabSelection"
TabSelection.Parent = Window
TabSelection.BackgroundColor3 = Color3.new(1, 1, 1)
TabSelection.BackgroundTransparency = 1
TabSelection.Position = UDim2.new(0, 15, 0, 32)
TabSelection.Size = UDim2.new(1, -30, 0, 28)
TabSelection.Image = "rbxassetid://2851929490"
TabSelection.ImageColor3 = Color3.fromRGB(30, 30, 50)
TabSelection.ImageTransparency = 0.3
TabSelection.ScaleType = Enum.ScaleType.Slice
TabSelection.SliceCenter = Rect.new(4, 4, 4, 4)

local GlowLine = Instance.new("ImageLabel")
GlowLine.Name = "GlowLine"
GlowLine.Parent = TabSelection
GlowLine.Size = UDim2.new(1, 0, 0, 2)
GlowLine.Position = UDim2.new(0, 0, 1, -1)
GlowLine.BackgroundColor3 = Color3.new(1, 1, 1)
GlowLine.BackgroundTransparency = 1
GlowLine.Image = "rbxassetid://2851926732"
GlowLine.ImageColor3 = ui_options.accent_color
GlowLine.ImageTransparency = 0.5
GlowLine.ZIndex = 10
GlowLine.ScaleType = Enum.ScaleType.Slice
GlowLine.SliceCenter = Rect.new(12, 12, 12, 12)

local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Parent = TabSelection
TabButtons.BackgroundColor3 = Color3.new(1, 1, 1)
TabButtons.BackgroundTransparency = 1
TabButtons.Size = UDim2.new(1, 0, 1, 0)

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabButtons
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 4)

local Tabs = Instance.new("Frame")
Tabs.Name = "Tabs"
Tabs.Parent = Window
Tabs.BackgroundColor3 = Color3.new(1, 1, 1)
Tabs.BackgroundTransparency = 1
Tabs.Position = UDim2.new(0, 15, 0, 64)
Tabs.Size = UDim2.new(1, -30, 1, -78)

-- ============================================
-- 📄 TAB TEMPLATE
-- ============================================
local Tab = Instance.new("Frame")
Tab.Name = "Tab"
Tab.Parent = Prefabs
Tab.BackgroundColor3 = Color3.new(1, 1, 1)
Tab.BackgroundTransparency = 1
Tab.Size = UDim2.new(1, 0, 1, 0)
Tab.Visible = false

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = Tab
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 6)

-- ============================================
-- 🔘 TAB BUTTON
-- ============================================
local TabButton = Instance.new("TextButton")
TabButton.Name = "TabButton"
TabButton.Parent = Prefabs
TabButton.BackgroundColor3 = ui_options.main_color
TabButton.BackgroundTransparency = 0.3
TabButton.BorderSizePixel = 0
TabButton.Size = UDim2.new(0, 80, 0, 24)
TabButton.ZIndex = 2
TabButton.Font = Enum.Font.GothamSemibold
TabButton.Text = "Tab"
TabButton.TextColor3 = Color3.fromRGB(200, 200, 220)
TabButton.TextSize = 13

local function createRoundedImage(parent, name, color, transparency)
    local image = Instance.new("ImageLabel")
    image.Name = name
    image.Parent = parent
    image.BackgroundColor3 = Color3.new(1, 1, 1)
    image.BackgroundTransparency = 1
    image.Size = UDim2.new(1, 0, 1, 0)
    image.Image = "rbxassetid://2851929490"
    image.ImageColor3 = color or Color3.fromRGB(40, 40, 60)
    image.ImageTransparency = transparency or 0.3
    image.ScaleType = Enum.ScaleType.Slice
    image.SliceCenter = Rect.new(4, 4, 4, 4)
    return image
end

createRoundedImage(TabButton, "RoundBg", ui_options.main_color, 0.2)

-- ============================================
-- 🏷️ LABEL TEMPLATE
-- ============================================
local Label = Instance.new("TextLabel")
Label.Name = "Label"
Label.Parent = Prefabs
Label.BackgroundColor3 = Color3.new(1, 1, 1)
Label.BackgroundTransparency = 1
Label.Size = UDim2.new(0, 200, 0, 22)
Label.Font = Enum.Font.GothamSemibold
Label.Text = "Label"
Label.TextColor3 = ui_options.text_color
Label.TextSize = 14
Label.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================
-- 🔘 BUTTON
-- ============================================
local Button = Instance.new("TextButton")
Button.Name = "Button"
Button.Parent = Prefabs
Button.BackgroundColor3 = ui_options.main_color
Button.BackgroundTransparency = 0.15
Button.BorderSizePixel = 0
Button.Size = UDim2.new(0, 100, 0, 24)
Button.ZIndex = 2
Button.Font = Enum.Font.GothamBold
Button.Text = "Button"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 13

createRoundedImage(Button, "RoundBg", ui_options.main_color, 0.15)

-- ============================================
-- 🔄 SWITCH
-- ============================================
local Switch = Instance.new("TextButton")
Switch.Name = "Switch"
Switch.Parent = Prefabs
Switch.BackgroundColor3 = Color3.new(1, 1, 1)
Switch.BackgroundTransparency = 1
Switch.BorderSizePixel = 0
Switch.Size = UDim2.new(0, 24, 0, 24)
Switch.ZIndex = 2
Switch.Font = Enum.Font.GothamBold
Switch.Text = ""
Switch.TextColor3 = ui_options.accent_color
Switch.TextSize = 18

createRoundedImage(Switch, "RoundBg", Color3.fromRGB(60, 60, 90), 0.4)

local SwitchTitle = Instance.new("TextLabel")
SwitchTitle.Name = "Title"
SwitchTitle.Parent = Switch
SwitchTitle.BackgroundColor3 = Color3.new(1, 1, 1)
SwitchTitle.BackgroundTransparency = 1
SwitchTitle.Position = UDim2.new(1.2, 0, 0, 0)
SwitchTitle.Size = UDim2.new(0, 200, 0, 24)
SwitchTitle.Font = Enum.Font.GothamSemibold
SwitchTitle.Text = "Switch"
SwitchTitle.TextColor3 = ui_options.text_color
SwitchTitle.TextSize = 13
SwitchTitle.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================
-- 📊 SLIDER
-- ============================================
local Slider = Instance.new("ImageLabel")
Slider.Name = "Slider"
Slider.Parent = Prefabs
Slider.BackgroundColor3 = Color3.new(1, 1, 1)
Slider.BackgroundTransparency = 1
Slider.Size = UDim2.new(1, 0, 0, 24)
Slider.Image = "rbxassetid://2851929490"
Slider.ImageColor3 = Color3.fromRGB(40, 40, 60)
Slider.ImageTransparency = 0.4
Slider.ScaleType = Enum.ScaleType.Slice
Slider.SliceCenter = Rect.new(4, 4, 4, 4)

local SliderTitle = Instance.new("TextLabel")
SliderTitle.Name = "Title"
SliderTitle.Parent = Slider
SliderTitle.BackgroundColor3 = Color3.new(1, 1, 1)
SliderTitle.BackgroundTransparency = 1
SliderTitle.Position = UDim2.new(0, 0, 0.5, -12)
SliderTitle.Size = UDim2.new(0, 0, 0, 24)
SliderTitle.Font = Enum.Font.GothamBold
SliderTitle.Text = "Slider"
SliderTitle.TextColor3 = ui_options.text_color
SliderTitle.TextSize = 13

local SliderTrack = Instance.new("ImageLabel")
SliderTrack.Name = "Track"
SliderTrack.Parent = Slider
SliderTrack.Size = UDim2.new(1, 0, 0, 4)
SliderTrack.Position = UDim2.new(0, 0, 0.5, -2)
SliderTrack.BackgroundColor3 = Color3.new(1, 1, 1)
SliderTrack.BackgroundTransparency = 1
SliderTrack.Image = "rbxassetid://2851929490"
SliderTrack.ImageColor3 = Color3.fromRGB(60, 60, 90)
SliderTrack.ImageTransparency = 0.3
SliderTrack.ScaleType = Enum.ScaleType.Slice
SliderTrack.SliceCenter = Rect.new(4, 4, 4, 4)

local SliderIndicator = Instance.new("ImageLabel")
SliderIndicator.Name = "Indicator"
SliderIndicator.Parent = Slider
SliderIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
SliderIndicator.BackgroundTransparency = 1
SliderIndicator.Size = UDim2.new(0, 0, 0, 4)
SliderIndicator.Image = "rbxassetid://2851929490"
SliderIndicator.ImageColor3 = ui_options.accent_color
SliderIndicator.ImageTransparency = 0.2
SliderIndicator.ScaleType = Enum.ScaleType.Slice
SliderIndicator.SliceCenter = Rect.new(4, 4, 4, 4)

local SliderThumb = Instance.new("ImageLabel")
SliderThumb.Name = "Thumb"
SliderThumb.Parent = SliderIndicator
SliderThumb.Size = UDim2.new(0, 16, 0, 16)
SliderThumb.Position = UDim2.new(1, -8, 0.5, -2)
SliderThumb.BackgroundColor3 = Color3.new(1, 1, 1)
SliderThumb.BackgroundTransparency = 1
SliderThumb.Image = "rbxassetid://266543268"
SliderThumb.ImageColor3 = ui_options.accent_color
SliderThumb.ImageTransparency = 0.2

local SliderValue = Instance.new("TextLabel")
SliderValue.Name = "Value"
SliderValue.Parent = Slider
SliderValue.BackgroundColor3 = Color3.new(1, 1, 1)
SliderValue.BackgroundTransparency = 1
SliderValue.Position = UDim2.new(1, -55, 0.5, -12)
SliderValue.Size = UDim2.new(0, 50, 0, 24)
SliderValue.Font = Enum.Font.GothamBold
SliderValue.Text = "0"
SliderValue.TextColor3 = ui_options.accent_color
SliderValue.TextSize = 13
SliderValue.TextXAlignment = Enum.TextXAlignment.Right

-- ============================================
-- 📝 TEXTBOX
-- ============================================
local TextBox = Instance.new("TextBox")
TextBox.Name = "TextBox"
TextBox.Parent = Prefabs
TextBox.BackgroundColor3 = Color3.new(1, 1, 1)
TextBox.BackgroundTransparency = 1
TextBox.BorderSizePixel = 0
TextBox.Size = UDim2.new(1, 0, 0, 24)
TextBox.ZIndex = 2
TextBox.Font = Enum.Font.GothamMedium
TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 150)
TextBox.PlaceholderText = "Input..."
TextBox.Text = ""
TextBox.TextColor3 = ui_options.text_color
TextBox.TextSize = 13
TextBox.TextXAlignment = Enum.TextXAlignment.Left

createRoundedImage(TextBox, "RoundBg", Color3.fromRGB(40, 40, 60), 0.3)

-- ============================================
-- 📋 DROPDOWN
-- ============================================
local Dropdown = Instance.new("TextButton")
Dropdown.Name = "Dropdown"
Dropdown.Parent = Prefabs
Dropdown.BackgroundColor3 = Color3.new(1, 1, 1)
Dropdown.BackgroundTransparency = 1
Dropdown.BorderSizePixel = 0
Dropdown.Size = UDim2.new(1, 0, 0, 24)
Dropdown.ZIndex = 2
Dropdown.Font = Enum.Font.GothamSemibold
Dropdown.Text = "  ▼ Dropdown"
Dropdown.TextColor3 = ui_options.text_color
Dropdown.TextSize = 13
Dropdown.TextXAlignment = Enum.TextXAlignment.Left

createRoundedImage(Dropdown, "RoundBg", Color3.fromRGB(40, 40, 60), 0.3)

local DropdownArrow = Instance.new("ImageLabel")
DropdownArrow.Name = "Arrow"
DropdownArrow.Parent = Dropdown
DropdownArrow.BackgroundColor3 = Color3.new(1, 1, 1)
DropdownArrow.BackgroundTransparency = 1
DropdownArrow.Position = UDim2.new(1, -20, 0.5, -8)
DropdownArrow.Size = UDim2.new(0, 16, 0, 16)
DropdownArrow.Image = "rbxassetid://4744658743"
DropdownArrow.ImageColor3 = Color3.fromRGB(200, 200, 220)
DropdownArrow.ImageTransparency = 0.5

local DropdownBox = Instance.new("ImageButton")
DropdownBox.Name = "Box"
DropdownBox.Parent = Dropdown
DropdownBox.BackgroundColor3 = Color3.new(1, 1, 1)
DropdownBox.BackgroundTransparency = 1
DropdownBox.Position = UDim2.new(0, 0, 1, 2)
DropdownBox.Size = UDim2.new(1, 0, 0, 0)
DropdownBox.ZIndex = 3
DropdownBox.Image = "rbxassetid://2851929490"
DropdownBox.ImageColor3 = Color3.fromRGB(25, 25, 40)
DropdownBox.ImageTransparency = 0.2
DropdownBox.ScaleType = Enum.ScaleType.Slice
DropdownBox.SliceCenter = Rect.new(4, 4, 4, 4)

local DropdownObjects = Instance.new("ScrollingFrame")
DropdownObjects.Name = "Objects"
DropdownObjects.Parent = DropdownBox
DropdownObjects.BackgroundColor3 = Color3.new(1, 1, 1)
DropdownObjects.BackgroundTransparency = 1
DropdownObjects.BorderSizePixel = 0
DropdownObjects.Size = UDim2.new(1, 0, 1, 0)
DropdownObjects.ZIndex = 3
DropdownObjects.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownObjects.ScrollBarThickness = 4

local DropdownList = Instance.new("UIListLayout")
DropdownList.Parent = DropdownObjects
DropdownList.SortOrder = Enum.SortOrder.LayoutOrder

local DropdownItem = Instance.new("TextButton")
DropdownItem.Name = "DropdownItem"
DropdownItem.Parent = Prefabs
DropdownItem.BackgroundColor3 = Color3.fromRGB(33, 34, 40)
DropdownItem.BackgroundTransparency = 0.5
DropdownItem.BorderSizePixel = 0
DropdownItem.Size = UDim2.new(1, 0, 0, 20)
DropdownItem.ZIndex = 3
DropdownItem.Font = Enum.Font.GothamMedium
DropdownItem.Text = "Item"
DropdownItem.TextColor3 = Color3.fromRGB(200, 200, 220)
DropdownItem.TextSize = 12
DropdownItem.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================
-- 🖥️ CONSOLE
-- ============================================
local Console = Instance.new("ImageLabel")
Console.Name = "Console"
Console.Parent = Prefabs
Console.BackgroundColor3 = Color3.new(1, 1, 1)
Console.BackgroundTransparency = 1
Console.Size = UDim2.new(1, 0, 0, 200)
Console.Image = "rbxassetid://2851928141"
Console.ImageColor3 = Color3.fromRGB(15, 15, 25)
Console.ImageTransparency = 0.1
Console.ScaleType = Enum.ScaleType.Slice
Console.SliceCenter = Rect.new(8, 8, 8, 8)

local ConsoleScroller = Instance.new("ScrollingFrame")
ConsoleScroller.Parent = Console
ConsoleScroller.BackgroundColor3 = Color3.new(1, 1, 1)
ConsoleScroller.BackgroundTransparency = 1
ConsoleScroller.BorderSizePixel = 0
ConsoleScroller.Size = UDim2.new(1, 0, 1, 0)
ConsoleScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
ConsoleScroller.ScrollBarThickness = 4

local LineNumbers = Instance.new("TextLabel")
LineNumbers.Name = "Lines"
LineNumbers.Parent = ConsoleScroller
LineNumbers.BackgroundColor3 = Color3.new(1, 1, 1)
LineNumbers.BackgroundTransparency = 1
LineNumbers.BorderSizePixel = 0
LineNumbers.Size = UDim2.new(0, 36, 0, 10000)
LineNumbers.ZIndex = 4
LineNumbers.Font = Enum.Font.Code
LineNumbers.Text = "1\n"
LineNumbers.TextColor3 = Color3.fromRGB(80, 80, 100)
LineNumbers.TextSize = 13
LineNumbers.TextWrapped = true
LineNumbers.TextYAlignment = Enum.TextYAlignment.Top

local Source = Instance.new("TextBox")
Source.Name = "Source"
Source.Parent = ConsoleScroller
Source.BackgroundColor3 = Color3.new(1, 1, 1)
Source.BackgroundTransparency = 1
Source.Position = UDim2.new(0, 40, 0, 0)
Source.Size = UDim2.new(1, -40, 0, 10000)
Source.ZIndex = 3
Source.ClearTextOnFocus = false
Source.Font = Enum.Font.Code
Source.MultiLine = true
Source.PlaceholderColor3 = Color3.fromRGB(80, 80, 100)
Source.Text = ""
Source.TextColor3 = Color3.fromRGB(240, 240, 255)
Source.TextSize = 13
Source.TextXAlignment = Enum.TextXAlignment.Left
Source.TextYAlignment = Enum.TextYAlignment.Top

local function createSyntaxLayer(name, color)
    local layer = Instance.new("TextLabel")
    layer.Name = name
    layer.Parent = Source
    layer.BackgroundColor3 = Color3.new(1, 1, 1)
    layer.BackgroundTransparency = 1
    layer.Size = UDim2.new(1, 0, 1, 0)
    layer.ZIndex = 5
    layer.Font = Enum.Font.Code
    layer.Text = ""
    layer.TextColor3 = color
    layer.TextSize = 13
    layer.TextXAlignment = Enum.TextXAlignment.Left
    layer.TextYAlignment = Enum.TextYAlignment.Top
    return layer
end

createSyntaxLayer("Keywords", Color3.fromRGB(255, 100, 120))
createSyntaxLayer("Globals", Color3.fromRGB(100, 180, 255))
createSyntaxLayer("Strings", Color3.fromRGB(150, 230, 120))
createSyntaxLayer("Comments", Color3.fromRGB(80, 200, 80))
createSyntaxLayer("Numbers", Color3.fromRGB(255, 200, 50))
createSyntaxLayer("Tokens", Color3.fromRGB(255, 255, 255))
createSyntaxLayer("RemoteHighlight", Color3.fromRGB(0, 150, 255))
createSyntaxLayer("Info", Color3.fromRGB(0, 160, 255))

-- ============================================
-- 🪟 WINDOWS CONTAINER
-- ============================================
local Windows = Instance.new("Frame")
Windows.Name = "Windows"
Windows.Parent = imgui
Windows.BackgroundColor3 = Color3.new(1, 1, 1)
Windows.BackgroundTransparency = 1
Windows.Position = UDim2.new(0, 20, 0, 20)
Windows.Size = UDim2.new(1, -40, 1, -40)

-- ============================================
-- 📦 LIBRARY
-- ============================================
local library = {}
local windows_count = 0
local dropdown_open = false
local checks = { binding = false }

-- ============================================
-- 🎬 HELPERS
-- ============================================
local function gNameLen(obj)
    return obj.TextBounds.X + 15
end

local function gMouse()
    return Vector2.new(UIS:GetMouseLocation().X + 1, UIS:GetMouseLocation().Y - 35)
end

local function Resize(part, new, _delay)
    _delay = _delay or ui_options.animation_duration
    local tween = TweenService:Create(part, TweenInfo.new(_delay, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), new)
    tween:Play()
    return tween
end

local function rgbtohsv(r, g, b)
    r, g, b = r / 255, g / 255, b / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v = 0, 0, max
    local d = max - min
    if max ~= 0 then s = d / max end
    if max ~= min then
        if max == r then h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then h = (b - r) / d + 2
        elseif max == b then h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h, s, v
end

-- ============================================
-- 🎬 RIPPLE EFFECT
-- ============================================
local RippleCircle = Instance.new("ImageLabel")
RippleCircle.Name = "Circle"
RippleCircle.Parent = Prefabs
RippleCircle.BackgroundColor3 = Color3.new(1, 1, 1)
RippleCircle.BackgroundTransparency = 1
RippleCircle.Image = "rbxassetid://266543268"
RippleCircle.ImageColor3 = Color3.fromRGB(255, 255, 255)
RippleCircle.ImageTransparency = 0.5
RippleCircle.Visible = false

local function ripple(button, x, y)
    spawn(function()
        button.ClipsDescendants = true
        local circle = RippleCircle:Clone()
        circle.Parent = button
        circle.ZIndex = 1000
        circle.Position = UDim2.new(0, x - circle.AbsolutePosition.X, 0, y - circle.AbsolutePosition.Y)
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5
        circle:TweenSizeAndPosition(
            UDim2.new(0, size, 0, size),
            UDim2.new(0.5, -size/2, 0.5, -size/2),
            "Out", "Quad", 0.5, false, nil
        )
        Resize(circle, {ImageTransparency = 1}, 0.5)
        wait(0.5)
        circle:Destroy()
    end)
end

-- ============================================
-- 🏗️ ADD WINDOW
-- ============================================
function library:AddWindow(title, options)
    windows_count = windows_count + 1
    title = tostring(title or "New Window")
    options = (typeof(options) == "table") and options or ui_options
    options.tween_time = options.animation_duration or 0.1

    local Window = Prefabs:FindFirstChild("Window"):Clone()
    Window.Parent = Windows
    Window:FindFirstChild("Title").Text = title
    Window.Size = UDim2.new(0, options.min_size.X, 0, options.min_size.Y)
    Window.ZIndex = Window.ZIndex + (windows_count * 10)

    -- Apply glow border
    local glowBorder = Window:FindFirstChild("GlowBorder")
    if glowBorder then
        glowBorder.ImageColor3 = options.main_color
    end

    -- Window color updater
    spawn(function()
        while Window and Window.Parent do
            local bar = Window:FindFirstChild("Bar")
            if bar then
                bar.BackgroundColor3 = options.main_color
                local base = bar:FindFirstChild("Base")
                if base then
                    base.BackgroundColor3 = options.main_color
                    base.ImageColor3 = options.main_color
                end
                local top = bar:FindFirstChild("Top")
                if top then
                    top.ImageColor3 = options.main_color
                end
            end
            task.wait()
        end
    end)

    local Resizer = Window:WaitForChild("Resizer")
    local window_data = {}
    Window.Draggable = true

    -- ============================================
    -- 🖐️ GESTURE: RESIZE
    -- ============================================
    do
        local Entered = false
        Resizer.MouseEnter:Connect(function()
            Window.Draggable = false
            Entered = true
        end)
        Resizer.MouseLeave:Connect(function()
            Entered = false
            Window.Draggable = true
        end)

        local Held = false
        UIS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Held = true
                spawn(function()
                    if Entered and Resizer.Active and options.can_resize then
                        while Held and Resizer.Active do
                            local mouse_pos = gMouse()
                            local x = mouse_pos.X - Window.AbsolutePosition.X
                            local y = mouse_pos.Y - Window.AbsolutePosition.Y
                            
                            if x >= options.min_size.X and y >= options.min_size.Y then
                                Resize(Window, {Size = UDim2.new(0, x, 0, y)}, options.tween_time)
                            elseif x >= options.min_size.X then
                                Resize(Window, {Size = UDim2.new(0, x, 0, options.min_size.Y)}, options.tween_time)
                            elseif y >= options.min_size.Y then
                                Resize(Window, {Size = UDim2.new(0, options.min_size.X, 0, y)}, options.tween_time)
                            else
                                Resize(Window, {Size = UDim2.new(0, options.min_size.X, 0, options.min_size.Y)}, options.tween_time)
                            end
                            task.wait()
                        end
                    end
                end)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Held = false
            end
        end)
    end

    -- ============================================
    -- 🪟 MINIMIZE
    -- ============================================
    do
        local open_close = Window:FindFirstChild("Bar"):FindFirstChild("Toggle")
        local open = true
        local canopen = true
        local oldwindowdata = {}
        local oldy = Window.AbsoluteSize.Y

        open_close.MouseButton1Click:Connect(function()
            if canopen then
                canopen = false
                if open then
                    oldwindowdata = {}
                    for i,v in next, Window:FindFirstChild("Tabs"):GetChildren() do
                        oldwindowdata[v] = v.Visible
                        v.Visible = false
                    end
                    Resizer.Active = false
                    oldy = Window.AbsoluteSize.Y
                    Resize(open_close, {Rotation = 0}, options.tween_time)
                    Resize(Window, {Size = UDim2.new(0, Window.AbsoluteSize.X, 0, 26)}, options.tween_time)
                    open_close.Parent:FindFirstChild("Base").Transparency = 1
                else
                    for i,v in next, oldwindowdata do
                        i.Visible = v
                    end
                    Resizer.Active = true
                    Resize(open_close, {Rotation = 90}, options.tween_time)
                    Resize(Window, {Size = UDim2.new(0, Window.AbsoluteSize.X, 0, oldy)}, options.tween_time)
                    open_close.Parent:FindFirstChild("Base").Transparency = 0
                end
                open = not open
                wait(options.tween_time)
                canopen = true
            end
        end)
    end

    -- ============================================
    -- 📑 TABS
    -- ============================================
    do
        local tabs = Window:FindFirstChild("Tabs")
        local tab_selection = Window:FindFirstChild("TabSelection")
        local tab_buttons = tab_selection:FindFirstChild("TabButtons")

        function window_data:AddTab(tab_name)
            local tab_data = {}
            tab_name = tostring(tab_name or "New Tab")
            tab_selection.Visible = true

            local new_button = Prefabs:FindFirstChild("TabButton"):Clone()
            new_button.Parent = tab_buttons
            new_button.Text = tab_name
            new_button.Size = UDim2.new(0, gNameLen(new_button), 0, 20)
            new_button.ZIndex = new_button.ZIndex + (windows_count * 10)
            
            local bg = new_button:FindFirstChild("RoundBg")
            if bg then bg.ZIndex = bg.ZIndex + (windows_count * 10) end

            local new_tab = Prefabs:FindFirstChild("Tab"):Clone()
            new_tab.Parent = tabs
            new_tab.ZIndex = new_tab.ZIndex + (windows_count * 10)

            local function show()
                if dropdown_open then return end
                for i, v in next, tab_buttons:GetChildren() do
                    if not (v:IsA("UIListLayout")) then
                        local vbg = v:FindFirstChild("RoundBg")
                        if vbg then vbg.ImageColor3 = Color3.fromRGB(52, 53, 56) end
                        Resize(v, {Size = UDim2.new(0, v.AbsoluteSize.X, 0, 20)}, options.tween_time)
                    end
                end
                for i, v in next, tabs:GetChildren() do
                    v.Visible = false
                end
                Resize(new_button, {Size = UDim2.new(0, new_button.AbsoluteSize.X, 0, 25)}, options.tween_time)
                local newbg = new_button:FindFirstChild("RoundBg")
                if newbg then newbg.ImageColor3 = Color3.fromRGB(73, 75, 79) end
                
                -- Animate tab content
                local children = {}
                for _, child in pairs(new_tab:GetChildren()) do
                    if not child:IsA("UIListLayout") then
                        table.insert(children, child)
                    end
                end
                Stagger(new_tab, children, {
                    staggerDelay = 0.03,
                    duration = 0.2,
                    scale = 0.95,
                    variants = {"fade", "slide_up", "fade", "slide_right"}
                })
                
                new_tab.Visible = true
            end

            new_button.MouseButton1Click:Connect(show)

            function tab_data:Show()
                show()
            end

            -- ============================================
            -- 🎨 UI ELEMENTS
            -- ============================================
            do
                function tab_data:AddLabelImage(text, icon, config)
                    return CreateLabelImage(new_tab, text, icon, config)
                end

                function tab_data:AddLabel(label_text)
                    label_text = tostring(label_text or "New Label")
                    local label = Prefabs:FindFirstChild("Label"):Clone()
                    label.Parent = new_tab
                    label.Text = label_text
                    label.Size = UDim2.new(0, gNameLen(label), 0, 20)
                    label.ZIndex = label.ZIndex + (windows_count * 10)
                    return label
                end

                function tab_data:AddButton(button_text, callback)
                    button_text = tostring(button_text or "New Button")
                    callback = typeof(callback) == "function" and callback or function()end

                    local button = Prefabs:FindFirstChild("Button"):Clone()
                    button.Parent = new_tab
                    button.Text = button_text
                    button.Size = UDim2.new(0, gNameLen(button), 0, 20)
                    button.ZIndex = button.ZIndex + (windows_count * 10)
                    
                    local bg = button:FindFirstChild("RoundBg")
                    if bg then bg.ZIndex = bg.ZIndex + (windows_count * 10) end

                    spawn(function()
                        while button and button.Parent do
                            local bbg = button:FindFirstChild("RoundBg")
                            if bbg then bbg.ImageColor3 = options.main_color end
                            task.wait()
                        end
                    end)

                    button.MouseButton1Click:Connect(function()
                        ripple(button, UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y)
                        pcall(callback)
                    end)

                    return button
                end

                function tab_data:AddSwitch(switch_text, callback)
                    local switch_data = {}
                    switch_text = tostring(switch_text or "New Switch")
                    callback = typeof(callback) == "function" and callback or function()end

                    local switch = Prefabs:FindFirstChild("Switch"):Clone()
                    switch.Parent = new_tab
                    switch:FindFirstChild("Title").Text = switch_text
                    switch:FindFirstChild("Title").ZIndex = switch:FindFirstChild("Title").ZIndex + (windows_count * 10)
                    switch.ZIndex = switch.ZIndex + (windows_count * 10)
                    
                    local bg = switch:FindFirstChild("RoundBg")
                    if bg then bg.ZIndex = bg.ZIndex + (windows_count * 10) end

                    spawn(function()
                        while switch and switch.Parent do
                            local sbg = switch:FindFirstChild("RoundBg")
                            if sbg then sbg.ImageColor3 = options.main_color end
                            task.wait()
                        end
                    end)

                    local toggled = false
                    switch.MouseButton1Click:Connect(function()
                        toggled = not toggled
                        switch.Text = toggled and utf8.char(10003) or ""
                        pcall(callback, toggled)
                    end)

                    function switch_data:Set(bool)
                        toggled = (typeof(bool) == "boolean") and bool or false
                        switch.Text = toggled and utf8.char(10003) or ""
                        pcall(callback, toggled)
                    end

                    return switch_data, switch
                end

                function tab_data:AddToggle(switch_text, callback)
                    return tab_data:AddSwitch(switch_text, callback)
                end

                function tab_data:AddTextBox(textbox_text, callback, textbox_options)
                    textbox_text = tostring(textbox_text or "New TextBox")
                    callback = typeof(callback) == "function" and callback or function()end
                    textbox_options = typeof(textbox_options) == "table" and textbox_options or {clear = true}
                    textbox_options = {clear = textbox_options.clear == true}

                    local textbox = Prefabs:FindFirstChild("TextBox"):Clone()
                    textbox.Parent = new_tab
                    textbox.PlaceholderText = textbox_text
                    textbox.ZIndex = textbox.ZIndex + (windows_count * 10)
                    
                    local bg = textbox:FindFirstChild("RoundBg")
                    if bg then bg.ZIndex = bg.ZIndex + (windows_count * 10) end

                    textbox.FocusLost:Connect(function(ep)
                        if ep and #textbox.Text > 0 then
                            pcall(callback, textbox.Text)
                            if textbox_options.clear then textbox.Text = "" end
                        end
                    end)

                    return textbox
                end

                function tab_data:AddSlider(slider_text, callback, slider_options)
                    local slider_data = {}
                    slider_text = tostring(slider_text or "New Slider")
                    callback = typeof(callback) == "function" and callback or function()end
                    slider_options = typeof(slider_options) == "table" and slider_options or {}
                    slider_options = {
                        min = slider_options.min or 0,
                        max = slider_options.max or 100,
                        readonly = slider_options.readonly or false,
                    }

                    local slider = Prefabs:FindFirstChild("Slider"):Clone()
                    slider.Parent = new_tab
                    slider.ZIndex = slider.ZIndex + (windows_count * 10)

                    local title = slider:FindFirstChild("Title")
                    local indicator = slider:FindFirstChild("Indicator")
                    local value = slider:FindFirstChild("Value")
                    title.ZIndex = title.ZIndex + (windows_count * 10)
                    indicator.ZIndex = indicator.ZIndex + (windows_count * 10)
                    value.ZIndex = value.ZIndex + (windows_count * 10)
                    title.Text = slider_text

                    do
                        local Entered = false
                        slider.MouseEnter:Connect(function()
                            Entered = true
                            Window.Draggable = false
                        end)
                        slider.MouseLeave:Connect(function()
                            Entered = false
                            Window.Draggable = true
                        end)

                        local Held = false
                        UIS.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                Held = true
                                spawn(function()
                                    if Entered and not slider_options.readonly then
                                        while Held and (not dropdown_open) do
                                            local mouse_pos = gMouse()
                                            local x = (slider.AbsoluteSize.X - (slider.AbsoluteSize.X - ((mouse_pos.X - slider.AbsolutePosition.X)) + 1)) / slider.AbsoluteSize.X
                                            local size = math.clamp(x, 0, 1)
                                            
                                            Resize(indicator, {Size = UDim2.new(size, 0, 0, 4)}, options.tween_time)
                                            local p = math.floor(size * 100)
                                            local diff = slider_options.max - slider_options.min
                                            local sel_value = math.floor(((diff / 100) * p) + slider_options.min)
                                            value.Text = tostring(sel_value)
                                            pcall(callback, sel_value)
                                            task.wait()
                                        end
                                    end
                                end)
                            end
                        end)
                        UIS.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                Held = false
                            end
                        end)

                        function slider_data:Set(new_value)
                            new_value = tonumber(new_value) or 0
                            new_value = math.clamp(new_value / 100, 0, 1)
                            Resize(indicator, {Size = UDim2.new(new_value, 0, 0, 4)}, options.tween_time)
                            local p = math.floor(new_value * 100)
                            local diff = slider_options.max - slider_options.min
                            local sel_value = math.floor(((diff / 100) * p) + slider_options.min)
                            value.Text = tostring(sel_value)
                            pcall(callback, sel_value)
                        end

                        slider_data:Set(slider_options.min)
                    end

                    return slider_data, slider
                end

                function tab_data:AddKeybind(keybind_name, callback, keybind_options)
                    local keybind_data = {}
                    keybind_name = tostring(keybind_name or "New Keybind")
                    callback = typeof(callback) == "function" and callback or function()end
                    keybind_options = typeof(keybind_options) == "table" and keybind_options or {}
                    keybind_options = {standard = keybind_options.standard or Enum.KeyCode.RightShift}

                    local keybind = Prefabs:FindFirstChild("Keybind"):Clone()
                    local input = keybind:FindFirstChild("Input")
                    local title = keybind:FindFirstChild("Title")
                    keybind.ZIndex = keybind.ZIndex + (windows_count * 10)
                    input.ZIndex = input.ZIndex + (windows_count * 10)
                    title.ZIndex = title.ZIndex + (windows_count * 10)
                    
                    local ibg = input:FindFirstChild("RoundBg")
                    if ibg then ibg.ZIndex = ibg.ZIndex + (windows_count * 10) end

                    keybind.Parent = new_tab
                    title.Text = "  " .. keybind_name
                    keybind.Size = UDim2.new(0, gNameLen(title) + 80, 0, 20)

                    local shortkeys = {
                        RightControl = 'RightCtrl',
                        LeftControl = 'LeftCtrl',
                        LeftShift = 'LShift',
                        RightShift = 'RShift',
                        MouseButton1 = "Mouse1",
                        MouseButton2 = "Mouse2"
                    }

                    local keybind_key = keybind_options.standard

                    function keybind_data:SetKeybind(Keybind)
                        local key = shortkeys[Keybind.Name] or Keybind.Name
                        input.Text = key
                        keybind_key = Keybind
                    end

                    UIS.InputBegan:Connect(function(a, b)
                        if checks.binding then
                            spawn(function()
                                wait()
                                checks.binding = false
                            end)
                            return
                        end
                        if a.KeyCode == keybind_key and not b then
                            pcall(callback, keybind_key)
                        end
                    end)

                    keybind_data:SetKeybind(keybind_options.standard)

                    input.MouseButton1Click:Connect(function()
                        if checks.binding then return end
                        input.Text = "..."
                        checks.binding = true
                        local a, b = UIS.InputBegan:Wait()
                        keybind_data:SetKeybind(a.KeyCode)
                    end)

                    return keybind_data, keybind
                end

                function tab_data:AddDropdown(dropdown_name, callback)
                    local dropdown_data = {}
                    dropdown_name = tostring(dropdown_name or "New Dropdown")
                    callback = typeof(callback) == "function" and callback or function()end

                    local dropdown = Prefabs:FindFirstChild("Dropdown"):Clone()
                    local box = dropdown:FindFirstChild("Box")
                    local objects = box:FindFirstChild("Objects")
                    local indicator = dropdown:FindFirstChild("Indicator")
                    dropdown.ZIndex = dropdown.ZIndex + (windows_count * 10)
                    box.ZIndex = box.ZIndex + (windows_count * 10)
                    objects.ZIndex = objects.ZIndex + (windows_count * 10)
                    indicator.ZIndex = indicator.ZIndex + (windows_count * 10)

                    dropdown.Parent = new_tab
                    dropdown.Text = "      " .. dropdown_name
                    box.Size = UDim2.new(1, 0, 0, 0)

                    local open = false
                    dropdown.MouseButton1Click:Connect(function()
                        open = not open
                        local len = (#objects:GetChildren() - 1) * 20
                        if #objects:GetChildren() - 1 >= 10 then
                            len = 10 * 20
                            objects.CanvasSize = UDim2.new(0, 0, (#objects:GetChildren() - 1) * 0.1, 0)
                        end

                        if open then
                            if dropdown_open then return end
                            dropdown_open = true
                            Resize(box, {Size = UDim2.new(1, 0, 0, len)}, options.tween_time)
                            Resize(indicator, {Rotation = 0}, options.tween_time)
                        else
                            dropdown_open = false
                            Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
                            Resize(indicator, {Rotation = -90}, options.tween_time)
                        end
                    end)

                    function dropdown_data:Add(n)
                        local object_data = {}
                        n = tostring(n or "New Object")

                        local object = Prefabs:FindFirstChild("DropdownItem"):Clone()
                        object.Parent = objects
                        object.Text = n
                        object.ZIndex = object.ZIndex + (windows_count * 10)

                        object.MouseEnter:Connect(function()
                            object.BackgroundColor3 = options.main_color
                        end)
                        object.MouseLeave:Connect(function()
                            object.BackgroundColor3 = Color3.fromRGB(33, 34, 36)
                        end)

                        if open then
                            local len = (#objects:GetChildren() - 1) * 20
                            if #objects:GetChildren() - 1 >= 10 then
                                len = 10 * 20
                                objects.CanvasSize = UDim2.new(0, 0, (#objects:GetChildren() - 1) * 0.1, 0)
                            end
                            Resize(box, {Size = UDim2.new(1, 0, 0, len)}, options.tween_time)
                        end

                        object.MouseButton1Click:Connect(function()
                            if dropdown_open then
                                dropdown.Text = "      [ " .. n .. " ]"
                                dropdown_open = false
                                open = false
                                Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
                                Resize(indicator, {Rotation = -90}, options.tween_time)
                                pcall(callback, n)
                            end
                        end)

                        function object_data:Remove()
                            object:Destroy()
                        end

                        return object, object_data
                    end

                    return dropdown_data, dropdown
                end

                function tab_data:AddColorPicker(callback)
                    local color_picker_data = {}
                    callback = typeof(callback) == "function" and callback or function()end

                    local color_picker = Prefabs:FindFirstChild("ColorPicker"):Clone()
                    color_picker.Parent = new_tab
                    color_picker.ZIndex = color_picker.ZIndex + (windows_count * 10)

                    local palette = color_picker:FindFirstChild("Palette")
                    local sample = color_picker:FindFirstChild("Sample")
                    local saturation = color_picker:FindFirstChild("Saturation")
                    palette.ZIndex = palette.ZIndex + (windows_count * 10)
                    sample.ZIndex = sample.ZIndex + (windows_count * 10)
                    saturation.ZIndex = saturation.ZIndex + (windows_count * 10)

                    do
                        local h, s, v = 0, 1, 1
                        local function update()
                            local color = Color3.fromHSV(h, s, v)
                            sample.ImageColor3 = color
                            saturation.ImageColor3 = Color3.fromHSV(h, 1, 1)
                            pcall(callback, color)
                        end

                        update()

                        local Entered1, Entered2 = false, false
                        palette.MouseEnter:Connect(function()
                            Window.Draggable = false
                            Entered1 = true
                        end)
                        palette.MouseLeave:Connect(function()
                            Window.Draggable = true
                            Entered1 = false
                        end)
                        saturation.MouseEnter:Connect(function()
                            Window.Draggable = false
                            Entered2 = true
                        end)
                        saturation.MouseLeave:Connect(function()
                            Window.Draggable = true
                            Entered2 = false
                        end)

                        local palette_indicator = palette:FindFirstChild("Indicator")
                        local saturation_indicator = saturation:FindFirstChild("Indicator")
                        palette_indicator.ZIndex = palette_indicator.ZIndex + (windows_count * 10)
                        saturation_indicator.ZIndex = saturation_indicator.ZIndex + (windows_count * 10)

                        local Held = false
                        UIS.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                Held = true
                                spawn(function()
                                    while Held and Entered1 and (not dropdown_open) do
                                        local mouse_pos = gMouse()
                                        local x = ((palette.AbsoluteSize.X - (mouse_pos.X - palette.AbsolutePosition.X)) + 1)
                                        local y = ((palette.AbsoluteSize.Y - (mouse_pos.Y - palette.AbsolutePosition.Y)) + 1.5)
                                        h = x / 100
                                        s = y / 100
                                        Resize(palette_indicator, {Position = UDim2.new(0, math.abs(x - 100) - (palette_indicator.AbsoluteSize.X / 2), 0, math.abs(y - 100) - (palette_indicator.AbsoluteSize.Y / 2))}, options.tween_time)
                                        update()
                                        task.wait()
                                    end
                                    while Held and Entered2 and (not dropdown_open) do
                                        local mouse_pos = gMouse()
                                        local y = ((palette.AbsoluteSize.Y - (mouse_pos.Y - palette.AbsolutePosition.Y)) + 1.5)
                                        v = y / 100
                                        Resize(saturation_indicator, {Position = UDim2.new(0, 0, 0, math.abs(y - 100))}, options.tween_time)
                                        update()
                                        task.wait()
                                    end
                                end)
                            end
                        end)
                        UIS.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                Held = false
                            end
                        end)

                        function color_picker_data:Set(color)
                            color = typeof(color) == "Color3" and color or Color3.new(1, 1, 1)
                            local h2, s2, v2 = rgbtohsv(color.r * 255, color.g * 255, color.b * 255)
                            sample.ImageColor3 = color
                            saturation.ImageColor3 = Color3.fromHSV(h2, 1, 1)
                            pcall(callback, color)
                        end
                    end

                    return color_picker_data, color_picker
                end

                function tab_data:AddConsole(console_options, _type)
                    local console_data = {}
                    console_options = typeof(console_options) == "table" and console_options or {readonly = true, full = false}
                    console_options = {
                        y = tonumber(console_options.y) or 200,
                        source = console_options.source or "Logs",
                        readonly = console_options.readonly == true,
                        full = console_options.full == true,
                    }

                    local console = Prefabs:FindFirstChild("Console"):Clone()
                    console.Parent = new_tab
                    console.ZIndex = console.ZIndex + (windows_count * 10)
                    console.Size = UDim2.new(1, 0, console_options.full and 1 or 0, console_options.y)

                    local sf = console:GetChildren()[1]
                    local Source = sf:FindFirstChild("Source")
                    local Lines = sf:FindFirstChild("Lines")
                    Source.ZIndex = Source.ZIndex + (windows_count * 10)
                    Lines.ZIndex = Lines.ZIndex + (windows_count * 10)
                    Source.TextEditable = not console_options.readonly

                    -- Syntax highlighting
                    do
                        for i,v in next, Source:GetChildren() do
                            v.ZIndex = v.ZIndex + (windows_count * 10) + 1
                        end
                        local commentsLayer = Source:FindFirstChild("Comments")
                        if commentsLayer then commentsLayer.ZIndex = commentsLayer.ZIndex + 1 end

                        local lua_keywords = {"and", "break", "do", "else", "elseif", "end", "false", "for", "function", "goto", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true", "until", "while"}
                        local global_env = {"getrawmetatable", "newcclosure", "islclosure", "setclipboard", "game", "workspace", "script", "math", "string", "table", "print", "wait", "BrickColor", "Color3", "next", "pairs", "ipairs", "select", "unpack", "Instance", "Vector2", "Vector3", "CFrame", "Ray", "UDim2", "Enum", "assert", "error", "warn", "tick", "loadstring", "_G", "shared", "getfenv", "setfenv", "newproxy", "setmetatable", "getmetatable", "os", "debug", "pcall", "ypcall", "xpcall", "rawequal", "rawset", "rawget", "tonumber", "tostring", "type", "typeof", "_VERSION", "coroutine", "delay", "require", "spawn", "LoadLibrary", "settings", "stats", "time", "UserSettings", "version", "Axes", "ColorSequence", "Faces", "ColorSequenceKeypoint", "NumberRange", "NumberSequence", "NumberSequenceKeypoint", "gcinfo", "elapsedTime", "collectgarbage", "PhysicalProperties", "Rect", "Region3", "Region3int16", "UDim", "Vector2int16", "Vector3int16", "load", "fire", "Fire","task","Parent","Name","Size","Position","Transparency","LocalPlayer","Character","HumanoidRootPart","Humanoid","Health","WalkSpeed","JumpPower","Gravity","HipHeight","MaxHealth","FogEnd","FogColor","Value","table.concat","string.find","table.find","table.clear","table.remove"}

                        local CustomMethods = {}
                        local CustomSyntax = {}
                        if(_type=="Custom")then
                            lua_keywords = {"lcall","xcall","exget","exset","xconf","xmove","nbase","xcref","xxret"}
                            global_env = {"aut","deb","bas","stk","opt"}
                            CustomSyntax = {"-","+","*",",","=","%","#","$","[","]","!","&","@","->","^"}
                            CustomMethods = {"true","false","null","deleted"}
                        end

                        for i,v in pairs(getgenv())do
                            if(not global_env[i])then
                                table.insert(global_env,i)
                            end
                        end
                        for i,v in pairs(getfenv())do
                            if(not global_env[i])then
                                table.insert(global_env,i)
                            end
                        end
                        for i,v in pairs(game:GetChildren())do
                            if(not global_env[v.Name])then
                                table.insert(global_env,v.Name)
                            end
                        end

                        local Highlight = function(string, keywords)
                            local K = {}
                            local S = string
                            local Token = {["="]=true, ["."]=true, [","]=true, ["("]=true, [")"]=true, ["["]=true, ["]"]=true, ["{"]=true, ["}"]=true, [":"]=true, ["*"]=true, ["/"]=true, ["+"]=true, ["-"]=true, ["%"]=true, [";"]=true, ["~"]=true}
                            if(_type=="Custom")then Token = CustomSyntax end
                            for i, v in pairs(keywords) do K[v] = true end
                            S = S:gsub(".", function(c)
                                if Token[c] ~= nil then return "\32" else return c end
                            end)
                            S = S:gsub("%S+", function(c)
                                if K[c] ~= nil then return c else return (" "):rep(#c) end
                            end)
                            return S
                        end

                        local function hTokens(string)
                            local Token = {["="]=true, ["."]=true, [","]=true, ["("]=true, [")"]=true, ["["]=true, ["]"]=true, ["{"]=true, ["}"]=true, [":"]=true, ["*"]=true, ["/"]=true, ["+"]=true, ["-"]=true, ["%"]=true, [";"]=true, ["~"]=true}
                            local A = ""
                            string:gsub(".", function(c)
                                if Token[c] ~= nil then A = A .. c
                                elseif c == "\n" then A = A .. "\n"
                                elseif c == "\t" then A = A .. "\t"
                                else A = A .. "\32" end
                            end)
                            return A
                        end

                        local function strings(string)
                            local highlight, quote = "", false
                            string:gsub(".", function(c)
                                if quote == false and c == "\34" then quote = true
                                elseif quote == true and c == "\34" then quote = false end
                                if quote == false and c == "\34" then highlight = highlight .. "\34"
                                elseif c == "\n" then highlight = highlight .. "\n"
                                elseif c == "\t" then highlight = highlight .. "\t"
                                elseif quote == true then highlight = highlight .. c
                                elseif quote == false then highlight = highlight .. "\32" end
                            end)
                            return highlight
                        end

                        local function info(string)
                            local highlight, quote = "", false
                            string:gsub(".", function(c)
                                if quote == false and c == "[" then quote = true
                                elseif quote == true and c == "]" then quote = false end
                                if quote == false and c == "\]" then highlight = highlight .. "\]"
                                elseif c == "\n" then highlight = highlight .. "\n"
                                elseif c == "\t" then highlight = highlight .. "\t"
                                elseif quote == true then highlight = highlight .. c
                                elseif quote == false then highlight = highlight .. "\32" end
                            end)
                            return highlight
                        end

                        local function comments(string)
                            local ret = ""
                            string:gsub("[^\r\n]+", function(c)
                                local comm, i = false, 0
                                c:gsub(".", function(n)
                                    i = i + 1
                                    if c:sub(i, i + 1) == "--" then comm = true end
                                    if comm == true then ret = ret .. n else ret = ret .. "\32" end
                                end)
                                ret = ret
                            end)
                            return ret
                        end

                        local function numbers(string)
                            local A = ""
                            string:gsub(".", function(c)
                                if tonumber(c) ~= nil then A = A .. c
                                elseif c == "\n" then A = A .. "\n"
                                elseif c == "\t" then A = A .. "\t"
                                else A = A .. "\32" end
                            end)
                            return A
                        end

                        local function highlight_lua(type)
                            if type == "Text" then
                                Source.Text = Source.Text:gsub("\13", "")
                                Source.Text = Source.Text:gsub("\t", "      ")
                                local s = Source.Text

                                local keywordsLayer = Source:FindFirstChild("Keywords")
                                local globalsLayer = Source:FindFirstChild("Globals")
                                local remoteLayer = Source:FindFirstChild("RemoteHighlight")
                                local tokensLayer = Source:FindFirstChild("Tokens")
                                local numbersLayer = Source:FindFirstChild("Numbers")
                                local stringsLayer = Source:FindFirstChild("Strings")
                                local commentsLayer = Source:FindFirstChild("Comments")

                                if keywordsLayer then keywordsLayer.Text = Highlight(s, lua_keywords) end
                                if globalsLayer then globalsLayer.Text = Highlight(s, global_env) end
                                if(_type~="Custom")then
                                    if remoteLayer then remoteLayer.Text = Highlight(s, {"FireServer", "fireServer", "InvokeServer", "invokeServer","GetService","Connect","Disconnect","GetFullName","GetChildren","GetDescendants","SetCore","GetCore","Destroy","Remove","ClearAllChildren"}) end
                                else
                                    if remoteLayer then remoteLayer.Text = Highlight(s, CustomMethods) end
                                end
                                if tokensLayer then tokensLayer.Text = hTokens(s) end
                                if numbersLayer then numbersLayer.Text = numbers(s) end
                                if stringsLayer then stringsLayer.Text = strings(s) end
                                if commentsLayer then commentsLayer.Text = comments(s) end

                                local lin = 1
                                s:gsub("\n", function() lin = lin + 1 end)
                                Lines.Text = ""
                                for i = 1, lin do Lines.Text = Lines.Text .. i .. "\n" end
                                sf.CanvasSize = UDim2.new(0, 0, lin * 0.153846154, 0)
                            end
                        end

                        local function highlight_logs(type)
                            if type == "Text" then
                                Source.Text = Source.Text:gsub("\13", "")
                                Source.Text = Source.Text:gsub("\t", "      ")
                                local s = Source.Text
                                local infoLayer = Source:FindFirstChild("Info")
                                if infoLayer then infoLayer.Text = info(s) end
                                local lin = 1
                                s:gsub("\n", function() lin = lin + 1 end)
                                sf.CanvasSize = UDim2.new(0, 0, lin * 0.153846154, 0)
                            end
                        end

                        if console_options.source == "Lua" then
                            highlight_lua("Text")
                            Source.Changed:Connect(highlight_lua)
                        elseif console_options.source == "Logs" then
                            Lines.Visible = false
                            highlight_logs("Text")
                            Source.Changed:Connect(highlight_logs)
                        end
                    end

                    function console_data:Set(code)
                        Source.Text = tostring(code)
                    end

                    function console_data:Get()
                        return Source.Text
                    end

                    function console_data:Log(msg)
                        Source.Text = Source.Text .. "[*] " .. tostring(msg) .. "\n"
                    end

                    return console_data, console
                end

                function tab_data:AddHorizontalAlignment()
                    local ha_data = {}
                    local ha = Prefabs:FindFirstChild("HorizontalAlignment"):Clone()
                    ha.Parent = new_tab

                    function ha_data:AddButton(...)
                        local data, object
                        local ret = {tab_data:AddButton(...)}
                        if typeof(ret[1]) == "table" then
                            data = ret[1]
                            object = ret[2]
                            object.Parent = ha
                            return data, object
                        else
                            object = ret[1]
                            object.Parent = ha
                            return object
                        end
                    end

                    return ha_data, ha
                end

                function tab_data:AddFolder(folder_name)
                    local folder_data = {}
                    folder_name = tostring(folder_name or "New Folder")

                    local folder = Prefabs:FindFirstChild("Folder"):Clone()
                    local button = folder:FindFirstChild("Button")
                    local objects = folder:FindFirstChild("Objects")
                    local toggle = button:FindFirstChild("Toggle")
                    folder.ZIndex = folder.ZIndex + (windows_count * 10)
                    button.ZIndex = button.ZIndex + (windows_count * 10)
                    objects.ZIndex = objects.ZIndex + (windows_count * 10)
                    toggle.ZIndex = toggle.ZIndex + (windows_count * 10)
                    
                    local bg = button:FindFirstChild("RoundBg")
                    if bg then bg.ZIndex = bg.ZIndex + (windows_count * 10) end

                    folder.Parent = new_tab
                    button.Text = "      " .. folder_name

                    spawn(function()
                        while folder and folder.Parent do
                            local bbg = button:FindFirstChild("RoundBg")
                            if bbg then bbg.ImageColor3 = options.main_color end
                            task.wait()
                        end
                    end)

                    local function gFolderLen()
                        local n = 25
                        for i,v in next, objects:GetChildren() do
                            if not (v:IsA("UIListLayout")) then
                                n = n + v.AbsoluteSize.Y + 5
                            end
                        end
                        return n
                    end

                    local open = false
                    button.MouseButton1Click:Connect(function()
                        open = not open
                        if open then
                            Resize(toggle, {Rotation = 90}, options.tween_time)
                            objects.Visible = true
                            -- Animate children
                            local children = {}
                            for _, child in pairs(objects:GetChildren()) do
                                if not child:IsA("UIListLayout") then
                                    table.insert(children, child)
                                end
                            end
                            Stagger(objects, children, {
                                staggerDelay = 0.03,
                                duration = 0.2,
                                variants = {"slide_left", "slide_right", "fade"}
                            })
                        else
                            Resize(toggle, {Rotation = 0}, options.tween_time)
                            objects.Visible = false
                        end
                    end)

                    spawn(function()
                        while folder and folder.Parent do
                            Resize(folder, {Size = UDim2.new(1, 0, 0, (open and gFolderLen() or 20))}, options.tween_time)
                            task.wait()
                        end
                    end)

                    for i,v in next, tab_data do
                        folder_data[i] = function(...)
                            local data, object
                            local ret = {v(...)}
                            if typeof(ret[1]) == "table" then
                                data = ret[1]
                                object = ret[2]
                                object.Parent = objects
                                return data, object
                            else
                                object = ret[1]
                                object.Parent = objects
                                return object
                            end
                        end
                    end

                    return folder_data, folder
                end
            end

            return tab_data, new_tab
        end
    end

    -- Fix ZIndex
    for i, v in next, Window:GetDescendants() do
        if hasprop(v, "ZIndex") then
            v.ZIndex = v.ZIndex + (windows_count * 10)
        end
    end

    return window_data, Window
end

-- ============================================
-- 🎬 FORMAT WINDOWS
-- ============================================
local function format_windows()
    local ull = Prefabs:FindFirstChild("UIListLayout"):Clone()
    ull.Parent = Windows
    local data = {}
    for i,v in next, Windows:GetChildren() do
        if not (v:IsA("UIListLayout")) then
            data[v] = v.AbsolutePosition
        end
    end
    ull:Destroy()
    for i,v in next, data do
        i.Position = UDim2.new(0, v.X, 0, v.Y)
    end
end

function library:FormatWindows()
    format_windows()
end

-- ============================================
-- 🎮 KEYBIND TOGGLE (FIXED)
-- ============================================
-- This goes at the bottom of the library, right before `return library`

local toggleKey = ui_options.toggle_key or Enum.KeyCode.RightShift

UIS.InputBegan:Connect(function(input, gameProcessed)
    -- Check if the key matches
    if input.KeyCode == toggleKey then
        -- Don't toggle if we're in the middle of binding a key
        if checks.binding then
            return
        end
        
        -- Toggle the UI
        if imgui then
            imgui.Enabled = not imgui.Enabled
            print("🔄 UI Toggled:", imgui.Enabled and "ON" or "OFF")
        end
    end
end)

print("🚀 Elerium Ultra loaded with NEXT-GEN features!")
print("✨ Spring physics | Layout animations | Gestures")
print("🔑 Press RightShift to toggle UI")

return library
