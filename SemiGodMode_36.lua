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
Text = "Infinite Revive",
Default = false,
}):OnChanged(function(v)
T.revive = v
unbind("revive")
if not v then return end
if not isOldFloor() then
notify("Vo han hoi sinh chi hoat dong trong Old Hotels hoac che do Flools !", 1.8)
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
Text = "Delete Figure",
Default = false,
}):OnChanged(function(v)
T.delfig = v
unbind("delfig")
if not v then return end
notify("Chi hoat dong Old Hotels", 1)
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
Text = "Figure Godmode",
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
AntiRight:AddLabel("Semi God = bat moi Anti trong tab", true)
AntiRight:AddToggle("AP_SemiGod", {
Text = "Semi God Mode",
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
notify("Chi hoat dong voi thuc the yeu den trung binh KHONG HOAT DONG VOI ENTITY DUOC BAO VE KI VOI NHA PHAT TRIEN!", 2.0)
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
local function FindVisualTab()
if Svc.VisualTab then return Svc.VisualTab end
local A = getgenv().Abysall
if A then
local Tabs = A.Tabs or (A.Window and A.Window.Tabs)
if Tabs and Tabs.Visual then return Tabs.Visual end
end
local root = AntiLeft
while root and root.Parent do root = root.Parent end
if root then
for _, desc in ipairs(root:GetDescendants()) do
if desc:IsA("TextButton") or desc:IsA("TextLabel") then
if desc.Name == "Visual" or desc.Text == "Visual" then
local tab = desc.Parent and desc.Parent.Parent
if tab then return tab end
end
end
end
end
return nil
end
local HotelsBox = MiscTab:AddRightGroupbox("Hotels","building")
local MineBox = MiscTab:AddLeftGroupbox("The Mine","pickaxe")
local HotelBox = MiscTab:AddLeftGroupbox("Auto Hotel")

-- ===== AUTO HOTEL (fixed) =====
local RED = "#FF3232"

-- Whitelist entity được phép trốn + blacklist entity cùi
local ENTITY_CONFIG = {
    { key = "rush",            wsName = "Rush",             range = 60  },
    { key = "ambush",          wsName = "Ambush",           range = 100 },
    { key = "blizt",           wsName = "BackdoorRush",     range = 60  },
    { key = "a60",             wsName = "A-60",             range = 90  },
    { key = "a120",            wsName = "A-120",            range = 60  },
    { key = "blash",           wsName = "Blash",            range = 100 },
    { key = "glitched_ambush", wsName = "Glitched Ambush",  range = 100 },
    { key = "ar0xmbush",       wsName = "AR0xMBUSH",        range = 170 },
    { key = "glitched_rush",   wsName = "Glitched Rush",    range = 100 },
    { key = "rniushcg",        wsName = "RNIUSHCg==",       range = 100 },
}

local NO_HIDE = {
    "eyes", "lookman", "backdoorlookman",
    "screech", "scjvereECH",
    "halt", "seek", "seek_arm",
    "seekfloodline", "seekingwall", "chandelierobstruction",
}

local NAME_TO_KEY = {
    ["Rush"] = "rush", ["Ambush"] = "ambush",
    ["BackdoorRush"] = "blizt", ["A-60"] = "a60", ["A-120"] = "a120",
    ["Blash"] = "blash", ["Glitched Ambush"] = "glitched_ambush",
    ["AR0xMBUSH"] = "ar0xmbush", ["Glitched Rush"] = "glitched_rush",
    ["RNIUSHCg=="] = "rniushcg",
}

-- HotelBox đã được tạo sẵn phía trên → KHÔNG tạo lại
local AH = {
    Running  = false,
    State    = "Idle",
    LastFire = 0,
    _cache   = { t = 0, entity = nil, dist = math.huge },
}

-------------------------------------------------
-- Lấy cửa đúng từ CurrentRooms[LatestRoom]
-------------------------------------------------
local function AH_GetNextDoor()
    local GD = ReplicatedStorage:FindFirstChild("GameData")
    local LR = GD and GD:FindFirstChild("LatestRoom")
    if not LR then return nil end
    local CR = Workspace:FindFirstChild("CurrentRooms")
    if not CR then return nil end

    local room = CR:FindFirstChild(tostring(LR.Value))
    if not room and LR.Value == 0 then
        room = CR:FindFirstChild("1") or CR:FindFirstChild("0")
    end
    if not room then return nil end

    local door = room:FindFirstChild("Door") or room:FindFirstChild("Door", true)
    if not door then return nil end
    if door:GetAttribute("Open") == true then return nil end
    return door, room
end

-------------------------------------------------
-- Nhận diện entity whitelist / blacklist
-------------------------------------------------
local function AH_IsHideEntity(name)
    local lower = tostring(name or ""):lower()
    for _, n in ipairs(NO_HIDE) do
        if lower == n or lower:find(n, 1, true) then
            return false
        end
    end
    for _, cfg in ipairs(ENTITY_CONFIG) do
        if name == cfg.wsName then
            return true, cfg.key, cfg.range
        end
    end
    return false
end

local function AH_GetNearestHideEntity()
    if tick() - (AH._cache.t or 0) < 0.25 and AH._cache.entity then
        return AH._cache.entity, AH._cache.dist
    end
    local Char = LocalPlayer.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    if not Root then return nil end

    local container = Workspace:FindFirstChild("CurrentRooms") or Workspace
    local best, bestDist = nil, math.huge
    for _, Obj in ipairs(container:GetDescendants()) do
        if Obj:IsA("Model") and Obj.PrimaryPart then
            local ok, _, range = AH_IsHideEntity(Obj.Name)
            if ok then
                local d = (Obj.PrimaryPart.Position - Root.Position).Magnitude
                if d <= (range or 60) and d < bestDist then
                    best, bestDist = Obj, d
                end
            end
        end
    end
    AH._cache.t = tick()
    AH._cache.entity = best
    AH._cache.dist = bestDist
    return best, bestDist
end

-------------------------------------------------
-- Tìm tủ trốn (ưu tiên Prompt Enabled)
-------------------------------------------------
local function AH_GetNearestHidingSpot()
    local Char = LocalPlayer.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    if not Root then return nil, nil end

    local best, bestDist, bestPrompt = nil, 35, nil
    local container = Workspace:FindFirstChild("CurrentRooms") or Workspace
    for _, Obj in ipairs(container:GetDescendants()) do
        if Obj:IsA("Model") then
            local n = Obj.Name:lower()
            if n:find("wardrobe") or n:find("closet") or n:find("locker")
                or n:find("bed") or n:find("hide") or n:find("cabinet") or n:find("drawer") then
                local pp = Obj.PrimaryPart or Obj:FindFirstChildWhichIsA("BasePart")
                if pp then
                    local d = (pp.Position - Root.Position).Magnitude
                    if d < bestDist then
                        local prompt = Obj:FindFirstChild("HidePrompt", true)
                            or Obj:FindFirstChild("HidingPrompt", true)
                            or Obj:FindFirstChild("EnterPrompt", true)
                        if not prompt then
                            for _, D in ipairs(Obj:GetDescendants()) do
                                if D:IsA("ProximityPrompt") and D.Enabled then
                                    prompt = D
                                    break
                                end
                            end
                        end
                        if prompt and prompt.Enabled then
                            best, bestDist, bestPrompt = Obj, d, prompt
                        elseif not bestPrompt then
                            best, bestDist, bestPrompt = Obj, d, prompt
                        end
                    end
                end
            end
        end
    end
    return best, bestPrompt
end

-------------------------------------------------
-- Fire hide (teleport gần prompt rồi kích)
-------------------------------------------------
local function AH_FireHide()
    local Spot, Prompt = AH_GetNearestHidingSpot()
    if not Spot then return false end

    local Char = LocalPlayer.Character
    if not Char then return false end

    -- Đứng gần prompt \~2 studs
    local targetCF
    if Prompt and Prompt.Parent and Prompt.Parent:IsA("BasePart") then
        targetCF = Prompt.Parent.CFrame * CFrame.new(0, 0, -2)
    else
        local pp = Spot.PrimaryPart or Spot:FindFirstChildWhichIsA("BasePart")
        if pp then targetCF = pp.CFrame * CFrame.new(0, 0, -2) end
    end
    if targetCF then
        pcall(function() Char:PivotTo(targetCF) end)
        task.wait(0.15)
    end

    if Prompt then
        pcall(function()
            if fireproximityprompt then
                fireproximityprompt(Prompt)
            else
                Prompt:InputHoldBegin()
                task.wait(Prompt.HoldDuration or 0.2)
                Prompt:InputHoldEnd()
            end
        end)
        return true
    end
    return false
end

-------------------------------------------------
-- Mở cửa + xử lý chìa khoá
-------------------------------------------------
local function AH_FireDoor(Door, Room)
    if not Door then return end

    -- 1) Nếu cửa bị khoá → tìm KeyObtain trong room
    local lock = Door:FindFirstChild("Lock", true)
    local unlockPrompt = lock and lock:FindFirstChild("UnlockPrompt")
    if unlockPrompt and unlockPrompt.Enabled then
        local key = Room and (Room:FindFirstChild("KeyObtain", true) or Room:FindFirstChild("Key", true))
        if key then
            local hit = key:FindFirstChild("Hitbox") or key:FindFirstChildWhichIsA("BasePart")
            if hit then
                pcall(function() LocalPlayer.Character:PivotTo(CFrame.new(hit.Position + Vector3.new(0, 3, 0))) end)
                task.wait(0.2)
                local keyPrompt = key:FindFirstChild("ModulePrompt", true) or key:FindFirstChildWhichIsA("ProximityPrompt", true)
                if keyPrompt then
                    pcall(function()
                        if fireproximityprompt then fireproximityprompt(keyPrompt)
                        else
                            keyPrompt:InputHoldBegin()
                            task.wait(keyPrompt.HoldDuration or 0.2)
                            keyPrompt:InputHoldEnd()
                        end
                    end)
                    task.wait(0.3)
                end
            end
        end
        -- Unlock
        pcall(function()
            if fireproximityprompt then fireproximityprompt(unlockPrompt)
            else
                unlockPrompt:InputHoldBegin()
                task.wait(unlockPrompt.HoldDuration or 0.2)
                unlockPrompt:InputHoldEnd()
            end
        end)
        task.wait(0.25)
    end

    -- 2) Mở cửa bằng ClientOpen (không cần đứng sát)
    local clientOpen = Door:FindFirstChild("ClientOpen")
        or Door:FindFirstChild("ClientOpen", true)
        or (RF() and (RF():FindFirstChild("ClientOpen") or RF():FindFirstChild("ClientOpen", true)))
    if clientOpen and clientOpen:IsA("RemoteEvent") then
        pcall(function() clientOpen:FireServer() end)
    end
end

-------------------------------------------------
-- Kiểm tra đang trốn
-------------------------------------------------
local function AH_IsHiding()
    local Char = LocalPlayer.Character
    if not Char then return false end
    if Char:GetAttribute("Hiding") == true then return true end
    local container = Workspace:FindFirstChild("CurrentRooms") or Workspace
    for _, Obj in ipairs(container:GetDescendants()) do
        if Obj:IsA("Model") then
            local hp = Obj:FindFirstChild("HiddenPlayer", true)
            if hp and hp:IsA("ObjectValue") and hp.Value == Char then
                return true
            end
        end
    end
    return false
end

local function AH_TryRevive()
    local r = RF():FindFirstChild("Revive") or RF():FindFirstChild("Revive", true)
    if r then
        pcall(function() r:FireServer() end)
        return true
    end
    return false
end

local function AH_Unhide()
    local camLock = RF():FindFirstChild("CamLock") or RF():FindFirstChild("CamLock", true)
    if camLock then
        pcall(function() camLock:FireServer() end)
    end
end

-------------------------------------------------
-- Tick chính
-------------------------------------------------
local function AH_Tick()
    if not AH.Running then return end
    local Char = LocalPlayer.Character
    if not Char then return end

    -- Chết → revive
    if LocalPlayer:GetAttribute("Alive") == false then
        AH_TryRevive()
        AH.State = "Revive"
        return
    end

    -- Đang trốn → chờ entity đi
    if AH_IsHiding() then
        local E = AH_GetNearestHideEntity()
        if not E then
            AH_Unhide()
            AH.State = "Idle"
        else
            AH.State = "Wait"
        end
        return
    end

    -- Có entity whitelist gần → trốn (thử tối đa 2 lần)
    local E = AH_GetNearestHideEntity()
    if E then
        local ok = false
        for _ = 1, 2 do
            if AH_FireHide() then
                task.wait(0.6)
                if AH_IsHiding() then
                    ok = true
                    break
                end
            else
                break
            end
        end
        AH.State = ok and "Hide" or "Wait"
        return
    end

    -- Mở cửa kế tiếp
    if tick() - AH.LastFire > 0.35 then
        AH.LastFire = tick()
        local Door, Room = AH_GetNextDoor()
        if Door then
            AH_FireDoor(Door, Room)
            AH.State = "OpenDoor"
        else
            AH.State = "Idle"
        end
    end
end

-------------------------------------------------
-- UI (chỉ Add vào HotelBox đã có)
-------------------------------------------------
HotelBox:AddToggle("AP_AutoHotel", {
    Text = "<font color='" .. RED .. "'>Auto Hotel</font>",
    Default = false,
    Tooltip = "Tự động mở cửa + trốn entity (Rush/Ambush/...)",
}):OnChanged(function(v)
    AH.Running = v
    if v then
        notify("<font color='" .. RED .. "'>Auto Hotel: BẬT</font>", 2)
    end
end)

HotelBox:AddButton({
    Text = "<font color='" .. RED .. "'>Teleport Next Door</font>",
    DoubleClick = false,
    Func = function()
        local Door = AH_GetNextDoor()
        local Char = LocalPlayer.Character
        if Door and Char then
            local pp = Door.PrimaryPart or Door:FindFirstChildWhichIsA("BasePart")
            if pp then
                -- Đứng LÙI 3 studs trước cửa, không đứng giữa cửa
                Char:PivotTo(pp.CFrame * CFrame.new(0, 0, 3))
            end
        end
    end,
})

task.spawn(function()
    while true do
        task.wait(0.12)
        if AH.Running then
            pcall(AH_Tick)
        end
    end
end)
-- ===== END AUTO HOTEL =====

task.spawn(function()
    task.wait(0.6)
    local function ReplaceIcon(gb, glyph)
        for _, d in gb:GetDescendants() do
            if d:IsA("ImageLabel") and (d.Name == "Icon" or d.Name == "IconLabel" or d.Name == "Logo") then
                d.Visible = false
                d.ImageTransparency = 1
                local L = Instance.new("TextLabel")
                L.Name = "GlyphIcon"
                L.BackgroundTransparency = 1
                L.Size = d.Size
                L.Position = d.Position
                L.AnchorPoint = d.AnchorPoint
                L.Font = Enum.Font.GothamBold
                L.TextSize = 14
                L.TextColor3 = Color3.fromRGB(255, 255, 255)
                L.Text = glyph
                L.Parent = d.Parent
                return
            end
        end
    end
    pcall(ReplaceIcon, HotelsBox, "HOTEL")
    pcall(ReplaceIcon, MineBox, "MINE")
end)

local VisualTab = FindVisualTab()
if VisualTab then
    local VfxBox = VisualTab:AddRightGroupbox("Effects & Protection", "eye")
    local vfx = { enabled = false, transparency = 0.5, saved = {} }

    local function vfxApplyHiding()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local n = obj.Name:lower()
                if n:find("wardrobe") or n:find("closet") or n:find("locker") or n:find("hide") then
                    local hidden = obj:FindFirstChild("HiddenPlayer", true)
                    local isHiding = hidden and hidden.Value == LocalPlayer.Character
                    for _, p in ipairs(obj:GetDescendants()) do
                        if p:IsA("BasePart") then
                            if vfx.saved[p] == nil then vfx.saved[p] = p.Transparency end
                            p.Transparency = (vfx.enabled and isHiding) and vfx.transparency or vfx.saved[p]
                        end
                    end
                end
            end
        end
    end

-- [FIX-3] VfxTransparentHiding
VfxBox:AddToggle("VfxTransparentHiding", {
    Text = "Transparent Hiding Spots",
    Default = false,
    Tooltip = "Tu trong suot khi ban dang tron ben trong.",
}):OnChanged(function(v)
    vfx.enabled = v
    if v then
        C.vfxConn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local cr = Workspace:FindFirstChild("CurrentRooms")
            if not cr then return end
            local hiding = false
            for _, obj in ipairs(cr:GetDescendants()) do
                if obj:IsA("Model") then
                    local hp = obj:FindFirstChild("HiddenPlayer", true)
                    if hp and hp:IsA("ObjectValue") and hp.Value == char then
                        hiding = true
                        for _, part in ipairs(obj:GetDescendants()) do
                            if part:IsA("BasePart") then
                                if vfx.saved[part] == nil then
                                    vfx.saved[part] = part.Transparency
                                end
                                part.Transparency = vfx.transparency
                            end
                        end
                    end
                end
            end
            if not hiding then
                for p, o in pairs(vfx.saved) do
                    if p and p.Parent then
                        p.Transparency = o
                    end
                end
                table.clear(vfx.saved)
            end
        end)
    else
        if C.vfxConn then
            C.vfxConn:Disconnect()
            C.vfxConn = nil
        end
        for p, o in pairs(vfx.saved) do
            if p and p.Parent then
                p.Transparency = o
            end
        end
        table.clear(vfx.saved)
    end
end)

VfxBox:AddSlider("VfxTransparencySlider", {
    Text = "Transparency",
    Min = 0, Max = 1, Default = 0.5,
    Rounding = 2, Compact = true,
}):OnChanged(function(v)
    vfx.transparency = v
    if vfx.enabled then vfxApplyHiding() end
end)

VfxBox:AddDivider()

local function disableModule(name, disable)
    local ui = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
    local rl = ui and ui:FindFirstChild("Initiator") and ui.Initiator:FindFirstChild("Main_Game")
        and ui.Initiator.Main_Game:FindFirstChild("RemoteListener")
    if not rl then return end
    local mods = rl:FindFirstChild("Modules")
    if not mods then return end
    local m = mods:FindFirstChild(name) or mods:FindFirstChild(name .. "_Disabled")
    if m then
        if not m:GetAttribute("OrigName") then m:SetAttribute("OrigName", name) end
        m.Name = disable and (name .. "_Disabled") or name
    end
end

VfxBox:AddToggle("VfxDisableGlitchJumpscare", {
    Text = "Disable Glitch Jumpscare",
    Default = false,
}):OnChanged(function(v) pcall(disableModule, "Glitch", v) end)

VfxBox:AddToggle("VfxDisableTimothyJumpscare", {
    Text = "Disable Timothy Jumpscare",
    Default = false,
}):OnChanged(function(v) pcall(disableModule, "SpiderJumpscare", v) end)

VfxBox:AddToggle("VfxDisableVoidJumpscare", {
    Text = "Disable Void Jumpscare",
    Default = false,
}):OnChanged(function(v) pcall(disableModule, "Void", v) end)
VfxBox:AddToggle("VfxDisableHideVignette", {
Text = "Disable Hide Vignette",
Default = false,
}):OnChanged(function(v)
local ui = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
local mf = ui and ui:FindFirstChild("MainFrame")
local vig = ui and ui:FindFirstChild("HideVignette") or (mf and mf:FindFirstChild("HideVignette"))
if vig then
if v then
if not vig:GetAttribute("OrigImage") then vig:SetAttribute("OrigImage", vig.Image) end
vig.Image = "Disabled"
else
local orig = vig:GetAttribute("OrigImage") or "rbxassetid://6100076320"
vig.Image = orig
end
end
end)
-- [FIX-1] VfxDisableFiredamp
VfxBox:AddToggle("VfxDisableFiredamp", {
Text = "Disable Firedamp Effect",
Default = false,
}):OnChanged(function(v)
if v then
C.firedampConn = RunService.Heartbeat:Connect(function()
local cr = Workspace:FindFirstChild("CurrentRooms")
if cr then
for _, room in ipairs(cr:GetChildren()) do
if room:GetAttribute("Firedamp") ~= false then
room:SetAttribute("Firedamp", false)
end
end
end
local cam = Workspace.CurrentCamera
if cam then
for _, obj in ipairs(cam:GetChildren()) do
if obj.Name == "LiveFiredamp" then
obj:Destroy()
end
end
end
end)
else
if C.firedampConn then
C.firedampConn:Disconnect()
C.firedampConn = nil
end
end
end)
-- [FIX-2] VfxDisableEntityJumpscares
VfxBox:AddToggle("VfxDisableEntityJumpscares", {
Text = "Disable Entity Jumpscares",
Default = false,
}):OnChanged(function(v)
local ui = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
local rl = ui and ui:FindFirstChild("Initiator") and ui.Initiator:FindFirstChild("Main_Game")
and ui.Initiator.Main_Game:FindFirstChild("RemoteListener")
if not rl then return end
if v then
local js = rl:FindFirstChild("Jumpscares")
if js then js.Name = "Jumpscares_Disabled" end
local mods = rl:FindFirstChild("Modules")
if mods then
for _, mod in ipairs(mods:GetDescendants()) do
if mod:IsA("ModuleScript") then
local n = mod.Name
if n:find("Jumpscare") or n == "Glitch" or n == "Void" or n == "SpiderJumpscare" or n == "FigureJumpscare" then
if not mod:GetAttribute("OrigName") then
mod:SetAttribute("OrigName", mod.Name)
end
if not mod.Name:find("_Disabled") then
mod.Name = mod.Name .. "_Disabled"
end
end
end
end
if C.jsConn then C.jsConn:Disconnect() end
C.jsConn = mods.ChildAdded:Connect(function(c)
task.wait(0.1)
if c:IsA("ModuleScript") then
local n = c.Name
if n:find("Jumpscare") or n == "Glitch" or n == "Void" or n == "SpiderJumpscare" or n == "FigureJumpscare" then
if not c:GetAttribute("OrigName") then
c:SetAttribute("OrigName", c.Name)
end
if not c.Name:find("_Disabled") then
c.Name = c.Name .. "_Disabled"
end
end
end
end)
end
else
if C.jsConn then
C.jsConn:Disconnect()
C.jsConn = nil
end
local js = rl:FindFirstChild("Jumpscares_Disabled")
if js then js.Name = "Jumpscares" end
local mods = rl:FindFirstChild("Modules")
if mods then
for _, mod in ipairs(mods:GetDescendants()) do
if mod:IsA("ModuleScript") then
local orig = mod:GetAttribute("OrigName")
if orig then
mod.Name = orig
mod:SetAttribute("OrigName", nil)
end
end
end
end
end
end)
end
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
notify("Library Code: nil (khong o phong 50)", 5)
return
end
if not Code or Code:find("_") or #Code < 5 then
notify("Library Code: nil (chua du hint)", 5)
return
end
notify("Library Code: " .. Code, 8)
end,
})
HotelsBox:AddToggle("MiscAutoHeartbeat", {
Text = "Auto Heartbeat Minigame",
Default = false,
}):OnChanged(function(v)
MISC.heartbeat = v
if v then
C.heartbeat = RunService.Heartbeat:Connect(function()
if not MISC.heartbeat then return end
local ui = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
local hb = ui and ui:FindFirstChild("Heartbeat")
if hb and hb.Visible then
local bar = hb:FindFirstChild("Bar") or hb:FindFirstChild("Progress")
if bar then
pcall(function()
local r = RF():FindFirstChild("Heartbeat") or RF():FindFirstChild("HeartbeatMinigame")
if r then r:FireServer() end
end)
end
end
end)
else
if C.heartbeat then C.heartbeat:Disconnect() C.heartbeat = nil end
end
end)
MineBox:AddToggle("MiscAutoAnchors", {
Text = "Auto Anchors",
Default = false,
}):OnChanged(function(v)
MISC.anchors = v
if v then
C.anchors = RunService.Heartbeat:Connect(function()
if not MISC.anchors then return end
local CR = Workspace:FindFirstChild("CurrentRooms")
if not CR then return end
for _, room in ipairs(CR:GetChildren()) do
for _, obj in ipairs(room:GetDescendants()) do
if obj.Name == "Anchor" and obj:IsA("Model") then
local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
if prompt and prompt.Enabled then
pcall(function()
if fireproximityprompt then
fireproximityprompt(prompt)
else
prompt:InputHoldBegin()
task.wait(prompt.HoldDuration or 0.1)
prompt:InputHoldEnd()
end
end)
end
end
end
end
end)
else
if C.anchors then C.anchors:Disconnect() C.anchors = nil end
end
end)
MineBox:AddToggle("MiscAutoSteerMinecart", {
Text = "Auto Steer Minecart",
Default = false,
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
