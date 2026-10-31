return function(AntiLeft, AntiRight, Obsidian, Svc)
local Workspace = Svc.Workspace
local RunService = Svc.RunService
local ReplicatedStorage = Svc.ReplicatedStorage
local Players = Svc.Players
local LocalPlayer = Svc.LocalPlayer
local SoundService = game:GetService("SoundService")

local T, C, TOGS = {}, {}, {}

local function notify(msg, t)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://3318713980"
        s.Volume = 8
        s.Parent = SoundService
        s:Play()
        task.delay(2.2, function() if s then s:Destroy() end end)
    end)
    pcall(function()
        Obsidian:Notify({ Title = "Anti", Description = msg, Time = t or 2 })
    end)
end

local function RF()
    return ReplicatedStorage:FindFirstChild("RemotesFolder")
        or ReplicatedStorage:FindFirstChild("EntityInfo")
        or ReplicatedStorage:FindFirstChild("Bricks")
        or ReplicatedStorage
end

local function fireMotor()
    local mr = RF():FindFirstChild("MotorReplication") or RF():FindFirstChild("MotorReplication", true)
    if mr then pcall(function() mr:FireServer(-650) end) end
end

local function setTouch(inst, on)
    if not inst then return end
    if inst:IsA("BasePart") then pcall(function() inst.CanTouch = on end) end
    for _, p in ipairs(inst:GetDescendants()) do
        if p:IsA("BasePart") then pcall(function() p.CanTouch = on end) end
    end
end

local function setCollide(inst, on)
    if not inst then return end
    if inst:IsA("BasePart") then pcall(function() inst.CanCollide = on end) end
    for _, p in ipairs(inst:GetDescendants()) do
        if p:IsA("BasePart") then pcall(function() p.CanCollide = on end) end
    end
end

local function floorName()
    local gd = ReplicatedStorage:FindFirstChild("GameData")
    local f = gd and gd:FindFirstChild("Floor")
    local name = f and tostring(f.Value) or ""
    local rf = RF()
    if name == "Hotel" and rf and rf.Name == "Bricks" then name = "OldHotel" end
    return name
end

local function isOldFloor()
    local n = floorName()
    return n == "OldHotel" or n == "Fools"
end

local function bindDesc(key, filter)
    if C[key] then C[key]:Disconnect() end
    C[key] = Workspace.DescendantAdded:Connect(function(obj)
        task.defer(function() if T[key] then filter(obj) end end)
    end)
    for _, obj in ipairs(Workspace:GetDescendants()) do filter(obj) end
end

local function unbind(key)
    if C[key] then C[key]:Disconnect() C[key] = nil end
end

local function addTog(side, id, text, key, onEnable, onDisable)
    local tog = side:AddToggle(id, { Text = text, Default = false })
    TOGS[key] = tog
    tog:OnChanged(function(v)
        T[key] = v
        if v then onEnable() else onDisable() end
    end)
    return tog
end

addTog(AntiLeft, "AP_Eyes", "Anti Eyes", "eyes", function()
    unbind("eyesHB")
    C.eyesHB = RunService.Heartbeat:Connect(function()
        if T.eyes and (Workspace:FindFirstChild("Eyes") or Workspace:FindFirstChild("Lookman")) then fireMotor() end
    end)
end, function() unbind("eyesHB") end)

addTog(AntiLeft, "AP_Lookman", "Anti Lookman", "lookman", function()
    unbind("lookHB")
    C.lookHB = RunService.Heartbeat:Connect(function()
        if T.lookman and (Workspace:FindFirstChild("BackdoorLookman") or Workspace:FindFirstChild("Lookman")) then fireMotor() end
    end)
end, function() unbind("lookHB") end)

addTog(AntiLeft, "AP_Giggle", "Anti Giggle", "giggle", function()
    bindDesc("giggle", function(obj)
        if obj.Name == "GiggleCeiling" then
            local h = obj:FindFirstChild("Hitbox"); if h then h.CanTouch = false end
        end
    end)
end, function() unbind("giggle") end)

addTog(AntiLeft, "AP_Dupe", "Anti Dupe", "dupe", function()
    bindDesc("dupe", function(obj)
        if obj.Name == "DoorFake" or obj.Name == "FakeDoor" then
            local h = obj:FindFirstChild("Hidden"); if h then h.CanTouch = false end
            local lock = obj:FindFirstChild("Lock")
            if lock and lock:FindFirstChild("UnlockPrompt") then lock.UnlockPrompt.Enabled = false end
        end
    end)
end, function() unbind("dupe") end)

addTog(AntiLeft, "AP_Vacuum", "Anti Vacuum", "vacuum", function()
    bindDesc("vacuum", function(obj)
        if obj.Name == "SideroomSpace" then
            local col = obj:FindFirstChild("Collision")
            if col then col.CanCollide = true; col.CanTouch = false end
        end
    end)
end, function() unbind("vacuum") end)

addTog(AntiLeft, "AP_Snare", "Anti Snare", "snare", function()
    bindDesc("snare", function(obj) if obj.Name == "Snare" then setTouch(obj, false) end end)
end, function() unbind("snare") end)

addTog(AntiLeft, "AP_Jeff", "Anti Jeff", "jeff", function()
    bindDesc("jeff", function(obj)
        if obj.Name == "JeffTheKiller" then
            setTouch(obj, false); setCollide(obj, false)
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum.Health = 0 end) end
        end
    end)
end, function() unbind("jeff") end)

addTog(AntiLeft, "AP_Banana", "Anti Banana", "banana", function()
    bindDesc("banana", function(obj)
        if obj.Name == "BananaPeel" or obj.Name == "NannerPeel" then setTouch(obj, false) end
    end)
end, function() unbind("banana") end)

addTog(AntiRight, "AP_Gloom", "Anti Gloombat Eggs", "gloom", function()
    bindDesc("gloom", function(obj)
        if obj.Name == "GloomPile" or obj.Name:lower():find("gloombat") then setTouch(obj, false) end
    end)
end, function() unbind("gloom") end)

addTog(AntiRight, "AP_Kill", "Anti Killbrick", "kill", function()
    bindDesc("kill", function(obj)
        if obj.Name == "Lava" or obj.Name:lower():find("killbrick") then
            if obj:IsA("BasePart") then obj.CanTouch = false end
        end
    end)
end, function() unbind("kill") end)

addTog(AntiRight, "AP_ScaryWall", "Anti Seeking Wall", "wall", function()
    bindDesc("wall", function(obj)
        if obj.Name == "ScaryWall" then setTouch(obj, false); setCollide(obj, false) end
    end)
end, function() unbind("wall") end)

addTog(AntiRight, "AP_SeekObs", "Anti Seek Obstructions", "seekobs", function()
    bindDesc("seekobs", function(obj)
        if obj.Name == "Seek_Arm" or obj.Name == "ChandelierObstruction" then setTouch(obj, false)
        elseif obj.Name == "SeekFloodline" and obj:IsA("BasePart") then obj.CanCollide = true end
    end)
end, function() unbind("seekobs") end)

AntiRight:AddToggle("AP_InfRevive", {
    Text = "<font color='#FF3232'>Infinite Revive</font>",
    Default = false,
}):OnChanged(function(v)
    T.revive = v
    unbind("revive")
    if not v then return end
    if not isOldFloor() then
        notify("<font color='#FF3232'>Vo han hoi sinh chi hoat dong trong Old Hotels hoac che do Flools !</font>", 1.8)
    end
    C.revive = LocalPlayer:GetAttributeChangedSignal("Alive"):Connect(function()
        if not T.revive then return end
        if LocalPlayer:GetAttribute("Alive") == false and isOldFloor() then
            task.spawn(function()
                while T.revive and LocalPlayer:GetAttribute("Alive") ~= true do
                    local r = RF():FindFirstChild("Revive") or RF():FindFirstChild("Revive", true)
                    if r then pcall(function() r:FireServer() end) end
                    task.wait(0.5)
                end
            end)
        end
    end)
end)

AntiRight:AddToggle("AP_DelFigure", {
    Text = "<font color='#FF3232'>Delete Figure</font>",
    Default = false,
}):OnChanged(function(v)
    T.delfig = v
    unbind("delfig")
    if not v then return end
    notify("<font color='#FF3232'>Chi hoat dong Old Hotels</font>", 1)
    local function nuke(obj)
        if not (obj.Name == "Figure" or obj.Name == "FigureRig" or obj.Name == "FigureRagdoll") then return end
        if not isOldFloor() then return end
        for _, p in ipairs(obj:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
                pcall(function()
                    if isnetworkowner and isnetworkowner(p) then
                        p.Position = Vector3.new(math.random(-29999,29999), -49999, math.random(-29999,29999))
                    end
                end)
            end
        end
    end
    bindDesc("delfig", nuke)
end)

AntiRight:AddToggle("AP_FigGod", {
    Text = "<font color='#FF3232'>Figure Godmode</font>",
    Default = false,
}):OnChanged(function(v)
    T.figgod = v
    unbind("figgod")
    if not v then return end
    C.figgod = RunService.Heartbeat:Connect(function()
        if not T.figgod then return end
        local c = LocalPlayer.Character
        local h = c and c:FindFirstChild("HumanoidRootPart")
        if not h then return end
        local near = false
        for _, o in ipairs(Workspace:GetDescendants()) do
            if (o.Name == "Figure" or o.Name == "FigureRig" or o.Name == "FigureRagdoll") and o:IsA("Model") and o.PrimaryPart then
                if (h.Position - o.PrimaryPart.Position).Magnitude < 30 then near = true break end
            end
        end
        if near then
            local col = c:FindFirstChild("Collision")
            if col then col.Position = h.Position + Vector3.new(0, 200, 0) end
            setTouch(c, false)
        end
    end)
end)

AntiRight:AddLabel("<font color='#FF3232'>Semi God = bat moi Anti trong tab</font>", true)
AntiRight:AddToggle("AP_SemiGod", {
    Text = "<font color='#FF3232'>Semi God Mode</font>",
    Default = false,
}):OnChanged(function(v)
    local order = {
        "eyes","lookman","giggle","dupe","vacuum","snare","jeff","banana",
        "gloom","kill","wall","seekobs",
    }
    for _, k in ipairs(order) do
        local tog = TOGS[k]
        if tog then
            pcall(function()
                if tog.SetValue then tog:SetValue(v)
                elseif tog.Set then tog:Set(v) end
            end)
            T[k] = v
        end
    end
    if v then
        notify("<font color='#FF3232'>Chi hoat dong voi thuc the yeu den trung binh KHONG HOAT DONG VOI ENTITY DUOC BAO VE KI VOI NHA PHAT TRIEN!</font>", 2.0)
    end
end)

local Camera = Workspace.CurrentCamera
local gd = ReplicatedStorage:FindFirstChild("GameData")
local LatestRoom = gd and gd:FindFirstChild("LatestRoom")

local function FindMiscTab()
    if Svc.MiscTab then return Svc.MiscTab end
    local A = getgenv().Abysall
    if A then
        local Tabs = A.Tabs or (A.Window and A.Window.Tabs)
        if Tabs and Tabs.Misc then return Tabs.Misc end
    end
    local root = AntiLeft
    while root and root.Parent do root = root.Parent end
    if root then
        for _, desc in ipairs(root:GetDescendants()) do
            if desc:IsA("TextButton") or desc:IsA("TextLabel") then
                if desc.Name == "Misc" or desc.Text == "Misc" then
                    local tab = desc.Parent and desc.Parent.Parent
                    if tab then return tab end
                end
            end
        end
    end
    return AntiLeft.Parent or AntiRight.Parent
end

local MiscTab = FindMiscTab()
local HotelsBox = MiscTab:AddRightGroupbox("Hotels")
local MineBox = MiscTab:AddLeftGroupbox("The Mine")

task.spawn(function()
    task.wait(0.6)
    local function ReplaceIcon(gb, id)
        for _, d in gb:GetDescendants() do
            if d:IsA("ImageLabel") and (d.Name == "Icon" or d.Name == "IconLabel" or d.Name == "Logo") then
                d.Image = id
                d.ImageColor3 = Color3.fromRGB(255, 255, 255)
                return
            end
        end
    end
    ReplaceIcon(HotelsBox, "rbxassetid://6031075936")
    ReplaceIcon(MineBox, "rbxassetid://6031091004")
end)

local function GetLibraryCode()
    local char = LocalPlayer.Character
    if not char then return nil end
    local paper = char:FindFirstChild("LibraryHintPaper")
        or char:FindFirstChild("LibraryHintPaperHard")
        or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper")
        or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaperHard")
    if not paper or not paper:FindFirstChild("UI") then return nil end
    local perm = LocalPlayer.PlayerGui:FindFirstChild("PermUI")
    local hints = perm and perm:FindFirstChild("Hints")
    if not hints then return nil end
    local codeLen = (floorName() == "Fools") and 10 or 5
    local code = {}
    for i = 1, codeLen do code[i] = "_" end
    for _, hint in ipairs(hints:GetChildren()) do
        if hint:IsA("ImageLabel") then
            for _, ui in ipairs(paper.UI:GetChildren()) do
                if ui:IsA("ImageLabel") and hint.ImageRectOffset == ui.ImageRectOffset and code[tonumber(ui.Name)] then
                    code[tonumber(ui.Name)] = hint.TextLabel.Text
                end
            end
        end
    end
    return table.concat(code)
end

local MISC = { breaker = false, heartbeat = false, anchors = false, minecart = false, minecartY = 0 }

HotelsBox:AddToggle("MiscAutoBreakerBox", {
    Text = "Auto Breaker Box",
    Default = false,
}):OnChanged(function(v)
    MISC.breaker = v
    if v then
        local CR = Workspace:FindFirstChild("CurrentRooms")
        local Breaker = CR and CR:FindFirstChild("ElevatorBreaker", true)
        if Breaker then
            notify("Interact voi hop cau chi. No se tu giai.", 3)
            local sg = Breaker:FindFirstChild("SurfaceGui")
            if sg and sg:FindFirstChild("Frame") and sg.Frame:FindFirstChild("Code") then
                if C.breakerConn then C.breakerConn:Disconnect() end
                C.breakerConn = sg.Frame.Code:GetPropertyChangedSignal("Text"):Connect(function()
                    if not MISC.breaker then return end
                    local ebf = RF():FindFirstChild("EBF")
                    if ebf then pcall(function() ebf:FireServer() end) end
                end)
            end
        end
    else
        if C.breakerConn then C.breakerConn:Disconnect() C.breakerConn = nil end
    end
end)

HotelsBox:AddButton({
    Text = "Test Library Code",
    DoubleClick = false,
    Func = function()
        local Code = GetLibraryCode()
        local Room = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0
        local IsRoom50 = (Room == 50) or (LatestRoom and LatestRoom.Value == 50)
        if not IsRoom50 then
            notify("Library Code: <font color='#FF3232'>nil</font> (khong o phong 50)", 5)
            return
        end
        if not Code or Code:find("_") or #Code < 5 then
            notify("Library Code: <font color='#FF3232'>nil</font> (chua doan duoc ma)", 5)
            return
        end
        notify("Library Code: " .. Code, 8)
    end,
})

HotelsBox:AddToggle("MiscAutoHeartbeatMinigame", {
    Text = "<font color='#FF3232'>Auto Heartbeat Minigame</font>",
    Default = false,
    Disabled = not (hookmetamethod and newcclosure and getnamecallmethod),
    DisabledTooltip = "Executor khong ho tro hookmetamethod.",
}):OnChanged(function(v)
    MISC.heartbeat = v
    if not v then return end
    if not (hookmetamethod and newcclosure and getnamecallmethod) then return end
    if C.heartbeatHook then return end
    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
        local Args = {...}
        local Method = getnamecallmethod()
        if MISC.heartbeat and (Self.Name == "ClutchHeartbeat" or Self.Name == "HideMonster") and Method == "FireServer" then
            return
        end
        return old(Self, table.unpack(Args))
    end))
    C.heartbeatHook = old
end)

MineBox:AddToggle("MiscAutoSolveAnchors", {
    Text = "Auto Solve Anchors",
    Default = false,
}):OnChanged(function(v)
    MISC.anchors = v
    if C.anchorConn then C.anchorConn:Disconnect() C.anchorConn = nil end
    if not v then return end
    C.anchorConn = RunService.Heartbeat:Connect(function()
        if not MISC.anchors then return end
        if floorName() ~= "Mines" then return end
        local perm = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
        local hint = perm and perm:FindFirstChild("AnchorHintFrame")
        if not hint then return end
        local CR = Workspace:FindFirstChild("CurrentRooms")
        if not CR then return end
        local code = hint:FindFirstChild("Code")
        if not code or code.Text == "" then return end
        for _, room in ipairs(CR:GetChildren()) do
            for _, obj in ipairs(room:GetDescendants()) do
                if obj.Name == "MinesAnchor" and obj.PrimaryPart
                    and not obj:GetAttribute("Activated") and not obj:GetAttribute("Abysall_Solved") then
                    if LocalPlayer:DistanceFromCharacter(obj.PrimaryPart.Position) < 15 then
                        local Remote = obj:FindFirstChild("AnchorRemote")
                        if Remote then
                            pcall(function() Remote:InvokeServer(code.Text) end)
                            obj:SetAttribute("Abysall_Solved", true)
                        end
                    end
                end
            end
        end
    end)
end)

MineBox:AddToggle("MiscAutoSteerMinecart", {
    Text = "Auto Steer Minecart",
    Default = false,
    Disabled = not require,
}):OnChanged(function(v)
    MISC.minecart = v
end)

MineBox:AddSlider("MiscAutoSteerMinecartY", {
    Text = "Minecart Y Offset",
    Min = -10, Max = 10, Default = 0,
    Rounding = 1, Compact = true,
}):OnChanged(function(v)
    MISC.minecartY = v
    local Rig = Camera and Camera:FindFirstChild("MinecartRig")
    if Rig and Rig.PrimaryPart then
        if not Rig:GetAttribute("Abysall_OrigY") then
            Rig:SetAttribute("Abysall_OrigY", Rig.PrimaryPart.Position.Y)
        end
        local applied = Rig:GetAttribute("Abysall_AppliedY") or 0
        Rig.PrimaryPart.CFrame = Rig.PrimaryPart.CFrame + Vector3.new(0, v - applied, 0)
        Rig:SetAttribute("Abysall_AppliedY", v)
    end
end)

if require then
    task.spawn(function()
        local PlayerModule = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 9e9)
        local Controls = require(PlayerModule):GetControls()
        local OrigGetMoveVector = Controls.GetMoveVector
        Controls.GetMoveVector = function(...)
            if MISC.minecart and floorName() == "Mines" then
                local camera = Workspace.CurrentCamera
                if camera and camera:FindFirstChild("MinecartRig") then
                    local nodes = Workspace:FindFirstChild("CurrentRooms")
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root and nodes then
                        local best, bestDist = nil, math.huge
                        for _, room in ipairs(nodes:GetChildren()) do
                            for _, n in ipairs(room:GetDescendants()) do
                                if n.Name == "MinecartNode" and n:IsA("BasePart") and n:GetAttribute("Turn") then
                                    local d = (n.Position - root.Position).Magnitude
                                    if d < bestDist and d < 30 then bestDist = d best = n end
                                end
                            end
                        end
                        if best then
                            local turn = best:GetAttribute("Turn")
                            if turn == "Left" then return Vector3.new(-1, 0, 0) end
                            if turn == "Right" then return Vector3.new(1, 0, 0) end
                        end
                    end
                end
            end
            return OrigGetMoveVector(...)
        end
    end)
end
end
