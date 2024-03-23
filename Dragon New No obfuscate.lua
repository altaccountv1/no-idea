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

char.Head:FindFirstChild("HeavyYell"):Destroy()
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

local function Notify(Text,Sound,Color,Fonts) --text function, sounds: tp, buzz, Gong, HeatDepleted
	local Text1 = string.upper(Text)
	if Sound then
		pgui.Notify:Fire(Text,Sound)
	else
		pgui.Notify:Fire(Text)
	end
	if Color then
		for i,v in pairs(pgui.NotifyUI.Awards:GetChildren()) do
			if v.Name == "XPEx" and v.Text == Text1 then
				v.Text = Text
				v.TextColor3 = Color
				if Fonts then
				    v.Font = Enum.Font[Fonts]
				end
			end
		end
	end
end


local namesChanged = false
local hasReloaded = false
local sentNotifs = false

local alreadyRunning = status:FindFirstChild("Dragon Style")
if alreadyRunning then
    Notify("Dragon Style is already loaded", "buzz", Color3.fromRGB(255,255,255), "RobotoMono")
    task.wait(2)
    Notify("If you have an error, report it to me.", "HeatDepleted", Color3.fromRGB(255,255,255), "RobotoMono")
    namesChanged = true
    hasReloaded = true
    sentNotifs = true
    return
end
 
moves[Dragon.Strike1.Value].Anim.AnimationId = moves.BStrike1.TurnAnim.AnimationId
alreadyRunning = Instance.new("BoolValue")
alreadyRunning.Parent = status
alreadyRunning.Value = true
alreadyRunning.Name = "Dragon Style"

local Beast = styles.Beast
local Rush = styles.Rush
Dragon.VisualName.Value = "Dragon"
Dragon.Speed.Value = 1.25
Dragon.Color.Value = Color3.fromRGB(255,0,0)
Dragon.Pummel.Value = "T_龍GParry"
Dragon.Idle.AnimationId = "rbxassetid://12120045620"
Dragon.StanceStrike.Value = "CounterHook"
Dragon.BlockStrike.Value = "ShuckyDrop"
Dragon.EvadeStrikeB.Value = "TigerDrop"
Rush.EvadeF.AnimationId = Dragon.EvadeF.AnimationId
Rush.EvadeB.AnimationId = Dragon.EvadeB.AnimationId
Rush.EvadeL.AnimationId = Dragon.EvadeL.AnimationId
Rush.EvadeR.AnimationId = Dragon.EvadeR.AnimationId
Rush.EvadeCF.AnimationId = Dragon.EvadeF.AnimationId
Rush.EvadeCB.AnimationId = Dragon.EvadeB.AnimationId
Rush.EvadeCL.AnimationId = Dragon.EvadeL.AnimationId
Rush.EvadeCR.AnimationId = Dragon.EvadeR.AnimationId
Rush.EvadeQCF.AnimationId = Dragon.EvadeF.AnimationId
Rush.EvadeQCB.AnimationId = Dragon.EvadeB.AnimationId
Rush.EvadeQCL.AnimationId = Dragon.EvadeL.AnimationId
Rush.EvadeQCR.AnimationId = Dragon.EvadeR.AnimationId
local walkf = Dragon.WalkF:Clone()
walkf.Parent = Rush
local walkb = Dragon.WalkB:Clone()
walkb.Parent = Rush
local walkl = Dragon.WalkL:Clone()
walkl.Parent = Rush
local walkr = Dragon.WalkR:Clone()
walkr.Parent = Rush
if Dragon.GrabStrike:FindFirstChild("Ability") then
Dragon.GrabStrike.Ability.Value = "Guru Parry"
Dragon.StanceStrike.Ability.Value = "Counter Hook"
Dragon.BlockStrike.Ability.Value = "Guru Knockback"
else
    if not Dragon.GrabStrike:FindFirstChild("Ability") then
        local ability = Instance.new("StringValue", Dragon.GrabStrike) ability.Value = "Guru Parry"
    elseif not Dragon.StanceStrike:FindFirstChild("Ability") then
        local ability = Instance.new("StringValue", Dragon.StanceStrike) ability.Value = "Counter Hook"
    elseif not Dragon.BlockStrike:FindFirstChild("Ability") then
        local ability = Instance.new("StringValue", Dragon.BlockStrike) ability.Value = "Guru Knockback"
    end
end
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
moves.BStrike2.ComboAt.Value -= 0.15
Dragon.GrabStrike.Value = "T_龍GParry"
moves["龍2Strike2"].AniSpeed.Value = 1.45
moves["龍2Strike2"].MoveForward.Value -= 4
moves.BStrike2.MoveForward.Value -= 3
moves.BStrike3.AniSpeed.Value += 0.05
moves.BStrike3.ComboAt.Value -= 0.05
moves["龍Strike1"].Anim.AnimationId = "rbxassetid://13731752257"
moves.BStrike5.Anim.AnimationId = moves["龍2Strike1"].Anim.AnimationId
moves.BStrike5.AniSpeed.Value += 0.05
moves.BStrike5.ComboAt.Value -= 0.1
moves["龍Strike5"].HitboxLocations.Value = '[["LeftFoot",2,[0,0,0]],["LeftLowerLeg",1.5,[0,0,0]],["LeftUpperLeg",1,[0,0,0]]]'
moves["龍Strike5"].Anim.AnimationId = moves.BStrike1.TurnAnim.AnimationId
else
moves.BStrike2.Anim.AnimationId = "rbxassetid://13785068836"
moves.B2Strike3.Anim.AnimationId = "rbxassetid://13785070193"
moves.BStrike4.Anim.AnimationId = "rbxassetid://13785070193"
moves["龍Strike5"].Anim.AnimationId = "rbxassetid://13731752257"
moves["龍Strike5"]:WaitForChild("AniSpeed").Value = 1.5
moves["龍Strike5"]:WaitForChild("MoveForward").Value = 12
moves.BStrike5:WaitForChild("ComboAt").Value = 0.6
moves.BStrike4:WaitForChild("ComboAt").Value = 0.6
moves.BStrike4.AniSpeed.Value = moves.B2Strike3.AniSpeed.Value
Dragon.Rush1.Value = "龍Attack1"
Dragon.Rush2.Value = "龍Attack2"
Dragon.Rush3.Value = "龍Attack3"
Dragon.Rush4.Value = "BAttack1"
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
Dragon.H_FallenDown.Value = "H_FallenGrate"
Dragon.H_CounterSoloAllFront.Value = "H_TSpinCounterFront"
Dragon.H_CounterSoloAllBack.Value = "H_TSpinCounterBack"
Dragon.H_CounterSoloAllLeft.Value = "H_TSpinCounterLeft"
Dragon.H_CounterSoloAllRight.Value = "H_TSpinCounterRight"
rush.VisualName.Value = "Rush"
beast.VisualName.Value = "Beast"
beast.Strike2.Value = "DashAttack"
beast.Strike4.Value = "DerekCharge"
moves.T_GuruParry.Anim.AnimationId = moves["T_龍GParry"].Anim.AnimationId
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
sf.Value = "H_FallenStomp"
-- Sumo Slap Move Values
moves["H_FastFootworkBack"].Closest.Value = '30'
wn = Instance.new("StringValue", moves["H_FastFootworkBack"])
wn.Name = "Within"
wn.Value = '15'
moves.TigerDrop.MoveForward.Value += 5
-- Other Move Values --
if namesChanged == false then
    moves.Taunt.Name = "FakeTaunt"
    moves.DragonTaunt.Name = "Taunt"
    moves.BGetup.Anim.AnimationId = moves.RSweep.Anim.AnimationId
    moves.BGetup.HitboxLocations.Value = moves.RSweep.HitboxLocations.Value
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

moves.ShuckyDrop.Anim.AnimationId = moves.GuruStumble.Anim.AnimationId
moves.ShuckyDrop.AniSpeed.Value = moves.GuruStumble.AniSpeed.Value
moves.ShuckyDrop.MoveForward.Value = moves.GuruStumble.MoveForward.Value
moves.ShuckyDrop.SF.Value = 0.1
whenattack = Instance.new("Folder", moves.ShuckyDrop)
whenattack.Name = "WhenAttacking"
counter = Instance.new("Folder", moves.ShuckyDrop)
counter.Name = "CounterAttack" 
moves.CounterHook.Anim.AnimationId = "rbxassetid://12120052426"
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

local feelingheat = Instance.new("BoolValue")
feelingheat.Value = false
thing = Instance.new("BoolValue")
local Event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ME")

function UseHeatAction(HeatAction, Style, Bots)
	local args = {
		[1] = {
			[1] = "heatmove",
			[2] = game:GetService("ReplicatedStorage").Moves[HeatAction],
			[3] = {

			},
			[4] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame,
			[5] = Style
		}
	}

	for i,v in pairs(Bots) do
		table.insert(args[1][3], {
			[1] = v,
			[2] = 10.49982091806829,
			[3] = false,
			[4] = Vector3.new(0.854888916015625, -0.499908447265625, -3.08367919921875)
		})
	end

	game:GetService("ReplicatedStorage").Events.ME:FireServer(unpack(args))
end

local function Hit(Move, Enemy)
    local A_1 = {
                [1] = "damage", 
                [3] = Enemy, 
                [4] = plr.Character.RightHand.Position,
                [5] = game:GetService("ReplicatedStorage").Moves[Move],
                [6] = "Brawler", 
                [7] = 0.04611371246065557, 
                [11] = Vector3.new(-0.9940911531448364, -0, 0.10854917764663696), 
                [13] = char.HumanoidRootPart.Position, --rootpart 
                [14] = CFrame.new(Enemy.Position.X, Enemy.Position.Y, Enemy.Position.Z, -0.108549215, -1.1197094e-05, 0.994091153, 0.000829752884, 0.999999642, 0.000101868049, -0.994090796, 0.000835907587, -0.108549178)
    }
if thing.Value == false then
        thing.Value = true
        Event:FireServer(A_1)
    end
end

local function play_ingamesound(sfxname)
	local v = game.ReplicatedStorage.Sounds:FindFirstChild(sfxname)
	local sfx = Instance.new("Sound", nil)
	local id = v.Value

	sfx.SoundId = id

	for i,v in pairs(v:GetChildren()) do
		sfx[v.Name] = v.Value
	end

	game.SoundService:PlayLocalSound(sfx)
	task.delay(15, function()
		sfx:Destroy()
	end)
end

local function playsound(id)
	local sfx = Instance.new("Sound", workspace)
	sfx.SoundId = "rbxassetid://"..tostring(id)

	game:GetService("SoundService"):PlayLocalSound(sfx)

	spawn(function()
		task.wait(sfx.TimeLength)
		sfx:Destroy()
	end)
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

local A_1 =  {
	[1] = "heat", 
	[2] = game:GetService("ReplicatedStorage").Moves.Taunt
}

local A_2 = {
  [1] = {
    [1] = "evade",
    [3] = false,
    [4] = true
  }
}

local function fillHeat(howmany)
	for i = 1, howmany do
		ME:FireServer(A_1)
	end
end

local function depleteHeat(howmany)
	for i = 1, howmany do
		ME:FireServer(A_2)
	end
end

local SlapUlt = false
local DOD88 = false

status.CurrentMove.Changed:Connect(function()
    if status.CurrentMove.Value ~= moves["龍Attack2"] then
	SlapUlt = true
	DOD88 = false
    elseif status.CurrentMove.Value == moves["龍Attack2"] then
	SlapUlt = false
	DOD88 = true
    end
end)

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

local function Stun(enemy)
    local A_1 = {
                [1] = "damage", 
                [3] = enemy, 
                [4] = plr.Character.RightHand.Position, --right hand
                [5] = game:GetService("ReplicatedStorage").Moves.ShuckyDrop, --Slapper
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
    if RDS.Value == true then
        for i,enemy in pairs(game.Workspace.Bots.AI:GetDescendants()) do
            if enemy:IsA("MeshPart") and enemy.Name == "HumanoidRootPart" and enemy.Parent.LastTarget.Value == plr.Character.HumanoidRootPart and not IsInPvp() then
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
        if IsInPvp() then
	    if game.Players:GetPlayerFromCharacter(char.LockedOn.Value.Parent) then
	        local opp = game.Players:GetPlayerFromCharacter(char.LockedOn.Value.Parent)
	        if opp.Status.AttackBegan.Value == true then
                    opp.Status.AttackBegan.Value = false
                    thing.Value = false
                    Slap(char.LockedOn.Value)
	        end	
	    end
	end
    end
end

game:GetService("RunService").RenderStepped:Connect(AutoSlap)

Main.HeatMove.TextLabel:GetPropertyChangedSignal("Text"):Connect(function()
    if Main.HeatMove.TextLabel.Text == "Ultimate Essence" and not plr.Character:FindFirstChild("BeingHeated") and SlapUlt == true and DOD88 == false then -- dargon of dojima 88 or slap ult.
	local soundr = Rep.Voices.Kiryu.Taunt["taunt2 (2)"]
        local Anim = Char.Humanoid:LoadAnimation(Rep.Moves.H_UltimateEssence.Anim)
        Anim.Priority = Enum.AnimationPriority.Action4
        Anim:AdjustSpeed(1)
        Anim:Play()
	vpSound(soundr) -- ora doushita??
        task.wait(1)
        PlaySound("MassiveSlap") -- slap slap slap 
        task.wait(2)
        Anim:Destroy()
    elseif Main.HeatMove.TextLabel.Text == "Ultimate Essence" and not plr.Character:FindFirstChild("BeingHeated") and SlapUlt == false and DOD88 == true then
	Main.HeatMove.TextLabel.Text = "Ultimate Essence 88"
    elseif Main.HeatMove.TextLabel.Text == "Essence of Fast Footwork [Back]" and not char:FindFirstChild("BeingHeated") then
	Main.HeatMove.TextLabel.Text = "Essence of Sumo Slapping"
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
   elseif Main.HeatMove.TextLabel.Text == "Essence of Stomping" then 
        task.wait(1.5)
        if status.CurrentMove.Value == moves["龍Stomp"] then
	    task.wait(0.25)
	    UseHeatAction("H_FallenKick","Brawler",{char.LockedOn.Value})
        end
    end
end)

-- Aura, Idle Stance, Hact Renames, No Heat Action Label
local anim = game.Players.LocalPlayer.Character.Humanoid.Animator:LoadAnimation(game.ReplicatedStorage.AIStyles.Dragon.StanceIdle)
anim.Priority = Enum.AnimationPriority.Movement

local DragonText = "Dragon"
styles.Blade.Color.Value = Color3.fromRGB(0,0,0)
local DragonColor
DragonColor = Color3.new(1,0,0)
local DSeq = ColorSequence.new({ColorSequenceKeypoint.new(0, DragonColor), ColorSequenceKeypoint.new(1, DragonColor)})
local NoTrail = ColorSequence.new({ColorSequenceKeypoint.new(0, styles.Blade.Color.Value), ColorSequenceKeypoint.new(1, styles.Blade.Color.Value)})

local function UpdateStyle()
if status.Style.Value == "Brawler" then
	Dragon.Color.Value = DragonColor
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

local Heat = status.Heat

local FastMoves = Instance.new("BoolValue", nil)

Heat.Changed:Connect(function()
    if Heat.Value >= 50 then
	FastMoves.Value = true
    elseif Heat.Value < 50 then
	FastMoves.Value = false
    end
end)

FastMoves.Changed:Connect(function()
    if FastMoves.Value == true then
	moves[Dragon.Rush1.Value].ComboAt.Value -= 0.05
	moves[Dragon.Rush2.Value].ComboAt.Value -= 0.05
	moves[Dragon.Rush3.Value].ComboAt.Value -= 0.05
	moves[Dragon.Rush4.Value].ComboAt.Value -= 0.05
	moves[Dragon.Strike2.Value].ComboAt.Value -= 0.1
	moves[Dragon.Strike3.Value].ComboAt.Value -= 0.15
	moves[Dragon.Strike4.Value].ComboAt.Value -= 0.05
	moves[Dragon.Strike5.Value].ComboAt.Value -= 0.075
	moves[Dragon.Strike2.Value].AniSpeed.Value += 0.1
	moves[Dragon.Strike3.Value].AniSpeed.Value += 0.1
	moves[Dragon.Strike4.Value].AniSpeed.Value += 0.1
	moves[Dragon.Strike5.Value].AniSpeed.Value += 0.1
	moves[Dragon.Strike5.Value].AniSpeed.Value += 0.1
    elseif FastMoves.Value == false then
	moves[Dragon.Rush1.Value].ComboAt.Value += 0.05
	moves[Dragon.Rush2.Value].ComboAt.Value += 0.05
	moves[Dragon.Rush3.Value].ComboAt.Value += 0.05
	moves[Dragon.Rush4.Value].ComboAt.Value += 0.05
	moves[Dragon.Strike2.Value].ComboAt.Value += 0.1
	moves[Dragon.Strike3.Value].ComboAt.Value += 0.15
	moves[Dragon.Strike4.Value].ComboAt.Value += 0.05
	moves[Dragon.Strike5.Value].ComboAt.Value += 0.075
	moves[Dragon.Strike2.Value].AniSpeed.Value -= 0.1
	moves[Dragon.Strike3.Value].AniSpeed.Value -= 0.1
	moves[Dragon.Strike4.Value].AniSpeed.Value -= 0.1
	moves[Dragon.Strike5.Value].AniSpeed.Value -= 0.1
	moves[Dragon.Strike5.Value].AniSpeed.Value -= 0.1
    end
end)

local cc = Instance.new("ColorCorrectionEffect", game.Lighting)
cc.Name = "dragon tint"

local tweenService = game:GetService("TweenService")
local ts1 = tweenService:Create(cc, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
    Contrast = 0.3,
    TintColor = Color3.new(1,0.5,0.5)
})

local ts2 = tweenService:Create(cc, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Contrast = 0, TintColor = Color3.new(1,1,1)})

local function Animation()
    ts1:Play()
    ts1.Completed:Once(function()
        ts2:Play()
    end)
end

playSound = (function(a1) -- PlaySound
u10.playsound(a1, u9.hrp, nil, nil, true)
local SoundEvent = {
    [1] = "repsound",
    [2] = a1
}
u5:FireServer(SoundEvent)
end)

status.ChildRemoved:Connect(function(v)
    if v.Name == "ANGRY" then
	RDS.Value = false
    end
end)

status.ChildAdded:Connect(function(v)
    if v.Name == "ANGRY" then
	RDS.Value = true
    end
end)

local settings = {
    Brightness = 128,
    
    Color = ColorSequence.new(Color3.new(1)),
    
    Texture = "rbxassetid://5699911427",
    
    LightEmission = 1,
    
    LightInfluence = 1,
    
    Transparency = NumberSequence.new(
        {
            NumberSequenceKeypoint.new(0, 0, 0),
            NumberSequenceKeypoint.new(0.4, 0, 0),
            NumberSequenceKeypoint.new(1, 1, 1)
        }
    ),
    
    Name = "Dragon Trail",
    
    Lifetime = 0.5,
    
    MaxLength = 0,
    
    MinLength = 0.1,
    
    WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1, 1),
        NumberSequenceKeypoint.new(1, 0, 0),
    })
}

local function makeTrail()
    local trail = Instance.new("Trail", char.UpperTorso)
    for i,v in settings do
        trail[i] = v
    end
    return trail
end

local function makeAttachments(target)
    -- Target is a part
    local topAttachment = Instance.new("Attachment", target)
    topAttachment.Position = Vector3.new(0, target.Size.Y*1, 0)
    topAttachment.Name = "TAttach"
    local bottomAttachment = Instance.new("Attachment", target)
    bottomAttachment.Position = Vector3.new(0, target.Size.Y*-1, 0)
    bottomAttachment.Name = "BAttach"
    return bottomAttachment, topAttachment
end

local trail = makeTrail()
local top, bot = makeAttachments(char.UpperTorso)
trail.Attachment0 = top
trail.Attachment1 = bot
trail.Parent = char.UpperTorso
trail.Enabled = false

local plr = game:GetService("Players").LocalPlayer
local pgui = plr.PlayerGui
local interf = pgui.Interface

local function teleportToLocked(target)
    local user = game.Players.LocalPlayer
    local char = user.Character or user.CharacterAdded:Wait()

    local root = char.HumanoidRootPart

    local lock = char.LockedOn
    local val = target or lock.Value
    if val and val:IsDescendantOf(workspace) and val.Parent.Health.Value > 0 then
	local anim = Instance.new("Animation") anim.AnimationId = moves.BEvadeStrikeForward.Anim.AnimationId local atrack = char.Humanoid:LoadAnimation(anim)
	atrack:AdjustSpeed(2)
	atrack.Priority = Enum.AnimationPriority.Action4
	atrack:Play()
	play_ingamesound("Teleport")
        root.CFrame = CFrame.new(val.Position - (val.CFrame.LookVector * Vector3.new(1, 0, 1).Unit * 3), val.Position)
        return true    
    end
    return false
end

local teleportDebounce = 0
local debouceDuration = 0.5

function Teleport()
    if status.Taunting.Value == true and RDS.Value == true then
        local success = teleportToLocked()

        if success then
            local ff = RPS.Invulnerable:Clone()
            ff.Parent = status 
	    trail.Enabled = true
            task.defer(function()
                trail.Enabled = false
                ff:Destroy()
            end)
        else
            trail.Enabled = false
            if status:FindFirstChild("Invulnerable") then
		status.Invulnerable:Destroy()
            end
        end
    end
end

status.Taunting.Changed:Connect(Teleport)

RDS.Changed:Connect(function()
if RDS.Value == true then
    local id = "rbxassetid://10928237540"
    local SuperCharge = Instance.new("Animation", workspace)
    SuperCharge.AnimationId = id
    local anim = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(SuperCharge) anim.Priority = Enum.AnimationPriority.Action4
    anim:Play()
    local rage = fetchRandom(RPS.Voices.Kiryu.Rage)
    Animation()
    FillHeat()
    local invul = Instance.new("Folder",status)
    invul.Name = "Invulnerable" 
    playSound(rage)
    if not status:FindFirstChild("Invulnerable") then
	local invul = Instance.new("Folder",status)
	invul.Name = "Invulnerable"
    end
elseif RDS.Value == true and status:FindFirstChild("ANGRY") then
    Animation()
    FillHeat()
    local invul = Instance.new("Folder",status)
    invul.Name = "Invulnerable" 
    if not status:FindFirstChild("Invulnerable") then
	local invul = Instance.new("Folder",status)
	invul.Name = "Invulnerable"
    end	
else 
    if status:FindFirstChild("Invulnerable") then
	status.Invulnerable:Destroy()
	end
    end
end)


-- Feel The Heat

local EnemyText = pgui.EInterface.EnemyHP.TextLabel

local CanFeelHeat = Instance.new("BoolValue")
local IsBoss = false
local HPCorrect = Instance.new("BoolValue")
local AlreadyFeltHeat = Instance.new("BoolValue")

local BossHPTable = {"1100/3000", "1100/4200", "1100/1200", "1099/3000", "1099/4200", "1099/1200", "1098/3000", "1098/4200", "1098/1200", "1097/3000", "1097/4200", "1097/1200", "1096/3000", "1096/4200", "1096/1200", "1095/3000", "1095/4200", "1095/1200", "1094/3000", "1094/4200", "1094/1200", "1093/3000", "1093/4200", "1093/1200", "1092/3000", "1092/4200", "1092/1200", "1091/3000", "1091/4200", "1091/1200", "1090/3000", "1090/4200", "1090/1200", "1089/3000", "1089/4200", "1089/1200", "1088/3000", "1088/4200", "1088/1200", "1087/3000", "1087/4200", "1087/1200", "1086/3000", "1086/4200", "1086/1200", "1085/3000", "1085/4200", "1085/1200", "1084/3000", "1084/4200", "1084/1200", "1083/3000", "1083/4200", "1083/1200", "1082/3000", "1082/4200", "1082/1200", "1081/3000", "1081/4200", "1081/1200", "1080/3000", "1080/4200", "1080/1200", "1079/3000", "1079/4200", "1079/1200", "1078/3000", "1078/4200", "1078/1200", "1077/3000", "1077/4200", "1077/1200", "1076/3000", "1076/4200", "1076/1200", "1075/3000", "1075/4200", "1075/1200", "1074/3000", "1074/4200", "1074/1200", "1073/3000", "1073/4200", "1073/1200", "1072/3000", "1072/4200", "1072/1200", "1071/3000", "1071/4200", "1071/1200", "1070/3000", "1070/4200", "1070/1200", "1069/3000", "1069/4200", "1069/1200", "1068/3000", "1068/4200", "1068/1200", "1067/3000", "1067/4200", "1067/1200", "1066/3000", "1066/4200", "1066/1200", "1065/3000", "1065/4200", "1065/1200", "1064/3000", "1064/4200", "1064/1200", "1063/3000", "1063/4200", "1063/1200", "1062/3000", "1062/4200", "1062/1200", "1061/3000", "1061/4200", "1061/1200", "1060/3000", "1060/4200", "1060/1200", "1059/3000", "1059/4200", "1059/1200", "1058/3000", "1058/4200", "1058/1200", "1057/3000", "1057/4200", "1057/1200", "1056/3000", "1056/4200", "1056/1200", "1055/3000", "1055/4200", "1055/1200", "1054/3000", "1054/4200", "1054/1200", "1053/3000", "1053/4200", "1053/1200", "1052/3000", "1052/4200", "1052/1200", "1051/3000", "1051/4200", "1051/1200", "1050/3000", "1050/4200", "1050/1200", "1049/3000", "1049/4200", "1049/1200", "1048/3000", "1048/4200", "1048/1200", "1047/3000", "1047/4200", "1047/1200", "1046/3000", "1046/4200", "1046/1200", "1045/3000", "1045/4200", "1045/1200", "1044/3000", "1044/4200", "1044/1200", "1043/3000", "1043/4200", "1043/1200", "1042/3000", "1042/4200", "1042/1200", "1041/3000", "1041/4200", "1041/1200", "1040/3000", "1040/4200", "1040/1200", "1039/3000", "1039/4200", "1039/1200", "1038/3000", "1038/4200", "1038/1200", "1037/3000", "1037/4200", "1037/1200", "1036/3000", "1036/4200", "1036/1200", "1035/3000", "1035/4200", "1035/1200", "1034/3000", "1034/4200", "1034/1200", "1033/3000", "1033/4200", "1033/1200", "1032/3000", "1032/4200", "1032/1200", "1031/3000", "1031/4200", "1031/1200", "1030/3000", "1030/4200", "1030/1200", "1029/3000", "1029/4200", "1029/1200", "1028/3000", "1028/4200", "1028/1200", "1027/3000", "1027/4200", "1027/1200", "1026/3000", "1026/4200", "1026/1200", "1025/3000", "1025/4200", "1025/1200", "1024/3000", "1024/4200", "1024/1200", "1023/3000", "1023/4200", "1023/1200", "1022/3000", "1022/4200", "1022/1200", "1021/3000", "1021/4200", "1021/1200", "1020/3000", "1020/4200", "1020/1200", "1019/3000", "1019/4200", "1019/1200", "1018/3000", "1018/4200", "1018/1200", "1017/3000", "1017/4200", "1017/1200", "1016/3000", "1016/4200", "1016/1200", "1015/3000", "1015/4200", "1015/1200", "1014/3000", "1014/4200", "1014/1200", "1013/3000", "1013/4200", "1013/1200", "1012/3000", "1012/4200", "1012/1200", "1011/3000", "1011/4200", "1011/1200", "1010/3000", "1010/4200", "1010/1200", "1009/3000", "1009/4200", "1009/1200", "1008/3000", "1008/4200", "1008/1200", "1007/3000", "1007/4200", "1007/1200", "1006/3000", "1006/4200", "1006/1200", "1005/3000", "1005/4200", "1005/1200", "1004/3000", "1004/4200", "1004/1200", "1003/3000", "1003/4200", "1003/1200", "1002/3000", "1002/4200", "1002/1200", "1001/3000", "1001/4200", "1001/1200", "1000/3000", "1000/4200", "1000/1200", "999/3000", "999/4200", "999/1200", "998/3000", "998/4200", "998/1200", "997/3000", "997/4200", "997/1200", "996/3000", "996/4200", "996/1200", "995/3000", "995/4200", "995/1200", "994/3000", "994/4200", "994/1200", "993/3000", "993/4200", "993/1200", "992/3000", "992/4200", "992/1200", "991/3000", "991/4200", "991/1200", "990/3000", "990/4200", "990/1200", "989/3000", "989/4200", "989/1200", "988/3000", "988/4200", "988/1200", "987/3000", "987/4200", "987/1200", "986/3000", "986/4200", "986/1200", "985/3000", "985/4200", "985/1200", "984/3000", "984/4200", "984/1200", "983/3000", "983/4200", "983/1200", "982/3000", "982/4200", "982/1200", "981/3000", "981/4200", "981/1200", "980/3000", "980/4200", "980/1200", "979/3000", "979/4200", "979/1200", "978/3000", "978/4200", "978/1200", "977/3000", "977/4200", "977/1200", "976/3000", "976/4200", "976/1200", "975/3000", "975/4200", "975/1200", "974/3000", "974/4200", "974/1200", "973/3000", "973/4200", "973/1200", "972/3000", "972/4200", "972/1200", "971/3000", "971/4200", "971/1200", "970/3000", "970/4200", "970/1200", "969/3000", "969/4200", "969/1200", "968/3000", "968/4200", "968/1200", "967/3000", "967/4200", "967/1200", "966/3000", "966/4200", "966/1200", "965/3000", "965/4200", "965/1200", "964/3000", "964/4200", "964/1200", "963/3000", "963/4200", "963/1200", "962/3000", "962/4200", "962/1200", "961/3000", "961/4200", "961/1200", "960/3000", "960/4200", "960/1200", "959/3000", "959/4200", "959/1200", "958/3000", "958/4200", "958/1200", "957/3000", "957/4200", "957/1200", "956/3000", "956/4200", "956/1200", "955/3000", "955/4200", "955/1200", "954/3000", "954/4200", "954/1200", "953/3000", "953/4200", "953/1200", "952/3000", "952/4200", "952/1200", "951/3000", "951/4200", "951/1200", "950/3000", "950/4200", "950/1200", "949/3000", "949/4200", "949/1200", "948/3000", "948/4200", "948/1200", "947/3000", "947/4200", "947/1200", "946/3000", "946/4200", "946/1200", "945/3000", "945/4200", "945/1200", "944/3000", "944/4200", "944/1200", "943/3000", "943/4200", "943/1200", "942/3000", "942/4200", "942/1200", "941/3000", "941/4200", "941/1200", "940/3000", "940/4200", "940/1200", "939/3000", "939/4200", "939/1200", "938/3000", "938/4200", "938/1200", "937/3000", "937/4200", "937/1200", "936/3000", "936/4200", "936/1200", "935/3000", "935/4200", "935/1200", "934/3000", "934/4200", "934/1200", "933/3000", "933/4200", "933/1200", "932/3000", "932/4200", "932/1200", "931/3000", "931/4200", "931/1200", "930/3000", "930/4200", "930/1200", "929/3000", "929/4200", "929/1200", "928/3000", "928/4200", "928/1200", "927/3000", "927/4200", "927/1200", "926/3000", "926/4200", "926/1200", "925/3000", "925/4200", "925/1200", "924/3000", "924/4200", "924/1200", "923/3000", "923/4200", "923/1200", "922/3000", "922/4200", "922/1200", "921/3000", "921/4200", "921/1200", "920/3000", "920/4200", "920/1200", "919/3000", "919/4200", "919/1200", "918/3000", "918/4200", "918/1200", "917/3000", "917/4200", "917/1200", "916/3000", "916/4200", "916/1200", "915/3000", "915/4200", "915/1200", "914/3000", "914/4200", "914/1200", "913/3000", "913/4200", "913/1200", "912/3000", "912/4200", "912/1200", "911/3000", "911/4200", "911/1200", "910/3000", "910/4200", "910/1200", "909/3000", "909/4200", "909/1200", "908/3000", "908/4200", "908/1200", "907/3000", "907/4200", "907/1200", "906/3000", "906/4200", "906/1200", "905/3000", "905/4200", "905/1200", "904/3000", "904/4200", "904/1200", "903/3000", "903/4200", "903/1200", "902/3000", "902/4200", "902/1200", "901/3000", "901/4200", "901/1200", "900/3000", "900/4200", "900/1200", "899/3000", "899/4200", "899/1200", "898/3000", "898/4200", "898/1200", "897/3000", "897/4200", "897/1200", "896/3000", "896/4200", "896/1200", "895/3000", "895/4200", "895/1200", "894/3000", "894/4200", "894/1200", "893/3000", "893/4200", "893/1200", "892/3000", "892/4200", "892/1200", "891/3000", "891/4200", "891/1200", "890/3000", "890/4200", "890/1200", "889/3000", "889/4200", "889/1200", "888/3000", "888/4200", "888/1200", "887/3000", "887/4200", "887/1200", "886/3000", "886/4200", "886/1200", "885/3000", "885/4200", "885/1200", "884/3000", "884/4200", "884/1200", "883/3000", "883/4200", "883/1200", "882/3000", "882/4200", "882/1200", "881/3000", "881/4200", "881/1200", "880/3000", "880/4200", "880/1200", "879/3000", "879/4200", "879/1200", "878/3000", "878/4200", "878/1200", "877/3000", "877/4200", "877/1200", "876/3000", "876/4200", "876/1200", "875/3000", "875/4200", "875/1200", "874/3000", "874/4200", "874/1200", "873/3000", "873/4200", "873/1200", "872/3000", "872/4200", "872/1200", "871/3000", "871/4200", "871/1200", "870/3000", "870/4200", "870/1200", "869/3000", "869/4200", "869/1200", "868/3000", "868/4200", "868/1200", "867/3000", "867/4200", "867/1200", "866/3000", "866/4200", "866/1200", "865/3000", "865/4200", "865/1200", "864/3000", "864/4200", "864/1200", "863/3000", "863/4200", "863/1200", "862/3000", "862/4200", "862/1200", "861/3000", "861/4200", "861/1200", "860/3000", "860/4200", "860/1200", "859/3000", "859/4200", "859/1200", "858/3000", "858/4200", "858/1200", "857/3000", "857/4200", "857/1200", "856/3000", "856/4200", "856/1200", "855/3000", "855/4200", "855/1200", "854/3000", "854/4200", "854/1200", "853/3000", "853/4200", "853/1200", "852/3000", "852/4200", "852/1200", "851/3000", "851/4200", "851/1200", "850/3000", "850/4200", "850/1200", "849/3000", "849/4200", "849/1200", "848/3000", "848/4200", "848/1200", "847/3000", "847/4200", "847/1200", "846/3000", "846/4200", "846/1200", "845/3000", "845/4200", "845/1200", "844/3000", "844/4200", "844/1200", "843/3000", "843/4200", "843/1200", "842/3000", "842/4200", "842/1200", "841/3000", "841/4200", "841/1200", "840/3000", "840/4200", "840/1200", "839/3000", "839/4200", "839/1200", "838/3000", "838/4200", "838/1200", "837/3000", "837/4200", "837/1200", "836/3000", "836/4200", "836/1200", "835/3000", "835/4200", "835/1200", "834/3000", "834/4200", "834/1200", "833/3000", "833/4200", "833/1200", "832/3000", "832/4200", "832/1200", "831/3000", "831/4200", "831/1200", "830/3000", "830/4200", "830/1200", "829/3000", "829/4200", "829/1200", "828/3000", "828/4200", "828/1200", "827/3000", "827/4200", "827/1200", "826/3000", "826/4200", "826/1200", "825/3000", "825/4200", "825/1200", "824/3000", "824/4200", "824/1200", "823/3000", "823/4200", "823/1200", "822/3000", "822/4200", "822/1200", "821/3000", "821/4200", "821/1200", "820/3000", "820/4200", "820/1200", "819/3000", "819/4200", "819/1200", "818/3000", "818/4200", "818/1200", "817/3000", "817/4200", "817/1200", "816/3000", "816/4200", "816/1200", "815/3000", "815/4200", "815/1200", "814/3000", "814/4200", "814/1200", "813/3000", "813/4200", "813/1200", "812/3000", "812/4200", "812/1200", "811/3000", "811/4200", "811/1200", "810/3000", "810/4200", "810/1200", "809/3000", "809/4200", "809/1200", "808/3000", "808/4200", "808/1200", "807/3000", "807/4200", "807/1200", "806/3000", "806/4200", "806/1200", "805/3000", "805/4200", "805/1200", "804/3000", "804/4200", "804/1200", "803/3000", "803/4200", "803/1200", "802/3000", "802/4200", "802/1200", "801/3000", "801/4200", "801/1200", "800/3000", "800/4200", "800/1200", "799/3000", "799/4200", "799/1200", "798/3000", "798/4200", "798/1200", "797/3000", "797/4200", "797/1200", "796/3000"}

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
	
status.RedDragonSpirit.Changed:Connect(function()
if status.RedDragonSpirit.Value == true then
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

local oldcframe = char.HumanoidRootPart.CFrame
if hasReloaded == false then
interf.Client.Disabled = true
task.wait()
interf.Client.Disabled = false
char.HumanoidRootPart.CFrame = oldcframe
end

moves.BRCounter2.Anim.AnimationId = "rbxassetid://12338275115"
moves.CounterHook.Anim.AnimationId = "rbxassetid://12338275115"

local styleToChange = "Brawler" --Brawler = fisticuffs, Rush = frenzy, Beast = brute.  you MUST use one of these 3 or else you cannot use the custom style.
local styleToChangeTo = "堂島の龍" -- is Dragon Style
local characterToChange = "Your Avatar"
local characterToChangeTo = "Kiryu Morph"

if _G.MorphMod == true and not hasReloaded then
_G.Morph = "Legendary Dragon"          
loadstring(game:HttpGet("https://raw.githubusercontent.com/aAAAakakrvmv192/R2FMods/main/charmorphmod.lua"))();
if not sentNotifs then
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
	   Notify("Selected voice: ".._G.voice.Name,"buzz", Color3.fromRGB(255, 255, 255))
	    return
	end 
	
	alreadyRunning = Instance.new("BoolValue")
	alreadyRunning.Parent = status
	alreadyRunning.Value = true
	alreadyRunning.Name = "Voice Mod"
	
	Notify("Voice Mod loaded",nil, Color3.fromRGB(255, 255, 255), "Bangers" )
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
		if main.HeatMove.TextLabel.Text ~= "Ultimate Essence " then
	        receivedsound = fetchRandom(_G.voice.HeatAction)
	        playSound(receivedsound)
		    end
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

if hasReloaded == false then
	local startsound = Instance.new("Sound")
	startsound.SoundId = "rbxassetid://9085027122"
	game:GetService("SoundService"):PlayLocalSound(startsound)
        Notify("dragon loaded :3",nil,Color3.fromRGB(3,161,252),"Bangers")
	startsound.Ended:Wait()
	startsound:Destroy()
end
