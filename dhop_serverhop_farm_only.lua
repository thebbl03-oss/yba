--[[
    MethionSH — Farm Edition (облегчённая версия)
    Оставлено: UI, AFK-автофарм, авто-продажа, авто-закупка Lucky Arrow,
    быстрый вход в игру, авто-реджойн после кика, серверхоп,
    конвертация конфет (вкладка Halloween Event: авто-сбор конфет,
    авто-сдача Джеку — порог 20, включена по умолчанию;
    кнопка Convert All Candy на вкладке Selling).
    Оптимизировано: поиск цели без sqrt и лишних аллокаций, кэш владельцев
    предметов, noclip без пересканирования, подсчёт конфет/инвентаря
    в один проход, кэш очков Джека.
    Вырезано: ESP, телепорты, троллинг, погода, Auto Prestige, Quest Farm,
    Misc-движение, вкладка Shop, Player Info, скины, низкая графика.
]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local PhysicsService = game:GetService("PhysicsService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local METHIONSH_RAW_URL = "https://raw.githubusercontent.com/thebbl03-oss/yba/refs/heads/main/dhop_serverhop_farm_only.lua"
local MethionSH_Env = type(getgenv) == "function" and getgenv() or _G
local MSH = type(MethionSH_Env.__MethionSHRuntime) == "table" and MethionSH_Env.__MethionSHRuntime or {}
MethionSH_Env.__MethionSHRuntime = MSH
local SH_SCRIPT_JOB_ID = tostring(game.JobId)
if MethionSH_Env.__MethionSHLoadedJobId == SH_SCRIPT_JOB_ID then
    MethionSH_Env.__MethionSHReady = true
    warn("[MethionSH] Already loaded in this server; ignoring duplicate execution.")
    return
end
local SH_AUTOSTART = MethionSH_Env.__MethionSHAutoStart == true
MethionSH_Env.__MethionSHReady = false

local AIRFLOW_LIBRARY_URL = "https://raw.githubusercontent.com/thebbl03-oss/yba/refs/heads/main/graba"
local libraryOk, AirflowLibrary = pcall(function()
    local source = game:HttpGet(AIRFLOW_LIBRARY_URL)
    assert(type(source) == "string" and #source > 0, "The Airflow library returned an empty response")

    if not source:find("function Window:_revealCards", 1, true)
        and not source:find("function Window._revealCards", 1, true) then
        local fallback = [[
if type(Window) == "table" and type(Window._revealCards) ~= "function" then
    function Window:_revealCards(tab, delay)
        if type(tab) ~= "table" or not tab.List then return end
        local list = tab.List
        pcall(function() list.CanvasPosition = Vector2.new(0, 0) end)
        for _, item in ipairs(list:GetChildren()) do
            if item:IsA("GuiObject") then
                item.Visible = true
                local scale = item:FindFirstChildOfClass("UIScale")
                if scale then scale.Scale = 1 end
            end
        end
    end
end
]]
        local patched, count = source:gsub("return%s+Library%s*$", fallback .. "\nreturn Library")
        if count > 0 then source = patched end
    end

    if not source:find("AF_ROBUST_VIEWPORT_PAIRING", 1, true) then
        local pairStart = source:find("local function viewerPair(a, b, list)", 1, true)
        local pairEnd = pairStart and source:find("local function wrapAngle", pairStart, true)
        if pairStart and pairEnd then
            local pairPatch = [[local AF_ROBUST_VIEWPORT_PAIRING = true
local function viewerPair(a, b, list)
    if not a or not b then return end
    if b:IsA("BasePart") then
        pcall(function() b.Anchored = true end)
        if a:IsA("BasePart") then list[#list + 1] = { a, b } end
    end
    local sourceChildren, cloneChildren = a:GetChildren(), b:GetChildren()
    local used = {}
    for _, sourceChild in ipairs(sourceChildren) do
        local matchIndex
        for index, cloneChild in ipairs(cloneChildren) do
            if not used[index] and cloneChild.Parent
                and cloneChild.Name == sourceChild.Name
                and cloneChild.ClassName == sourceChild.ClassName then
                matchIndex = index
                break
            end
        end
        if matchIndex then
            used[matchIndex] = true
            local cloneChild = cloneChildren[matchIndex]
            if VIEWER_STRIP[cloneChild.ClassName] then
                cloneChild:Destroy()
            else
                viewerPair(sourceChild, cloneChild, list)
            end
        end
    end
end
]]
            source = source:sub(1, pairStart - 1) .. pairPatch .. source:sub(pairEnd)
        end
    end

    if not source:find("AF_SAFE_VIEWPORT_BOUNDS", 1, true) then
        local boundsStart, boundsEnd = source:find("local cf, size = model:GetBoundingBox()", 1, true)
        if boundsStart and boundsEnd then
            local boundsPatch = [[local AF_SAFE_VIEWPORT_BOUNDS = true
local cf, size
local boundsOk = pcall(function() cf, size = model:GetBoundingBox() end)
if (not boundsOk or not cf or not size) and src:IsA("Model") then
    pcall(function() cf, size = src:GetBoundingBox() end)
end
if not cf or not size then
    local fallbackPart = list[1] and list[1][2]
    if fallbackPart and fallbackPart.Parent then
        cf, size = fallbackPart.CFrame, fallbackPart.Size
    else
        clone:Destroy()
        setEmpty(true, "Nothing to show")
        return
    end
end
]]
            source = source:sub(1, boundsStart - 1) .. boundsPatch .. source:sub(boundsEnd + 1)
        end
    end

    local toggleMarker = 'cfg, card, st = baseCard(self, cfg, { Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default" }, "TextButton", 56, "Toggle")'
    local toggleStart, toggleEnd = source:find(toggleMarker, 1, true)
    if toggleStart and toggleEnd and not source:find('Text = "LOCKED"', toggleEnd, true) then
        local lockVisual = [[
    if cfg.Locked == true then
        local lockedLabel = mkText {
            AnchorPoint = Vector2.new(1, .5),
            Position = UDim2.new(1, -58, .5, 0),
            Size = UDim2.fromOffset(48, 14),
            Text = "LOCKED",
            TextSize = 9,
            TextColor3 = Theme.Warning,
            TextXAlignment = Enum.TextXAlignment.Center,
            FontFace = Fonts.Bold,
            ZIndex = card.ZIndex + 3,
            Parent = card,
        }
    end
]]
        source = source:sub(1, toggleEnd) .. lockVisual .. source:sub(toggleEnd + 1)
    end
    local setMarker = 'function obj:Set(v, silent)\n\t\tv = v == true'
    local setReplacement = 'function obj:Set(v, silent)\n\t\tif cfg.Locked == true then return end\n\t\tv = v == true'
    local setStart, setEnd = source:find(setMarker, 1, true)
    if setStart and setEnd and not source:find('if cfg.Locked == true then return end', setStart, true) then
        source = source:sub(1, setStart - 1) .. setReplacement .. source:sub(setEnd + 1)
    end

    local initialToggleCallback = 'if obj.Value then fire(cfg.Callback, true) end'
    local guardedInitialCallback = 'if obj.Value and cfg.Locked ~= true then fire(cfg.Callback, true) end'
    local initialStart, initialEnd = source:find(initialToggleCallback, 1, true)
    if initialStart and initialEnd then
        source = source:sub(1, initialStart - 1) .. guardedInitialCallback .. source:sub(initialEnd + 1)
    end

    local chunk, compileError = loadstring(source)
    assert(chunk, compileError or "Could not compile Airflow library")
    return chunk()
end)

if not libraryOk or type(AirflowLibrary) ~= "table" then
    warn("[Methion] Could not load the Airflow library: " .. tostring(AirflowLibrary))
    return
end

pcall(function()
    AirflowLibrary:PreloadIcons()
end)

local AirflowCompat = {}
local CompatWindow = nil

function MSH.adaptTab(rawTab)
    local tab = {}

    function tab:Section(config)
        config = config or {}
        local section = rawTab:Section({
            Name = config.Title or config.Name or "Section",
            Side = config.Side,
            Collapsible = config.Collapsible,
            Collapsed = config.Collapsed,
        })
        return MSH.adaptTab(section)
    end

    local function writeText(target, text, oldText, depth, seen)
        depth = depth or 0
        seen = seen or {}
        if target == nil or depth > 4 then return false end
        local kind = typeof(target)
        if kind == "Instance" then
            if target:IsA("TextLabel") or target:IsA("TextButton") or target:IsA("TextBox") then
                if oldText == nil or target.Text == oldText or target.Text == "" or target.Name == "Label" or target.Name == "Text" then
                    target.Text = text
                    return true
                end
                return false
            end
            if target:IsA("GuiObject") then
                local candidates = {}
                for _, child in ipairs(target:GetDescendants()) do
                    if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                        table.insert(candidates, child)
                    end
                end
                for _, child in ipairs(candidates) do
                    if oldText == nil or child.Text == oldText or child.Text == "" or child.Name == "Label" or child.Name == "Text" then
                        child.Text = text
                        return true
                    end
                end
                if #candidates == 1 then candidates[1].Text = text return true end
            end
            return false
        end
        if type(target) ~= "table" or seen[target] then return false end
        seen[target] = true
        for _, key in ipairs({"Instance", "Label", "TextLabel", "TitleLabel", "Frame", "Main", "Container", "Holder", "Object", "Element", "Raw"}) do
            local ok, child = pcall(function() return target[key] end)
            if ok and child ~= nil and child ~= target then
                if writeText(child, text, oldText, depth + 1, seen) then return true end
            end
        end
        return false
    end

    function tab:Toggle(config)
        config = config or {}
        return rawTab:Toggle({
            Name = config.Title or config.Name or "Toggle",
            Desc = config.Desc or "",
            Default = config.Value == true,
            Flag = config.Flag,
            Locked = config.Locked == true,
            LockedReason = config.LockedReason or "Premium",
            Callback = config.Callback,
        })
    end

    function tab:Dropdown(config)
        config = config or {}
        local element = rawTab:Dropdown({
            Name = config.Title or config.Name or "Dropdown",
            Desc = config.Desc or "",
            Style = "Popup",
            SearchAfter = config.SearchAfter or 8,
            Options = config.Values or config.Options or {},
            Default = config.Value ~= nil and config.Value or config.Default,
            Multi = config.Multi == true,
            Callback = config.Callback,
        })

        local initialValue = config.Value ~= nil and config.Value or config.Default
        local wrapped = {
            Raw = element,
            Instance = nil,
            _displayValue = type(initialValue) == "table" and tostring(initialValue[1] or "") or tostring(initialValue or ""),
        }
        function wrapped:Refresh(options, preserveSelection)
            if self.Raw and type(self.Raw.Refresh) == "function" then
                return self.Raw:Refresh(options, preserveSelection)
            end
        end
        function wrapped:Set(value)
            local raw = self.Raw
            for _, methodName in ipairs({"Set", "SetValue", "SetSelected", "SetSelection", "Select"}) do
                local ok, method = pcall(function()
                    return raw and raw[methodName]
                end)
                if ok and type(method) == "function" then
                    local applied = pcall(function()
                        method(raw, value)
                    end)
                    if applied then
                        self._displayValue = tostring(value or "")
                        return true
                    end
                end
            end
            local previous = self._displayValue
            local applied = pcall(function()
                writeText(raw, tostring(value or ""), previous)
            end)
            self._displayValue = tostring(value or "")
            return applied
        end
        return wrapped
    end

    function tab:Progress(config)
        config = config or {}
        return rawTab:Progress({
            Name = config.Title or config.Name or "Progress",
            Desc = config.Desc or "",
            Default = config.Default or 0,
            Format = config.Format,
        })
    end

    function tab:Slider(config)
        config = config or {}
        local range = config.Value or {}
        return rawTab:Slider({
            Name = config.Title or config.Name or "Slider",
            Desc = config.Desc or "",
            Min = range.Min or config.Min or 0,
            Max = range.Max or config.Max or 100,
            Step = config.Step or 1,
            Default = range.Default or config.Default or range.Min or config.Min or 0,
            Suffix = config.Suffix,
            Callback = config.Callback,
        })
    end

    function tab:ColorPicker(config)
        config = config or {}
        return rawTab:ColorPicker({
            Name = config.Title or config.Name or "Color",
            Desc = config.Desc or "",
            Default = config.Value or config.Default or Color3.new(1, 1, 1),
            Flag = config.Flag,
            Callback = config.Callback,
        })
    end

    function tab:Button(config)
        config = config or {}
        return rawTab:Button({
            Name = config.Title or config.Name or "Button",
            Desc = config.Desc or "",
            Icon = config.Icon,
            Style = config.Style,
            Callback = config.Callback,
        })
    end

    function tab:Input(config)
        config = config or {}
        return rawTab:Input({
            Name = config.Title or config.Name or "Input",
            Desc = config.Desc or "",
            Placeholder = config.Placeholder or "",
            Default = config.Value ~= nil and config.Value or config.Default or "",
            Callback = config.Callback,
        })
    end

    function tab:Paragraph(config)
        config = config or {}
        local title = tostring(config.Title or config.Name or "")
        local desc = tostring(config.Desc or config.Content or "")
        local label = rawTab:Label({
            Text = title ~= "" and (title .. "\n" .. desc) or desc,
        })

        local paragraph = {
            Title = title,
            Desc = desc,
            Label = label,
            _renderedText = title ~= "" and (title .. "\n" .. desc) or desc,
        }
        function paragraph:SetDesc(value)
            self.Desc = tostring(value)
            local text = self.Title ~= "" and (self.Title .. "\n" .. self.Desc) or self.Desc
            local wrote = false
            if self.Label and type(self.Label.Set) == "function" then
                wrote = pcall(function() self.Label:Set(text) end)
            end
            if not wrote then
                pcall(function() writeText(self.Label, text, self._renderedText) end)
            else
                pcall(function() writeText(self.Label, text, self._renderedText) end)
            end
            self._renderedText = text
        end
        function paragraph:Set(value)
            return self:SetDesc(value)
        end
        return paragraph
    end

    function tab:Divider()
        return rawTab:Divider()
    end

    function tab:Header(text)
        return rawTab:Header(text)
    end

    function tab:Label(config)
        return rawTab:Label(config)
    end

    function tab:Viewer(config)
        config = config or {}
        local methodOk, viewerMethod = pcall(function()
            return rawTab.Viewer
        end)
        if not methodOk or type(viewerMethod) ~= "function" then
            warn("[Methion] The loaded Flow library does not expose Tab:Viewer. Update the Flow library before using Player Viewer.")
            return nil
        end

        local created, viewer = pcall(function()
            return rawTab:Viewer(config)
        end)
        if not created then
            warn("[Methion] Could not create Player Viewer: " .. tostring(viewer))
            return nil
        end
        return viewer
    end

    return tab
end

function AirflowCompat:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Methion"
    local rawWindow = AirflowLibrary:CreateWindow({
        Name = config.Name or "Methion",
        Title = title,
        LoadingSubtitle = config.Author or "by Diablo",
        Icon = config.Icon or "rbxthumb://type=Asset&id=76755716686687&w=150&h=150",
        Size = config.Size or UDim2.fromOffset(580, 460),
        MinSize = Vector2.new(560, 380),
        MaxSize = Vector2.new(1100, 800),
        ToggleUIKeybind = "RightControl",
        OpenButton = { Title = title, Icon = config.Icon or "rbxthumb://type=Asset&id=76755716686687&w=150&h=150" },
        KeepOnScreen = true,
        MaxNotifications = 4,
        Loading = {
            Enabled = true,
            Duration = 1.1,
            Title = title,
            Text = "Preparing Methion",
            Steps = { "Loading components", "Building controls", "Ready" },
        },
        ConfigurationSaving = {
            Enabled = false,
            FolderName = "Methion",
            FileName = "Config",
        },
        Parent = game:GetService("CoreGui"),
    })

    local window = { Raw = rawWindow, MainFrame = nil }

    local itemTabs = {}
    local function hiddenControl(config)
        config = config or {}
        local control = {
            Value = config.Value ~= nil and config.Value or config.Default,
            Raw = nil,
            Desc = config.Desc or "",
        }
        control.Raw = control
        function control:Set(value)
            self.Value = value
            return true
        end
        function control:SetDesc(value)
            self.Desc = tostring(value or "")
            return true
        end
        function control:Refresh(...) return true end
        function control:Add(...) return true end
        function control:Remove(...) return true end
        return setmetatable(control, { __index = function()
            return function() return nil end
        end })
    end
    local hiddenTab = {}
    hiddenTab.Raw = hiddenTab
    setmetatable(hiddenTab, { __index = function(_, methodName)
        if methodName == "Section" or methodName == "Divider" or methodName == "Header" then
            return function() return hiddenTab end
        end
        return function(_, config) return hiddenControl(config) end
    end })

    function window:Tab(options)
        options = options or {}
        local requestedName = options.Title or options.Name or "Tab"
        if requestedName ~= "Auto-Farm" and requestedName ~= "Farm Settings"
            and requestedName ~= "Selling" and requestedName ~= "Halloween Event" then
            return hiddenTab
        end
        if not itemTabs[requestedName] then
            local rawTab = self.Raw:Tab({
                Name = requestedName == "Auto-Farm" and "ItemFarmSH"
                    or (requestedName == "Selling" and "ItemSellSH"
                    or (requestedName == "Halloween Event" and "HalloweenEventSH"
                    or "ItemFarmSettingsSH")),
                Icon = options.Icon or (requestedName == "Auto-Farm" and "package-search"
                    or (requestedName == "Selling" and "dollar-sign"
                    or (requestedName == "Halloween Event" and "ghost" or "settings"))),
                Desc = options.Desc or (requestedName == "Auto-Farm"
                    and "AFK item farming with server hopping."
                    or (requestedName == "Selling"
                        and "Auto and manual item selling."
                        or (requestedName == "Halloween Event"
                            and "Collect candy and turn it in to Jack."
                            or "Configure the item farmer and server hopper."))),
            })
            itemTabs[requestedName] = MSH.adaptTab(rawTab)
        end
        return itemTabs[requestedName]
    end

    function window:Notify(options)
        options = options or {}
        return self.Raw:Notify({
            Title = options.Title or "Methion",
            Content = options.Content or options.Desc or "",
            Type = options.Type or "Info",
            Duration = options.Duration or 3,
            Icon = options.Icon,
        })
    end

    function window:Destroy()
        if self.Raw and type(self.Raw.Destroy) == "function" then
            return self.Raw:Destroy()
        end
    end

    function window:Toggle()
        if self.Raw and type(self.Raw.Toggle) == "function" then
            return self.Raw:Toggle()
        end
    end

    CompatWindow = window
    return window
end

function AirflowCompat:Notify(options)
    if CompatWindow then
        return CompatWindow:Notify(options)
    end
end

local LP = Players.LocalPlayer

local RETURNER_KEY = "idklolbrah2de"
local RETURNER_RESPONSE = "  ___XP DE KEY"
local bypassSupported = false

pcall(function()
    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if not checkcaller() and typeof(self) == "Instance" and self.Name == "Returner" and rawequal((...), RETURNER_KEY) then
            return RETURNER_RESPONSE
        end
        return old(self, ...)
    end))
    bypassSupported = true
end)

pcall(function()
    local meta = getrawmetatable(Vector3.new())
    if not meta then return end
    setreadonly(meta, false)
    local old = meta.__index
    meta.__index = newcclosure(function(self, index)
        if not checkcaller() and (index == "magnitude" or index == "Magnitude") then
            local cs = getcallingscript()
            if cs then
                local name = typeof(cs) == "Instance" and (cs.Name or "") or tostring(cs)
                if name == "ItemSpawn" then return 0 end
            end
        end
        return old(self, index)
    end)
    setreadonly(meta, true)
end)

if not bypassSupported then
    local fallbackOk, fallbackErr = pcall(function()
        local fallbackSource = game:HttpGet("https://pastebin.com/raw/c9xy3XzA")
        assert(type(fallbackSource) == "string" and #fallbackSource > 0, "Fallback script returned an empty response")
        local fallbackChunk, compileError = loadstring(fallbackSource)
        assert(type(fallbackChunk) == "function", compileError or "Fallback script could not be compiled")
        fallbackChunk()
    end)

    if not fallbackOk then
        warn("[Methion] Bypass unsupported and fallback script failed: " .. tostring(fallbackErr))
    end
    return
end

local savedFarmTeleportMode = MethionSH_Env.__MethionSHFarmTeleportMode
local initialFarmTeleportMode = (savedFarmTeleportMode == "instant" or savedFarmTeleportMode == "tween") and savedFarmTeleportMode or (bypassSupported and "instant" or "tween")
local savedReloadOnKick = MethionSH_Env.__MethionSHReloadOnKick
local initialReloadOnKick = true
if type(savedReloadOnKick) == "boolean" then initialReloadOnKick = savedReloadOnKick end
local savedFarmOnlyItems = MethionSH_Env.__MethionSHFarmOnlyItems
local savedHopSettings = type(MethionSH_Env.__MethionSHHopSettings) == "table"
    and MethionSH_Env.__MethionSHHopSettings or {}
local hopDefaultsNeedMigration = savedHopSettings.HopIntervalDefaultsV3 ~= true
local savedHopIntervalEnabled = savedHopSettings.HopIntervalEnabled
if type(savedHopIntervalEnabled) ~= "boolean" then savedHopIntervalEnabled = true end
local savedHopOnEmpty = savedHopSettings.HopOnEmpty
local savedHopIntervalUnit = savedHopSettings.HopIntervalUnit
local savedHopIntervalAmount = savedHopSettings.HopIntervalAmount
if hopDefaultsNeedMigration then
    savedHopOnEmpty = false
    savedHopIntervalUnit = "Seconds"
    savedHopIntervalAmount = 35
else
    if type(savedHopOnEmpty) ~= "boolean" then savedHopOnEmpty = false end
    if savedHopIntervalUnit ~= "Seconds" and savedHopIntervalUnit ~= "Minutes" and savedHopIntervalUnit ~= "Hours" then
        savedHopIntervalUnit = "Seconds"
    end
    if tonumber(savedHopIntervalAmount) == nil then savedHopIntervalAmount = 35 end
end
local savedAutoBuyLucky = MethionSH_Env.__MethionSHAutoBuyLucky
if type(savedAutoBuyLucky) ~= "boolean" then savedAutoBuyLucky = false end

local Config = {
    TweenSpeed = 220,
    SafeZone = Vector3.new(-212.241150, -33.486183, -283.842651),
    AutoBuyLucky = savedAutoBuyLucky,
    LuckyArrowPrice = 75000,
    LuckyArrowItem = "1x Lucky Arrow",
    FarmOnlyItems = type(savedFarmOnlyItems) == "table" and savedFarmOnlyItems or {},
    HopIntervalEnabled = savedHopIntervalEnabled,
    HopIntervalUnit = savedHopIntervalUnit,
    HopIntervalAmount = math.clamp(math.floor(tonumber(savedHopIntervalAmount) or 35), 1, 120),
    HopOnEmpty = savedHopOnEmpty,
    StartupGraceSeconds = math.clamp(math.floor(tonumber(savedHopSettings.StartupGraceSeconds) or 30), 10, 90),
    EmptyGraceSeconds = math.clamp(math.floor(tonumber(savedHopSettings.EmptyGraceSeconds) or 15), 5, 90),
    MinServerDwellSeconds = math.clamp(math.floor(tonumber(savedHopSettings.MinServerDwellSeconds) or 15), 10, 60),
    AutoRejoinEnabled = initialReloadOnKick,
    FarmTeleportMode = initialFarmTeleportMode,
    InstantDelay = 0.35,
    Boosted = false,
    NotifyItemSpawn = true,
}

function MSH.persistHopSettings()
    MethionSH_Env.__MethionSHHopSettings = {
        HopIntervalEnabled = Config.HopIntervalEnabled == true,
        HopIntervalUnit = Config.HopIntervalUnit,
        HopIntervalAmount = math.clamp(math.floor(tonumber(Config.HopIntervalAmount) or 35), 1, 120),
        HopOnEmpty = Config.HopOnEmpty == true,
        HopIntervalDefaultsV3 = true,
        StartupGraceSeconds = math.clamp(math.floor(tonumber(Config.StartupGraceSeconds) or 30), 10, 90),
        EmptyGraceSeconds = math.clamp(math.floor(tonumber(Config.EmptyGraceSeconds) or 15), 5, 90),
        MinServerDwellSeconds = math.clamp(math.floor(tonumber(Config.MinServerDwellSeconds) or 15), 10, 60),
    }
end
MSH.persistHopSettings()

local State = {
    Farm = false,
    HalloweenCandyFarm = false,
    HalloweenTurnInBusy = false,
    NoClip = false,
    TweenRunning = false,
    Selling = false,
    NotifyItemSpawn = true,
}

local Tracked = {}
local TrackedRev = {}
local Pending = {}

local FARM_ITEMS = {
    ["Mysterious Arrow"] = Color3.fromRGB(255,185,46),
    ["Rokakaka"] = Color3.fromRGB(204,8,8),
    ["Gold Coin"] = Color3.fromRGB(255,215,71),
    ["Diamond"] = Color3.fromRGB(40,199,201),
    ["Stone Mask"] = Color3.fromRGB(128,128,128),
    ["Quinton's Glove"] = Color3.fromRGB(212,69,30),
    ["Steel Ball"] = Color3.fromRGB(58,189,76),
    ["Dio's Diary"] = Color3.fromRGB(97,49,5),
    ["Pure Rokakaka"] = Color3.fromRGB(255,84,84),
    ["Lucky Arrow"] = Color3.fromRGB(255,0,162),
    ["Lucky Stone Mask"] = Color3.fromRGB(132,0,255),
    ["Rib Cage of The Saint's Corpse"] = Color3.fromRGB(194,194,194),
    ["Ancient Scroll"] = Color3.fromRGB(0,85,255),
    ["Caesar's Headband"] = Color3.fromRGB(200,255,0),
    ["Clackers"] = Color3.fromRGB(0,85,255),
    ["Zeppeli's Hat"] = Color3.fromRGB(173,201,255),
    ["Christmas Present"] = Color3.fromRGB(68,140,0),
    ["Green Candy"] = Color3.fromRGB(0,255,238),
    ["Red Candy"] = Color3.fromRGB(0,255,238),
    ["Blue Candy"] = Color3.fromRGB(0,255,238),
    ["Yellow Candy"] = Color3.fromRGB(0,255,238),
}

local SELLABLE = {
    ["Mysterious Arrow"] = true, ["Rokakaka"] = true, ["Gold Coin"] = true,
    ["Diamond"] = true, ["Stone Mask"] = true, ["Quinton's Glove"] = true,
    ["Steel Ball"] = true, ["Dio's Diary"] = true, ["Pure Rokakaka"] = true,
    ["Rib Cage of The Saint's Corpse"] = true, ["Ancient Scroll"] = true,
    ["Caesar's Headband"] = true, ["Clackers"] = true, ["Zeppeli's Hat"] = true,
}

local Utils = {}

function Utils.basePart(obj)
    if not obj or not obj.Parent then return nil end
    if obj.Parent:IsA("BasePart") then return obj.Parent end
    return obj.Parent:FindFirstChildWhichIsA("BasePart", true)
        or (obj.Parent.Parent and obj.Parent.Parent:FindFirstChildWhichIsA("BasePart", true))
end

function Utils.validPos(part)
    if not part or not part:IsDescendantOf(workspace) then return false end
    local p = part.Position
    return not (math.abs(p.X) < 1 and math.abs(p.Y) < 1 and math.abs(p.Z) < 1)
end

function Utils.invisible(part)
    if not part or not part.Parent then return true end
    if not part:IsDescendantOf(workspace) then return true end
    if part.Transparency >= 1 then return true end
    if part.LocalTransparencyModifier >= 1 then return true end
    return false
end

function Utils.money()
    local ps = LP:FindFirstChild("PlayerStats")
    if not ps then return 0 end
    local m = ps:FindFirstChild("Money")
    if m then return tonumber(m.Value) or 0 end
    return 0
end

local Gui = {}

function Gui.isVisible(guiObject)
    if not guiObject or not guiObject:IsA("GuiObject") or not guiObject.Visible then
        return false
    end
    local current = guiObject.Parent
    while current do
        if current:IsA("GuiObject") and not current.Visible then
            return false
        end
        if current:IsA("ScreenGui") and not current.Enabled then
            return false
        end
        current = current.Parent
    end
    return true
end

function Gui.clickAt(x, y)
    local sent = false
    pcall(function()
        local virtualInput = game:GetService("VirtualInputManager")
        virtualInput:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.005)
        virtualInput:SendMouseButtonEvent(x, y, 0, false, game, 0)
        sent = true
    end)
    if not sent and type(mousemoverel) == "function" and type(mouse1click) == "function" then
        pcall(function()
            local mousePos = UserInputService:GetMouseLocation()
            mousemoverel(x - mousePos.X, y - mousePos.Y)
            task.wait(0.025)
            mouse1click()
            sent = true
        end)
    end
    return sent
end

function Gui.dialogueSignature(gui)
    if not gui or not gui.Parent then return "" end
    local parts = {}
    for _, obj in ipairs(gui:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) and Gui.isVisible(obj) then
            table.insert(parts, obj:GetFullName() .. "=" .. tostring(obj.Text))
        end
    end
    table.sort(parts)
    return table.concat(parts, "\30")
end

function Gui.dialogueText(gui)
    if not gui or not gui.Parent then return "" end
    local parts = {}
    local frame = gui:FindFirstChild("Frame")
    local options = frame and frame:FindFirstChild("Options")
    for _, obj in ipairs(gui:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton"))
            and Gui.isVisible(obj)
            and not (options and obj:IsDescendantOf(options)) then
            local value = tostring(obj.Text or "")
            if value ~= "" then table.insert(parts, value) end
        end
    end
    return table.concat(parts, " ")
end

function Gui.skipClick()
    local camera = workspace.CurrentCamera
    if not camera then return false end
    local viewport = camera.ViewportSize
    return Gui.clickAt(math.max(1, math.floor(viewport.X - 10)), 10)
end

function Gui.click(button)
    if not button or not button.Parent then return false end

    local fired = false
    if type(getconnections) == "function" then
        local ok, connections = pcall(function()
            return getconnections(button.MouseButton1Click)
        end)
        if ok and connections then
            for _, connection in pairs(connections) do
                local success = pcall(function()
                    connection:Fire()
                end)
                if success then fired = true end
            end
        end
    end
    if not fired and type(firesignal) == "function" then
        local ok = pcall(function()
            firesignal(button.MouseButton1Click)
        end)
        fired = ok
    end
    if not fired then
        local ok = pcall(function()
            button:Activate()
        end)
        fired = ok
    end
    if fired then return true end

    local pos = button.AbsolutePosition
    local size = button.AbsoluteSize
    if size.X > 0 and size.Y > 0 then
        return Gui.clickAt(pos.X + size.X / 2, pos.Y + size.Y / 2)
    end
    return false
end

function Gui.dialogueActive(gui)
    if not gui or not gui.Parent then return false end
    if gui:IsA("ScreenGui") and not gui.Enabled then return false end
    if gui:IsA("GuiObject") and not gui.Visible then return false end
    local frame = gui:FindFirstChild("Frame")
    if frame and frame:IsA("GuiObject") and not frame.Visible then return false end
    return true
end

function Gui.currentDialogue()
    local playerGui = LP:FindFirstChildOfClass("PlayerGui") or LP:FindFirstChild("PlayerGui")
    local gui = playerGui and playerGui:FindFirstChild("DialogueGui") or nil
    return Gui.dialogueActive(gui) and gui or nil
end

function Gui.option(gui, name)
    local frame = gui and gui:FindFirstChild("Frame")
    if not frame then return nil end
    local options = frame:FindFirstChild("Options")
    if not options then return nil end

    local option = options:FindFirstChild(name) or options:FindFirstChild(name, true)
    if not option then return nil end
    if option:IsA("GuiButton") then return option end
    return option:FindFirstChildWhichIsA("GuiButton", true)
end

function Gui.hasVisibleOptions(gui)
    local frame = gui and gui:FindFirstChild("Frame")
    local options = frame and frame:FindFirstChild("Options")
    if not options or not Gui.isVisible(options) then return false end

    for _, name in ipairs({"Option1", "Option2", "Option3", "Option4", "Option5", "Option6", "Option7", "Option8"}) do
        local button = Gui.option(gui, name)
        if button and Gui.isVisible(button) then
            return true
        end
    end

    for _, descendant in ipairs(options:GetDescendants()) do
        if descendant:IsA("GuiButton") and Gui.isVisible(descendant) then
            return true
        end
    end
    for _, child in ipairs(options:GetChildren()) do
        if child:IsA("GuiButton") and Gui.isVisible(child) then
            return true
        end
    end
    return false
end

function Gui.waitDialogue(timeout)
    local start = tick()
    while tick() - start < timeout do
        local gui = Gui.currentDialogue()
        if gui and gui.Parent then return gui end
        task.wait()
    end
    return nil
end

function Gui.waitAndClickOption(name, timeout)
    local started = tick()
    local skipInterval = 0.12
    local lastSkip = tick() - skipInterval

    while tick() - started < timeout do
        local gui = Gui.currentDialogue()
        if not gui then
            task.wait()
            gui = Gui.currentDialogue()
            if not gui then
                return false
            end
        end

        local target = Gui.option(gui, name)
        if target and target.Parent and Gui.isVisible(target) then
            if Gui.click(target) then
                return true
            end
        elseif not Gui.hasVisibleOptions(gui) and tick() - lastSkip >= skipInterval then
            if Gui.skipClick() then
                lastSkip = tick()
            end
        end

        task.wait()
    end

    return false
end

function Gui.forceCloseDialogue(timeout)
    local deadline = tick() + (tonumber(timeout) or 3)
    local lastSkip = 0

    while tick() < deadline do
        local gui = Gui.currentDialogue()
        if not gui then return true end

        local clickedClose = false
        for _, descendant in ipairs(gui:GetDescendants()) do
            if descendant:IsA("GuiButton") and Gui.isVisible(descendant) then
                local buttonName = string.lower(tostring(descendant.Name or ""))
                local buttonText = string.lower(tostring(descendant.Text or "")):gsub("%s+", "")
                local isCloseButton = buttonName == "close" or buttonName == "closebutton"
                    or buttonName == "exit" or buttonName == "exitbutton"
                    or buttonName == "x" or buttonName == "xbutton"
                    or buttonName == "skip" or buttonName == "skipbutton"
                    or buttonText == "close" or buttonText == "exit"
                    or buttonText == "x" or buttonText == "×" or buttonText == "skip"
                if isCloseButton and Gui.click(descendant) then
                    clickedClose = true
                    break
                end
            end
        end

        if not clickedClose and tick() - lastSkip >= 0.15 then
            Gui.skipClick()
            lastSkip = tick()
        end
        task.wait(0.05)
    end

    local remaining = Gui.currentDialogue()
    if remaining then
        local frame = remaining:FindFirstChild("Frame")
        if frame and frame:IsA("GuiObject") then
            frame.Visible = false
        elseif remaining:IsA("ScreenGui") then
            remaining.Enabled = false
        end
    end
    return Gui.currentDialogue() == nil
end

local ItemESP = {}

function ItemESP.isPlayerOwned(obj, part)
    local checkObj = obj ~= nil and obj ~= part
    if not part and not checkObj then return false end
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        local backpack = player:FindFirstChild("Backpack")
        if part and part.Parent then
            if character and part:IsDescendantOf(character) then
                return true
            end
            if backpack and part:IsDescendantOf(backpack) then
                return true
            end
        end
        if checkObj and obj.Parent then
            if character and obj:IsDescendantOf(character) then
                return true
            end
            if backpack and obj:IsDescendantOf(backpack) then
                return true
            end
        end
    end
    return false
end

function ItemESP.remove(part)
    if not part then return end
    local hl = part:FindFirstChild("Phantom_ESP")
    if hl then hl:Destroy() end
    local bb = part:FindFirstChild("Phantom_Label")
    if bb then bb:Destroy() end
end

function ItemESP.register(obj)
    if not obj or TrackedRev[obj] then return end
    local name, part
    if obj:IsA("ProximityPrompt") and FARM_ITEMS[obj.ObjectText or ""] then
        name = obj.ObjectText
        part = Utils.basePart(obj)
    elseif obj:IsA("BasePart") and FARM_ITEMS[obj.Name] then
        name = obj.Name
        part = obj
    end
    if not name or not part then return end
    if Tracked[part] then TrackedRev[obj] = part return end
    if not Utils.validPos(part) then
        table.insert(Pending, {obj = obj, part = part, name = name})
        return
    end
    Tracked[part] = {Name = name, Obj = obj}
    TrackedRev[obj] = part
end

function ItemESP.unregister(part)
    if not part then return end
    if Tracked[part] then
        ItemESP.remove(part)
        Tracked[part] = nil
    end

    for object, mappedPart in pairs(TrackedRev) do
        if mappedPart == part then
            TrackedRev[object] = nil
        end
    end

    for index = #Pending, 1, -1 do
        local entry = Pending[index]
        if entry and entry.part == part then
            table.remove(Pending, index)
        end
    end
end

function ItemESP.scan()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("ProximityPrompt") or o:IsA("BasePart") then
            ItemESP.register(o)
        end
    end
end

function ItemESP.count()
    local n = 0
    for part, data in pairs(Tracked) do
        if part and part:IsDescendantOf(workspace) and not Utils.invisible(part)
            and not ItemESP.isPlayerOwned(data and data.Obj, part) then
            n = n + 1
        end
    end
    return n
end

local Selling = {}

local items = {}
local maxLimits = {
    ["Mysterious Arrow"] = 25,
    ["Rokakaka"] = 25,
    ["Gold Coin"] = 45,
    ["Diamond"] = 25,
    ["Pure Rokakaka"] = 999,
    ["Quinton's Glove"] = 10,
    ["Steel Ball"] = 10,
    ["Rib Cage of The Saint's Corpse"] = 10,
    ["Zepellin's Headband"] = 10,
    ["Zeppeli's Hat"] = 10,
    ["Caesar's Headband"] = 10,
    ["Clackers"] = 10,
    ["Stone Mask"] = 10,
    ["Ancient Scroll"] = 10,
    ["Dio's Diary"] = 10,
    ["Lucky Stone Mask"] = 999,
    ["Lucky Arrow"] = 999,
    ["Gold Umbrella"] = 999,
    ["Christmas Present"] = 999,
}

local nonSellable = {
    "Blue Candy", "Red Candy", "Green Candy", "Yellow Candy",
    "Lucky Arrow", "Lucky Stone Mask", "Christmas Present",
}
local nonSellableLookup = {}
for _, name in ipairs(nonSellable) do
    nonSellableLookup[name] = true
end

local itemOptions = {}
local seenOptions = {}
for name in pairs(maxLimits) do
    table.insert(itemOptions, name)
    seenOptions[name] = true
end
for _, name in ipairs(nonSellable) do
    if not seenOptions[name] then
        table.insert(itemOptions, name)
        seenOptions[name] = true
    end
end
table.sort(itemOptions)

local worthlessItems = {
    "Gold Coin", "Diamond", "Quinton's Glove", "Zeppeli's Hat",
    "Caesar's Headband", "Ancient Scroll",
}
local selectedAutoSellItems = {}
local selectedSellAllItems = {}
local autoSellMax = true
local autoSellSelected = false
local autoSellAllSelectedLoop = false
local autoSellInterval = 3
local autoSellLoopToken = 0
local pendingPickupChecks = {}

function MSH.notifySelling(title, content)
    pcall(function()
        AirflowCompat:Notify({
            Title = title or "Selling",
            Content = content or "",
            Type = "Info",
            Duration = 3,
        })
    end)
end

function MSH.countInventoryName(name)
    local count = 0
    local seenTools = {}
    local containers = {}
    if LP.Character then table.insert(containers, LP.Character) end
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then table.insert(containers, backpack) end

    for _, container in ipairs(containers) do
        for _, object in ipairs(container:GetChildren()) do
            if object:IsA("Tool") and object.Name == name and not seenTools[object] then
                seenTools[object] = true
                count += 1
            end
        end
    end
    return count
end

function Selling.updateItems()
    table.clear(items)
    for name in pairs(maxLimits) do
        items[name] = 0
    end
    local character = LP.Character
    local backpack = LP:FindFirstChild("Backpack")
    if character then
        for _, object in ipairs(character:GetChildren()) do
            if object:IsA("Tool") and maxLimits[object.Name] then
                items[object.Name] += 1
            end
        end
    end
    if backpack then
        for _, object in ipairs(backpack:GetChildren()) do
            if object:IsA("Tool") and maxLimits[object.Name] then
                items[object.Name] += 1
            end
        end
    end
    return items
end

function Selling.allowed(name)
    return SELLABLE[name] == true and not nonSellableLookup[name]
end

function Selling.tools()
    local list = {}
    local seenTools = {}
    local containers = {}
    if LP.Character then table.insert(containers, LP.Character) end
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then table.insert(containers, backpack) end

    for _, container in ipairs(containers) do
        for _, object in ipairs(container:GetChildren()) do
            if object:IsA("Tool") and Selling.allowed(object.Name) and not seenTools[object] then
                seenTools[object] = true
                table.insert(list, object)
            end
        end
    end
    return list
end

function Selling.inventoryCount()
    local count = 0
    local seenTools = {}
    local containers = {}
    if LP.Character then table.insert(containers, LP.Character) end
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then table.insert(containers, backpack) end

    for _, container in ipairs(containers) do
        for _, object in ipairs(container:GetChildren()) do
            if object:IsA("Tool") and not seenTools[object] then
                seenTools[object] = true
                count += 1
            end
        end
    end
    return count
end

function Selling.find(name)
    local character = LP.Character
    local tool = character and character:FindFirstChild(name)
    if tool and tool:IsA("Tool") then return tool end
    local backpack = LP:FindFirstChild("Backpack")
    tool = backpack and backpack:FindFirstChild(name)
    if tool and tool:IsA("Tool") then return tool end
    return nil
end

function Selling.equip(tool)
    if not tool or not tool.Parent then return false end
    local character = LP.Character
    if not character then return false end
    if tool.Parent == character then return true end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    local ok = pcall(function()
        humanoid:EquipTool(tool)
    end)
    if not ok then return false end
    task.wait(0.03)
    return tool.Parent == character
end

function Selling.merchantRemote()
    local character = LP.Character
    local remote = character and character:FindFirstChild("RemoteEvent")
    local dialogueFolder = ReplicatedStorage:FindFirstChild("Dialogue")
    local merchant = dialogueFolder and dialogueFolder:FindFirstChild("Merchant")
    if remote and remote:IsA("RemoteEvent") and merchant then
        return remote, merchant
    end
    return nil, nil
end

function Selling.openMerchant()
    local remote, merchant = Selling.merchantRemote()
    if not remote or not merchant then return false end

    if Gui.currentDialogue() then return false end

    local ok = pcall(function()
        remote:FireServer("PromptTriggered", merchant)
    end)
    if not ok then return false end

    local gui = Gui.waitDialogue(3)
    return gui ~= nil and Gui.dialogueActive(gui)
end

function Selling.inInventory(tool)
    if not tool then return false end
    local character = LP.Character
    local backpack = LP:FindFirstChild("Backpack")
    return tool.Parent == character or tool.Parent == backpack
end

function Selling.clickOptionAndWait(optionName, timeout)
    local deadline = tick() + (tonumber(timeout) or 8)
    while tick() < deadline do
        local gui = Gui.currentDialogue()
        if not gui then
            task.wait(0.06)
        else
            local option = Gui.option(gui, optionName)
            if option and option.Parent and Gui.isVisible(option) then
                local before = Gui.dialogueSignature(gui)
                if Gui.click(option) then
                    local transitionDeadline = math.min(deadline, tick() + 1.1)
                    repeat
                        task.wait(0.06)
                        local current = Gui.currentDialogue()
                        if not current then return true end
                        local after = Gui.dialogueSignature(current)
                        local currentOption = Gui.option(current, optionName)
                        if after ~= before or not currentOption or not Gui.isVisible(currentOption) then
                            return true
                        end
                    until tick() >= transitionDeadline
                end
            elseif not Gui.hasVisibleOptions(gui) then
                Gui.skipClick()
                task.wait(0.06)
            else
                task.wait(0.06)
            end
        end
    end
    return false
end

function Selling.sell(toolName, targetTool)
    local tool = targetTool
    if not tool and type(toolName) == "string" then
        tool = Selling.find(toolName)
    end
    if not tool or not tool:IsA("Tool") or not Selling.inInventory(tool) then
        return false
    end
    if not Selling.allowed(tool.Name) then
        return false
    end

    if Gui.currentDialogue() then return false end

    Selling.equip(tool)
    task.wait(0.06)
    if not Selling.inInventory(tool) then return true end
    if Gui.currentDialogue() then return false end

    local ownedDialogue = nil
    local function abortSell()
        local current = Gui.currentDialogue()
        if ownedDialogue and current == ownedDialogue then
            for _ = 1, 3 do
                pcall(Gui.skipClick)
                task.wait(0.1)
                if not Gui.currentDialogue() then break end
            end
        end
        return false
    end

    if not Selling.openMerchant() then return false end
    ownedDialogue = Gui.currentDialogue()
    if not ownedDialogue then return false end
    if not Selling.clickOptionAndWait("Option1", 8) then return abortSell() end
    task.wait(0.12)

    local remote, merchant = Selling.merchantRemote()
    if not remote or not merchant then return abortSell() end
    local opened = pcall(function()
        remote:FireServer("PromptTriggered", merchant)
    end)
    if not opened or not Gui.waitDialogue(5) then return abortSell() end

    if not Selling.clickOptionAndWait("Option1", 8) then return abortSell() end
    task.wait(0.12)
    if not Selling.clickOptionAndWait("Option6", 8) then return abortSell() end

    local confirmUntil = tick() + 4
    while Selling.inInventory(tool) and tick() < confirmUntil do
        task.wait(0.05)
    end
    if Selling.inInventory(tool) then return abortSell() end
    return true
end

function MSH.acquireSellingLock(timeout)
    local started = tick()
    timeout = timeout or 60
    while State.Selling do
        if tick() - started >= timeout then
            return false
        end
        task.wait(0.03)
    end
    State.Selling = true
    return true
end

function MSH.selectTools(predicate)
    local result = {}
    for _, tool in ipairs(Selling.tools()) do
        if not predicate or predicate(tool.Name) then
            table.insert(result, tool)
        end
    end
    return result
end

function MSH.sellMatching(predicate, description, alreadyLocked)
    local ownsLock = not alreadyLocked
    if ownsLock and not MSH.acquireSellingLock(60) then
        MSH.notifySelling("Selling", "Another sell operation is still running.")
        return false
    end

    local sold = 0
    local ok, err = pcall(function()
        local maxPasses = 3
        for _ = 1, maxPasses do
            local current = MSH.selectTools(predicate)
            if #current == 0 then break end

            local soldBeforePass = sold
            for _, tool in ipairs(current) do
                if Selling.inInventory(tool) and Selling.allowed(tool.Name) and (not predicate or predicate(tool.Name)) then
                    local didSell = false
                    for attempt = 1, 2 do
                        if not Selling.inInventory(tool) then
                            didSell = true
                            sold += 1
                            break
                        end
                        local okSell, result = pcall(Selling.sell, tool.Name, tool)
                        if okSell and result then
                            didSell = true
                            sold += 1
                            break
                        end
                        if attempt < 2 then task.wait(0.35) end
                    end
                    if not didSell then task.wait(0.12) end
                end
            end

            if #MSH.selectTools(predicate) == 0 then break end
            if sold == soldBeforePass then break end
        end
    end)

    if ownsLock then State.Selling = false end
    if not ok then
        warn("[Methion] Selling failed: " .. tostring(err))
        MSH.notifySelling("Selling", "Selling stopped because an error occurred.")
        return false
    end

    Selling.updateItems()
    local remaining = #MSH.selectTools(predicate)
    if sold == 0 and remaining == 0 then
        MSH.notifySelling("Selling", "No " .. description .. " found.")
    elseif remaining > 0 then
        MSH.notifySelling("Selling", "Sold " .. sold .. " " .. description .. "; " .. remaining .. " still remain.")
    else
        MSH.notifySelling("Selling", "Sold " .. sold .. " " .. description .. ".")
    end
    return remaining == 0 and sold > 0
end

function Selling.sellAll(alreadyLocked)
    return MSH.sellMatching(nil, "items", alreadyLocked)
end

function Selling.sellAllSelected(selectedItems)
    local wanted = {}
    for _, name in ipairs(selectedItems or {}) do
        if type(name) == "string" then wanted[name] = true end
    end
    if next(wanted) == nil then
        MSH.notifySelling("Selling", "Select at least one item first.")
        return false
    end
    return MSH.sellMatching(function(name) return wanted[name] == true end, "selected items", false)
end

function Selling.sellAllWorthless()
    local wanted = {}
    for _, name in ipairs(worthlessItems) do wanted[name] = true end
    return MSH.sellMatching(function(name) return wanted[name] == true end, "worthless items", false)
end

function Selling.sellInventory()
    return MSH.sellMatching(nil, "items from inventory", false)
end

function Selling.checkAndSellMax()
    if not autoSellMax then return false end
    if not MSH.acquireSellingLock(60) then return false end

    local soldSummary = {}
    local ok, err = pcall(function()
        Selling.updateItems()
        for _, name in ipairs(itemOptions) do
            local limit = maxLimits[name]
            if autoSellMax and limit and Selling.allowed(name) then
                local count = MSH.countInventoryName(name)
                while autoSellMax and count >= limit do
                    local tool = Selling.find(name)
                    if not tool or not Selling.inInventory(tool) then break end
                    local didSell = false
                    for attempt = 1, 2 do
                        if not Selling.inInventory(tool) then
                            didSell = true
                            break
                        end
                        local okSell, result = pcall(Selling.sell, name, tool)
                        if okSell and result then
                            didSell = true
                            break
                        end
                        if attempt < 2 then task.wait(0.35) end
                    end
                    if not didSell then break end
                    soldSummary[name] = (soldSummary[name] or 0) + 1
                    count = MSH.countInventoryName(name)
                    task.wait(0.08)
                end
            end
        end
    end)

    State.Selling = false
    Selling.updateItems()
    if not ok then
        warn("[Methion] Auto-sell-on-max failed: " .. tostring(err))
        return false
    end

    local parts = {}
    local totalSold = 0
    for _, name in ipairs(itemOptions) do
        local amount = soldSummary[name] or 0
        if amount > 0 then
            totalSold += amount
            table.insert(parts, tostring(amount) .. "x " .. name)
        end
    end
    if totalSold > 0 then
        MSH.notifySelling("Auto Sell", "Auto sold: " .. table.concat(parts, ", "))
    end
    return totalSold > 0
end

function MSH.selectedForAutoSell(name)
    for _, selectedName in ipairs(selectedAutoSellItems) do
        if selectedName == name then return true end
    end
    return false
end

_G.__MethionSellingRuntime = _G.__MethionSellingRuntime or {}
local SellRuntime = _G.__MethionSellingRuntime
SellRuntime.MaxSellWorkerRunning = false
SellRuntime.MaxSellCheckQueued = false
SellRuntime.SelectedPickupQueue = {}
SellRuntime.SelectedPickupQueued = setmetatable({}, {__mode = "k"})
SellRuntime.SelectedPickupWorkerRunning = false
SellRuntime.HandledInventoryTools = setmetatable({}, {__mode = "k"})

function Selling.requestAutoSellMaxCheck()
    if not autoSellMax then return end
    SellRuntime.MaxSellCheckQueued = true
    if SellRuntime.MaxSellWorkerRunning then return end

    SellRuntime.MaxSellWorkerRunning = true
    task.spawn(function()
        while autoSellMax and SellRuntime.MaxSellCheckQueued do
            SellRuntime.MaxSellCheckQueued = false
            local ok, err = pcall(Selling.checkAndSellMax)
            if not ok then warn("[Methion] Auto-sell-on-max worker failed: " .. tostring(err)) end
            task.wait(0.15)
        end
        SellRuntime.MaxSellWorkerRunning = false
        if autoSellMax and SellRuntime.MaxSellCheckQueued then
            Selling.requestAutoSellMaxCheck()
        end
    end)
end

function Selling.requestSelectedPickupSell(item)
    if not item or not item:IsA("Tool") or not autoSellSelected
        or not MSH.selectedForAutoSell(item.Name) or not Selling.allowed(item.Name) then
        return
    end
    if SellRuntime.SelectedPickupQueued[item] then return end

    SellRuntime.SelectedPickupQueued[item] = true
    table.insert(SellRuntime.SelectedPickupQueue, item)
    if SellRuntime.SelectedPickupWorkerRunning then return end

    SellRuntime.SelectedPickupWorkerRunning = true
    task.spawn(function()
        while #SellRuntime.SelectedPickupQueue > 0 do
            local tool = table.remove(SellRuntime.SelectedPickupQueue, 1)
            local failedAttempts = 0
            local sold = false
            local missingSince = nil

            while autoSellSelected and tool
                and MSH.selectedForAutoSell(tool.Name) and Selling.allowed(tool.Name) do
                if not tool.Parent or not Selling.inInventory(tool) then
                    missingSince = missingSince or tick()
                    if tick() - missingSince >= 2.5 then break end
                    task.wait(0.1)
                else
                    missingSince = nil
                    if Gui.currentDialogue() then
                        task.wait(0.3)
                    elseif MSH.acquireSellingLock(1) then
                        if Gui.currentDialogue() then
                            State.Selling = false
                            task.wait(0.3)
                        else
                            local okSell, didSell = pcall(Selling.sell, tool.Name, tool)
                            State.Selling = false
                            if okSell and didSell then
                                sold = true
                                MSH.notifySelling("Auto Sell", "Auto sold " .. tool.Name .. " on pickup.")
                                break
                            end

                            failedAttempts = math.min(failedAttempts + 1, 12)
                            local backoff = math.min(4, 0.35 * failedAttempts)
                            task.wait(backoff)
                        end
                    else
                        task.wait(0.2)
                    end
                end
            end

            SellRuntime.SelectedPickupQueued[tool] = nil
            if not sold and tool and tool.Parent and Selling.inInventory(tool)
                and autoSellSelected and MSH.selectedForAutoSell(tool.Name)
                and Selling.allowed(tool.Name) then
                task.wait(0.5)
                if not SellRuntime.SelectedPickupQueued[tool] then
                    SellRuntime.SelectedPickupQueued[tool] = true
                    table.insert(SellRuntime.SelectedPickupQueue, tool)
                end
            end
            task.wait(0.05)
        end
        SellRuntime.SelectedPickupWorkerRunning = false
    end)
end

function MSH.handleInventoryAdded(item)
    if not item or not item:IsA("Tool") or SellRuntime.HandledInventoryTools[item] then return end
    SellRuntime.HandledInventoryTools[item] = true
    pendingPickupChecks[item] = true

    task.spawn(function()
        task.wait(0.2)
        if autoSellMax then Selling.requestAutoSellMaxCheck() end
        if autoSellSelected and MSH.selectedForAutoSell(item.Name) and Selling.allowed(item.Name) then
            Selling.requestSelectedPickupSell(item)
        end
        pendingPickupChecks[item] = nil
    end)
end

local backpack = LP:FindFirstChild("Backpack") or LP:WaitForChild("Backpack", 10)
if backpack then
    backpack.ChildAdded:Connect(MSH.handleInventoryAdded)
end

function MSH.connectCharacterInventory(character)
    if not character then return end
    character.ChildAdded:Connect(MSH.handleInventoryAdded)
end
if LP.Character then MSH.connectCharacterInventory(LP.Character) end
LP.CharacterAdded:Connect(MSH.connectCharacterInventory)

function Selling.hasMaxedItems()
    if not autoSellMax then return false end
    local counts = {}
    local character = LP.Character
    local backpack = LP:FindFirstChild("Backpack")
    local function reachedLimit(container)
        for _, object in ipairs(container:GetChildren()) do
            if object:IsA("Tool") then
                local limit = maxLimits[object.Name]
                if limit and Selling.allowed(object.Name) then
                    local count = (counts[object.Name] or 0) + 1
                    counts[object.Name] = count
                    if count >= limit then return true end
                end
            end
        end
        return false
    end
    if character and reachedLimit(character) then return true end
    if backpack and reachedLimit(backpack) then return true end
    return false
end

task.spawn(function()
    while true do
        task.wait(3)
        if autoSellMax and Selling.hasMaxedItems() then
            Selling.requestAutoSellMaxCheck()
        end
    end
end)

pcall(function()
    local env = type(getgenv) == "function" and getgenv() or _G
    env.MethionSelling = {
        items = items,
        maxLimits = maxLimits,
        nonSellable = nonSellable,
        itemOptions = itemOptions,
        worthlessItems = worthlessItems,
        updateItems = Selling.updateItems,
        sellItem = Selling.sell,
        sellAll = Selling.sellAll,
        sellAllSelected = Selling.sellAllSelected,
        sellAllWorthless = Selling.sellAllWorthless,
        sellInventory = Selling.sellInventory,
        checkAndSellMax = Selling.checkAndSellMax,
    }
end)

local Move = {}

function Move.flyCF(cf, speed, shouldContinue)
    local requestedSpeed = tonumber(speed) or tonumber(Config.TweenSpeed) or 220

    speed = math.clamp(requestedSpeed, 10, 500)

    local targetCFrame = typeof(cf) == "Vector3" and CFrame.new(cf) or cf
    if typeof(targetCFrame) ~= "CFrame" then return false end

    local ch = LP.Character or LP.CharacterAdded:Wait()
    local root = ch and ch:FindFirstChild("HumanoidRootPart")
    if not root then root = ch:WaitForChild("HumanoidRootPart", 5) end
    if not root or not root.Parent then return false end

    local distance = (targetCFrame.Position - root.Position).Magnitude
    if distance <= 0.001 then
        root.CFrame = targetCFrame
        return true
    end

    State.TweenRunning = true
    State.NoClip = true

    local anchor = Instance.new("Part")
    anchor.Name = "MethionAutoFarmTweenAnchor"
    anchor.Anchored = true
    anchor.CanCollide = false
    anchor.CanTouch = false
    anchor.CanQuery = false
    anchor.Transparency = 1
    anchor.Size = Vector3.one
    anchor.CFrame = root.CFrame
    anchor.Parent = workspace

    local duration = distance / speed
    local tween = TweenService:Create(
        anchor,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = targetCFrame}
    )

    local cancelled = false
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if cancelled then return end
        if not anchor.Parent or not root.Parent or LP.Character ~= ch then
            cancelled = true
            pcall(function() tween:Cancel() end)
            return
        end

        root.CFrame = anchor.CFrame
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        if shouldContinue then
            local ok, keepMoving = pcall(shouldContinue)
            if not ok or not keepMoving then
                cancelled = true
                pcall(function() tween:Cancel() end)
            end
        end
    end)

    local playbackState
    local waitOk = pcall(function()
        tween:Play()
        playbackState = tween.Completed:Wait()
    end)

    if connection then
        pcall(function() connection:Disconnect() end)
    end
    pcall(function() tween:Cancel() end)
    if anchor.Parent then pcall(function() anchor:Destroy() end) end

    local completed = waitOk and playbackState == Enum.PlaybackState.Completed and not cancelled
    if completed and root.Parent and LP.Character == ch then
        root.CFrame = targetCFrame
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    State.TweenRunning = false
    State.NoClip = false
    if completed then task.wait(0.05) end
    return completed
end

function Move.flyPart(part)
    if not part or not part.Parent then return false end
    return Move.flyCF(CFrame.new(part.Position))
end

function Move.flySafe()
    return Move.flyCF(CFrame.new(Config.SafeZone))
end

function Move.teleCF(cf)

    if not bypassSupported then
        return Move.flyCF(cf, Config.TweenSpeed)
    end

    local ch = LP.Character or LP.CharacterAdded:Wait()
    local root = ch:WaitForChild("HumanoidRootPart", 5)
    if not root then return false end
    local old = State.NoClip
    State.NoClip = true
    root.CFrame = cf
    root.Velocity = Vector3.new()
    root.RotVelocity = Vector3.new()
    task.wait(.05)
    State.NoClip = old
    return true
end

function Move.telePart(part)
    if not part or not part.Parent or not part:IsDescendantOf(workspace) then return false end
    if not bypassSupported then
        return Move.flyCF(CFrame.new(part.Position + Vector3.new(0, 3, 0)), Config.TweenSpeed)
    end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    root.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    return true
end

function Move.teleSafe()
    return Move.teleCF(CFrame.new(Config.SafeZone))
end

local FarmVisual = {
    OriginalVisuals = setmetatable({}, {__mode = "k"}),
    AnimationMap = setmetatable({}, {__mode = "k"}),
    DecoyUpdateConnection = nil,
    FallbackWalkTrack = nil,
    FallbackWalkAnimation = nil,
    CameraBindBefore = "Phantom_Farm_Decoy_Camera_Before",
    CameraBindAfter = "Phantom_Farm_Decoy_Camera_After",
}

function MSH.hideFarmVisual(instance)
    if not instance or not instance.Parent then return end

    if instance:IsA("BasePart") then
        if FarmVisual.OriginalVisuals[instance] == nil then
            FarmVisual.OriginalVisuals[instance] = {
                Kind = "BasePart",
                LocalTransparencyModifier = instance.LocalTransparencyModifier,
                Transparency = instance.Transparency,
            }
        end
        pcall(function()
            instance.LocalTransparencyModifier = 1
            instance.Transparency = 1
        end)
    elseif instance:IsA("Decal") or instance:IsA("Texture") then
        if FarmVisual.OriginalVisuals[instance] == nil then
            FarmVisual.OriginalVisuals[instance] = {
                Kind = "Texture",
                Transparency = instance.Transparency,
            }
        end
        pcall(function() instance.Transparency = 1 end)
    end
end

function FarmVisual.isActive()
    return FarmVisual.Character == LP.Character
        and FarmVisual.Decoy ~= nil
        and FarmVisual.Decoy.Parent ~= nil
        and FarmVisual.DecoyHumanoid ~= nil
        and FarmVisual.DecoyHumanoid.Parent ~= nil
end

function FarmVisual.cleanup()
    pcall(function()
        RunService:UnbindFromRenderStep(FarmVisual.CameraBindBefore)
        RunService:UnbindFromRenderStep(FarmVisual.CameraBindAfter)
    end)

    if FarmVisual.CharacterConnection then
        pcall(function() FarmVisual.CharacterConnection:Disconnect() end)
        FarmVisual.CharacterConnection = nil
    end
    if FarmVisual.DecoyUpdateConnection then
        pcall(function() FarmVisual.DecoyUpdateConnection:Disconnect() end)
        FarmVisual.DecoyUpdateConnection = nil
    end
    for _, entry in pairs(FarmVisual.AnimationMap or {}) do
        if type(entry) == "table" then
            if entry.Track then
                pcall(function() entry.Track:Stop(0) end)
                pcall(function() entry.Track:Destroy() end)
            end
            if entry.Animation then
                pcall(function() entry.Animation:Destroy() end)
            end
        end
    end
    FarmVisual.AnimationMap = setmetatable({}, {__mode = "k"})
    if FarmVisual.FallbackWalkTrack then
        pcall(function() FarmVisual.FallbackWalkTrack:Stop(0) end)
        pcall(function() FarmVisual.FallbackWalkTrack:Destroy() end)
        FarmVisual.FallbackWalkTrack = nil
    end
    if FarmVisual.FallbackWalkAnimation then
        pcall(function() FarmVisual.FallbackWalkAnimation:Destroy() end)
        FarmVisual.FallbackWalkAnimation = nil
    end

    for instance, saved in pairs(FarmVisual.OriginalVisuals or {}) do
        if instance and instance.Parent and type(saved) == "table" then
            pcall(function()
                if saved.Kind == "BasePart" then
                    instance.LocalTransparencyModifier = saved.LocalTransparencyModifier
                    instance.Transparency = saved.Transparency
                elseif saved.Kind == "Texture" then
                    instance.Transparency = saved.Transparency
                end
            end)
        end
    end
    FarmVisual.OriginalVisuals = setmetatable({}, {__mode = "k"})

    local wasActive = FarmVisual.Decoy ~= nil
    local previousSubject = FarmVisual.PreviousCameraSubject
    local previousCameraType = FarmVisual.PreviousCameraType
    local decoy = FarmVisual.Decoy

    FarmVisual.Character = nil
    FarmVisual.Decoy = nil
    FarmVisual.DecoyHumanoid = nil
    FarmVisual.DecoyRoot = nil
    FarmVisual.PreviousCameraSubject = nil
    FarmVisual.PreviousCameraType = nil

    if decoy then
        pcall(function() decoy:Destroy() end)
    end

    if wasActive then
        local camera = workspace.CurrentCamera
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if camera then
            pcall(function()
                camera.CameraType = previousCameraType or Enum.CameraType.Custom
                local subject = humanoid or previousSubject
                if subject and subject.Parent then
                    camera.CameraSubject = subject
                end
            end)
        end
    end
end

function FarmVisual.showSafeZoneDecoy()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not root or not humanoid then return false end
    if FarmVisual.isActive() then return true end

    FarmVisual.cleanup()

    local wasArchivable = character.Archivable
    local ok, decoy
    pcall(function() character.Archivable = true end)
    ok, decoy = pcall(function() return character:Clone() end)
    pcall(function() character.Archivable = wasArchivable end)
    if not ok or not decoy or not decoy:IsA("Model") then
        return false
    end

    decoy.Name = "Phantom_FarmSafeZoneDecoy"
    local decoyRoot = decoy:FindFirstChild("HumanoidRootPart")
    local decoyHumanoid = decoy:FindFirstChildOfClass("Humanoid")
    if not decoyRoot or not decoyHumanoid then
        pcall(function() decoy:Destroy() end)
        return false
    end

    for _, descendant in ipairs(decoy:GetDescendants()) do
        if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript")
            or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("ParticleEmitter")
            or descendant:IsA("Fire") or descendant:IsA("Smoke") or descendant:IsA("Sparkles") then
            pcall(function() descendant:Destroy() end)
        elseif descendant:IsA("BasePart") then
            pcall(function()
                descendant.LocalTransparencyModifier = 0

                descendant.Anchored = descendant == decoyRoot
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.CanQuery = false
                descendant.Massless = descendant ~= decoyRoot
            end)
        end
    end

    pcall(function()
        decoyHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        decoyHumanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        decoyHumanoid.BreakJointsOnDeath = false
        decoyHumanoid.AutoRotate = false
        decoyHumanoid.PlatformStand = false
        decoyHumanoid.Sit = false
        decoyHumanoid.WalkSpeed = humanoid.WalkSpeed
        decoyHumanoid.JumpPower = humanoid.JumpPower
        decoyHumanoid.UseJumpPower = humanoid.UseJumpPower
    end)

    local safeRootCFrame = CFrame.new(Config.SafeZone) * root.CFrame.Rotation
    local pivotOffset = root.CFrame:ToObjectSpace(character:GetPivot())
    decoy.Parent = workspace
    decoy:PivotTo(safeRootCFrame * pivotOffset)

    FarmVisual.Character = character
    FarmVisual.Decoy = decoy
    FarmVisual.DecoyHumanoid = decoyHumanoid
    FarmVisual.DecoyRoot = decoyRoot
    FarmVisual.AnimationMap = setmetatable({}, {__mode = "k"})
    FarmVisual.OriginalVisuals = setmetatable({}, {__mode = "k"})

    local decoyAnimator = decoyHumanoid:FindFirstChildOfClass("Animator")
    if not decoyAnimator then
        decoyAnimator = Instance.new("Animator")
        decoyAnimator.Parent = decoyHumanoid
    end

    local function findWalkAnimationId()
        local animateScript = character:FindFirstChild("Animate")
        if not animateScript then return nil end
        local fallbackRun
        for _, animationObject in ipairs(animateScript:GetDescendants()) do
            if animationObject:IsA("Animation") and animationObject.AnimationId ~= "" then
                local name = string.lower(animationObject.Name or "")
                if name == "walkanim" or name == "walk" or name:find("walk", 1, true) then
                    return animationObject.AnimationId
                elseif (name == "runanim" or name == "run" or name:find("run", 1, true)) and not fallbackRun then
                    fallbackRun = animationObject.AnimationId
                end
            end
        end
        return fallbackRun
    end

    local fallbackWalkId = findWalkAnimationId()
    if fallbackWalkId then
        local fallbackAnimation = Instance.new("Animation")
        fallbackAnimation.Name = "Phantom_FallbackWalkAnimation"
        fallbackAnimation.AnimationId = fallbackWalkId
        local fallbackTrack
        local fallbackLoaded = pcall(function()
            fallbackTrack = decoyAnimator:LoadAnimation(fallbackAnimation)
        end)
        if fallbackLoaded and fallbackTrack then
            pcall(function()
                fallbackTrack.Priority = Enum.AnimationPriority.Movement
                fallbackTrack.Looped = true
            end)
            FarmVisual.FallbackWalkAnimation = fallbackAnimation
            FarmVisual.FallbackWalkTrack = fallbackTrack
        else
            pcall(function() fallbackAnimation:Destroy() end)
        end
    end

    local nextAnimationSync = 0
    local function syncCurrentAnimations()
        local sourceAnimator = humanoid.Parent and humanoid:FindFirstChildOfClass("Animator")
        local visualAnimator = decoyHumanoid.Parent and decoyHumanoid:FindFirstChildOfClass("Animator")
        if not sourceAnimator or not visualAnimator then return end

        local playing = {}
        local hasMovementAnimation = false
        for _, sourceTrack in ipairs(sourceAnimator:GetPlayingAnimationTracks()) do
            if sourceTrack and sourceTrack.IsPlaying then
                if sourceTrack.Priority == Enum.AnimationPriority.Movement then
                    hasMovementAnimation = true
                end
                local sourceAnimation = sourceTrack.Animation
                local animationId = sourceAnimation and sourceAnimation.AnimationId or ""
                if animationId ~= "" then
                    playing[sourceTrack] = true
                    local entry = FarmVisual.AnimationMap[sourceTrack]
                    if not entry or entry.AnimationId ~= animationId then
                        if entry then
                            if entry.Track then
                                pcall(function() entry.Track:Stop(0) end)
                                pcall(function() entry.Track:Destroy() end)
                            end
                            if entry.Animation then
                                pcall(function() entry.Animation:Destroy() end)
                            end
                        end

                        local copiedAnimation = Instance.new("Animation")
                        copiedAnimation.Name = "Phantom_MirroredAnimation"
                        copiedAnimation.AnimationId = animationId
                        local copiedTrack
                        local loaded = pcall(function()
                            copiedTrack = visualAnimator:LoadAnimation(copiedAnimation)
                        end)
                        if loaded and copiedTrack then
                            pcall(function()
                                copiedTrack.Priority = sourceTrack.Priority
                                copiedTrack.Looped = sourceTrack.Looped
                                copiedTrack:Play(0.05, sourceTrack.WeightCurrent, sourceTrack.Speed)
                                copiedTrack.TimePosition = sourceTrack.TimePosition
                            end)
                            entry = {
                                Track = copiedTrack,
                                Animation = copiedAnimation,
                                AnimationId = animationId,
                                LastSync = 0,
                            }
                            FarmVisual.AnimationMap[sourceTrack] = entry
                        else
                            pcall(function() copiedAnimation:Destroy() end)
                            FarmVisual.AnimationMap[sourceTrack] = nil
                            entry = nil
                        end
                    end

                    if entry and entry.Track then
                        pcall(function()
                            local targetTrack = entry.Track
                            local speed = tonumber(sourceTrack.Speed) or 1
                            if targetTrack.Priority ~= sourceTrack.Priority then
                                targetTrack.Priority = sourceTrack.Priority
                            end
                            if targetTrack.Looped ~= sourceTrack.Looped then
                                targetTrack.Looped = sourceTrack.Looped
                            end
                            if not targetTrack.IsPlaying then
                                targetTrack:Play(0.05, sourceTrack.WeightCurrent, speed)
                            end
                            targetTrack:AdjustSpeed(speed)
                            if math.abs(targetTrack.TimePosition - sourceTrack.TimePosition) > 0.14 then
                                targetTrack.TimePosition = sourceTrack.TimePosition
                            end
                            local targetWeight = tonumber(sourceTrack.WeightTarget) or 1
                            if math.abs(targetTrack.WeightTarget - targetWeight) > 0.05 then
                                targetTrack:AdjustWeight(targetWeight, 0.06)
                            end
                        end)
                    end
                end
            end
        end

        for sourceTrack, entry in pairs(FarmVisual.AnimationMap) do
            if not playing[sourceTrack] then
                if entry.Track then
                    pcall(function() entry.Track:Stop(0.08) end)
                    pcall(function() entry.Track:Destroy() end)
                end
                if entry.Animation then
                    pcall(function() entry.Animation:Destroy() end)
                end
                FarmVisual.AnimationMap[sourceTrack] = nil
            end
        end

        local movement = humanoid.MoveDirection
        local isMoving = Vector3.new(movement.X, 0, movement.Z).Magnitude > 0.04
        local fallbackTrack = FarmVisual.FallbackWalkTrack
        if fallbackTrack then
            if isMoving and not hasMovementAnimation then
                if not fallbackTrack.IsPlaying then
                    pcall(function() fallbackTrack:Play(0.08, 1, 1) end)
                end
                pcall(function()
                    fallbackTrack:AdjustSpeed(math.clamp((tonumber(humanoid.WalkSpeed) or 16) / 16, 0.5, 2.5))
                end)
            elseif fallbackTrack.IsPlaying then
                pcall(function() fallbackTrack:Stop(0.08) end)
            end
        end
    end

    FarmVisual.DecoyUpdateConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if FarmVisual.Decoy ~= decoy or not decoy.Parent
            or FarmVisual.Character ~= character or LP.Character ~= character
            or not decoyRoot.Parent or not humanoid.Parent then
            return
        end

        local movement = humanoid.MoveDirection
        local horizontal = Vector3.new(movement.X, 0, movement.Z)
        if horizontal.Magnitude > 0.04 then
            local direction = horizontal.Unit
            local currentPivot = decoy:GetPivot()
            local speed = math.clamp(tonumber(humanoid.WalkSpeed) or 16, 0, 80)
            local step = math.min(math.max(tonumber(deltaTime) or 0, 0), 0.05)
            local nextPosition = currentPivot.Position + direction * speed * step
            local nextPivot = CFrame.lookAt(nextPosition, nextPosition + direction)
            pcall(function() decoy:PivotTo(nextPivot) end)
        end

        local now = os.clock()
        if now >= nextAnimationSync then
            nextAnimationSync = now + 0.05
            pcall(syncCurrentAnimations)
        end
    end)

    for _, descendant in ipairs(character:GetDescendants()) do
        MSH.hideFarmVisual(descendant)
    end

    FarmVisual.CharacterConnection = character.DescendantAdded:Connect(function(descendant)
        if FarmVisual.Character == character and FarmVisual.Decoy == decoy then
            MSH.hideFarmVisual(descendant)
        end
    end)

    local camera = workspace.CurrentCamera
    if camera then
        FarmVisual.PreviousCameraSubject = camera.CameraSubject
        FarmVisual.PreviousCameraType = camera.CameraType
        pcall(function()
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = decoyHumanoid
        end)
    end

    local function maintainDecoyCamera()
        if FarmVisual.Decoy ~= decoy or not decoy.Parent or not decoyHumanoid.Parent then
            return
        end

        for instance, saved in pairs(FarmVisual.OriginalVisuals or {}) do
            if instance and instance.Parent and type(saved) == "table" then
                pcall(function()
                    if saved.Kind == "BasePart" then
                        if instance.LocalTransparencyModifier ~= 1 then
                            instance.LocalTransparencyModifier = 1
                        end
                        if instance.Transparency ~= 1 then
                            instance.Transparency = 1
                        end
                    elseif saved.Kind == "Texture" and instance.Transparency ~= 1 then
                        instance.Transparency = 1
                    end
                end)
            end
        end

        local currentCamera = workspace.CurrentCamera
        if currentCamera then
            pcall(function()
                if currentCamera.CameraType ~= Enum.CameraType.Custom then
                    currentCamera.CameraType = Enum.CameraType.Custom
                end
                if currentCamera.CameraSubject ~= decoyHumanoid then
                    currentCamera.CameraSubject = decoyHumanoid
                end
            end)
        end
    end

    pcall(function()
        RunService:BindToRenderStep(
            FarmVisual.CameraBindBefore,
            Enum.RenderPriority.Camera.Value - 1,
            maintainDecoyCamera
        )
        RunService:BindToRenderStep(
            FarmVisual.CameraBindAfter,
            Enum.RenderPriority.Camera.Value + 1,
            maintainDecoyCamera
        )
        maintainDecoyCamera()
    end)

    return true
end

function FarmVisual.restoreAtSafe()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root and (root.Position - Config.SafeZone).Magnitude > 6 then
        Move.teleSafe()
    end
    FarmVisual.cleanup()
    return root ~= nil
end

local Farm = {}

function Farm.isActive()
    return (State.Farm == true or State.HalloweenCandyFarm == true)
        and State.HalloweenTurnInBusy ~= true
        and _G.__MethionSHPreloading ~= true
end

Farm.PendingBoostedTarget = nil
Farm.PendingBoostedTargets = {}
Farm.BoostedTargetQueued = setmetatable({}, {__mode = "k"})
Farm.BoostedTargetSeen = setmetatable({}, {__mode = "k"})
Farm.BoostedTargetQueueLifetime = 12

function MSH.refreshPendingBoostedTarget()
    Farm.PendingBoostedTarget = nil
    for index = #Farm.PendingBoostedTargets, 1, -1 do
        local entry = Farm.PendingBoostedTargets[index]
        if entry and entry.Part and entry.Part.Parent then
            Farm.PendingBoostedTarget = entry.Part
            break
        end
    end
end

function Farm.queueBoostedTarget(part)
    if not part or not part.Parent or not part:IsDescendantOf(workspace)
        or ItemESP.isPlayerOwned(nil, part) then
        return false
    end
    if Farm.BoostedTargetQueued[part] or Farm.BoostedTargetSeen[part] then
        return false
    end

    Farm.BoostedTargetQueued[part] = true
    Farm.BoostedTargetSeen[part] = true
    table.insert(Farm.PendingBoostedTargets, {
        Part = part,
        AddedAt = os.clock(),
    })
    Farm.PendingBoostedTarget = part
    return true
end

function Farm.nextReadyBoostedTarget(exceptPart, now, consume)
    now = now or tick()
    local queue = Farm.PendingBoostedTargets
    local currentClock = os.clock()

    for index = #queue, 1, -1 do
        local entry = queue[index]
        local part = entry and entry.Part
        local data = part and Tracked[part]
        local expired = not entry or currentClock - (entry.AddedAt or currentClock) > Farm.BoostedTargetQueueLifetime
        local playerOwned = part and ItemESP.isPlayerOwned(nil, part)
        local disallowed = data and not Farm.allowed(data.Name)
        if not part or not part.Parent or not part:IsDescendantOf(workspace)
            or expired or disallowed or playerOwned then
            if part then Farm.BoostedTargetQueued[part] = nil end
            table.remove(queue, index)
        end
    end

    for index, entry in ipairs(queue) do
        local part = entry and entry.Part
        local data = part and Tracked[part]
        if part and part ~= exceptPart and data
            and Farm.allowed(data.Name)
            and not ItemESP.isPlayerOwned(nil, part)
            and Utils.validPos(part) and not Utils.invisible(part)
            and (not data.FarmRetryAt or data.FarmRetryAt <= now) then
            if consume then
                Farm.BoostedTargetQueued[part] = nil
                table.remove(queue, index)
                MSH.refreshPendingBoostedTarget()
            end
            return part, data
        end
    end

    MSH.refreshPendingBoostedTarget()
    return nil
end

function Farm.allowed(name)
    if State.HalloweenCandyFarm then
        return name == "Green Candy" or name == "Red Candy"
            or name == "Blue Candy" or name == "Yellow Candy"
    end

    local filter = Config.FarmOnlyItems
    if not filter or #filter == 0 then return true end
    for _, n in ipairs(filter) do
        if n == "All items" or n == name then return true end
    end
    return false
end

local FARM_PRIORITY_SET = {
    ["Lucky Arrow"] = true,
    ["Lucky Stone Mask"] = true,
    ["Christmas Present"] = true,
}

function Farm.nearest()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local now = tick()
    local nearest, nearestPart, nearestData, nearestDist = nil, nil, nil, math.huge
    local priorityItem, priorityPart, priorityData, priorityDist = nil, nil, nil, math.huge
    local origin = root.Position

    if State.Farm and Config.Boosted then
        local pending, data = Farm.nextReadyBoostedTarget(nil, now, true)
        if pending and data then
            local candidate = pending:FindFirstAncestorOfClass("Model") or pending
            if _G.__PhantomQuestFarmSetItemViewerTarget then
                pcall(_G.__PhantomQuestFarmSetItemViewerTarget, candidate)
            end
            return candidate, pending, data
        end
    end

    for part, data in pairs(Tracked) do
        if part and part:IsDescendantOf(workspace)
            and Farm.allowed(data.Name)
            and (not data.FarmRetryAt or data.FarmRetryAt <= now)
            and data.PlayerOwned ~= true
            and Utils.validPos(part)
            and not Utils.invisible(part)
            and not ItemESP.isPlayerOwned(data.Obj, part) then
            local delta = part.Position - origin
            local distSq = delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z

            if distSq < nearestDist then
                nearestDist = distSq
                nearest = part:FindFirstAncestorOfClass("Model") or part
                nearestPart = part
                nearestData = data
            end

            if FARM_PRIORITY_SET[data.Name] and distSq < priorityDist then
                priorityDist = distSq
                priorityItem = part:FindFirstAncestorOfClass("Model") or part
                priorityPart = part
                priorityData = data
            end
        end
    end

    local chosenItem = priorityItem or nearest
    local chosenPart = priorityPart or nearestPart
    local chosenData = priorityData or nearestData
    if chosenItem and _G.__PhantomQuestFarmSetItemViewerTarget then
        pcall(_G.__PhantomQuestFarmSetItemViewerTarget, chosenItem)
    end

    return chosenItem, chosenPart, chosenData
end

function Farm.waitForArrival(part, timeout)
    timeout = math.clamp(tonumber(timeout) or 2.5, 1.0, 4.0)
    local started = os.clock()
    local expectedCharacter = LP.Character
    local previousPosition = nil
    local stableFrames = 0
    local settleTime = math.clamp(tonumber(Config.InstantDelay) or 0.35, 0.2, 1.0)

    while Farm.isActive() and part and part.Parent and part:IsDescendantOf(workspace)
        and os.clock() - started < timeout do
        local character = LP.Character
        if not character or character ~= expectedCharacter then return false end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return false end

        local targetPosition = part.Position + Vector3.new(0, 3, 0)
        if (root.Position - targetPosition).Magnitude > 0.1 then
            root.CFrame = CFrame.new(targetPosition)
        end
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        local currentPosition = root.Position
        local moved = previousPosition and (currentPosition - previousPosition).Magnitude or 0
        if (currentPosition - targetPosition).Magnitude <= 0.15 and moved <= 0.35 then
            stableFrames += 1
        else
            stableFrames = 0
        end
        previousPosition = currentPosition

        if stableFrames >= 5 then
            local settleUntil = os.clock() + settleTime
            while Farm.isActive() and part and part.Parent and part:IsDescendantOf(workspace)
                and os.clock() < settleUntil do
                character = LP.Character
                if not character or character ~= expectedCharacter then return false end
                root = character:FindFirstChild("HumanoidRootPart")
                if not root then return false end

                targetPosition = part.Position + Vector3.new(0, 3, 0)
                if (root.Position - targetPosition).Magnitude > 0.1 then
                    root.CFrame = CFrame.new(targetPosition)
                end
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                RunService.Heartbeat:Wait()
            end

            if not Farm.isActive() or not part or not part.Parent or not part:IsDescendantOf(workspace) then
                return false
            end
            character = LP.Character
            root = character and character:FindFirstChild("HumanoidRootPart")
            if not root then return false end
            targetPosition = part.Position + Vector3.new(0, 3, 0)
            if (root.Position - targetPosition).Magnitude > 0.1 then
                root.CFrame = CFrame.new(targetPosition)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                RunService.Heartbeat:Wait()
            end

            return Farm.isActive()
                and LP.Character == expectedCharacter
                and part.Parent ~= nil
                and part:IsDescendantOf(workspace)
                and (root.Position - (part.Position + Vector3.new(0, 3, 0))).Magnitude <= 0.5
                and (part.Position - root.Position).Magnitude <= 4.0
        end

        RunService.Heartbeat:Wait()
    end

    return false
end
function Farm.triggerPickupPrompt(prompt)
    if not prompt or not prompt.Parent or not prompt:IsA("ProximityPrompt") or prompt.Enabled == false then
        return false
    end

    local oldHoldDuration
    pcall(function()
        oldHoldDuration = prompt.HoldDuration
        prompt.HoldDuration = 0
    end)

    local function restoreHoldDuration()
        if oldHoldDuration ~= nil and prompt.Parent then
            pcall(function() prompt.HoldDuration = oldHoldDuration end)
        end
    end

    if bypassSupported and type(fireproximityprompt) == "function" then
        local ok = pcall(function()
            fireproximityprompt(prompt, 0, true)
        end)
        if not ok then
            ok = pcall(function() fireproximityprompt(prompt) end)
        end
        restoreHoldDuration()
        if ok then return true end
    end

    local fired = false
    if type(getconnections) == "function" then
        local connectionsOk, connections = pcall(function()
            return getconnections(prompt.Triggered)
        end)
        if connectionsOk and connections then
            for _, connection in pairs(connections) do
                if connection and type(connection.Fire) == "function" then
                    local connectionFired = pcall(function()
                        connection:Fire(prompt)
                    end)
                    if connectionFired then fired = true end
                end
            end
        end
    end

    if not fired and prompt.Parent then
        local inputOk = pcall(function()
            prompt:InputHoldBegin()
            task.wait(0.1)
            prompt:InputHoldEnd()
        end)
        if inputOk then fired = true end
    end

    restoreHoldDuration()
    return fired
end

function Farm.pickup(model, part)
    if not model or not model.Parent then return false end
    if not part or not part.Parent or Utils.invisible(part) then return false end
    local prompt = model:FindFirstChild("ProximityPrompt") or part:FindFirstChild("ProximityPrompt")
    if not prompt then
        prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
            or part:FindFirstChildWhichIsA("ProximityPrompt", true)
    end
    if not prompt or prompt.Enabled == false then return false end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    if (part.Position - root.Position).Magnitude > 4.25 then return false end
    return Farm.triggerPickupPrompt(prompt)
end

function Farm.pickupBoosted(model, part, trackedData)
    if not State.Farm or not Config.Boosted or not model or not model.Parent
        or not part or not part.Parent or not part:IsDescendantOf(workspace) then
        return false
    end

    local expectedCharacter = LP.Character
    if not expectedCharacter then return false end

    local startedAt = os.clock()
    local lastPromptAt = 0
    local lastSuccessfulTriggerAt = nil
    local nextPromptAt = 0
    local stableFrames = 0
    local previousAnchors = nil
    local promptInFlight = false
    local invisibleSince = nil

    local R6_BODY_PARTS = {
        "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg",
    }
    local R15_BODY_PARTS = {
        "Head", "UpperTorso", "LowerTorso",
        "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand",
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
        "RightUpperLeg", "RightLowerLeg", "RightFoot",
    }

    local function itemRemoved()
        return not part or not part.Parent or not part:IsDescendantOf(workspace)
            or (model ~= part and model and not model.Parent)
    end

    local function characterSnapshot()
        local character = LP.Character
        if not character or character ~= expectedCharacter
            or not character.Parent or not character:IsDescendantOf(workspace) then
            return nil
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or humanoid.Health <= 0
            or not root or not root:IsA("BasePart")
            or not root:IsDescendantOf(character) then
            return nil
        end

        local requiredNames = humanoid.RigType == Enum.HumanoidRigType.R6
            and R6_BODY_PARTS or R15_BODY_PARTS
        local bodyParts = {}
        for _, name in ipairs(requiredNames) do
            local bodyPart = character:FindFirstChild(name)
            if not bodyPart or not bodyPart:IsA("BasePart")
                or not bodyPart:IsDescendantOf(character) then
                return nil
            end
            bodyParts[#bodyParts + 1] = bodyPart
        end

        local head = character:FindFirstChild("Head")
        local torsoName = humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso"
        local torso = character:FindFirstChild(torsoName)
        if not head or not head:IsA("BasePart") or not torso or not torso:IsA("BasePart") then
            return nil
        end

        return character, humanoid, root, head, torso, bodyParts
    end

    local function findPrompt()
        local saved = trackedData and trackedData.Obj
        if saved and saved.Parent and saved:IsA("ProximityPrompt")
            and saved:IsDescendantOf(workspace) then
            return saved
        end

        for _, object in ipairs({model, part}) do
            if object and object.Parent then
                if object:IsA("ProximityPrompt") then return object end
                local prompt = object:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then return prompt end
            end
        end

        local ancestor = part:FindFirstAncestorOfClass("Model")
        return ancestor and ancestor:FindFirstChildWhichIsA("ProximityPrompt", true) or nil
    end

    local function promptAnchor(prompt)
        if prompt and prompt.Parent then
            if prompt.Parent:IsA("BasePart") then
                return prompt.Parent
            end
            local ancestorPart = prompt:FindFirstAncestorWhichIsA("BasePart")
            if ancestorPart then return ancestorPart end
            local childPart = prompt.Parent:FindFirstChildWhichIsA("BasePart", true)
            if childPart then return childPart end
        end
        return part
    end

    local function verifyCharacterAtItem(anchor)
        local character, humanoid, root, head, torso, bodyParts = characterSnapshot()
        if not character then return false end
        if not anchor or not anchor.Parent or not anchor:IsDescendantOf(workspace) then
            return false
        end

        local targetPosition = anchor.Position + Vector3.new(0, 3, 0)
        if (root.Position - targetPosition).Magnitude > 0.25
            or (anchor.Position - root.Position).Magnitude > 4.25 then
            return false
        end

        if (head.Position - root.Position).Magnitude > 8
            or (torso.Position - root.Position).Magnitude > 8 then
            return false
        end
        for _, bodyPart in ipairs(bodyParts) do
            if not bodyPart.Parent or not bodyPart:IsDescendantOf(character)
                or (bodyPart.Position - root.Position).Magnitude > 9 then
                return false
            end
        end

        return true, character, humanoid, root, head, torso, bodyParts
    end

    local function anchorsAreStable(root, head, torso)
        local current = {root.Position, head.Position, torso.Position}
        local stable = previousAnchors ~= nil
        if previousAnchors then
            for index, position in ipairs(current) do
                if (position - previousAnchors[index]).Magnitude > 0.6 then
                    stable = false
                    break
                end
            end
        end
        previousAnchors = current
        return stable
    end

    local firstPrompt = findPrompt()
    local firstAnchor = promptAnchor(firstPrompt)
    if firstAnchor and firstAnchor.Parent then
        Move.telePart(firstAnchor)
    else
        Move.telePart(part)
    end

    while State.Farm and Config.Boosted and LP.Character == expectedCharacter
        and os.clock() - startedAt < 4.0 do
        if itemRemoved() then
            ItemESP.unregister(part)
            return true
        end

        local pendingSpawn = Farm.nextReadyBoostedTarget(part, tick(), false)
        if pendingSpawn then
            if trackedData then trackedData.FarmRetryAt = tick() end
            return false
        end

        local visibleAndPositioned = Utils.validPos(part) and not Utils.invisible(part)
        if not visibleAndPositioned then
            stableFrames = 0
            previousAnchors = nil
            local nowInvisible = os.clock()
            invisibleSince = invisibleSince or nowInvisible

            if lastSuccessfulTriggerAt and nowInvisible - lastSuccessfulTriggerAt >= 0.15
                and nowInvisible - invisibleSince >= 0.12 then
                ItemESP.unregister(part)
                return true
            end
            RunService.Heartbeat:Wait()
        else
            invisibleSince = nil
            local prompt = findPrompt()
            local anchor = promptAnchor(prompt)
            local character, humanoid, root, head, torso = characterSnapshot()

            if character and humanoid and root and head and torso and anchor and anchor.Parent then
                local targetPosition = anchor.Position + Vector3.new(0, 3, 0)
                if (root.Position - targetPosition).Magnitude > 0.04 then
                    root.CFrame = CFrame.new(targetPosition)
                end
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero

                local verified, verifiedCharacter, verifiedHumanoid,
                    verifiedRoot, verifiedHead, verifiedTorso = verifyCharacterAtItem(anchor)
                if verified and verifiedCharacter == expectedCharacter and verifiedHumanoid.Health > 0 then
                    if anchorsAreStable(verifiedRoot, verifiedHead, verifiedTorso) then
                        stableFrames += 1
                    else
                        stableFrames = 0
                    end

                    local now = os.clock()
                    if prompt and prompt.Parent and prompt:IsA("ProximityPrompt")
                        and prompt.Enabled ~= false and stableFrames >= 3
                        and not promptInFlight and now >= nextPromptAt then
                        local referencePart = promptAnchor(prompt)
                        local maxDistance = math.max(0, tonumber(prompt.MaxActivationDistance) or 10)
                        local distance = referencePart and referencePart.Parent
                            and (referencePart.Position - verifiedRoot.Position).Magnitude or math.huge

                        if referencePart and referencePart.Parent
                            and distance <= maxDistance + 0.1 and distance <= 4.25 then
                            promptInFlight = true
                            lastPromptAt = now
                            task.spawn(function()

                                task.wait(0.27)
                                local callbackOk, callbackErr = pcall(function()
                                    local currentPromptAnchor = promptAnchor(prompt)
                                    local finalVerified, finalCharacter, finalHumanoid, finalRoot =
                                        verifyCharacterAtItem(currentPromptAnchor)
                                    local readySpawn = Farm.nextReadyBoostedTarget(part, tick(), false)
                                    local stillValid = State.Farm and Config.Boosted
                                        and not itemRemoved()
                                        and Utils.validPos(part) and not Utils.invisible(part)
                                        and prompt.Parent ~= nil and prompt:IsDescendantOf(workspace)
                                        and prompt.Enabled ~= false
                                        and finalVerified and finalCharacter == expectedCharacter
                                        and finalHumanoid.Health > 0
                                        and readySpawn == nil

                                    if stillValid then
                                        local currentReference = promptAnchor(prompt)
                                        local currentMaxDistance = math.max(0, tonumber(prompt.MaxActivationDistance) or 10)
                                        local currentDistance = currentReference and currentReference.Parent
                                            and (currentReference.Position - finalRoot.Position).Magnitude or math.huge
                                        stillValid = currentReference ~= nil and currentReference.Parent ~= nil
                                            and currentDistance <= currentMaxDistance + 0.1
                                            and currentDistance <= 4.25
                                    end

                                    if stillValid then
                                        local fired = Farm.triggerPickupPrompt(prompt)
                                        if fired then
                                            lastSuccessfulTriggerAt = os.clock()
                                        end
                                    end
                                end)
                                if not callbackOk then
                                    warn("[Methion] Boosted pickup check failed: " .. tostring(callbackErr))
                                end
                                promptInFlight = false
                                nextPromptAt = os.clock() + 0.06
                            end)
                        end
                    end
                else
                    stableFrames = 0
                    previousAnchors = nil
                end
            else
                stableFrames = 0
                previousAnchors = nil
            end

            RunService.Heartbeat:Wait()
        end
    end

    if itemRemoved() then
        ItemESP.unregister(part)
        return true
    end

    if trackedData and Config.Boosted then
        trackedData.FarmRetryAt = tick() + 0.08
    end
    return false
end

function Farm.pickupTween(model, part, trackedData)
    if not part or not part.Parent or not part:IsDescendantOf(workspace) then
        if part then ItemESP.unregister(part) end
        return true
    end

    local function findPrompt()
        local saved = trackedData and trackedData.Obj
        if saved and saved.Parent and saved:IsA("ProximityPrompt") then
            return saved
        end

        local roots = {model, part}
        for _, object in ipairs(roots) do
            if object and object.Parent then
                if object:IsA("ProximityPrompt") then return object end
                local prompt = object:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then return prompt end
            end
        end

        local ancestor = part:FindFirstAncestorOfClass("Model")
        if ancestor and ancestor ~= model then
            return ancestor:FindFirstChildWhichIsA("ProximityPrompt", true)
        end
        return nil
    end

    if not bypassSupported then

        local expectedCharacter = LP.Character
        local started = tick()
        local lastPromptAt = 0

        while Farm.isActive() and model and model.Parent and part and part.Parent
            and part:IsDescendantOf(workspace) and tick() - started < 3.5 do
            local character = LP.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not character or not root then break end
            expectedCharacter = expectedCharacter or character
            if character ~= expectedCharacter then break end

            local targetPosition = part.Position + Vector3.new(0, 2.25, 0)
            if (root.Position - targetPosition).Magnitude > 2.5 then
                root.CFrame = CFrame.new(targetPosition, part.Position)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end

            local prompt = findPrompt()
            if prompt and prompt.Parent and prompt.Enabled ~= false
                and tick() - lastPromptAt >= 0.16 then
                lastPromptAt = tick()
                Farm.triggerPickupPrompt(prompt)
            end
            task.wait(0.1)
        end

        if not part.Parent or not part:IsDescendantOf(workspace)
            or (model and not model.Parent) then
            ItemESP.unregister(part)
            return true
        end

        if trackedData then trackedData.FarmRetryAt = tick() + 1.0 end
        return false
    end

    for attempt = 1, 3 do
        if not part.Parent or not part:IsDescendantOf(workspace) then
            ItemESP.unregister(part)
            return true
        end
        if model and not model.Parent then
            ItemESP.unregister(part)
            return true
        end

        local prompt = findPrompt()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if prompt and prompt.Parent and prompt.Enabled ~= false and root then
            local promptPart = prompt.Parent:IsA("BasePart") and prompt.Parent
                or prompt.Parent:FindFirstChildWhichIsA("BasePart", true)
            local referencePart = promptPart or part
            local distance = (referencePart.Position - root.Position).Magnitude
            local maxDistance = tonumber(prompt.MaxActivationDistance) or 10

            if distance > math.max(maxDistance, 6) then
                root.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                RunService.Heartbeat:Wait()
            end

            Farm.triggerPickupPrompt(prompt)
        end

        task.wait(0.22)
        if not part.Parent or not part:IsDescendantOf(workspace) then
            ItemESP.unregister(part)
            return true
        end
        if trackedData then trackedData.FarmRetryAt = tick() + 0.35 end
    end

    if trackedData then trackedData.FarmRetryAt = tick() + 1.0 end
    return false
end

function MSH.moveToSafeIfNeeded()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root and (root.Position - Config.SafeZone).Magnitude > 6 then
        return Move.teleSafe()
    end
    return root ~= nil
end

function Farm.tick()
    if State.Selling then
        if Farm.isActive() and bypassSupported and Config.FarmTeleportMode == "instant" and not FarmVisual.isActive() then
            FarmVisual.showSafeZoneDecoy()
        end
        return
    end

    if not Farm.isActive() then
        if FarmVisual.Decoy then FarmVisual.restoreAtSafe() end
        return
    end

    if State.TweenRunning then
        if FarmVisual.Decoy then FarmVisual.cleanup() end
        return
    end

    local instantMode = bypassSupported and Config.FarmTeleportMode == "instant"
    if instantMode then
        if not FarmVisual.isActive() then
            MSH.moveToSafeIfNeeded()
            if not Config.Boosted then task.wait(0.08) end
            FarmVisual.showSafeZoneDecoy()
        end
    elseif FarmVisual.Decoy then
        FarmVisual.cleanup()
    end

    local item, trackedPart, trackedData = Farm.nearest()
    if item then

        local part = Config.Boosted and trackedPart and trackedPart.Parent
            and trackedPart:IsDescendantOf(workspace) and trackedPart
            or (item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true))
        if instantMode then
            if part then
                if Config.Boosted and State.Farm then
                    Farm.pickupBoosted(item, part, trackedData)
                    if not part.Parent or not part:IsDescendantOf(workspace) or Utils.invisible(part) then
                        ItemESP.unregister(part)
                    end
                else
                    local moved = Move.telePart(part)
                    if moved and Farm.waitForArrival(part, 2.5) then
                        local picked = Farm.pickup(item, part)
                        if not picked and (not part.Parent or not part:IsDescendantOf(workspace)) then
                            ItemESP.unregister(part)
                        end
                    elseif not part.Parent or not part:IsDescendantOf(workspace) then
                        ItemESP.unregister(part)
                    end
                    task.wait(0.025)
                end
            else
                MSH.moveToSafeIfNeeded()
            end
        else

            local targetPart = trackedPart and trackedPart.Parent and trackedPart:IsDescendantOf(workspace)
                and trackedPart or part
            if targetPart then
                local moved = Move.flyCF(
                    CFrame.new(targetPart.Position + Vector3.new(0, 3, 0)),
                    Config.TweenSpeed,
                    function()
                        return Farm.isActive()
                            and targetPart.Parent ~= nil
                            and targetPart:IsDescendantOf(workspace)
                            and (not item or item.Parent ~= nil)
                    end
                )

                if moved and targetPart.Parent and targetPart:IsDescendantOf(workspace)
                    and Farm.waitForArrival(targetPart, 3.5) then
                    Farm.pickupTween(item, targetPart, trackedData)
                end

                if not targetPart.Parent or not targetPart:IsDescendantOf(workspace) then
                    ItemESP.unregister(targetPart)
                elseif trackedData then
                    trackedData.FarmRetryAt = trackedData.FarmRetryAt or 0
                end
                task.wait(0.1)
            else

                local roamPos = Vector3.new(math.random(-560, 560), 100, math.random(-600, 580))
                Move.flyCF(CFrame.new(roamPos), Config.TweenSpeed, function()
                    return Farm.isActive() and Farm.nearest() == nil
                end)
                task.wait(0.1)
            end
        end
    else
        if instantMode then
            MSH.moveToSafeIfNeeded()
        else
            
            local roamPos = Vector3.new(math.random(-560, 560), 100, math.random(-600, 580))
            Move.flyCF(CFrame.new(roamPos), Config.TweenSpeed, function()
                return Farm.isActive() and Farm.nearest() == nil
            end)
            task.wait(0.1)
        end
    end
end

local Rejoin = {}
local rejoinConn = nil

function Rejoin.start()
    if rejoinConn then return end
    pcall(function()
        local GuiService = game:GetService("GuiService")
        local TeleportService = game:GetService("TeleportService")
        rejoinConn = GuiService.ErrorMessageChanged:Connect(function(message)
            if not Config.AutoRejoinEnabled then return end
            if not message or message == "" then return end
            task.spawn(function()
                task.wait(0.35)
                local reloadHandler = _G.__MethionSHReloadAfterKick
                if type(reloadHandler) == "function" then
                    local ok, reloading = pcall(reloadHandler)
                    if ok and reloading then return end
                end
                local controller = _G.__MethionSHController
                if controller and controller.Enabled and type(controller.hop) == "function" then
                    local ok, hopped = pcall(function() return controller:hop() end)
                    if ok and hopped then return end
                end
                pcall(function() TeleportService:Teleport(game.PlaceId, LP) end)
            end)
        end)
    end)
end

function Rejoin.stop()
    if rejoinConn then
        rejoinConn:Disconnect()
        rejoinConn = nil
    end
end

local Shop = {}

function Shop.buy(itemName)
    pcall(function()
        local char = LP.Character
        if not char then return end
        local ev = char:FindFirstChild("RemoteEvent")
        if not ev then return end
        ev:FireServer("PurchaseShopItem", {ItemName = itemName})
    end)
end

local autoLuckyLoopToken = 0
function Shop.autoLucky()
    autoLuckyLoopToken += 1
    local myToken = autoLuckyLoopToken
    if not Config.AutoBuyLucky then return end
    task.spawn(function()
        while Config.AutoBuyLucky and autoLuckyLoopToken == myToken do
            task.wait(1)
            if Config.AutoBuyLucky and autoLuckyLoopToken == myToken
                and Utils.money() >= Config.LuckyArrowPrice then
                Shop.buy(Config.LuckyArrowItem)
                task.wait(2)
            end
        end
    end)
end

local Loops = {}

local noclipCharacter = nil
local noclipParts = {}
local noclipAddedConn = nil
local noclipRemovingConn = nil

function Loops.noclip()
    RunService.Stepped:Connect(function()
        if not State.NoClip then return end
        local char = LP.Character
        if not char then return end
        if noclipCharacter ~= char then
            noclipCharacter = char
            if noclipAddedConn then pcall(function() noclipAddedConn:Disconnect() end) end
            if noclipRemovingConn then pcall(function() noclipRemovingConn:Disconnect() end) end
            table.clear(noclipParts)
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then table.insert(noclipParts, p) end
            end
            noclipAddedConn = char.DescendantAdded:Connect(function(p)
                if p:IsA("BasePart") then table.insert(noclipParts, p) end
            end)
            noclipRemovingConn = char.DescendantRemoving:Connect(function(p)
                if p:IsA("BasePart") then
                    for i = #noclipParts, 1, -1 do
                        if noclipParts[i] == p then
                            table.remove(noclipParts, i)
                            break
                        end
                    end
                end
            end)
        end
        for i = 1, #noclipParts do
            noclipParts[i].CanCollide = false
        end
    end)
end

function Loops.farm()
    task.spawn(function()
        local lastFarmErrorAt = 0
        while true do
            local ok, err = pcall(Farm.tick)
            if not ok and os.clock() - lastFarmErrorAt >= 5 then
                lastFarmErrorAt = os.clock()
                warn("[MethionSH] Farm iteration recovered from an error: " .. tostring(err))
            end
            if Farm.isActive() and bypassSupported and Config.FarmTeleportMode == "instant" then
                task.wait()
            else
                task.wait(0.1)
            end
        end
    end)
end

function Loops.trackedCleanup()
    task.spawn(function()
        while true do
            task.wait(0.25)
            for part, data in pairs(Tracked) do
                if not part or not part:IsDescendantOf(workspace) then
                    ItemESP.unregister(part)
                elseif ItemESP.isPlayerOwned(data.Obj or part, part) then
                    data.PlayerOwned = true
                else
                    data.PlayerOwned = nil
                    if not Utils.validPos(part) then
                        ItemESP.unregister(part)
                        table.insert(Pending, {obj = data.Obj or part, part = part, name = data.Name})
                    end
                end
            end
        end
    end)
end

function Loops.pending()
    task.spawn(function()
        while true do
            if Farm.isActive() and bypassSupported and Config.FarmTeleportMode == "instant" then
                RunService.Heartbeat:Wait()
            else
                task.wait(.2)
            end
            for i = #Pending, 1, -1 do
                local e = Pending[i]
                if e.obj and e.obj:IsDescendantOf(game) and Utils.validPos(e.part) then
                    table.remove(Pending, i)
                    if not Tracked[e.part] then ItemESP.register(e.obj) end
                elseif not e.obj or not e.obj:IsDescendantOf(game) then
                    table.remove(Pending, i)
                end
            end
        end
    end)
end

local SHController = {
    Enabled = false,
    Running = false,
    Token = 0,
    VisitedJobs = type(MethionSH_Env.__MethionSHVisitedJobs) == "table"
        and MethionSH_Env.__MethionSHVisitedJobs or {},
}
_G.__MethionSHController = SHController
local AFKFarmToggle = nil

local SHStats = MethionSH_Env.__MethionSHStats
if type(SHStats) ~= "table" then SHStats = {} end
local activeJobId = tostring(game.JobId or "")
local sameStatsServer = activeJobId ~= "" and SHStats.CurrentJobId == activeJobId
SHStats.ServersHopped = math.max(0, math.floor(tonumber(SHStats.ServersHopped) or 0))
SHStats.ItemsCollected = math.max(0, math.floor(tonumber(SHStats.ItemsCollected) or 0))
SHStats.LifetimeMoneyEarned = math.max(0, tonumber(SHStats.LifetimeMoneyEarned) or 0)
SHStats.CurrentServerItems = math.max(0, math.floor(tonumber(SHStats.CurrentServerItems) or 0))
SHStats.CurrentServerMoneyEarned = math.max(0, tonumber(SHStats.CurrentServerMoneyEarned) or 0)
SHStats.StartedAt = tonumber(SHStats.StartedAt) or os.time()
SHStats.Status = "Idle"
if not sameStatsServer then
    SHStats.CurrentJobId = activeJobId
    SHStats.CurrentServerItems = 0
    SHStats.CurrentServerMoneyEarned = 0
    SHStats.ServerStartedAt = os.time()
    SHStats.LastMoneyObserved = nil
end
MethionSH_Env.__MethionSHStats = SHStats
local shTeleportPending = false

function MSH.isJobVisited(jobId)
    for _, visitedId in ipairs(SHController.VisitedJobs) do
        if visitedId == jobId then return true end
    end
    return false
end

function MSH.rememberCurrentJob()
    local jobId = game.JobId
    if jobId and jobId ~= "" and not MSH.isJobVisited(jobId) then
        table.insert(SHController.VisitedJobs, jobId)
        while #SHController.VisitedJobs > 50 do
            table.remove(SHController.VisitedJobs, 1)
        end
    end
    MethionSH_Env.__MethionSHVisitedJobs = SHController.VisitedJobs
end

function MSH.resolvedMethionSHUrl()
    local url = METHIONSH_RAW_URL
    if type(url) ~= "string" or url == "" then return nil end
    if not (url:match("^https://") or url:match("^http://")) then return nil end
    return url
end

local ENTER_GAME_SOURCE = [=[
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local function enterGame()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    pcall(function()
        if not playerGui:FindFirstChild("HUD") then
            local objects = ReplicatedStorage:FindFirstChild("Objects")
            local hudTemplate = objects and objects:FindFirstChild("HUD")
            if hudTemplate then
                hudTemplate:Clone().Parent = playerGui
            end
        end
    end)
    local character = LocalPlayer.Character
        or LocalPlayer.CharacterAdded:Wait()
    local remote = character:WaitForChild("RemoteEvent", 15)
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer("PressedPlay")
    end
    for _, name in ipairs({
        "LoadingScreen1",
        "LoadingScreen"
    }) do
        local screen = playerGui:FindFirstChild(name)
        if screen then
            screen:Destroy()
        end
    end
    LocalPlayer:SetAttribute("LOADED", "Skip")
    local depthOfField = Lighting:FindFirstChild("DepthOfField")
    if depthOfField then
        depthOfField:Destroy()
    end
    local loadingScreen = workspace:FindFirstChild("LoadingScreen")
    if loadingScreen then
        local song = loadingScreen:FindFirstChild("Song")
        if song then
            song:Destroy()
        end
    end
end
while true do
    local ok, err = pcall(enterGame)
    if not ok then
        warn("[AutoPlay] Attempt failed: " .. tostring(err))
    end
    task.wait(3)
end
]=]

function MSH.countFarmableItems()
    local count = 0
    for part, data in pairs(Tracked) do
        if part and part.Parent and part:IsDescendantOf(workspace)
            and data and Farm.allowed(data.Name)
            and Utils.validPos(part) and not Utils.invisible(part)
            and not ItemESP.isPlayerOwned(data.Obj, part) then
            count += 1
        end
    end
    return count
end

function MSH.getPublicServerCandidate()
    local cursor = nil
    local candidates = {}
    local pages = 0
    repeat
        local cursorArg = cursor and ("&cursor=" .. HttpService:UrlEncode(cursor)) or ""
        local url = string.format(
            "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100%s",
            game.PlaceId,
            cursorArg
        )
        local ok, response = pcall(function() return game:HttpGet(url) end)
        if not ok or type(response) ~= "string" then
            warn("[MethionSH] Could not read the public server list: " .. tostring(response))
            break
        end
        local decodedOk, payload = pcall(function() return HttpService:JSONDecode(response) end)
        if not decodedOk or type(payload) ~= "table" or type(payload.data) ~= "table" then
            warn("[MethionSH] The public server list response was invalid.")
            break
        end
        for _, server in ipairs(payload.data) do
            local id = server.id
            local playing = tonumber(server.playing) or math.huge
            local maxPlayers = tonumber(server.maxPlayers) or 0
            if type(id) == "string" and id ~= "" and id ~= game.JobId
                and maxPlayers > 0 and playing < maxPlayers
                and not MSH.isJobVisited(id) then
                table.insert(candidates, {id = id, playing = playing, maxPlayers = maxPlayers})
            end
        end
        cursor = payload.nextPageCursor
        pages += 1
    until not cursor or pages >= 3 or #candidates >= 80

    if #candidates == 0 then

        cursor = nil
        local url = string.format(
            "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
            game.PlaceId
        )
        local ok, response = pcall(function() return game:HttpGet(url) end)
        if ok and type(response) == "string" then
            local decodedOk, payload = pcall(function() return HttpService:JSONDecode(response) end)
            if decodedOk and type(payload) == "table" and type(payload.data) == "table" then
                for _, server in ipairs(payload.data) do
                    local id = server.id
                    local playing = tonumber(server.playing) or math.huge
                    local maxPlayers = tonumber(server.maxPlayers) or 0
                    if type(id) == "string" and id ~= "" and id ~= game.JobId
                        and maxPlayers > 0 and playing < maxPlayers then
                        table.insert(candidates, {id = id, playing = playing, maxPlayers = maxPlayers})
                    end
                end
            end
        end
    end

    if #candidates == 0 then return nil end
    
    table.sort(candidates, function(a, b) return a.playing < b.playing end)
    local topCount = math.min(12, #candidates)
    return candidates[math.random(1, topCount)]
end

function MSH.queueNextRun(url, autoStart)
    local queueFunction = MethionSH_Env.queue_on_teleport or MethionSH_Env.queueonteleport
    if type(queueFunction) ~= "function" and type(MethionSH_Env.syn) == "table" then
        queueFunction = MethionSH_Env.syn.queue_on_teleport
    end
    if type(queueFunction) ~= "function" then
        warn("[MethionSH] This executor does not expose queue_on_teleport.")
        return false
    end

    local mode = Config.FarmTeleportMode == "tween" and "tween" or "instant"
    local filterJson = HttpService:JSONEncode(Config.FarmOnlyItems or {})
    local visitedJson = HttpService:JSONEncode(SHController.VisitedJobs)
    local statsPayload = {
        ServersHopped = SHStats.ServersHopped,
        ItemsCollected = SHStats.ItemsCollected,
        LifetimeMoneyEarned = SHStats.LifetimeMoneyEarned,
        CurrentServerItems = SHStats.CurrentServerItems,
        CurrentServerMoneyEarned = SHStats.CurrentServerMoneyEarned,
        StartedAt = SHStats.StartedAt,
        CurrentJobId = SHStats.CurrentJobId,
        LastMoneyObserved = SHStats.LastMoneyObserved,
        ServerStartedAt = SHStats.ServerStartedAt,
    }
    local statsJson = HttpService:JSONEncode(statsPayload)
    local hopSettingsJson = HttpService:JSONEncode({
        HopIntervalEnabled = Config.HopIntervalEnabled == true,
        HopIntervalUnit = Config.HopIntervalUnit,
        HopIntervalAmount = Config.HopIntervalAmount,
        HopOnEmpty = Config.HopOnEmpty == true,
        HopIntervalDefaultsV3 = true,
        StartupGraceSeconds = Config.StartupGraceSeconds,
        EmptyGraceSeconds = Config.EmptyGraceSeconds,
        MinServerDwellSeconds = Config.MinServerDwellSeconds,
    })
    local queueSource = table.concat({
        "repeat task.wait() until game:IsLoaded()",
        "local env = type(getgenv) == \"function\" and getgenv() or _G",
        "local jobKey = tostring(game.JobId)",
        "if env.__MethionSHLoadedJobId == jobKey then return end",
        "if env.__MethionSHBootstrapJob == jobKey and env.__MethionSHBootstrapActive == true then return end",
        "env.__MethionSHBootstrapJob = jobKey",
        "env.__MethionSHBootstrapActive = true",
        "local http = game:GetService(\"HttpService\")",
        "local statsOk, stats = pcall(function() return http:JSONDecode(" .. string.format("%q", statsJson) .. ") end)",
        "if statsOk and type(stats) == \"table\" then env.__MethionSHStats = stats end",
        "local mode = " .. string.format("%q", mode),
        "env.__MethionSHFarmTeleportMode = mode",
        "env.__MethionSHAutoBuyLucky = " .. tostring(Config.AutoBuyLucky == true),
        "local filterOk, filter = pcall(function() return http:JSONDecode(" .. string.format("%q", filterJson) .. ") end)",
        "if filterOk and type(filter) == \"table\" then env.__MethionSHFarmOnlyItems = filter end",
        "local hopSettingsOk, hopSettings = pcall(function() return http:JSONDecode(" .. string.format("%q", hopSettingsJson) .. ") end)",
        "if hopSettingsOk and type(hopSettings) == \"table\" then env.__MethionSHHopSettings = hopSettings end",
        "env.__MethionSHReloadOnKick = " .. tostring(Config.AutoRejoinEnabled == true),
        "env.__MethionSHAutoStart = " .. tostring(autoStart == true),
        "env.__MethionSHVisitedJobs = http:JSONDecode(" .. string.format("%q", visitedJson) .. ")",
        "local Players = game:GetService(\"Players\")",
        "local ReplicatedStorage = game:GetService(\"ReplicatedStorage\")",
        "local Lighting = game:GetService(\"Lighting\")",
        "local TeleportService = game:GetService(\"TeleportService\")",
        "local player = Players.LocalPlayer",
        "local function enterGame()",
        "    local playerGui = player:WaitForChild(\"PlayerGui\")",
        "    pcall(function() if not playerGui:FindFirstChild(\"HUD\") then local objects = ReplicatedStorage:FindFirstChild(\"Objects\"); local template = objects and objects:FindFirstChild(\"HUD\"); if template then template:Clone().Parent = playerGui end end end)",
        "    local character = player.Character or player.CharacterAdded:Wait()",
        "    local remote = character:WaitForChild(\"RemoteEvent\", 15)",
        "    if remote and remote:IsA(\"RemoteEvent\") then remote:FireServer(\"PressedPlay\") end",
        "    for _, name in ipairs({\"LoadingScreen1\", \"LoadingScreen\"}) do local screen = playerGui:FindFirstChild(name); if screen then screen:Destroy() end end",
        "    player:SetAttribute(\"LOADED\", \"Skip\")",
        "    local dof = Lighting:FindFirstChild(\"DepthOfField\"); if dof then dof:Destroy() end",
        "    local loading = workspace:FindFirstChild(\"LoadingScreen\"); local song = loading and loading:FindFirstChild(\"Song\"); if song then song:Destroy() end",
        "end",
        "task.spawn(function() while true do pcall(enterGame); task.wait(3) end end)",
        "local deadline = os.clock() + 10",
        "local entered = false",
        "repeat",
        "    task.wait(0.1)",
        "    local character = player.Character",
        "    local humanoid = character and character:FindFirstChildOfClass(\"Humanoid\")",
        "    local root = character and character:FindFirstChild(\"HumanoidRootPart\")",
        "    entered = character ~= nil and character.Parent ~= nil and humanoid ~= nil and humanoid.Health > 0 and root ~= nil and player:GetAttribute(\"LOADED\") == \"Skip\"",
        "until entered or os.clock() >= deadline",
        "if not entered then",
        "    local queueFn = env.queue_on_teleport or env.queueonteleport",
        "    if type(queueFn) ~= \"function\" and type(env.syn) == \"table\" then queueFn = env.syn.queue_on_teleport end",
        "    local retrySource = env.__MethionSHRecoverySource",
        "    if type(queueFn) == \"function\" and type(retrySource) == \"string\" then pcall(queueFn, retrySource) end",
        "    local targetId = nil",
        "    local ok, response = pcall(function() return game:HttpGet(\"https://games.roblox.com/v1/games/\" .. tostring(game.PlaceId) .. \"/servers/Public?sortOrder=Asc&limit=100\") end)",
        "    if ok and type(response) == \"string\" then",
        "        local decodedOk, payload = pcall(function() return http:JSONDecode(response) end)",
        "        if decodedOk and type(payload) == \"table\" and type(payload.data) == \"table\" then",
        "            local candidates = {}",
        "            for _, server in ipairs(payload.data) do local id = server.id; local playing = tonumber(server.playing) or math.huge; local maximum = tonumber(server.maxPlayers) or 0; if type(id) == \"string\" and id ~= \"\" and id ~= game.JobId and maximum > 0 and playing < maximum then table.insert(candidates, {id = id, playing = playing}) end end",
        "            table.sort(candidates, function(a, b) return a.playing < b.playing end)",
        "            if candidates[1] then targetId = candidates[1].id end",
        "        end",
        "    end",
        "    local attempt = 0",
        "    while true do",
        "        attempt += 1",
        "        local queueFn = env.queue_on_teleport or env.queueonteleport",
        "        if type(queueFn) ~= \"function\" and type(env.syn) == \"table\" then queueFn = env.syn.queue_on_teleport end",
        "        local retrySource = env.__MethionSHRecoverySource",
        "        if type(queueFn) == \"function\" and type(retrySource) == \"string\" then pcall(queueFn, retrySource) end",
        "        local failed = false",
        "        local teleportStarted = false",
        "        local failConn",
        "        local teleportConn",
        "        pcall(function() failConn = TeleportService.TeleportInitFailed:Connect(function(failedPlayer) if failedPlayer == player then failed = true end end) end)",
        "        pcall(function() teleportConn = player.OnTeleport:Connect(function(state) if state == Enum.TeleportState.Started or state == Enum.TeleportState.InProgress then teleportStarted = true elseif state == Enum.TeleportState.Failed then failed = true end end) end)",
        "        if targetId and attempt % 2 == 1 then",
        "            local callOk = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, targetId, player) end)",
        "            if not callOk then failed = true end",
        "        else",
        "            local callOk = pcall(function() TeleportService:Teleport(game.PlaceId, player) end)",
        "            if not callOk then failed = true end",
        "        end",
        "        local retryDeadline = os.clock() + 12",
        "        while os.clock() < retryDeadline and not failed and not teleportStarted do task.wait(0.2) end",
        "        if teleportConn then pcall(function() teleportConn:Disconnect() end) end",
        "        if failConn then pcall(function() failConn:Disconnect() end) end",
        "        if teleportStarted and not failed then repeat task.wait(1) until game.JobId ~= jobKey end",
        "        task.wait(1)",
        "    end",
        "end",
        "local mainUrl = " .. string.format("%q", url),
        "task.wait(0.75)",
        "for attempt = 1, 3 do",
        "    env.__MethionSHReady = false",
        "    local fetchOk, source = pcall(function() return game:HttpGet(mainUrl) end)",
        "    if fetchOk and type(source) == \"string\" and #source > 0 then",
        "        local chunk, compileError = loadstring(source)",
        "        if type(chunk) == \"function\" then",
        "            local ran, runError = pcall(chunk)",
        "            if not ran then warn(\"[MethionSH] Main script execution failed: \" .. tostring(runError)) end",
        "            local readyDeadline = os.clock() + 25",
        "            repeat task.wait(0.2) until env.__MethionSHReady == true or os.clock() >= readyDeadline",
        "            if env.__MethionSHReady == true or _G.__MethionSHReady == true then env.__MethionSHReady = true; env.__MethionSHLoadedJobId = tostring(game.JobId); env.__MethionSHBootstrapActive = false; return end",
        "            warn(\"[MethionSH] Main script did not finish initialization on attempt \" .. tostring(attempt))",
        "        else",
        "            warn(\"[MethionSH] Main script compile failed: \" .. tostring(compileError))",
        "        end",
        "    else",
        "        warn(\"[MethionSH] Could not fetch the main script: \" .. tostring(source))",
        "    end",
        "    task.wait(attempt * 2)",
        "end",
        "warn(\"[MethionSH] Script initialization failed after retries. Rejoining and retrying.\")",
        "while true do",
        "    local queueFn = env.queue_on_teleport or env.queueonteleport",
        "    if type(queueFn) ~= \"function\" and type(env.syn) == \"table\" then queueFn = env.syn.queue_on_teleport end",
        "    local retrySource = env.__MethionSHRecoverySource",
        "    if type(queueFn) == \"function\" and type(retrySource) == \"string\" then pcall(queueFn, retrySource) end",
        "    local failed = false",
        "    local teleportStarted = false",
        "    local failConn",
        "    local teleportConn",
        "    pcall(function() failConn = TeleportService.TeleportInitFailed:Connect(function(failedPlayer) if failedPlayer == player then failed = true end end) end)",
        "    pcall(function() teleportConn = player.OnTeleport:Connect(function(state) if state == Enum.TeleportState.Started or state == Enum.TeleportState.InProgress then teleportStarted = true elseif state == Enum.TeleportState.Failed then failed = true end end) end)",
        "    local callOk = pcall(function() TeleportService:Teleport(game.PlaceId, player) end)",
        "    if not callOk then failed = true end",
        "    local retryDeadline = os.clock() + 12",
        "    while os.clock() < retryDeadline and not failed and not teleportStarted do task.wait(0.2) end",
        "    if teleportConn then pcall(function() teleportConn:Disconnect() end) end",
        "    if failConn then pcall(function() failConn:Disconnect() end) end",
        "    if teleportStarted and not failed then repeat task.wait(1) until game.JobId ~= jobKey end",
        "    task.wait(1)",
        "end",
        "",
    }, "\n")
    MethionSH_Env.__MethionSHRecoverySource = queueSource
    local ok, err = pcall(queueFunction, queueSource)
    if not ok then
        warn("[MethionSH] Could not queue the next run: " .. tostring(err))
        return false
    end
    return true
end

function SHController:hop()
    local url = MSH.resolvedMethionSHUrl()
    if not url then
        if not self.UrlWarningShown then
            self.UrlWarningShown = true
            AirflowCompat:Notify({
                Title = "MethionSH URL missing",
                Content = "The configured MethionSH source URL is invalid. Check METHIONSH_RAW_URL in the script.",
                Type = "Warning",
                Duration = 7,
            })
            warn("[MethionSH] METHIONSH_RAW_URL is invalid; automatic server hopping cannot re-execute the script.")
        end
        return false
    end
    self.UrlWarningShown = false

    MSH.rememberCurrentJob()
    local target = MSH.getPublicServerCandidate()
    if not target then
        SHStats.Status = "Retrying"
        warn("[MethionSH] No different public server was found. Retrying soon.")
        return false
    end

    local previousHopCount = SHStats.ServersHopped
    SHStats.ServersHopped = previousHopCount + 1
    SHStats.Status = "Hopping"
    if not MSH.queueNextRun(url, true) then
        SHStats.ServersHopped = previousHopCount
        SHStats.Status = "Retrying"
        return false
    end

    shTeleportPending = true
    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, target.id, LP)
    end)
    if not ok then
        shTeleportPending = false
        SHStats.ServersHopped = previousHopCount
        SHStats.Status = "Retrying"
        warn("[MethionSH] Server hop failed: " .. tostring(err))
        return false
    end
    return true
end

_G.__MethionSHReloadAfterKick = function()
    local url = MSH.resolvedMethionSHUrl()
    if not url then return false end
    local shouldResumeFarm = SHController.Enabled or State.Farm == true
    if not MSH.queueNextRun(url, shouldResumeFarm) then return false end
    local ok = pcall(function() TeleportService:Teleport(game.PlaceId, LP) end)
    return ok
end

function SHController:stop()
    self.Enabled = false
    self.Running = false
    self.Token += 1
    _G.__MethionSHPreloading = false
    SHStats.Status = "Idle"
end

function SHController:start()
    if self.Enabled then return end
    self.Enabled = true
    self.Running = true
    self.Token += 1
    local myToken = self.Token
    State.Farm = true
    State.NoClip = true
    SHStats.Status = "Starting"
    _G.__MethionSHPreloading = true

    task.spawn(function()
        while not _G.__MethionSHReady and self.Enabled and self.Token == myToken do
            task.wait(0.1)
        end
        if not self.Enabled or self.Token ~= myToken then return end

        local character, humanoid, root
        while self.Enabled and self.Token == myToken do
            character = LP.Character
            humanoid = character and character:FindFirstChildOfClass("Humanoid")
            root = character and character:FindFirstChild("HumanoidRootPart")
            local enteredGame = LP:GetAttribute("LOADED") == "Skip"
            if character and character.Parent and humanoid and humanoid.Health > 0 and root and enteredGame then
                break
            end
            SHStats.Status = "Loading character"
            task.wait(0.2)
        end

        if not self.Enabled or self.Token ~= myToken then return end
        if not (character and character.Parent and humanoid and humanoid.Health > 0 and root) then
            SHStats.Status = "Waiting for character"
            return
        end

        if not bypassSupported then
            warn("[MethionSH] AFK Farm requires the Instant bypass supported by this executor.")
            self:stop()
            State.Farm = false
            State.NoClip = false
            return
        end
        ItemESP.scan()
        if not self.Enabled or self.Token ~= myToken then return end
        _G.__MethionSHPreloading = false
        State.Farm = true
        State.NoClip = true
        SHStats.Status = "Farming"
        local sawItems = MSH.countFarmableItems() > 0
        local emptySince = nil
        local timedHopDue = false
        local runStarted = os.clock()
        local initialItemGraceUntil = runStarted + Config.StartupGraceSeconds
        local nextScan = os.clock() + 3.0
        local function getHopIntervalSeconds()
            local amount = math.clamp(math.floor(tonumber(Config.HopIntervalAmount) or 35), 1, 120)
            local unit = Config.HopIntervalUnit
            local multiplier = unit == "Hours" and 3600 or (unit == "Seconds" and 1 or 60)
            return amount * multiplier
        end

        while self.Enabled and self.Token == myToken do
            local now = os.clock()
            if now >= nextScan then
                local scanOk, scanErr = pcall(ItemESP.scan)
                if not scanOk then warn("[MethionSH] Item rescan failed: " .. tostring(scanErr)) end
                nextScan = now + 3.0
            end

            local remaining = MSH.countFarmableItems()
            if remaining > 0 then
                sawItems = true
                emptySince = nil
            else
                emptySince = emptySince or now
            end

            local elapsed = now - runStarted
            local intervalSeconds = getHopIntervalSeconds()
            if Config.HopIntervalEnabled then
                SHStats.HopTimerRemaining = math.max(0, math.ceil(intervalSeconds - elapsed))
            else
                SHStats.HopTimerRemaining = nil
            end
            local minimumDwellPassed = elapsed >= Config.MinServerDwellSeconds
            local intervalExpired = Config.HopIntervalEnabled and elapsed >= intervalSeconds
            local emptyGracePassed = emptySince ~= nil
                and (now - emptySince) >= Config.EmptyGraceSeconds
                and (sawItems or now >= initialItemGraceUntil)
            local emptyHopAllowed = not Config.HopIntervalEnabled or Config.HopOnEmpty
            local shouldHop = intervalExpired
                or (minimumDwellPassed and emptyHopAllowed and emptyGracePassed)

            if shouldHop then
                SHStats.HopTimerRemaining = nil
                if intervalExpired then
                    timedHopDue = true
                    SHStats.Status = "Hop interval elapsed"
                else
                    SHStats.Status = sawItems and "Item pool depleted" or "No items found"
                end
                break
            end
            task.wait(0.25)
        end

        if not self.Enabled or self.Token ~= myToken then return end

        _G.__MethionSHPreloading = false
        State.Farm = false
        State.NoClip = false
        if AFKFarmToggle and type(AFKFarmToggle.Set) == "function" then
            pcall(function() AFKFarmToggle:Set(true, true) end)
        end
        if autoSellMax and not timedHopDue then
            pcall(function() Selling.requestAutoSellMaxCheck() end)
        end
        if not timedHopDue then
            local sellDeadline = os.clock() + 4
            while State.Selling and os.clock() < sellDeadline and self.Enabled and self.Token == myToken do
                task.wait(0.1)
            end
        end

        while self.Enabled and self.Token == myToken do
            local hopStarted = self:hop()
            if hopStarted then
                local pendingDeadline = os.clock() + 15
                while self.Enabled and self.Token == myToken
                    and shTeleportPending and os.clock() < pendingDeadline do
                    task.wait(0.2)
                end
                if not self.Enabled or self.Token ~= myToken then return end
                if shTeleportPending then
                    shTeleportPending = false
                    SHStats.ServersHopped = math.max(0, SHStats.ServersHopped - 1)
                    SHStats.Status = "Retrying"
                    warn("[MethionSH] Teleport did not complete. Retrying the server hop.")
                end
                task.wait(2)
            else
                task.wait(5)
            end
        end
    end)
end

if MethionSH_Env.__MethionSHTeleportFailedConnection then
    pcall(function() MethionSH_Env.__MethionSHTeleportFailedConnection:Disconnect() end)
end
MethionSH_Env.__MethionSHTeleportFailedConnection = TeleportService.TeleportInitFailed:Connect(function(player)
    if player == LP and shTeleportPending then
        shTeleportPending = false
        SHStats.ServersHopped = math.max(0, SHStats.ServersHopped - 1)
        SHStats.Status = "Retrying"
    end
end)

function MSH.shFormatNumber(value)
    local number = math.max(0, math.floor(tonumber(value) or 0))
    local formatted = tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return formatted:gsub("^,", "")
end

function MSH.shFormatDuration(seconds)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remaining = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, remaining)
end

local itemToolSeen = setmetatable({}, {__mode = "k"})
local inventoryContainers = setmetatable({}, {__mode = "k"})
local oldInventoryConnections = MethionSH_Env.__MethionSHInventoryConnections
if type(oldInventoryConnections) == "table" then
    for _, connection in ipairs(oldInventoryConnections) do
        pcall(function() connection:Disconnect() end)
    end
end
local inventoryConnections = {}
MethionSH_Env.__MethionSHInventoryConnections = inventoryConnections
function MSH.isFarmItemTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tostring(tool.Name or "")
    local normalized = name:gsub("^%s*%d+%s*[xX]%s*", "")
    return FARM_ITEMS[name] ~= nil or FARM_ITEMS[normalized] ~= nil
end

function MSH.countNewFarmItemTool(tool)
    if not MSH.isFarmItemTool(tool) or itemToolSeen[tool] then return end
    itemToolSeen[tool] = true
    SHStats.ItemsCollected += 1
    SHStats.CurrentServerItems += 1
end

function MSH.bindInventoryContainer(container)
    if not container or inventoryContainers[container] then return end
    inventoryContainers[container] = true
    for _, child in ipairs(container:GetChildren()) do
        if MSH.isFarmItemTool(child) then itemToolSeen[child] = true end
    end
    table.insert(inventoryConnections, container.ChildAdded:Connect(MSH.countNewFarmItemTool))
end

local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
if backpack then MSH.bindInventoryContainer(backpack) end
if LP.Character then MSH.bindInventoryContainer(LP.Character) end
if MethionSH_Env.__MethionSHBackpackWatcher then
    pcall(function() MethionSH_Env.__MethionSHBackpackWatcher:Disconnect() end)
end
MethionSH_Env.__MethionSHBackpackWatcher = LP.ChildAdded:Connect(function(child)
    if child:IsA("Backpack") or child.Name == "Backpack" then
        MSH.bindInventoryContainer(child)
    end
end)
if MethionSH_Env.__MethionSHCharacterAddedConnection then
    pcall(function() MethionSH_Env.__MethionSHCharacterAddedConnection:Disconnect() end)
end
MethionSH_Env.__MethionSHCharacterAddedConnection = LP.CharacterAdded:Connect(function(character)
    MSH.bindInventoryContainer(character)
end)

function MSH.bindMoneyStat()
    local statsFolder = LP:FindFirstChild("PlayerStats")
    if not statsFolder then return false end
    local money = statsFolder:FindFirstChild("Money")
    if not money or not money:IsA("ValueBase") then return false end

    if MethionSH_Env.__MethionSHMoneyValueConnection then
        pcall(function() MethionSH_Env.__MethionSHMoneyValueConnection:Disconnect() end)
    end
    local function recordMoney(value)
        local amount = tonumber(value)
        if not amount then return end
        local previous = tonumber(SHStats.LastMoneyObserved)
        if previous and SHStats.CurrentJobId == activeJobId then
            local delta = amount - previous
            if delta > 0 then
                SHStats.LifetimeMoneyEarned += delta
                SHStats.CurrentServerMoneyEarned += delta
            end
        end
        SHStats.LastMoneyObserved = amount
    end
    recordMoney(money.Value)
    MethionSH_Env.__MethionSHMoneyValueConnection = money:GetPropertyChangedSignal("Value"):Connect(function()
        recordMoney(money.Value)
    end)
    return true
end

if MethionSH_Env.__MethionSHMoneyValueConnection then
    pcall(function() MethionSH_Env.__MethionSHMoneyValueConnection:Disconnect() end)
end
if MethionSH_Env.__MethionSHStatsFolderConnection then
    pcall(function() MethionSH_Env.__MethionSHStatsFolderConnection:Disconnect() end)
end
if MethionSH_Env.__MethionSHPlayerStatsAddedConnection then
    pcall(function() MethionSH_Env.__MethionSHPlayerStatsAddedConnection:Disconnect() end)
end
MSH.bindMoneyStat()
local statsFolder = LP:FindFirstChild("PlayerStats")
if statsFolder then
    MethionSH_Env.__MethionSHStatsFolderConnection = statsFolder.ChildAdded:Connect(function(child)
        if child.Name == "Money" then task.defer(MSH.bindMoneyStat) end
    end)
end
MethionSH_Env.__MethionSHPlayerStatsAddedConnection = LP.ChildAdded:Connect(function(child)
    if child.Name == "PlayerStats" then
        task.defer(function()
            if child.Parent == LP then
                MSH.bindMoneyStat()
                if MethionSH_Env.__MethionSHStatsFolderConnection then
                    pcall(function() MethionSH_Env.__MethionSHStatsFolderConnection:Disconnect() end)
                end
                MethionSH_Env.__MethionSHStatsFolderConnection = child.ChildAdded:Connect(function(valueObject)
                    if valueObject.Name == "Money" then task.defer(MSH.bindMoneyStat) end
                end)
            end
        end)
    end
end)

function MSH.createServerStatsPanel()
    local oldConnections = MethionSH_Env.__MethionSHStatsUiConnections
    if type(oldConnections) == "table" then
        for _, connection in ipairs(oldConnections) do
            pcall(function() connection:Disconnect() end)
        end
    end
    local connections = {}
    MethionSH_Env.__MethionSHStatsUiConnections = connections

    local coreGui = game:GetService("CoreGui")
    pcall(function()
        local old = coreGui:FindFirstChild("MethionSH_ServerStats")
        if old then old:Destroy() end
    end)
    local parent = coreGui
    local screen = Instance.new("ScreenGui")
    screen.Name = "MethionSH_ServerStats"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.DisplayOrder = 10020
    local parentOk = pcall(function() screen.Parent = parent end)
    if not parentOk or not screen.Parent then
        local playerGui = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")
        screen.Parent = playerGui
    end

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.Size = UDim2.fromOffset(244, 236)
    panel.Position = UDim2.new(0, 10, 0.36, 0)
    panel.BackgroundColor3 = Color3.fromRGB(18, 21, 28)
    panel.BackgroundTransparency = 0.06
    panel.BorderSizePixel = 0
    panel.Parent = screen
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = panel
    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(58, 66, 82)
    outline.Transparency = 0.18
    outline.Thickness = 1
    outline.Parent = panel
    local scale = Instance.new("UIScale")
    scale.Parent = panel

    local header = Instance.new("Frame")
    header.Name = "DragHeader"
    header.BackgroundTransparency = 1
    header.Position = UDim2.fromOffset(0, 0)
    header.Size = UDim2.new(1, 0, 0, 48)
    header.Active = true
    header.Parent = panel

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(13, 8)
    title.Size = UDim2.new(1, -90, 0, 21)
    title.Font = Enum.Font.GothamBold
    title.Text = "SERVER HOPPER"
    title.TextColor3 = Color3.fromRGB(237, 241, 248)
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Active = false
    title.Parent = header

    local subtitle = Instance.new("TextLabel")
    subtitle.BackgroundTransparency = 1
    subtitle.Position = UDim2.fromOffset(13, 28)
    subtitle.Size = UDim2.new(1, -26, 0, 13)
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = "SESSION TOTALS"
    subtitle.TextColor3 = Color3.fromRGB(139, 149, 166)
    subtitle.TextSize = 9
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Active = false
    subtitle.Parent = header

    local statusBadge = Instance.new("TextLabel")
    statusBadge.Name = "Status"
    statusBadge.AnchorPoint = Vector2.new(1, 0)
    statusBadge.Position = UDim2.new(1, -11, 0, 11)
    statusBadge.Size = UDim2.fromOffset(69, 20)
    statusBadge.BackgroundColor3 = Color3.fromRGB(37, 64, 58)
    statusBadge.BorderSizePixel = 0
    statusBadge.Font = Enum.Font.GothamBold
    statusBadge.Text = "STARTING"
    statusBadge.TextColor3 = Color3.fromRGB(148, 230, 194)
    statusBadge.TextSize = 9
    statusBadge.Active = false
    statusBadge.Parent = header
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 5)
    statusCorner.Parent = statusBadge

    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.Position = UDim2.fromOffset(12, 48)
    accent.Size = UDim2.new(1, -24, 0, 2)
    accent.BackgroundColor3 = Color3.fromRGB(95, 173, 154)
    accent.BorderSizePixel = 0
    accent.Parent = panel

    local rowsFrame = Instance.new("Frame")
    rowsFrame.Name = "Rows"
    rowsFrame.BackgroundTransparency = 1
    rowsFrame.Position = UDim2.fromOffset(12, 57)
    rowsFrame.Size = UDim2.new(1, -24, 0, 150)
    rowsFrame.Parent = panel
    local rowLayout = Instance.new("UIListLayout")
    rowLayout.Padding = UDim.new(0, 2)
    rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rowLayout.Parent = rowsFrame

    local rows = {}
    local rowSpecs = {
        {"SERVERS HOPPED", "ServersHopped"},
        {"ITEMS THIS SERVER", "CurrentServerItems"},
        {"ITEMS COLLECTED", "ItemsCollected"},
        {"EARNED THIS SERVER", "CurrentServerMoneyEarned", true},
        {"TOTAL MONEY EARNED", "LifetimeMoneyEarned", true},
        {"SESSION TIME", "SessionTime"},
    }
    for index, spec in ipairs(rowSpecs) do
        local row = Instance.new("Frame")
        row.Name = "StatRow" .. tostring(index)
        row.Size = UDim2.new(1, 0, 0, 21)
        row.BackgroundTransparency = 1
        row.LayoutOrder = index
        row.Parent = rowsFrame

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0.61, 0, 1, 0)
        label.Font = Enum.Font.GothamMedium
        label.Text = spec[1]
        label.TextColor3 = Color3.fromRGB(151, 161, 177)
        label.TextSize = 9
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row

        local value = Instance.new("TextLabel")
        value.Name = "Value"
        value.BackgroundTransparency = 1
        value.Position = UDim2.new(0.61, 0, 0, 0)
        value.Size = UDim2.new(0.39, 0, 1, 0)
        value.Font = Enum.Font.GothamSemibold
        value.Text = "0"
        value.TextColor3 = Color3.fromRGB(237, 241, 248)
        value.TextSize = 11
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.TextTruncate = Enum.TextTruncate.AtEnd
        value.Parent = row
        rows[spec[2]] = {Label = value, Money = spec[3] == true}
    end

    local serverLabel = Instance.new("TextLabel")
    serverLabel.Name = "ServerId"
    serverLabel.BackgroundTransparency = 1
    serverLabel.Position = UDim2.new(0, 12, 1, -20)
    serverLabel.Size = UDim2.new(1, -24, 0, 12)
    serverLabel.Font = Enum.Font.Code
    serverLabel.Text = "SERVER 00000000"
    serverLabel.TextColor3 = Color3.fromRGB(111, 123, 142)
    serverLabel.TextSize = 9
    serverLabel.TextXAlignment = Enum.TextXAlignment.Left
    serverLabel.Parent = panel

    local function updateResponsive()
        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
        if viewport.X < 430 then
            scale.Scale = 0.82
            panel.Position = UDim2.new(0, 7, 0.32, 0)
        elseif viewport.X < 700 then
            scale.Scale = 0.9
            panel.Position = UDim2.new(0, 8, 0.34, 0)
        else
            scale.Scale = 1
            panel.Position = UDim2.new(0, 10, 0.36, 0)
        end
    end
    local function bindCamera(camera)
        if camera then
            table.insert(connections, camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsive))
        end
        updateResponsive()
    end
    bindCamera(workspace.CurrentCamera)
    table.insert(connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        bindCamera(workspace.CurrentCamera)
    end))

    local dragging = false
    local dragStart = nil
    local startPosition = nil
    table.insert(connections, header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = panel.Position
        end
    end))
    table.insert(connections, header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if not dragging or not dragStart or not startPosition then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end))

    local function updateStats()
        local values = {
            ServersHopped = SHStats.ServersHopped,
            CurrentServerItems = SHStats.CurrentServerItems,
            ItemsCollected = SHStats.ItemsCollected,
            CurrentServerMoneyEarned = SHStats.CurrentServerMoneyEarned,
            LifetimeMoneyEarned = SHStats.LifetimeMoneyEarned,
            SessionTime = MSH.shFormatDuration(os.time() - (tonumber(SHStats.StartedAt) or os.time())),
        }
        for key, row in pairs(rows) do
            local value = values[key]
            if row.Money then
                row.Label.Text = "$" .. MSH.shFormatNumber(value)
            elseif key == "SessionTime" then
                row.Label.Text = tostring(value)
            else
                row.Label.Text = MSH.shFormatNumber(value)
            end
        end

        local status = tostring(SHStats.Status or "Idle")
        statusBadge.Text = string.upper(status)
        if status == "Farming" then
            statusBadge.BackgroundColor3 = Color3.fromRGB(37, 64, 58)
            statusBadge.TextColor3 = Color3.fromRGB(148, 230, 194)
        elseif status == "Hopping" then
            statusBadge.BackgroundColor3 = Color3.fromRGB(45, 58, 83)
            statusBadge.TextColor3 = Color3.fromRGB(167, 198, 255)
        elseif status == "Retrying" then
            statusBadge.BackgroundColor3 = Color3.fromRGB(83, 61, 39)
            statusBadge.TextColor3 = Color3.fromRGB(255, 207, 140)
        else
            statusBadge.BackgroundColor3 = Color3.fromRGB(50, 54, 64)
            statusBadge.TextColor3 = Color3.fromRGB(185, 192, 205)
        end
        local job = tostring(game.JobId or "")
        serverLabel.Text = "SERVER " .. (job ~= "" and string.sub(job, 1, 8) or "UNKNOWN")
    end

    updateStats()
    task.spawn(function()
        while screen.Parent do
            pcall(updateStats)
            task.wait(1)
        end
    end)
end

MSH.createServerStatsPanel()

local Window = AirflowCompat:CreateWindow({
    Name = "MethionSH",
    Title = "MethionSH",
    Author = "by Diablo",
    Icon = "rbxthumb://type=Asset&id=76755716686687&w=150&h=150",
    Theme = "Phantom",
    Folder = "Methion",
    Size = UDim2.fromOffset(820, 580),
    Transparent = true,
    Resizable = true,
    SideBarWidth = 200,
    HideSearchBar = true,
    OpenButton = {
        Title = "MethionSH",
        Enabled = true,
        Draggable = true,
        Scale = 1,
        Color = ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromRGB(224,224,224)),
    },
    User = {Enabled = true, Anonymous = false, Title = "Methion", Avatar = "rbxthumb://type=Asset&id=76755716686687&w=150&h=150", Icon = "rbxthumb://type=Asset&id=76755716686687&w=150&h=150"},
})

pcall(function()
    local mainFrame = Window.MainFrame or Window.Frame or Window.Window
    if mainFrame and mainFrame:IsA("Frame") then
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new {
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(224,224,224)),
        }
        grad.Rotation = 135
        grad.Parent = mainFrame
        mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    end
end)

local FarmTab = Window:Tab({Title = "Auto-Farm", Icon = "zap"})
local FarmHopSettingsTab = Window:Tab({Title = "Farm Settings", Icon = "settings", Desc = "Configure farming and server hopping."})

local HalloweenTab = Window:Tab({
    Title = "Halloween Event",
    Icon = "ghost",
    Desc = "Collect candy and turn it in to Jack.",
})

local Halloween = {
    AutoTurnIn = true,
    TurnInThreshold = 20,
    TurnInBusy = false,
    LastTurnInAt = 0,
    StatusLabel = nil,
    PointsLabel = nil,
    CachedJackPoints = nil,
    PointsValue = nil,
}

local HALLOWEEN_CANDY_LOOKUP = {
    ["Green Candy"] = true,
    ["Red Candy"] = true,
    ["Blue Candy"] = true,
    ["Yellow Candy"] = true,
}

function Halloween.countCandies()
    local total = 0
    local character = LP.Character
    local backpack = LP:FindFirstChild("Backpack")
    if character then
        for _, object in ipairs(character:GetChildren()) do
            if object:IsA("Tool") and HALLOWEEN_CANDY_LOOKUP[object.Name] then
                total += 1
            end
        end
    end
    if backpack then
        for _, object in ipairs(backpack:GetChildren()) do
            if object:IsA("Tool") and HALLOWEEN_CANDY_LOOKUP[object.Name] then
                total += 1
            end
        end
    end
    return total
end

function Halloween.captureJackPoints(gui)
    if not gui or not gui.Parent then return false end
    local ok, rawText = pcall(function()
        return Gui.dialogueText(gui)
    end)
    if not ok or type(rawText) ~= "string" or rawText == "" then return false end

    local text = string.lower(rawText):gsub(",", "")
    local digits = text:match("you%s+now%s+have%s+(%d+)%s+points?")
    if not digits then return false end

    local points = tonumber(digits)
    if not points then return false end
    Halloween.CachedJackPoints = points
    return true
end

local HALLOWEEN_POINTS_ALIASES = {
    jackpoints = 120,
    halloweenpoints = 115,
    candypoints = 110,
    pumpkinpoints = 105,
    eventpoints = 100,
    trickortreatpoints = 98,
    jackpoint = 95,
    halloweenpoint = 94,
    candypoint = 93,
    pumpkinpoint = 92,
    eventpoint = 91,
    halloweencurrency = 85,
    candycurrency = 84,
    eventcurrency = 83,
    jackcurrency = 82,
    trickortreatcurrency = 80,
    halloweentokens = 75,
    candytokens = 74,
    jacktokens = 73,
}

local HALLOWEEN_SCAN_ROOT_NAMES = {"PlayerStats", "leaderstats", "Stats", "Data"}

local function halloweenNormalize(value)
    return string.lower(tostring(value or "")):gsub("[^%w]", "")
end

function Halloween.formatPoints(bestValue)
    local numeric = tonumber(bestValue)
    if numeric then
        local rounded = math.floor(numeric)
        local formatted = tostring(rounded)
        while true do
            local replaced, count = formatted:gsub("^(%-?%d+)(%d%d%d)", "%1,%2")
            formatted = replaced
            if count == 0 then break end
        end
        return formatted
    end
    return tostring(bestValue)
end

function Halloween.readJackPoints()
    -- points captured from Jack's dialogue always win; skip the stat scan
    if Halloween.CachedJackPoints ~= nil then
        return Halloween.formatPoints(Halloween.CachedJackPoints)
    end

    -- cached stat instance still alive: read its current value directly
    local cachedStat = Halloween.PointsValue
    if cachedStat and cachedStat.Parent then
        return Halloween.formatPoints(cachedStat.Value)
    end

    local bestValue, bestScore, bestObject = nil, -1, nil
    local scanRoots = {LP}
    for _, rootName in ipairs(HALLOWEEN_SCAN_ROOT_NAMES) do
        local root = LP:FindFirstChild(rootName)
        if root then table.insert(scanRoots, root) end
    end

    local seen = {}
    for _, root in ipairs(scanRoots) do
        if root and not seen[root] then
            seen[root] = true
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("ValueBase") then
                    local key = halloweenNormalize(obj.Name)
                    local score = HALLOWEEN_POINTS_ALIASES[key]
                    if not score and key:find("point", 1, true) then
                        local ancestor = obj.Parent
                        local eventContext = false
                        while ancestor and ancestor ~= root do
                            local contextName = halloweenNormalize(ancestor.Name)
                            if contextName:find("jack", 1, true)
                                or contextName:find("halloween", 1, true)
                                or contextName:find("candy", 1, true)
                                or contextName:find("pumpkin", 1, true)
                                or contextName:find("trickortreat", 1, true)
                                or contextName:find("event", 1, true) then
                                eventContext = true
                                break
                            end
                            ancestor = ancestor.Parent
                        end
                        if eventContext then score = 70 end
                    end
                    if score and score > bestScore then
                        bestScore = score
                        bestValue = obj.Value
                        bestObject = obj
                    end
                end
            end
        end
    end

    for name, value in pairs(LP:GetAttributes()) do
        local key = halloweenNormalize(name)
        local score = HALLOWEEN_POINTS_ALIASES[key]
        if score and score > bestScore then
            bestScore = score
            bestValue = value
            bestObject = nil
        end
    end

    if bestValue == nil then return nil end
    if bestObject then Halloween.PointsValue = bestObject end
    return Halloween.formatPoints(bestValue)
end

function MSH.halloweenNotify(title, message, notificationType)
    pcall(function()
        AirflowCompat:Notify({
            Title = title or "Halloween Event",
            Content = message or "",
            Type = notificationType or "Info",
            Duration = 4,
        })
    end)
end

function MSH.turnInHalloweenCandies()
    if Halloween.TurnInBusy or State.HalloweenTurnInBusy then
        return false, "A candy turn-in is already running."
    end
    if State.Selling then
        return false, "Wait until selling finishes first."
    end
    if Gui.currentDialogue() then
        return false, "Close the current NPC dialogue before turning in candy."
    end

    local candyCount = Halloween.countCandies()
    if candyCount <= 0 then
        return false, "You do not have any candy to turn in."
    end

    local character = LP.Character
    local remote = character and character:FindFirstChild("RemoteEvent")
    local dialogueFolder = ReplicatedStorage:FindFirstChild("Dialogue")
    local dialogueTemplate = dialogueFolder and dialogueFolder:FindFirstChild("Halloween Event")
    if not remote or not remote:IsA("RemoteEvent") or not dialogueTemplate then
        return false, "Halloween Event dialogue or the character RemoteEvent is unavailable."
    end

    Halloween.TurnInBusy = true
    State.HalloweenTurnInBusy = true
    local success = false
    local openedDialogue = nil
    local failureReason = "Could not select the candy turn-in option."

    local ok, err = pcall(function()
        remote:FireServer("PromptTriggered", dialogueTemplate)
        local dialogue = Gui.waitDialogue(4)
        if not dialogue or not Gui.dialogueActive(dialogue) then
            failureReason = "Jack's dialogue did not open."
            return
        end
        openedDialogue = dialogue

        if not Gui.waitAndClickOption("Option2", 5) then
            failureReason = "The second dialogue option was not available."
            return
        end

        local captureDeadline = tick() + 2.5
        repeat
            local responseDialogue = Gui.currentDialogue() or openedDialogue
            if Halloween.captureJackPoints(responseDialogue) then break end
            task.wait(0.1)
        until tick() >= captureDeadline

        success = true
        Halloween.LastTurnInAt = tick()
    end)

    if openedDialogue then
        pcall(function()
            Gui.forceCloseDialogue(3)
        end)
    end

    Halloween.TurnInBusy = false
    State.HalloweenTurnInBusy = false

    if not ok then
        return false, "Turn-in failed: " .. tostring(err)
    end
    return success, success and ("Turn-in requested for " .. tostring(candyCount) .. " candies.") or failureReason
end

local HalloweenCollection = HalloweenTab:Section({Title = "Candy Collection", Side = "left"})
HalloweenCollection:Paragraph({
    Title = "Auto Collect Candies",
    Desc = "Picks up Halloween candy only.",
})
HalloweenCollection:Toggle({
    Title = "Auto Collect Candies",
    Desc = "Collect Halloween candy automatically.",
    Icon = "candy",
    Value = false,
    Callback = function(state)
        State.HalloweenCandyFarm = state == true
        if State.HalloweenCandyFarm then
            State.NoClip = true
            ItemESP.scan()
        elseif not State.Farm then
            State.NoClip = false
        end
        MSH.halloweenNotify("Halloween Event", State.HalloweenCandyFarm and "Candy-only collection enabled." or "Candy-only collection disabled.")
    end,
})

local HalloweenInfo = HalloweenTab:Section({Title = "Info", Side = "left"})
Halloween.PointsLabel = HalloweenInfo:Paragraph({
    Title = "Points from Jack",
    Desc = "Checking your event points...",
})
Halloween.StatusLabel = HalloweenInfo:Paragraph({
    Title = "Candy Inventory",
    Desc = "Checking your candy...",
})

local HalloweenTurnInSection = HalloweenTab:Section({Title = "Candy Turn-In", Side = "right"})
HalloweenTurnInSection:Input({
    Title = "Candy Turn-In Threshold",
    Desc = "Turn in candy when you have this many. Max: 45.",
    Placeholder = "20",
    Value = "20",
    Callback = function(value)
        local amount = tonumber(value)
        if amount then
            Halloween.TurnInThreshold = math.clamp(math.floor(amount), 1, 45)
        end
    end,
})
HalloweenTurnInSection:Toggle({
    Title = "Auto Turn In Candies",
    Desc = "Turn in your candy automatically when you reach the amount above.",
    Icon = "message-circle",
    Value = true,
    Callback = function(state)
        Halloween.AutoTurnIn = state == true
        MSH.halloweenNotify("Halloween Event", Halloween.AutoTurnIn and "Automatic candy turn-in enabled." or "Automatic candy turn-in disabled.")
    end,
})
HalloweenTurnInSection:Button({
    Title = "Turn In Candies Now",
    Desc = "Turn in your candy now.",
    Icon = "gift",
    Callback = function()
        task.spawn(function()
            local success, message = MSH.turnInHalloweenCandies()
            MSH.halloweenNotify("Halloween Event", message, success and "Success" or "Warning")
        end)
    end,
})
task.spawn(function()
    local lastStatusUpdate = 0
    while true do
        task.wait(0.4)

        local activeDialogue = Gui.currentDialogue()
        if activeDialogue then
            Halloween.captureJackPoints(activeDialogue)
        end

        local candyCount = Halloween.countCandies()
        if tick() - lastStatusUpdate >= 0.8 then
            lastStatusUpdate = tick()
            if Halloween.StatusLabel then
                pcall(function()
                    Halloween.StatusLabel:SetDesc(string.format(
                        "%d / 45 candies in inventory. Auto turn-in threshold: %d.",
                        candyCount,
                        math.clamp(tonumber(Halloween.TurnInThreshold) or 20, 1, 45)
                    ))
                end)
            end
            if Halloween.PointsLabel then
                pcall(function()
                    local points = Halloween.readJackPoints()
                    Halloween.PointsLabel:SetDesc(points and (points .. " points") or "Points value not found in player stats yet.")
                end)
            end
        end

        local threshold = math.clamp(math.floor(tonumber(Halloween.TurnInThreshold) or 20), 1, 45)
        if Halloween.AutoTurnIn and candyCount >= threshold
            and not Halloween.TurnInBusy and not State.Selling
            and tick() - (Halloween.LastTurnInAt or 0) >= 1.0 then
            local startingCount = candyCount
            local success, message = MSH.turnInHalloweenCandies()
            if success then
                MSH.halloweenNotify("Halloween Event", message, "Success")
                local waitUntil = tick() + 5
                repeat
                    task.wait(0.2)
                until not Halloween.AutoTurnIn
                    or Halloween.countCandies() < startingCount
                    or tick() >= waitUntil
                task.wait(1.0)
            elseif Halloween.AutoTurnIn then
                task.wait(2.0)
            end
        end
    end
end)

local FarmAutomation = FarmTab:Section({Title = "Automation", Side = "left"})
AFKFarmToggle = FarmAutomation:Toggle({
    Title = "AFK Farm",
    Desc = "Collect all available items, then hop to another public server and repeat.",
    Icon = "zap",
    Value = SH_AUTOSTART,
    Callback = function(state)
        if state then
            State.Farm = true
            State.NoClip = true
            ItemESP.scan()
            SHController:start()
        else
            SHController:stop()
            State.Farm = false
            if State.HalloweenCandyFarm then
                State.NoClip = true
                return
            end
            if FarmVisual.Decoy and not State.Selling then FarmVisual.restoreAtSafe() end
            State.NoClip = false
            local c = LP.Character
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                if h then
                    h:ChangeState(Enum.HumanoidStateType.GettingUp)
                    h:ChangeState(Enum.HumanoidStateType.Running)
                    task.wait(.05)
                    h:ChangeState(Enum.HumanoidStateType.Freefall)
                end
            end
        end
    end,
})

FarmAutomation:Toggle({
    Title = "Auto Sell on Max",
    Desc = "Automatically sell items when they reach their inventory limit.",
    Icon = "package-check",
    Value = true,
    Callback = function(state)
        autoSellMax = state == true
        if autoSellMax then Selling.requestAutoSellMaxCheck() end
    end,
})

FarmAutomation:Toggle({
    Title = "Auto Buy Lucky Arrow",
    Desc = "Automatically purchase a Lucky Arrow when you have at least $75,000.",
    Icon = "shopping-cart",
    Value = Config.AutoBuyLucky,
    Callback = function(state)
        Config.AutoBuyLucky = state == true
        MethionSH_Env.__MethionSHAutoBuyLucky = Config.AutoBuyLucky
        Shop.autoLucky()
    end,
})

local HopSettings = FarmHopSettingsTab:Section({Title = "Server Hopping", Side = "left"})
HopSettings:Paragraph({
    Title = "Hop Interval",
    Desc = "The timer starts once the character is ready and farming begins. When enabled, item depletion alone will not trigger a hop unless early-hop is enabled.",
})
local HopTimerStatus = HopSettings:Paragraph({
    Title = "Hop Timer Status",
    Desc = "Waiting for AFK Farm to start.",
})
task.spawn(function()
    while true do
        task.wait(1)
        local description
        if SHController.Enabled and Config.HopIntervalEnabled then
            local remaining = tonumber(SHStats.HopTimerRemaining)
            description = remaining and (MSH.shFormatDuration(remaining) .. " remaining before the next timed hop.")
                or "The next hop is being prepared."
        elseif SHController.Enabled then
            description = "Timed hopping is disabled. Waiting for the item pool to stay empty."
        else
            description = "AFK Farm is stopped."
        end
        if HopTimerStatus then
            pcall(function() HopTimerStatus:SetDesc(description) end)
        end
    end
end)
HopSettings:Toggle({
    Title = "Hop Interval",
    Desc = "Automatically hop when the selected timer expires. Turn off to hop after the item pool stays empty.",
    Icon = "timer",
    Value = Config.HopIntervalEnabled,
    Callback = function(state)
        Config.HopIntervalEnabled = state == true
        MSH.persistHopSettings()
    end,
})
HopSettings:Dropdown({
    Title = "Hop Interval Unit",
    Desc = "Choose whether the interval amount is seconds, minutes, or hours. Defaults to Seconds.",
    Icon = "clock",
    Values = {"Seconds", "Minutes", "Hours"},
    Value = Config.HopIntervalUnit,
    Multi = false,
    Callback = function(selected)
        if selected == "Seconds" or selected == "Minutes" or selected == "Hours" then
            Config.HopIntervalUnit = selected
            MSH.persistHopSettings()
        end
    end,
})
HopSettings:Slider({
    Title = "Hop Interval Amount",
    Desc = "Set the amount in the selected unit (1–120). Default: 35 seconds.",
    Icon = "timer-reset",
    Value = {Min = 1, Max = 120, Default = Config.HopIntervalAmount},
    Step = 1,
    Callback = function(value)
        Config.HopIntervalAmount = math.clamp(math.floor(tonumber(value) or 35), 1, 120)
        MSH.persistHopSettings()
    end,
})
HopSettings:Toggle({
    Title = "Hop Early When Items Run Out",
    Desc = "Off by default. When enabled, hop after the item pool stays empty for the configured grace period, even before the timer expires.",
    Icon = "package-x",
    Value = Config.HopOnEmpty,
    Callback = function(state)
        Config.HopOnEmpty = state == true
        MSH.persistHopSettings()
    end,
})
HopSettings:Slider({
    Title = "Join / Spawn Grace",
    Desc = "Ignore an empty item list during this startup window while items are being discovered.",
    Icon = "hourglass",
    Value = {Min = 10, Max = 90, Default = Config.StartupGraceSeconds},
    Step = 5,
    Callback = function(value)
        Config.StartupGraceSeconds = math.clamp(math.floor(tonumber(value) or 30), 10, 90)
        MSH.persistHopSettings()
    end,
})
HopSettings:Slider({
    Title = "Empty Pool Grace",
    Desc = "How long the visible item pool must remain empty before an item-depletion hop is allowed.",
    Icon = "package-minus",
    Value = {Min = 5, Max = 90, Default = Config.EmptyGraceSeconds},
    Step = 5,
    Callback = function(value)
        Config.EmptyGraceSeconds = math.clamp(math.floor(tonumber(value) or 15), 5, 90)
        MSH.persistHopSettings()
    end,
})
HopSettings:Slider({
    Title = "Minimum Server Time",
    Desc = "Prevents very short server stays even if a timer or empty-pool condition is met.",
    Icon = "shield-check",
    Value = {Min = 10, Max = 60, Default = Config.MinServerDwellSeconds},
    Step = 5,
    Callback = function(value)
        Config.MinServerDwellSeconds = math.clamp(math.floor(tonumber(value) or 15), 10, 60)
        MSH.persistHopSettings()
    end,
})

local FarmSettings = FarmHopSettingsTab:Section({Title = "Farm Filters", Side = "right"})
FarmSettings:Dropdown({
    Title = "Teleport mode",
    Desc = bypassSupported and "Choose how to move between items." or "Instant isn't available here. Tween is enabled.",
    Icon = "zap",
    Values = bypassSupported and {"Instant", "Tween"} or {"Tween"},
    Value = Config.FarmTeleportMode == "instant" and "Instant" or "Tween",
    Multi = false,
    Callback = function(selected)
        if selected == "Instant" and not bypassSupported then
            Config.FarmTeleportMode = "tween"
            MethionSH_Env.__MethionSHFarmTeleportMode = Config.FarmTeleportMode
            AirflowCompat:Notify({Title = "Instant unavailable", Content = "Instant mode isn't supported here. Tween stays on.", Type = "Warning", Duration = 4})
            return
        end
        Config.FarmTeleportMode = (selected == "Instant" and bypassSupported) and "instant" or "tween"
        MethionSH_Env.__MethionSHFarmTeleportMode = Config.FarmTeleportMode
    end,
})
FarmSettings:Dropdown({
    Title = "Only items to farm",
    Desc = "Choose items to farm. Leave empty to farm everything.",
    Icon = "filter",
    Values = {
        "All items",
        "Mysterious Arrow", "Rokakaka", "Gold Coin", "Diamond", "Stone Mask",
        "Quinton's Glove", "Steel Ball", "Dio's Diary", "Pure Rokakaka",
        "Lucky Arrow", "Lucky Stone Mask", "Rib Cage of The Saint's Corpse",
        "Ancient Scroll", "Caesar's Headband", "Clackers", "Zeppeli's Hat",
        "Christmas Present", "Green Candy", "Red Candy", "Blue Candy", "Yellow Candy",
    },
    Value = #Config.FarmOnlyItems > 0 and Config.FarmOnlyItems or {"All items"},
    Multi = true,
    Callback = function(selected)
        Config.FarmOnlyItems = selected or {}
        MethionSH_Env.__MethionSHFarmOnlyItems = Config.FarmOnlyItems
    end,
})
FarmSettings:Slider({
    Title = "Instant Arrival Delay",
    Desc = "Let the character settle before picking up an item.",
    Icon = "timer",
    Value = {Min = 0.2, Max = 1.0, Default = 0.35},
    Step = 0.05,
    Callback = function(value)
        Config.InstantDelay = math.clamp(tonumber(value) or 0.35, 0.2, 1.0)
    end,
})
FarmSettings:Slider({
    Title = "Tween Speed",
    Desc = "Movement speed when Tween mode is selected.",
    Icon = "gauge",
    Value = {Min = 10, Max = 500, Default = 220},
    Step = 5,
    Callback = function(value)
        Config.TweenSpeed = math.clamp(tonumber(value) or 220, 10, 500)
    end,
})
FarmSettings:Toggle({
    Title = "Boosted",
    Desc = "Faster pickup; may cause kicks. Instant mode only.",
    Icon = "zap",
    Value = false,
    Callback = function(state)
        Config.Boosted = state == true
        if Config.Boosted then
            AirflowCompat:Notify({
                Title = "Boosted enabled",
                Content = "Boosted may cause frequent kicks. Disable it if the server becomes unstable.",
                Type = "Warning",
                Duration = 5,
            })
        end
    end,
})
FarmSettings:Toggle({
    Title = "Reload script on kick",
    Desc = "Rejoin, enter the game, and reload the script after a kick.",
    Icon = "refresh-cw",
    Value = Config.AutoRejoinEnabled,
    Callback = function(state)
        Config.AutoRejoinEnabled = state == true
        MethionSH_Env.__MethionSHReloadOnKick = Config.AutoRejoinEnabled
        if state then Rejoin.start() else Rejoin.stop() end
    end,
})
local FarmViewerSection = FarmTab:Section({Title = "Live Item Target", Side = "right"})
local FarmItemViewerLastTarget = nil
_G.__PhantomFarmItemViewer = FarmViewerSection:Viewer({
    Name = "Auto Farm Item Viewer",
    Desc = "Shows the item Auto Farm is going for.",
    Players = false,
    Height = 240,
    Float = false,
    AutoRotate = true,
    SpinSpeed = 0.7,
    Interactive = true,
    ShowTargetSelector = false,
    ShowTargetSwitch = false,
    ShowPreviousButton = false,
    ShowNextButton = false,
    ShowTargetDropdown = false,
    ShowHint = false,
    ShowToolStrip = false,
    ShowZoomControls = false,
    ShowZoomIn = false,
    ShowZoomOut = false,
    ShowPanToggle = false,
    ShowRotateToggle = false,
    ShowLockFacing = false,
    ShowSpectate = false,
    ShowResetView = false,
    ShowPresets = false,
    ShowFloatButton = false,
    Callback = function(target)
        if target then FarmItemViewerLastTarget = target end
    end,
})
_G.__PhantomQuestFarmSetItemViewerTarget = function(target)
    if typeof(target) ~= "Instance" or not target.Parent then return end
    if target == FarmItemViewerLastTarget then return end
    FarmItemViewerLastTarget = target
    local viewer = _G.__PhantomFarmItemViewer
    if not viewer then return end
    local setMethod
    pcall(function() setMethod = viewer.Set end)
    if type(setMethod) == "function" then
        local ok = pcall(function() setMethod(viewer, target) end)
        if ok then return end
    end
    pcall(function() viewer:Add(target, nil, true) end)
end

local SellTab = Window:Tab({Title = "Selling", Icon = "dollar-sign"})
SellTab:Toggle({
    Title = "Auto Sell on Max",
    Desc = "Sell items when they reach their limit.",
    Icon = "package-check",
    Value = true,
    Callback = function(state)
        autoSellMax = state
        if state then Selling.requestAutoSellMaxCheck() end
    end,
})
SellTab:Dropdown({
    Title = "Auto Sell Items (on Pickup)",
    Desc = "Choose what to sell when picked up.",
    Icon = "package",
    Values = itemOptions,
    Value = {},
    Multi = true,
    Callback = function(selected)
        selectedAutoSellItems = selected or {}
    end,
})
SellTab:Toggle({
    Title = "Auto Sell Selected on Pickup",
    Desc = "Sell selected items automatically.",
    Icon = "mouse-pointer-click",
    Value = false,
    Callback = function(state)
        autoSellSelected = state
    end,
})
SellTab:Dropdown({
    Title = "Select Items to Sell All Now",
    Desc = "Choose items for manual selling.",
    Icon = "list-check",
    Values = itemOptions,
    Value = {},
    Multi = true,
    Callback = function(selected)
        selectedSellAllItems = selected or {}
    end,
})
SellTab:Button({
    Title = "Sell All Selected Now",
    Desc = "Sell the selected items now.",
    Icon = "package-check",
    Callback = function()
        task.spawn(function() Selling.sellAllSelected(selectedSellAllItems) end)
    end,
})
SellTab:Slider({
    Title = "Auto Sell Interval (minutes)",
    Desc = "How often to repeat the sale.",
    Icon = "clock",
    Value = {Min = 1, Max = 10, Default = 3},
    Step = 1,
    Callback = function(value)
        autoSellInterval = math.clamp(tonumber(value) or 3, 1, 10)
    end,
})
SellTab:Toggle({
    Title = "Auto Sell All Selected Loop",
    Desc = "Keep selling selected items on a loop.",
    Icon = "repeat",
    Value = false,
    Callback = function(state)
        autoSellAllSelectedLoop = state
        autoSellLoopToken += 1
        local myToken = autoSellLoopToken
        if state then
            task.spawn(function()
                while autoSellAllSelectedLoop and myToken == autoSellLoopToken do
                    local waitUntil = tick() + (math.clamp(tonumber(autoSellInterval) or 3, 1, 10) * 60)
                    while autoSellAllSelectedLoop and myToken == autoSellLoopToken and tick() < waitUntil do
                        task.wait(0.25)
                    end
                    if not autoSellAllSelectedLoop or myToken ~= autoSellLoopToken then break end
                    local chosen = table.clone(selectedSellAllItems)
                    if #chosen > 0 then
                        local okLoop, errLoop = pcall(Selling.sellAllSelected, chosen)
                        if not okLoop then warn("[Methion] Selected-item sell loop failed: " .. tostring(errLoop)) end
                    end
                end
            end)
        end
    end,
})
SellTab:Divider()
SellTab:Button({
    Title = "Sell All Worthless Items",
    Desc = "Sell coins, diamonds, gloves, hats, headbands, and scrolls.",
    Icon = "hand-coins",
    Callback = function()
        task.spawn(Selling.sellAllWorthless)
    end,
})
SellTab:Button({
    Title = "Sell Inventory",
    Desc = "Sell all sellable items.",
    Icon = "shopping-cart",
    Callback = function()
        task.spawn(Selling.sellInventory)
    end,
})
SellTab:Divider()
SellTab:Button({
    Title = "Convert All Candy",
    Desc = "Turn in all Halloween candy to Jack for points.",
    Icon = "candy",
    Callback = function()
        task.spawn(function()
            local success, message = MSH.turnInHalloweenCandies()
            MSH.halloweenNotify("Halloween Event", message, success and "Success" or "Warning")
        end)
    end,
})

ItemESP.scan()

local NotifiedSpawnParts = setmetatable({}, {__mode = "k"})
Farm.SpawnPromptConnections = Farm.SpawnPromptConnections or setmetatable({}, {__mode = "k"})

function MSH.spawnedItemInfo(obj)
    if not obj then return nil end
    local name, part
    if obj:IsA("ProximityPrompt") then
        name = obj.ObjectText or ""
        if not FARM_ITEMS[name] then return nil end
        part = Utils.basePart(obj)
    elseif obj:IsA("BasePart") and FARM_ITEMS[obj.Name] then
        name, part = obj.Name, obj
    end

    if name and part and not ItemESP.isPlayerOwned(obj, part) then
        return name, part
    end
    return nil
end

function MSH.setBoostedSpawnTarget(itemName, itemPart)
    if not State.Farm or not Config.Boosted or not itemName or not itemPart
        or not itemPart.Parent or not itemPart:IsDescendantOf(workspace)
        or ItemESP.isPlayerOwned(nil, itemPart)
        or not Farm.allowed(itemName) then
        return
    end

    Farm.queueBoostedTarget(itemPart)
end

function Farm.notifySpawnedItem(itemName, itemPart)
    if not itemName or not itemPart then return end
    local spawnKey = itemPart:FindFirstAncestorOfClass("Model") or itemPart
    if not State.NotifyItemSpawn or not Config.NotifyItemSpawn or NotifiedSpawnParts[spawnKey] then return end
    NotifiedSpawnParts[spawnKey] = true
    pcall(function()
        AirflowCompat:Notify({
            Title = "Item Spawned",
            Content = itemName .. " has spawned",
            Icon = "bell",
            Type = "Info",
            Duration = 3,
        })
    end)
end

workspace.DescendantAdded:Connect(function(o)

    if not o or not o.Parent then return end
    if o:IsA("ProximityPrompt") then
        ItemESP.register(o)
        local itemName, itemPart = MSH.spawnedItemInfo(o)
        if itemName then
            MSH.setBoostedSpawnTarget(itemName, itemPart)
            Farm.notifySpawnedItem(itemName, itemPart)
        elseif not Farm.SpawnPromptConnections[o] then
            Farm.SpawnPromptConnections[o] = o:GetPropertyChangedSignal("ObjectText"):Connect(function()
                if not o.Parent then
                    local connection = Farm.SpawnPromptConnections[o]
                    if connection then connection:Disconnect() end
                    Farm.SpawnPromptConnections[o] = nil
                    return
                end
                local lateName, latePart = MSH.spawnedItemInfo(o)
                if lateName and latePart then
                    ItemESP.register(o)
                    MSH.setBoostedSpawnTarget(lateName, latePart)
                    Farm.notifySpawnedItem(lateName, latePart)
                    local connection = Farm.SpawnPromptConnections[o]
                    if connection then connection:Disconnect() end
                    Farm.SpawnPromptConnections[o] = nil
                end
            end)
        end
    elseif o:IsA("BasePart") then
        ItemESP.register(o)
        local itemName, itemPart = MSH.spawnedItemInfo(o)
        if itemName then
            MSH.setBoostedSpawnTarget(itemName, itemPart)
            Farm.notifySpawnedItem(itemName, itemPart)
        end
    end
end)

Rejoin.start()
Loops.noclip()
Loops.farm()
Loops.trackedCleanup()
Loops.pending()

if Config.AutoBuyLucky then
    Shop.autoLucky()
end

task.spawn(function()
    local enterChunk, enterError = loadstring(ENTER_GAME_SOURCE)
    if not enterChunk then
        warn("[AutoPlay] Could not compile enter-game script: " .. tostring(enterError))
        return
    end
    enterChunk()
end)

MethionSH_Env.__MethionSHLoadedJobId = tostring(game.JobId)
MethionSH_Env.__MethionSHReady = true
_G.__MethionSHReady = true
MethionSH_Env.__MethionSHBootstrapActive = false
MethionSH_Env.__MethionSHAutoStart = nil
if SH_AUTOSTART then
    task.defer(function()
        SHController:start()
    end)
end

print("[METHIONSH] MethionSH loaded")

if bypassSupported then
    print("[METHIONSH] Bypass installed successfully")
else
    print("[METHIONSH] Bypass not installed - executor may not support all features")
end

pcall(function()
    AirflowCompat:Notify({Title = "MethionSH", Content = "Loaded!", Icon = "check", Type = "Success", Duration = 3})
end)
