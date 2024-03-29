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
local Forcefield = RPS.Invulnerable:Clone()
Forcefield.Parent = status
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

local alreadyRunning = status:FindFirstChild("Dragon Style")
if alreadyRunning then
    Notify("Dragon Style is already loaded", "buzz", Color3.fromRGB(255,255,255), "RobotoMono")
    task.wait(2)
    Notify("If you have an error, report it to me.", "HeatDepleted", Color3.fromRGB(255,255,255), "RobotoMono")
    return
end
 
alreadyRunning = Instance.new("BoolValue")
alreadyRunning.Parent = status
alreadyRunning.Value = true
alreadyRunning.Name = "Dragon Style"

local Beast = styles.Beast
local Rush = styles.Rush
local DEF = Dragon.EvadeF.AnimationId
local DEB = Dragon.EvadeB.AnimationId
local DEL = Dragon.EvadeL.AnimationId
local DER = Dragon.EvadeR.AnimationId

for i,v in Rush:GetChildren() do
    if v:IsA("Animation") then
	if string.find(v.Name, "Evade") and string.find(v.Name, "F") then
	    v.AnimationId = DEF
	elseif string.find(v.Name, "Evade") and string.find(v.Name, "B") then
	    v.AnimationId = DEB
	elseif string.find(v.Name, "Evade") and string.find(v.Name, "L") then
	    v.AnimationId = DEL
	elseif string.find(v.Name, "Evade") and string.find(v.Name, "R") then
	    v.AnimationId = DER
	end
    end
end
Dragon.WalkF:Clone().Parent = Rush
Dragon.WalkB:Clone().Parent = Rush
Dragon.WalkL:Clone().Parent = Rush
Dragon.WalkR:Clone().Parent = Rush

local Y0Moveset = {
	{name = "Grab", Type = "StringValue", value = "Grab"},
	{name = "Throw", Type = "StringValue", value = "T_BrawlerToss"},
	{name = "GrabStrike", Type = "StringValue", value = "T_龍GParry"},
	{name = "Taunt", Type = "StringValue", value = "DragonTaunt"},
	{name = "RedHeat", Type = "Folder", value = nil},
	{name = "Idle", Type = "Animation", value = RPS.AIStyles.Dragon.StanceIdle.AnimationId},
	{name = "Color", Type = "Color", value = Color3.fromRGB(250,5,10)},
        {name = "Speed", Type = "NumberValue", value = 1.25},
	{name = "Pummel", Type = "StringValue", value = "T_龍GParry"},
	
	{name = "Rush1", Type = "StringValue", value = "BAttack1"},
	{name = "Rush2", Type = "StringValue", value = "BAttack2"},
	{name = "Rush3", Type = "StringValue", value = "BAttack3"},
	{name = "Rush4", Type = "StringValue", value = "BAttack4"},

	{name = "Strike1", Type = "StringValue", value = "龍Strike1"},
	{name = "Strike2", Type = "StringValue", value = "BStrike2"},
	{name = "Strike3", Type = "StringValue", value = "BStrike3"},
	{name = "Strike4", Type = "StringValue", value = "BStrike5"},
	{name = "Strike5", Type = "StringValue", value = "龍Strike5"},

	{name = "2Strike2", Type = "StringValue", value = "龍2Strike1"},
	{name = "2Strike3", Type = "StringValue", value = "龍2Strike2"},
	{name = "2Strike4", Type = "StringValue", value = "龍2Strike3"},
	{name = "2Strike5", Type = "StringValue", value = "龍2Strike4"},
	
	{name = "BlockStrike", Type = "StringValue", value = "ShuckyDrop"},
	{name = "StanceStrike", Type = "StringValue", value = "CounterHook"},
	{name = "H_Fallen", Type = "StringValue", value = "H_FallenStomp"},
	{name = "H_FallenDown", Type = "StringValue", value = "H_FallenGrate"},
	{name = "H_TwoHandeds", Type = "StringValue", value = "H_SelfDestruct"},
	{name = "H_GrabStanding3", Type = "StringValue", value = "H_Entangle"},
	{name = "H_Running4", Type = "StringValue", value = "H_Terror"},
	{name = "H_EvadedL", Type = "StringValue", value = "H_FastFootworkLeft"},
	{name = "H_EvadedR", Type = "StringValue", value = "H_FastFootworkRight"},
	{name = "H_EvadedF", Type = "StringValue", value = "H_FastFootworkFront"},
	{name = "H_CounterSoloAllFront", Type = "StringValue", value = "H_TSpinCounterFront"},
	{name = "H_CounterSoloAllBack", Type = "StringValue", value = "H_TSpinCounterBack"},
	{name = "H_CounterSoloAllLeft", Type = "StringValue", value = "H_TSpinCounterLeft"},
	{name = "H_CounterSoloAllRight", Type = "StringValue", value = "H_TSpinCounterRight"},
	{name = "H_CounterSolo", Type = "StringValue", value = "H_Escape"}
}
local DEMoveset = {
	{name = "Rush1", Type = "StringValue", value = "BAttack1"},
	{name = "Rush2", Type = "StringValue", value = "BAttack2"},
	{name = "Rush3", Type = "StringValue", value = "BAttack3"},
	{name = "Rush4", Type = "StringValue", value = "BAttack4"},
	
	{name = "Strike1", Type = "StringValue", value = "龍Strike1"},
	{name = "Strike2", Type = "StringValue", value = "BStrike3"},
	{name = "Strike3", Type = "StringValue", value = "BStrike2"},
	{name = "Strike4", Type = "StringValue", value = "BStrike5"},
	
	{name = "Strike5", Type = "StringValue", value = "BStrike4"},
	{name = "2Strike2", Type = "StringValue", value = "BEvadeStrikeBack"},
	{name = "2Strike3", Type = "StringValue", value = "BStrike2"},
	{name = "2Strike4", Type = "StringValue", value = "B2Strike3"},
	{name = "2Strike5", Type = "StringValue", value = "龍Strike5"}
}

local Y0MoveConfig = {
	{move = "BAttack1", property = "HitboxLocations", value = moves["龍Attack1"].HitboxLocations.Value},
	{move = "BAttack2", property = "HitboxLocations", value = moves["龍Attack2"].HitboxLocations.Value},
	{move = "BAttack3", property = "HitboxLocations", value = moves["龍Attack3"].HitboxLocations.Value},
	{move = "BAttack4", property = "HitboxLocations", value = moves["龍Attack4"].HitboxLocations.Value},
	{move = "BAttack1", property = "ComboAt", value = moves["龍Attack1"].ComboAt.Value},
	{move = "BAttack2", property = "ComboAt", value = moves["龍Attack2"].ComboAt.Value},
	{move = "BAttack3", property = "ComboAt", value = moves["龍Attack3"].ComboAt.Value},
	{move = "BAttack4", property = "ComboAt", value = moves["龍Attack4"].ComboAt.Value},
	{move = "龍Strike5", property = "HitboxLocations", value = '[["LeftFoot",2,[0,0,0]],["LeftLowerLeg",1.5,[0,0,0]],["LeftUpperLeg",1,[0,0,0]]]'},
	{move = "BStrike2", property = "ComboAt", value = moves.BStrike2.ComboAt.Value - 0.15},
	{move = "BStrike2", property = "MoveForward", value = moves.BStrike2.MoveForward.Value - 3},
	{move = "BStrike3", property = "AniSpeed", value = moves.BStrike2.AniSpeed.Value + 0.05},
	{move = "BStrike3", property = "ComboAt", value = moves.BStrike2.ComboAt.Value - 0.05},
	{move = "龍2Strike2", property = "AniSpeed", value = 1.45},
	{move = "龍2Strike2", property = "MoveForward", value = moves["龍2Strike2"].MoveForward.Value - 4},
	{move = "BStrike5", property = "AniSpeed", value = moves["BStrike5"].AniSpeed.Value + 0.05},
	{move = "BStrike5", property = "ComboAt", value = moves["BStrike5"].ComboAt.Value - 0.1}
}

local Y0Anims = {
    	{move = "BAttack1", value = moves["龍Attack1"].Anim.AnimationId},
	{move = "BAttack2", value = moves["龍Attack2"].Anim.AnimationId},
	{move = "BAttack3", value = moves["龍Attack3"].Anim.AnimationId},
	{move = "BAttack4", value = moves["龍Attack4"].Anim.AnimationId},
	{move = "龍Strike1", value = "rbxassetid://13731752257"},
	{move = "BStrike5", value = moves["龍2Strike1"].Anim.AnimationId},
	{move = "龍Strike5", value = moves.BStrike1.TurnAnim.AnimationId}
}

local DEAnims = {
	{move = "BStrike2", property = "Anim", value = "rbxassetid://13785068836"},
	{move = "B2Strike3", property = "Anim", value = "rbxassetid://13785070193"},
	{move = "BStrike4", property = "Anim", value = "rbxassetid://13785070193"},
	{move = "龍Strike5", property = "Anim", value = "rbxassetid://13731752257"},
        {move = "BAttack1", property = "Anim", value = moves["龍Attack1"].Anim.AnimationId},
	{move = "BAttack2", property = "Anim", value = moves["龍Attack2"].Anim.AnimationId},
	{move = "BAttack3", property = "Anim", value = moves["龍Attack3"].Anim.AnimationId},
	{move = "BAttack4", property = "Anim", value = moves["BAttack1"].Anim.AnimationId}
}

local DEMoveConfig = {
	
	{move = "龍Strike5", property = "AniSpeed", value = 1.5},
	{move = "龍Strike5", property = "MoveForward", value = 12},
	{move = "BStrike4", property = "ComboAt", value = 0.6},
	{move = "BStrike4", property = "AniSpeed", value = moves.B2Strike3.AniSpeed.Value},
	{move = "BStrike5", property = "ComboAt", value = 0.6},
	
	{move = "BAttack1", property = "HitboxLocations", value = moves["龍Attack1"].HitboxLocations.Value},
	{move = "BAttack2", property = "HitboxLocations", value = moves["龍Attack2"].HitboxLocations.Value},
	{move = "BAttack3", property = "HitboxLocations", value = moves["龍Attack3"].HitboxLocations.Value},
	{move = "BAttack4", property = "HitboxLocations", value = moves["BAttack1"].HitboxLocations.Value},
	{move = "BAttack1", property = "ComboAt", value = moves["龍Attack1"].ComboAt.Value},
	{move = "BAttack2", property = "ComboAt", value = moves["龍Attack2"].ComboAt.Value},
	{move = "BAttack3", property = "ComboAt", value = moves["龍Attack3"].ComboAt.Value},
	{move = "BAttack4", property = "ComboAt", value = moves["BAttack1"].ComboAt.Value}
}

local MoveConfig = {
    {name = "ShuckyDrop", property = "Anim", value = moves.GuruStumble.Anim.AnimationId},
    {name = "ShuckyDrop", property = "AniSpeed", value = moves.GuruStumble.AniSpeed.Value},
    {name = "ShuckyDrop", property = "MoveForward", value = moves.GuruStumble.MoveForward.Value},
    {name = "ShuckyDrop", property = "SF", value = 0.1},
    {name = "H_FastFootworkBack", property = "Closest", value = '40'},
    {name = "BGetup", property = "Anim", value = moves.RSweep.Anim.AnimationId},
    {name = "BGetup", property = "HitboxLocations", value = moves.RSweep.HitboxLocations.Value}
}
	
local function ChangeConfig(Table)
    for i,mv in ipairs(moves:GetChildren()) do
	for i,data in ipairs(Table) do
	    if data.move == mv.Name then
		if mv[data.property].Name ~= "Anim" and data.value ~= nil then
		    mv[data.property].Value = data.value
		elseif mv[data.property].Name == "Anim" and data.value ~= nil then
		    mv[data.property].AnimationId = value
		end
		if data.newname then
		    mv.Name = data.newname
		end
	    end
	end
    end
end

function ChangeAnims(Table)
    for i,Move in ipairs(moves:GetChildren()) do
	for i,v in ipairs(Table) do
	    if v.Name == Move.Name then
		Move.Anim.AnimationId = v.value
	    end
	end
    end
end

function ChangeMoveset(Style, Table)
    for i,data in ipairs(Table) do
	if not Style:FindFirstChild(data.name) and data.Type ~= "Destroy" then
	    local new = Instance.new(data.Type, Style)
            new.Name = data.name
	    if data.value ~= nil then
		new.Value = data.value
	    end	
	elseif Style:FindFirstChild(data.name) then
	    if data.value ~= nil and data.Type ~= "Animation" then
		Style[data.name].Value = data.value
	    elseif data.Type == "Destroy" then
                Style[data.name]:Destroy()
	    elseif data.Type == "Animation" then
		Style[data.name].AnimationId = data.value
	    elseif data.Type == "Color" then
		Style[data.name].Value = data.value
	    end
	end	
    end
end

local RDSCombo = {
  {name="Rush1", value="BAttack1", Type="StringValue"},
  {name="Rush2", value="BAttack2", Type="StringValue"},
  {name="Rush3", value="BAttack1", Type="StringValue"},
  {name="Rush4", value="BAttack2", Type="StringValue"},
  {name="Rush5", value="BAttack1", Type="StringValue"},
  {name="Rush6", value="BAttack2", Type="StringValue"},
  {name="Rush7", value="BAttack1", Type="StringValue"},
  {name="Rush8", value="BAttack2", Type="StringValue"}
}
local NCombo = {
  {name="Rush1", value="BAttack1", Type="StringValue"},
  {name="Rush2", value="BAttack2", Type="StringValue"},
  {name="Rush3", value="BAttack3", Type="StringValue"},
  {name="Rush4", value="BAttack4", Type="StringValue"},
  {name="Rush5", value="BAttack1", Type="Destroy"},
  {name="Rush6", value="BAttack2", Type="Destroy"},
  {name="Rush7", value="BAttack1", Type="Destroy"},
  {name="Rush8", value="BAttack2", Type="Destroy"}
}

if _G.DEMoveset == false or _G.DEMoveset == nil then
    ChangeMoveset(Dragon,Y0Moveset)
    ChangeConfig(Y0MoveConfig)
elseif _G.DEMoveset == true then
    ChangeMoveset(Dragon, Y0Moveset)
    ChangeConfig(DEMoveConfig)
    ChangeMoveset(Dragon, DEMoveset)
end

moves["H_FastFootworkBack"].Closest.Value = '40'
wn = Instance.new("StringValue", moves["H_FastFootworkBack"])
wn.Name = "Within"
wn.Value = '15'	
if not IsInPvp() then
    moves.BRCounter2.Name = "FakeBRCounter2"
    moves["龍TigerDrop"].Name = "BRCounter2"
    moves["BRCounter2"].AniSpeed.Value = 0.75
    moves.CounterHook.Anim.AnimationId = "rbxassetid://12120052426"
elseif IsInPvp() then
    moves["BRGrab"].Name = "FakeGrab" moves["CounterHook"].Name = "BRGrab"
    moves.BRGrab.Anim.AnimationId = "rbxassetid://12120052426"
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
	if not IsInPvp() then
            for i,enemy in pairs(game.Workspace.Bots.AI:GetDescendants()) do
                if enemy:IsA("MeshPart") and enemy.Name == "HumanoidRootPart" and enemy.Parent.LastTarget.Value == plr.Character.HumanoidRootPart then
                    if enemy.Parent.AttackBegan.Value == true then
                        enemy.Parent.AttackBegan.Value = false
                        thing.Value = false
                        Slap(enemy) Slap(enemy) Slap(enemy)  
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
        if IsInPvp() then                                   
	    for i,opp in game.Players:GetPlayers() do       
		if opp ~= plr then                           
                    if opp.Status.AttackBegan.Value == true then
                        opp.Status.AttackBegan.Value = false
                        thing.Value = false                 
                        Slap(opp.Character.HumanoidRootPart)
			Slap(opp.Character.HumanoidRootPart)
			Slap(opp.Character.HumanoidRootPart)
	            end
		end
	    end
	end
    end
end

Main.HeatMove.TextLabel:GetPropertyChangedSignal("Text"):Connect(function()
    if Main.HeatMove.TextLabel.Text == "Ultimate Essence" and not plr.Character:FindFirstChild("BeingHeated") then -- dargon of dojima 88 or slap ult.
	local soundr = Rep.Voices.Kiryu.Taunt["taunt2 (2)"]
        local Anim = Char.Humanoid:LoadAnimation(Rep.Moves.H_UltimateEssence.Anim)
        Anim.Priority = Enum.AnimationPriority.Action4
        Anim:AdjustSpeed(1)
        Anim:Play()
	playSound(soundr) -- ora doushita??
        task.wait(1)
        PlaySound("MassiveSlap") -- slap slap slap 
        task.wait(2)
        Anim:Destroy()
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
local DragonText = "Dragon"
styles.Blade.Color.Value = Color3.fromRGB(0,0,0)
local DragonColor
DragonColor = Color3.fromRGB(250,5,10)
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
    AutoSlap()
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
    
    Lifetime = 1,
    
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
    local topAttachment = Instance.new("Attachment", target.UpperTorso)
    topAttachment.Position = Vector3.new(0, target.UpperTorso.Size.Y * 1.25, 0)
    topAttachment.Name = "TAttach"
    local bottomAttachment = Instance.new("Attachment", target.LowerTorso)
    bottomAttachment.Position = Vector3.new(0, target.LowerTorso.Size.Y * -1.25, 0)
    bottomAttachment.Name = "BAttach"
    return topAttachment, bottomAttachment
end

local trail = makeTrail()
local top, bot = makeAttachments(char)
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
    if val and val:IsDescendantOf(workspace) and not val.Parent:FindFirstChild("ImaDea") then
	local anim = Instance.new("Animation") anim.AnimationId = Dragon.EvadeF.AnimationId local atrack = char.Humanoid:LoadAnimation(anim)
	atrack:AdjustSpeed(2)
	atrack.Priority = Enum.AnimationPriority.Action4
	atrack:Play()
	play_ingamesound("Teleport")
	trail.Enabled = true
	task.wait(0.1)
        root.CFrame = CFrame.new(val.Position - (val.CFrame.LookVector * Vector3.new(1, 0, 1).Unit * 3), val.Position)
	task.wait(0.1)
	trail.Enabled = false
        return true    
    end
    return false
end

local TPDebounce = false
local DebounceDuration = 0.5
local ff = RPS.Invulnerable:Clone()

function Teleport()
    if status.FFC.Evading.Value == true and RDS.Value == true and not TPDebounce and status.Style.Value == "Brawler" then
	local success = teleportToLocked()
	TPDebounce = true
        if success then
            ff.Parent = status 
	    task.wait(0.1)
            ff.Parent = RPS
	    task.wait(0.4)
	    TPDebounce = false
        end
	TPDebounce = false
    end
end

status.FFC.Evading.Changed:Connect(Teleport)

RDS.Changed:Connect(function()
if RDS.Value == true and not status:FindFirstChild("ANGRY") then
    ChangeMoveset(Dragon, RDSCombo)
    local id = "rbxassetid://10928237540"
    local SuperCharge = Instance.new("Animation", workspace)
    SuperCharge.AnimationId = id
    local anim = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(SuperCharge)
    anim:Play()
    local rage = fetchRandom(RPS.Voices.Kiryu.Rage)
    Animation()
    fillHeat(6)
    local invul = Instance.new("Folder",status)
    invul.Name = "Invulnerable" 
    playSound(rage)
    FastMoves.Value = true
    if not status:FindFirstChild("Invulnerable") then
	local invul = Instance.new("Folder",status)
	invul.Name = "Invulnerable"
    end
elseif RDS.Value == true and status:FindFirstChild("ANGRY") then
    ChangeMoveset(Dragon, RDSCombo)
    local id = "rbxassetid://10928237540"
    local SuperCharge = Instance.new("Animation", workspace)
    SuperCharge.AnimationId = id
    local anim = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(SuperCharge)
    anim:Play()
    Animation()
    fillHeat(6)
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
    ChangeMoveset(Dragon, NCombo)
    FastMoves.Value = false
    end
end)


-- Feel The Heat

local EnemyText = pgui.EInterface.EnemyHP.TextLabel

local CanFeelHeat = Instance.new("BoolValue")
local IsBoss = false
local HPCorrect = Instance.new("BoolValue")
local AlreadyFeltHeat = Instance.new("BoolValue")

local BossHPTable = loadstring(game:HttpGet("https://pastebin.com/raw/YG4rWKBq"));
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
end

status.Resets.Changed:Connect(function()
	Notify("You have prestiged [" .. status.Resets.Value .. "] times !",nil, Color3.fromRGB(0, 200, 0))
end)
 
status.Level.Changed:Connect(function()
	if status.Level.Value % 5 == 0 then
		Notify("You are now level [" .. status.Level.Value .. "]",nil, Color3.fromRGB(0, 200, 0))
	end
end)
 
status.Stats.Deaths.Changed:Connect(function()
	Notify("How are you dying??" , "HeatDepleted", Color3.fromRGB(250,5,10))
end)
 
status.Stats.Kills.Changed:Connect(function()
	if status.Stats.Kills.Value % 50 == 0 then
		Notify("You have defeated [" .. status.Stats.Kills.Value .. "] enemies, damn",nil, Color3.fromRGB(0, 200, 0))
	end
end)

status.AttackBegan.Changed:Connect(function() 
    if status.AttackBegan.Value == true then 
	if status.CurrentMove.Value.Name == "CounterHook" or status.CurrentMove.Value.Name == "BRCounter2" then
	    playSound(RPS.Voices.Kiryu.HeatAction["heataction1 (2)"])
	end 
    end 
end)
	
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
    loadstring(game:HttpGet("https://pastebin.com/raw/ihQaV3N6"));
    Notify("Voice Mod loaded",nil, Color3.fromRGB(255, 255, 255), "Bangers" )
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
abilFolder["Time for Resolve"].Description.Value = "Gain the power to destroy every enemy. EVADE to teleport, attacks get deflected, and you get heat."
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
	Forcefield:Destroy()
	startsound.Ended:Wait()
	startsound:Destroy()
end
