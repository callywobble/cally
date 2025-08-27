-- lo_hdi Hub – Made for Delta Executor
-- Dev: lo_hdi | Features: Fly, Speed, High Jump, Invisible, God Mode + GUI + Anti-Kick + Secure Key Access

local access_key = "wiz" -- 🔑 key

if _G.MyKey ~= access_key then
    game.Players.LocalPlayer:Kick("🔒 how tf u get the key wrong")
    return
end

local Players = game:GetService("Players")
local Marketplace = game:GetService("MarketplaceService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- 🛡️ gay 
do
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" or getnamecallmethod() == "Ban" then return end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end

-- 🎨 GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "for wizz or sum"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 520)
frame.Position = UDim2.new(0.5, -160, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Text = "☁️ lo_hdi Hub"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local lang = "ar"
local langBtn = Instance.new("TextButton", frame)
langBtn.Text = "🔄 English"
langBtn.Size = UDim2.new(0, 120, 0, 30)
langBtn.Position = UDim2.new(0, 10, 0, 50)
langBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
langBtn.TextColor3 = Color3.fromRGB(255,255,255)
langBtn.TextScaled = true
langBtn.Font = Enum.Font.Gotham

local buttons = {}
local speedVal, jumpVal = 100, 150
local features = {
    {ar="✈️ طيران", en="✈️ Fly", func=function()
        local flying = true
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Name = "FlyVelocity"
        RS:BindToRenderStep("fly", 200, function()
            if not flying then RS:UnbindFromRenderStep("fly") bv:Destroy() return end
            local vel = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then vel += hrp.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then vel -= hrp.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then vel -= hrp.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then vel += hrp.CFrame.RightVector end
            bv.Velocity = vel.Unit * 100
        end)
        wait(5) flying = false
    end},
    {ar="⚡ السرعة", en="⚡ Speed", func=function() hum.WalkSpeed = speedVal end},
    {ar="🦘 قفز عالي", en="🦘 High Jump", func=function() hum.JumpPower = jumpVal end},
    {ar="👻 تخفي", en="👻 Invisible", func=function()
        for _,p in pairs(char:GetChildren()) do if p:IsA("BasePart") then p.Transparency = 1 end end
    end},
    {ar="💀 وضع إله", en="💀 God Mode", func=function() hum.Health = math.huge end}
}

for i,feat in ipairs(features) do
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -20, 0, 35)
    b.Position = UDim2.new(0, 10, 0, 90 + (i-1)*40)
    b.BackgroundColor3 = Color3.fromRGB(60,60,120)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Font = Enum.Font.Gotham
    b.Text = (lang == "ar") and feat.ar or feat.en
    b.MouseButton1Click:Connect(feat.func)
    buttons[i] = b
end

langBtn.MouseButton1Click:Connect(function()
    lang = (lang == "ar") and "en" or "ar"
    langBtn.Text = (lang == "ar") and "🔄 English" or "🔄 عربية"
    for i,b in ipairs(buttons) do
        b.Text = (lang == "ar") and features[i].ar or features[i].en
    end
end)

-- 💰 تبرع
local donateLabel = Instance.new("TextLabel", frame)
donateLabel.Text = (lang == "ar") and "💰 دعم المطور:" or "💰 Support Dev:"
donateLabel.Position = UDim2.new(0, 10, 1, -100)
donateLabel.Size = UDim2.new(1, -20, 0, 25)
donateLabel.TextColor3 = Color3.new(1,1,1)
donateLabel.BackgroundTransparency = 1
donateLabel.Font = Enum.Font.Gotham
donateLabel.TextScaled = true
donateLabel.Parent = frame

local donationIds = {
    {amt = 2, id = 844484803},
    {amt = 5, id = 844493648},
    {amt = 10, id = 844365939}
}
for i,data in ipairs(donationIds) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 1, -70 + (i - 1) * 35)
    btn.BackgroundColor3 = Color3.fromRGB(0,150,100)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = (lang == "ar" and "تبرع بـ " or "Donate ") .. data.amt .. " R$"
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.MouseButton1Click:Connect(function()
        Marketplace:PromptGamePassPurchase(player, data.id)
    end)
end
