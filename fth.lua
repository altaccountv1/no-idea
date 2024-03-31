local EnemyText = pgui.EInterface.EnemyHP.TextLabel

local CanFeelHeat = Instance.new("BoolValue")
local IsBoss = false
local HPCorrect = Instance.new("BoolValue")
local AlreadyFeltHeat = Instance.new("BoolValue")

local BossHPTable = loadstring(game:HttpGet("https://pastebin.com/raw/YG4rWKBq"))();
local CanFeelHeat = Instance.new("BoolValue")
local HPCorrect = Instance.new("BoolValue")

pgui.EInterface.EnemyHP.BG.Meter.HPTxt:GetPropertyChangedSignal("Text"):Connect(function()
if table.find(BossHPTable, pgui.EInterface.EnemyHP.BG.Meter.HPTxt.Text) then
    CanFeelHeat.Value = true
    else
    CanFeelHeat.Value = false
    end
end)

CanFeelHeat.Changed:Connect(function()
if CanFeelHeat.Value == true and AlreadyFeltHeat.Value == false then
    AlreadyFeltHeat.Value = true
    if doingHact() then
	task.wait(4)
    end
    if char.LockedOn.Value then
        Stun(char.LockedOn.Value)
    end
    local whichfinisher
    if char.LockedOn.Value.Parent.Name == "Silent Stranger" or char.LockedOn.Value.Parent.Name == "Parker" or char.LockedOn.Value.Parent.Name == "Sensei Jeff Jefferson" then
	whichfinisher = "Kicks"
    elseif char.LockedOn.Value.Parent.Name == "Hue" or char.LockedOn.Value.Parent.Name == "Spoiled Brat" or char.LockedOn.Value.Parent.Name == "Bloodsucker" then
        whichfinisher = "Punches"
    elseif char.LockedOn.Value.Parent.Name == "Derek" or char.LockedOn.Value.Parent.Name == "The Foreman" then
	whichfinisher = "Brutal"
    end
    depleteHeat(6)
    task.wait()
    Notify("Feel the heat!!", "HeatDepleted", Color3.new(1,0,0))
    local anim = char.Humanoid:LoadAnimation(styles.Beast.Block)
    anim.Priority = Enum.AnimationPriority.Action4
    local id = "rbxassetid://10928237540"
    local SuperCharge = Instance.new("Animation", workspace)
    SuperCharge.AnimationId = id
    anim:Play()
    v = Instance.new("Folder", status)
    v.Name = "Invulnerable"
    char.HumanoidRootPart.Anchored = true
    fillHeat(2)
    task.wait(1.5)
    fillHeat(2)
    task.wait(1.5)
    anim:Stop()
    local anim = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(SuperCharge)
    anim:Play()
    anim.Looped = false
    PlaySound("Yell")
    fillHeat(6)
    task.wait(1)
    char.HumanoidRootPart.Anchored = false
    if whichfinisher == "Kicks" then
	UseHeatAction("H_Relentless", "Brawler", {char.LockedOn.Value})
    elseif whichfinisher == "Punches" then
	UseHeatAction("H_Fisticuffs", "Brawler", {char.LockedOn.Value})
    elseif whichfinisher == "Brutal" then
	UseHeatAction("H_Torment", "Brawler", {char.LockedOn.Value})
    end
    SuperCharge:Destroy()
    task.wait(2)
    v:Destroy()
    feelingheat.Value = false
    AlreadyFeltHeat.Value = false
    end
end)
