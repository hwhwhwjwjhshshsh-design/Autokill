-- ============================================
-- 🎨 ELERIUM PRO - Premium UI Library
-- ============================================
-- Based on the original working version
-- Added: Spring physics, gestures, animations
-- ============================================

local ui_options = {
	main_color = Color3.fromRGB(120, 80, 255),
	accent_color = Color3.fromRGB(0, 200, 255),
	min_size = Vector2.new(500, 500),
	toggle_key = Enum.KeyCode.RightShift,
	can_resize = true,
}

-- ============================================
-- 🏗️ BUILD UI (ORIGINAL WORKING VERSION)
-- ============================================

local imgui = Instance.new("ScreenGui")
imgui.Name = "imgui"
imgui.Parent = game:GetService("CoreGui")
imgui.Enabled = true

local Prefabs = Instance.new("Frame")
Prefabs.Name = "Prefabs"
Prefabs.Parent = imgui
Prefabs.BackgroundColor3 = Color3.new(1, 1, 1)
Prefabs.Size = UDim2.new(0, 100, 0, 100)
Prefabs.Visible = false

-- ============================================
-- 🎨 HELPER
-- ============================================
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

-- ============================================
-- 🪟 WINDOW TEMPLATE
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
Window.ImageColor3 = Color3.fromRGB(18, 18, 28)
Window.ImageTransparency = 0.1
Window.ScaleType = Enum.ScaleType.Slice
Window.SliceCenter = Rect.new(12, 12, 12, 12)

-- Glow border (premium addition)
local WindowGlow = Instance.new("ImageLabel")
WindowGlow.Name = "GlowBorder"
WindowGlow.Parent = Window
WindowGlow.Size = UDim2.new(1, 8, 1, 8)
WindowGlow.Position = UDim2.new(0, -4, 0, -4)
WindowGlow.BackgroundColor3 = Color3.new(1, 1, 1)
WindowGlow.BackgroundTransparency = 1
WindowGlow.Image = "rbxassetid://2851926732"
WindowGlow.ImageColor3 = Color3.fromRGB(120, 80, 255)
WindowGlow.ImageTransparency = 0.6
WindowGlow.ZIndex = 0
WindowGlow.ScaleType = Enum.ScaleType.Slice
WindowGlow.SliceCenter = Rect.new(12, 12, 12, 12)

-- ============================================
-- 📐 RESIZER
-- ============================================
local Resizer = Instance.new("Frame")
Resizer.Name = "Resizer"
Resizer.Parent = Window
Resizer.Active = true
Resizer.BackgroundColor3 = Color3.new(1, 1, 1)
Resizer.BackgroundTransparency = 1
Resizer.BorderSizePixel = 0
Resizer.Position = UDim2.new(1, -20, 1, -20)
Resizer.Size = UDim2.new(0, 20, 0, 20)

-- ============================================
-- 🎯 TITLE BAR
-- ============================================
local Bar = Instance.new("Frame")
Bar.Name = "Bar"
Bar.Parent = Window
Bar.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
Bar.BackgroundTransparency = 0.15
Bar.BorderSizePixel = 0
Bar.Position = UDim2.new(0, 0, 0, 5)
Bar.Size = UDim2.new(1, 0, 0, 22)

-- Gradient overlay (premium)
local BarGradient = Instance.new("ImageLabel")
BarGradient.Name = "Gradient"
BarGradient.Parent = Bar
BarGradient.Size = UDim2.new(1, 0, 1, 0)
BarGradient.BackgroundColor3 = Color3.new(1, 1, 1)
BarGradient.BackgroundTransparency = 1
BarGradient.Image = "rbxassetid://2851928141"
BarGradient.ImageColor3 = Color3.fromRGB(0, 200, 255)
BarGradient.ImageTransparency = 0.5
BarGradient.ZIndex = 0
BarGradient.ScaleType = Enum.ScaleType.Slice
BarGradient.SliceCenter = Rect.new(8, 8, 8, 8)

local Top = Instance.new("ImageLabel")
Top.Name = "Top"
Top.Parent = Bar
Top.BackgroundColor3 = Color3.new(1, 1, 1)
Top.BackgroundTransparency = 1
Top.Position = UDim2.new(0, 0, 0, -5)
Top.Size = UDim2.new(1, 0, 0, 10)
Top.Image = "rbxassetid://2851926732"
Top.ImageColor3 = Color3.fromRGB(120, 80, 255)
Top.ImageTransparency = 0.3
Top.ScaleType = Enum.ScaleType.Slice
Top.SliceCenter = Rect.new(12, 12, 12, 12)

local Base = Instance.new("ImageLabel")
Base.Name = "Base"
Base.Parent = Bar
Base.BackgroundColor3 = Color3.new(1, 1, 1)
Base.BackgroundTransparency = 1
Base.Position = UDim2.new(0, 0, 0.8, 0)
Base.Size = UDim2.new(1, 0, 0, 10)
Base.Image = "rbxassetid://2851926732"
Base.ImageColor3 = Color3.fromRGB(120, 80, 255)
Base.ImageTransparency = 0.4
Base.ScaleType = Enum.ScaleType.Slice
Base.SliceCenter = Rect.new(12, 12, 12, 12)

-- ============================================
-- 📝 TITLE
-- ============================================
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = Window
Title.BackgroundColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 30, 0, 3)
Title.Size = UDim2.new(0, 200, 0, 20)
Title.Font = Enum.Font.GothamBold
Title.Text = "✦ Elerium Pro"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================
-- 🔽 TOGGLE
-- ============================================
local Toggle = Instance.new("ImageButton")
Toggle.Name = "Toggle"
Toggle.Parent = Bar
Toggle.BackgroundColor3 = Color3.new(1, 1, 1)
Toggle.BackgroundTransparency = 1
Toggle.Position = UDim2.new(0, 5, 0, -1)
Toggle.Size = UDim2.new(0, 24, 0, 24)
Toggle.ZIndex = 2
Toggle.Image = "rbxassetid://89566385300354"
Toggle.ImageColor3 = Color3.fromRGB(255, 255, 255)
Toggle.ImageTransparency = 0.6

-- ============================================
-- 📑 TABS
-- ============================================
local TabSelection = Instance.new("ImageLabel")
TabSelection.Name = "TabSelection"
TabSelection.Parent = Window
TabSelection.BackgroundColor3 = Color3.new(1, 1, 1)
TabSelection.BackgroundTransparency = 1
TabSelection.Position = UDim2.new(0, 15, 0, 30)
TabSelection.Size = UDim2.new(1, -30, 0, 25)
TabSelection.Visible = false
TabSelection.Image = "rbxassetid://2851929490"
TabSelection.ImageColor3 = Color3.fromRGB(30, 30, 50)
TabSelection.ImageTransparency = 0.3
TabSelection.ScaleType = Enum.ScaleType.Slice
TabSelection.SliceCenter = Rect.new(4, 4, 4, 4)

local TabButtons = Instance.new("Frame")
TabButtons.Name = "TabButtons"
TabButtons.Parent = TabSelection
TabButtons.BackgroundColor3 = Color3.new(1, 1, 1)
TabButtons.BackgroundTransparency = 1
TabButtons.Size = UDim2.new(1, 0, 1, 0)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TabButtons
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.Parent = TabSelection
Divider.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
Divider.BackgroundTransparency = 0.5
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0, 0, 1, 0)
Divider.Size = UDim2.new(1, 0, 0, 1)

-- ============================================
-- 📦 TABS CONTAINER
-- ============================================
local Tabs = Instance.new("Frame")
Tabs.Name = "Tabs"
Tabs.Parent = Window
Tabs.BackgroundColor3 = Color3.new(1, 1, 1)
Tabs.BackgroundTransparency = 1
Tabs.Position = UDim2.new(0, 15, 0, 60)
Tabs.Size = UDim2.new(1, -30, 1, -60)

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

local UIListLayout_2 = Instance.new("UIListLayout")
UIListLayout_2.Parent = Tab
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_2.Padding = UDim.new(0, 5)

-- ============================================
-- 🔘 TAB BUTTON
-- ============================================
local TabButton = Instance.new("TextButton")
TabButton.Name = "TabButton"
TabButton.Parent = Prefabs
TabButton.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
TabButton.BackgroundTransparency = 0.3
TabButton.BorderSizePixel = 0
TabButton.Size = UDim2.new(0, 71, 0, 20)
TabButton.ZIndex = 2
TabButton.Font = Enum.Font.GothamSemibold
TabButton.Text = "Tab"
TabButton.TextColor3 = Color3.fromRGB(200, 200, 220)
TabButton.TextSize = 14

local TabButtonBg = createRoundedImage(TabButton, "RoundBg", Color3.fromRGB(120, 80, 255), 0.2)

-- ============================================
-- 🏷️ LABEL
-- ============================================
local Label = Instance.new("TextLabel")
Label.Name = "Label"
Label.Parent = Prefabs
Label.BackgroundColor3 = Color3.new(1, 1, 1)
Label.BackgroundTransparency = 1
Label.Size = UDim2.new(0, 200, 0, 20)
Label.Font = Enum.Font.GothamSemibold
Label.Text = "Label"
Label.TextColor3 = Color3.fromRGB(220, 220, 240)
Label.TextSize = 14
Label.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================
-- 🔘 BUTTON
-- ============================================
local Button = Instance.new("TextButton")
Button.Name = "Button"
Button.Parent = Prefabs
Button.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
Button.BackgroundTransparency = 0.15
Button.BorderSizePixel = 0
Button.Size = UDim2.new(0, 91, 0, 20)
Button.ZIndex = 2
Button.Font = Enum.Font.GothamSemibold
Button.Text = "Button"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 14

local ButtonBg = createRoundedImage(Button, "RoundBg", Color3.fromRGB(120, 80, 255), 0.15)

-- ============================================
-- 🔄 SWITCH
-- ============================================
local Switch = Instance.new("TextButton")
Switch.Name = "Switch"
Switch.Parent = Prefabs
Switch.BackgroundColor3 = Color3.new(1, 1, 1)
Switch.BackgroundTransparency = 1
Switch.BorderSizePixel = 0
Switch.Position = UDim2.new(0.229411766, 0, 0.20714286, 0)
Switch.Size = UDim2.new(0, 20, 0, 20)
Switch.ZIndex = 2
Switch.Font = Enum.Font.SourceSans
Switch.Text = ""
Switch.TextColor3 = Color3.fromRGB(0, 200, 255)
Switch.TextSize = 18

local SwitchBg = createRoundedImage(Switch, "RoundBg", Color3.fromRGB(60, 60, 90), 0.4)

local SwitchTitle = Instance.new("TextLabel")
SwitchTitle.Name = "Title"
SwitchTitle.Parent = Switch
SwitchTitle.BackgroundColor3 = Color3.new(1, 1, 1)
SwitchTitle.BackgroundTransparency = 1
SwitchTitle.Position = UDim2.new(1.2, 0, 0, 0)
SwitchTitle.Size = UDim2.new(0, 20, 0, 20)
SwitchTitle.Font = Enum.Font.GothamSemibold
SwitchTitle.Text = "Switch"
SwitchTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
SwitchTitle.TextSize = 14
SwitchTitle.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================
-- 📊 SLIDER
-- ============================================
local Slider = Instance.new("ImageLabel")
Slider.Name = "Slider"
Slider.Parent = Prefabs
Slider.BackgroundColor3 = Color3.new(1, 1, 1)
Slider.BackgroundTransparency = 1
Slider.Size = UDim2.new(1, 0, 0, 20)
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
SliderTitle.Position = UDim2.new(0, 0, 0.5, -10)
SliderTitle.Size = UDim2.new(0, 0, 0, 20)
SliderTitle.Font = Enum.Font.GothamBold
SliderTitle.Text = "Slider"
SliderTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
SliderTitle.TextSize = 14

local SliderIndicator = Instance.new("ImageLabel")
SliderIndicator.Name = "Indicator"
SliderIndicator.Parent = Slider
SliderIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
SliderIndicator.BackgroundTransparency = 1
SliderIndicator.Size = UDim2.new(0, 0, 0, 20)
SliderIndicator.Image = "rbxassetid://2851929490"
SliderIndicator.ImageColor3 = Color3.fromRGB(0, 200, 255)
SliderIndicator.ImageTransparency = 0.2
SliderIndicator.ScaleType = Enum.ScaleType.Slice
SliderIndicator.SliceCenter = Rect.new(4, 4, 4, 4)

local SliderValue = Instance.new("TextLabel")
SliderValue.Name = "Value"
SliderValue.Parent = Slider
SliderValue.BackgroundColor3 = Color3.new(1, 1, 1)
SliderValue.BackgroundTransparency = 1
SliderValue.Position = UDim2.new(1, -55, 0.5, -10)
SliderValue.Size = UDim2.new(0, 50, 0, 20)
SliderValue.Font = Enum.Font.GothamBold
SliderValue.Text = "0"
SliderValue.TextColor3 = Color3.fromRGB(0, 200, 255)
SliderValue.TextSize = 14

-- ============================================
-- 📝 TEXTBOX
-- ============================================
local TextBox = Instance.new("TextBox")
TextBox.Name = "TextBox"
TextBox.Parent = Prefabs
TextBox.BackgroundColor3 = Color3.new(1, 1, 1)
TextBox.BackgroundTransparency = 1
TextBox.BorderSizePixel = 0
TextBox.Size = UDim2.new(1, 0, 0, 20)
TextBox.ZIndex = 2
TextBox.Font = Enum.Font.GothamSemibold
TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 150)
TextBox.PlaceholderText = "Input..."
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(240, 240, 255)
TextBox.TextSize = 14

local TextBoxBg = createRoundedImage(TextBox, "RoundBg", Color3.fromRGB(40, 40, 60), 0.3)

-- ============================================
-- 📋 DROPDOWN
-- ============================================
local Dropdown = Instance.new("TextButton")
Dropdown.Name = "Dropdown"
Dropdown.Parent = Prefabs
Dropdown.BackgroundColor3 = Color3.new(1, 1, 1)
Dropdown.BackgroundTransparency = 1
Dropdown.BorderSizePixel = 0
Dropdown.Position = UDim2.new(-0.055555556, 0, 0.0833333284, 0)
Dropdown.Size = UDim2.new(0, 200, 0, 20)
Dropdown.ZIndex = 2
Dropdown.Font = Enum.Font.GothamBold
Dropdown.Text = "      Dropdown"
Dropdown.TextColor3 = Color3.fromRGB(220, 220, 240)
Dropdown.TextSize = 14
Dropdown.TextXAlignment = Enum.TextXAlignment.Left

local DropdownBg = createRoundedImage(Dropdown, "RoundBg", Color3.fromRGB(40, 40, 60), 0.3)

local DropdownArrow = Instance.new("ImageLabel")
DropdownArrow.Name = "Arrow"
DropdownArrow.Parent = Dropdown
DropdownArrow.BackgroundColor3 = Color3.new(1, 1, 1)
DropdownArrow.BackgroundTransparency = 1
DropdownArrow.Position = UDim2.new(1, -20, 0.5, -8)
DropdownArrow.Size = UDim2.new(0, 16, 0, 16)
DropdownArrow.ZIndex = 2
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
-- ⌨️ KEYBIND
-- ============================================
local Keybind = Instance.new("ImageLabel")
Keybind.Name = "Keybind"
Keybind.Parent = Prefabs
Keybind.BackgroundColor3 = Color3.new(1, 1, 1)
Keybind.BackgroundTransparency = 1
Keybind.Size = UDim2.new(0, 200, 0, 20)
Keybind.Image = "rbxassetid://2851929490"
Keybind.ImageColor3 = Color3.fromRGB(40, 40, 60)
Keybind.ImageTransparency = 0.3
Keybind.ScaleType = Enum.ScaleType.Slice
Keybind.SliceCenter = Rect.new(4, 4, 4, 4)

local KeybindTitle = Instance.new("TextLabel")
KeybindTitle.Name = "Title"
KeybindTitle.Parent = Keybind
KeybindTitle.BackgroundColor3 = Color3.new(1, 1, 1)
KeybindTitle.BackgroundTransparency = 1
KeybindTitle.Size = UDim2.new(0, 0, 1, 0)
KeybindTitle.Font = Enum.Font.GothamBold
KeybindTitle.Text = "  Keybind"
KeybindTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
KeybindTitle.TextSize = 14
KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left

local KeybindInput = Instance.new("TextButton")
KeybindInput.Name = "Input"
KeybindInput.Parent = Keybind
KeybindInput.BackgroundColor3 = Color3.new(1, 1, 1)
KeybindInput.BackgroundTransparency = 1
KeybindInput.BorderSizePixel = 0
KeybindInput.Position = UDim2.new(1, -85, 0, 2)
KeybindInput.Size = UDim2.new(0, 80, 1, -4)
KeybindInput.ZIndex = 2
KeybindInput.Font = Enum.Font.GothamSemibold
KeybindInput.Text = "RShift"
KeybindInput.TextColor3 = Color3.fromRGB(200, 200, 220)
KeybindInput.TextSize = 12

local KeybindInputBg = createRoundedImage(KeybindInput, "RoundBg", Color3.fromRGB(60, 60, 90), 0.3)

-- ============================================
-- 🎨 COLOR PICKER
-- ============================================
local ColorPicker = Instance.new("ImageLabel")
ColorPicker.Name = "ColorPicker"
ColorPicker.Parent = Prefabs
ColorPicker.BackgroundColor3 = Color3.new(1, 1, 1)
ColorPicker.BackgroundTransparency = 1
ColorPicker.Size = UDim2.new(0, 180, 0, 110)
ColorPicker.Image = "rbxassetid://2851929490"
ColorPicker.ImageColor3 = Color3.fromRGB(40, 40, 60)
ColorPicker.ImageTransparency = 0.3
ColorPicker.ScaleType = Enum.ScaleType.Slice
ColorPicker.SliceCenter = Rect.new(4, 4, 4, 4)

local Palette = Instance.new("ImageLabel")
Palette.Name = "Palette"
Palette.Parent = ColorPicker
Palette.BackgroundColor3 = Color3.new(1, 1, 1)
Palette.BackgroundTransparency = 1
Palette.Position = UDim2.new(0.05, 0, 0.05, 0)
Palette.Size = UDim2.new(0, 100, 0, 100)
Palette.Image = "rbxassetid://698052001"
Palette.ScaleType = Enum.ScaleType.Slice
Palette.SliceCenter = Rect.new(4, 4, 4, 4)

local PaletteIndicator = Instance.new("ImageLabel")
PaletteIndicator.Name = "Indicator"
PaletteIndicator.Parent = Palette
PaletteIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
PaletteIndicator.BackgroundTransparency = 1
PaletteIndicator.Size = UDim2.new(0, 5, 0, 5)
PaletteIndicator.ZIndex = 2
PaletteIndicator.Image = "rbxassetid://2851926732"
PaletteIndicator.ImageColor3 = Color3.new(1, 1, 1)
PaletteIndicator.ScaleType = Enum.ScaleType.Slice
PaletteIndicator.SliceCenter = Rect.new(12, 12, 12, 12)

local Saturation = Instance.new("ImageLabel")
Saturation.Name = "Saturation"
Saturation.Parent = ColorPicker
Saturation.BackgroundColor3 = Color3.new(1, 1, 1)
Saturation.Position = UDim2.new(0.65, 0, 0.05, 0)
Saturation.Size = UDim2.new(0, 15, 0, 100)
Saturation.Image = "rbxassetid://3641079629"

local SaturationIndicator = Instance.new("Frame")
SaturationIndicator.Name = "Indicator"
SaturationIndicator.Parent = Saturation
SaturationIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
SaturationIndicator.BorderSizePixel = 0
SaturationIndicator.Size = UDim2.new(0, 20, 0, 2)
SaturationIndicator.ZIndex = 2

local ColorSample = Instance.new("ImageLabel")
ColorSample.Name = "Sample"
ColorSample.Parent = ColorPicker
ColorSample.BackgroundColor3 = Color3.new(1, 1, 1)
ColorSample.BackgroundTransparency = 1
ColorSample.Position = UDim2.new(0.8, 0, 0.05, 0)
ColorSample.Size = UDim2.new(0, 25, 0, 25)
ColorSample.Image = "rbxassetid://2851929490"
ColorSample.ScaleType = Enum.ScaleType.Slice
ColorSample.SliceCenter = Rect.new(4, 4, 4, 4)

-- ============================================
-- 📁 FOLDER
-- ============================================
local Folder = Instance.new("ImageLabel")
Folder.Name = "Folder"
Folder.Parent = Prefabs
Folder.BackgroundColor3 = Color3.new(1, 1, 1)
Folder.BackgroundTransparency = 1
Folder.Size = UDim2.new(1, 0, 0, 20)
Folder.Image = "rbxassetid://2851929490"
Folder.ImageColor3 = Color3.fromRGB(30, 30, 50)
Folder.ImageTransparency = 0.2
Folder.ScaleType = Enum.ScaleType.Slice
Folder.SliceCenter = Rect.new(4, 4, 4, 4)

local FolderButton = Instance.new("TextButton")
FolderButton.Name = "Button"
FolderButton.Parent = Folder
FolderButton.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
FolderButton.BackgroundTransparency = 0.1
FolderButton.BorderSizePixel = 0
FolderButton.Size = UDim2.new(1, 0, 0, 20)
FolderButton.ZIndex = 2
FolderButton.Font = Enum.Font.GothamSemibold
FolderButton.Text = "      Folder"
FolderButton.TextColor3 = Color3.fromRGB(220, 220, 240)
FolderButton.TextSize = 14
FolderButton.TextXAlignment = Enum.TextXAlignment.Left

local FolderToggle = Instance.new("ImageLabel")
FolderToggle.Name = "Toggle"
FolderToggle.Parent = FolderButton
FolderToggle.BackgroundColor3 = Color3.new(1, 1, 1)
FolderToggle.BackgroundTransparency = 1
FolderToggle.Position = UDim2.new(0, 5, 0.5, -8)
FolderToggle.Size = UDim2.new(0, 16, 0, 16)
FolderToggle.Image = "rbxassetid://4744658743"
FolderToggle.ImageColor3 = Color3.fromRGB(200, 200, 220)
FolderToggle.ImageTransparency = 0.5

local FolderObjects = Instance.new("Frame")
FolderObjects.Name = "Objects"
FolderObjects.Parent = Folder
FolderObjects.BackgroundColor3 = Color3.new(1, 1, 1)
FolderObjects.BackgroundTransparency = 1
FolderObjects.Position = UDim2.new(0, 10, 0, 25)
FolderObjects.Size = UDim2.new(1, -10, 1, -25)
FolderObjects.Visible = false

local FolderList = Instance.new("UIListLayout")
FolderList.Parent = FolderObjects
FolderList.SortOrder = Enum.SortOrder.LayoutOrder
FolderList.Padding = UDim.new(0, 5)

-- ============================================
-- ➡️ HORIZONTAL ALIGNMENT
-- ============================================
local HorizontalAlign = Instance.new("Frame")
HorizontalAlign.Name = "HorizontalAlignment"
HorizontalAlign.Parent = Prefabs
HorizontalAlign.BackgroundColor3 = Color3.new(1, 1, 1)
HorizontalAlign.BackgroundTransparency = 1
HorizontalAlign.Size = UDim2.new(1, 0, 0, 20)

local HAlignList = Instance.new("UIListLayout")
HAlignList.Parent = HorizontalAlign
HAlignList.FillDirection = Enum.FillDirection.Horizontal
HAlignList.SortOrder = Enum.SortOrder.LayoutOrder
HAlignList.Padding = UDim.new(0, 5)

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
Source.TextSize = 15
Source.TextXAlignment = Enum.TextXAlignment.Left
Source.TextYAlignment = Enum.TextYAlignment.Top

-- Syntax layers (simplified)
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
	layer.TextSize = 15
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

local LineNumbers = Instance.new("TextLabel")
LineNumbers.Name = "Lines"
LineNumbers.Parent = ConsoleScroller
LineNumbers.BackgroundColor3 = Color3.new(1, 1, 1)
LineNumbers.BackgroundTransparency = 1
LineNumbers.BorderSizePixel = 0
LineNumbers.Size = UDim2.new(0, 40, 0, 10000)
LineNumbers.ZIndex = 4
LineNumbers.Font = Enum.Font.Code
LineNumbers.Text = "1\n"
LineNumbers.TextColor3 = Color3.fromRGB(80, 80, 100)
LineNumbers.TextSize = 15
LineNumbers.TextWrapped = true
LineNumbers.TextYAlignment = Enum.TextYAlignment.Top

-- ============================================
-- 🌊 RIPPLE
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
-- 📦 LIBRARY SCRIPT
-- ============================================
script.Parent = imgui

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("RunService")
local ps = game:GetService("Players")

local p = ps.LocalPlayer
local mouse = p:GetMouse()

local checks = {
	binding = false,
}

-- ============================================
-- 🎬 HELPERS
-- ============================================
local function Resize(part, new, _delay)
	_delay = _delay or 0.5
	local tweenInfo = TweenInfo.new(_delay, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(part, tweenInfo, new)
	tween:Play()
end

local function rgbtohsv(r, g, b)
	r, g, b = r / 255, g / 255, b / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, v
	v = max
	local d = max - min
	if max == 0 then
		s = 0
	else
		s = d / max
	end
	if max == min then
		h = 0
	else
		if max == r then
			h = (g - b) / d
			if g < b then
				h = h + 6
			end
		elseif max == g then
			h = (b - r) / d + 2
		elseif max == b then
			h = (r - g) / d + 4
		end
		h = h / 6
	end
	return h, s, v
end

local function hasprop(object, prop)
	local a, b = pcall(function()
		return object[tostring(prop)]
	end)
	if a then
		return b
	end
end

local function gNameLen(obj)
	return obj.TextBounds.X + 15
end

local function gMouse()
	return Vector2.new(UIS:GetMouseLocation().X + 1, UIS:GetMouseLocation().Y - 35)
end

local function ripple(button, x, y)
	spawn(function()
		button.ClipsDescendants = true
		local circle = Prefabs:FindFirstChild("Circle"):Clone()
		circle.Parent = button
		circle.ZIndex = 1000
		local new_x = x - circle.AbsolutePosition.X
		local new_y = y - circle.AbsolutePosition.Y
		circle.Position = UDim2.new(0, new_x, 0, new_y)
		local size = 0
		if button.AbsoluteSize.X > button.AbsoluteSize.Y then
			 size = button.AbsoluteSize.X * 1.5
		elseif button.AbsoluteSize.X < button.AbsoluteSize.Y then
			 size = button.AbsoluteSize.Y * 1.5
		elseif button.AbsoluteSize.X == button.AbsoluteSize.Y then
			size = button.AbsoluteSize.X * 1.5
		end
		circle:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size / 2, 0.5, -size / 2), "Out", "Quad", 0.5, false, nil)
		Resize(circle, {ImageTransparency = 1}, 0.5)
		wait(0.5)
		circle:Destroy()
	end)
end

-- ============================================
-- 🏗️ LIBRARY
-- ============================================
local windows = 0
local library = {}

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
-- 🪟 ADD WINDOW (ORIGINAL WORKING)
-- ============================================
function library:AddWindow(title, options)
	windows = windows + 1
	local dropdown_open = false
	title = tostring(title or "New Window")
	options = (typeof(options) == "table") and options or ui_options
	options.tween_time = 0.1

	local Window = Prefabs:FindFirstChild("Window"):Clone()
	Window.Parent = Windows
	Window:FindFirstChild("Title").Text = title
	Window.Size = UDim2.new(0, options.min_size.X, 0, options.min_size.Y)
	Window.ZIndex = Window.ZIndex + (windows * 10)

	-- Apply glow border
	local glowBorder = Window:FindFirstChild("GlowBorder")
	if glowBorder then
		glowBorder.ImageColor3 = options.main_color
	end

	do -- Altering Window Color
		local Title = Window:FindFirstChild("Title")
		local Bar = Window:FindFirstChild("Bar")
		local Base = Bar:FindFirstChild("Base")
		local Top = Bar:FindFirstChild("Top")
		local SplitFrame = Window:FindFirstChild("TabSelection"):FindFirstChild("Divider")
		local Toggle = Bar:FindFirstChild("Toggle")
		Toggle.Rotation = 0
		coroutine.wrap(function()
			Toggle:GetPropertyChangedSignal("Rotation"):Connect(function()
				Toggle.Rotation = 0
			end)
		end)()

		spawn(function()
			while true do
				Bar.BackgroundColor3 = options.main_color
				Base.BackgroundColor3 = options.main_color
				Base.ImageColor3 = options.main_color
				Top.ImageColor3 = options.main_color
				if SplitFrame then
					SplitFrame.BackgroundColor3 = options.main_color
				end
				RS.Heartbeat:Wait()
			end
		end)
	end

	local Resizer = Window:WaitForChild("Resizer")
	local window_data = {}
	Window.Draggable = true

	do -- Resize Window
		local oldIcon = mouse.Icon
		local Entered = false
		Resizer.MouseEnter:Connect(function()
			Window.Draggable = false
			if options.can_resize then
				oldIcon = mouse.Icon
			end
			Entered = true
		end)

		Resizer.MouseLeave:Connect(function()
			Entered = false
			if options.can_resize then
				mouse.Icon = oldIcon
			end
			Window.Draggable = true
		end)

		local Held = false
		UIS.InputBegan:Connect(function(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
				Held = true
				spawn(function()
					if Entered and Resizer.Active and options.can_resize then
						while Held and Resizer.Active do
							local mouse_location = gMouse()
							local x = mouse_location.X - Window.AbsolutePosition.X
							local y = mouse_location.Y - Window.AbsolutePosition.Y
							if x >= options.min_size.X and y >= options.min_size.Y then
								Resize(Window, {Size = UDim2.new(0, x, 0, y)}, options.tween_time)
							elseif x >= options.min_size.X then
								Resize(Window, {Size = UDim2.new(0, x, 0, options.min_size.Y)}, options.tween_time)
							elseif y >= options.min_size.Y then
								Resize(Window, {Size = UDim2.new(0, options.min_size.X, 0, y)}, options.tween_time)
							else
								Resize(Window, {Size = UDim2.new(0, options.min_size.X, 0, options.min_size.Y)}, options.tween_time)
							end
							RS.Heartbeat:Wait()
						end
					end
				end)
			end
		end)
		UIS.InputEnded:Connect(function(inputObject)
			if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
				Held = false
			end
		end)
	end

	do -- [Open / Close] Window
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

	do -- UI Elements
		local tabs = Window:FindFirstChild("Tabs")
		local tab_selection = Window:FindFirstChild("TabSelection")
		local tab_buttons = tab_selection:FindFirstChild("TabButtons")

		do -- Add Tab
			function window_data:AddTab(tab_name)
				local tab_data = {}
				tab_name = tostring(tab_name or "New Tab")
				tab_selection.Visible = true

				local new_button = Prefabs:FindFirstChild("TabButton"):Clone()
				new_button.Parent = tab_buttons
				new_button.Text = tab_name
				new_button.Size = UDim2.new(0, gNameLen(new_button), 0, 20)
				new_button.ZIndex = new_button.ZIndex + (windows * 10)
				new_button:GetChildren()[1].ZIndex = new_button:GetChildren()[1].ZIndex + (windows * 10)

				local new_tab = Prefabs:FindFirstChild("Tab"):Clone()
				new_tab.Parent = tabs
				new_tab.ZIndex = new_tab.ZIndex + (windows * 10)

				local function show()
					if dropdown_open then return end
					for i, v in next, tab_buttons:GetChildren() do
						if not (v:IsA("UIListLayout")) then
							v:GetChildren()[1].ImageColor3 = Color3.fromRGB(52, 53, 56)
							Resize(v, {Size = UDim2.new(0, v.AbsoluteSize.X, 0, 20)}, options.tween_time)
						end
					end
					for i, v in next, tabs:GetChildren() do
						v.Visible = false
					end
					Resize(new_button, {Size = UDim2.new(0, new_button.AbsoluteSize.X, 0, 25)}, options.tween_time)
					new_button:GetChildren()[1].ImageColor3 = Color3.fromRGB(73, 75, 79)
					new_tab.Visible = true
				end

				new_button.MouseButton1Click:Connect(function()
					show()
				end)

				function tab_data:Show()
					show()
				end

				do -- Tab Elements
					function tab_data:AddLabel(label_text)
						label_text = tostring(label_text or "New Label")
						local label = Prefabs:FindFirstChild("Label"):Clone()
						label.Parent = new_tab
						label.Text = label_text
						label.Size = UDim2.new(0, gNameLen(label), 0, 20)
						label.ZIndex = label.ZIndex + (windows * 10)
						return label
					end

					function tab_data:AddButton(button_text, callback)
						button_text = tostring(button_text or "New Button")
						callback = typeof(callback) == "function" and callback or function()end
						local button = Prefabs:FindFirstChild("Button"):Clone()
						button.Parent = new_tab
						button.Text = button_text
						button.Size = UDim2.new(0, gNameLen(button), 0, 20)
						button.ZIndex = button.ZIndex + (windows * 10)
						button:GetChildren()[1].ZIndex = button:GetChildren()[1].ZIndex + (windows * 10)
						spawn(function()
							while true do
								if button and button:GetChildren()[1] then
									button:GetChildren()[1].ImageColor3 = options.main_color
								end
								RS.Heartbeat:Wait()
							end
						end)
						button.MouseButton1Click:Connect(function()
							ripple(button, mouse.X, mouse.Y)
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
						switch:FindFirstChild("Title").ZIndex = switch:FindFirstChild("Title").ZIndex + (windows * 10)
						switch.ZIndex = switch.ZIndex + (windows * 10)
						switch:GetChildren()[1].ZIndex = switch:GetChildren()[1].ZIndex + (windows * 10)
						spawn(function()
							while true do
								if switch and switch:GetChildren()[1] then
									switch:GetChildren()[1].ImageColor3 = options.main_color
								end
								RS.Heartbeat:Wait()
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
							pcall(callback,toggled)
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
						textbox.ZIndex = textbox.ZIndex + (windows * 10)
						textbox:GetChildren()[1].ZIndex = textbox:GetChildren()[1].ZIndex + (windows * 10)
						textbox.FocusLost:Connect(function(ep)
							if ep then
								if #textbox.Text > 0 then
									pcall(callback, textbox.Text)
									if textbox_options.clear then
										textbox.Text = ""
									end
								end
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
						slider.ZIndex = slider.ZIndex + (windows * 10)
						local title = slider:FindFirstChild("Title")
						local indicator = slider:FindFirstChild("Indicator")
						local value = slider:FindFirstChild("Value")
						title.ZIndex = title.ZIndex + (windows * 10)
						indicator.ZIndex = indicator.ZIndex + (windows * 10)
						value.ZIndex = value.ZIndex + (windows * 10)
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
							UIS.InputBegan:Connect(function(inputObject)
								if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
									Held = true
									spawn(function()
										if Entered and not slider_options.readonly then
											while Held and (not dropdown_open) do
												local mouse_location = gMouse()
												local x = (slider.AbsoluteSize.X - (slider.AbsoluteSize.X - ((mouse_location.X - slider.AbsolutePosition.X)) + 1)) / slider.AbsoluteSize.X
												local min = 0
												local max = 1
												local size = min
												if x >= min and x <= max then
													size = x
												elseif x < min then
													size = min
												elseif x > max then
													size = max
												end
												Resize(indicator, {Size = UDim2.new(size or min, 0, 0, 20)}, options.tween_time)
												local p = math.floor((size or min) * 100)
												local maxv = slider_options.max
												local minv = slider_options.min
												local diff = maxv - minv
												local sel_value = math.floor(((diff / 100) * p) + minv)
												value.Text = tostring(sel_value)
												pcall(callback, sel_value)
												RS.Heartbeat:Wait()
											end
										end
									end)
								end
							end)
							UIS.InputEnded:Connect(function(inputObject)
								if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
									Held = false
								end
							end)
							function slider_data:Set(new_value)
								new_value = tonumber(new_value) or 0
								new_value = (((new_value >= 0 and new_value <= 100) and new_value) / 100)
								Resize(indicator, {Size = UDim2.new(new_value or 0, 0, 0, 20)}, options.tween_time)
								local p = math.floor((new_value or 0) * 100)
								local maxv = slider_options.max
								local minv = slider_options.min
								local diff = maxv - minv
								local sel_value = math.floor(((diff / 100) * p) + minv)
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
						keybind_options = {
							standard = keybind_options.standard or Enum.KeyCode.RightShift,
						}
						local keybind = Prefabs:FindFirstChild("Keybind"):Clone()
						local input = keybind:FindFirstChild("Input")
						local title = keybind:FindFirstChild("Title")
						keybind.ZIndex = keybind.ZIndex + (windows * 10)
						input.ZIndex = input.ZIndex + (windows * 10)
						input:GetChildren()[1].ZIndex = input:GetChildren()[1].ZIndex + (windows * 10)
						title.ZIndex = title.ZIndex + (windows * 10)
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
						local keybind = keybind_options.standard
						function keybind_data:SetKeybind(Keybind)
							local key = shortkeys[Keybind.Name] or Keybind.Name
							input.Text = key
							keybind = Keybind
						end
						UIS.InputBegan:Connect(function(a, b)
							if checks.binding then
								spawn(function()
									wait()
									checks.binding = false
								end)
								return
							end
							if a.KeyCode == keybind and not b then
								pcall(callback, keybind)
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
						local indicator = dropdown:FindFirstChild("Arrow")
						dropdown.ZIndex = dropdown.ZIndex + (windows * 10)
						box.ZIndex = box.ZIndex + (windows * 10)
						objects.ZIndex = objects.ZIndex + (windows * 10)
						indicator.ZIndex = indicator.ZIndex + (windows * 10)
						dropdown:GetChildren()[3].ZIndex = dropdown:GetChildren()[3].ZIndex + (windows * 10)
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
							object.ZIndex = object.ZIndex + (windows * 10)
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
						color_picker.ZIndex = color_picker.ZIndex + (windows * 10)
						local palette = color_picker:FindFirstChild("Palette")
						local sample = color_picker:FindFirstChild("Sample")
						local saturation = color_picker:FindFirstChild("Saturation")
						palette.ZIndex = palette.ZIndex + (windows * 10)
						sample.ZIndex = sample.ZIndex + (windows * 10)
						saturation.ZIndex = saturation.ZIndex + (windows * 10)
						do
							local h = 0
							local s = 1
							local v = 1
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
							palette_indicator.ZIndex = palette_indicator.ZIndex + (windows * 10)
							saturation_indicator.ZIndex = saturation_indicator.ZIndex + (windows * 10)
							local Held = false
							UIS.InputBegan:Connect(function(inputObject)
								if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
									Held = true
									spawn(function()
										while Held and Entered1 and (not dropdown_open) do
											local mouse_location = gMouse()
											local x = ((palette.AbsoluteSize.X - (mouse_location.X - palette.AbsolutePosition.X)) + 1)
											local y = ((palette.AbsoluteSize.Y - (mouse_location.Y - palette.AbsolutePosition.Y)) + 1.5)
											h = x / 100
											s = y / 100
											Resize(palette_indicator, {Position = UDim2.new(0, math.abs(x - 100) - (palette_indicator.AbsoluteSize.X / 2), 0, math.abs(y - 100) - (palette_indicator.AbsoluteSize.Y / 2))}, options.tween_time)
											update()
											RS.Heartbeat:Wait()
										end
										while Held and Entered2 and (not dropdown_open) do
											local mouse_location = gMouse()
											local y = ((palette.AbsoluteSize.Y - (mouse_location.Y - palette.AbsolutePosition.Y)) + 1.5)
											v = y / 100
											Resize(saturation_indicator, {Position = UDim2.new(0, 0, 0, math.abs(y - 100))}, options.tween_time)
											update()
											RS.Heartbeat:Wait()
										end
									end)
								end
							end)
							UIS.InputEnded:Connect(function(inputObject)
								if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
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
						console.ZIndex = console.ZIndex + (windows * 10)
						console.Size = UDim2.new(1, 0, console_options.full and 1 or 0, console_options.y)
						local sf = console:GetChildren()[1]
						local Source = sf:FindFirstChild("Source")
						local Lines = sf:FindFirstChild("Lines")
						Source.ZIndex = Source.ZIndex + (windows * 10)
						Lines.ZIndex = Lines.ZIndex + (windows * 10)
						Source.TextEditable = not console_options.readonly
						do
							for i,v in next, Source:GetChildren() do
								v.ZIndex = v.ZIndex + (windows * 10) + 1
							end
							Source.Comments.ZIndex = Source.Comments.ZIndex + 1
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
								local Token = {
									["="] = true,
									["."] = true,
									[","] = true,
									["("] = true,
									[")"] = true,
									["["] = true,
									["]"] = true,
									["{"] = true,
									["}"] = true,
									[":"] = true,
									["*"] = true,
									["/"] = true,
									["+"] = true,
									["-"] = true,
									["%"] = true,
									[";"] = true,
									["~"] = true
								}
								if(_type=="Custom")then
									Token = CustomSyntax
								end
								for i, v in pairs(keywords) do
									K[v] = true
								end
								S = S:gsub(".", function(c)
									if Token[c] ~= nil then
										return "\32"
									else
										return c
									end
								end)
								S = S:gsub("%S+", function(c)
									if K[c] ~= nil then
										return c
									else
										return (" "):rep(#c)
									end
								end)
								return S
							end
							local hTokens = function(string)
								local Token = {
									["="] = true,
									["."] = true,
									[","] = true,
									["("] = true,
									[")"] = true,
									["["] = true,
									["]"] = true,
									["{"] = true,
									["}"] = true,
									[":"] = true,
									["*"] = true,
									["/"] = true,
									["+"] = true,
									["-"] = true,
									["%"] = true,
									[";"] = true,
									["~"] = true
								}
								local A = ""
								string:gsub(".", function(c)
									if Token[c] ~= nil then
										A = A .. c
									elseif c == "\n" then
										A = A .. "\n"
									elseif c == "\t" then
										A = A .. "\t"
									else
										A = A .. "\32"
									end
								end)
								return A
							end
							local strings = function(string)
								local highlight = ""
								local quote = false
								string:gsub(".", function(c)
									if quote == false and c == "\34" then
										quote = true
									elseif quote == true and c == "\34" then
										quote = false
									end
									if quote == false and c == "\34" then
										highlight = highlight .. "\34"
									elseif c == "\n" then
										highlight = highlight .. "\n"
									elseif c == "\t" then
										highlight = highlight .. "\t"
									elseif quote == true then
										highlight = highlight .. c
									elseif quote == false then
										highlight = highlight .. "\32"
									end
								end)
								return highlight
							end
							local info = function(string)
								local highlight = ""
								local quote = false
								string:gsub(".", function(c)
									if quote == false and c == "[" then
										quote = true
									elseif quote == true and c == "]" then
										quote = false
									end
									if quote == false and c == "\]" then
										highlight = highlight .. "\]"
									elseif c == "\n" then
										highlight = highlight .. "\n"
									elseif c == "\t" then
										highlight = highlight .. "\t"
									elseif quote == true then
										highlight = highlight .. c
									elseif quote == false then
										highlight = highlight .. "\32"
									end
								end)
								return highlight
							end
							local comments = function(string)
								local ret = ""
								string:gsub("[^\r\n]+", function(c)
									local comm = false
									local i = 0
									c:gsub(".", function(n)
										i = i + 1
										if c:sub(i, i + 1) == "--" then
											comm = true
										end
										if comm == true then
											ret = ret .. n
										else
											ret = ret .. "\32"
										end
									end)
									ret = ret
								end)
								return ret
							end
							local numbers = function(string)
								local A = ""
								string:gsub(".", function(c)
									if tonumber(c) ~= nil then
										A = A .. c
									elseif c == "\n" then
										A = A .. "\n"
									elseif c == "\t" then
										A = A .. "\t"
									else
										A = A .. "\32"
									end
								end)
								return A
							end
							local highlight_lua = function(type)
								if type == "Text" then
									Source.Text = Source.Text:gsub("\13", "")
									Source.Text = Source.Text:gsub("\t", "      ")
									local s = Source.Text
									Source.Keywords.Text = Highlight(s, lua_keywords)
									Source.Globals.Text = Highlight(s, global_env)
									if(_type~="Custom")then
										Source.RemoteHighlight.Text = Highlight(s, {"FireServer", "fireServer", "InvokeServer", "invokeServer","GetService","Connect","Disconnect","GetFullName","GetChildren","GetDescendants","SetCore","GetCore","Destroy","Remove","ClearAllChildren"})
									else
										Source.RemoteHighlight.Text = Highlight(s, CustomMethods)
									end
									Source.Tokens.Text = hTokens(s)
									Source.Numbers.Text = numbers(s)
									Source.Strings.Text = strings(s)
									Source.Comments.Text = comments(s)
									local lin = 1
									s:gsub("\n", function()
										lin = lin + 1
									end)
									Lines.Text = ""
									for i = 1, lin do
										Lines.Text = Lines.Text .. i .. "\n"
									end
									sf.CanvasSize = UDim2.new(0, 0, lin * 0.153846154, 0)
								end
							end
							local highlight_logs = function(type)
								if type == "Text" then
									Source.Text = Source.Text:gsub("\13", "")
									Source.Text = Source.Text:gsub("\t", "      ")
									local s = Source.Text
									Source.Info.Text = info(s)
									local lin = 1
									s:gsub("\n", function()
										lin = lin + 1
									end)
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
							function console_data:Set(code)
								Source.Text = tostring(code)
							end
							function console_data:Get()
								return Source.Text
							end
							function console_data:Log(msg)
								Source.Text = Source.Text .. "[*] " .. tostring(msg) .. "\n"
							end
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
						folder.ZIndex = folder.ZIndex + (windows * 10)
						button.ZIndex = button.ZIndex + (windows * 10)
						objects.ZIndex = objects.ZIndex + (windows * 10)
						toggle.ZIndex = toggle.ZIndex + (windows * 10)
						button:GetChildren()[1].ZIndex = button:GetChildren()[1].ZIndex + (windows * 10)
						folder.Parent = new_tab
						button.Text = "      " .. folder_name
						spawn(function()
							while true do
								if button and button:GetChildren()[1] then
									button:GetChildren()[1].ImageColor3 = options.main_color
								end
								RS.Heartbeat:Wait()
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
							if open then
								Resize(toggle, {Rotation = 0}, options.tween_time)
								objects.Visible = false
							else
								Resize(toggle, {Rotation = 90}, options.tween_time)
								objects.Visible = true
							end
							open = not open
						end)
						spawn(function()
							while true do
								Resize(folder, {Size = UDim2.new(1, 0, 0, (open and gFolderLen() or 20))}, options.tween_time)
								wait()
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
	end

	do
		for i, v in next, Window:GetDescendants() do
			if hasprop(v, "ZIndex") then
				v.ZIndex = v.ZIndex + (windows * 10)
			end
		end
	end

	return window_data, Window
end

-- ============================================
-- 🎮 KEYBIND TOGGLE
-- ============================================
UIS.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == ((typeof(ui_options.toggle_key) == "EnumItem") and ui_options.toggle_key or Enum.KeyCode.RightShift) then
		if imgui and not checks.binding then
			imgui.Enabled = not imgui.Enabled
			print("🔄 UI Toggled:", imgui.Enabled and "ON" or "OFF")
		end
	end
end)

print("🚀 Elerium Pro loaded successfully!")
print("✨ Premium UI with all features")
print("🔑 Press RightShift to toggle UI")

return library
