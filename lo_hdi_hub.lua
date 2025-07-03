-- Script Hub by lo_hdi
local Players = game:GetService("Players")
local Marketplace = game:GetService("MarketplaceService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- منع الطرد أو الباند
do
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local m = getnamecallmethod()
        if m == "Kick" or m == "Ban" then return end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end

-- واجهة المستخدم
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "lo_hdi_UI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 560)
frame.Position = UDim2.new(0.5, -160, 0.4, -280)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Text = "☁️ lo_hdi Hub"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(35,35,35)

local watermark = Instance.new("TextLabel", frame)
watermark.Text = "By lo_hdi"
watermark.Font = Enum.Font.Code
watermark.TextSize = 12
watermark.TextColor3 = Color3.fromRGB(200,200,200)
watermark.BackgroundTransparency = 1
watermark.Size = UDim2.new(0,100,0,20)
watermark.Position = UDim2.new(1, -105, 1, -25)

local lang = "ar"
local langBtn = Instance.new("TextButton", frame)
langBtn.Text = "🔄 English"
langBtn.Size = UDim2.new(0,120,0,30)
langBtn.Position = UDim2.new(0,10,0,50)
langBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
langBtn.TextColor3 = Color3.fromRGB(255,255,255)
langBtn.TextScaled = true
langBtn.Font = Enum.Font.Gotham

local buttons = {}
local features = {
    {ar="طيران", en="Fly", func=function()
        local flying=false
        local bv=Instance.new("BodyVelocity")
        bv.MaxForce=Vector3.new(1e5,1e5,1e5)
        RS:BindToRenderStep("fly",200,function()
            if flying then
                local v=Vector3.new()
                if UIS:IsKeyDown(Enum.KeyCode.W) then v=v+hrp.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then v=v-hrp.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then v=v-hrp.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then v=v+hrp.CFrame.RightVector end
                bv.Velocity=v.Unit*100; bv.Parent=hrp
            else RS:UnbindFromRenderStep("fly"); bv:Destroy() end
        end)
        flying = not flying
    end},
    {ar="السرعة", en="Speed", func=function() hum.WalkSpeed = 100 end},
    {ar="قفز عالي", en="High Jump", func=function() hum.JumpPower = 150 end},
    {ar="تخفي", en="Invisible", func=function()
        for _,p in pairs(char:GetChildren()) do
            if p:IsA("BasePart") then p.Transparency = 1 end
        end
    end},
    {ar="وضع الإله", en="God Mode", func=function() hum.Health = 999999 end}
}

for i,feat in ipairs(features) do
    local b=Instance.new("TextButton",frame)
    b.Size=UDim2.new(1,-20,0,35)
    b.Position=UDim2.new(0,10,0,90 + (i-1)*40)
    b.BackgroundColor3 = Color3.fromRGB(60,60,120)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.TextScaled = true
    b.Font = Enum.Font.Gotham
    b.MouseButton1Click:Connect(feat.func)
    buttons[i] = b
end

langBtn.MouseButton1Click:Connect(function()
    lang = (lang=="ar") and "en" or "ar"
    langBtn.Text = (lang=="ar") and "🔄 English" or "🔄 عربية"
    for i,b in ipairs(buttons) do
        b.Text = (lang=="ar" and features[i].ar or features[i].en)
    end
end)

for i,feat in ipairs(features) do
    buttons[i].Text = (lang=="ar" and feat.ar or feat.en)
end

-- قسم التبرع
local donateLabel = Instance.new("TextLabel", frame)
donateLabel.Size = UDim2.new(1, -20, 0, 25)
donateLabel.Position = UDim2.new(0, 10, 1, -140)
donateLabel.Text = (lang == "ar") and "💰 دعم المطور:" or "💰 Support Dev:"
donateLabel.TextColor3 = Color3.fromRGB(255,255,255)
donateLabel.Font = Enum.Font.Gotham
donateLabel.TextScaled = true
donateLabel.BackgroundTransparency = 1

local donationData = {
    { amount = 2, id = 844484803 },
    { amount = 5, id = 844493648 },
    { amount = 10, id = 844365939 },
}

for i, data in ipairs(donationData) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 1, -105 + (i - 1) * 35)
    btn.BackgroundColor3 = Color3.fromRGB(0,150,100)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = (lang == "ar" and "تبرع بـ " or "Donate ").. data.amount .." R$"
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.MouseButton1Click:Connect(function()
        Marketplace:PromptGamePassPurchase(player, data.id)
    end)
end
