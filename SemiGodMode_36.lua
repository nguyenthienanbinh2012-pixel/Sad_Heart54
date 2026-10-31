return function(AntiLeft, AntiRight, Obsidian, Svc)
local Workspace = Svc.Workspace
local RunService = Svc.RunService
local ReplicatedStorage = Svc.ReplicatedStorage
local Players = Svc.Players
local LocalPlayer = Svc.LocalPlayer
local SoundService = game:GetService("SoundService")

local T = {}
local C = {}

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
    if inst:IsA("BasePart") then
        pcall(function() inst.CanTouch = on end)
    end
    for _, p in ipairs(inst:GetDescendants()) do
        if p:IsA("BasePart") then pcall(function() p.CanTouch = on end) end
    end
end

local function setCollide(inst, on)
    if not inst then return end
    for _, p in ipairs(inst:GetDescendants()) do
        if p:IsA("BasePart") then pcall(function() p.CanCollide = on end) end
    end
    if inst:IsA("BasePart") then pcall(function() inst.CanCollide = on end) end
end

local function bindDesc(key, filter)
    if C[key] then C[key]:Disconnect() end
    C[key] = Workspace.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if T[key] then filter(obj) end
        end)
    end)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        filter(obj)
    end
end

local function unbind(key)
    if C[key] then C[key]:Disconnect() C[key] = nil end
end

-- ========== LEFT: ENTITY ==========
-- Eyes (MotorReplication -650)
AntiLeft:AddToggle("AP_Eyes", {
    Text = "Anti Eyes", Default = false, Tooltip = "MotorReplication bypass Eyes",
}):OnChanged(function(v)
    T.eyes = v
    unbind("eyesHB")
    if not v then return end
    C.eyesHB = RunService.Heartbeat:Connect(function()
        if not T.eyes then return end
        if Workspace:FindFirstChild("Eyes") or Workspace:FindFirstChild("Lookman") then
            fireMotor()
        end
    end)
end)

-- Lookman
AntiLeft:AddToggle("AP_Lookman", {
    Text = "Anti Lookman", Default = false, Tooltip = "MotorReplication bypass Lookman",
}):OnChanged(function(v)
    T.lookman = v
    unbind("lookHB")
    if not v then return end
    C.lookHB = RunService.Heartbeat:Connect(function()
        if not T.lookman then return end
        if Workspace:FindFirstChild("BackdoorLookman") or Workspace:FindFirstChild("Lookman") then
            fireMotor()
        end
    end)
end)

-- Giggle
AntiLeft:AddToggle("AP_Giggle", {
    Text = "Anti Giggle", Default = false, Tooltip = "Tat CanTouch Hitbox Giggle",
}):OnChanged(function(v)
    T.giggle = v
    local function f(obj)
        if obj.Name == "GiggleCeiling" then
            local h = obj:FindFirstChild("Hitbox")
            if h then h.CanTouch = not v end
        end
    end
    if v then bindDesc("giggle", f) else unbind("giggle") end
end)

-- Dupe
AntiLeft:AddToggle("AP_Dupe", {
    Text = "Anti Dupe", Default = false, Tooltip = "Chan DoorFake / FakeDoor",
}):OnChanged(function(v)
    T.dupe = v
    local function f(obj)
        if obj.Name == "DoorFake" or obj.Name == "FakeDoor" then
            local h = obj:FindFirstChild("Hidden")
            if h then h.CanTouch = not v end
            local lock = obj:FindFirstChild("Lock")
            if lock and lock:FindFirstChild("UnlockPrompt") then
                lock.UnlockPrompt.Enabled = not v
            end
        end
    end
    if v then bindDesc("dupe", f) else unbind("dupe") end
end)

-- Vacuum
AntiLeft:AddToggle("AP_Vacuum", {
    Text = "Anti Vacuum", Default = false, Tooltip = "SideroomSpace Collision",
}):OnChanged(function(v)
    T.vacuum = v
    local function f(obj)
        if obj.Name == "SideroomSpace" then
            local col = obj:FindFirstChild("Collision")
            if col then
                col.CanCollide = v
                col.CanTouch = not v
            end
        end
    end
    if v then bindDesc("vacuum", f) else unbind("vacuum") end
end)

-- Snare
AntiLeft:AddToggle("AP_Snare", {
    Text = "Anti Snare", Default = false, Tooltip = "Tat CanTouch Snare",
}):OnChanged(function(v)
    T.snare = v
    local function f(obj)
        if obj.Name == "Snare" then setTouch(obj, not v) end
    end
    if v then bindDesc("snare", f) else unbind("snare") end
end)

-- Jeff
AntiLeft:AddToggle("AP_Jeff", {
    Text = "Anti Jeff", Default = false, Tooltip = "JeffTheKiller khong dam",
}):OnChanged(function(v)
    T.jeff = v
    local function f(obj)
        if obj.Name == "JeffTheKiller" then
            setTouch(obj, not v)
            setCollide(obj, not v)
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if v and hum then pcall(function() hum.Health = 0 end) end
        end
    end
    if v then bindDesc("jeff", f) else unbind("jeff") end
end)

-- Banana
AntiLeft:AddToggle("AP_Banana", {
    Text = "Anti Banana", Default = false, Tooltip = "BananaPeel / NannerPeel",
}):OnChanged(function(v)
    T.banana = v
    local function f(obj)
        if obj.Name == "BananaPeel" or obj.Name == "NannerPeel" then
            if obj:IsA("BasePart") then obj.CanTouch = not v end
            setTouch(obj, not v)
        end
    end
    if v then bindDesc("banana", f) else unbind("banana") end
end)

-- ========== RIGHT: TRAP ==========
-- Gloombat Eggs
AntiRight:AddToggle("AP_Gloom", {
    Text = "Anti Gloombat Eggs", Default = false, Tooltip = "GloomPile / eggs",
}):OnChanged(function(v)
    T.gloom = v
    local function f(obj)
        local n = obj.Name:lower()
        if obj.Name == "GloomPile" or n:find("gloombat") or n:find("egg") and n:find("gloom") then
            setTouch(obj, not v)
        end
    end
    if v then bindDesc("gloom", f) else unbind("gloom") end
end)

-- Killbrick / Lava
AntiRight:AddToggle("AP_Kill", {
    Text = "Anti Killbrick", Default = false, Tooltip = "Lava / kill parts",
}):OnChanged(function(v)
    T.kill = v
    local function f(obj)
        if obj.Name == "Lava" or obj.Name:lower():find("killbrick") then
            if obj:IsA("BasePart") then obj.CanTouch = not v end
        end
    end
    if v then bindDesc("kill", f) else unbind("kill") end
end)

-- Seeking Wall
AntiRight:AddToggle("AP_ScaryWall", {
    Text = "Anti Seeking Wall", Default = false, Tooltip = "ScaryWall",
}):OnChanged(function(v)
    T.wall = v
    local function f(obj)
        if obj.Name == "ScaryWall" then
            setTouch(obj, not v)
            setCollide(obj, not v)
        end
    end
    if v then bindDesc("wall", f) else unbind("wall") end
end)

-- Seek Obstructions
AntiRight:AddToggle("AP_SeekObs", {
    Text = "Anti Seek Obstructions", Default = false, Tooltip = "Seek_Arm / Chandelier / Floodline",
}):OnChanged(function(v)
    T.seekobs = v
    local function f(obj)
        if obj.Name == "Seek_Arm" or obj.Name == "ChandelierObstruction" then
            setTouch(obj, not v)
        elseif obj.Name == "SeekFloodline" then
            if obj:IsA("BasePart") then obj.CanCollide = v end
        end
    end
    if v then bindDesc("seekobs", f) else unbind("seekobs") end
end)

-- Semi God Mode
AntiRight:AddLabel("<font color='#FF3232'>Semi God Mode bat tat ca Anti thuong</font>", true)
AntiRight:AddToggle("AP_SemiGod", {
    Text = "<font color='#FF3232'>Semi God Mode</font>",
    Default = false,
}):OnChanged(function(v)
    local keys = {
        "eyes","lookman","giggle","dupe","vacuum","snare","jeff","banana",
        "gloom","kill","wall","seekobs",
    }
    -- bat logic truc tiep (khong phu thuoc UI set)
    for _, k in ipairs(keys) do T[k] = v end

    if v then
        if C.eyesHB then C.eyesHB:Disconnect() end
        C.eyesHB = RunService.Heartbeat:Connect(function()
            if Workspace:FindFirstChild("Eyes") or Workspace:FindFirstChild("Lookman")
                or Workspace:FindFirstChild("BackdoorLookman") then
                fireMotor()
            end
        end)
        local function all(obj)
            if obj.Name == "GiggleCeiling" then
                local h = obj:FindFirstChild("Hitbox"); if h then h.CanTouch = false end
            elseif obj.Name == "DoorFake" or obj.Name == "FakeDoor" then
                local h = obj:FindFirstChild("Hidden"); if h then h.CanTouch = false end
            elseif obj.Name == "SideroomSpace" then
                local col = obj:FindFirstChild("Collision")
                if col then col.CanCollide = true; col.CanTouch = false end
            elseif obj.Name == "Snare" or obj.Name == "GloomPile"
                or obj.Name == "BananaPeel" or obj.Name == "NannerPeel"
                or obj.Name == "JeffTheKiller" or obj.Name == "ScaryWall"
                or obj.Name == "Seek_Arm" or obj.Name == "ChandelierObstruction" then
                setTouch(obj, false)
            elseif obj.Name == "Lava" and obj:IsA("BasePart") then
                obj.CanTouch = false
            elseif obj.Name == "SeekFloodline" and obj:IsA("BasePart") then
                obj.CanCollide = true
            end
        end
        for _, o in ipairs(Workspace:GetDescendants()) do all(o) end
        if C.semiDesc then C.semiDesc:Disconnect() end
        C.semiDesc = Workspace.DescendantAdded:Connect(function(o) task.defer(all, o) end)

        notify("<font color='#FF3232'>Chi hoat dong voi thuc the yeu den trung binh KHONG HOAT DONG VOI ENTITY DUOC BAO VE KI VOI NHA PHAT TRIEN!</font>", 2.0)
    else
        for _, k in ipairs(keys) do T[k] = false end
        for k, c in pairs(C) do
            if c and c.Disconnect then pcall(function() c:Disconnect() end) end
            C[k] = nil
        end
    end
end)
end
