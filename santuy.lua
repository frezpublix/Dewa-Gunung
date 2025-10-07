-- // TELEPORT SCRIPT GUNUNG FOREVER BY Rayfield // --

-- Cek apakah script sudah aktif
local player = game:GetService("Players").LocalPlayer
if player:FindFirstChild("TeleportGUI_RUNNING") then
	warn("[Teleport GUI] Script sudah aktif — injeksi dibatalkan.")
	return
end

-- Tandai script aktif
local flag = Instance.new("BoolValue")
flag.Name = "TeleportGUI_RUNNING"
flag.Parent = player

-- Hapus GUI lama jika ada
if player.PlayerGui:FindFirstChild("TeleportGUI") then
	player.PlayerGui.TeleportGUI:Destroy()
end

-- Daftar checkpoint
local teleportPoints = {
    { name = "Checkpoint 1", position = Vector3.new(-1987.048583984375, 46.202178955078125, 2058.155517578125) },
    { name = "Checkpoint 2", position = Vector3.new(-1923.3533935546875, 85.5161361694336, 2009.8929443359375) },
    { name = "Checkpoint 3", position = Vector3.new(-1929.0367431640625, 150.24652099609375, 2227.52783203125) },
    { name = "Checkpoint 4", position = Vector3.new(-1656.391357421875, 121.10323333740234, 2476.236572265625) },
    { name = "Checkpoint 5", position = Vector3.new(-1490.5465087890625, 226.35215759277344, 2391.163818359375) },
    { name = "Checkpoint 6", position = Vector3.new(-1574.5728759765625, 186.3295135498047, 2106.269287109375) },
    { name = "Checkpoint 7", position = Vector3.new(-1862.438720703125, 194.11842346191406, 1898.1097412109375) },
    { name = "Checkpoint 8", position = Vector3.new(-1348.1943359375, 470.26885986328125, 1807.369140625) },
    { name = "Checkpoint 9", position = Vector3.new(-1286.0728759765625, 509.8629455566406, 2101.349365234375) },
    { name = "Checkpoint 10", position = Vector3.new(-1143.73095703125, 572.6705322265625, 2360.054443359375) },
    { name = "Checkpoint 11", position = Vector3.new(-1275.6390380859375, 625.569091796875, 2421.715087890625) },
    { name = "Checkpoint 12", position = Vector3.new(-1262.111328125, 710.3593139648438, 2359.757080078125) },
    { name = "Checkpoint 13", position = Vector3.new(-1325.8863525390625, 878.3743286132812, 2266.08349609375) },
    { name = "Checkpoint 14", position = Vector3.new(-1847.6968994140625, 1030.22119140625, 2325.512451171875) },
    { name = "Checkpoint 15", position = Vector3.new(-1564.3790283203125, 1042.8409423828125, 2780.93798828125) },
    { name = "Checkpoint 16", position = Vector3.new(-1445.52734375, 1070.6295166015625, 3073.49755859375) },
    { name = "Checkpoint 17", position = Vector3.new(-1333.28271484375, 1094.352783203125, 3463.568115234375) },
	{ name = "Summit", position = Vector3.new(-755.5657958984375, 1658.9156494140625, 3818.572509765625) },
}

-- Waktu cooldown global (detik)
local COOLDOWN_TIME = 0
local isGlobalCooldown = false -- status cooldown global
local currentCheckpoint = "Basecamp"

-- Fungsi teleport
local function teleportTo(index)
	local checkpoint = teleportPoints[index]
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character:MoveTo(checkpoint.position)
		currentCheckpoint = checkpoint.name

		game.StarterGui:SetCore("SendNotification", {
			Title = "Teleport Success!",
			Text = "Berhasil ke " .. checkpoint.name .. ". Cooldown (" .. COOLDOWN_TIME .. " detik).",
			Duration = 5
		})
	end
end

-- Fungsi reset checkpoint
local function resetToBasecamp()
	isGlobalCooldown = false
	currentCheckpoint = "Basecamp"

	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character:MoveTo(Vector3.new(-6.805, 15.108, -7.896))
	end

	-- Pulihkan warna tombol
	for _, btn in ipairs(player.PlayerGui.TeleportGUI.MainFrame.ScrollingFrame:GetChildren()) do
		if btn:IsA("TextButton") then
			btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end
	end

	game.StarterGui:SetCore("SendNotification", {
		Title = "Checkpoint Direset!",
		Text = "Kamu kembali ke Basecamp. Semua checkpoint direset.",
		Duration = 5
	})
end

-- GUI setup
local buttonHeight = 40
local totalButtonHeight = #teleportPoints * buttonHeight
local titleHeight = 40
local footerHeight = 40
local padding = 20
local maxHeight = 320
local frameHeight = math.min(totalButtonHeight + titleHeight + footerHeight + padding, maxHeight)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.ResetOnSpawn = false -- ✅ agar GUI tidak hilang setelah respawn
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, frameHeight)
mainFrame.Position = UDim2.new(0, 20, 0.5, -frameHeight / 2)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(92, 184, 212)
title.Text = "CP MOUNT SANTUY"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left -- ✅ teks rata kiri
title.TextYAlignment = Enum.TextYAlignment.Center -- biar tetap sejajar vertikal
title.Parent = mainFrame

-- Tambahkan padding kiri agar teks tidak menempel ke tepi
local paddingTitle = Instance.new("UIPadding")
paddingTitle.PaddingLeft = UDim.new(0, 10) -- ✅ jarak kiri 10px
paddingTitle.Parent = title

-- Tombol Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
	flag:Destroy()
end)

-- ScrollFrame
local scroll = Instance.new("ScrollingFrame")
scroll.Name = "ScrollingFrame"
scroll.Size = UDim2.new(1, 0, 1, -80)
scroll.Position = UDim2.new(0, 0, 0, 40)
scroll.CanvasSize = UDim2.new(0, 0, 0, #teleportPoints * 40)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.Parent = mainFrame

-- Footer
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 40)
footer.Position = UDim2.new(0, 0, 1, -40)
footer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
footer.BackgroundTransparency = 0.95
footer.BorderSizePixel = 0
footer.Parent = mainFrame

local footerText = Instance.new("TextLabel")
footerText.Size = UDim2.new(1, -10, 1, 0)
footerText.Position = UDim2.new(0, 5, 0, 0)
footerText.BackgroundTransparency = 1
footerText.Text = "Made with ❤️ by frezpublix"
footerText.TextColor3 = Color3.fromRGB(200, 200, 200)
footerText.Font = Enum.Font.Gotham
footerText.TextSize = 12
footerText.Parent = footer

-- Suara klik
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
clickSound.Parent = mainFrame

-- Tombol teleport
for i, checkpoint in ipairs(teleportPoints) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 35)
	button.Position = UDim2.new(0, 5, 0, (i - 1) * 40)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Text = checkpoint.name
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.Parent = scroll

	-- Hover efek
	button.MouseEnter:Connect(function()
		if not isGlobalCooldown then
			button.BackgroundColor3 = Color3.fromRGB(162, 169, 176)
		end
	end)
	button.MouseLeave:Connect(function()
		if not isGlobalCooldown then
			button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end
	end)

	-- Fungsi klik teleport / reset
	button.MouseButton1Click:Connect(function()
		if checkpoint.name == "Basecamp" then
			clickSound:Play()
			resetToBasecamp() -- ✅ Reset checkpoint
			return
		end

		if isGlobalCooldown then
			game.StarterGui:SetCore("SendNotification", {
				Title = "Cooldown Aktif!",
				Text = "Tunggu cooldown selesai sebelum teleport ke checkpoint lain.",
				Duration = 5
			})
			return
		end

		clickSound:Play()

		-- Animasi tombol
		button:TweenSize(UDim2.new(1, -5, 0, 38), "Out", "Quad", 0.1, true)
		task.wait(0.1)
		button:TweenSize(UDim2.new(1, -10, 0, 35), "Out", "Quad", 0.1, true)

		isGlobalCooldown = true
		teleportTo(i)

		-- Semua tombol dikunci
		for _, btn in ipairs(scroll:GetChildren()) do
			if btn:IsA("TextButton") then
				btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			end
		end

		task.delay(COOLDOWN_TIME, function()
			isGlobalCooldown = false
			for _, btn in ipairs(scroll:GetChildren()) do
				if btn:IsA("TextButton") then
					btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				end
			end

			game.StarterGui:SetCore("SendNotification", {
				Title = "Cooldown Selesai!",
				Text = "Kamu bisa teleport lagi ke checkpoint selanjutnya.",
				Duration = 5
			})
		end)
	end)
end
