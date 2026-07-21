local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerMouse = Player:GetMouse()

local antoralib = {
    Themes = {
        Classic = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 25)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32.5, 32.5, 32.5)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 25))
            }),
            ["Color Hub 2"] = Color3.fromRGB(45, 30, 70),
            ["Color Stroke"] = Color3.fromRGB(40, 40, 40),
            ["Color Theme"] = Color3.fromRGB(255, 50, 50),
            ["Color Text"] = Color3.fromRGB(243, 243, 243),
            ["Color Dark Text"] = Color3.fromRGB(180, 180, 180),
            ["antora Icon"] = "https://www.roblox.com/asset-thumbnail/image?assetId=114929713504311&width=678&height=810&format=png"
        }
    },
    Info = {
        Version = "DylanV9999"
    },
    Save = {
        UISize = {540, 350},
        TabSize = 150,
        Theme = "Classic"
    },
    Settings = {},
    Connection = {},
    Instances = {},
    Elements = {},
    Options = {},
    Flags = {},
    Tabs = {},
    Icons = loadstring(game:HttpGet("https://pastebin.com/raw/La8CxEK7"))()
}

local ViewportSize = workspace.CurrentCamera.ViewportSize
local UIScale = ViewportSize.Y / 450

local Settings = antoralib.Settings
local Flags = antoralib.Flags

local PURPLE_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(110, 45, 220)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(176, 96, 244)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(236, 198, 255)),
})

local SetProps, SetChildren, InsertTheme, Create do
    InsertTheme = function(Instance, Type)
        table.insert(antoralib.Instances, {
            Instance = Instance,
            Type = Type
        })
        return Instance
    end

    SetChildren = function(Instance, Children)
        if Children then
            table.foreach(Children, function(_,Child)
                Child.Parent = Instance
            end)
        end
        return Instance
    end

    SetProps = function(Instance, Props)
        if Props then
            table.foreach(Props, function(prop, value)
                Instance[prop] = value
            end)
        end
        return Instance
    end

    Create = function(...)
        local args = {...}
        if type(args) ~= "table" then return end
        local new = Instance.new(args[1])
        local Children = {}

        if type(args[2]) == "table" then
            SetProps(new, args[2])
            SetChildren(new, args[3])
            Children = args[3] or {}
        elseif typeof(args[2]) == "Instance" then
            new.Parent = args[2]
            SetProps(new, args[3])
            SetChildren(new, args[4])
            Children = args[4] or {}
        end
        return new
    end

    local function Save(file)
        if readfile and isfile and isfile(file) then
            local decode = HttpService:JSONDecode(readfile(file))

            if type(decode) == "table" then
                if rawget(decode, "UISize") then antoralib.Save["UISize"] = decode["UISize"] end
                if rawget(decode, "TabSize") then antoralib.Save["TabSize"] = decode["TabSize"] end
                if rawget(decode, "Theme") and VerifyTheme(decode["Theme"]) then antoralib.Save["Theme"] = decode["Theme"] end
            end
        end
    end

    pcall(Save, "Antora Library.json")
end

local Funcs = {} do
    function Funcs:InsertCallback(tab, func)
        if type(func) == "function" then
            table.insert(tab, func)
        end
        return func
    end

    function Funcs:FireCallback(tab, ...)
        for _,v in ipairs(tab) do
            if type(v) == "function" then
                task.spawn(v, ...)
            end
        end
    end

    function Funcs:ToggleVisible(Obj, Bool)
        Obj.Visible = Bool ~= nil and Bool or Obj.Visible
    end

    function Funcs:ToggleParent(Obj, Parent)
        if Bool ~= nil then
            Obj.Parent = Bool
        else
            Obj.Parent = not Obj.Parent and Parent
        end
    end

    function Funcs:GetConnectionFunctions(ConnectedFuncs, func)
        local Connected = { Function = func, Connected = true }

        function Connected:Disconnect()
            if self.Connected then
                table.remove(ConnectedFuncs, table.find(ConnectedFuncs, self.Function))
                self.Connected = false
            end
        end

        function Connected:Fire(...)
            if self.Connected then
                task.spawn(self.Function, ...)
            end
        end

        return Connected
    end

    function Funcs:GetCallback(Configs, index)
        local func = Configs[index] or Configs.Callback or function()end

        if type(func) == "table" then
            return ({function(Value) func[1][func[2]] = Value end})
        end
        return {func}
    end
end

local Connections, Connection = {}, antoralib.Connection do
    local function NewConnectionList(List)
        if type(List) ~= "table" then return end

        for _,CoName in ipairs(List) do
            local ConnectedFuncs, Connect = {}, {}
            Connection[CoName] = Connect
            Connections[CoName] = ConnectedFuncs
            Connect.Name = CoName

            function Connect:Connect(func)
                if type(func) == "function" then
                    table.insert(ConnectedFuncs, func)
                    return Funcs:GetConnectionFunctions(ConnectedFuncs, func)
                end
            end

            function Connect:Once(func)
                if type(func) == "function" then
                    local Connected;

                    local _NFunc;_NFunc = function(...)
                        task.spawn(func, ...)
                        Connected:Disconnect()
                    end

                    Connected = Funcs:GetConnectionFunctions(ConnectedFuncs, _NFunc)
                    return Connected
                end
            end
        end
    end

    function Connection:FireConnection(CoName, ...)
        local Connection = type(CoName) == "string" and Connections[CoName] or Connections[CoName.Name]
        for _,Func in pairs(Connection) do
            task.spawn(Func, ...)
        end
    end

    NewConnectionList({"FlagsChanged", "ThemeChanged", "FileSaved", "ThemeChanging", "OptionAdded"})
end

local GetFlag, SetFlag, CheckFlag do
    CheckFlag = function(Name)
        return type(Name) == "string" and Flags[Name] ~= nil
    end

    GetFlag = function(Name)
        return type(Name) == "string" and Flags[Name]
    end

    SetFlag = function(Flag, Value)
        if Flag and (Value ~= Flags[Flag] or type(Value) == "table") then
            Flags[Flag] = Value
            Connection:FireConnection("FlagsChanged", Flag, Value)
        end
    end

    local db
    Connection.FlagsChanged:Connect(function(Flag, Value)
        local ScriptFile = Settings.ScriptFile
        if not db and ScriptFile and writefile then
            db=true;task.wait(0.1);db=false

            local Success, Encoded = pcall(function()
                return HttpService:JSONEncode(Flags)
            end)

            if Success then
                local Success = pcall(writefile, ScriptFile, Encoded)
                if Success then
                    Connection:FireConnection("FileSaved", "Script-Flags", ScriptFile, Encoded)
                end
            end
        end
    end)
end

local ScreenGui = Create("ScreenGui", CoreGui, {
    Name = "Antora Library",
}, {
    Create("UIScale", {
        Scale = UIScale,
        Name = "Scale"
    })
})

local ScreenFind = CoreGui:FindFirstChild(ScreenGui.Name)
if ScreenFind and ScreenFind ~= ScreenGui then
    ScreenFind:Destroy()
end

local function GetStr(val)
    if type(val) == "function" then
        return val()
    end
    return val
end

local function ConnectSave(Instance, func)
    Instance.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do task.wait()
            end
        end
        func()
    end)
end

local function CreateTween(Configs)
    local Instance = Configs[1] or Configs.Instance
    local Prop = Configs[2] or Configs.Prop
    local NewVal = Configs[3] or Configs.NewVal
    local Time = Configs[4] or Configs.Time or 0.5
    local TweenWait = Configs[5] or Configs.wait or false
    local TweenInfo = TweenInfo.new(Time, Enum.EasingStyle.Quint)

    local Tween = TweenService:Create(Instance, TweenInfo, {[Prop] = NewVal})
    Tween:Play()
    if TweenWait then
        Tween.Completed:Wait()
    end
    return Tween
end

local function MakeDrag(Instance)
    task.spawn(function()
        SetProps(Instance, {
            Active = true,
            AutoButtonColor = false
        })

        local DragStart, StartPos, InputOn

        local function Update(Input)
            local delta = Input.Position - DragStart
            local Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X / UIScale, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y / UIScale)
            CreateTween({Instance, "Position", Position, 0.35})
        end

        Instance.MouseButton1Down:Connect(function()
            InputOn = true
        end)

        Instance.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                StartPos = Instance.Position
                DragStart = Input.Position

                while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do RunService.Heartbeat:Wait()
                    if InputOn then
                        Update(Input)
                    end
                end
                InputOn = false
            end
        end)
    end)
    return Instance
end

local function VerifyTheme(Theme)
    for name,_ in pairs(antoralib.Themes) do
        if name == Theme then
            return true
        end
    end
end

local function SaveJson(FileName, save)
    if writefile then
        local json = HttpService:JSONEncode(save)
        writefile(FileName, json)
    end
end

local Theme = antoralib.Themes[antoralib.Save.Theme]

local function AddEle(Name, Func)
    antoralib.Elements[Name] = Func
end

local function Make(Ele, Instance, props, ...)
    local Element = antoralib.Elements[Ele](Instance, props, ...)
    return Element
end

local function AddMarbleOverlay(parent, cornerRadius, transparency)
    cornerRadius = cornerRadius or UDim.new(0, 6)
    transparency = transparency or 0.6
    local overlay = Create("ImageLabel", parent, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114929713504311&width=678&height=810&format=png",
        ScaleType = Enum.ScaleType.Stretch,
        ImageTransparency = transparency,
        ZIndex = 0
    })
    Make("Corner", overlay, cornerRadius)
    return overlay
end

AddEle("Corner", function(parent, CornerRadius)
    local New = SetProps(Create("UICorner", parent, {
        CornerRadius = CornerRadius or UDim.new(0, 17)
    }), props)
    return New
end)

AddEle("Stroke", function(parent, props, ...)
    local args = {...}
    local New = InsertTheme(SetProps(Create("UIStroke", parent, {
        Color = args[1] or Theme["Color Stroke"],
        Thickness = args[2] or 1,
        ApplyStrokeMode = "Border"
    }), props), "Stroke")
    return New
end)

AddEle("Button", function(parent, props, ...)
    local args = {...}
    local New = InsertTheme(SetProps(Create("TextButton", parent, {
        Text = "",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Theme["Color Hub 2"],
        AutoButtonColor = false
    }), props), "Frame")

    New.MouseEnter:Connect(function()
        New.BackgroundTransparency = 0.4
    end)
    New.MouseLeave:Connect(function()
        New.BackgroundTransparency = 0
    end)
    if args[1] then
        New.Activated:Connect(args[1])
    end
    return New
end)

AddEle("Gradient", function(parent, props, ...)
    local args = {...}
    local New = InsertTheme(SetProps(Create("UIGradient", parent, {
        Color = PURPLE_GRADIENT,
        Rotation = 180
    }), props), "Gradient")
    return New
end)

local function ButtonFrame(Instance, Title, Description, HolderSize)
    local TitleL = InsertTheme(Create("TextLabel", {
        Font = Enum.Font.BuilderSansExtraBold,
        TextColor3 = Theme["Color Text"],
        Size = UDim2.new(1, -20),
        AutomaticSize = "Y",
        Position = UDim2.new(0, 0, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        TextTruncate = "AtEnd",
        TextSize = 10,
        TextXAlignment = "Left",
        Text = "",
        RichText = true
    }), "Text")

    local DescL = InsertTheme(Create("TextLabel", {
        Font = Enum.Font.BuilderSansExtraBold,
        TextColor3 = Theme["Color Dark Text"],
        Size = UDim2.new(1, -20),
        AutomaticSize = "Y",
        Position = UDim2.new(0, 12, 0, 15),
        BackgroundTransparency = 1,
        TextWrapped = true,
        TextSize = 8,
        TextXAlignment = "Left",
        Text = "",
        RichText = true
    }), "DarkText")

    local Frame = Make("Button", Instance, {
        Size = UDim2.new(1, 0, 0, 25),
        AutomaticSize = "Y",
        Name = "Option"
    })
    Make("Corner", Frame, UDim.new(0, 6))
    Make("Gradient", Frame)
    AddMarbleOverlay(Frame, UDim.new(0, 6))

    local LabelHolder = Create("Frame", Frame, {
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
        Size = HolderSize,
        Position = UDim2.new(0, 10, 0),
        AnchorPoint = Vector2.new(0, 0)
    }, {
        Create("UIListLayout", {
            SortOrder = "LayoutOrder",
            VerticalAlignment = "Center",
            Padding = UDim.new(0, 2)
        }),
        Create("UIPadding", {
            PaddingBottom = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 5)
        }),
        TitleL,
        DescL,
    })

    local Label = {}
    function Label:SetTitle(NewTitle)
        if type(NewTitle) == "string" and NewTitle:gsub(" ", ""):len() > 0 then
            TitleL.Text = NewTitle
        end
    end
    function Label:SetDesc(NewDesc)
        if type(NewDesc) == "string" and NewDesc:gsub(" ", ""):len() > 0 then
            DescL.Visible = true
            DescL.Text = NewDesc
            LabelHolder.Position = UDim2.new(0, 10, 0)
            LabelHolder.AnchorPoint = Vector2.new(0, 0)
        else
            DescL.Visible = false
            DescL.Text = ""
            LabelHolder.Position = UDim2.new(0, 10, 0.5)
            LabelHolder.AnchorPoint = Vector2.new(0, 0.5)
        end
    end

    Label:SetTitle(Title)
    Label:SetDesc(Description)
    return Frame, Label
end

local function GetColor(Instance)
    if Instance:IsA("Frame") then
        return "BackgroundColor3"
    elseif Instance:IsA("ImageLabel") then
        return "ImageColor3"
    elseif Instance:IsA("TextLabel") then
        return "TextColor3"
    elseif Instance:IsA("ScrollingFrame") then
        return "ScrollBarImageColor3"
    elseif Instance:IsA("UIStroke") then
        return "Color"
    end
    return ""
end

function antoralib:GetIcon(index)
    if type(index) ~= "string" or index:find("rbxassetid://") or #index == 0 then
        return index
    end

    local firstMatch = nil
    index = string.lower(index):gsub("lucide", ""):gsub("-", "")

    for Name, Icon in self.Icons do
        Name = Name:gsub("lucide", ""):gsub("-", "")
        if Name == index then
            return Icon
        elseif not firstMatch and Name:find(index, 1, true) then
            firstMatch = Icon
        end
    end

    return firstMatch or index
end

function antoralib:SetTheme(NewTheme)
    if not VerifyTheme(NewTheme) then return end

    antoralib.Save.Theme = NewTheme
    SaveJson("Antora Library.json", antoralib.Save)
    Theme = antoralib.Themes[NewTheme]

    Connection:FireConnection("ThemeChanged", NewTheme)
    table.foreach(antoralib.Instances, function(_,Val)
        if Val.Type == "Gradient" then
            Val.Instance.Color = PURPLE_GRADIENT
            Val.Instance.Rotation = 180
        elseif Val.Type == "Frame" then
            Val.Instance.BackgroundColor3 = Theme["Color Hub 2"]
        elseif Val.Type == "Stroke" then
            Val.Instance[GetColor(Val.Instance)] = Theme["Color Stroke"]
        elseif Val.Type == "Theme" then
            Val.Instance[GetColor(Val.Instance)] = Theme["Color Theme"]
        elseif Val.Type == "Text" then
            Val.Instance[GetColor(Val.Instance)] = Theme["Color Text"]
        elseif Val.Type == "DarkText" then
            Val.Instance[GetColor(Val.Instance)] = Theme["Color Dark Text"]
        elseif Val.Type == "ScrollBar" then
            Val.Instance[GetColor(Val.Instance)] = Theme["Color Theme"]
        end
    end)
end

function antoralib:SetScale(NewScale)
    NewScale = ViewportSize.Y / math.clamp(NewScale, 300, 2000)
    UIScale, ScreenGui.Scale.Scale = NewScale, NewScale
end

function antoralib:SetFlag(Flag, Value)
    SetFlag(Flag, Value)
end

function antoralib:GetFlag(Flag)
    return GetFlag(Flag)
end

-- ============================
--  MakeWindow
-- ============================
function antoralib:MakeWindow(Configs)
    local WTitle = Configs[1] or Configs.Name or Configs.Title or "Antora Library"
    local WMiniText = Configs[2] or Configs.SubTitle or ""

    Settings.ScriptFile = Configs[3] or Configs.SaveFolder or false

    local function LoadFile()
        local File = Settings.ScriptFile
        if type(File) ~= "string" then return end
        if not readfile or not isfile then return end
        local s, r = pcall(isfile, File)

        if s and r then
            local s, _Flags = pcall(readfile, File)

            if s and type(_Flags) == "string" then
                local s,r = pcall(function() return HttpService:JSONDecode(_Flags) end)
                Flags = s and r or {}
            end
        end
    end; LoadFile()

    local function CreatePanel(name, anchorPos, size, cornerRadius, zIndex)
        local panel = {}
        cornerRadius = cornerRadius or 20

        panel.Shadow = Create("Frame", ScreenGui, {
            Name = name .. "Shadow",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = anchorPos + UDim2.new(0, 0, 0, 8),
            Size = size,
            BackgroundColor3 = Color3.fromRGB(0,0,0),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            ZIndex = zIndex or 0
        })
        Make("Corner", panel.Shadow, UDim.new(0, cornerRadius))

        panel.Frame = Create("Frame", ScreenGui, {
            Name = name,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = anchorPos,
            Size = size,
            BackgroundColor3 = Color3.fromRGB(255,255,255),
            BackgroundTransparency = 0.15,
            BorderSizePixel = 0
        })
        Make("Corner", panel.Frame, UDim.new(0, cornerRadius))

        local stroke = Create("UIStroke", panel.Frame, {
            Color = Color3.fromRGB(255,255,255),
            Thickness = 2,
            Transparency = 0.3,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })

        local gradient = Create("UIGradient", panel.Frame, {
            Rotation = 90,
            Color = PURPLE_GRADIENT
        })

        local marble = Create("ImageLabel", panel.Frame, {
            Size = UDim2.fromScale(1,1),
            BackgroundTransparency = 1,
            Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114929713504311&width=678&height=810&format=png",
            ImageTransparency = 0.6,
            ScaleType = Enum.ScaleType.Stretch
        })
        Make("Corner", marble, UDim.new(0, cornerRadius))

        return panel
    end

    local MainWidth = 0.40
    local MainHeight = 0.75
    local SideWidth = 0.15
    local SideHeight = 0.75
    local Gap = 0.025

    local MainSize = UDim2.fromScale(MainWidth, MainHeight)
    local MainPos = UDim2.fromScale(0.5, 0.54)
    local MainPanel = CreatePanel("Main", MainPos, MainSize, 20, 1)

    local SideX = (0.5 - MainWidth/2) - Gap - SideWidth/2
    local SidePos = UDim2.new(SideX, 0, 0.54, 0)
    local SideSize = UDim2.fromScale(SideWidth, SideHeight)
    local SidePanel = CreatePanel("Side", SidePos, SideSize, 20, 1)

    MakeDrag(MainPanel.Frame)
    MakeDrag(SidePanel.Frame)

    -- Header
    local HeaderShadow = Create("Frame", MainPanel.Frame, {
        Name = "HeaderShadow",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 2, -0.04, 4),
        Size = UDim2.fromScale(0.5, 0.09),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 0
    })
    Make("Corner", HeaderShadow, UDim.new(0, 18))

    local Header = Create("Frame", MainPanel.Frame, {
        Name = "Header",
        AnchorPoint = Vector2.new(0.5,0),
        Position = UDim2.new(0.5,0,-0.04,0),
        Size = UDim2.fromScale(0.5,0.09),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BorderSizePixel = 0
    })
    Make("Corner", Header, UDim.new(0, 18))

    local HeaderGradient = MainPanel.Frame:FindFirstChildWhichIsA("UIGradient"):Clone()
    HeaderGradient.Parent = Header

    local HeaderMarble = Create("ImageLabel", Header, {
        Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1,
        Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114929713504311&width=678&height=810&format=png",
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Stretch
    })
    Make("Corner", HeaderMarble, UDim.new(0, 18))

    -- Title centered with LuckiestGuy font
    local Title = Create("TextLabel", Header, {
        Name = "Title",
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.fromScale(0.5,0.5),
        Size = UDim2.fromScale(0.85,0.8),
        BackgroundTransparency = 1,
        Font = Enum.Font.LuckiestGuy,
        Text = WTitle,
        TextScaled = true,
        TextColor3 = Color3.fromRGB(255,255,255)
    })

    -- Close button
    local CloseButton = Create("ImageButton", MainPanel.Frame, {
        Name = "CloseButton",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(56, 56),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = "https://www.roblox.com/asset-thumbnail/image?assetId=114840795551292&width=678&height=810&format=png",
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 10
    })
    Make("Corner", CloseButton, UDim.new(1, 0))

    CloseButton.MouseEnter:Connect(function()
        CloseButton:TweenSize(UDim2.fromOffset(62, 62), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    end)
    CloseButton.MouseLeave:Connect(function()
        CloseButton:TweenSize(UDim2.fromOffset(56, 56), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
    end)

    -- Minimized frame
    local MinimizedFrame = Create("ImageButton", ScreenGui, {
        Name = "MinimizedFrame",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -20, 0, 20),
        Size = UDim2.fromOffset(60, 60),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 100,
        Image = "https://www.roblox.com/asset-thumbnail/image?assetId=103591022804634&width=678&height=810&format=png",
        ScaleType = Enum.ScaleType.Fit
    })
    Make("Corner", MinimizedFrame, UDim.new(1, 0))
    local MinimizedStroke = Create("UIStroke", MinimizedFrame, {
        Color = Color3.fromRGB(255,255,255),
        Thickness = 2,
        Transparency = 0.3,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })

    -- State
    local minimized = false
    local creationTime = tick()

    -- Restore function
    local function Restore()
        minimized = false
        MinimizedFrame.Visible = false
        MainPanel.Frame.Visible = true
        MainPanel.Shadow.Visible = true
        SidePanel.Frame.Visible = true
        SidePanel.Shadow.Visible = true

        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(MainPanel.Frame, tweenInfo, {Size = MainSize, Position = MainPos}):Play()
        TweenService:Create(MainPanel.Shadow, tweenInfo, {Size = MainSize, Position = MainPos + UDim2.new(0,0,0,8)}):Play()
        TweenService:Create(SidePanel.Frame, tweenInfo, {Size = SideSize, Position = SidePos}):Play()
        TweenService:Create(SidePanel.Shadow, tweenInfo, {Size = SideSize, Position = SidePos + UDim2.new(0,0,0,8)}):Play()
    end

    -- Minimize function with startup lock
    local function Minimize()
        if tick() - creationTime < 0.5 then return end

        minimized = true
        local targetPos = UDim2.new(1, -40, 0, 40)
        local targetSize = UDim2.fromScale(0.05, 0.05)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

        TweenService:Create(MainPanel.Frame, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
        TweenService:Create(MainPanel.Shadow, tweenInfo, {Size = targetSize, Position = targetPos + UDim2.new(0,0,0,8)}):Play()
        TweenService:Create(SidePanel.Frame, tweenInfo, {Size = targetSize, Position = targetPos}):Play()
        TweenService:Create(SidePanel.Shadow, tweenInfo, {Size = targetSize, Position = targetPos + UDim2.new(0,0,0,8)}):Play()

        task.wait(0.3)
        MainPanel.Frame.Visible = false
        MainPanel.Shadow.Visible = false
        SidePanel.Frame.Visible = false
        SidePanel.Shadow.Visible = false

        MinimizedFrame.Visible = true
        MinimizedFrame.Size = UDim2.fromOffset(0,0)
        MinimizedFrame:TweenSize(UDim2.fromOffset(60,60), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
    end

    MinimizedFrame.MouseButton1Click:Connect(Restore)
    CloseButton.MouseButton1Click:Connect(Minimize)

    -- Tab scrolling frame (side)
    local TabScroll = Create("ScrollingFrame", SidePanel.Frame, {
        Name = "TabScroll",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(180, 120, 255),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = "Y",
        ScrollingDirection = "Y"
    })
    local TabPadding = Create("UIPadding", TabScroll, {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5)
    })
    local TabLayout = Create("UIListLayout", TabScroll, {
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top
    })

    -- Content container (main)
    local ContentContainer = Create("Frame", MainPanel.Frame, {
        Name = "ContentContainer",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })

    -- Window object
    local Window, FirstTab = {}, false
    local ContainerList = {}

    function Window:Minimize()
        Minimize()
    end

    function Window:MinimizeBtn()
        if minimized then
            Restore()
        else
            Minimize()
        end
    end

    function Window:CloseBtn()
        local Dialog = Window:Dialog({
            Title = "Close",
            Text = "You Want Close Ui?",
            Options = {
                {"Confirm", function()
                    ScreenGui:Destroy()
                end},
                {"Cancel"}
            }
        })
    end

    function Window:Set(Val1, Val2)
        if type(Val1) == "string" and type(Val2) == "string" then
            Title.Text = Val1
        elseif type(Val1) == "string" then
            Title.Text = Val1
        end
    end

    function Window:Dialog(Configs)
        if MainPanel.Frame:FindFirstChild("Dialog") then return end

        local DTitle = Configs[1] or Configs.Title or "Dialog"
        local DText = Configs[2] or Configs.Text or "This is a Dialog"
        local DOptions = Configs[3] or Configs.Options or {}

        local Frame = Create("Frame", {
            Active = true,
            Size = UDim2.fromOffset(250 * 1.08, 150 * 1.08),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5)
        }, {
            Create("TextLabel", {
                Font = Enum.Font.BuilderSansExtraBold,
                Size = UDim2.new(1, 0, 0, 20),
                Text = DTitle,
                TextXAlignment = "Left",
                TextColor3 = Theme["Color Text"],
                TextSize = 15,
                Position = UDim2.fromOffset(15, 5),
                BackgroundTransparency = 1
            }),
            Create("TextLabel", {
                Font = Enum.Font.BuilderSansExtraBold,
                Size = UDim2.new(1, -25),
                AutomaticSize = "Y",
                Text = DText,
                TextXAlignment = "Left",
                TextColor3 = Theme["Color Dark Text"],
                TextSize = 12,
                Position = UDim2.fromOffset(15, 25),
                BackgroundTransparency = 1,
                TextWrapped = true
            })
        })
        Make("Gradient", Frame, {Rotation = 180})
        Make("Corner", Frame)
        AddMarbleOverlay(Frame, UDim.new(0, 6))

        local ButtonsHolder = Create("Frame", Frame, {
            Size = UDim2.fromScale(1, 0.35),
            Position = UDim2.fromScale(0, 1),
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = Theme["Color Hub 2"],
            BackgroundTransparency = 1
        }, {
            Create("UIListLayout", {
                Padding = UDim.new(0, 10),
                VerticalAlignment = "Center",
                FillDirection = "Horizontal",
                HorizontalAlignment = "Center"
            })
        })

        local Screen = Create("Frame", MainPanel.Frame, {
            BackgroundTransparency = 0.6,
            Active = true,
            BackgroundColor3 = Theme["Color Hub 2"],
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Theme["Color Stroke"],
            Name = "Dialog"
        })
        Make("Corner", Screen, UDim.new(0, 20))
        Frame.Parent = Screen
        CreateTween({Frame, "Size", UDim2.fromOffset(250, 150), 0.2})
        CreateTween({Frame, "Transparency", 0, 0.15})
        CreateTween({Screen, "Transparency", 0.3, 0.15})

        local ButtonCount, Dialog = 1, {}
        function Dialog:Button(Configs)
            local Name = Configs[1] or Configs.Name or Configs.Title or ""
            local Callback = Configs[2] or Configs.Callback or function()end

            ButtonCount = ButtonCount + 1
            local Button = Make("Button", ButtonsHolder)
            Make("Corner", Button)
            Make("Gradient", Button)
            AddMarbleOverlay(Button, UDim.new(0, 6))
            SetProps(Button, {
                Text = Name,
                Font = Enum.Font.BuilderSansExtraBold,
                TextColor3 = Theme["Color Text"],
                TextSize = 12
            })

            for _,B in pairs(ButtonsHolder:GetChildren()) do
                if B:IsA("TextButton") then
                    B.Size = UDim2.new(1 / ButtonCount, -(((ButtonCount - 1) * 20) / ButtonCount), 0, 32)
                end
            end
            Button.Activated:Connect(Dialog.Close)
            Button.Activated:Connect(Callback)
        end
        function Dialog:Close()
            CreateTween({Frame, "Size", UDim2.fromOffset(250 * 1.08, 150 * 1.08), 0.2})
            CreateTween({Screen, "Transparency", 1, 0.15})
            CreateTween({Frame, "Transparency", 1, 0.15, true})
            Screen:Destroy()
        end
        table.foreach(DOptions, function(_,Button)
            Dialog:Button(Button)
        end)
        return Dialog
    end

    function Window:SelectTab(TabSelect)
        if type(TabSelect) == "number" then
            antoralib.Tabs[TabSelect].func:Enable()
        else
            for _,Tab in pairs(antoralib.Tabs) do
                if Tab.Cont == TabSelect.Cont then
                    Tab.func:Enable()
                end
            end
        end
    end

    -- ===== FIXED MakeTab - proper argument handling =====
    function Window:MakeTab(paste, Configs)
        local TName, TIcon
        
        -- Handle both calling styles: (title, icon) or ({Title = ..., Icon = ...})
        if type(paste) == "table" then
            TName = paste[1] or paste.Title or "Tab!"
            TIcon = paste[2] or paste.Icon or ""
        else
            TName = paste or "Tab!"
            TIcon = Configs or ""
        end

        TIcon = antoralib:GetIcon(TIcon)
        if not TIcon:find("rbxassetid://") or TIcon:gsub("rbxassetid://", ""):len() < 6 then
            TIcon = false
        end

        -- Create tab button
        local TabButton = Make("Button", TabScroll, {
            Size = UDim2.new(0.9, 0, 0, 35),
            Name = "TabButton_" .. TName
        })
        Make("Corner", TabButton, UDim.new(0, 8))
        Make("Gradient", TabButton)
        AddMarbleOverlay(TabButton, UDim.new(0, 8))

        -- Icon (if provided)
        local LabelIcon
        if TIcon then
            LabelIcon = Create("ImageLabel", TabButton, {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 8, 0.5),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Image = TIcon
            })
        end

        -- Tab label
        local LabelTitle = Create("TextLabel", TabButton, {
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.new(0, TIcon and 32 or 10, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Font = Enum.Font.LuckiestGuy,
            Text = TName,
            TextColor3 = Theme["Color Text"],
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = "AtEnd"
        })

        -- Selection indicator
        local Selected = Create("Frame", TabButton, {
            Size = UDim2.new(0, 4, 0, 4),
            Position = UDim2.new(0, 1, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1
        })
        local selGradient = Instance.new("UIGradient")
        selGradient.Color = PURPLE_GRADIENT
        selGradient.Rotation = 90
        selGradient.Parent = Selected
        Make("Corner", Selected, UDim.new(0.5, 0))

        -- Content container
        local Container = Create("ScrollingFrame", ContentContainer, {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 1),
            AnchorPoint = Vector2.new(0, 1),
            ScrollBarThickness = 1.5,
            BackgroundTransparency = 1,
            ScrollBarImageTransparency = 0.2,
            ScrollBarImageColor3 = Theme["Color Theme"],
            AutomaticCanvasSize = "Y",
            ScrollingDirection = "Y",
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(),
            Name = ("Container %i"):format(#ContainerList + 1),
            Visible = false
        })
        local ContainerPadding = Create("UIPadding", Container, {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
        local ContainerLayout = Create("UIListLayout", Container, {
            Padding = UDim.new(0, 5)
        })

        table.insert(ContainerList, Container)

        local function Activate()
            if Container.Visible then return end
            for _, cont in pairs(ContainerList) do
                cont.Visible = false
            end
            Container.Visible = true
            for _, tab in pairs(antoralib.Tabs) do
                if tab.Cont ~= Container then
                    tab.func:Disable()
                end
            end
            CreateTween({Selected, "Size", UDim2.new(0, 4, 0, 16), 0.35})
            CreateTween({Selected, "BackgroundTransparency", 0, 0.35})
        end

        local Tab = {}
        table.insert(antoralib.Tabs, {TabInfo = {Name = TName, Icon = TIcon}, func = Tab, Cont = Container})
        Tab.Cont = Container

        function Tab:Enable()
            Activate()
        end

        function Tab:Disable()
            Container.Visible = false
            CreateTween({Selected, "Size", UDim2.new(0, 4, 0, 4), 0.35})
            CreateTween({Selected, "BackgroundTransparency", 1, 0.35})
        end

        function Tab:Visible(Bool)
            Funcs:ToggleVisible(TabButton, Bool)
            Funcs:ToggleParent(Container, Bool, ContentContainer)
        end

        function Tab:Destroy()
            TabButton:Destroy()
            Container:Destroy()
        end

        TabButton.Activated:Connect(Activate)

        if not FirstTab then
            FirstTab = true
            Activate()
        end

        -- ========== Tab Methods ==========
        function Tab:AddSection(Configs)
            local SectionName = type(Configs) == "string" and Configs or Configs[1] or Configs.Name or Configs.Title or Configs.Section

            local SectionFrame = Create("Frame", Container, {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Name = "Option"
            })

            local SectionLabel = InsertTheme(Create("TextLabel", SectionFrame, {
                Font = Enum.Font.BuilderSansExtraBold,
                Text = SectionName,
                TextColor3 = Theme["Color Text"],
                Size = UDim2.new(1, -25, 1, 0),
                Position = UDim2.new(0, 5),
                BackgroundTransparency = 1,
                TextTruncate = "AtEnd",
                TextSize = 14,
                TextXAlignment = "Left"
            }), "Text")

            local Section = {}
            table.insert(antoralib.Options, {type = "Section", Name = SectionName, func = Section})
            function Section:Visible(Bool)
                if Bool == nil then SectionFrame.Visible = not SectionFrame.Visible return end
                SectionFrame.Visible = Bool
            end
            function Section:Destroy() SectionFrame:Destroy() end
            function Section:Set(New) if New then SectionLabel.Text = GetStr(New) end end
            return Section
        end

        function Tab:AddParagraph(Configs)
            local PName = Configs[1] or Configs.Title or "Paragraph"
            local PDesc = Configs[2] or Configs.Text or ""
            local Frame, LabelFunc = ButtonFrame(Container, PName, PDesc, UDim2.new(1, -20))
            local Paragraph = {}
            function Paragraph:Visible(...) Funcs:ToggleVisible(Frame, ...) end
            function Paragraph:Destroy() Frame:Destroy() end
            function Paragraph:SetTitle(Val) LabelFunc:SetTitle(GetStr(Val)) end
            function Paragraph:SetDesc(Val) LabelFunc:SetDesc(GetStr(Val)) end
            function Paragraph:Set(Val1, Val2)
                if Val1 and Val2 then
                    LabelFunc:SetTitle(GetStr(Val1))
                    LabelFunc:SetDesc(GetStr(Val2))
                elseif Val1 then
                    LabelFunc:SetDesc(GetStr(Val1))
                end
            end
            return Paragraph
        end

        function Tab:AddButton(Configs)
            local BName = Configs[1] or Configs.Name or Configs.Title or "Button!"
            local BDescription = Configs.Desc or Configs.Description or ""
            local Callback = Funcs:GetCallback(Configs, 2)

            local FButton, LabelFunc = ButtonFrame(Container, BName, BDescription, UDim2.new(1, -20))
            local ButtonIcon = Create("ImageLabel", FButton, {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(1, -10, 0.5),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Image = "rbxassetid://10709791437"
            })
            FButton.Activated:Connect(function()
                Funcs:FireCallback(Callback)
            end)
            local Button = {}
            function Button:Visible(...) Funcs:ToggleVisible(FButton, ...) end
            function Button:Destroy() FButton:Destroy() end
            function Button:Callback(...) Funcs:InsertCallback(Callback, ...) end
            function Button:Set(Val1, Val2)
                if type(Val1) == "string" and type(Val2) == "string" then
                    LabelFunc:SetTitle(Val1)
                    LabelFunc:SetDesc(Val2)
                elseif type(Val1) == "string" then
                    LabelFunc:SetTitle(Val1)
                elseif type(Val1) == "function" then
                    Callback = Val1
                end
            end
            return Button
        end

        function Tab:AddToggle(Configs)
            local TName = Configs[1] or Configs.Name or Configs.Title or "Toggle"
            local TDesc = Configs.Desc or Configs.Description or ""
            local Callback = Funcs:GetCallback(Configs, 3)
            local Flag = Configs[4] or Configs.Flag or false
            local Default = Configs[2] or Configs.Default or false
            if CheckFlag(Flag) then Default = GetFlag(Flag) end

            local Button, LabelFunc = ButtonFrame(Container, TName, TDesc, UDim2.new(1, -38))

            local ToggleHolder = InsertTheme(Create("Frame", Button, {
                Size = UDim2.new(0, 35, 0, 18),
                Position = UDim2.new(1, -10, 0.5),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Theme["Color Stroke"]
            }), "Stroke")
            Make("Corner", ToggleHolder, UDim.new(0.5, 0))

            local Slider = Create("Frame", ToggleHolder, {
                BackgroundTransparency = 1,
                Size = UDim2.new(0.8, 0, 0.8, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5)
            })

            local Toggle = InsertTheme(Create("Frame", Slider, {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0, 0, 0.5),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1
            }), "Theme")

            local gradient = Instance.new("UIGradient")
            gradient.Color = PURPLE_GRADIENT
            gradient.Rotation = 180
            gradient.Parent = Toggle
            Make("Corner", Toggle, UDim.new(0.5, 0))

            local WaitClick
            local function SetToggle(Val)
                if WaitClick then return end
                WaitClick, Default = true, Val
                SetFlag(Flag, Default)
                Funcs:FireCallback(Callback, Default)
                if Default then
                    CreateTween({Toggle, "Position", UDim2.new(1, 0, 0.5), 0.25})
                    CreateTween({Toggle, "BackgroundTransparency", 0, 0.25})
                    CreateTween({Toggle, "AnchorPoint", Vector2.new(1, 0.5), 0.25})
                else
                    CreateTween({Toggle, "Position", UDim2.new(0, 0, 0.5), 0.25})
                    CreateTween({Toggle, "BackgroundTransparency", 0.8, 0.25})
                    CreateTween({Toggle, "AnchorPoint", Vector2.new(0, 0.5), 0.25})
                end
                WaitClick = false
            end
            task.spawn(SetToggle, Default)

            Button.Activated:Connect(function()
                SetToggle(not Default)
            end)

            local Toggle = {}
            function Toggle:Visible(...) Funcs:ToggleVisible(Button, ...) end
            function Toggle:Destroy() Button:Destroy() end
            function Toggle:Callback(...) Funcs:InsertCallback(Callback, ...)() end
            function Toggle:Set(Val1, Val2)
                if type(Val1) == "string" and type(Val2) == "string" then
                    LabelFunc:SetTitle(Val1)
                    LabelFunc:SetDesc(Val2)
                elseif type(Val1) == "string" then
                    LabelFunc:SetTitle(Val1, false, true)
                elseif type(Val1) == "boolean" then
                    if WaitClick and Val2 then
                        repeat task.wait() until not WaitClick
                    end
                    task.spawn(SetToggle, Val1)
                elseif type(Val1) == "function" then
                    Callback = Val1
                end
            end
            return Toggle
        end

        function Tab:AddDropdown(Configs)
            local DName = Configs[1] or Configs.Name or Configs.Title or "Dropdown"
            local DDesc = Configs.Desc or Configs.Description or ""
            local DOptions = Configs[2] or Configs.Options or {}
            local OpDefault = Configs[3] or Configs.Default or {}
            local Flag = Configs[5] or Configs.Flag or false
            local DMultiSelect = Configs.MultiSelect or false
            local Callback = Funcs:GetCallback(Configs, 4)

            local Button, LabelFunc = ButtonFrame(Container, DName, DDesc, UDim2.new(1, -180))

            local SelectedFrame = InsertTheme(Create("Frame", Button, {
                Size = UDim2.new(0, 150, 0, 18),
                Position = UDim2.new(1, -10, 0.5),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Theme["Color Stroke"]
            }), "Stroke")
            Make("Corner", SelectedFrame, UDim.new(0, 4))

            local ActiveLabel = InsertTheme(Create("TextLabel", SelectedFrame, {
                Size = UDim2.new(0.85, 0, 0.85, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.BuilderSansExtraBold,
                TextScaled = true,
                TextColor3 = Theme["Color Text"],
                Text = "..."
            }), "Text")

            local Arrow = Create("ImageLabel", SelectedFrame, {
                Size = UDim2.new(0, 15, 0, 15),
                Position = UDim2.new(0, -5, 0.5),
                AnchorPoint = Vector2.new(1, 0.5),
                Image = "rbxassetid://10709791523",
                BackgroundTransparency = 1
            })

            local NoClickFrame = Create("TextButton", ScreenGui, {
                Name = "AntiClick",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Visible = false,
                Text = ""
            })

            local DropFrame = Create("Frame", NoClickFrame, {
                Size = UDim2.new(SelectedFrame.Size.X, 0, 0),
                BackgroundTransparency = 0.1,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                AnchorPoint = Vector2.new(0, 1),
                Name = "DropdownFrame",
                ClipsDescendants = true,
                Active = true
            })
            Make("Corner", DropFrame)
            Make("Stroke", DropFrame)
            Make("Gradient", DropFrame, {Rotation = 180})
            AddMarbleOverlay(DropFrame, UDim.new(0, 6))

            local ScrollFrame = InsertTheme(Create("ScrollingFrame", DropFrame, {
                ScrollBarImageColor3 = Theme["Color Theme"],
                Size = UDim2.new(1, 0, 1, 0),
                ScrollBarThickness = 1.5,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                CanvasSize = UDim2.new(),
                ScrollingDirection = "Y",
                AutomaticCanvasSize = "Y",
                Active = true
            }, {
                Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                    PaddingTop = UDim.new(0, 5),
                    PaddingBottom = UDim.new(0, 5)
                }),
                Create("UIListLayout", {
                    Padding = UDim.new(0, 4)
                })
            }), "ScrollBar")

            local ScrollSize, WaitClick = 5
            local function Disable()
                WaitClick = true
                CreateTween({Arrow, "Rotation", 0, 0.2})
                CreateTween({DropFrame, "Size", UDim2.new(0, 152, 0, 0), 0.2, true})
                CreateTween({Arrow, "ImageColor3", Color3.fromRGB(255, 255, 255), 0.2})
                Arrow.Image = "rbxassetid://10709791523"
                NoClickFrame.Visible = false
                WaitClick = false
            end

            local function GetFrameSize()
                return UDim2.fromOffset(152, ScrollSize)
            end

            local function CalculateSize()
                local Count = 0
                for _,Frame in pairs(ScrollFrame:GetChildren()) do
                    if Frame:IsA("Frame") or Frame.Name == "Option" then
                        Count = Count + 1
                    end
                end
                ScrollSize = (math.clamp(Count, 0, 10) * 25) + 10
                if NoClickFrame.Visible then
                    NoClickFrame.Visible = true
                    CreateTween({DropFrame, "Size", GetFrameSize(), 0.2, true})
                end
            end

            local function Minimize()
                if WaitClick then return end
                WaitClick = true
                if NoClickFrame.Visible then
                    Arrow.Image = "rbxassetid://10709791523"
                    CreateTween({Arrow, "ImageColor3", Color3.fromRGB(255, 255, 255), 0.2})
                    CreateTween({DropFrame, "Size", UDim2.new(0, 152, 0, 0), 0.2, true})
                    NoClickFrame.Visible = false
                else
                    NoClickFrame.Visible = true
                    Arrow.Image = "rbxassetid://10709790948"
                    CreateTween({Arrow, "ImageColor3", Color3.fromRGB(255, 255, 255), 0.2})
                    CreateTween({DropFrame, "Size", GetFrameSize(), 0.2, true})
                end
                WaitClick = false
            end

            local function CalculatePos()
                local FramePos = SelectedFrame.AbsolutePosition
                local ScreenSize = ScreenGui.AbsoluteSize
                local ClampX = math.clamp((FramePos.X / UIScale), 0, ScreenSize.X / UIScale - DropFrame.Size.X.Offset)
                local ClampY = math.clamp((FramePos.Y / UIScale) , 0, ScreenSize.Y / UIScale)
                local NewPos = UDim2.fromOffset(ClampX, ClampY)
                local AnchorPoint = FramePos.Y > ScreenSize.Y / 1.4 and 1 or ScrollSize > 80 and 0.5 or 0
                DropFrame.AnchorPoint = Vector2.new(0, AnchorPoint)
                CreateTween({DropFrame, "Position", NewPos, 0.1})
            end

            local AddNewOptions, GetOptions, AddOption, RemoveOption, Selected do
                local Default = type(OpDefault) ~= "table" and {OpDefault} or OpDefault
                local MultiSelect = DMultiSelect
                local Options = {}
                Selected = MultiSelect and {} or CheckFlag(Flag) and GetFlag(Flag) or Default[1]

                if MultiSelect then
                    for index, Value in pairs(CheckFlag(Flag) and GetFlag(Flag) or Default) do
                        if type(index) == "string" and (DOptions[index] or table.find(DOptions, index)) then
                            Selected[index] = Value
                        elseif DOptions[Value] then
                            Selected[Value] = true
                        end
                    end
                end

                local function CallbackSelected()
                    SetFlag(Flag, MultiSelect and Selected or tostring(Selected))
                    Funcs:FireCallback(Callback, Selected)
                end

                local function UpdateLabel()
                    if MultiSelect then
                        local list = {}
                        for index, Value in pairs(Selected) do
                            if Value then
                                table.insert(list, index)
                            end
                        end
                        ActiveLabel.Text = #list > 0 and table.concat(list, ", ") or "..."
                    else
                        ActiveLabel.Text = tostring(Selected or "...")
                    end
                end

                local function UpdateSelected()
                    if MultiSelect then
                        for _,v in pairs(Options) do
                            local nodes, Stats = v.nodes, v.Stats
                            CreateTween({nodes[2], "BackgroundTransparency", Stats and 0 or 0.8, 0.35})
                            CreateTween({nodes[2], "Size", Stats and UDim2.fromOffset(4, 12) or UDim2.fromOffset(4, 4), 0.35})
                            CreateTween({nodes[3], "TextTransparency", Stats and 0 or 0.4, 0.35})
                        end
                    else
                        for _,v in pairs(Options) do
                            local Slt = v.Value == Selected
                            local nodes = v.nodes
                            CreateTween({nodes[2], "BackgroundTransparency", Slt and 0 or 1, 0.35})
                            CreateTween({nodes[2], "Size", Slt and UDim2.fromOffset(4, 14) or UDim2.fromOffset(4, 4), 0.35})
                            CreateTween({nodes[3], "TextTransparency", Slt and 0 or 0.4, 0.35})
                        end
                    end
                    UpdateLabel()
                end

                local function Select(Option)
                    if MultiSelect then
                        Option.Stats = not Option.Stats
                        Option.LastCB = tick()
                        Selected[Option.Name] = Option.Stats
                        CallbackSelected()
                    else
                        Option.LastCB = tick()
                        Selected = Option.Value
                        CallbackSelected()
                    end
                    UpdateSelected()
                end

                AddOption = function(index, Value)
                    local Name = tostring(type(index) == "string" and index or Value)
                    if Options[Name] then return end
                    Options[Name] = {
                        index = index,
                        Value = Value,
                        Name = Name,
                        Stats = false,
                        LastCB = 0
                    }
                    if MultiSelect then
                        local Stats = Selected[Name]
                        Selected[Name] = Stats or false
                        Options[Name].Stats = Stats
                    end

                    local Button = Make("Button", ScrollFrame, {
                        Name = "Option",
                        Size = UDim2.new(1, 0, 0, 21),
                        Position = UDim2.new(0, 0, 0.5),
                        AnchorPoint = Vector2.new(0, 0.5)
                    })
                    Make("Corner", Button, UDim.new(0, 4))

                    local IsSelected = InsertTheme(Create("Frame", Button, {
                        Position = UDim2.new(0, 1, 0.5),
                        Size = UDim2.new(0, 4, 0, 4),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0, 0.5)
                    }), "Theme")
                    local grad = Instance.new("UIGradient")
                    grad.Color = PURPLE_GRADIENT
                    grad.Rotation = 180
                    grad.Parent = IsSelected
                    Make("Corner", IsSelected, UDim.new(0.5, 0))

                    local OptioneName = InsertTheme(Create("TextLabel", Button, {
                        Size = UDim2.new(1, 0, 1),
                        Position = UDim2.new(0, 10),
                        Text = Name,
                        TextColor3 = Theme["Color Text"],
                        Font = Enum.Font.BuilderSansExtraBold,
                        TextXAlignment = "Left",
                        BackgroundTransparency = 1,
                        TextTransparency = 0.4
                    }), "Text")

                    Button.Activated:Connect(function()
                        Select(Options[Name])
                    end)
                    Options[Name].nodes = {Button, IsSelected, OptioneName}
                end

                RemoveOption = function(index, Value)
                    local Name = tostring(type(index) == "string" and index or Value)
                    if Options[Name] then
                        if MultiSelect then Selected[Name] = nil else Selected = nil end
                        Options[Name].nodes[1]:Destroy()
                        table.clear(Options[Name])
                        Options[Name] = nil
                    end
                end

                GetOptions = function() return Options end

                AddNewOptions = function(List, Clear)
                    if Clear then
                        table.foreach(Options, RemoveOption)
                    end
                    table.foreach(List, AddOption)
                    CallbackSelected()
                    UpdateSelected()
                end

                table.foreach(DOptions, AddOption)
                CallbackSelected()
                UpdateSelected()
            end

            Button.Activated:Connect(Minimize)
            NoClickFrame.MouseButton1Down:Connect(Disable)
            NoClickFrame.MouseButton1Click:Connect(Disable)
            MainPanel.Frame:GetPropertyChangedSignal("Visible"):Connect(Disable)
            SelectedFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(CalculatePos)
            Button.Activated:Connect(CalculateSize)
            ScrollFrame.ChildAdded:Connect(CalculateSize)
            ScrollFrame.ChildRemoved:Connect(CalculateSize)
            CalculatePos()
            CalculateSize()

            local Dropdown = {}
            function Dropdown:Visible(...) Funcs:ToggleVisible(Button, ...) end
            function Dropdown:Destroy() Button:Destroy() end
            function Dropdown:Callback(...) Funcs:InsertCallback(Callback, ...)(Selected) end
            function Dropdown:Add(...)
                local NewOptions = {...}
                if type(NewOptions[1]) == "table" then
                    table.foreach(NewOptions[1], function(_,Name) AddOption(Name) end)
                else
                    table.foreach(NewOptions, function(_,Name) AddOption(Name) end)
                end
            end
            function Dropdown:Remove(Option)
                for index, Value in pairs(GetOptions()) do
                    if type(Option) == "number" and index == Option or Value.Name == Option then
                        RemoveOption(index, Value.Value)
                    end
                end
            end
            function Dropdown:Select(Option)
                for _,Val in pairs(Options) do
                    if Val.Name == Option or Val.Value == Option then
                        Select(Val)
                        return
                    end
                end
            end
            function Dropdown:Set(Val1, Clear)
                if type(Val1) == "table" then
                    AddNewOptions(Val1, not Clear)
                elseif type(Val1) == "function" then
                    Callback = Val1
                end
            end
            return Dropdown
        end

        function Tab:AddSlider(Configs)
            local SName = Configs[1] or Configs.Name or Configs.Title or "Slider!"
            local SDesc = Configs.Desc or Configs.Description or ""
            local Min = Configs[2] or Configs.MinValue or Configs.Min or 10
            local Max = Configs[3] or Configs.MaxValue or Configs.Max or 100
            local Increase = Configs[4] or Configs.Increase or 1
            local Callback = Funcs:GetCallback(Configs, 6)
            local Flag = Configs[7] or Configs.Flag or false
            local Default = Configs[5] or Configs.Default or 25
            if CheckFlag(Flag) then Default = GetFlag(Flag) end
            Min, Max = Min / Increase, Max / Increase

            local Button, LabelFunc = ButtonFrame(Container, SName, SDesc, UDim2.new(1, -180))

            local SliderHolder = Create("TextButton", Button, {
                Size = UDim2.new(0.45, 0, 1),
                Position = UDim2.new(1),
                AnchorPoint = Vector2.new(1, 0),
                AutoButtonColor = false,
                Text = "",
                BackgroundTransparency = 1
            })

            local SliderBar = InsertTheme(Create("Frame", SliderHolder, {
                BackgroundColor3 = Theme["Color Stroke"],
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0.5, 0, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5)
            }), "Stroke")
            Make("Corner", SliderBar)

            local Indicator = InsertTheme(Create("Frame", SliderBar, {
                Size = UDim2.fromScale(0.3, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }), "Theme")
            local grad = Instance.new("UIGradient")
            grad.Color = PURPLE_GRADIENT
            grad.Rotation = 180
            grad.Parent = Indicator
            Make("Corner", Indicator)

            local SliderIcon = Create("Frame", SliderBar, {
                Size = UDim2.new(0, 6, 0, 12),
                BackgroundColor3 = Color3.fromRGB(220, 220, 220),
                Position = UDim2.fromScale(0.3, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 0.2
            })
            Make("Corner", SliderIcon)

            local LabelVal = InsertTheme(Create("TextLabel", SliderHolder, {
                Size = UDim2.new(0, 14, 0, 14),
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(0, 0, 0.5),
                BackgroundTransparency = 1,
                TextColor3 = Theme["Color Text"],
                Font = Enum.Font.BuilderSansExtraBold,
                TextSize = 12
            }), "Text")

            local BaseMousePos = Create("Frame", SliderBar, {
                Position = UDim2.new(0, 0, 0.5, 0),
                Visible = false
            })

            local function UpdateLabel(NewValue)
                local Number = tonumber(NewValue * Increase)
                Number = math.floor(Number * 100) / 100
                Default, LabelVal.Text = Number, tostring(Number)
                Funcs:FireCallback(Callback, Default)
            end

            local function ControlPos()
                local MousePos = Player:GetMouse()
                local APos = MousePos.X - BaseMousePos.AbsolutePosition.X
                local ConfigureDpiPos = APos / SliderBar.AbsoluteSize.X
                SliderIcon.Position = UDim2.new(math.clamp(ConfigureDpiPos, 0, 1), 0, 0.5, 0)
            end

            local function UpdateValues()
                Indicator.Size = UDim2.new(SliderIcon.Position.X.Scale, 0, 1, 0)
                local SliderPos = SliderIcon.Position.X.Scale
                local NewValue = math.floor(((SliderPos * Max) / Max) * (Max - Min) + Min)
                UpdateLabel(NewValue)
            end

            SliderHolder.MouseButton1Down:Connect(function()
                CreateTween({SliderIcon, "Transparency", 0, 0.3})
                Container.ScrollingEnabled = false
                while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    task.wait()
                    ControlPos()
                end
                CreateTween({SliderIcon, "Transparency", 0.2, 0.3})
                Container.ScrollingEnabled = true
                SetFlag(Flag, Default)
            end)

            function SetSlider(NewValue)
                if type(NewValue) ~= "number" then return end
                local Min, Max = Min * Increase, Max * Increase
                local SliderPos = (NewValue - Min) / (Max - Min)
                SetFlag(Flag, NewValue)
                CreateTween({ SliderIcon, "Position", UDim2.fromScale(math.clamp(SliderPos, 0, 1), 0.5), 0.3, true })
            end
            SetSlider(Default)

            SliderIcon:GetPropertyChangedSignal("Position"):Connect(UpdateValues)
            UpdateValues()

            local Slider = {}
            function Slider:Set(NewVal1, NewVal2)
                if NewVal1 and NewVal2 then
                    LabelFunc:SetTitle(NewVal1)
                    LabelFunc:SetDesc(NewVal2)
                elseif type(NewVal1) == "string" then
                    LabelFunc:SetTitle(NewVal1)
                elseif type(NewVal1) == "function" then
                    Callback = NewVal1
                elseif type(NewVal1) == "number" then
                    SetSlider(NewVal1)
                end
            end
            function Slider:Callback(...) Funcs:InsertCallback(Callback, ...)(tonumber(Default)) end
            function Slider:Visible(...) Funcs:ToggleVisible(Button, ...) end
            function Slider:Destroy() Button:Destroy() end
            return Slider
        end

        function Tab:AddTextBox(Configs)
            local TName = Configs[1] or Configs.Name or Configs.Title or "Text Box"
            local TDesc = Configs.Desc or Configs.Description or ""
            local TDefault = Configs[2] or Configs.Default or ""
            local TPlaceholderText = Configs[5] or Configs.PlaceholderText or "Input"
            local TClearText = Configs[3] or Configs.ClearText or false
            local Callback = Funcs:GetCallback(Configs, 4)

            if type(TDefault) ~= "string" or TDefault:gsub(" ", ""):len() < 1 then
                TDefault = false
            end

            local Button, LabelFunc = ButtonFrame(Container, TName, TDesc, UDim2.new(1, -38))

            local SelectedFrame = InsertTheme(Create("Frame", Button, {
                Size = UDim2.new(0, 150, 0, 18),
                Position = UDim2.new(1, -10, 0.5),
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Theme["Color Stroke"]
            }), "Stroke")
            Make("Corner", SelectedFrame, UDim.new(0, 4))

            local TextBoxInput = InsertTheme(Create("TextBox", SelectedFrame, {
                Size = UDim2.new(0.85, 0, 0.85, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.BuilderSansExtraBold,
                TextScaled = true,
                TextColor3 = Theme["Color Text"],
                ClearTextOnFocus = TClearText,
                PlaceholderText = TPlaceholderText,
                Text = ""
            }), "Text")

            local Pencil = Create("ImageLabel", SelectedFrame, {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0, -5, 0.5),
                AnchorPoint = Vector2.new(1, 0.5),
                Image = "",
                BackgroundTransparency = 1
            })

            local TextBox = {}
            local function Input()
                local Text = TextBoxInput.Text
                if Text:gsub(" ", ""):len() > 0 then
                    if TextBox.OnChanging then Text = TextBox.OnChanging(Text) or Text end
                    Funcs:FireCallback(Callback, Text)
                    TextBoxInput.Text = Text
                end
            end

            TextBoxInput.FocusLost:Connect(Input)
            Input()

            TextBoxInput.FocusLost:Connect(function()
                CreateTween({Pencil, "ImageColor3", Color3.fromRGB(255, 255, 255), 0.2})
            end)
            TextBoxInput.Focused:Connect(function()
                CreateTween({Pencil, "ImageColor3", Theme["Color Theme"], 0.2})
            end)

            TextBox.OnChanging = false
            function TextBox:Visible(...) Funcs:ToggleVisible(Button, ...) end
            function TextBox:Destroy() Button:Destroy() end
            return TextBox
        end

        function Tab:AddDiscordInvite(Configs)
            local Title = Configs[1] or Configs.Name or Configs.Title or "Discord"
            local Desc = Configs.Desc or Configs.Description or ""
            local Logo = Configs[2] or Configs.Logo or ""
            local Invite = Configs[3] or Configs.Invite or ""

            local InviteHolder = Create("Frame", Container, {
                Size = UDim2.new(1, 0, 0, 80),
                Name = "Option",
                BackgroundTransparency = 1
            })

            local InviteLabel = Create("TextLabel", InviteHolder, {
                Size = UDim2.new(1, 0, 0, 15),
                Position = UDim2.new(0, 5),
                TextColor3 = Color3.fromRGB(176, 96, 244),
                Font = Enum.Font.BuilderSansExtraBold,
                TextXAlignment = "Left",
                BackgroundTransparency = 1,
                TextSize = 10,
                Text = Invite
            })

            local FrameHolder = InsertTheme(Create("Frame", InviteHolder, {
                Size = UDim2.new(1, 0, 0, 65),
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0, 0, 1),
                BackgroundColor3 = Theme["Color Hub 2"]
            }), "Frame")
            Make("Corner", FrameHolder)
            Make("Gradient", FrameHolder)
            AddMarbleOverlay(FrameHolder, UDim.new(0, 6))

            local ImageLabel = Create("ImageLabel", FrameHolder, {
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(0, 7, 0, 7),
                Image = Logo,
                BackgroundTransparency = 1
            })
            Make("Corner", ImageLabel, UDim.new(0, 4))
            Make("Stroke", ImageLabel)

            local LTitle = InsertTheme(Create("TextLabel", FrameHolder, {
                Size = UDim2.new(1, -52, 0, 15),
                Position = UDim2.new(0, 44, 0, 7),
                Font = Enum.Font.BuilderSansExtraBold,
                TextColor3 = Theme["Color Text"],
                TextXAlignment = "Left",
                BackgroundTransparency = 1,
                TextSize = 10,
                Text = Title
            }), "Text")

            local LDesc = InsertTheme(Create("TextLabel", FrameHolder, {
                Size = UDim2.new(1, -52, 0, 0),
                Position = UDim2.new(0, 44, 0, 22),
                TextWrapped = "Y",
                AutomaticSize = "Y",
                Font = Enum.Font.BuilderSansExtraBold,
                TextColor3 = Theme["Color Dark Text"],
                TextXAlignment = "Left",
                BackgroundTransparency = 1,
                TextSize = 8,
                Text = Desc
            }), "DarkText")

            local JoinButton = Create("TextButton", FrameHolder, {
                Size = UDim2.new(1, -14, 0, 16),
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.new(0.5, 0, 1, -7),
                Text = "Join",
                Font = Enum.Font.BuilderSansExtraBold,
                TextSize = 12,
                TextColor3 = Color3.fromRGB(220, 220, 220),
                BackgroundColor3 = Color3.fromRGB(176, 96, 244)
            })
            Make("Corner", JoinButton, UDim.new(0, 5))
            Make("Gradient", JoinButton)
            AddMarbleOverlay(JoinButton, UDim.new(0, 5))

            local ClickDelay
            JoinButton.Activated:Connect(function()
                setclipboard(Invite)
                if ClickDelay then return end
                ClickDelay = true
                SetProps(JoinButton, {
                    Text = "Copied to Clipboard",
                    BackgroundColor3 = Color3.fromRGB(100, 100, 100),
                    TextColor3 = Color3.fromRGB(150, 150, 150)
                })
                task.wait(5)
                SetProps(JoinButton, {
                    Text = "Join",
                    BackgroundColor3 = Color3.fromRGB(176, 96, 244),
                    TextColor3 = Color3.fromRGB(220, 220, 220)
                })
                ClickDelay = false
            end)

            local DiscordInvite = {}
            function DiscordInvite:Destroy() InviteHolder:Destroy() end
            function DiscordInvite:Visible(...) Funcs:ToggleVisible(InviteHolder, ...) end
            return DiscordInvite
        end

        return Tab
    end

    -- Ensure UI starts visible
    minimized = false
    MinimizedFrame.Visible = false
    MainPanel.Frame.Visible = true
    MainPanel.Shadow.Visible = true
    SidePanel.Frame.Visible = true
    SidePanel.Shadow.Visible = true

    return Window
end

return antoralib
