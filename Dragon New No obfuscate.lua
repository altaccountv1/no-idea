local plr = game.Players.LocalPlayer
local pgui = plr.PlayerGui
local interf = pgui.Interface
local bt = interf.Battle
local main = bt.Main
local moves = game.ReplicatedStorage.Moves
local styles = game.ReplicatedStorage.Styles
local Dragon = styles.Brawler
local rush = styles.Rush
local beast = styles.Beast
local status = plr.Status
local menu = pgui.MenuUI.Menu 
local abil = menu.Abilities.Frame.Frame.Frame
local abilFolder = game.ReplicatedStorage.Abilities.Brawler
local char = plr.Character
local RPS = game.ReplicatedStorage
local sounds = RPS.Sounds
local DragonText = "Dragon"
local u1 = game.Players.LocalPlayer
local u2 = u1.Status
local u3 = u2.Settings
local u4 = game.Workspace.CurrentCamera
local S_UserInputService_1 = game:GetService("UserInputService")
local S_ReplicatedStorage_2 = game:GetService("ReplicatedStorage")
local S_ReplicatedFirst_3 = game:GetService("ReplicatedFirst")
local S_TweenService_4 = game:GetService("TweenService")
local u5 = S_ReplicatedStorage_2.Events.ME
local L_Interface_5 = u1:WaitForChild("PlayerGui"):WaitForChild("Interface")
local u6 = require(S_ReplicatedStorage_2.Modules.XP)
local u7 = require(S_ReplicatedStorage_2.Modules.SpecialFunctions)
local u8 = require(S_ReplicatedFirst_3.Ambassador)
local u9 = require(S_ReplicatedFirst_3.Variables)
local u10 = require(S_ReplicatedStorage_2.Modules.Sound)
local u11 = require(u1:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
local L_MenuUI_6 = u1:WaitForChild("PlayerGui"):WaitForChild("MenuUI")
local u12 = nil
local battleWatcher = false;

local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local ME = ReplicatedStorage.Events.ME

local Ambassador = require(ReplicatedFirst.Ambassador)
local Variables = require(ReplicatedFirst.Variables)
local SoundModule = require(ReplicatedStorage.Modules.Sound)

local function PlaySound(SoundName) -- rplaysound
    SoundModule.playsound(ReplicatedStorage.Sounds[SoundName], Variables.hrp, nil, nil, true)
    local SoundEvent = {
        [1] = "repsound",
        [2] = SoundName
    }
    ME:FireServer(SoundEvent)
end


function isInBattle()
	return (plr:FindFirstChild("InBattle") and true or false)
end

function isDungeon()
	return game.ReplicatedStorage.Dungeon.Value
end

function doingHact()
	return (plr.Character:FindFirstChild("Heated") and true or false)
end

function showMaxHeatEffect()
	return (isInBattle() and not doingHact() and plr.Status.Heat.Value >= 100) and true or false
end

function hasWeaponInHand()
	return (plr.Character:FindFirstChild("Holding") and true or false)
end

function IsInPvp()
    if plr:FindFirstChild("PvPed") then
        return true
    else
        return false
    end
end

local function Notify(text)
	game.Players.LocalPlayer.PlayerGui["Notify"]:Fire(text)
end

local namesChanged = false
local hasReloaded = false
local sentNotifs = false

local alreadyRunning = status:FindFirstChild("Dragon Style")
if alreadyRunning then
	Notify("Dragon Style is already loaded")
    task.wait(2)
    Notify("Have an error, report it to me.")
    namesChanged = true
    hasReloaded = true
    sentNotifs = true
end
 
 
alreadyRunning = Instance.new("BoolValue")
alreadyRunning.Parent = status
alreadyRunning.Value = true
alreadyRunning.Name = "Dragon Style"

Dragon.VisualName.Value = "Dragon"
Dragon.Speed.Value = 1.5
Dragon.Color.Value = Color3.fromRGB(255,0,0)
Dragon.Idle.AnimationId = "rbxassetid://12120045620"
if _G.DEMoveset == false or _G.DEMoveset == nil then
Dragon.Rush1.Value = "龍Attack1"
Dragon.Rush2.Value = "龍Attack2"
Dragon.Rush3.Value = "龍Attack3"
Dragon.Rush4.Value = "龍Attack4"
Dragon.Strike1.Value = "龍Strike1"
Dragon.Strike2.Value = "BStrike2"
Dragon.Strike3.Value = "BStrike3"
Dragon.Strike4.Value = "BStrike5"
Dragon.Strike5.Value = "龍Strike5"
Dragon["2Strike2"].Value = "龍2Strike1"
Dragon["2Strike3"].Value = "龍2Strike2"
Dragon["2Strike4"].Value = "龍2Strike3"
Dragon["2Strike5"].Value = "龍2Strike4"
elseif _G.DEMoveset == true then
moves.BStrike2.Anim.AnimationId = "rbxassetid://13785068836"
moves.B2Strike3.Anim.AnimationId = "rbxassetid://13785070193"
moves.BStrike4.Anim.AnimationId = "rbxassetid://13785070193"
moves["龍Strike5"].Anim.AnimationId = "rbxassetid://13731752257"
moves["龍Strike5"]:WaitForChild("AniSpeed").Value = 1.5
moves["龍Strike5"]:WaitForChild("MoveForward").Value = 12
moves.BStrike5:WaitForChild("ComboAt").Value = 0.6
moves.BStrike4:WaitForChild("ComboAt").Value = 0.6
Dragon.Rush1.Value = "龍Attack1"
Dragon.Rush2.Value = "龍Attack2"
Dragon.Rush3.Value = "龍Attack3"
Dragon.Rush4.Value = "BAttack3"
Dragon.GrabStrike.Value = "T_CounterQuickstep"
Dragon.Strike1.Value = "龍Strike1"
Dragon.Strike2.Value = "BStrike3" -- gut punch
Dragon.Strike3.Value = "BStrike2" -- leg sweep
Dragon.Strike4.Value = "BStrike5" -- uppercut
Dragon.Strike5.Value = "BStrike4" -- high leg sweep
Dragon["2Strike2"].Value = "BEvadeStrikeBack" -- evade punch
Dragon["2Strike3"].Value = "BStrike2" -- leg sweep
Dragon["2Strike4"].Value = "B2Strike3" -- high leg sweep
Dragon["2Strike5"].Value = "龍Strike5" -- hook kick
end
Dragon.H_FallenDown.Value = "H_FallenKick"
Dragon.H_CounterSoloAllFront.Value = "H_TSpinCounterFront"
Dragon.H_CounterSoloAllBack.Value = "H_TSpinCounterBack"
Dragon.H_CounterSoloAllLeft.Value = "H_TSpinCounterLeft"
Dragon.H_CounterSoloAllRight.Value = "H_TSpinCounterRight"
-- New Values --
r4 = Instance.new("StringValue", Dragon)
r4.Name = "H_Running4"
r4.Value = 'H_Terror'
ta = Instance.new("StringValue", Dragon)
ta.Name = "Taunt"
ta.Value = 'Taunt'
fh = Instance.new("StringValue", Dragon)
fh.Name = "H_FullHeat"
fh.Value = 'H_GUltimateEssence'
th = Instance.new("StringValue", Dragon)
th.Name = "H_TwoHandeds"
th.Value = 'H_SelfDestruct'
cs = Instance.new("StringValue", Dragon)
cs.Name = "H_CounterSolo"
cs.Value = 'H_Escape'
ds = Instance.new("StringValue", Dragon)
ds.Name = "H_Distanced"
ds.Value = 'H_FastFootworkBack' 
rd = Instance.new("Folder", Dragon)
rd.Name = "RedHeat"
ef = Instance.new("StringValue", Dragon)
ef.Name = "H_EvadedF"
ef.Value = 'H_FastFootworkFront'
el = Instance.new("StringValue", Dragon)
el.Name = "H_EvadedL"
el.Value = 'H_FastFootworkLeft'
er = Instance.new("StringValue", Dragon)
er.Name = "H_EvadedR"
er.Value = 'H_FastFootworkRight'
sf = Instance.new("StringValue", Dragon)
sf.Name = "H_StanceFallen"
sf.Value = "H_FallenBeatdown"
-- Sumo Slap Move Values
moves["H_FastFootworkBack"].Closest.Value = '30'
wn = Instance.new("StringValue", moves["H_FastFootworkBack"])
wn.Name = "Within"
wn.Value = '15'
-- Other Move Values --
if namesChanged == false then
    moves.Taunt.Name = "FakeTaunt"
    moves.DragonTaunt.Name = "Taunt"
if not IsInPvp() then
moves.BRCounter2.Name = "FakeBRCounter2"
    moves["龍TigerDrop"].Name = "BRCounter2"
    moves["BRCounter2"].AniSpeed.Value = 0.75
    moves["TigerDrop"].AniSpeed.Value = 0.75
    if not moves.BRCounter2:FindFirstChild("HSize") then
        HSize = Instance.new("NumberValue", moves.BRCounter2)
        HSize.Name = "HSize"
        HSize.Value = 2
        end
    end
end

moves.TigerDrop.Anim.AnimationId = "rbxassetid://12120052426"

-- FUNCTIONS -- 
local function add_forcefield(duration)
	local p = game.Players.LocalPlayer
	local Status = p.Status

	local invun = game.ReplicatedStorage.Invulnerable:Clone()
	invun.Parent = Status

	if duration then
		spawn(function()
			task.wait(duration)
			invun:Destroy()
		end)
	end

	return invun
end

local function FillHeat()
	local Event = game:GetService("ReplicatedStorage").Events.ME

	for i=1,6 do
		local A_1 =  {
			[1] = "heat", 
			[2] = game:GetService("ReplicatedStorage").Moves.Taunt
		}
		Event:FireServer(A_1)
	end
end


-- Ultimate Essence and Essence of Sumo Slapping --

local Player = game.Players.LocalPlayer
local Rep = game.ReplicatedStorage
local Char = Player.Character
local Main = Player.PlayerGui.Interface.Battle.Main

local function fetchRandom(instance)
	    local instancechildren = instance:GetChildren()
	    local random = instancechildren[math.random(1, #instancechildren)]
	    return random
	end

vpSound = (function(a1) -- PlaySound
u10.playsound(a1, u9.hrp, nil, nil, true)
local SoundEvent = {
    [1] = "repsound",
    [2] = a1
}
u5:FireServer(SoundEvent)
end)

Main.HeatMove.TextLabel:GetPropertyChangedSignal("Text"):Connect(function()
    if Main.HeatMove.TextLabel.Text == "Ultimate Essence" and not plr.Character:FindFirstChild("BeingHeated") then
        local Anim = Char.Humanoid:LoadAnimation(Rep.Moves.H_UltimateEssence.Anim)
        Anim.Priority = Enum.AnimationPriority.Action4
        Anim:AdjustSpeed(1)
        Anim:Play()
	vpSound(fetchRandom(Rep.Voices.Kiryu.Taunt))
        task.wait(1)
        PlaySound("MassiveSlap")
        task.wait(2)
        Anim:Destroy()
    end
end)

Main.HeatMove.TextLabel:GetPropertyChangedSignal("Text"):Connect(function()
    if Main.HeatMove.TextLabel.Text == "Essence of Sumo Slapping " and not char:FindFirstChild("BeingHeated") then
        local Anim = Char.Humanoid:LoadAnimation(Rep.Moves.H_SumoSlap.Anim)
        Anim.Priority = Enum.AnimationPriority.Action4
        Anim:AdjustSpeed(1)
        Anim:Play()
        task.wait(0.1)
        PlaySound("Slap")
        task.wait(0.45)
        PlaySound("Slap")
        task.wait(0.45)
        PlaySound("Slap")
        task.wait(0.9)
        PlaySound("MassiveSlap")
        Anim:Destroy()
    end
end)

-- Aura, Idle Stance, Hact Renames, No Heat Action Label
local anim = game.Players.LocalPlayer.Character.Humanoid.Animator:LoadAnimation(game.ReplicatedStorage.AIStyles.Dragon.StanceIdle)
anim.Priority = Enum.AnimationPriority.Movement

local DragonText = "Dragon"
styles.Blade.Color.Value = Color3.fromRGB(0,0,0)
local DragonColor = Color3.new(1,0,0)
local DSeq = ColorSequence.new({ColorSequenceKeypoint.new(0, DragonColor), ColorSequenceKeypoint.new(1, DragonColor)})
local NoTrail = ColorSequence.new({ColorSequenceKeypoint.new(0, styles.Blade.Color.Value), ColorSequenceKeypoint.new(1, styles.Blade.Color.Value)})

local function UpdateStyle()
if status.Style.Value == "Brawler" then
		char.HumanoidRootPart.Fire_Main.Color = DSeq
        char.HumanoidRootPart.Fire_Secondary.Color = DSeq
        char.HumanoidRootPart.Fire_Main.Rate = status.Heat.Value >= 100 and 115 or status.Heat.Value >= 75 and 85 or 80
        char.HumanoidRootPart.Fire_Secondary.Rate = status.Heat.Value >= 100 and 90 or status.Heat.Value >= 75 and 80 or 70
        char.HumanoidRootPart.Lines1.Color = DSeq
        char.HumanoidRootPart.Lines1.Rate = status.Heat.Value >= 100 and 60 or status.Heat.Value >= 75 and 40 or 20
        char.HumanoidRootPart.Lines2.Color = DSeq
        char.HumanoidRootPart.Lines2.Rate = status.Heat.Value >= 100 and 60 or status.Heat.Value >= 75 and 40 or 20
        char.HumanoidRootPart.Sparks.Color = DSeq
        if not char.HumanoidRootPart.TimeFor.Enabled then
            char.HumanoidRootPart.TimeFor.Color = DSeq
        end

        char.UpperTorso["r2f_aura_burst"].Lines1.Color = DSeq
        char.UpperTorso["r2f_aura_burst"].Lines2.Color = DSeq
       	char.UpperTorso["r2f_aura_burst"].Lines1.Enabled = showMaxHeatEffect()
		char.UpperTorso["r2f_aura_burst"].Flare.Enabled = showMaxHeatEffect()
        char.UpperTorso["r2f_aura_burst"].Flare.Color = DSeq
        char.UpperTorso["r2f_aura_burst"].Smoke.Color = DSeq
        char.UpperTorso.Evading.Color = NoTrail

  	if main.HeatMove.TextLabel.Text == "Essence of Fisticuffs" then
		main.HeatMove.TextLabel.Text = "Essence of Battery"
	elseif main.HeatMove.TextLabel.Text == "Guru Firearm Flip" then
		main.HeatMove.TextLabel.Text = "Komaki Shot Stopper"
	elseif main.HeatMove.TextLabel.Text == "Essence of Fast Footwork [Back]" then
		main.HeatMove.TextLabel.Text = "Essence of Sumo Slapping "
    elseif main.HeatMove.TextLabel.Text == "Ultimate Essence" then
		main.HeatMove.TextLabel.Text = "Ultimate Essence "
	    end
    end
    main.Heat.noheattho.Text = "Heat Actions Disabled"
	main.Heat.noheattho.Size = UDim2.new(10, 0, 1, 0)
    menu.Bars.Mobile_Title.Text = "Dragon Style Mod by d_ucksy"
	menu.Bars.Mobile_Title.Visible = true
    
    if menu.Bars.Mobile_Title.Text ~= "Dragon Style Mod by d_ucksy" then
        plr:Kick("Do not try to change credits.")
    elseif menu.Bars.Mobile_Title.Visible ~= true then
        plr:Kick("Do not try to disable credits.")
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    UpdateStyle()
end)

-- Red Dragon Spirit --

if not status:FindFirstChild("RedDragonSpirit") then
RDS = Instance.new("BoolValue", status)
RDS.Value = false 
RDS.Name = "RedDragonSpirit"
else
RDS = status.RedDragonSpirit
end

local function HealthChanged()
if status.Health.Value <= 150 then
    RDS.Value = true
elseif status.Health.Value >= 150 then
    RDS.Value = false
    end
end

plr.Status.Health.Changed:Connect(HealthChanged)

local receivedsound = fetchRandom(RPS.Voices.Kiryu.Rage)
RDS.Changed:Connect(function()
if RDS.Value == true or status:FindFirstChild("ANGRY") then
    FillHeat()
    local invul = Instance.new("Folder",status)
    invul.Name = "Invulnerable" 
    vpSound(receivedsound)
    Notify("Red Dragon Spirit Activated")
    if not status:FindFirstChild("Invulnerable") then
	local invul = Instance.new("Folder",status)
	invul.Name = "Invulnerable"
elseif RDS.Value == false or not status:FindFirstChild("ANGRY") then
    if status:FindFirstChild("Invulnerable") then
	status.Invulnerable:Destroy()
			end
		end
	end
end)
thing = Instance.new("BoolValue", workspace)
local Event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ME")
local function Slap(enemy)
    local A_1 = {
                [1] = "damage", 
                [3] = enemy, 
                [4] = plr.Character.RightHand.Position, --right hand
                [5] = game:GetService("ReplicatedStorage").Moves.Slapper, --Slapper
                [6] = "Brawler", 
                [7] = 0.04611371246065557, 
                [11] = Vector3.new(-0.9940911531448364, -0, 0.10854917764663696), 
                [13] = plr.Character.HumanoidRootPart.Position, --rootpart 
                [14] = CFrame.new(enemy.Position.X, enemy.Position.Y, enemy.Position.Z, -0.108549215, -1.1197094e-05, 0.994091153, 0.000829752884, 0.999999642, 0.000101868049, -0.994090796, 0.000835907587, -0.108549178)
    }
if thing.Value == false then
        thing.Value = true
        Event:FireServer(A_1)
    end
end

local function AutoSlap()
    if RDS.Value == true or status:FindFirstChild("ANGRY") then
        for i,enemy in pairs(game.Workspace.Bots.AI:GetDescendants()) do
            if enemy:IsA("MeshPart") and enemy.Name == "HumanoidRootPart" and enemy.Parent.LastTarget.Value == plr.Character.HumanoidRootPart then
                if enemy.Parent.AttackBegan.Value == true then
                    enemy.Parent.AttackBegan.Value = false
                    thing.Value = false
                    Slap(enemy)
                end
                if enemy.Parent.TookAim.Value == true then
                    enemy.Parent.TookAim.Value = false
                    wait(0.6)
                    thing.Value = false                
                    Slap(enemy)
                end
            end
        end
    end
end


game:GetService("RunService").RenderStepped:Connect(AutoSlap)
-- Feel The Heat

local EnemyText = pgui.EInterface.EnemyHP.TextLabel

local CanFeelHeat = Instance.new("BoolValue", workspace)
local IsBoss = false
local HPCorrect = Instance.new("BoolValue", workspace)
local AlreadyFeltHeat = Instance.new("BoolValue", workspace)

local BossHPTable = {
     "1000/3000",
     "1000/4200",
     "1000/1200",
     "999/3000",
     "999/4200",
     "999/1200",
     "998/3000",
     "998/4200",
     "998/1200",
     "997/3000",
     "997/4200",
     "997/1200",
     "996/3000",
     "996/4200",
     "996/1200",
     "995/3000",
     "995/4200",
     "995/1200",
     "994/3000",
     "994/4200",
     "994/1200",
     "993/3000",
     "993/4200",
     "993/1200",
     "992/3000",
     "992/4200",
     "992/1200",
     "991/3000",
     "991/4200",
     "991/1200",
     "990/1200",
     "990/3000",
     "990/4200",
     "989/3000",
     "989/4200",
     "989/1200",
     "988/3000",
     "988/4200",
     "988/1200",
     "987/3000",
     "987/4200",
     "987/1200",
     "986/3000",
     "986/4200",
     "986/1200",
     "985/3000",
     "985/4200",
     "985/1200",
     "984/3000",
     "984/4200",
     "984/1200",
     "983/3000",
     "983/4200",
     "983/1200",
     "982/3000",
     "982/4200",
     "982/1200",
     "981/3000",
     "981/4200",
     "981/1200",
     "980/3000",
     "980/4200",
     "980/1200"
}

local CanFeelHeat = Instance.new("BoolValue", workspace)
local HPCorrect = Instance.new("BoolValue", workspace)

pgui.EInterface.EnemyHP.BG.Meter.HPTxt:GetPropertyChangedSignal("Text"):Connect(function()
if table.find(BossHPTable, pgui.EInterface.EnemyHP.BG.Meter.HPTxt.Text) then
    CanFeelHeat.Value = true
    else
    CanFeelHeat.Value = false
    end
end)


CanFeelHeat.Changed:Connect(function()
if CanFeelHeat.Value == true and AlreadyFeltHeat.Value == false then
Notify("FEEL THE HEAT!!!")
    local anim = char.Humanoid:LoadAnimation(styles.Beast.Block)
    anim.Priority = Enum.AnimationPriority.Action4
    local id = "rbxassetid://10928237540"
    local SuperCharge = Instance.new("Animation", workspace)
    SuperCharge.AnimationId = id
    anim:Play()
    v = Instance.new("Folder", status)
    v.Name = "Invulnerable"
    char.HumanoidRootPart.Anchored = true
    task.wait(3)
    anim:Stop()
    game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(SuperCharge):Play()
    task.wait(0.25)
    char.HumanoidRootPart.Anchored = false
    FillHeat()
    PlaySound("Yell")
    SuperCharge:Destroy()
    task.wait(2)
    v:Destroy()
    AlreadyFeltHeat.Value = true
    end
end)


local function OnBattleStart()
if AlreadyFeltHeat.Value == true then
AlreadyFeltHeat.Value = false
    end
end
local function OnBattleEnd()
if AlreadyFeltHeat.Value == false then
AlreadyFeltHeat.Value = true
end

if not battleWatcher then
		battleWatcher = true
		while true do
			repeat task.wait() until isInBattle()
			coroutine.wrap(function()
				onBattleStart()
			end)()
			repeat task.wait() until not isInBattle()
			coroutine.wrap(function()
				onBattleEnd()
			end)()
		end
	end
end

-- Style Change Animation --
status.Style.Changed:Connect(function()
if status.Style.Value == "Brawler" then
	local id = "rbxassetid://10928237540"
			local anim = Instance.new("Animation")
			anim.AnimationId = id

			game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(anim):Play()

			task.wait(5)
            anim:Destroy()
	end
end)

status.RedDragonSpirit.Changed:Connect(function()
if status.Style.Value == "Brawler" then
	local id = "rbxassetid://10928237540"
			local anim = Instance.new("Animation")
			anim.AnimationId = id
			game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(anim):Play()

			task.wait(5)
            anim:Destroy()
	end
end)

-- Reload 
local plr = game:GetService("Players").LocalPlayer
local pgui = plr.PlayerGui
local interf = pgui.Interface

local cframe = plr.Character.LowerTorso.CFrame
if hasReloaded == false then
interf.Client.Disabled = true
task.wait()
interf.Client.Disabled = false
end

moves.BRCounter2.Anim.AnimationId = "rbxassetid://12338275115"
moves.TigerDrop.Anim.AnimationId = "rbxassetid://12338275115"

local styleToChange = "Brawler" --Brawler = fisticuffs, Rush = frenzy, Beast = brute.  you MUST use one of these 3 or else you cannot use the custom style.
local styleToChangeTo = "堂島の龍" -- is Dragon Style
local characterToChange = "Your Avatar"
local characterToChangeTo = "Kiryu Morph"

if sentNotifs == false then
game.StarterGui:SetCore("SendNotification",{
    Title = styleToChangeTo.." style loaded!";
    Text = styleToChangeTo.." style has replaced "..styleToChange..".";
    Button1 = "OK!";
})
end

if _G.MorphMod == true then
_G.Morph = "Legendary Dragon"          
loadstring(game:HttpGet("https://raw.githubusercontent.com/aAAAakakrvmv192/R2FMods/main/charmorphmod.lua"))();
if sentNotifs then
game.StarterGui:SetCore("SendNotification",{
    Title = characterToChange.." Is Invisible";
    Text = characterToChangeTo.."Has Replaced "..characterToChange..".";
    Button1 = "OK!";
})
    end
end
if _G.CustomMorphSkin == true and _G.MorphMod == true then
char.Ignore.FakeUpperTorso["Kiryu_Buttons"].Color = Color3.fromRGB(228,212,0)
char.Ignore.FakeUpperTorso["Kiryu_Shirt"].Color = Color3.fromRGB(255,255,255)
char.Ignore.FakeUpperTorso["Kiryu_Suit"].Color = Color3.fromRGB(42,42,42)
char.Ignore.FakeLeftLowerArm["Suit_CuffSL"].Color = Color3.fromRGB(237,220,0)
char.Ignore.FakeLeftLowerArm["Suit_CuffL"].Color = Color3.fromRGB(42,42,42)
char.Ignore.FakeRightLowerArm["Suit_CuffSR"].Color = Color3.fromRGB(237,220,0)
char.Ignore.FakeRightLowerArm["Suit_CuffR"].Color = Color3.fromRGB(42,42,42)
char.Ignore.FakeLeftLowerLeg["Suit_PantL"].Color = Color3.fromRGB(42,42,42)
char.Ignore.FakeRightLowerLeg["Suit_PantR"].Color = Color3.fromRGB(42,42,42)
char.Ignore.FakeLowerTorso["Kiryu_Belt"].Color = Color3.fromRGB(42,42,42)
char.Ignore.FakeLowerTorso["Kiryu_BeltLoop"].Color = Color3.fromRGB(237,220,0)
char.Ignore.FakeLowerTorso["Kiryu_Tail"].Color = Color3.fromRGB(42,42,42)
char.LowerTorso.Color = Color3.fromRGB(42,42,42)
char.UpperTorso.Color = Color3.fromRGB(42,42,42)
char.RightUpperArm.Color = Color3.fromRGB(42,42,42)
char.LeftUpperArm.Color = Color3.fromRGB(42,42,42)
char.RightLowerArm.Color = Color3.fromRGB(42,42,42)
char.LeftLowerArm.Color = Color3.fromRGB(42,42,42)
char.LowerTorso.Color = Color3.fromRGB(42,42,42)
char.LeftUpperLeg.Color = Color3.fromRGB(42,42,42)
char.LeftLowerLeg.Color = Color3.fromRGB(42,42,42)
char.RightUpperLeg.Color = Color3.fromRGB(42,42,42)
char.RightLowerLeg.Color = Color3.fromRGB(42,42,42)
end
playSound = (function(a1) -- PlaySound
u10.playsound(a1, u9.hrp, nil, nil, true)
local SoundEvent = {
    [1] = "repsound",
    [2] = a1
}
u5:FireServer(SoundEvent)
end)

if _G.VoiceMod == true then
	_G.voicepack = "Kiryu" -- Current available voices: "Kiryu", "Akiyama", "Majima" and "Vulcan"
	local player = game.Players.LocalPlayer
	local character = player.Character
	local pgui = player.PlayerGui
	local status = player.Status
	local RPS = game.ReplicatedStorage
	_G.voice = RPS.Voices:FindFirstChild(_G.voicepack)
	
	print(_G.voice.Name)
	local function fetchRandom(instance)
	    local instancechildren = instance:GetChildren()
	    local random = instancechildren[math.random(1, #instancechildren)]
	    return random
	end

local plr = game.Players.LocalPlayer
local pgui = plr.PlayerGui
local interf = pgui.Interface
local bt = interf.Battle
local main = bt.Main

	
	local alreadyRunning = status:FindFirstChild("Voice Mod")
	if alreadyRunning then
	   Notify("Selected voice: ".._G.voice.Name, Color3.fromRGB(255, 255, 255))
	    return
	end 
	
	alreadyRunning = Instance.new("BoolValue")
	alreadyRunning.Parent = status
	alreadyRunning.Value = true
	alreadyRunning.Name = "Voice Mod"
	
	Notify("Voice Mod loaded", Color3.fromRGB(255, 255, 255))
	Notify("Selected voice: ".._G.voice.Name, Color3.fromRGB(255, 255, 255))
	local receivedsound
	
	player.ChildAdded:Connect(function(child)
	    if child.Name == "InBattle" then
	        receivedsound = fetchRandom(_G.voice.BattleStart)
	        playSound(receivedsound)
	    end 
	end) 
	local hitCD = false
	character.ChildAdded:Connect(function(child)
	    if child.Name == "Heated" and child:WaitForChild("Heating",0.5).Value ~= character then
	        local isThrowing = child:WaitForChild("Throwing",0.5)
	        if not isThrowing then
	        receivedsound = fetchRandom(_G.voice.HeatAction)
	        playSound(receivedsound)
			end
	    end
		if child.Name == "Hitstunned" and not character:FindFirstChild("Ragdolled") then
			if hitCD == false then
			hitCD = true
	        receivedsound = fetchRandom(_G.voice.Pain)
	        playSound(receivedsound)
			delay(2,function()
				hitCD = false
			end)
			end
		end
		if child.Name == "Ragdolled" then
	        receivedsound = fetchRandom(_G.voice.Knockdown)
	        playSound(receivedsound)
	    end
	    if child.Name == "ImaDea" then
	        receivedsound = fetchRandom(_G.voice.Death)
	        playSound(receivedsound)
	    end
		if child.Name == "Stunned" then
	        receivedsound = fetchRandom(_G.voice.Stun)
	        playSound(receivedsound)
	    end
	end)
	
	character.ChildRemoved:Connect(function(child)
		if child.Name == "Ragdolled" then
			wait(0.1)
			if not string.match(status.CurrentMove.Value.Name, "Getup") then
			receivedsound = fetchRandom(_G.voice.Recover)
	        playSound(receivedsound)
			end
		end
	end)
	
	character.HumanoidRootPart.ChildAdded:Connect(function(child)
	    if child.Name == "KnockOut" or child.Name == "KnockOutRare" then
	                child.Volume = 0
	            end
	end) 
	local dodgeCD = false
	status.FFC.Evading.Changed:Connect(function()
	    if status.FFC.Evading.Value == true and character:FindFirstChild("BeingHacked") and not dodgeCD then
	        dodgeCD = true
	        receivedsound = fetchRandom(_G.voice.Dodge)
	        playSound(receivedsound)
	        delay(10,function()
	            dodgeCD = false
	        end)
	    end
	end)
	local fakeTauntSound = RPS.Sounds:FindFirstChild("Laugh"):Clone()
	fakeTauntSound.Parent = RPS.Sounds
	fakeTauntSound.Name = "FakeLaugh"
	fakeTauntSound.Volume.Value = 0
	RPS.Moves.Taunt.Sound.Value = "FakeLaugh"
	RPS.Moves.RushTaunt.Sound.Value = "FakeLaugh"
	RPS.Moves.GoonTaunt.Sound.Value = "FakeLaugh"
	status.Taunting.Changed:Connect(function()
	    if status.Taunting.Value == true and status.CurrentMove.Value.Name ~= "BeastTaunt" then
	        receivedsound = fetchRandom(_G.voice.Taunt)
	        playSound(receivedsound)
	    end
	end)
	local lattackCD = false
	status.CurrentMove.Changed:Connect(function()
	    if string.match(status.CurrentMove.Value.Name, "Attack") or string.match(status.CurrentMove.Value.Name, "Punch") then
	        if lattackCD == false then
	            lattackCD = true
	        receivedsound = fetchRandom(_G.voice.LightAttack)
	        playSound(receivedsound)
	        delay(0.35, function()
	        lattackCD = false
	        end)
	    end
	    else
	    if not string.match(status.CurrentMove.Value.Name, "Taunt") and not string.match(status.CurrentMove.Value.Name, "Grab") then
	    receivedsound = fetchRandom(_G.voice.HeavyAttack)
	    playSound(receivedsound)
	    end
	    end
	end)
	
	game.UserInputService.InputBegan:Connect(function(key)
		if game.UserInputService:GetFocusedTextBox() == nil then
			if key.KeyCode == Enum.KeyCode.H then
					if _G.voicepack == "Kiryu" then
						_G.voicepack = "Akiyama"
					elseif _G.voicepack == "Akiyama" then
						_G.voicepack = "Majima"
					elseif _G.voicepack == "Majima" then
						_G.voicepack = "Vulcan"
					elseif _G.voicepack == "Vulcan" then
						_G.voicepack = "Kiryu"
					end
					_G.voice = RPS.Voices:FindFirstChild(_G.voicepack)
					Notify("Selected voice: ".._G.voice.Name, Color3.fromRGB(255, 255, 255))
			end	
		end
	end)
end
menu.Abilities.Frame.Frame.Frame.Tabs.Tabs.Brawler.Filled.Title.Text = "Dragon"
menu.Abilities.Frame.Frame.Frame.Tabs.Tabs.Rush.Filled.Title.Text = "Rush"
menu.Abilities.Frame.Frame.Frame.Tabs.Tabs.Beast.Filled.Title.Text = "Beast"
                    --Ability Names--
local list = {
["Counter Hook"] = "Komaki Tiger Drop (Lvl. 25)",
["Guru Parry"] = "Komaki Parry",
["Time for Resolve"] = "Red Dragon Spirit (Lvl. 20)",
["Finishing Hold"] = "Essence of Sumo Slapping (Lvl. 15)",
["Ultimate Essence"] = "Ultimate Essence (Lvl. 30)",
["Guru Dodge Shot"] = "Komaki Evade & Strike",
["Guru Spin Counter"] = "Komaki Fist Reversal",
["Guru Firearm Flip"] = "Komaki Shot Stopper",
["Guru Knockback"] = "Komaki Knockback",
["Guru Safety Roll"] = "Komaki Dharma Tumbler"
}

menu.Abilities.Frame.Frame.Frame.List.ListFrame.ChildAdded:Connect(function(v)
  local rename = list[v.Name]
  if rename then
    v.Generic.Label.Text = rename
  end
end)
            --Ability descriptions and prompts--
abilFolder["Time for Resolve"].Description.Value = "Unleash the willpower of the Legendary Red Dragon to fly above the rest and withstand any attacks that would stagger or knock you down."
abilFolder["Guru Parry"].Description.Value = "One of the Three Ultimate Komaki style moves. Stuns the enemy."
abilFolder["Guru Knockback"].Description.Value = "One of the Three Ultimate Komaki style moves. Send an enemy's attack right back at them."
abilFolder["Counter Hook"].Description.Value = "One of the Three Ultimate Komaki style moves. The style's strongest counter-attack."
abilFolder["Counter Hook"].Prompt.Value = "Get in Stance with LOCK ON, then HEAVY ATTACK when the enemy attacks."
abilFolder["Finishing Hold"].Description.Value = "Make a sudden move towards the enemy and slap them with your open hand."
abilFolder["Finishing Hold"].Prompt.Value = "Get in Stance with LOCK ON and whilst distanced, HEAVY ATTACK."
abilFolder["Ultimate Essence"].Prompt.Value = "Get in Stance with LOCK ON and with Full Heat, HEAVY ATTACK"
abilFolder["Ultimate Essence"].Description.Value = "The Ultimate Komaki Ability. Gain the Power to destroy every type of enemy."
