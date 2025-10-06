local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- local BOT_TOKEN = "aw"
-- local CHAT_ID = "aw"
-- local API_URL = "https://api.telegram.org/bot" .. BOT_TOKEN .. "/sendMessage"

-- local function httpRequest(data)
--     if syn and syn.request then return syn.request(data)
--     elseif http_request then return http_request(data)
--     elseif request then return request(data)
--     elseif fluxus and fluxus.request then return fluxus.request(data)
--     elseif KRNL_LOADED and request then return request(data)
--     else error("Executor lo ga support http request") end
-- end

-- local function sendToTelegram(msg)
--     local body = {
--         chat_id = CHAT_ID,
--         text = msg
--     }
--     local data = HttpService:JSONEncode(body)

--     httpRequest({
--         Url = API_URL,
--         Method = "POST",
--         Headers = { ["Content-Type"] = "application/json" },
--         Body = data
--     })
-- end

local Window = Rayfield:CreateWindow({
   Name = "Dewa Gunung by Okane",
   Icon = 0,
   LoadingTitle = "FREZPUBLIX HUB",
   LoadingSubtitle = "by Okane",
   Theme = "Default",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, 
      Invite = "https://discord.gg/GgEWHUYh49", 
      RememberJoins = true 
   },

   KeySystem = false, 
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", 
      FileName = "Key",
      SaveKey = true, 
      GrabKeyFromSite = false,
      Key = {"Hello"} 
   }
})

local Tab = Window:CreateTab("Main")
local Section = Tab:CreateSection("- Enjoy your game -")

local InfiniteJumpEnabled = false

local Toggle = Tab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        InfiniteJumpEnabled = Value

        if InfiniteJumpEnabled then
            local Player = game:GetService("Players").LocalPlayer
            local UIS = game:GetService("UserInputService")

            if _G.InfiniteJumpConnection then
                _G.InfiniteJumpConnection:Disconnect()
            end

            _G.InfiniteJumpConnection = UIS.JumpRequest:Connect(function()
                if InfiniteJumpEnabled and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
                    Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if _G.InfiniteJumpConnection then
                _G.InfiniteJumpConnection:Disconnect()
                _G.InfiniteJumpConnection = nil
            end
        end
    end,
})

local AutoHealEnabled = false
local HealConnection

local Toggle = Tab:CreateToggle({
    Name = "Auto Heal",
    CurrentValue = false,
    Flag = "AutoHealToggle",
    Callback = function(Value)
        AutoHealEnabled = Value
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        if AutoHealEnabled then
            HealConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = math.min(humanoid.Health + 5, humanoid.MaxHealth)
                end
            end)
        else
            if HealConnection then HealConnection:Disconnect() HealConnection = nil end
        end
    end,
})

local godModeConnection = nil
local function enableGodMode(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Name ~= "GodHumanoid" then
        humanoid.Name = "GodHumanoid"

        godModeConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health < 1 then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end
end

local function disableGodMode(character)
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    local humanoid = character:FindFirstChild("GodHumanoid")
    if humanoid then
        humanoid.Name = "Humanoid"
    end
end

local Toggle = Tab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodModeToggle",
    Callback = function(Value)
        local character = player.Character or player.CharacterAdded:Wait()
        if Value then
            enableGodMode(character)
        else
            disableGodMode(character)
        end
    end,
})

player.CharacterAdded:Connect(function(character)
    wait(1)
    if Toggle.CurrentValue then
        enableGodMode(character)
    else
        disableGodMode(character)
    end
end)

local Toggle = Tab:CreateToggle({
    Name = "Click Teleport",
    CurrentValue = false,
    Flag = "ClickTP_Toggle",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()

        local existingTool = player.Backpack:FindFirstChild("Equip to Click TP") 
            or player.Character:FindFirstChild("Equip to Click TP")

        if Value then
            if not existingTool then
                local tool = Instance.new("Tool")
                tool.RequiresHandle = false
                tool.Name = "Equip to Click TP"

                tool.Activated:Connect(function()
                    local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
                    pos = CFrame.new(pos.X, pos.Y, pos.Z)
                    player.Character.HumanoidRootPart.CFrame = pos
                end)

                tool.Parent = player.Backpack
            end
        else
            if existingTool then existingTool:Destroy() end
        end
    end,
})

-- local Toggle = Tab:CreateToggle({
--     Name = "Click Teleport To Get Coordinate",
--     CurrentValue = false,
--     Flag = "ClickTP_Coords_Toggle",
--     Callback = function(Value)
--         local player = game.Players.LocalPlayer
--         local mouse = player:GetMouse()

--         local existingTool = player.Backpack:FindFirstChild("Equip to Click TP Coords") 
--             or player.Character:FindFirstChild("Equip to Click TP Coords")

--         if Value then
--             if not existingTool then
--                 local tool = Instance.new("Tool")
--                 tool.RequiresHandle = false
--                 tool.Name = "Equip to Click TP Coords"

--                 tool.Activated:Connect(function()
--                     local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
--                     pos = CFrame.new(pos.X, pos.Y, pos.Z)
--                     player.Character.HumanoidRootPart.CFrame = pos

--                     local coords = player.Character.HumanoidRootPart.Position
--                     local msg = string.format(
--                         "Player %s Teleported!\nKoordinat:\n(%.2f,%.2f,%.2f)",
--                         player.Name, coords.X, coords.Y, coords.Z
--                     )

--                     -- Kirim ke Telegram
--                     sendToTelegram(msg)
--                 end)

--                 tool.Parent = player.Backpack
--             end
--         else
--             if existingTool then existingTool:Destroy() end
--         end
--     end,
-- })

local Slider = Tab:CreateSlider({
   Name = "WalkSpeed",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local humanoid = character:FindFirstChildOfClass("Humanoid")
      
      if humanoid then
          humanoid.WalkSpeed = Value
      end
   end,
})

-- Players Tab

local function getRoot(model)
    if not model then return nil end
    return model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("Torso")
        or model:FindFirstChild("UpperTorso")
end

local function typeOf(v)
    local tf = typeof or function(x) return type(x) end
    return tf(v)
end

local function getMyHRP()
    local myChar = player.Character or player.CharacterAdded:Wait()
    local myHRP  = getRoot(myChar) or myChar:WaitForChild("HumanoidRootPart", 8)
    return myChar, myHRP
end

local function tpToTarget(targetPlayer)
    print("[TP] start to", targetPlayer and targetPlayer.Name)

    local myChar = player.Character or player.CharacterAdded:Wait()
    local myHRP  = getRoot(myChar) or myChar:WaitForChild("HumanoidRootPart", 8)
    if not myHRP then
        print("[TP] myHRP not found")
        return false, "HRP kamu gak ditemukan."
    end

    local tChar = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
    local tHRP  = getRoot(tChar) or tChar:WaitForChild("HumanoidRootPart", 8)
    if not tHRP then
        print("[TP] target HRP not found")
        return false, "Target belum punya HRP."
    end

    local destCFrame = tHRP.CFrame + Vector3.new(0, 2.5, 0)

    pcall(function()
        myHRP.AssemblyLinearVelocity = Vector3.new()
        myHRP.AssemblyAngularVelocity = Vector3.new()
    end)

    for tries = 1, 4 do
        local ok = pcall(function()
            myHRP.CFrame = destCFrame
        end)
        if ok then
            print("[TP] CFrame set ok on try", tries)
            return true
        end
        task.wait(0.12)
        myChar = player.Character or player.CharacterAdded:Wait()
        myHRP  = getRoot(myChar) or myChar:WaitForChild("HumanoidRootPart", 8)
        if not myHRP then
            print("[TP] myHRP lost after retry")
            return false, "HRP kamu hilang saat teleport."
        end
    end
    print("[TP] CFrame method failed, fallback to PivotTo")

    for tries = 1, 3 do
        local ok = pcall(function()
            if not myChar.PrimaryPart then
                myChar.PrimaryPart = getRoot(myChar)
            end
            myChar:PivotTo(destCFrame)
        end)
        if ok then
            print("[TP] PivotTo ok on try", tries)
            return true
        end
        task.wait(0.12)
    end
    print("[TP] PivotTo failed, fallback to Humanoid:MoveTo")

    local hum = myChar:FindFirstChildOfClass("Humanoid")
    if hum then
        local reached = false
        local conn
        conn = hum.MoveToFinished:Connect(function(ok)
            reached = ok
            if conn then conn:Disconnect() end
        end)
        pcall(function()
            hum:MoveTo(destCFrame.Position)
        end)
        local t0 = os.clock()
        while os.clock() - t0 < 2 do
            if reached then break end
            task.wait(0.1)
        end
        if reached then
            print("[TP] MoveTo reached")
            return true
        end
    end

    print("[TP] all methods failed")
    return false, "Gagal teleport (CFrame/PivotTo/MoveTo). Mungkin diblokir anti-teleport."
end

local PlayerTab = Window:CreateTab("Players", nil)

local optionToPlayer = {}
local selectedLabel  = nil

local function makeLabel(p)
    if p == player then
        return string.format("%s (You) [%d]", p.Name, p.UserId)
    else
        return string.format("%s [%d]", p.Name, p.UserId)
    end
end

local function buildOptions()
    optionToPlayer = {}
    local opts = {}
    for _, p in ipairs(Players:GetPlayers()) do
        local label = makeLabel(p)
        optionToPlayer[label] = p
        table.insert(opts, label)
    end
    return opts
end

local function getSelected()
    if selectedLabel and optionToPlayer[selectedLabel] then
        return selectedLabel
    end
    local opts = buildOptions()
    if #opts > 0 then
        selectedLabel = opts[1]
        return selectedLabel
    end
    return nil
end

local initialOpts = buildOptions()

local function dropdownSetOptionsSafe(dd, opts)
    if not dd then return end
    local ok = false
    if dd.SetOptions then
        ok = pcall(function() dd:SetOptions(opts) end)
    end
    if (not ok) and dd.Refresh then
        pcall(function() dd:Refresh(opts, opts[1]) end)
    end
end

local function dropdownSetValueSafe(dd, value)
    if not dd then return end
    if dd.SetOption then
        pcall(function() dd:SetOption(value) end)
        return
    end
    if dd.Set then
        pcall(function() dd:Set(value) end)
        return
    end
    if dd.Refresh then
        pcall(function()
            local opts = buildOptions()
            dd:Refresh(opts, value)
        end)
    end
end

local PlayerDropdown = PlayerTab:CreateDropdown({
    Name = "Pilih Player",
    Options = initialOpts,
    CurrentOption = initialOpts[1] or nil,
    Callback = function(label)
        if typeOf(label) == "table" then
            label = label[1]
        end
        selectedLabel = label
        local target = optionToPlayer[label]
        if target then
            Rayfield:Notify({
                Title   = "Target Dipilih",
                Content = string.format("-> %s (%d)", target.Name, target.UserId),
                Duration = 1.25
            })
        end
    end,
})

if initialOpts[1] then
    selectedLabel = initialOpts[1]
end

PlayerTab:CreateButton({
    Name = "Refresh List",
    Callback = function()
        local opts = buildOptions()
        dropdownSetOptionsSafe(PlayerDropdown, opts)
        if #opts > 0 then
            dropdownSetValueSafe(PlayerDropdown, opts[1])
            selectedLabel = opts[1]
        else
            selectedLabel = nil
            Rayfield:Notify({ Title="Players", Content="Belum ada pemain terdeteksi.", Duration=1.5 })
        end
        Rayfield:Notify({ Title="Players", Content="List di-refresh ("..tostring(#opts).." pemain).", Duration=1.2 })
    end,
})

local function autoRefresh()
    local opts = buildOptions()
    dropdownSetOptionsSafe(PlayerDropdown, opts)
    if #opts > 0 then
        selectedLabel = (selectedLabel and optionToPlayer[selectedLabel]) and selectedLabel or opts[1]
    else
        selectedLabel = nil
    end
end

Players.PlayerAdded:Connect(autoRefresh)
Players.PlayerRemoving:Connect(function()
    autoRefresh()
    if selectedLabel and not optionToPlayer[selectedLabel] then
        selectedLabel = nil
    end
end)

PlayerTab:CreateButton({
    Name = "Teleport To Player",
    Callback = function()
        print("[BTN] Teleport pressed")
        local label = getSelected()
        print("[BTN] selected label =", label)

        if not label or not optionToPlayer[label] then
            print("[BTN] label invalid, rebuilding options")
            local opts = buildOptions()
            dropdownSetOptionsSafe(PlayerDropdown, opts)
            selectedLabel = opts[1]
            if not selectedLabel then
                Rayfield:Notify({ Title="Players", Content="Belum ada pemain di server.", Duration=1.5 })
                return
            end
            label = selectedLabel
        end

        local target = optionToPlayer[label]
        print("[BTN] target =", target and target.Name, target and target.UserId)

        if not target then
            Rayfield:Notify({ Title="Teleport", Content="Target tidak valid.", Duration=1.5 })
            return
        end
        if target == player then
            Rayfield:Notify({ Title="Teleport", Content="Tidak bisa teleport ke diri sendiri.", Duration=1.5 })
            return
        end

        local ok, err = tpToTarget(target)
        if ok then
            Rayfield:Notify({ Title="Teleport", Content="Berhasil teleport ke "..label, Duration=1.5 })
        else
            Rayfield:Notify({ Title="Teleport", Content="Gagal: "..tostring(err), Duration=2 })
            print("[TP] error:", err)
        end
    end,
})

-- local Tab = Window:CreateTab("Teleport")
-- local Section = Tab:CreateSection("- 3xplo Yang Tersedia -")

-- local Toggle = Tab:CreateToggle({
--     Name = "Teleport to CP1",
--     CurrentValue = false,
--     Flag = "Toggle1",
--     Callback = function(Value)
--         if Value then
--             local player = game.Players.LocalPlayer
--             local character = player.Character or player.CharacterAdded:Wait()
--             local hrp = character:WaitForChild("HumanoidRootPart")

--             -- Ganti ini ke koordinat tujuan kamu
--             local targetPosition = CFrame.new(-421.68,193.49,553.80)

--             hrp.CFrame = targetPosition
--         end
--         -- Kalau Value == false, nggak ngapa-ngapain
--     end,
-- })

-- local Toggle = Tab:CreateToggle({
--     Name = "Teleport to CP2",
--     CurrentValue = false,
--     Flag = "Toggle1",
--     Callback = function(Value)
--         if Value then
--             local player = game.Players.LocalPlayer
--             local character = player.Character or player.CharacterAdded:Wait()
--             local hrp = character:WaitForChild("HumanoidRootPart")

--             -- Ganti ini ke koordinat tujuan kamu
--             local targetPosition = CFrame.new(-630.61,580.31,1136.20)

--             hrp.CFrame = targetPosition
--         end
--         -- Kalau Value == false, nggak ngapa-ngapain
--     end,
-- })

-- local Toggle = Tab:CreateToggle({
--     Name = "Teleport to CP3",
--     CurrentValue = false,
--     Flag = "Toggle1",
--     Callback = function(Value)
--         if Value then
--             local player = game.Players.LocalPlayer
--             local character = player.Character or player.CharacterAdded:Wait()
--             local hrp = character:WaitForChild("HumanoidRootPart")

--             -- Ganti ini ke koordinat tujuan kamu
--             local targetPosition = CFrame.new(-894.48,691.89,1222.08)

--             hrp.CFrame = targetPosition
--         end
--         -- Kalau Value == false, nggak ngapa-ngapain
--     end,
-- })

-- local Toggle = Tab:CreateToggle({
--     Name = "Teleport to CP4",
--     CurrentValue = false,
--     Flag = "Toggle1",
--     Callback = function(Value)
--         if Value then
--             local player = game.Players.LocalPlayer
--             local character = player.Character or player.CharacterAdded:Wait()
--             local hrp = character:WaitForChild("HumanoidRootPart")

--             -- Ganti ini ke koordinat tujuan kamu
--             local targetPosition = CFrame.new(-389.85,1043.46,2045.04)

--             hrp.CFrame = targetPosition
--         end
--         -- Kalau Value == false, nggak ngapa-ngapain
--     end,
-- })

-- local Toggle = Tab:CreateToggle({
--     Name = "Teleport to CP5",
--     CurrentValue = false,
--     Flag = "Toggle1",
--     Callback = function(Value)
--         if Value then
--             local player = game.Players.LocalPlayer
--             local character = player.Character or player.CharacterAdded:Wait()
--             local hrp = character:WaitForChild("HumanoidRootPart")

--             -- Ganti ini ke koordinat tujuan kamu
--             local targetPosition = CFrame.new(1189.22,10121.51,2295.03)

--             hrp.CFrame = targetPosition
--         end
--         -- Kalau Value == false, nggak ngapa-ngapain
--     end,
-- })

-- local Toggle = Tab:CreateToggle({
--     Name = "Teleport to SUMMIT",
--     CurrentValue = false,
--     Flag = "Toggle1",
--     Callback = function(Value)
--         if Value then
--             local player = game.Players.LocalPlayer
--             local character = player.Character or player.CharacterAdded:Wait()
--             local hrp = character:WaitForChild("HumanoidRootPart")

--             -- Ganti ini ke koordinat tujuan kamu
--             local targetPosition = CFrame.new(-120.01,10832.71,3017.44)

--             hrp.CFrame = targetPosition
--         end
--         -- Kalau Value == false, nggak ngapa-ngapain
--     end,
-- })

local WAIT_SEC = 5
local USE_HEARTBEAT_TIMER = true

_G.__TP_BUSY = _G.__TP_BUSY or false

local function createOrGetHud()
    local pg = player:WaitForChild("PlayerGui")

    local gui = pg:FindFirstChild("AutoSummitHUD")
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = "AutoSummitHUD"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = pg

        local container = Instance.new("Frame")
        container.Name = "Container"
        container.AnchorPoint = Vector2.new(0.5, 0)
        container.Position = UDim2.new(0.5, 0, 0.08, 0)
        container.Size = UDim2.fromOffset(420, 86)
        container.BackgroundTransparency = 0.25
        container.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        container.Parent = gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = container

        local stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Thickness = 1.5
        stroke.Color = Color3.fromRGB(70, 70, 70)
        stroke.Parent = container

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, -20, 0, 32)
        title.Position = UDim2.fromOffset(10, 6)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.SourceSansBold
        title.TextScaled = true
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Text = "Auto Summit"
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = container

        local status = Instance.new("TextLabel")
        status.Name = "Status"
        status.Size = UDim2.new(1, -20, 0, 24)
        status.Position = UDim2.fromOffset(10, 40)
        status.BackgroundTransparency = 1
        status.Font = Enum.Font.SourceSans
        status.TextScaled = true
        status.TextColor3 = Color3.fromRGB(220, 220, 220)
        status.Text = "Menyiapkan..."
        status.TextXAlignment = Enum.TextXAlignment.Left
        status.Parent = container

        local countdown = Instance.new("TextLabel")
        countdown.Name = "Countdown"
        countdown.Size = UDim2.new(1, -20, 0, 24)
        countdown.Position = UDim2.fromOffset(10, 62)
        countdown.BackgroundTransparency = 1
        countdown.Font = Enum.Font.SourceSans
        countdown.TextScaled = true
        countdown.TextColor3 = Color3.fromRGB(180, 220, 255)
        countdown.Text = ""
        countdown.TextXAlignment = Enum.TextXAlignment.Left
        countdown.Parent = container
    end

    local container = gui:WaitForChild("Container")
    container.AnchorPoint = Vector2.new(0.5, 0)
    container.Position    = UDim2.new(0.5, 0, 0.08, 0)

    return gui,
           container:WaitForChild("Title"),
           container:WaitForChild("Status"),
           container:WaitForChild("Countdown")
end

local function hudShow(titleText, statusText)
    local gui, title, status, countdown = createOrGetHud()
    title.Text = titleText or "Auto Summit"
    status.Text = statusText or ""
    countdown.Text = ""
    gui.Enabled = true
end

local function hudStatus(statusText)
    local _, _, status, _ = createOrGetHud()
    status.Text = statusText or ""
end

local function hudCountdown(text)
    local _, _, _, countdown = createOrGetHud()
    countdown.Text = text or ""
end

local function hudHide()
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return end
    local gui = pg:FindFirstChild("AutoSummitHUD")
    if gui then gui.Enabled = false end
end

local function getCharacterAndHRP()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        character = player.Character or player.CharacterAdded:Wait()
        hrp = character:WaitForChild("HumanoidRootPart")
    end
    return character, hrp
end

local function resetCharacter()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
end

local function sleepSeconds(seconds, onTick)
    if seconds <= 0 then return end
    if USE_HEARTBEAT_TIMER then
        local remaining = seconds
        while remaining > 0 do
            local dt = RunService.Heartbeat:Wait()
            remaining -= dt
            if onTick then
                onTick(math.max(remaining, 0))
            end
        end
    else
        local t = seconds
        while t > 0 do
            local waitChunk = math.min(1, t)
            task.wait(waitChunk)
            t -= waitChunk
            if onTick then onTick(math.max(t, 0)) end
        end
    end
end

local _teleFailConn
local function _bindTeleportRetry(placeId, player, sameServer)
    if _teleFailConn then _teleFailConn:Disconnect() end
    _teleFailConn = TeleportService.TeleportInitFailed:Connect(function(plr, result, err)
        if plr ~= player then return end
        warn("[AutoRejoin] Teleport gagal (" .. tostring(result) .. "): " .. tostring(err))
        task.wait(5)
        pcall(function()
            if sameServer and game.JobId ~= "" then
                TeleportService:TeleportToPlaceInstance(placeId, game.JobId, player)
            else
                TeleportService:Teleport(placeId, player)
            end
        end)
    end)
end

local function autoRejoin(delaySec, sameServer)
    if typeof(delaySec) ~= "number" then delaySec = 5 end
    if typeof(sameServer) ~= "boolean" then sameServer = false end

    task.spawn(function()
        if hudShow then hudShow("Auto Summit", ("🔁 Rejoin dalam %d detik..."):format(delaySec)) end

        if hudCountdown then
            for t = delaySec, 1, -1 do
                if hudStatus then hudStatus(("🔁 Rejoin dalam %d detik..."):format(t)) end
                hudCountdown(("⏳ %d"):format(t))
                task.wait(1)
            end
        else
            task.wait(delaySec)
        end

        local player  = Players.LocalPlayer
        local placeId = game.PlaceId

        _bindTeleportRetry(placeId, player, sameServer)

        if hudStatus then hudStatus("🚪 Rejoining...") end
        pcall(function()
            if sameServer and game.JobId ~= "" then
                TeleportService:TeleportToPlaceInstance(placeId, game.JobId, player)
            else
                TeleportService:Teleport(placeId, player)
            end
        end)

        if hudHide then hudHide() end
    end)
end

local function runOnceResilient(points, toggleRef, waitSec, runName, opts)
    if typeof(waitSec) == "string" and runName == nil and opts == nil then
        runName = waitSec
        waitSec = nil
    end

    if typeof(waitSec) ~= "number" then waitSec = 5 end
    if runName == nil then runName = "Auto Summit" end
    if opts == nil then opts = { autoRejoin = false } end

    if _G.__TP_BUSY then
        warn("Auto Summit lagi jalan, batal start baru.")
        pcall(function()
            if toggleRef and (toggleRef.Set or toggleRef.SetState) then
                (toggleRef.Set or toggleRef.SetState)(toggleRef, false)
            end
        end)
        return
    end
    _G.__TP_BUSY = true

    if hudShow then hudShow(runName, "Memulai...") end

    local ok, err = pcall(function()
        local total = #points
        local i = 1
        while i <= total do
            local entry    = points[i]
            local targetCF = nil
            local stepWait = waitSec
            local stepLabel= ("Point %d/%d"):format(i, total)

            if typeof(entry) == "CFrame" then
                targetCF = entry
            elseif typeof(entry) == "table" then
                targetCF = (typeof(entry.pos) == "CFrame" and entry.pos)
                        or (typeof(entry.cframe) == "CFrame" and entry.cframe)
                        or (typeof(entry.CFrame) == "CFrame" and entry.CFrame)
                        or (typeof(entry[1]) == "CFrame" and entry[1])
                if typeof(entry.wait) == "number" then stepWait = entry.wait end
                if typeof(entry.label) == "string" then stepLabel = entry.label end
            end

            if not targetCF then
                if hudStatus then hudStatus(("❗ Data point %d tidak valid, stop."):format(i)) end
                break
            end

            if hudStatus then hudStatus(("Teleport %d/%d (%s) ..."):format(i, total, stepLabel)) end
            if hudCountdown then hudCountdown("") end

            local character, hrp = getCharacterAndHRP()

            local teleported = false
            while not teleported do
                if not hrp or not hrp.Parent then
                    character, hrp = getCharacterAndHRP()
                end
                local okSet = pcall(function()
                    hrp.CFrame = targetCF
                end)
                if okSet then
                    teleported = true
                    if hudStatus then hudStatus(("✅ Teleport %d/%d berhasil"):format(i, total)) end
                else
                    if hudStatus then hudStatus(("Gagal set CFrame, retry... (point %d)"):format(i)) end
                    task.wait(0.1)
                end
            end

            if i < total and stepWait and stepWait > 0 then
                local lastInt = -1
                sleepSeconds(stepWait, function(remain)
                    local s = math.ceil(remain)
                    if s ~= lastInt then
                        lastInt = s
                        if hudCountdown then
                            hudCountdown(("⏳ Jeda %d detik sebelum point berikutnya..."):format(s))
                        end
                    end
                end)
            end

            i += 1
        end

        if hudStatus then hudStatus("Selesai, reset karakter...") end
        if hudCountdown then hudCountdown("") end
        resetCharacter()
    end)

    _G.__TP_BUSY = false

    pcall(function()
        if toggleRef and (toggleRef.Set or toggleRef.SetState) then
            (toggleRef.Set or toggleRef.SetState)(toggleRef, false)
        end
    end)

    if not ok then
        warn("runOnceResilient error: " .. tostring(err))
        if hudStatus then hudStatus("❌ Error: " .. tostring(err)) end
        if hudCountdown then hudCountdown("") end
        task.wait(2)
        if hudHide then hudHide() end
        return
    end

    if hudStatus then hudStatus("🎉 Auto Summit selesai!") end
    if hudCountdown then hudCountdown("") end
    task.wait(2)

    if opts and opts.autoRejoin then
        autoRejoin(
            (typeof(opts.rejoinDelay) == "number" and opts.rejoinDelay) or 3,
            (typeof(opts.rejoinSameServer) == "boolean" and opts.rejoinSameServer) or false
        )
    else
        if hudHide then hudHide() end
    end
end

local Tab = Window:CreateTab("Auto Summit")
local Section = Tab:CreateSection("- Map Yang Tersedia -")

local AutoSummitYahayuk = {
    CFrame.new(-429.05, 265.50, 788.27), -- Camp 1
    CFrame.new(-359.93, 405.13, 541.62), -- Camp 2
    CFrame.new(288.24,  446.13, 506.28), -- Camp 3
    CFrame.new(336.31,  507.13, 348.97), -- Camp 4
    CFrame.new(224.20, 331.13, -144.73), -- Camp 5
    CFrame.new(-614.06, 904.50, -551.25), -- Summit
    CFrame.new(-674.25, 909.50, -481.76), -- Start
}

local AutoSummitCKPTW = {
    CFrame.new(517.06,160.18,-531.54), -- CP1
    CFrame.new(386.77,308.18,-183.78), -- CP2
    CFrame.new(100.16,410.78,616.67), -- CP3
    CFrame.new(6.23,603.47,996.42), -- CP4
    CFrame.new(871.85,864.43,586.87), -- CP5
    CFrame.new(1612.18,1084.12,159.86), -- CP6
    CFrame.new(2965.00,1531.21,705.93), -- CP7
    CFrame.new(1943.24,1743.55,1219.65), -- C8
    CFrame.new(1822.42,1979.40,2163.64), -- SUMMIT
    CFrame.new(1822.42,1979.40,2163.64), -- SUMMIT
}

local AutoSummitATIN = {
    CFrame.new(-184.15,135.96,408.26), -- CP2
    CFrame.new(-165.85,237.86,652.82), -- CP3
    CFrame.new(-38.09,414.72,616.19), -- CP4
    CFrame.new(129.79,657.62,612.45), -- CP5
    CFrame.new(-247.56,673.80,733.76), -- CP6
    CFrame.new(-683.53,647.78,865.59), -- CP7
    CFrame.new(-658.56,696.34,1458.61), -- CP8
    CFrame.new(-508.22,910.78,1868.44), -- CP9
    CFrame.new(61.01,955.51,2089.64), -- CP10
    CFrame.new(50.73,989.36,2450.35), -- CP11
    CFrame.new(72.75,1104.84,2457.93), -- CP12
    CFrame.new(263.02,1278.07,2036.99), -- CP13
    CFrame.new(-419.41,1310.04,2394.95), -- CP14
    CFrame.new(-773.75,1321.82,2664.02), -- CP15
    CFrame.new(-837.27,1479.91,2626.56), -- CP16
    CFrame.new(-468.61,1473.57,2769.79), -- CP17
    CFrame.new(-468.19,1545.35,2836.32), -- CP18
    CFrame.new(-385.21,1648.19,2793.62), -- CP19
    CFrame.new(-208.67,1673.70,2749.49), -- CP20
    CFrame.new(-233.00,1749.94,2792.68), -- CP21
    CFrame.new(-422.38,1745.45,2797.23), -- CP22
    CFrame.new(-425.31,1721.03,3419.69), -- CP23
    CFrame.new(70.22,1726.61,3427.71), -- CP24
    CFrame.new(436.40,1728.44,3431.17), -- CP25
    CFrame.new(625.72,1807.36,3432.32), -- CP26
    CFrame.new(806.40,2169.73,3897.66), -- SUMMIT
    CFrame.new(112.62,2432.62,3484.93), -- PLANG
    CFrame.new(15.32,54.67,-1081.71), -- Balik Ke Start
}

local AutoSummitMerapi = {
    CFrame.new(-2000.68,1878.72,-268.20), -- Summit
    CFrame.new(-4240.44,13.90,2316.65), -- Basecamp
    CFrame.new(-4240.44,13.90,2316.65), -- Start
}

local AutoSummitRinjani = {
    CFrame.new(3353.48,9033.58,5633.81), -- CP1
    CFrame.new(3079.93,9108.74,4455.46), -- CP2
    CFrame.new(1878.50,9553.97,3484.22), -- CP3
    CFrame.new(1370.43,9776.59,3122.20), -- CP4
    CFrame.new(1188.40,10122.28,2291.25), -- CP5
    CFrame.new(-120.01,10832.71,3017.44), -- SUMMIT
    CFrame.new(2693.64,8956.50,7527.51), -- Balik Ke Start
}

local AutoSummitHilih = {
    CFrame.new(444.01,14.01,-606.61), -- CP1
    CFrame.new(-212.45,48.58,-121.66), -- CP2
    CFrame.new(-840.77,35.99,-74.67), -- CP3
    CFrame.new(-710.52,400.87,396.13), -- CP4
    CFrame.new(-343.62,149.93,218.66), -- CP5
    CFrame.new(-371.40,360.07,469.29), -- CP6
    CFrame.new(-73.06,336.25,242.59), -- CP7
    CFrame.new(255.53,527.68,137.86), -- SUMMIT
    CFrame.new(-913.85,23.17,-718.45), -- Balik Ke Start
}

local AutoSummitKonoha = {
    { pos = CFrame.new(809.82,284.54,-576.08), wait = 30,  label = "CP1 → CP2" },
    { pos = CFrame.new(771.31,516.59,-377.75), wait = 30, label = "CP2 → CP3" },
    { pos = CFrame.new(-77.94,483.80,387.65), wait = 30,  label = "CP3 → CP4" },
    { pos = CFrame.new(179.96,589.83,701.90), wait = 30, label = "CP4 → CP5" },
    { pos = CFrame.new(350.36,596.12,822.64), wait = 30,  label = "CP5 → CP6" },
    { pos = CFrame.new(795.65,821.21,626.56), wait = 60,  label = "CP6 → CP7" },
    { pos = CFrame.new(926.30,1000.36,599.03), wait = 5,  label = "CP7 → SUMMIT" },
    { pos = CFrame.new(-822.58,124.45,-675.14), wait = 5,  label = "SUMMIT → START" },
}

local AutoSummitSumbing = {
    CFrame.new(-229.69,440.91,2146.39), -- CP1
    CFrame.new(-422.98,848.91,3203.40), -- CP2
    CFrame.new(-33.31,1268.50,4040.99), -- CP3
    CFrame.new(-1136.99,1552.91,4902.62), -- CP4
    CFrame.new(-900.03,1955.17,5397.75), -- SUMMIT
    CFrame.new(-338.95,4.91,27.93), -- Balik Ke Start
}

local AutoSummitTerserah = {
    CFrame.new(312.90,121.29,156.62), -- CP1
    CFrame.new(87.26,226.13,406.76), -- CP2
    CFrame.new(-182.93,531.31,1104.80), -- CP3
    CFrame.new(-738.85,515.08,1125.69), -- CP4
    CFrame.new(125.68,532.72,1674.51), -- CP5
    CFrame.new(-360.37,724.50,2052.89), -- SUMMIT
    CFrame.new(-498.33,13.60,355.24), -- Start
}

local AutoSummitOwashu = {
    CFrame.new(-306.00,68.61,632.71), -- CP1
    CFrame.new(9.97,69.87,1103.22), -- CP2
    CFrame.new(-605.84,250.88,1232.00), -- CP3
    CFrame.new(-1077.51,326.33,1408.93), -- CP4
    CFrame.new(-1192.40,485.98,1785.13), -- CP5
    CFrame.new(-1584.57,671.96,2312.45), -- SUMMIT
    CFrame.new(-20.00,36.50,-21.58), -- Start
}

local AutoSummitPapua = {
    CFrame.new(-282.27,352.50,1169.06), -- CP1
    CFrame.new(439.11,577.14,971.96), -- CP2
    CFrame.new(1153.82,860.41,420.35), -- CP3
    CFrame.new(1501.02,897.70,153.23), -- CP4
    CFrame.new(1540.62,1044.38,-288.27), -- CP5
    CFrame.new(2449.63,1405.50,-546.10), -- CP6
    CFrame.new(3146.02,1512.12,-638.04), -- CP7
    CFrame.new(4115.05,1842.34,-724.03), -- CP8
    CFrame.new(5387.35,2140.50,-951.20), -- CP9
    CFrame.new(6056.92,2248.86,-868.63), -- SUMMIT
    CFrame.new(-1975.20,-65.42,26.87), -- START
}

local AutoSummitYagataw = {
    CFrame.new(-421.68,193.49,553.80), -- CP1
    CFrame.new(-630.61,580.31,1136.20), -- CP2
    CFrame.new(-900.47,691.89,1224.18), -- CP3
    CFrame.new(-387.07,1043.46,2050.91), -- CP4
    CFrame.new(-752.93,1527.18,2058.24), -- CP5
    CFrame.new(-480.29,1635.18,2283.78), -- CP6
    CFrame.new(-88.17,1932.96,2113.13), -- CP7
    CFrame.new(-0.56,2495.21,2041.70), -- Summit
    CFrame.new(-250.50,36.50,207.63), -- Basecamp
}

local AutoSummitYagataw = {
    CFrame.new(-421.68,193.49,553.80), -- CP1
    CFrame.new(-630.61,580.31,1136.20), -- CP2
    CFrame.new(-900.47,691.89,1224.18), -- CP3
    CFrame.new(-387.07,1043.46,2050.91), -- CP4
    CFrame.new(-752.93,1527.18,2058.24), -- CP5
    CFrame.new(-480.29,1635.18,2283.78), -- CP6
    CFrame.new(-88.17,1932.96,2113.13), -- CP7
    CFrame.new(-0.56,2495.21,2041.70), -- Summit
    CFrame.new(-250.50,36.50,207.63), -- Basecamp
}

local AutoSummitSibuatan = {
    CFrame.new(-311.28,154.57,-324.72), -- CP1
    CFrame.new(5393.69,8108.83,2206.70), -- SUMMIT
    CFrame.new(1024.28,112.30,-699.23), -- START
}

local AutoSummitAWAN = {
    CFrame.new(-752.05,69.16,7.87), -- CP1
    CFrame.new(-781.00,289.16,156.39), -- CP2
    CFrame.new(-1071.84,510.51,419.47), -- CP3
    CFrame.new(-1174.26,640.21,24.83), -- CP4
    CFrame.new(-879.83,866.64,-671.40), -- CP5
    CFrame.new(-410.55,994.86,-1213.15), -- CP6
    CFrame.new(-457.82,1255.87,-1903.55), -- CP7
    CFrame.new(-503.84,1527.85,-2601.64), -- CP8
    CFrame.new(-534.02,1701.36,-3047.00), -- CP9
    CFrame.new(-513.29,1780.59,-3158.25), -- SUMMIT
    CFrame.new(-522.24,1765.17,-3172.44), -- SUMMIT2
}

local AutoSummitBOHONG = {
    CFrame.new(1156.26,163.57,-450.70), -- CP1
    CFrame.new(929.48,274.94,-1014.63), -- CP2
    CFrame.new(592.31,663.18,-893.33), -- CP3
    CFrame.new(49.57,808.45,-995.56), -- CP4
    CFrame.new(-35.32,905.33,-1139.37), -- CP5
    CFrame.new(-688.45,889.49,-1383.23), -- CP6
    CFrame.new(-652.17,898.22,-1773.40), -- CP7
    CFrame.new(-1193.66,996.69,-1740.74), -- CP8
    CFrame.new(-1329.81,898.09,-1154.87), -- CP9
    CFrame.new(-971.55,1303.45,-1474.88), -- SUMMIT
    CFrame.new(-971.30,1320.50,-1383.12), -- SUMMIT2
}

local AutoSummitJawir = {
    CFrame.new(-138.81,73.55,265.43), -- CP1
    CFrame.new(99.42,169.55,523.83), -- CP2
    CFrame.new(-100.93,169.53,553.54), -- CP3
    CFrame.new(-250.64,113.60,417.87), -- CP4
    CFrame.new(-291.71,202.87,671.44), -- CP5
    CFrame.new(-445.32,283.26,903.01), -- CP6
    CFrame.new(-660.97,393.53,983.71), -- CP7
    CFrame.new(-780.47,539.31,713.50), -- CP8
    CFrame.new(-997.04,591.28,806.86), -- CP9
    CFrame.new(-1012.43,699.48,710.21), -- 10
    CFrame.new(-1141.15,699.64,749.96), -- 11
    CFrame.new(-1210.04,671.66,954.60), -- 12
    CFrame.new(-1540.76,671.60,851.69), -- 13
    CFrame.new(-1544.44,742.83,570.56), -- 14
    CFrame.new(-1329.22,697.63,424.72), -- 15
    CFrame.new(-1230.76,672.03,305.12), -- 16
    CFrame.new(-892.24,597.54,334.98), -- 17
    CFrame.new(-1300.47,861.88,643.66), -- SUMMIT
    CFrame.new(-1300.47,861.88,643.66), -- SUMMIT
}

local AutoSummitHELL = {
    CFrame.new(-102.14,200.61,271.89), -- CP1
    CFrame.new(-1512.61,1873.27,-71.88), -- SUMMIT
    CFrame.new(-1512.61,1873.27,-71.88), -- START
}

local AutoSummitCihuy = {
    CFrame.new(-1582.00,118.60,499.05), -- CP1
    CFrame.new(-1177.50,206.86,-22.28), -- CP2
    CFrame.new(-807.00,319.53,621.00), -- CP3
    CFrame.new(468.60,195.16,790.39), -- CP4
    CFrame.new(491.42,533.34,620.50), -- CP5
    CFrame.new(168.50,1012.09,-124.29), -- CP6
    CFrame.new(610.50,1186.63,-863.04), -- CP7
    CFrame.new(253.85,1267.63,-970.16), -- CP8
    CFrame.new(118.50,1399.94,-713.47), -- CP9
    CFrame.new(104.12,1454.79,-463.25), -- CP10
    CFrame.new(-200.02,1448.13,-436.17), -- CP11
    CFrame.new(67.54,1481.11,-84.45), -- CP12
    CFrame.new(579.56,1670.20,-320.61), -- SUM
    CFrame.new(579.56,1670.20,-320.61), -- SUM
}

local AutoSummitInerie = {
    CFrame.new(-2242.74,557.43,-493.60), -- SUMMIT
    CFrame.new(-2242.74,557.43,-493.60), -- SUMMIT
}

local AutoSummitDaun = {
    CFrame.new(-622.597, 251.480, -383.820), -- SHELTER1
    CFrame.new(-1202.631, 262.853, -486.886), -- SHELTER2
    CFrame.new(-1399.541, 579.590, -950.313), -- SHELTER3
    CFrame.new(-1700.140, 817.854, -1398.986), -- SHELTER4
    CFrame.new(-3204.742, 1725.660, -2607.370), -- SUMMIT
}

local AutoSummitBaja = {
    CFrame.new(-323.5145263671875, 142.47230529785156, -905.1727905273438), -- CP1
    CFrame.new(-32.221466064453125, 311.5097961425781, -960.9024047851562), -- CP2
    CFrame.new(-155.38153076171875, 359.3307189941406, -906.6642456054688), -- CP3
    CFrame.new(-289.7442932128906, 411.3307189941406, -850.7291870117188), -- CP4
    CFrame.new(-608.3347778320312, 483.1664733886719, -794.5529174804688), -- CP5
    CFrame.new(-1013.6422119140625, 471.7531433105469, -589.4368286132812), -- CP6
    CFrame.new(-1098.0870361328125, 427.3307189941406, -389.0946960449219), -- CP7
    CFrame.new(-253.88230895996094, 593.543212890625, -661.4715576171875), -- CP8
    CFrame.new(-404.121826171875, 696.137451171875, -626.8255004882812), -- CP9
    CFrame.new(-169.27037048339844, 768.1548461914062, -722.5739135742188), -- CP10
    CFrame.new(-169.27037048339844, 768.1548461914062, -722.5739135742188), -- CP11
    CFrame.new(-299.5137939453125, 931.33056640625, -300.2574157714844), -- CP12
    CFrame.new(-386.93756103515625, 1015.9373779296875, -351.1980895996094), -- CP13
    CFrame.new(-599.1567993164062, 1125.7169189453125, -278.48065185546875), -- CP14
    CFrame.new(-720.5885620117188, 1221.5345458984375, -197.82456970214844), -- CP15
    CFrame.new(-590.4952392578125, 1262.62158203125, -345.5721740722656), -- CP16
    CFrame.new(-676.2166137695312, 1271.33056640625, -97.80644226074219), -- CP17
    CFrame.new(-738.877197265625, 1275.33056640625, 141.12059020996094), -- SUMMIT
}

local AutoSummitDombret = {
    CFrame.new(-1084.8145751953125, 119.32339477539062, 509.9850158691406), wait = 2, -- CP1
    CFrame.new(-1221.3685302734375, 302.2683410644531, 217.46971130371094), wait = 2, -- CP2
    CFrame.new(-971.9522705078125, 314.2341003417969, -161.90005493164062), wait = 2, -- CP3
    CFrame.new(-918.9764404296875, 482.37432861328125, -257.5782775878906), wait = 2, -- CP4
    CFrame.new(-693.15478515625, 482.3558654785156, -318.5072021484375), wait = 2, -- CP5
    CFrame.new(-1200.6365966796875, 511.9288330078125, -544.3865356445312), wait = 2, -- CP6
    CFrame.new(-1356.0562744140625, 514.0059814453125, -600.8192749023438), wait = 2, -- CP7
    CFrame.new(-1207.1214599609375, 426.37432861328125, -992.6610107421875), wait = 2, -- CP8
    CFrame.new(-1055.6812744140625, 417.0321350097656, -1045.0009765625), wait = 2, -- CP9
    CFrame.new(-860.5717163085938, 417.0321350097656, -1049.0018310546875), wait = 2, -- CP10
    CFrame.new(-682.5454711914062, 474.3108825683594, -1092.1669921875), wait = 2, -- CP11
    CFrame.new(-589.9775390625, 574.3743286132812, -1003.4483642578125), wait = 2, -- CP12
    CFrame.new(-342.0392761230469, 573.9166259765625, -641.4917602539062), wait = 2, -- CP13
    CFrame.new(155.28158569335938, 537.9758911132812, -558.9714965820312), wait = 2, -- CP14
    CFrame.new(-591.9486694335938, 742.3743286132812, 214.07650756835938), wait = 2, -- SUMMIT
}

local AutoSummitTabaLagan = {
    CFrame.new(-1651.791259765625, 1416.5426025390625, -802.2590942382812), -- SUMMIT
    CFrame.new(-1651.791259765625, 1416.5426025390625, -802.2590942382812), -- SUMMIT
}

local AutoSummitWasabi = {
    CFrame.new(317.5267333984375, 280.43798828125, -371.3353576660156), -- CP1
    CFrame.new(6.510121822357178, 277.20697021484375, -401.59051513671875), -- CP2
    CFrame.new(-28.949024200439453, 280.9440002441406, -277.83612060546875), -- CP3
    CFrame.new(-149.84298706054688, 289.1069641113281, -39.99715805053711), -- CP4
    CFrame.new(129.13824462890625, 240.4202423095703, 2.132035732269287), -- CP5
    CFrame.new(-196.26153564453125, 257.1359558105469, 339.5901184082031), -- CP6
    CFrame.new(-236.62342834472656, 325.6009826660156, 95.86695098876953), -- CP7
    CFrame.new(-389.9990234375, 344.7939758300781, 312.8550720214844), -- CP8
    CFrame.new(-330.8992614746094, 434.3028869628906, 538.4367065429688), -- CP9
    CFrame.new(-373.4931945800781, 657.9804077148438, 466.4712219238281), -- CP10
    CFrame.new(-1057.0382080078125, 791.7791137695312, 493.11260986328125), -- SUMMIT
}

local AutoSummitForever = {
    CFrame.new(-36.39281463623047, 160.19747924804688, 395.0010681152344), -- CP1
    CFrame.new(-615.9189453125, 285.3744201660156, 168.6779022216797), -- CP2
    CFrame.new(-337.11279296875, 388.19744873046875, -316.99462890625), -- CP3
    CFrame.new(-214.383056640625, 667.9271240234375, -1048.417236328125), -- CP4
    CFrame.new(-216.14320373535156, 742.7069702148438, -1049.311767578125), -- CP5
    CFrame.new(-242.8191680908203, 792.6585083007812, -1037.410400390625), -- CP6
    CFrame.new(-370.0701904296875, 819.4791259765625, -1050.9102783203125), -- CP7
    CFrame.new(-222.01168823242188, 866.6239013671875, -1041.05126953125), -- CP8
    CFrame.new(-325.9489440917969, 894.7463989257812, -1089.089599609375), -- CP9
    CFrame.new(19.723787307739258, 1060.1973876953125, -1064.84326171875), -- CP10
    CFrame.new(596.5394897460938, 1014.22998046875, -1035.56591796875), -- CP11
    CFrame.new(877.02587890625, 1071.3624267578125, -1030.0843505859375), -- CP12
    CFrame.new(955.4330444335938, 1292.1973876953125, -1081.1094970703125), -- CP13
    CFrame.new(1116.73388671875, 1292.1973876953125, -806.6150512695312), -- CP14
    CFrame.new(1390.50439453125, 1292.1973876953125, -1080.1025390625), -- CP15
    CFrame.new(1014.5308227539062, 1443.9974365234375, -1636.3902587890625), -- CP16
    CFrame.new(311.989990234375, 2050.691162109375, -2226.282470703125), -- CP17
}

local Toggle_A
Toggle_A = Tab:CreateToggle({
    Name = "Auto Summit Gunung Yahayuk",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitYahayuk, Toggle_A, 5, "Auto Summit - Yahayuk by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_B
Toggle_B = Tab:CreateToggle({
    Name = "Auto Summit Gunung CKPTW",
    CurrentValue = false,
    Callback = function(on)
        if on then
            spawn(function()
                runOnceResilient(AutoSummitCKPTW, Toggle_B, 5, "Auto Summit - CKPTW by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_C
Toggle_C = Tab:CreateToggle({
    Name = "Auto Summit Gunung ATIN",
    CurrentValue = false,
    Callback = function(on)
        if on then
            spawn(function()
                runOnceResilient(AutoSummitATIN, Toggle_C, 5, "Auto Summit - Atin by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_D
Toggle_D = Tab:CreateToggle({
    Name = "Auto Summit Gunung Merapi ( Rejoin )",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitMerapi, Toggle_D, 5, "Auto Summit - Merapi by Okane", { autoRejoin = true, rejoinDelay = 5, rejoinSameServer = false }
                )
            end)
        end
    end,
})

local Toggle_E
Toggle_E = Tab:CreateToggle({
    Name = "Auto Summit Gunung Rinjani",
    CurrentValue = false,
    Callback = function(on)
        if on then
            spawn(function()
                runOnceResilient(AutoSummitRinjani, Toggle_E, 5, "Auto Summit - Rinjani by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_F
Toggle_F = Tab:CreateToggle({
    Name = "Auto Summit Gunung Hilih",
    CurrentValue = false,
    Callback = function(on)
        if on then
            spawn(function()
                runOnceResilient(AutoSummitHilih, Toggle_F, 5, "Auto Summit - Hilih by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_G
Toggle_G = Tab:CreateToggle({
    Name = "Auto Summit Gunung Konoha",
    CurrentValue = false,
    Callback = function(on)
        if on then
            spawn(function()
                runOnceResilient(AutoSummitKonoha, Toggle_G, 5, "Auto Summit - Konoha by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_H
Toggle_H = Tab:CreateToggle({
    Name = "Auto Summit Gunung Sumbing",
    CurrentValue = false,
    Callback = function(on)
        if on then
            spawn(function()
                runOnceResilient(AutoSummitSumbing, Toggle_H, 5, "Auto Summit - Sumbing by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_I
Toggle_I = Tab:CreateToggle({
    Name = "Auto Summit Gunung Terserah ( Masih Bug )",
    CurrentValue = false,
    Callback = function(on)
        if on then
            spawn(function()
                runOnceResilient(AutoSummitTerserah, Toggle_I, 5, "Auto Summit - Terserah by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_J
Toggle_J = Tab:CreateToggle({
    Name = "Auto Summit Gunung Owashu",
    CurrentValue = false,
    Callback = function(on)
        if on then
            spawn(function()
                runOnceResilient(AutoSummitOwashu, Toggle_J, 5, "Auto Summit - Owashu by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_K
Toggle_K = Tab:CreateToggle({
    Name = "Auto Summit Gunung Papua",
    CurrentValue = false,
    Callback = function(on)
        if on then
            spawn(function()
                runOnceResilient(AutoSummitPapua, Toggle_K, 5, "Auto Summit - Papua by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_L
Toggle_L = Tab:CreateToggle({
    Name = "Auto Summit Gunung Yagataw ( Masih Bug )",
    CurrentValue = false,
    Callback = function(on)
        if on then
            spawn(function()
                runOnceResilient(AutoSummitYagataw, Toggle_L, 5, "Auto Summit - Yagataw by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_M
Toggle_M = Tab:CreateToggle({
    Name = "Auto Summit Gunung Sibuatan ( Rejoin )",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitSibuatan, Toggle_M, 5, "Auto Summit - Sibuatan by Okane", { autoRejoin = true, rejoinDelay = 5, rejoinSameServer = false }
                )
            end)
        end
    end,
})

local Toggle_N
Toggle_N = Tab:CreateToggle({
    Name = "Auto Summit Gunung AWAN ( Rejoin )",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitAWAN, Toggle_N, 5, "Auto Summit - AWAN by Okane", { autoRejoin = true, rejoinDelay = 5, rejoinSameServer = false }
                )
            end)
        end
    end,
})

local Toggle_O
Toggle_O = Tab:CreateToggle({
    Name = "Auto Summit Gunung BOHONG",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitBOHONG, Toggle_O, 5, "Auto Summit - BOHONG by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_P
Toggle_P = Tab:CreateToggle({
    Name = "Auto Summit Gunung Jawir",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitJawir, Toggle_P, 5, "Auto Summit - Jawir by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_Q
Toggle_Q = Tab:CreateToggle({
    Name = "Auto Summit Hell Expedition",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitHELL, Toggle_Q, 5, "Auto Summit - Hell Expedition by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_R
Toggle_R = Tab:CreateToggle({
    Name = "Auto Summit Gunung Cihuy",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitCihuy, Toggle_R, 5, "Auto Summit - Cihuy by Okane", { autoRejoin = false })
            end)
        end
    end,
})

local Toggle_S
Toggle_S = Tab:CreateToggle({
    Name = "Auto Summit Gunung Inerie ( Rejoin )",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitInerie, Toggle_S, 5, "Auto Summit - Inerie by Okane", { autoRejoin = true, rejoinDelay = 5, rejoinSameServer = false })
            end)
        end
    end,
})

local Toggle_T
Toggle_T = Tab:CreateToggle({
    Name = "Auto Summit Gunung Daun",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitDaun, Toggle_T, 5, "Auto Summit - Daun by Okane", { autoRejoin = false, rejoinDelay = 5, rejoinSameServer = false })
            end)
        end
    end,
})

local Toggle_U
Toggle_U = Tab:CreateToggle({
    Name = "Auto Summit Gunung B AJA",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitBaja, Toggle_U, 5, "Auto Summit - B AJA by Okane", { autoRejoin = false, rejoinDelay = 5, rejoinSameServer = false })
            end)
        end
    end,
})

local Toggle_V
Toggle_V = Tab:CreateToggle({
    Name = "Auto Summit Gunung Dombret",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitDombret, Toggle_V, 5, "Auto Summit - Dombret by Okane", { autoRejoin = false, rejoinDelay = 5, rejoinSameServer = false })
            end)
        end
    end,
})

local Toggle_W
Toggle_W = Tab:CreateToggle({
    Name = "Auto Summit Gunung Taba Lagan",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitTabaLagan, Toggle_W, 5, "Auto Summit - Taba Lagan by Okane", { autoRejoin = false, rejoinDelay = 5, rejoinSameServer = false })
            end)
        end
    end,
})

local Toggle_X
Toggle_X = Tab:CreateToggle({
    Name = "Auto Summit Gunung Wasabi",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitWasabi, Toggle_X, 5, "Auto Summit - Wasabi by Okane", { autoRejoin = false, rejoinDelay = 5, rejoinSameServer = false })
            end)
        end
    end,
})

local Toggle_Y
Toggle_Y = Tab:CreateToggle({
    Name = "Auto Summit Gunung Forever (Rejoin)",
    CurrentValue = false,
    Callback = function(on)
        if on then
            task.spawn(function()
                runOnceResilient(AutoSummitForever, Toggle_Y, 5, "Auto Summit - Inerie by Okane", { autoRejoin = true, rejoinDelay = 5, rejoinSameServer = false })
            end)
        end
    end,
})

local Tab = Window:CreateTab("Detect Nearby CP")
local Section = Tab:CreateSection("- Checkpoint Yang Tersedia -")

-- Simpan referensi hasil deteksi agar bisa dihapus
local checkpointElements = {}

-- Fungsi hapus daftar lama
local function clearCheckpoints()
	for _, ui in pairs(checkpointElements) do
		if ui and ui.Destroy then
			ui:Destroy()
		end
	end
	checkpointElements = {}
end

-- Fungsi ambil angka dari nama checkpoint
local function extractNumber(name)
	local num = string.match(name, "%d+")
	return num and tonumber(num) or math.huge -- jika tidak ada angka, taruh di akhir
end

-- Fungsi utama deteksi checkpoint
local function detectCheckpoints()
	clearCheckpoints()

	local checkpoints = {}

	-- Cari semua checkpoint di workspace
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Part") or obj:IsA("Model") then
			local lname = string.lower(obj.Name)
			if lname:find("checkpoint") or lname:find("cp") then
				table.insert(checkpoints, obj)
			end
		end
	end

	-- Jika tidak ditemukan
	if #checkpoints == 0 then
		local noLabel = Tab:CreateLabel("❌ Tidak ada checkpoint ditemukan di Workspace.")
		table.insert(checkpointElements, noLabel)
		return
	end

	-- Urutkan berdasarkan angka di nama checkpoint
	table.sort(checkpoints, function(a, b)
		local numA, numB = extractNumber(a.Name), extractNumber(b.Name)
		if numA == numB then
			return a.Name:lower() < b.Name:lower()
		else
			return numA < numB
		end
	end)

	-- Tampilkan hasil
	for i, cp in ipairs(checkpoints) do
		local btn = Tab:CreateButton({
			Name = "📍 " .. cp.Name,
			Callback = function()
				local player = game.Players.LocalPlayer
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local pos
					if cp:IsA("Model") then
						if cp.PrimaryPart then
							pos = cp.PrimaryPart.Position
						else
							local first = cp:FindFirstChildWhichIsA("BasePart")
							if first then pos = first.Position end
						end
					elseif cp:IsA("BasePart") then
						pos = cp.Position
					end

					if pos then
						player.Character:MoveTo(pos)
						game.StarterGui:SetCore("SendNotification", {
							Title = "Teleport Success!",
							Text = "Berhasil ke " .. cp.Name,
							Duration = 3
						})
					else
						game.StarterGui:SetCore("SendNotification", {
							Title = "Teleport Gagal!",
							Text = "Posisi checkpoint tidak ditemukan.",
							Duration = 3
						})
					end
				end
			end
		})

		table.insert(checkpointElements, btn)
	end

	local label = Tab:CreateLabel("✅ " .. #checkpoints .. " checkpoint ditemukan & diurutkan.")
	table.insert(checkpointElements, label)
end

-- Tombol untuk memindai checkpoint (manual)
local detectBtn = Tab:CreateButton({
	Name = "Deteksi Checkpoint",
	Callback = function()
		game.StarterGui:SetCore("SendNotification", {
			Title = "Mendeteksi...",
			Text = "Sedang mencari checkpoint di Workspace...",
			Duration = 3
		})
		detectCheckpoints()
	end
})

-- Tombol refresh
local refreshBtn = Tab:CreateButton({
	Name = "Refresh Daftar Checkpoint",
	Callback = function()
		game.StarterGui:SetCore("SendNotification", {
			Title = "Memperbarui...",
			Text = "Checkpoint diperbarui.",
			Duration = 3
		})
        clearCheckpoints()
		detectCheckpoints()
	end
})

Rayfield:LoadConfiguration()
