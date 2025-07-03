-- lo_hdi Hub – Made with 💙
local Players = game:GetService("Players")
local Marketplace = game:GetService("MarketplaceService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- حماية من الطرد
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "Ban" then return end
    return old(self, ...)
end)
setreadonly(mt, true)

-- واجهة المستخدم
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "lo_hdi_Hub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 500)
frame.Position = UDim2.new(0.5, -150, 0.4, -250)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "☁️ lo_hdi Hub"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local features = {
    {name = "🚀 طيران", func = function()
        local flying = true
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        RS:BindToRenderStep("Fly", 200, function()
            if flying then
                local dir = Vector3.zero
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir += hrp.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= hrp.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= hrp.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir += hrp.CFrame.RightVector end
                bv.Velocity = dir.Unit * 100
            else
                RS:UnbindFromRenderStep("Fly")
                bv:Destroy()
            end
        end)
        wait(10) flying = false
    end},
    {name = "💨 السرعة", func = function() hum.WalkSpeed = 100 end},
    {name = "🦘 قفز عالي", func = function() hum.JumpPower = 150 end},
    {name = "👻 تخفي", func = function()
        for _,p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") then
                p.Transparency = 1
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end},
    {name = "🔒 وضع الإله", func = function() hum.MaxHealth = math.huge hum.Health = math.huge end}
}

for i, feature in ipairs(features) do
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -20, 0, 40)
    b.Position = UDim2.new(0, 10, 0, 50 + (i - 1) * 45)
    b.Text = feature.name
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.BackgroundColor3 = Color3.fromRGB(60,60,120)
    b.Font = Enum.Font.Gotham
    b.TextScaled = true
    b.MouseButton1Click:Connect(feature.func)
end

-- التبرع
local donate = Instance.new("TextLabel", frame)
donate.Size = UDim2.new(1, -20, 0, 30)
donate.Position = UDim2.new(0, 10, 1, -110)
donate.Text = "💰 دعم المطور:"
donate.TextColor3 = Color3.fromRGB(255,255,255)
donate.Font = Enum.Font.Gotham
donate.TextScaled = true
donate.BackgroundTransparency = 1

local donationData = {
    {amount = 2, id = 844484803},
    {amount = 5, id = 844493648},
    {amount = 10, id = 844365939}
}

for i, d in ipairs(donationData) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 1, -75 + (i - 1) * 35)
    btn.Text = "تبرع بـ " .. d.amount .. " R$"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(0,150,100)
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.MouseButton1Click:Connect(function()
        Marketplace:PromptGamePassPurchase(player, d.id)
    end)
end
