local ui_options = {
    main_color = Color3.fromRGB(41, 74, 122),
    min_size = Vector2.new(400, 300),
    toggle_key = Enum.KeyCode.RightShift,
    can_resize = true
}

do
    local old = game:GetService("CoreGui"):FindFirstChild("imgui")
    if old then old:Destroy() end
end

local gui = Instance.new("ScreenGui")
gui.Name = "imgui"
gui.Parent = game:GetService("CoreGui") or gethui()

local prefabs = Instance.new("Frame")
prefabs.Name = "Prefabs"
prefabs.Parent = gui
prefabs.BackgroundColor3 = Color3.new(1, 1, 1)
prefabs.Size = UDim2.new(0, 100, 0, 100)
prefabs.Visible = false

-- Label
local label = Instance.new("TextLabel")
label.Name = "Label"
label.Parent = prefabs
label.BackgroundColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.Size = UDim2.new(0, 200, 0, 20)
label.Font = Enum.Font.GothamSemibold
label.Text = "Hello, world 123"
label.TextColor3 = Color3.new(1, 1, 1)
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Left

-- Window
local window = Instance.new("ImageLabel")
window.Name = "Window"
window.Parent = prefabs
window.Active = true
window.BackgroundColor3 = Color3.new(1, 1, 1)
window.BackgroundTransparency = 1
window.ClipsDescendants = true
window.Position = UDim2.new(0, 20, 0, 20)
window.Selectable = true
window.Size = UDim2.new(0, 200, 0, 200)
window.Image = "rbxassetid://2851926732"
window.ImageColor3 = Color3.new(0.0823529, 0.0862745, 0.0901961)
window.ScaleType = Enum.ScaleType.Slice
window.SliceCenter = Rect.new(12, 12, 12, 12)

-- Resizer
local resizer = Instance.new("Frame")
resizer.Name = "Resizer"
resizer.Parent = window
resizer.Active = true
resizer.BackgroundColor3 = Color3.new(1, 1, 1)
resizer.BackgroundTransparency = 1
resizer.BorderSizePixel = 0
resizer.Position = UDim2.new(1, -20, 1, -20)
resizer.Size = UDim2.new(0, 20, 0, 20)

-- Bar
local bar = Instance.new("Frame")
bar.Name = "Bar"
bar.Parent = window
bar.BackgroundColor3 = Color3.new(0.160784, 0.290196, 0.478431)
bar.BorderSizePixel = 0
bar.Position = UDim2.new(0, 0, 0, 5)
bar.Size = UDim2.new(1, 0, 0, 15)

-- Toggle
local toggle = Instance.new("ImageButton")
toggle.Name = "Toggle"
toggle.Parent = bar
toggle.BackgroundColor3 = Color3.new(1, 1, 1)
toggle.BackgroundTransparency = 1
toggle.Position = UDim2.new(0, 5, 0, -2)
toggle.Rotation = 90
toggle.Size = UDim2.new(0, 20, 0, 20)
toggle.ZIndex = 2
toggle.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId=116780206008533"

-- Base
local base = Instance.new("ImageLabel")
base.Name = "Base"
base.Parent = bar
base.BackgroundColor3 = Color3.new(0.160784, 0.290196, 0.478431)
base.BorderSizePixel = 0
base.Position = UDim2.new(0, 0, 0.800000012, 0)
base.Size = UDim2.new(1, 0, 0, 10)
base.Image = "rbxassetid://2851926732"
base.ImageColor3 = Color3.new(0.160784, 0.290196, 0.478431)
base.ScaleType = Enum.ScaleType.Slice
base.SliceCenter = Rect.new(12, 12, 12, 12)

-- Top
local top = Instance.new("ImageLabel")
top.Name = "Top"
top.Parent = bar
top.BackgroundColor3 = Color3.new(1, 1, 1)
top.BackgroundTransparency = 1
top.Position = UDim2.new(0, 0, 0, -5)
top.Size = UDim2.new(1, 0, 0, 10)
top.Image = "rbxassetid://2851926732"
top.ImageColor3 = Color3.new(0.160784, 0.290196, 0.478431)
top.ScaleType = Enum.ScaleType.Slice
top.SliceCenter = Rect.new(12, 12, 12, 12)

-- Tabs
local tabs = Instance.new("Frame")
tabs.Name = "Tabs"
tabs.Parent = window
tabs.BackgroundColor3 = Color3.new(1, 1, 1)
tabs.BackgroundTransparency = 1
tabs.Position = UDim2.new(0, 15, 0, 60)
tabs.Size = UDim2.new(1, -30, 1, -60)

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Parent = window
title.BackgroundColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 30, 0, 3)
title.Size = UDim2.new(0, 200, 0, 20)
title.Font = Enum.Font.GothamBold
title.Text = "Gamer Time"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- TabSelection
local tabSelection = Instance.new("ImageLabel")
tabSelection.Name = "TabSelection"
tabSelection.Parent = window
tabSelection.BackgroundColor3 = Color3.new(1, 1, 1)
tabSelection.BackgroundTransparency = 1
tabSelection.Position = UDim2.new(0, 15, 0, 30)
tabSelection.Size = UDim2.new(1, -30, 0, 25)
tabSelection.Visible = false
tabSelection.Image = "rbxassetid://2851929490"
tabSelection.ImageColor3 = Color3.new(0.145098, 0.14902, 0.156863)
tabSelection.ScaleType = Enum.ScaleType.Slice
tabSelection.SliceCenter = Rect.new(4, 4, 4, 4)

-- TabButtons
local tabButtons = Instance.new("Frame")
tabButtons.Name = "TabButtons"
tabButtons.Parent = tabSelection
tabButtons.BackgroundColor3 = Color3.new(1, 1, 1)
tabButtons.BackgroundTransparency = 1
tabButtons.Size = UDim2.new(1, 0, 1, 0)

local tabList = Instance.new("UIListLayout")
tabList.Parent = tabButtons
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0, 2)

-- Line
local line = Instance.new("Frame")
line.Parent = tabSelection
line.BackgroundColor3 = Color3.new(0.12549, 0.227451, 0.372549)
line.BorderColor3 = Color3.new(0.105882, 0.164706, 0.207843)
line.BorderSizePixel = 0
line.Position = UDim2.new(0, 0, 1, 0)
line.Size = UDim2.new(1, 0, 0, 2)

-- Tab
local tab = Instance.new("Frame")
tab.Name = "Tab"
tab.Parent = prefabs
tab.BackgroundColor3 = Color3.new(1, 1, 1)
tab.BackgroundTransparency = 1
tab.Size = UDim2.new(1, 0, 1, 0)
tab.Visible = false

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = tab
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 5)

-- TextBox
local textbox = Instance.new("TextBox")
textbox.Parent = prefabs
textbox.BackgroundColor3 = Color3.new(1, 1, 1)
textbox.BackgroundTransparency = 1
textbox.BorderSizePixel = 0
textbox.Size = UDim2.new(1, 0, 0, 20)
textbox.ZIndex = 2
textbox.Font = Enum.Font.GothamSemibold
textbox.PlaceholderColor3 = Color3.new(0.698039, 0.698039, 0.698039)
textbox.PlaceholderText = "Input Text"
textbox.Text = ""
textbox.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
textbox.TextSize = 14

local textboxBg = Instance.new("ImageLabel")
textboxBg.Name = "TextBox_Roundify_4px"
textboxBg.Parent = textbox
textboxBg.BackgroundColor3 = Color3.new(1, 1, 1)
textboxBg.BackgroundTransparency = 1
textboxBg.Size = UDim2.new(1, 0, 1, 0)
textboxBg.Image = "rbxassetid://2851929490"
textboxBg.ImageColor3 = Color3.new(0.203922, 0.207843, 0.219608)
textboxBg.ScaleType = Enum.ScaleType.Slice
textboxBg.SliceCenter = Rect.new(4, 4, 4, 4)

-- Slider
local slider = Instance.new("ImageLabel")
slider.Name = "Slider"
slider.Parent = prefabs
slider.BackgroundColor3 = Color3.new(1, 1, 1)
slider.BackgroundTransparency = 1
slider.Position = UDim2.new(0, 0, 0.178571433, 0)
slider.Size = UDim2.new(1, 0, 0, 20)
slider.Image = "rbxassetid://2851929490"
slider.ImageColor3 = Color3.new(0.145098, 0.14902, 0.156863)
slider.ScaleType = Enum.ScaleType.Slice
slider.SliceCenter = Rect.new(4, 4, 4, 4)

local sliderTitle = Instance.new("TextLabel")
sliderTitle.Name = "Title"
sliderTitle.Parent = slider
sliderTitle.BackgroundColor3 = Color3.new(1, 1, 1)
sliderTitle.BackgroundTransparency = 1
sliderTitle.Position = UDim2.new(0.5, 0, 0.5, -10)
sliderTitle.Size = UDim2.new(0, 0, 0, 20)
sliderTitle.ZIndex = 2
sliderTitle.Font = Enum.Font.GothamBold
sliderTitle.Text = "Slider"
sliderTitle.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
sliderTitle.TextSize = 14

local sliderIndicator = Instance.new("ImageLabel")
sliderIndicator.Name = "Indicator"
sliderIndicator.Parent = slider
sliderIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
sliderIndicator.BackgroundTransparency = 1
sliderIndicator.Size = UDim2.new(0, 0, 0, 20)
sliderIndicator.Image = "rbxassetid://2851929490"
sliderIndicator.ImageColor3 = Color3.new(0.254902, 0.262745, 0.278431)
sliderIndicator.ScaleType = Enum.ScaleType.Slice
sliderIndicator.SliceCenter = Rect.new(4, 4, 4, 4)

local sliderValue = Instance.new("TextLabel")
sliderValue.Name = "Value"
sliderValue.Parent = slider
sliderValue.BackgroundColor3 = Color3.new(1, 1, 1)
sliderValue.BackgroundTransparency = 1
sliderValue.Position = UDim2.new(1, -55, 0.5, -10)
sliderValue.Size = UDim2.new(0, 50, 0, 20)
sliderValue.Font = Enum.Font.GothamBold
sliderValue.Text = "0%"
sliderValue.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
sliderValue.TextSize = 14

local bracketR = Instance.new("TextLabel")
bracketR.Parent = slider
bracketR.BackgroundColor3 = Color3.new(1, 1, 1)
bracketR.BackgroundTransparency = 1
bracketR.Position = UDim2.new(1, -20, -0.75, 0)
bracketR.Size = UDim2.new(0, 26, 0, 50)
bracketR.Font = Enum.Font.GothamBold
bracketR.Text = "]"
bracketR.TextColor3 = Color3.new(0.627451, 0.627451, 0.627451)
bracketR.TextSize = 14

local bracketL = Instance.new("TextLabel")
bracketL.Parent = slider
bracketL.BackgroundColor3 = Color3.new(1, 1, 1)
bracketL.BackgroundTransparency = 1
bracketL.Position = UDim2.new(1, -65, -0.75, 0)
bracketL.Size = UDim2.new(0, 26, 0, 50)
bracketL.Font = Enum.Font.GothamBold
bracketL.Text = "["
bracketL.TextColor3 = Color3.new(0.627451, 0.627451, 0.627451)
bracketL.TextSize = 14

-- Circle
local circle = Instance.new("ImageLabel")
circle.Name = "Circle"
circle.Parent = prefabs
circle.BackgroundColor3 = Color3.new(1, 1, 1)
circle.BackgroundTransparency = 1
circle.Image = "rbxassetid://266543268"
circle.ImageTransparency = 0.5

local layout = Instance.new("UIListLayout")
layout.Parent = prefabs
layout.FillDirection = Enum.FillDirection.Horizontal
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 20)

-- Dropdown
local dropdown = Instance.new("TextButton")
dropdown.Name = "Dropdown"
dropdown.Parent = prefabs
dropdown.BackgroundColor3 = Color3.new(1, 1, 1)
dropdown.BackgroundTransparency = 1
dropdown.BorderSizePixel = 0
dropdown.Position = UDim2.new(-0.055555556, 0, 0.0833333284, 0)
dropdown.Size = UDim2.new(0, 200, 0, 20)
dropdown.ZIndex = 2
dropdown.Font = Enum.Font.GothamBold
dropdown.Text = "      Dropdown"
dropdown.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
dropdown.TextSize = 14
dropdown.TextXAlignment = Enum.TextXAlignment.Left

local dropdownIndicator = Instance.new("ImageLabel")
dropdownIndicator.Name = "Indicator"
dropdownIndicator.Parent = dropdown
dropdownIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
dropdownIndicator.BackgroundTransparency = 1
dropdownIndicator.Position = UDim2.new(0.899999976, -10, 0.100000001, 0)
dropdownIndicator.Rotation = -90
dropdownIndicator.Size = UDim2.new(0, 15, 0, 15)
dropdownIndicator.ZIndex = 2
dropdownIndicator.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId=4744658743"

local dropdownBox = Instance.new("ImageButton")
dropdownBox.Name = "Box"
dropdownBox.Parent = dropdown
dropdownBox.BackgroundColor3 = Color3.new(1, 1, 1)
dropdownBox.BackgroundTransparency = 1
dropdownBox.Position = UDim2.new(0, 0, 0, 25)
dropdownBox.Size = UDim2.new(1, 0, 0, 150)
dropdownBox.ZIndex = 3
dropdownBox.Image = "rbxassetid://2851929490"
dropdownBox.ImageColor3 = Color3.new(0.129412, 0.133333, 0.141176)
dropdownBox.ScaleType = Enum.ScaleType.Slice
dropdownBox.SliceCenter = Rect.new(4, 4, 4, 4)

local dropdownObjects = Instance.new("ScrollingFrame")
dropdownObjects.Name = "Objects"
dropdownObjects.Parent = dropdownBox
dropdownObjects.BackgroundColor3 = Color3.new(1, 1, 1)
dropdownObjects.BackgroundTransparency = 1
dropdownObjects.BorderSizePixel = 0
dropdownObjects.Size = UDim2.new(1, 0, 1, 0)
dropdownObjects.ZIndex = 3
dropdownObjects.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownObjects.ScrollBarThickness = 8

local dropdownList = Instance.new("UIListLayout")
dropdownList.Parent = dropdownObjects
dropdownList.SortOrder = Enum.SortOrder.LayoutOrder

local dropdownBg = Instance.new("ImageLabel")
dropdownBg.Name = "TextButton_Roundify_4px"
dropdownBg.Parent = dropdown
dropdownBg.BackgroundColor3 = Color3.new(1, 1, 1)
dropdownBg.BackgroundTransparency = 1
dropdownBg.Size = UDim2.new(1, 0, 1, 0)
dropdownBg.Image = "rbxassetid://2851929490"
dropdownBg.ImageColor3 = Color3.new(0.203922, 0.207843, 0.219608)
dropdownBg.ScaleType = Enum.ScaleType.Slice
dropdownBg.SliceCenter = Rect.new(4, 4, 4, 4)

-- TabButton
local tabButton = Instance.new("TextButton")
tabButton.Name = "TabButton"
tabButton.Parent = prefabs
tabButton.BackgroundColor3 = Color3.new(0.160784, 0.290196, 0.478431)
tabButton.BackgroundTransparency = 1
tabButton.BorderSizePixel = 0
tabButton.Position = UDim2.new(0.185185179, 0, 0, 0)
tabButton.Size = UDim2.new(0, 71, 0, 20)
tabButton.ZIndex = 2
tabButton.Font = Enum.Font.GothamSemibold
tabButton.Text = "Test tab"
tabButton.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
tabButton.TextSize = 14

local tabButtonBg = Instance.new("ImageLabel")
tabButtonBg.Name = "TextButton_Roundify_4px"
tabButtonBg.Parent = tabButton
tabButtonBg.BackgroundColor3 = Color3.new(1, 1, 1)
tabButtonBg.BackgroundTransparency = 1
tabButtonBg.Size = UDim2.new(1, 0, 1, 0)
tabButtonBg.Image = "rbxassetid://2851929490"
tabButtonBg.ImageColor3 = Color3.new(0.203922, 0.207843, 0.219608)
tabButtonBg.ScaleType = Enum.ScaleType.Slice
tabButtonBg.SliceCenter = Rect.new(4, 4, 4, 4)

-- Folder
local folder = Instance.new("ImageLabel")
folder.Name = "Folder"
folder.Parent = prefabs
folder.BackgroundColor3 = Color3.new(1, 1, 1)
folder.BackgroundTransparency = 1
folder.Position = UDim2.new(0, 0, 0, 50)
folder.Size = UDim2.new(1, 0, 0, 20)
folder.Image = "rbxassetid://2851929490"
folder.ImageColor3 = Color3.new(0.0823529, 0.0862745, 0.0901961)
folder.ScaleType = Enum.ScaleType.Slice
folder.SliceCenter = Rect.new(4, 4, 4, 4)

local folderButton = Instance.new("TextButton")
folderButton.Name = "Button"
folderButton.Parent = folder
folderButton.BackgroundColor3 = Color3.new(0.160784, 0.290196, 0.478431)
folderButton.BackgroundTransparency = 1
folderButton.BorderSizePixel = 0
folderButton.Size = UDim2.new(1, 0, 0, 20)
folderButton.ZIndex = 2
folderButton.Font = Enum.Font.GothamSemibold
folderButton.Text = "      Folder"
folderButton.TextColor3 = Color3.new(1, 1, 1)
folderButton.TextSize = 14
folderButton.TextXAlignment = Enum.TextXAlignment.Left

local folderButtonBg = Instance.new("ImageLabel")
folderButtonBg.Name = "TextButton_Roundify_4px"
folderButtonBg.Parent = folderButton
folderButtonBg.BackgroundColor3 = Color3.new(1, 1, 1)
folderButtonBg.BackgroundTransparency = 1
folderButtonBg.Size = UDim2.new(1, 0, 1, 0)
folderButtonBg.Image = "rbxassetid://2851929490"
folderButtonBg.ImageColor3 = Color3.new(0.160784, 0.290196, 0.478431)
folderButtonBg.ScaleType = Enum.ScaleType.Slice
folderButtonBg.SliceCenter = Rect.new(4, 4, 4, 4)

local folderToggle = Instance.new("ImageLabel")
folderToggle.Name = "Toggle"
folderToggle.Parent = folderButton
folderToggle.BackgroundColor3 = Color3.new(1, 1, 1)
folderToggle.BackgroundTransparency = 1
folderToggle.Position = UDim2.new(0, 5, 0, 0)
folderToggle.Size = UDim2.new(0, 20, 0, 20)
folderToggle.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId=4731371541"

local folderObjects = Instance.new("Frame")
folderObjects.Name = "Objects"
folderObjects.Parent = folder
folderObjects.BackgroundColor3 = Color3.new(1, 1, 1)
folderObjects.BackgroundTransparency = 1
folderObjects.Position = UDim2.new(0, 10, 0, 25)
folderObjects.Size = UDim2.new(1, -10, 1, -25)
folderObjects.Visible = false

local folderList = Instance.new("UIListLayout")
folderList.Parent = folderObjects
folderList.SortOrder = Enum.SortOrder.LayoutOrder
folderList.Padding = UDim.new(0, 5)

-- HorizontalAlignment
local horizontal = Instance.new("Frame")
horizontal.Name = "HorizontalAlignment"
horizontal.Parent = prefabs
horizontal.BackgroundColor3 = Color3.new(1, 1, 1)
horizontal.BackgroundTransparency = 1
horizontal.Size = UDim2.new(1, 0, 0, 20)

local horizontalList = Instance.new("UIListLayout")
horizontalList.Parent = horizontal
horizontalList.FillDirection = Enum.FillDirection.Horizontal
horizontalList.SortOrder = Enum.SortOrder.LayoutOrder
horizontalList.Padding = UDim.new(0, 5)

-- Console
local console = Instance.new("ImageLabel")
console.Name = "Console"
console.Parent = prefabs
console.BackgroundColor3 = Color3.new(1, 1, 1)
console.BackgroundTransparency = 1
console.Size = UDim2.new(1, 0, 0, 200)
console.Image = "rbxassetid://2851928141"
console.ImageColor3 = Color3.new(0.129412, 0.133333, 0.141176)
console.ScaleType = Enum.ScaleType.Slice
console.SliceCenter = Rect.new(8, 8, 8, 8)

local consoleScroll = Instance.new("ScrollingFrame")
consoleScroll.Parent = console
consoleScroll.BackgroundColor3 = Color3.new(1, 1, 1)
consoleScroll.BackgroundTransparency = 1
consoleScroll.BorderSizePixel = 0
consoleScroll.Size = UDim2.new(1, 0, 1, 1)
consoleScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
consoleScroll.ScrollBarThickness = 4

local consoleSource = Instance.new("TextBox")
consoleSource.Name = "Source"
consoleSource.Parent = consoleScroll
consoleSource.BackgroundColor3 = Color3.new(1, 1, 1)
consoleSource.BackgroundTransparency = 1
consoleSource.Position = UDim2.new(0, 40, 0, 0)
consoleSource.Size = UDim2.new(1, -40, 0, 10000)
consoleSource.ZIndex = 3
consoleSource.ClearTextOnFocus = false
consoleSource.Font = Enum.Font.Code
consoleSource.MultiLine = true
consoleSource.PlaceholderColor3 = Color3.new(0.8, 0.8, 0.8)
consoleSource.Text = ""
consoleSource.TextColor3 = Color3.new(1, 1, 1)
consoleSource.TextSize = 15
consoleSource.TextStrokeColor3 = Color3.new(1, 1, 1)
consoleSource.TextWrapped = true
consoleSource.TextXAlignment = Enum.TextXAlignment.Left
consoleSource.TextYAlignment = Enum.TextYAlignment.Top

local comments = Instance.new("TextLabel")
comments.Name = "Comments"
comments.Parent = consoleSource
comments.BackgroundColor3 = Color3.new(1, 1, 1)
comments.BackgroundTransparency = 1
comments.Size = UDim2.new(1, 0, 1, 0)
comments.ZIndex = 5
comments.Font = Enum.Font.Code
comments.Text = ""
comments.TextColor3 = Color3.new(0.231373, 0.784314, 0.231373)
comments.TextSize = 15
comments.TextXAlignment = Enum.TextXAlignment.Left
comments.TextYAlignment = Enum.TextYAlignment.Top

local globals = Instance.new("TextLabel")
globals.Name = "Globals"
globals.Parent = consoleSource
globals.BackgroundColor3 = Color3.new(1, 1, 1)
globals.BackgroundTransparency = 1
globals.Size = UDim2.new(1, 0, 1, 0)
globals.ZIndex = 5
globals.Font = Enum.Font.Code
globals.Text = ""
globals.TextColor3 = Color3.new(0.517647, 0.839216, 0.968628)
globals.TextSize = 15
globals.TextXAlignment = Enum.TextXAlignment.Left
globals.TextYAlignment = Enum.TextYAlignment.Top

local keywords = Instance.new("TextLabel")
keywords.Name = "Keywords"
keywords.Parent = consoleSource
keywords.BackgroundColor3 = Color3.new(1, 1, 1)
keywords.BackgroundTransparency = 1
keywords.Size = UDim2.new(1, 0, 1, 0)
keywords.ZIndex = 5
keywords.Font = Enum.Font.Code
keywords.Text = ""
keywords.TextColor3 = Color3.new(0.972549, 0.427451, 0.486275)
keywords.TextSize = 15
keywords.TextXAlignment = Enum.TextXAlignment.Left
keywords.TextYAlignment = Enum.TextYAlignment.Top

local remoteHighlight = Instance.new("TextLabel")
remoteHighlight.Name = "RemoteHighlight"
remoteHighlight.Parent = consoleSource
remoteHighlight.BackgroundColor3 = Color3.new(1, 1, 1)
remoteHighlight.BackgroundTransparency = 1
remoteHighlight.Size = UDim2.new(1, 0, 1, 0)
remoteHighlight.ZIndex = 5
remoteHighlight.Font = Enum.Font.Code
remoteHighlight.Text = ""
remoteHighlight.TextColor3 = Color3.new(0, 0.568627, 1)
remoteHighlight.TextSize = 15
remoteHighlight.TextXAlignment = Enum.TextXAlignment.Left
remoteHighlight.TextYAlignment = Enum.TextYAlignment.Top

local strings = Instance.new("TextLabel")
strings.Name = "Strings"
strings.Parent = consoleSource
strings.BackgroundColor3 = Color3.new(1, 1, 1)
strings.BackgroundTransparency = 1
strings.Size = UDim2.new(1, 0, 1, 0)
strings.ZIndex = 5
strings.Font = Enum.Font.Code
strings.Text = ""
strings.TextColor3 = Color3.new(0.678431, 0.945098, 0.584314)
strings.TextSize = 15
strings.TextXAlignment = Enum.TextXAlignment.Left
strings.TextYAlignment = Enum.TextYAlignment.Top

local tokens = Instance.new("TextLabel")
tokens.Name = "Tokens"
tokens.Parent = consoleSource
tokens.BackgroundColor3 = Color3.new(1, 1, 1)
tokens.BackgroundTransparency = 1
tokens.Size = UDim2.new(1, 0, 1, 0)
tokens.ZIndex = 5
tokens.Font = Enum.Font.Code
tokens.Text = ""
tokens.TextColor3 = Color3.new(1, 1, 1)
tokens.TextSize = 15
tokens.TextXAlignment = Enum.TextXAlignment.Left
tokens.TextYAlignment = Enum.TextYAlignment.Top

local numbers = Instance.new("TextLabel")
numbers.Name = "Numbers"
numbers.Parent = consoleSource
numbers.BackgroundColor3 = Color3.new(1, 1, 1)
numbers.BackgroundTransparency = 1
numbers.Size = UDim2.new(1, 0, 1, 0)
numbers.ZIndex = 4
numbers.Font = Enum.Font.Code
numbers.Text = ""
numbers.TextColor3 = Color3.new(1, 0.776471, 0)
numbers.TextSize = 15
numbers.TextXAlignment = Enum.TextXAlignment.Left
numbers.TextYAlignment = Enum.TextYAlignment.Top

local info = Instance.new("TextLabel")
info.Name = "Info"
info.Parent = consoleSource
info.BackgroundColor3 = Color3.new(1, 1, 1)
info.BackgroundTransparency = 1
info.Size = UDim2.new(1, 0, 1, 0)
info.ZIndex = 5
info.Font = Enum.Font.Code
info.Text = ""
info.TextColor3 = Color3.new(0, 0.635294, 1)
info.TextSize = 15
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top

local lines = Instance.new("TextLabel")
lines.Name = "Lines"
lines.Parent = consoleScroll
lines.BackgroundColor3 = Color3.new(1, 1, 1)
lines.BackgroundTransparency = 1
lines.BorderSizePixel = 0
lines.Size = UDim2.new(0, 40, 0, 10000)
lines.ZIndex = 4
lines.Font = Enum.Font.Code
lines.Text = "1\n"
lines.TextColor3 = Color3.new(1, 1, 1)
lines.TextSize = 15
lines.TextWrapped = true
lines.TextYAlignment = Enum.TextYAlignment.Top

-- ColorPicker
local colorPicker = Instance.new("ImageLabel")
colorPicker.Name = "ColorPicker"
colorPicker.Parent = prefabs
colorPicker.BackgroundColor3 = Color3.new(1, 1, 1)
colorPicker.BackgroundTransparency = 1
colorPicker.Size = UDim2.new(0, 180, 0, 110)
colorPicker.Image = "rbxassetid://2851929490"
colorPicker.ImageColor3 = Color3.new(0.203922, 0.207843, 0.219608)
colorPicker.ScaleType = Enum.ScaleType.Slice
colorPicker.SliceCenter = Rect.new(4, 4, 4, 4)

local palette = Instance.new("ImageLabel")
palette.Name = "Palette"
palette.Parent = colorPicker
palette.BackgroundColor3 = Color3.new(1, 1, 1)
palette.BackgroundTransparency = 1
palette.Position = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
palette.Size = UDim2.new(0, 100, 0, 100)
palette.Image = "rbxassetid://698052001"
palette.ScaleType = Enum.ScaleType.Slice
palette.SliceCenter = Rect.new(4, 4, 4, 4)

local paletteIndicator = Instance.new("ImageLabel")
paletteIndicator.Name = "Indicator"
paletteIndicator.Parent = palette
paletteIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
paletteIndicator.BackgroundTransparency = 1
paletteIndicator.Size = UDim2.new(0, 5, 0, 5)
paletteIndicator.ZIndex = 2
paletteIndicator.Image = "rbxassetid://2851926732"
paletteIndicator.ImageColor3 = Color3.new(0, 0, 0)
paletteIndicator.ScaleType = Enum.ScaleType.Slice
paletteIndicator.SliceCenter = Rect.new(12, 12, 12, 12)

local sample = Instance.new("ImageLabel")
sample.Name = "Sample"
sample.Parent = colorPicker
sample.BackgroundColor3 = Color3.new(1, 1, 1)
sample.BackgroundTransparency = 1
sample.Position = UDim2.new(0.800000012, 0, 0.0500000007, 0)
sample.Size = UDim2.new(0, 25, 0, 25)
sample.Image = "rbxassetid://2851929490"
sample.ScaleType = Enum.ScaleType.Slice
sample.SliceCenter = Rect.new(4, 4, 4, 4)

local saturation = Instance.new("ImageLabel")
saturation.Name = "Saturation"
saturation.Parent = colorPicker
saturation.BackgroundColor3 = Color3.new(1, 1, 1)
saturation.Position = UDim2.new(0.649999976, 0, 0.0500000007, 0)
saturation.Size = UDim2.new(0, 15, 0, 100)
saturation.Image = "rbxassetid://3641079629"

local saturationIndicator = Instance.new("Frame")
saturationIndicator.Name = "Indicator"
saturationIndicator.Parent = saturation
saturationIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
saturationIndicator.BorderSizePixel = 0
saturationIndicator.Size = UDim2.new(0, 20, 0, 2)
saturationIndicator.ZIndex = 2

-- Switch
local switch = Instance.new("TextButton")
switch.Name = "Switch"
switch.Parent = prefabs
switch.BackgroundColor3 = Color3.new(1, 1, 1)
switch.BackgroundTransparency = 1
switch.BorderSizePixel = 0
switch.Position = UDim2.new(0.229411766, 0, 0.20714286, 0)
switch.Size = UDim2.new(0, 20, 0, 20)
switch.ZIndex = 2
switch.Font = Enum.Font.SourceSans
switch.Text = ""
switch.TextColor3 = Color3.new(1, 1, 1)
switch.TextSize = 18

local switchBg = Instance.new("ImageLabel")
switchBg.Name = "TextButton_Roundify_4px"
switchBg.Parent = switch
switchBg.BackgroundColor3 = Color3.new(1, 1, 1)
switchBg.BackgroundTransparency = 1
switchBg.Size = UDim2.new(1, 0, 1, 0)
switchBg.Image = "rbxassetid://2851929490"
switchBg.ImageColor3 = Color3.new(0.160784, 0.290196, 0.478431)
switchBg.ImageTransparency = 0.5
switchBg.ScaleType = Enum.ScaleType.Slice
switchBg.SliceCenter = Rect.new(4, 4, 4, 4)

local switchTitle = Instance.new("TextLabel")
switchTitle.Name = "Title"
switchTitle.Parent = switch
switchTitle.BackgroundColor3 = Color3.new(1, 1, 1)
switchTitle.BackgroundTransparency = 1
switchTitle.Position = UDim2.new(1.20000005, 0, 0, 0)
switchTitle.Size = UDim2.new(0, 20, 0, 20)
switchTitle.Font = Enum.Font.GothamSemibold
switchTitle.Text = "Switch"
switchTitle.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
switchTitle.TextSize = 14
switchTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Button
local button = Instance.new("TextButton")
button.Name = "Button"
button.Parent = prefabs
button.BackgroundColor3 = Color3.new(0.160784, 0.290196, 0.478431)
button.BackgroundTransparency = 1
button.BorderSizePixel = 0
button.Size = UDim2.new(0, 91, 0, 20)
button.ZIndex = 2
button.Font = Enum.Font.GothamSemibold
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 14

local buttonBg = Instance.new("ImageLabel")
buttonBg.Name = "TextButton_Roundify_4px"
buttonBg.Parent = button
buttonBg.BackgroundColor3 = Color3.new(1, 1, 1)
buttonBg.BackgroundTransparency = 1
buttonBg.Size = UDim2.new(1, 0, 1, 0)
buttonBg.Image = "rbxassetid://2851929490"
buttonBg.ImageColor3 = Color3.new(0.160784, 0.290196, 0.478431)
buttonBg.ScaleType = Enum.ScaleType.Slice
buttonBg.SliceCenter = Rect.new(4, 4, 4, 4)

-- DropdownButton
local dropdownButton = Instance.new("TextButton")
dropdownButton.Name = "DropdownButton"
dropdownButton.Parent = prefabs
dropdownButton.BackgroundColor3 = Color3.new(0.129412, 0.133333, 0.141176)
dropdownButton.BorderSizePixel = 0
dropdownButton.Size = UDim2.new(1, 0, 0, 20)
dropdownButton.ZIndex = 3
dropdownButton.Font = Enum.Font.GothamBold
dropdownButton.Text = "      Button"
dropdownButton.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
dropdownButton.TextSize = 14
dropdownButton.TextXAlignment = Enum.TextXAlignment.Left

-- Keybind
local keybind = Instance.new("ImageLabel")
keybind.Name = "Keybind"
keybind.Parent = prefabs
keybind.BackgroundColor3 = Color3.new(1, 1, 1)
keybind.BackgroundTransparency = 1
keybind.Size = UDim2.new(0, 200, 0, 20)
keybind.Image = "rbxassetid://2851929490"
keybind.ImageColor3 = Color3.new(0.203922, 0.207843, 0.219608)
keybind.ScaleType = Enum.ScaleType.Slice
keybind.SliceCenter = Rect.new(4, 4, 4, 4)

local keybindTitle = Instance.new("TextLabel")
keybindTitle.Name = "Title"
keybindTitle.Parent = keybind
keybindTitle.BackgroundColor3 = Color3.new(1, 1, 1)
keybindTitle.BackgroundTransparency = 1
keybindTitle.Size = UDim2.new(0, 0, 1, 0)
keybindTitle.Font = Enum.Font.GothamBold
keybindTitle.Text = "Keybind"
keybindTitle.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
keybindTitle.TextSize = 14
keybindTitle.TextXAlignment = Enum.TextXAlignment.Left

local keybindInput = Instance.new("TextButton")
keybindInput.Name = "Input"
keybindInput.Parent = keybind
keybindInput.BackgroundColor3 = Color3.new(1, 1, 1)
keybindInput.BackgroundTransparency = 1
keybindInput.BorderSizePixel = 0
keybindInput.Position = UDim2.new(1, -85, 0, 2)
keybindInput.Size = UDim2.new(0, 80, 1, -4)
keybindInput.ZIndex = 2
keybindInput.Font = Enum.Font.GothamSemibold
keybindInput.Text = "RShift"
keybindInput.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
keybindInput.TextSize = 12
keybindInput.TextWrapped = true

local keybindBg = Instance.new("ImageLabel")
keybindBg.Name = "Input_Roundify_4px"
keybindBg.Parent = keybindInput
keybindBg.BackgroundColor3 = Color3.new(1, 1, 1)
keybindBg.BackgroundTransparency = 1
keybindBg.Size = UDim2.new(1, 0, 1, 0)
keybindBg.Image = "rbxassetid://2851929490"
keybindBg.ImageColor3 = Color3.new(0.290196, 0.294118, 0.313726)
keybindBg.ScaleType = Enum.ScaleType.Slice
keybindBg.SliceCenter = Rect.new(4, 4, 4, 4)

-- Windows
local windows = Instance.new("Frame")
windows.Name = "Windows"
windows.Parent = gui
windows.BackgroundColor3 = Color3.new(1, 1, 1)
windows.BackgroundTransparency = 1
windows.Position = UDim2.new(0, 20, 0, 20)
windows.Size = UDim2.new(1, 20, 1, -20)

script.Parent = gui

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local prefabs = script.Parent:WaitForChild("Prefabs")
local windows = script.Parent:FindFirstChild("Windows")
local checks = {["binding"] = false}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == (typeof(ui_options.toggle_key) == "EnumItem" and ui_options.toggle_key or Enum.KeyCode.RightShift) then
        if script.Parent then
            if not checks.binding then
                script.Parent.Enabled = not script.Parent.Enabled
            end
        end
    end
end)

local function Resize(part, new, delay)
    delay = delay or 0.5
    local tweenInfo = TweenInfo.new(delay, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(part, tweenInfo, new)
    tween:Play()
end

local function ApplyGradient(element, colors, rotation)
    local oldGradient = element:FindFirstChild("UIGradient")
    if oldGradient then oldGradient:Destroy() end
    if typeof(colors) == "Color3" then colors = {colors} end
    if not colors or #colors == 0 then return end
    if #colors == 1 then
        if element:IsA("ImageLabel") or element:IsA("ImageButton") then
            element.ImageColor3 = colors[1]
        else
            element.BackgroundColor3 = colors[1]
        end
        return
    end
    local gradient = Instance.new("UIGradient")
    gradient.Parent = element
    gradient.Rotation = rotation or 0
    local keypoints = {}
    if #colors == 2 then
        table.insert(keypoints, ColorSequenceKeypoint.new(0, colors[1]))
        table.insert(keypoints, ColorSequenceKeypoint.new(1, colors[2]))
    elseif #colors >= 3 then
        table.insert(keypoints, ColorSequenceKeypoint.new(0, colors[1]))
        table.insert(keypoints, ColorSequenceKeypoint.new(0.5, colors[2]))
        table.insert(keypoints, ColorSequenceKeypoint.new(1, colors[3]))
    end
    gradient.Color = ColorSequence.new(keypoints)
    if element:IsA("ImageLabel") or element:IsA("ImageButton") then
        element.ImageColor3 = Color3.new(1, 1, 1)
    else
        element.BackgroundColor3 = Color3.new(1, 1, 1)
    end
    return gradient
end

-- ============================================
-- ANIMATE GRADIENT - SLIDING WAVE (off-screen to on-screen loop)
-- ============================================
local function AnimateGradient(element, speed)
    speed = speed or 0.8
    local gradient = element:FindFirstChild("UIGradient")
    if not gradient then return end
    local offset = -1.0  -- Start OFF-SCREEN (left side)
    spawn(function()
        while gradient and gradient.Parent do
            offset = offset + speed * 0.025
            if offset > 1.5 then offset = -1.0 end  -- Reset to off-screen left
            gradient.Offset = Vector2.new(offset, 0)
            task.wait()
        end
    end)
end

-- ============================================
-- RGB TO HSV
-- ============================================
local function RGBtoHSV(r, g, b)
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
            if g < b then h = h + 6 end
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h, s, v
end

local function HasProp(object, prop)
    local success, result = pcall(function() return object[tostring(prop)] end)
    if success then return result end
end

local function GetNameLen(obj)
    return obj.TextBounds.X + 15
end

local function GetMouse()
    return Vector2.new(UserInputService:GetMouseLocation().X + 1, UserInputService:GetMouseLocation().Y - 35)
end

local function Ripple(button, x, y)
    spawn(function()
        button.ClipsDescendants = true
        local circle = prefabs:FindFirstChild("Circle"):Clone()
        circle.Parent = button
        circle.ZIndex = 1000
        local newX = x - circle.AbsolutePosition.X
        local newY = y - circle.AbsolutePosition.Y
        circle.Position = UDim2.new(0, newX, 0, newY)
        local size = 0
        if button.AbsoluteSize.X > button.AbsoluteSize.Y then
            size = button.AbsoluteSize.X * 1.5
        elseif button.AbsoluteSize.X < button.AbsoluteSize.Y then
            size = button.AbsoluteSize.Y * 1.5
        elseif button.AbsoluteSize.X == button.AbsoluteSize.Y then
            size = button.AbsoluteSize.X * 1.5
        end
        circle:TweenSizeAndPosition(
            UDim2.new(0, size, 0, size),
            UDim2.new(0.5, -size / 2, 0.5, -size / 2),
            "Out", "Quad", 0.5, false, nil
        )
        Resize(circle, {ImageTransparency = 1}, 0.5)
        wait(0.5)
        circle:Destroy()
    end)
end

local windowCount = 0
local library = {}

local function FormatWindows()
    local layout = prefabs:FindFirstChild("UIListLayout"):Clone()
    layout.Parent = windows
    local data = {}
    for _, child in next, windows:GetChildren() do
        if not child:IsA("UIListLayout") then
            data[child] = child.AbsolutePosition
        end
    end
    layout:Destroy()
    for child, pos in next, data do
        child.Position = UDim2.new(0, pos.X, 0, pos.Y)
    end
end

function library:FormatWindows()
    FormatWindows()
end

function library:AddWindow(titleText, options)
    windowCount = windowCount + 1
    local dropdownOpen = false
    titleText = tostring(titleText or "New Window")
    options = typeof(options) == "table" and options or ui_options
    options.tween_time = 0.1
    options.title_bar = options.title_bar or {Color3.fromRGB(41, 74, 122)}
    if typeof(options.title_bar) == "Color3" then options.title_bar = {options.title_bar} end
    options.title_bar_transparency = options.title_bar_transparency or 0
    options.background = options.background or {Color3.new(0.08, 0.09, 0.1)}
    if typeof(options.background) == "Color3" then options.background = {options.background} end
    options.background_transparency = options.background_transparency or 0.1
    if not options.main_color then options.main_color = options.title_bar[1] end

    local window = prefabs:FindFirstChild("Window"):Clone()
    window.Parent = windows
    window:FindFirstChild("Title").Text = titleText
    window.Size = UDim2.new(0, options.min_size.X, 0, options.min_size.Y)
    window.ZIndex = window.ZIndex + windowCount * 10

    do
        options.title_bar = options.title_bar or {options.main_color or Color3.fromRGB(41, 74, 122)}
        options.title_bar_transparency = options.title_bar_transparency or 0
        options.background = options.background or {Color3.new(0.08, 0.09, 0.1)}
        options.background_transparency = options.background_transparency or 0.1

        local bar = window:FindFirstChild("Bar")
        local titleLabel = bar:FindFirstChild("Title")
        local toggleButton = bar:FindFirstChild("Toggle")
        local baseBar = bar:FindFirstChild("Base")
        local topBar = bar:FindFirstChild("Top")
        local tabSelection = window:FindFirstChild("TabSelection")
        local lineFrame = tabSelection:FindFirstChild("Frame")
        local barHeight = 24
        local barOffset = (barHeight - 18) / 2

        bar.Size = UDim2.new(1, 0, 0, barHeight)
        bar.Position = UDim2.new(0, 0, 0, 0)
        if baseBar then baseBar:Destroy() end
        if topBar then topBar:Destroy() end

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = bar

        if toggleButton then toggleButton.Position = UDim2.new(0, 5, 0, barOffset) end
        if titleLabel then
            local leftPad = 25
            local rightPad = 5
            titleLabel.Position = UDim2.new(0, leftPad, 0, barOffset)
            titleLabel.Size = UDim2.new(1, -(leftPad + rightPad), 1, -barOffset * 2)
            titleLabel.TextXAlignment = Enum.TextXAlignment.Center
        end

        bar.BackgroundTransparency = options.title_bar_transparency
        local barGrad = ApplyGradient(bar, options.title_bar, 0)
        if barGrad then AnimateGradient(bar, 3.0) end

        if tabSelection then
            tabSelection.Size = UDim2.new(1, -30, 0, 22)
            tabSelection.Position = UDim2.new(0, 15, 0, 28)
            local tabCorner = Instance.new("UICorner")
            tabCorner.CornerRadius = UDim.new(0, 6)
            tabCorner.Parent = tabSelection
            tabSelection.ImageTransparency = 0.4
            local tabGrad = ApplyGradient(tabSelection, options.title_bar, 45)
            if tabGrad then AnimateGradient(tabSelection, 3.0) end
            local tabButtonsFrame = tabSelection:FindFirstChild("TabButtons")
            if tabButtonsFrame then
                local tabListLayout = tabButtonsFrame:FindFirstChild("UIListLayout")
                if tabListLayout then
                    tabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                    tabListLayout.Padding = UDim.new(0, 12)
                end
            end
            if lineFrame then lineFrame:Destroy() end
        end

        window.ImageTransparency = options.background_transparency
        local bgGrad = ApplyGradient(window, options.background, 45)
        if bgGrad then AnimateGradient(window, 3.0) end

        local tabsContainer = window:FindFirstChild("Tabs")
        toggleButton.MouseButton1Click:Connect(function()
            local isVisible = tabsContainer.Visible
            if isVisible then
                tabsContainer.Visible = false
                Resize(window, {Size = UDim2.new(0, window.AbsoluteSize.X, 0, barHeight)}, options.tween_time)
            else
                Resize(window, {Size = UDim2.new(0, window.AbsoluteSize.X, 0, options.min_size.Y)}, options.tween_time)
                wait(options.tween_time * 0.9)
                tabsContainer.Visible = true
            end
        end)
    end

    local resizer = window:WaitForChild("Resizer")
    local windowData = {}
    window.Draggable = true

    do
        local oldIcon = mouse.Icon
        local entered = false
        resizer.MouseEnter:Connect(function()
            window.Draggable = false
            if options.can_resize then oldIcon = mouse.Icon end
            entered = true
        end)
        resizer.MouseLeave:Connect(function()
            entered = false
            if options.can_resize then mouse.Icon = oldIcon end
            window.Draggable = true
        end)
        local held = false
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                held = true
                spawn(function()
                    if entered and resizer.Active and options.can_resize then
                        while held and resizer.Active do
                            local mousePos = GetMouse()
                            local x = mousePos.X - window.AbsolutePosition.X
                            local y = mousePos.Y - window.AbsolutePosition.Y
                            if x >= options.min_size.X and y >= options.min_size.Y then
                                Resize(window, {Size = UDim2.new(0, x, 0, y)}, options.tween_time)
                            elseif x >= options.min_size.X then
                                Resize(window, {Size = UDim2.new(0, x, 0, options.min_size.Y)}, options.tween_time)
                            elseif y >= options.min_size.Y then
                                Resize(window, {Size = UDim2.new(0, options.min_size.X, 0, y)}, options.tween_time)
                            else
                                Resize(window, {Size = UDim2.new(0, options.min_size.X, 0, options.min_size.Y)}, options.tween_time)
                            end
                            RunService.Heartbeat:Wait()
                        end
                    end
                end)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                held = false
            end
        end)
    end

    do
        local toggleButton = window:FindFirstChild("Bar"):FindFirstChild("Toggle")
        local isOpen = true
        local canToggle = true
        local oldTabData = {}
        local oldHeight = window.AbsoluteSize.Y
        toggleButton.MouseButton1Click:Connect(function()
            if canToggle then
                canToggle = false
                if isOpen then
                    oldTabData = {}
                    for _, child in next, window:FindFirstChild("Tabs"):GetChildren() do
                        oldTabData[child] = child.Visible
                        child.Visible = false
                    end
                    resizer.Active = false
                    oldHeight = window.AbsoluteSize.Y
                    Resize(toggleButton, {Rotation = 0}, options.tween_time)
                    Resize(window, {Size = UDim2.new(0, window.AbsoluteSize.X, 0, 26)}, options.tween_time)
                    toggleButton.Parent:FindFirstChild("Base").Transparency = 1
                else
                    for child, visible in next, oldTabData do
                        child.Visible = visible
                    end
                    resizer.Active = true
                    Resize(toggleButton, {Rotation = 90}, options.tween_time)
                    Resize(window, {Size = UDim2.new(0, window.AbsoluteSize.X, 0, oldHeight)}, options.tween_time)
                    toggleButton.Parent:FindFirstChild("Base").Transparency = options.title_bar_transparency
                end
                isOpen = not isOpen
                wait(options.tween_time)
                canToggle = true
            end
        end)
    end

    do
        local tabsContainer = window:FindFirstChild("Tabs")
        local tabSelection = window:FindFirstChild("TabSelection")
        local tabButtonsFrame = tabSelection:FindFirstChild("TabButtons")
        local activeTab = nil
        local particleConnection = nil

        do
            function windowData:AddTab(tabName)
                local tabData = {}
                tabName = tostring(tabName or "New Tab")
                tabSelection.Visible = true

                local newButton = prefabs:FindFirstChild("TabButton"):Clone()
                newButton.Parent = tabButtonsFrame
                newButton.Text = tabName
                newButton.Size = UDim2.new(0, GetNameLen(newButton) + 20, 0, 18)
                newButton.ZIndex = newButton.ZIndex + windowCount * 10
                newButton.BackgroundTransparency = 1

                local buttonBg = newButton:GetChildren()[1]
                buttonBg.ZIndex = newButton.ZIndex + windowCount * 10
                buttonBg.ImageTransparency = 1

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 4)
                corner.Parent = newButton

                newButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                newButton.TextSize = 13
                newButton.Font = Enum.Font.GothamSemibold

                local stroke = Instance.new("UIStroke")
                stroke.Color = Color3.new(0, 0, 0)
                stroke.Thickness = 1.2
                stroke.Transparency = 0.7
                stroke.Parent = newButton

                local outline = Instance.new("Frame")
                outline.Name = "TabOutline"
                outline.Size = UDim2.new(1, 0, 1, 0)
                outline.BackgroundTransparency = 1
                outline.BorderSizePixel = 2
                outline.BorderColor3 = options.main_color
                outline.ZIndex = newButton.ZIndex + 10
                outline.Visible = false

                local outlineCorner = Instance.new("UICorner")
                outlineCorner.CornerRadius = UDim.new(0, 4)
                outlineCorner.Parent = outline
                outline.Parent = newButton

                local newTab = prefabs:FindFirstChild("Tab"):Clone()
                newTab.Parent = tabsContainer
                newTab.ZIndex = newTab.ZIndex + windowCount * 10
                newTab.Visible = false

                local function SpawnParticles(button)
                    if button ~= activeTab then return end
                    local size = button.AbsoluteSize
                    for i = 1, 3 do
                        spawn(function()
                            local particle = Instance.new("Frame")
                            particle.Name = "SimpleParticle"
                            particle.Size = UDim2.new(0, 1.5, 0, 1.5)
                            particle.AnchorPoint = Vector2.new(0.5, 0.5)
                            particle.BackgroundColor3 = options.main_color
                            particle.BorderSizePixel = 0
                            particle.ZIndex = button.ZIndex + 15

                            local particleCorner = Instance.new("UICorner")
                            particleCorner.CornerRadius = UDim.new(1, 0)
                            particleCorner.Parent = particle

                            local side = math.random(1, 4)
                            local startX, startY = 0, 0
                            if side == 1 then
                                startX = math.random(5, size.X - 5)
                                startY = 1
                            elseif side == 2 then
                                startX = size.X - 1
                                startY = math.random(5, size.Y - 5)
                            elseif side == 3 then
                                startX = math.random(5, size.X - 5)
                                startY = size.Y - 1
                            else
                                startX = 1
                                startY = math.random(5, size.Y - 5)
                            end

                            particle.Position = UDim2.new(0, startX, 0, startY)
                            particle.Parent = button

                            local centerX, centerY = size.X / 2, size.Y / 2
                            local dirX, dirY = startX - centerX, startY - centerY
                            local dist = math.sqrt(dirX * dirX + dirY * dirY)
                            dirX, dirY = dirX / dist, dirY / dist

                            local endX = startX + dirX * 6
                            local endY = startY + dirY * 6

                            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                            local tween = TweenService:Create(particle, tweenInfo, {
                                Position = UDim2.new(0, endX, 0, endY),
                                BackgroundTransparency = 1
                            })
                            tween:Play()
                            wait(0.5)
                            if particle and particle.Parent then particle:Destroy() end
                        end)
                    end
                end

                local function StartParticles()
                    if particleConnection then particleConnection:Disconnect() end
                    particleConnection = game:GetService("RunService").Heartbeat:Connect(function()
                        if activeTab and activeTab.Parent then
                            SpawnParticles(activeTab)
                            wait(0.2)
                        end
                    end)
                end

                local function SelectTab()
                    if dropdownOpen then return end
                    if activeTab and activeTab ~= newButton then
                        local oldOutline = activeTab:FindFirstChild("TabOutline")
                        if oldOutline then oldOutline.Visible = false end
                        activeTab.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end
                    for _, child in next, tabsContainer:GetChildren() do
                        if child:IsA("Frame") then child.Visible = false end
                    end
                    activeTab = newButton
                    local newOutline = newButton:FindFirstChild("TabOutline")
                    if newOutline then
                        newOutline.Visible = true
                        newOutline.BorderColor3 = options.main_color
                    end
                    newButton.TextColor3 = Color3.new(1, 1, 1)
                    StartParticles()
                    newTab.Visible = true
                end

                newButton.MouseButton1Click:Connect(function() SelectTab() end)
                newButton.MouseEnter:Connect(function()
                    if newButton ~= activeTab then newButton.TextColor3 = Color3.fromRGB(230, 230, 230) end
                end)
                newButton.MouseLeave:Connect(function()
                    if newButton ~= activeTab then newButton.TextColor3 = Color3.fromRGB(200, 200, 200) end
                end)

                function tabData:Show() SelectTab() end

                newButton.AncestryChanged:Connect(function()
                    if not newButton.Parent then
                        if activeTab == newButton then
                            activeTab = nil
                            if particleConnection then particleConnection:Disconnect(); particleConnection = nil end
                        end
                    end
                end)

                if #tabButtonsFrame:GetChildren() == 2 then SelectTab() end

                do
                    function tabData:AddLabel(labelText)
                        labelText = tostring(labelText or "New Label")
                        local label = prefabs:FindFirstChild("Label"):Clone()
                        label.Parent = newTab
                        label.Text = labelText
                        label.Size = UDim2.new(0, GetNameLen(label), 0, 20)
                        label.ZIndex = label.ZIndex + windowCount * 10
                        return label
                    end

                    function tabData:AddButton(buttonText, callback)
                        buttonText = tostring(buttonText or "New Button")
                        callback = typeof(callback) == "function" and callback or function() end
                        local button = prefabs:FindFirstChild("Button"):Clone()
                        button.Parent = newTab
                        button.Text = buttonText
                        button.Size = UDim2.new(0, GetNameLen(button), 0, 20)
                        button.ZIndex = button.ZIndex + windowCount * 10
                        local buttonBg = button:GetChildren()[1]
                        buttonBg.ZIndex = buttonBg.ZIndex + windowCount * 10
                        buttonBg.ImageTransparency = options.title_bar_transparency or 0
                        ApplyGradient(buttonBg, options.title_bar, 0)
                        button.TextColor3 = Color3.new(1, 1, 1)
                        button.MouseButton1Click:Connect(function()
                            Ripple(button, mouse.X, mouse.Y)
                            pcall(callback)
                        end)
                        return button
                    end

                    function tabData:AddSwitch(switchText, callback)
                        local switchData = {}
                        switchText = tostring(switchText or "New Switch")
                        callback = typeof(callback) == "function" and callback or function() end
                        local switch = prefabs:FindFirstChild("Switch"):Clone()
                        switch.Parent = newTab
                        switch:FindFirstChild("Title").Text = switchText
                        switch:FindFirstChild("Title").ZIndex = switch:FindFirstChild("Title").ZIndex + windowCount * 10
                        switch.ZIndex = switch.ZIndex + windowCount * 10
                        local switchBg = switch:GetChildren()[1]
                        switchBg.ZIndex = switchBg.ZIndex + windowCount * 10
                        switchBg.ImageTransparency = options.title_bar_transparency or 0
                        ApplyGradient(switchBg, options.title_bar, 0)
                        local toggled = false
                        switch.MouseButton1Click:Connect(function()
                            toggled = not toggled
                            switch.Text = toggled and utf8.char(10003) or ""
                            pcall(callback, toggled)
                        end)
                        function switchData:Set(value)
                            toggled = typeof(value) == "boolean" and value or false
                            switch.Text = toggled and utf8.char(10003) or ""
                            pcall(callback, toggled)
                        end
                        return switchData, switch
                    end

                    function tabData:AddTextBox(placeholder, callback, options)
                        placeholder = tostring(placeholder or "New TextBox")
                        callback = typeof(callback) == "function" and callback or function() end
                        options = typeof(options) == "table" and options or {["clear"] = false}
                        options = {["clear"] = options.clear == true}
                        local textbox = prefabs:FindFirstChild("TextBox"):Clone()
                        textbox.Size = UDim2.new(0.5, -5, 0, 20)
                        textbox.Parent = newTab
                        textbox.PlaceholderText = placeholder
                        textbox.ZIndex = textbox.ZIndex + windowCount * 10
                        local textboxBg = textbox:GetChildren()[1]
                        textboxBg.ZIndex = textboxBg.ZIndex + windowCount * 10
                        textboxBg.ImageTransparency = options.title_bar_transparency or 0
                        ApplyGradient(textboxBg, options.title_bar, 0)
                        textbox.TextColor3 = Color3.new(1, 1, 1)
                        textbox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
                        textbox.FocusLost:Connect(function(enterPressed)
                            if enterPressed then
                                if #textbox.Text > 0 then
                                    pcall(callback, textbox.Text)
                                    if options.clear then textbox.Text = "" end
                                end
                            end
                        end)
                        return textbox
                    end

                    function tabData:AddSlider(sliderText, callback, sliderOptions)
                        local sliderData = {}
                        sliderText = tostring(sliderText or "New Slider")
                        callback = typeof(callback) == "function" and callback or function() end
                        sliderOptions = typeof(sliderOptions) == "table" and sliderOptions or {}
                        sliderOptions = {
                            ["min"] = sliderOptions.min or 0,
                            ["max"] = sliderOptions.max or 100,
                            ["readonly"] = sliderOptions.readonly or false
                        }
                        local slider = prefabs:FindFirstChild("Slider"):Clone()
                        slider.Parent = newTab
                        slider.ZIndex = slider.ZIndex + windowCount * 10
                        local titleLabel = slider:FindFirstChild("Title")
                        local indicator = slider:FindFirstChild("Indicator")
                        local valueLabel = slider:FindFirstChild("Value")
                        titleLabel.ZIndex = titleLabel.ZIndex + windowCount * 10
                        indicator.ZIndex = indicator.ZIndex + windowCount * 10
                        valueLabel.ZIndex = valueLabel.ZIndex + windowCount * 10
                        titleLabel.Text = sliderText

                        do
                            local entered = false
                            slider.MouseEnter:Connect(function()
                                entered = true
                                window.Draggable = false
                            end)
                            slider.MouseLeave:Connect(function()
                                entered = false
                                window.Draggable = true
                            end)
                            local held = false
                            UserInputService.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    held = true
                                    spawn(function()
                                        if entered and not sliderOptions.readonly then
                                            while held and not dropdownOpen do
                                                local mousePos = GetMouse()
                                                local x = (slider.AbsoluteSize.X - (slider.AbsoluteSize.X - (mousePos.X - slider.AbsolutePosition.X) + 1)) / slider.AbsoluteSize.X
                                                local minVal = 0
                                                local maxVal = 1
                                                local size = minVal
                                                if x >= minVal and x <= maxVal then
                                                    size = x
                                                elseif x < minVal then
                                                    size = minVal
                                                elseif x > maxVal then
                                                    size = maxVal
                                                end
                                                Resize(indicator, {Size = UDim2.new(size or minVal, 0, 0, 20)}, options.tween_time)
                                                local percent = math.floor((size or minVal) * 100)
                                                local maxV = sliderOptions.max
                                                local minV = sliderOptions.min
                                                local diff = maxV - minV
                                                local selectedValue = math.floor(diff / 100 * percent + minV)
                                                valueLabel.Text = tostring(selectedValue)
                                                pcall(callback, selectedValue)
                                                RunService.Heartbeat:Wait()
                                            end
                                        end
                                    end)
                                end
                            end)
                            UserInputService.InputEnded:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    held = false
                                end
                            end)

                            function sliderData:Set(value)
                                value = tonumber(value) or 0
                                value = (value >= 0 and value <= 100 and value) / 100
                                Resize(indicator, {Size = UDim2.new(value or 0, 0, 0, 20)}, options.tween_time)
                                local percent = math.floor((value or 0) * 100)
                                local maxV = sliderOptions.max
                                local minV = sliderOptions.min
                                local diff = maxV - minV
                                local selectedValue = math.floor(diff / 100 * percent + minV)
                                valueLabel.Text = tostring(selectedValue)
                                pcall(callback, selectedValue)
                            end

                            sliderData:Set(sliderOptions["min"])
                        end

                        return sliderData, slider
                    end

                    function tabData:AddKeybind(keybindName, callback, keybindOptions)
                        local keybindData = {}
                        keybindName = tostring(keybindName or "New Keybind")
                        callback = typeof(callback) == "function" and callback or function() end
                        keybindOptions = typeof(keybindOptions) == "table" and keybindOptions or {}
                        keybindOptions = {["standard"] = keybindOptions.standard or Enum.KeyCode.RightShift}
                        local keybind = prefabs:FindFirstChild("Keybind"):Clone()
                        local input = keybind:FindFirstChild("Input")
                        local titleLabel = keybind:FindFirstChild("Title")
                        keybind.ZIndex = keybind.ZIndex + windowCount * 10
                        input.ZIndex = input.ZIndex + windowCount * 10
                        input:GetChildren()[1].ZIndex = input:GetChildren()[1].ZIndex + windowCount * 10
                        titleLabel.ZIndex = titleLabel.ZIndex + windowCount * 10
                        keybind.Parent = newTab
                        titleLabel.Text = "  " .. keybindName
                        keybind.Size = UDim2.new(0, GetNameLen(titleLabel) + 80, 0, 20)

                        local shortkeys = {
                            RightControl = 'RightCtrl',
                            LeftControl = 'LeftCtrl',
                            LeftShift = 'LShift',
                            RightShift = 'RShift',
                            MouseButton1 = "Mouse1",
                            MouseButton2 = "Mouse2"
                        }

                        local keybind = keybindOptions.standard

                        function keybindData:SetKeybind(key)
                            local display = shortkeys[key.Name] or key.Name
                            input.Text = display
                            keybind = key
                        end

                        UserInputService.InputBegan:Connect(function(input, gameProcessed)
                            if checks.binding then
                                spawn(function() wait(); checks.binding = false end)
                                return
                            end
                            if input.KeyCode == keybind and not gameProcessed then
                                pcall(callback, keybind)
                            end
                        end)

                        keybindData:SetKeybind(keybindOptions.standard)

                        input.MouseButton1Click:Connect(function()
                            if checks.binding then return end
                            input.Text = "..."
                            checks.binding = true
                            local input, gameProcessed = UserInputService.InputBegan:Wait()
                            keybindData:SetKeybind(input.KeyCode)
                        end)

                        return keybindData, keybind
                    end

                    function tabData:AddDropdown(dropdownName, callback)
                        local dropdownData = {}
                        dropdownName = tostring(dropdownName or "New Dropdown")
                        callback = typeof(callback) == "function" and callback or function() end
                        local dropdown = prefabs:FindFirstChild("Dropdown"):Clone()
                        local box = dropdown:FindFirstChild("Box")
                        local objects = box:FindFirstChild("Objects")
                        local indicator = dropdown:FindFirstChild("Indicator")
                        dropdown.ZIndex = dropdown.ZIndex + windowCount * 10
                        box.ZIndex = box.ZIndex + windowCount * 10
                        objects.ZIndex = objects.ZIndex + windowCount * 10
                        indicator.ZIndex = indicator.ZIndex + windowCount * 10
                        dropdown.Size = UDim2.new(0.5, -5, 0, 20)
                        local dropdownBg = dropdown:GetChildren()[3]
                        dropdownBg.ZIndex = dropdownBg.ZIndex + windowCount * 10
                        dropdownBg.ImageTransparency = options.title_bar_transparency or 0
                        ApplyGradient(dropdownBg, options.title_bar, 0)
                        box.ImageTransparency = options.background_transparency or 0.1
                        ApplyGradient(box, options.background, 0)

                        local boxCorner = Instance.new("UICorner")
                        boxCorner.CornerRadius = UDim.new(0, 6)
                        boxCorner.Parent = box

                        objects.BackgroundTransparency = 1
                        objects.Position = UDim2.new(0, 0, 0, 0)
                        objects.Size = UDim2.new(1, 0, 1, 0)
                        dropdown.Parent = newTab
                        dropdown.Text = "      " .. dropdownName
                        box.Size = UDim2.new(1, 0, 0, 0)
                        dropdown.TextColor3 = Color3.new(1, 1, 1)

                        local isOpen = false
                        dropdown.MouseButton1Click:Connect(function()
                            isOpen = not isOpen
                            local height = (#objects:GetChildren() - 1) * 20
                            if #objects:GetChildren() - 1 >= 10 then
                                height = 10 * 20
                                objects.CanvasSize = UDim2.new(0, 0, (#objects:GetChildren() - 1) * 0.1, 0)
                            end
                            if isOpen then
                                if dropdownOpen then return end
                                dropdownOpen = true
                                Resize(box, {Size = UDim2.new(1, 0, 0, height)}, options.tween_time)
                                Resize(indicator, {Rotation = 90}, options.tween_time)
                            else
                                dropdownOpen = false
                                Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
                                Resize(indicator, {Rotation = -90}, options.tween_time)
                            end
                        end)

                        function dropdownData:Add(optionName)
                            local optionData = {}
                            optionName = tostring(optionName or "New Object")
                            local option = prefabs:FindFirstChild("DropdownButton"):Clone()
                            option.Parent = objects
                            option.Text = optionName
                            option.ZIndex = option.ZIndex + windowCount * 10 + 5
                            option.BackgroundTransparency = 1
                            option.TextColor3 = Color3.new(1, 1, 1)
                            option.BorderSizePixel = 0
                            option.TextXAlignment = Enum.TextXAlignment.Left

                            local corner = option:FindFirstChildOfClass("UICorner")
                            if corner then corner:Destroy() end

                            local stroke = Instance.new("UIStroke")
                            stroke.Color = Color3.new(0, 0, 0)
                            stroke.Thickness = 1
                            stroke.Transparency = 0.3
                            stroke.Parent = option

                            option.MouseEnter:Connect(function()
                                option.BackgroundTransparency = 0.8
                                option.BackgroundColor3 = options.main_color
                            end)
                            option.MouseLeave:Connect(function()
                                option.BackgroundTransparency = 1
                            end)

                            if isOpen then
                                local height = (#objects:GetChildren() - 1) * 20
                                if #objects:GetChildren() - 1 >= 10 then
                                    height = 10 * 20
                                    objects.CanvasSize = UDim2.new(0, 0, (#objects:GetChildren() - 1) * 0.1, 0)
                                end
                                Resize(box, {Size = UDim2.new(1, 0, 0, height)}, options.tween_time)
                            end

                            option.MouseButton1Click:Connect(function()
                                if dropdownOpen then
                                    dropdown.Text = "      [ " .. optionName .. " ]"
                                    dropdownOpen = false
                                    isOpen = false
                                    Resize(box, {Size = UDim2.new(1, 0, 0, 0)}, options.tween_time)
                                    Resize(indicator, {Rotation = -90}, options.tween_time)
                                    pcall(callback, optionName)
                                end
                            end)

                            function optionData:Remove() option:Destroy() end
                            return option, optionData
                        end

                        return dropdownData, dropdown
                    end

                    function tabData:AddColorPicker(callback)
                        local colorPickerData = {}
                        callback = typeof(callback) == "function" and callback or function() end
                        local colorPicker = prefabs:FindFirstChild("ColorPicker"):Clone()
                        colorPicker.Parent = newTab
                        colorPicker.ZIndex = colorPicker.ZIndex + windowCount * 10
                        local palette = colorPicker:FindFirstChild("Palette")
                        local sample = colorPicker:FindFirstChild("Sample")
                        local saturation = colorPicker:FindFirstChild("Saturation")
                        palette.ZIndex = palette.ZIndex + windowCount * 10
                        sample.ZIndex = sample.ZIndex + windowCount * 10
                        saturation.ZIndex = saturation.ZIndex + windowCount * 10

                        do
                            local h = 0
                            local s = 1
                            local v = 1

                            local function Update()
                                local color = Color3.fromHSV(h, s, v)
                                sample.ImageColor3 = color
                                saturation.ImageColor3 = Color3.fromHSV(h, 1, 1)
                                pcall(callback, color)
                            end

                            do
                                local color = Color3.fromHSV(h, s, v)
                                sample.ImageColor3 = color
                                saturation.ImageColor3 = Color3.fromHSV(h, 1, 1)
                            end

                            local enteredPalette, enteredSaturation = false, false
                            palette.MouseEnter:Connect(function() window.Draggable = false; enteredPalette = true end)
                            palette.MouseLeave:Connect(function() window.Draggable = true; enteredPalette = false end)
                            saturation.MouseEnter:Connect(function() window.Draggable = false; enteredSaturation = true end)
                            saturation.MouseLeave:Connect(function() window.Draggable = true; enteredSaturation = false end)

                            local paletteIndicator = palette:FindFirstChild("Indicator")
                            local saturationIndicator = saturation:FindFirstChild("Indicator")
                            paletteIndicator.ZIndex = paletteIndicator.ZIndex + windowCount * 10
                            saturationIndicator.ZIndex = saturationIndicator.ZIndex + windowCount * 10

                            local held = false
                            UserInputService.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    held = true
                                    spawn(function()
                                        while held and enteredPalette and not dropdownOpen do
                                            local mousePos = GetMouse()
                                            local x = palette.AbsoluteSize.X - (mousePos.X - palette.AbsolutePosition.X) + 1
                                            local y = palette.AbsoluteSize.Y - (mousePos.Y - palette.AbsolutePosition.Y) + 1.5
                                            local color = Color3.fromHSV(x / 100, y / 100, 0)
                                            h = x / 100
                                            s = y / 100
                                            Resize(paletteIndicator, {Position = UDim2.new(0, math.abs(x - 100) - paletteIndicator.AbsoluteSize.X / 2, 0, math.abs(y - 100) - paletteIndicator.AbsoluteSize.Y / 2)}, options.tween_time)
                                            Update()
                                            RunService.Heartbeat:Wait()
                                        end
                                        while held and enteredSaturation and not dropdownOpen do
                                            local mousePos = GetMouse()
                                            local y = palette.AbsoluteSize.Y - (mousePos.Y - palette.AbsolutePosition.Y) + 1.5
                                            v = y / 100
                                            Resize(saturationIndicator, {Position = UDim2.new(0, 0, 0, math.abs(y - 100))}, options.tween_time)
                                            Update()
                                            RunService.Heartbeat:Wait()
                                        end
                                    end)
                                end
                            end)
                            UserInputService.InputEnded:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    held = false
                                end
                            end)

                            function colorPickerData:Set(color)
                                color = typeof(color) == "Color3" and color or Color3.new(1, 1, 1)
                                local h2, s2, v2 = RGBtoHSV(color.r * 255, color.g * 255, color.b * 255)
                                sample.ImageColor3 = color
                                saturation.ImageColor3 = Color3.fromHSV(h2, 1, 1)
                                pcall(callback, color)
                            end
                        end

                        return colorPickerData, colorPicker
                    end

                    function tabData:AddConsole(consoleOptions)
                        local consoleData = {}
                        consoleOptions = typeof(consoleOptions) == "table" and consoleOptions or {["readonly"] = true, ["full"] = false}
                        consoleOptions = {
                            ["y"] = tonumber(consoleOptions.y) or 200,
                            ["source"] = consoleOptions.source or "Logs",
                            ["readonly"] = consoleOptions.readonly == true,
                            ["full"] = consoleOptions.full == true
                        }
                        local console = prefabs:FindFirstChild("Console"):Clone()
                        console.Parent = newTab
                        console.ZIndex = console.ZIndex + windowCount * 10
                        console.Size = UDim2.new(1, 0, consoleOptions.full and 1 or 0, consoleOptions.y)
                        local scroll = console:GetChildren()[1]
                        local source = scroll:FindFirstChild("Source")
                        local lines = scroll:FindFirstChild("Lines")
                        source.ZIndex = source.ZIndex + windowCount * 10
                        lines.ZIndex = lines.ZIndex + windowCount * 10
                        source.TextEditable = not consoleOptions.readonly

                        do
                            for _, child in next, source:GetChildren() do
                                child.ZIndex = child.ZIndex + windowCount * 10 + 1
                            end
                        end
                        source.Comments.ZIndex = source.Comments.ZIndex + 1

                        do
                            local luaKeywords = {"and","break","do","else","elseif","end","false","for","function","goto","if","in","local","nil","not","or","repeat","return","then","true","until","while"}
                            local globalEnv = {"getrawmetatable","newcclosure","islclosure","setclipboard","game","workspace","script","math","string","table","print","wait","BrickColor","Color3","next","pairs","ipairs","select","unpack","Instance","Vector2","Vector3","CFrame","Ray","UDim2","Enum","assert","error","warn","tick","loadstring","_G","shared","getfenv","setfenv","newproxy","setmetatable","getmetatable","os","debug","pcall","ypcall","xpcall","rawequal","rawset","rawget","tonumber","tostring","type","typeof","_VERSION","coroutine","delay","require","spawn","LoadLibrary","settings","stats","time","UserSettings","version","Axes","ColorSequence","Faces","ColorSequenceKeypoint","NumberRange","NumberSequence","NumberSequenceKeypoint","gcinfo","elapsedTime","collectgarbage","PhysicalProperties","Rect","Region3","Region3int16","UDim","Vector2int16","Vector3int16","load","fire","Fire"}

                            local function Highlight(text, keywords)
                                local keywordMap = {}
                                local output = text
                                local tokens = {["="]=true,["."]=true,[","]=true,["("]=true,[")"]=true,["["]=true,["]"]=true,["{"]=true,["}"]=true,[":"]=true,["*"]=true,["/"]=true,["+"]=true,["-"]=true,["%"]=true,[";"]=true,["~"]=true}
                                for _, keyword in pairs(keywords) do keywordMap[keyword] = true end
                                output = output:gsub(".", function(char)
                                    if tokens[char] ~= nil then return "\32" else return char end
                                end)
                                output = output:gsub("%S+", function(word)
                                    if keywordMap[word] ~= nil then return word else return (" "):rep(#word) end
                                end)
                                return output
                            end

                            local function HighlightTokens(text)
                                local tokens = {["="]=true,["."]=true,[","]=true,["("]=true,[")"]=true,["["]=true,["]"]=true,["{"]=true,["}"]=true,[":"]=true,["*"]=true,["/"]=true,["+"]=true,["-"]=true,["%"]=true,[";"]=true,["~"]=true}
                                local output = ""
                                text:gsub(".", function(char)
                                    if tokens[char] ~= nil then output = output .. char
                                    elseif char == "\n" then output = output .. "\n"
                                    elseif char == "\t" then output = output .. "\t"
                                    else output = output .. "\32" end
                                end)
                                return output
                            end

                            local function HighlightStrings(text)
                                local output = ""
                                local inString = false
                                text:gsub(".", function(char)
                                    if inString == false and char == "\34" then inString = true
                                    elseif inString == true and char == "\34" then inString = false end
                                    if inString == false and char == "\34" then output = output .. "\34"
                                    elseif char == "\n" then output = output .. "\n"
                                    elseif char == "\t" then output = output .. "\t"
                                    elseif inString == true then output = output .. char
                                    elseif inString == false then output = output .. "\32" end
                                end)
                                return output
                            end

                            local function HighlightInfo(text)
                                local output = ""
                                local inBracket = false
                                text:gsub(".", function(char)
                                    if inBracket == false and char == "[" then inBracket = true
                                    elseif inBracket == true and char == "]" then inBracket = false end
                                    if inBracket == false and char == "\]" then output = output .. "\]"
                                    elseif char == "\n" then output = output .. "\n"
                                    elseif char == "\t" then output = output .. "\t"
                                    elseif inBracket == true then output = output .. char
                                    elseif inBracket == false then output = output .. "\32" end
                                end)
                                return output
                            end

                            local function HighlightComments(text)
                                local output = ""
                                text:gsub("[^\r\n]+", function(line)
                                    local inComment = false
                                    local i = 0
                                    line:gsub(".", function(char)
                                        i = i + 1
                                        if line:sub(i, i + 1) == "--" then inComment = true end
                                        if inComment == true then output = output .. char else output = output .. "\32" end
                                    end)
                                    output = output
                                end)
                                return output
                            end

                            local function HighlightNumbers(text)
                                local output = ""
                                text:gsub(".", function(char)
                                    if tonumber(char) ~= nil then output = output .. char
                                    elseif char == "\n" then output = output .. "\n"
                                    elseif char == "\t" then output = output .. "\t"
                                    else output = output .. "\32" end
                                end)
                                return output
                            end

                            local function UpdateHighlight(type)
                                if type == "Text" then
                                    source.Text = source.Text:gsub("\13", "")
                                    source.Text = source.Text:gsub("\t", "      ")
                                    local text = source.Text
                                    source.Keywords.Text = Highlight(text, luaKeywords)
                                    source.Globals.Text = Highlight(text, globalEnv)
                                    source.RemoteHighlight.Text = Highlight(text, {"FireServer","fireServer","InvokeServer","invokeServer"})
                                    source.Tokens.Text = HighlightTokens(text)
                                    source.Numbers.Text = HighlightNumbers(text)
                                    source.Strings.Text = HighlightStrings(text)
                                    source.Comments.Text = HighlightComments(text)
                                    local lineCount = 1
                                    text:gsub("\n", function() lineCount = lineCount + 1 end)
                                    lines.Text = ""
                                    for i = 1, lineCount do
                                        lines.Text = lines.Text .. i .. "\n"
                                    end
                                    scroll.CanvasSize = UDim2.new(0, 0, lineCount * 0.153846154, 0)
                                end
                                if type == "Text" then
                                    source.Text = source.Text:gsub("\13", "")
                                    source.Text = source.Text:gsub("\t", "      ")
                                    local text = source.Text
                                    source.Info.Text = HighlightInfo(text)
                                    local lineCount = 1
                                    text:gsub("\n", function() lineCount = lineCount + 1 end)
                                    scroll.CanvasSize = UDim2.new(0, 0, lineCount * 0.153846154, 0)
                                end
                            end

                            if consoleOptions.source == "Lua" then
                                UpdateHighlight("Text")
                                source.Changed:Connect(UpdateHighlight)
                            elseif consoleOptions.source == "Logs" then
                                lines.Visible = false
                                local function highlightLogs(type) end
                                highlightLogs("Text")
                                source.Changed:Connect(highlightLogs)
                            end

                            function consoleData:Set(text) source.Text = tostring(text) end
                            function consoleData:Get() return source.Text end
                            function consoleData:Log(message) source.Text = source.Text .. "[*] " .. tostring(message) .. "\n" end
                        end

                        return consoleData, console
                    end

                    function tabData:AddHorizontalAlignment()
                        local haData = {}
                        local ha = prefabs:FindFirstChild("HorizontalAlignment"):Clone()
                        ha.Parent = newTab
                        function haData:AddButton(...)
                            local data, object
                            local results = {tabData:AddButton(...)}
                            if typeof(results[1]) == "table" then
                                data = results[1]
                                object = results[2]
                                object.Parent = ha
                                return data, object
                            else
                                object = results[1]
                                object.Parent = ha
                                return object
                            end
                        end
                        return haData, ha
                    end

                    function tabData:AddFolder(folderName)
                        local folderData = {}
                        folderName = tostring(folderName or "New Folder")
                        local folder = prefabs:FindFirstChild("Folder"):Clone()
                        local button = folder:FindFirstChild("Button")
                        local objects = folder:FindFirstChild("Objects")
                        local toggle = button:FindFirstChild("Toggle")
                        folder.ZIndex = folder.ZIndex + windowCount * 10
                        button.ZIndex = button.ZIndex + windowCount * 10
                        objects.ZIndex = objects.ZIndex + windowCount * 10
                        toggle.ZIndex = toggle.ZIndex + windowCount * 10
                        button:GetChildren()[1].ZIndex = button:GetChildren()[1].ZIndex + windowCount * 10
                        folder.Parent = newTab
                        button.Text = "      " .. folderName

                        spawn(function()
                            while true do
                                if button and button:GetChildren()[1] then
                                    button:GetChildren()[1].ImageColor3 = options.main_color
                                end
                                RunService.Heartbeat:Wait()
                            end
                        end)

                        local function GetFolderHeight()
                            local height = 25
                            for _, child in next, objects:GetChildren() do
                                if not child:IsA("UIListLayout") then
                                    height = height + child.AbsoluteSize.Y + 5
                                end
                            end
                            return height
                        end

                        local isOpen = false
                        button.MouseButton1Click:Connect(function()
                            if isOpen then
                                Resize(toggle, {Rotation = 0}, options.tween_time)
                                objects.Visible = false
                            else
                                Resize(toggle, {Rotation = 90}, options.tween_time)
                                objects.Visible = true
                            end
                            isOpen = not isOpen
                        end)

                        spawn(function()
                            while true do
                                Resize(folder, {Size = UDim2.new(1, 0, 0, isOpen and GetFolderHeight() or 20)}, options.tween_time)
                                wait()
                            end
                        end)

                        for methodName, method in next, tabData do
                            folderData[methodName] = function(...)
                                local data, object
                                local results = {method(...)}
                                if typeof(results[1]) == "table" then
                                    data = results[1]
                                    object = results[2]
                                    object.Parent = objects
                                    return data, object
                                else
                                    object = results[1]
                                    object.Parent = objects
                                    return object
                                end
                            end
                        end

                        return folderData, folder
                    end
                end

                return tabData, newTab
            end
        end
    end

    do
        for _, child in next, window:GetDescendants() do
            if HasProp(child, "ZIndex") then
                child.ZIndex = child.ZIndex + windowCount * 10
            end
        end
    end

    -- ============================================
    -- PROFILE PICTURE - UIStroke + TOP LAYER
    -- ============================================
    local userId = game:GetService("Players").LocalPlayer.UserId
    local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"

    local avatarFrame = Instance.new("ImageLabel")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.Parent = window
    avatarFrame.Size = UDim2.new(0, 50, 0, 50)
    avatarFrame.Position = UDim2.new(1, -65, 1, -65)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    avatarFrame.BackgroundTransparency = 0.3
    avatarFrame.ZIndex = 999

    -- UIStroke instead of Border
    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Parent = avatarFrame
    avatarStroke.Color = options.main_color
    avatarStroke.Thickness = 2
    avatarStroke.Transparency = 0.3
    avatarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatarFrame

    avatarFrame.Image = avatarUrl
    avatarFrame.ImageTransparency = 0.1

    return windowData, window
end

return library
