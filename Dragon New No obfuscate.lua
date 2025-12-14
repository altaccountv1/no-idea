local plr = game.Players.LocalPlayer
local pgui = plr.PlayerGui
local interf = pgui.Interface
local bt = interf.Battle
local main = bt.Main
local char = plr.Character

local fthActive = false

local RPS = game.ReplicatedStorage
local moves = RPS.Moves or game.ReplicatedFirst.Moves
local sounds = RPS.Sounds
local styles = RPS.Styles
local Dragon = styles.Brawler

local oldanim = moves.BRCounter2.Anim.AnimationId

local status = plr.Status
local menu = pgui.MenuUI.Menu 
local abil = menu.Abilities.Frame.Frame.Frame
local abilFolder = game.ReplicatedStorage.Abilities.Brawler

local alreadyRunning = status:FindFirstChild("Dragon Style")
if alreadyRunning then
	Notify("Dragon Style is already loaded", "buzz", Color3.fromRGB(255,255,255), "RobotoMono")
	task.wait(2)
	Notify("If you have an error, report it to me.", "HeatDepleted", Color3.fromRGB(255,255,255), "RobotoMono")
	return
end

if _G.DragonConfigurations.AuraSyncAddOn == true then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ducksy9340/R2FModding/refs/heads/main/AuraSyncer.lua"))();
end

local debug = false

local ME = RPS.Events.ME

function Notify(Text,Sound,Color,Fonts) --text function, sounds: tp, buzz, Gong, HeatDepleted
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

plr.Chatted:Connect(function(message)
	if message == "CopySLink" then
		if setclipboard then
			setclipboard("https://www.roblox.com/games/8170900938/Right-2-Fight-V0-4-0?privateServerLinkCode=19758439488827467697623615384054")
			Notify("Shucky Dungeon Link copied!", nil, Color3.new(1,1,1), nil)
		else
			Notify("Your executor can't use your clipboard!", nil, Color3.new(1,1,1), nil)
		end
	end
end)

if _G.DragonConfigurations.Experiments == true then
    local experiment = "sumo slap tp "
    if not hookmetamethod and not getnamecallmethod then Notify("Your executor does not support this experiment.", "buzz", Color3.new(1,0,0),nil) return end
    local TweenService = game:GetService("TweenService")
    Notify("Enabling experiment: Sumo Slap Teleport and Tiger Drop Immunity",nil,Color3.new(1,1,1),nil)
    function getLocked()
        return char.LockedOn.Value
    end
    moves["龍TigerDrop"].ScrewYou:Destroy()
    function createTrail(startPos, endPos, color)
        local trail = RPS.TPTrail:Clone()
        trail.Parent = game.Workspace.Ignore

        local distance = (startPos - endPos).Magnitude
        trail.Size = Vector3.new(trail.Size.X, trail.Size.Y, distance)
        trail.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -distance / 2)

        if color then
            trail.Gradient.Color3 = color
            trail.Gradient2.Color3 = color
        end

        local duration = distance * 0.001
        TweenService:Create(
            trail,
            TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In),
            {
                CFrame = CFrame.new(endPos, 2 * endPos - startPos),
                Size = trail.Size * Vector3.new(1, 1, 0)
            }
        ):Play()

        task.delay(
            duration,
            function()
                trail:Destroy()
            end
        )
    end

    function SumoSlap(args)
        local target = getLocked()
        local hrp = char.HumanoidRootPart
        local distanceAway = (hrp.Position - target.Position).Magnitude
        local distance = math.clamp(distanceAway * 0.5, 3, 10)

        local offset = target.CFrame.LookVector * distance
        local newPosition = target.Position + offset
        local newCF = CFrame.new(newPosition, target.Position)
        args[1][2] = moves.H_FastFootworkBack
        args[1][3] = {
            {
                [1] = target,
                [2] = 10.49982091806829,
                [3] = false,
                [4] = newPosition
            }
        }
        args[1][4] = newCF

        ME:FireServer(unpack(args)) 
        createTrail(hrp.Position, target.Position, Color3.new(1, 0, 0))
    end

    function checkArgs(args)
        if
            typeof(args[1]) == "table" and args[1][1] == "heatmove" and args[1][2] == moves.H_FastFootworkBack and
                args[1][5] == "Brawler" and
                plr.Status.Heat.Value >= 75
         then
            SumoSlap(args)
        elseif typeof(args[1]) == "table" and args[1][1] == "repsound" and args[1][2] == "Teleport" then
            args[1][2] = "nuhuh"
        elseif typeof(args[1]) == "table" and args[1][1] == "tpeffect" then
            args[1][1] = "nuhuh"
        end
        return args
    end

    local processingEvent = false

    local originalNamecall
    originalNamecall =
        hookmetamethod(game,"__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}

            if self == ME and method:lower() == "fireserver" and typeof(args[1]) == "table" then
                if processingEvent then
                    return originalNamecall(self, unpack(args)) -- Avoid reprocessing modified events
                end

                processingEvent = true
                args = checkArgs(args)
                processingEvent = false
            end
            return originalNamecall(self, unpack(args))
        end)
end


local Forcefield = RPS.Invulnerable:Clone()
Forcefield.Parent = status

local ME = RPS.Events.ME

function PlaySound(sound)
	local soundclone = Instance.new("Sound")
	soundclone.Parent = char.Head
	soundclone.Name = sound
	soundclone.SoundId = RPS.Sounds:FindFirstChild(sound).Value
	soundclone.Volume = 0.35
	soundclone.PlaybackSpeed = RPS.Sounds:FindFirstChild(sound).PlaybackSpeed.Value
	soundclone:Play()
	ME:FireServer({"repsound",sound})
	soundclone.Ended:Connect(function()
		game:GetService("Debris"):AddItem(soundclone)
	end)
end

function isInBattle()
	return (plr:FindFirstChild("InBattle") and true or false)
end

function IsInDungeon()
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

function InCriticalHp()
	if plr.Status.Health.Value <= plr.Status.MaxHealth.Value * 0.25 then
		return true
	elseif plr.Status.MaxHealth.Value * 0.25 <= plr.Status.Health.Value then
		return false
	end
end

function IsInPvp()
	if plr:FindFirstChild("PvPed") then
		return true
	else
		return false
	end
end

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

	ME:FireServer(unpack(args))
end

function play_ingamesound(sfxname)
	local v = sounds:FindFirstChild(sfxname)
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

function playsound(id, volume)
	local sfx = Instance.new("Sound", char.Head)
	sfx.SoundId = "rbxassetid://"..tostring(id)
            sfx.Volume = volume or 2
	sfx:Play()

	spawn(function()
		task.wait(sfx.TimeLength)
		sfx:Destroy()
	end)
end

function playSound(sound)
    local soundclone = Instance.new("Sound")
    soundclone.Parent = char.Head
    soundclone.Name = sound.Name
    soundclone.SoundId = sound.Value
    if not sound.Name:find("taunt") then
        soundclone.Volume = 0.35
    elseif sound.Name:find("taunt") then
        soundclone.Volume = 0.5
    end
    soundclone:Play()
    soundclone.Ended:Connect(function()
        game:GetService("Debris"):AddItem(soundclone)
    end)
end

if debug then 
    Notify("Dragon Style is being worked on right now", "HeatDepleted", Color3.fromRGB(255,255,255), nil)
    task.wait(1.5)
    Notify("Some features may not work, but I am working on it", "HeatDepleted", Color3.fromRGB(255,255,255), nil)
end

alreadyRunning = Instance.new("BoolValue")
alreadyRunning.Parent = status
alreadyRunning.Value = true
alreadyRunning.Name = "Dragon Style"

local Y0Moveset = {
	{name = "Grab", Type = "StringValue", value = "Grab"},
	{name = "Throw", Type = "StringValue", value = "T_BrawlerToss"},
	{name = "GrabStrike", Type = "StringValue", value = "T_龍GParry"},
	{name = "RedHeat", Type = "Folder", value = nil},
	{name = "Idle", Type = "Animation", value = RPS.AIStyles.Dragon.StanceIdle.AnimationId},
	{name = "Color", Type = "Color", value = Color3.fromRGB(250,5,10)},
	{name = "Speed", Type = "NumberValue", value = 1.25},
	{name = "Pummel", Type = "StringValue", value = "T_龍GParry"},
	{name = "VisualName", Type = "StringValue", value = "Dragon"},
	{name = "Taunt", Type = "StringValue", value = "Taunt"},

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
	{name = "2Strike3", Type = "StringValue", value = "B2Strike2"},
	{name = "2Strike4", Type = "StringValue", value = "龍2Strike3"},
	{name = "2Strike5", Type = "StringValue", value = "B2Strike3"},

	{name = "BlockStrike", Type = "StringValue", value = "ShuckyDrop"},
	{name = "StanceStrike", Type = "StringValue", value = "BRCounter2"},
	{name = "H_Fallen", Type = "StringValue", value = "H_FallenSupine"},
	{name = "H_FallenDown", Type = "StringValue", value = "H_FallenGrate"},
	{name = "H_TwoHandeds", Type = "StringValue", value = "H_SelfDestruct"},
	{name = "H_GrabStanding3", Type = "StringValue", value = "H_Entangle"},
	{name = "H_Running4", Type = "StringValue", value = "H_Terror"},
	{name = "H_EvadedL", Type = "StringValue", value = "H_FastFootworkLeft"},
	{name = "H_EvadedR", Type = "StringValue", value = "H_SpinCounterLeft"},
	{name = "H_EvadedF", Type = "StringValue", value = "H_FastFootworkFront"},
	{name = "H_CounterSoloAllFront", Type = "StringValue", value = "H_TSpinCounterFront"},
	{name = "H_CounterSoloAllBack", Type = "StringValue", value = "H_TSpinCounterBack"},
	{name = "H_CounterSoloAllLeft", Type = "StringValue", value = "H_TSpinCounterLeft"},
	{name = "H_CounterSoloAllRight", Type = "StringValue", value = "H_TSpinCounterRight"},
	{name = "H_CounterSolo", Type = "StringValue", value = "H_Escape"},
	{name = "H_Distanced", Type = "StringValue", value = "H_FastFootworkBack"},
	{name = "H_FullHeat", Type = "StringValue", value = "H_GUltimateEssence"}
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

local CMoveset = {
        {name = "Grab", Type = "StringValue", value = "Grab"},
	{name = "Throw", Type = "StringValue", value = "T_BrawlerToss"},
	{name = "GrabStrike", Type = "StringValue", value = "T_龍GParry"},
	{name = "RedHeat", Type = "Folder", value = nil},
	{name = "Idle", Type = "Animation", value = RPS.AIStyles.Dragon.StanceIdle.AnimationId},
	{name = "Color", Type = "Color", value = Color3.fromRGB(250,5,10)},
	{name = "Speed", Type = "NumberValue", value = 1.25},
	{name = "Pummel", Type = "StringValue", value = "T_龍GParry"},
	{name = "VisualName", Type = "StringValue", value = "Dragon"},
	{name = "Taunt", Type = "StringValue", value = "Taunt"},

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

	{name = "BlockStrike", Type = "StringValue", value = "GuruStumble"},
	{name = "StanceStrike", Type = "StringValue", value = "BRCounter2"},
	{name = "H_Fallen", Type = "StringValue", value = "H_FallenSupine"},
	{name = "H_FallenDown", Type = "StringValue", value = "H_FallenKick"},
	{name = "H_TwoHandeds", Type = "StringValue", value = "H_SelfDestruct"},
	{name = "H_GrabStanding3", Type = "StringValue", value = "H_Entangle"},
	{name = "H_Running4", Type = "StringValue", value = "H_Terror"},
	{name = "H_EvadedL", Type = "StringValue", value = "H_FastFootworkLeft"},
	{name = "H_EvadedR", Type = "StringValue", value = "H_SpinCounterLeft"},
	{name = "H_EvadedF", Type = "StringValue", value = "H_FastFootworkFront"},
	{name = "H_CounterSoloAllFront", Type = "StringValue", value = "H_TSpinCounterFront"},
	{name = "H_CounterSoloAllBack", Type = "StringValue", value = "H_TSpinCounterBack"},
	{name = "H_CounterSoloAllLeft", Type = "StringValue", value = "H_TSpinCounterLeft"},
	{name = "H_CounterSoloAllRight", Type = "StringValue", value = "H_TSpinCounterRight"},
	{name = "H_CounterSolo", Type = "StringValue", value = "H_Escape"},
	{name = "H_Distanced", Type = "StringValue", value = "H_FastFootworkBack"},
	{name = "H_FullHeat", Type = "StringValue", value = "H_GUltimateEssence"}
}

local RDSAnims = {
	{move = "龍Attack1", value = moves.BAttack2.Anim.AnimationId},
	{move = "龍Attack2", value = moves.BAttack1.Anim.AnimationId},
	{move = "龍Attack3", value = moves.BAttack2.Anim.AnimationId},
	{move = "龍Attack4", value = moves.BAttack1.Anim.AnimationId}
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
	{move = "龍Strike5", property = "HitboxLocations", value = moves.RDashAttack.HitboxLocations.Value},
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
	{move = "龍Strike5", value = moves.RDashAttack.Anim.AnimationId}
}
local CMoveConfig = {
	{move = "BAttack1", property = "HitboxLocations", value = moves["龍Attack1"].HitboxLocations.Value},
	{move = "BAttack2", property = "HitboxLocations", value = moves["龍Attack2"].HitboxLocations.Value},
	{move = "BAttack3", property = "HitboxLocations", value = moves["龍Attack3"].HitboxLocations.Value},
	{move = "BAttack4", property = "HitboxLocations", value = moves["龍Attack4"].HitboxLocations.Value},
	{move = "BAttack1", property = "ComboAt", value = moves["龍Attack1"].ComboAt.Value},
	{move = "BAttack2", property = "ComboAt", value = moves["龍Attack2"].ComboAt.Value},
	{move = "BAttack3", property = "ComboAt", value = moves["龍Attack3"].ComboAt.Value},
	{move = "BAttack4", property = "ComboAt", value = moves["龍Attack4"].ComboAt.Value},
	{move = "BStrike3", property = "ComboAt", value = moves.BStrike2.ComboAt.Value - 0.05}
}

local CAnims = {
	{move = "BAttack1", value = moves["龍Attack1"].Anim.AnimationId},
	{move = "BAttack2", value = moves["龍Attack2"].Anim.AnimationId},
	{move = "BAttack3", value = moves["龍Attack3"].Anim.AnimationId},
	{move = "BAttack4", value = moves["龍Attack4"].Anim.AnimationId}
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

local RDSCombo = {
	{name = "Rush1", value="龍Attack1", Type="StringValue"},
	{name = "Rush2", value="龍Attack2", Type="StringValue"},
	{name = "Rush3", value="龍Attack1", Type="StringValue"},
	{name = "Rush4", value="龍Attack2", Type="StringValue"},
	{name = "Rush5", value="龍Attack1", Type="StringValue"},
	{name = "Rush6", value="龍Attack2", Type="StringValue"},
	{name = "Rush7", value="龍Attack1", Type="StringValue"},
	{name = "Rush8", value="龍Attack2", Type="StringValue"},
	{name = "Rush9", value="龍Attack1", Type="StringValue"},
	{name = "Rush10", value="龍Attack4", Type="StringValue"},
	{name = "Strike1", value ="龍Strike5", Type="StringValue"},
	{name = "Strike6", Type = "StringValue", value = "龍Strike5"},
	{name = "Strike7", Type = "StringValue", value = "B2Strike1"},
	{name = "Strike8", Type = "StringValue", value = "B2Strike2"},
	{name = "Strike9", Type = "StringValue", value = "龍2Strike4"}
}
local NCombo = {
	{name = "Rush1", value = "BAttack1", Type = "StringValue"},
	{name = "Rush2", value = "BAttack2", Type = "StringValue"},
	{name = "Rush3", value = "BAttack3", Type = "StringValue"},
	{name = "Rush4", value = "BAttack4", Type = "StringValue"},
	{name = "Rush5", value = nil, Type = "Destroy"},
	{name = "Rush6", value = nil, Type = "Destroy"},
	{name = "Rush7", value = nil, Type = "Destroy"},
	{name = "Rush8", value = nil, Type = "Destroy"},
	{name = "Rush9", value = nil, Type = "Destroy"},
	{name = "Rush10", value = nil, Type = "Destroy"},
	{name = "Strike1", Type = "StringValue", value = "龍Strike1"},
	{name = "Strike6", Type = "Destroy", value = "龍Strike5"},
	{name = "Strike7", Type = "Destroy", value = "B2Strike1"},
	{name = "Strike8", Type = "Destroy", value = "B2Strike2"},
	{name = "Strike9", Type = "Destroy", value = "龍2Strike4"}
}

function ChangeConfig(Table)
	for i,mv in ipairs(moves:GetChildren()) do
		for i,data in ipairs(Table) do
			if mv.Name == data.move then
				if data.property ~= "Anim" and data.value ~= nil then
					mv[data.property].Value = data.value
				elseif data.property == "Anim" and data.value ~= nil then
					mv[data.property].AnimationId = data.value
				end
			end
		end
	end
end

function ChangeAnims(Table)
	for i,Move in ipairs(moves:GetChildren()) do
		for i,v in ipairs(Table) do
			if v.move == Move.Name then
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

function ChangeSpeed(Type, Table)
	for i,mv in moves:GetChildren() do
		for i,data in Table do
			if mv.Name == data.Move then
				if Type == "Fast" then
					mv.ComboAt.Value = data.NewComboAt
				elseif Type == "Slow" then
					mv.ComboAt.Value = data.OldComboAt
				end
			end
		end
	end
end
function ChangeAniSpeed(Type, Table)
	for i,mv in moves:GetChildren() do
		for i,data in Table do
			if mv.Name == data.Move then
				if Type == "Fast" then
					mv.AniSpeed.Value = data.NewAniSpeed
				elseif Type == "Slow" then
					mv.AniSpeed.Value = data.OldAniSpeed
				end
			end
		end
	end
end

if _G.DragonConfigurations.Moveset == "Y0" then
	ChangeMoveset(Dragon,Y0Moveset)
	ChangeConfig(Y0MoveConfig)
	ChangeAnims(Y0Anims)
elseif _G.DragonConfigurations.Moveset == "DE" then
	ChangeMoveset(Dragon, Y0Moveset)
	ChangeConfig(DEMoveConfig)
	ChangeMoveset(Dragon, DEMoveset)
	ChangeAnims(DEAnims)
elseif _G.DragonConfigurations.Moveset == "Classic" then
	ChangeMoveset(Dragon, CMoveset)
	ChangeConfig(CMoveConfig)
	ChangeAnims(CAnims)
end


ChangeAnims(RDSAnims)
Dragon.SuperEvadeB.AnimationId = styles.Beast.EvadeB.AnimationId

moves["H_FastFootworkBack"].Closest.Value = '75'
wn = Instance.new("StringValue", moves["H_FastFootworkBack"])
wn.Name = "Within"
wn.Value = '15'	
if not IsInPvp() then
	moves.BRCounter2.Name = "FakeBRCounter2"
	moves["龍TigerDrop"].Name = "BRCounter2"
	moves["BRCounter2"].AniSpeed.Value = 0.85
end

if _G.DragonConfigurations.Moveset ~= "Classic" then
    moves.ShuckyDrop.AniSpeed.Value = moves.GuruStumble.AniSpeed.Value
    moves.ShuckyDrop.MoveForward.Value = moves.GuruStumble.MoveForward.Value
    moves.ShuckyDrop.SF.Value = 0.1
    moves.ShuckyDrop.Anim.AnimationId = moves.GuruStumble.Anim.AnimationId
    moves.BGetup.Anim.AnimationId = moves.RSweep.Anim.AnimationId
    moves.BGetup.HitboxLocations.Value = moves.RSweep.HitboxLocations.Value
end
moves.Taunt.Name = "FakeTaunt" moves.DragonTaunt.Name = "Taunt"

thing = Instance.new("BoolValue")

-- Ultimate Essence and Essence of Sumo Slapping --

local Player = game.Players.LocalPlayer
local Rep = game.ReplicatedStorage
local Char = Player.Character
local Main = Player.PlayerGui.Interface.Battle.Main

function fetchRandom(instance)
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

function fillHeat(howmany)
	for i = 1, howmany do
		ME:FireServer(A_1)
	end
end

function depleteHeat(howmany)
	for i = 1, howmany do
		ME:FireServer(unpack(A_2))
	end
end

local RDS
if not status:FindFirstChild("RedDragonSpirit") then
	RDS = Instance.new("BoolValue", status)
	RDS.Value = false 
	RDS.Name = "RedDragonSpirit"
else
	RDS = status.RedDragonSpirit
end

function HealthChanged()
	if InCriticalHp() then
		RDS.Value = true
	end
end

plr.Status.Health.Changed:Connect(HealthChanged)

function Slap(enemy)
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
		ME:FireServer(A_1)
	end
end

function Stun(enemy)
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
		ME:FireServer(A_1)
	end
end

function AutoSlap()
	if not RDS.Value then return end -- Skip execution if RDS is false

	if not IsInPvp() then
		for _, enemy in ipairs(game.Workspace.Bots.AI:GetChildren()) do
			local root = enemy:FindFirstChild("HumanoidRootPart")
			local lastTarget = enemy:FindFirstChild("LastTarget")
			local attackBegan = enemy:FindFirstChild("AttackBegan")
			local tookAim = enemy:FindFirstChild("TookAim")

			if root and lastTarget and attackBegan and tookAim then
				if lastTarget.Value == plr.Character.HumanoidRootPart then
					if attackBegan.Value then
						attackBegan.Value = false
						thing.Value = false
						Slap(root)
					elseif tookAim.Value then
						tookAim.Value = false
						task.delay(0.6, function()
							thing.Value = false
							Slap(root)
						end)
					end
				end
			end
		end
	else
		for _, opp in ipairs(game.Players:GetPlayers()) do
			if opp ~= plr then
				local oppStatus = opp:FindFirstChild("Status")
				local attackBegan = oppStatus and oppStatus:FindFirstChild("AttackBegan")

				if attackBegan and attackBegan.Value then
					attackBegan.Value = false
					thing.Value = false
					Slap(opp.Character.HumanoidRootPart)
				end
			end
		end
	end
end

local debounce = false

function Hacts()
	local heated = plr.Character:FindFirstChild("Heated")
	if heated and heated:FindFirstChild("MoveName") and status.Style.Value == "Brawler" then
		local whatHact = heated.MoveName
		local char = plr.Character

		if debounce or char:FindFirstChild("BeingHeated") then return end -- Prevent multiple activations
		debounce = true

		if whatHact.Value == "Ultimate Essence" then
                            if not fthActive then 
			local soundr = Rep.Voices.Kiryu.Taunt["taunt2 (2)"]
			local anim = char.Humanoid:LoadAnimation(Rep.Moves.H_UltimateEssence.Anim)
			local anim2 = heated.Heating.Value.Humanoid:LoadAnimation(Rep.Moves.H_UltimateEssence.Victim1)

			anim.Priority = Enum.AnimationPriority.Action4
			anim2.Priority = Enum.AnimationPriority.Action4
			anim:Play()
			anim2:Play()

			if _G.DragonConfigurations.VoiceMod then
				playSound(soundr)
			end

			task.delay(1, function() PlaySound("MassiveSlap") end)
			task.delay(2, function() anim:Destroy(); anim2:Stop(); anim2:Destroy() end)
                            else
                                   local soundr = Rep.Voices.Kiryu.Rage["extremeheatmode2"]
                                   local dk = Instance.new("Animation") dk.AnimationId = "rbxassetid://12747380309"
			local anim = char.Humanoid:LoadAnimation(dk)
			local anim2 = heated.Heating.Value.Humanoid:LoadAnimation(Rep.Anims.Fear)

			anim.Priority = Enum.AnimationPriority.Action4
			anim2.Priority = Enum.AnimationPriority.Action4
			anim:Play() anim:AdjustSpeed(1.1)
			anim2:Play()

			if _G.DragonConfigurations.VoiceMod then
				playSound(soundr)
			end

			task.delay(2, function() anim:Destroy(); anim2:Stop(); anim2:Destroy() end)
                            end
			-- "Essence of Fast Footwork [Back]
		elseif whatHact.Value == "Essence of Fast Footwork [Back]" then
			Main.HeatMove.TextLabel.Text = "Essence of Sumo Slapping"
			local anim = char.Humanoid:LoadAnimation(Rep.Moves.H_SumoSlap.Anim)
			local anim2 = heated.Heating.Value.Humanoid:LoadAnimation(Rep.Moves.H_SumoSlap.Victim1)

			anim.Priority = Enum.AnimationPriority.Action4
			anim2.Priority = Enum.AnimationPriority.Action4
			anim:Play()
			anim2:Play()

			playSound(Rep.Sounds.Teleport)

			-- Scheduled sound effects instead of blocking execution
			local slapTimes = {0.1, 0.55, 1.0, 1.9}
			for _, t in ipairs(slapTimes) do
				task.delay(t, function() PlaySound("Slap") end)
			end

			task.delay(2, function()
				PlaySound("MassiveSlap")
				anim:Destroy()
				anim2:Destroy()
			end)

		elseif whatHact.Value == "Guru Spin Counter [Left]" then
			Main.HeatMove.TextLabel.Text = "Essence of Fast Footwork [Right]"
		end
	end

	-- Reset debounce if heating effect is removed
	if not plr.Character:FindFirstChild("Heated") then
		debounce = false
	end
end


-- Aura, Idle Stance, Hact Renames, No Heat Action Label
local DragonText = "Dragon"
styles.Blade.Color.Value = Color3.fromRGB(0,0,0)
local DragonColor
DragonColor = Color3.fromRGB(250,5,10)
local DSeq = ColorSequence.new({ColorSequenceKeypoint.new(0, DragonColor), ColorSequenceKeypoint.new(1, DragonColor)})
local NoTrail = ColorSequence.new({ColorSequenceKeypoint.new(0, styles.Blade.Color.Value), ColorSequenceKeypoint.new(1, styles.Blade.Color.Value)})

function UpdateStyle()
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
		if main.HeatMove.TextLabel.Text == "Guru Firearm Flip" then
			main.HeatMove.TextLabel.Text = "Komaki Shot Stopper"
		elseif main.HeatMove.TextLabel.Text == "Ultimate Essence" then
			main.HeatMove.TextLabel.Text = "Ultimate Essence "
        elseif main.HeatMove.TextLabel.Text == "Essence of Fast Footwork [Back]" then
            main.HeatMove.TextLabel.Text = "Essence of Sumo Slapping" 
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

local MoveSpeed = {
	{Move = "BAttack1", NewComboAt = moves["BAttack1"].ComboAt.Value - 0.05, OldComboAt = moves["BAttack1"].ComboAt.Value},
	{Move = "BAttack2", NewComboAt = moves["BAttack2"].ComboAt.Value - 0.05, OldComboAt = moves["BAttack2"].ComboAt.Value},
	{Move = "BAttack3", NewComboAt = moves["BAttack3"].ComboAt.Value - 0.05, OldComboAt = moves["BAttack3"].ComboAt.Value},
	{Move = "BAttack4", NewComboAt = moves["BAttack4"].ComboAt.Value - 0, OldComboAt = moves["BAttack4"].ComboAt.Value},
	{Move = "BStrike2", NewComboAt = moves["BStrike2"].ComboAt.Value - 0.05, OldComboAt = moves["BStrike2"].ComboAt.Value},
	{Move = "BStrike3", NewComboAt = moves["BStrike3"].ComboAt.Value - 0.05, OldComboAt = moves["BStrike3"].ComboAt.Value},
	{Move = "BStrike5", NewComboAt = moves["BStrike5"].ComboAt.Value - 0.1, OldComboAt = moves["BStrike5"].ComboAt.Value},
	{Move = "龍Strike5", NewComboAt = moves["龍Strike5"].ComboAt.Value - 0.05, OldComboAt = moves["龍Strike5"].ComboAt.Value}
	
}
local MoveAniSpeed = {
	{Move = "BAttack1", NewAniSpeed = moves["BAttack1"].AniSpeed.Value + 0.05, OldAniSpeed = moves["BAttack1"].AniSpeed.Value},
	{Move = "BAttack2", NewAniSpeed = moves["BAttack2"].AniSpeed.Value + 0.05, OldAniSpeed = moves["BAttack2"].AniSpeed.Value},
	{Move = "BAttack3", NewAniSpeed = moves["BAttack3"].AniSpeed.Value + 0.05, OldAniSpeed = moves["BAttack3"].AniSpeed.Value},
	{Move = "BAttack4", NewAniSpeed = moves["BAttack4"].AniSpeed.Value + 0.05, OldAniSpeed = moves["BAttack4"].AniSpeed.Value},
	{Move = "BStrike2", NewAniSpeed = moves["BStrike2"].AniSpeed.Value + 0.05, OldAniSpeed = moves["BStrike2"].AniSpeed.Value},
	{Move = "BStrike3", NewAniSpeed = moves["BStrike3"].AniSpeed.Value + 0.05, OldAniSpeed = moves["BStrike3"].AniSpeed.Value},
	{Move = "BStrike5", NewAniSpeed = moves["BStrike5"].AniSpeed.Value + 0.1, OldAniSpeed = moves["BStrike5"].AniSpeed.Value},
	{Move = "龍Strike5", NewAniSpeed = moves["龍Strike5"].AniSpeed.Value + 0.05, OldAniSpeed = moves["龍Strike5"].AniSpeed.Value},
	{Move = "龍2Strike2", NewAniSpeed = moves["龍2Strike2"].AniSpeed.Value + 0.1, OldAniSpeed = moves["龍2Strike2"].AniSpeed.Value},
	{Move = "龍2Strike3", NewAniSpeed = moves["龍2Strike3"].AniSpeed.Value + 0.15, OldAniSpeed = moves["龍2Strike3"].AniSpeed.Value},
	{Move = "龍2Strike4", NewAniSpeed = moves["龍2Strike4"].AniSpeed.Value + 0.1, OldAniSpeed = moves["龍2Strike4"].AniSpeed.Value}
	
}

FastMoves.Changed:Connect(function()
	if FastMoves.Value == true then
		ChangeSpeed("Fast", MoveSpeed)
		ChangeAniSpeed("Fast", MoveAniSpeed)
	elseif FastMoves.Value == false then
		ChangeSpeed("Slow", MoveSpeed)
		ChangeAniSpeed("Slow", MoveAniSpeed)
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

function Animation()
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

local TweenService = game:GetService("TweenService")

function getLocked()
    return char.LockedOn.Value
end

function createTrail(startPos, endPos, color)
    local trail = RPS.TPTrail:Clone()
    trail.Parent = game.Workspace.Ignore

    local distance = (startPos - endPos).Magnitude
    trail.Size = Vector3.new(trail.Size.X, trail.Size.Y, distance)
    trail.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -distance / 2)

    if color then
        trail.Gradient.Color3 = color
        trail.Gradient2.Color3 = color
    end

    local duration = distance * 0.005
    TweenService:Create(trail, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
        CFrame = CFrame.new(endPos, 2 * endPos - startPos),
        Size = trail.Size * Vector3.new(1, 1, 0)
    }):Play()

    task.delay(duration, function()
        trail:Destroy()
    end)
end

function teleportToLocked(target)
	local user = game.Players.LocalPlayer
	local char = user.Character or user.CharacterAdded:Wait()
	local root = char.HumanoidRootPart
	local lock = char.LockedOn
	local val = target or lock.Value

	if val and val:IsDescendantOf(workspace) and not val.Parent:FindFirstChild("ImaDea") then
		-- Play teleport animation
		local anim = Instance.new("Animation")
		anim.AnimationId = Dragon.EvadeF.AnimationId
		local atrack = char.Humanoid:LoadAnimation(anim)
		atrack:AdjustSpeed(2)
		atrack.Priority = Enum.AnimationPriority.Action4
		atrack:Play()

		play_ingamesound("Teleport")

		-- Create teleport trail
		local startPos = root.Position
		local endPos = val.Position - (val.CFrame.LookVector * Vector3.new(1, 0, 1).Unit * 3)
		createTrail(startPos, endPos, Color3.fromRGB(255, 0, 0)) -- Red color trail

		-- Wait before teleporting
		task.wait(0.1)
		root.CFrame = CFrame.new(endPos, val.Position)

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
		if _G.DragonConfigurations.VoiceMod == true then
			local rage = fetchRandom(RPS.Voices.Kiryu.Rage)
			playSound(rage)
		end
		Animation()
		fillHeat(6)
		FastMoves.Value = true
		if not status:FindFirstChild("Invulnerable") then
			local invul = Instance.new("Folder",status)
			invul.Name = "Invulnerable"
		end
		FastMoves.Value = true
		if _G.DragonConfigurations.Moveset == "Y0" then
			local id = "rbxassetid://10928237540"
			local SuperCharge = Instance.new("Animation", workspace)
			SuperCharge.AnimationId = id
			local anim = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(SuperCharge)
			anim:Play()
			anim.Ended:Wait()
			SuperCharge:Destroy()
			anim:Destroy()
		elseif _G.DragonConfigurations.Moveset == "DE" then
			ChangeMoveset(Dragon, RDSCombo)
			local id = moves.H_FallenProne.Anim.AnimationId
			local anim = Instance.new("Animation")
			anim.AnimationId = id
			local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(anim)
			track.Priority = Enum.AnimationPriority.Action4
			track.Looped = false
			track:Play()
			track:AdjustSpeed(1)
			char.HumanoidRootPart.Anchored = true
			task.wait(1.25)
			char.HumanoidRootPart.Anchored = false
			track:Destroy()
			anim:Destroy()
		end
	elseif RDS.Value == true and status:FindFirstChild("ANGRY") then
		if _G.DragonConfigurations.VoiceMod == true then
			local rage = fetchRandom(RPS.Voices.Kiryu.Rage)
			playSound(rage)
		end
		Animation()
		fillHeat(6)
		FastMoves.Value = true
		if not status:FindFirstChild("Invulnerable") then
			local invul = Instance.new("Folder",status)
			invul.Name = "Invulnerable"
		end
		FastMoves.Value = true
		if _G.DragonConfigurations.Moveset == "Y0" then
			local id = "rbxassetid://10928237540"
			local SuperCharge = Instance.new("Animation", workspace)
			SuperCharge.AnimationId = id
			local anim = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(SuperCharge)
			anim:Play()
			anim.Ended:Wait()
			SuperCharge:Destroy()
			anim:Destroy()
		elseif _G.DragonConfigurations.Moveset == "DE" then
			ChangeMoveset(Dragon, RDSCombo)
			local id = moves.H_FallenProne.Anim.AnimationId
			local anim = Instance.new("Animation")
			anim.AnimationId = id
			local track = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(anim)
			track.Priority = Enum.AnimationPriority.Action4
			track.Looped = false
			track:Play()
			track:AdjustSpeed(1)
			char.HumanoidRootPart.Anchored = true
			task.wait(1.25) track:Stop()
			char.HumanoidRootPart.Anchored = false
			track:Destroy()
			anim:Destroy()
		end
	else 
		if status:FindFirstChild("Invulnerable") then
			status.Invulnerable:Destroy()
		end
		ChangeMoveset(Dragon, NCombo)
	end
end)

-- Reload 
local plr = game:GetService("Players").LocalPlayer
local pgui = plr.PlayerGui
local interf = pgui.Interface

local oldcframe = char.HumanoidRootPart.CFrame
interf.Client.Disabled = true
task.wait()
interf.Client.Disabled = false
char.HumanoidRootPart.CFrame = oldcframe

if not IsInPvp() then
    moves.BRCounter2.Anim.AnimationId = "rbxassetid://11464955887"
else
    moves.BRCounter2.Anim.AnimationId = oldanim
end
moves.HueDrop.Anim.AnimationId = moves.TigerDrop.Anim.AnimationId
local styleToChange = "Brawler" --Brawler = fisticuffs, Rush = frenzy, Beast = brute.  you MUST use one of these 3 or else you cannot use the custom style.
local styleToChangeTo = "堂島の龍" -- is Dragon Style
local characterToChange = "Your Avatar"
local characterToChangeTo = "Kiryu Morph"

if _G.DragonConfigurations.MorphMod == true then
	_G.Morph = "Legendary Dragon"          
	loadstring(game:HttpGet("https://raw.githubusercontent.com/aAAAakakrvmv192/R2FMods/main/charmorphmod.lua"))();
end

if _G.DragonConfigurations.FeelTheHeat == true then
local enemyHPFrame = pgui.EInterface.EnemyHP
local hpTextLabel = enemyHPFrame.BG.Meter.HPTxt
local enemyValue = enemyHPFrame.Enemy -- ObjectValue that changes

function getEnemy()
    for _, v in workspace.Bots.AI:GetChildren() do
        if v:FindFirstChild("MyArena") and v.MyArena.Value == status.MyArena.Value then
            local bossMarker = v:FindFirstChild("Boss")
            if bossMarker and bossMarker:IsA("Folder") then
                return v
            end
        end
    end
end

local qter = plr.PlayerGui.Interface.QTEr
local notifier = plr.PlayerGui.Notify

function qtesound(sound, volume)
	local sfx = Instance.new("Sound", char.Head)
	sfx.SoundId = sound.Value
            sfx.Volume = volume or sound.Volume.Value - 2
            sfx.PlaybackSpeed = sound.PlaybackSpeed.Value
	sfx:Play()

	spawn(function()
		task.wait(sfx.TimeLength)
		sfx:Destroy()
	end)
end

local TweenService = game:GetService("TweenService")
local isPc = true
local Parent = game.Players.LocalPlayer.PlayerGui.Interface
local qteUI = Parent.QTE
local script = Parent.QTEr
local mButtons = game:GetService("Players").LocalPlayer.PlayerGui.MobileUI.MobileFrame.Right.Buttons
-- ButtonA, ButtonX, ButtonY, ButtonB
local buttonImages = Parent.ButtonImages
 
local keyButtons = {'E', 'Q', "M1", "M2"}
local mcButtons = {"ButtonA", "ButtonB", "ButtonX", "ButtonY"}
local chosenInput
local whichInput
local mashActive = false
local mashCounter = 0
local sentData = 0
local device = Parent.Parent.Device
local tweens = {}
local events = game.ReplicatedStorage.Events

tweens.Flicker = TweenService:Create(qteUI.Glow, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 999999, true), {
	ImageTransparency = 0.5;
})
tweens.InputFadeOut = TweenService:Create(qteUI.PromptG, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {
	GroupTransparency = 1;
})
tweens.RingFadeOut = TweenService:Create(qteUI, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {
	ImageTransparency = 1;
})
tweens.ProgressRingFadeOutLeft = TweenService:Create(qteUI.Left.ImageLabel, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {
	ImageTransparency = 1;
})
tweens.ProgressRingFadeOutRight = TweenService:Create(qteUI.Right.ImageLabel, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {
	ImageTransparency = 1;
})
tweens.Shockwave = TweenService:Create(qteUI.Shockwave, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {
	Size = UDim2.new(20, 0, 20, 0);
	ImageTransparency = 1;
})
tweens.PromptShrink = TweenService:Create(qteUI.PromptG.Prompt, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
	Size = UDim2.new(0.25, 0, 0.25, 0);
})
tweens.PromptGrow = TweenService:Create(qteUI.PromptG.Prompt, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
	Size = UDim2.new(0.8, 0, 0.8, 0);
})
tweens.PromptGlowFadeOut = TweenService:Create(qteUI.PromptG.Prompt.Glow, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {
	ImageTransparency = 1;
})
tweens.SuccessGlowOut = TweenService:Create(qteUI.SuccessGlow, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {
	ImageTransparency = 1;
	Size = UDim2.new(2, 0, 2, 0);
})
tweens.InputGreyOut = TweenService:Create(qteUI.PromptG.Prompt.Input, TweenInfo.new(0.4, Enum.EasingStyle.Linear), {
	ImageColor3 = Color3.new(0.5, 0.5, 0.5);
})
spawn(function() -- Line 42
	--[[ Upvalues[1]:
		[1]: buttonImages (readonly)
	]]
	local children = buttonImages:GetChildren()
	for i = 1, #children do
		local clone = script.btn:clone()
		clone.Parent = script.Parent
		clone.Image = "rbxassetid://"..children[i].Value
		clone.Visible = true
	end
end)
function getb(arg1) -- Line 54
	--[[ Upvalues[6]:
		[1]: mcButtons (readonly)
		[2]: isPc (read and write)
		[3]: keyButtons (readonly)
		[4]: qteUI (readonly)
		[5]: buttonImages (readonly)
		[6]: chosenInput (read and write)
	]]
            local randint
	if arg1 == nil then
		randint = math.random(1, 4)
	end
	local buttonIndex = mcButtons[randint]
	if isPc then
		buttonIndex = keyButtons[randint]
	end
	qteUI.PromptG.Prompt.Input.Image = "rbxassetid://"..buttonImages[buttonIndex].Value
	chosenInput = randint
end
local newKeypoint = NumberSequenceKeypoint.new
function fill(arg1) -- Line 62
	--[[ Upvalues[2]:
		[1]: qteUI (readonly)
		[2]: newKeypoint (readonly)
	]]
	local clamped = math.clamp(arg1 * 360, 0, 360)
	local ImageLabel = qteUI.Left.ImageLabel
	local visibleFlag = false
	local ImageLabel2 = qteUI.Right.ImageLabel
	if 0.5 > arg1 then
		visibleFlag = false
	else
		visibleFlag = true
	end
	ImageLabel.Parent.Visible = visibleFlag
	ImageLabel.UIGradient.Rotation = math.clamp(clamped, 180, 360)
	ImageLabel2.UIGradient.Rotation = math.clamp(clamped, 0, 180)
	local NumberSequence_new_result1 = NumberSequence.new({newKeypoint(0, 0), newKeypoint(0.5, 0), newKeypoint(0.501, 1), newKeypoint(1, 1)})
	ImageLabel.UIGradient.Transparency = NumberSequence_new_result1
	ImageLabel2.UIGradient.Transparency = NumberSequence_new_result1
end
function QTEStart() -- Line 75
	--[[ Upvalues[3]:
		[1]: script (readonly)
		[2]: qteUI (readonly)
		[3]: tweens (readonly)
	]]
	qtesound(script.Appear, 1)
	qteUI.Visible = true
	tweens.Shockwave:Play()
	tweens.Flicker:Play()
end
function QTEEnd() -- Line 83
	--[[ Upvalues[6]:
		[1]: mashActive (read and write)
		[2]: whichInput (read and write)
		[3]: chosenInput (read and write)
		[4]: mashCounter (read and write)
		[5]: qteUI (readonly)
		[6]: tweens (readonly)
	]]
	mashActive = false
	whichInput = nil
	chosenInput = nil
	mashCounter = 0
	qteUI.Glow.ImageTransparency = 1
	tweens.RingFadeOut:Play()
	tweens.ProgressRingFadeOutLeft:Play()
	tweens.ProgressRingFadeOutRight:Play()
	tweens.InputFadeOut:Play()
	tweens.Flicker:Cancel()
end
function ResetQTE() -- Line 96
	--[[ Upvalues[1]:
		[1]: qteUI (readonly)
	]]
	qteUI.ImageTransparency = 0.5
	qteUI.Left.ImageLabel.ImageTransparency = 0
	qteUI.Right.ImageLabel.ImageTransparency = 0
	qteUI.PromptG.GroupTransparency = 0
	qteUI.PromptG.Prompt.Input.ImageColor3 = Color3.new(1, 1, 1)
	qteUI.PromptG.Prompt.Glow.Visible = false
	qteUI.PromptG.Prompt.Glow.ImageTransparency = 0
	qteUI.PromptG.Prompt.Size = UDim2.new(0.5, 0, 0.5, 0)
	qteUI.PromptG.Prompt.Position = UDim2.new(0.5, 0, 0.5, 0)
	qteUI.SuccessGlow.Visible = false
	qteUI.SuccessGlow.ImageTransparency = 0
	qteUI.SuccessGlow.Size = UDim2.new(1.5, 0, 1.5, 0)
	qteUI.PromptG.MashPrompt.Visible = false
	qteUI.Shockwave.ImageTransparency = 0.8
	qteUI.Shockwave.Size = UDim2.new(0, 0, 0, 0)
	fill(1)
end

function QTEFail() -- Line 143
	--[[ Upvalues[2]:
		[1]: script (readonly)
		[2]: qteUI (readonly)
	]]
	qtesound(script.Fail,1 )
	QTEEnd()
	qteUI.PromptG.Prompt.Input.ImageColor3 = Color3.new(0.5, 0.5, 0.5)
	task.wait(0.45)
	qteUI.Visible = false
	ResetQTE()
end

function PulsateMash() -- Line 172
	--[[ Upvalues[3]:
		[1]: mashCounter (read and write)
		[2]: qteUI (readonly)
		[3]: TweenService (readonly)
	]]
	mashCounter = mashCounter + 1
	local pulseClone = qteUI.Pulse:Clone()
	pulseClone.Visible = true
	pulseClone.Archivable = false
	pulseClone.Parent = qteUI
	TweenService:Create(pulseClone, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
		Size = UDim2.new(1.5, 0, 1.2, 0);
	}):Play()
	delay(0.09, function() -- Line 183
		--[[ Upvalues[1]:
			[1]: pulseClone (readonly)
		]]
		pulseClone:Destroy()
	end)
end
function QTEMashInputDown() -- Line 186
	--[[ Upvalues[1]:
		[1]: qteUI (readonly)
	]]
	qteUI.PromptG.Prompt.Position = UDim2.new(0.5, 0, 0.5, 6)
end
function QTEMashInputUp() -- Line 191
	--[[ Upvalues[1]:
		[1]: qteUI (readonly)
	]]
	qteUI.PromptG.Prompt.Position = UDim2.new(0.5, 0, 0.5, 0)
end
function QTEMashSuccess() -- Line 195
	--[[ Upvalues[5]:
		[1]: events (readonly)
		[2]: sentData (read and write)
		[3]: script (readonly)
		[4]: qteUI (readonly)
		[5]: tweens (readonly)
	]]
	events.QTE:FireServer(sentData)
	qtesound(script.Success, 1)
	QTEEnd()
	qteUI.PromptG.Prompt.Glow.Visible = true
	tweens.PromptGlowFadeOut:Play()
	qteUI.SuccessGlow.Visible = true
	tweens.SuccessGlowOut:Play()
	task.wait(0.45)
	qteUI.Visible = false
	ResetQTE()
end
function QTEMashFail() -- Line 212
	--[[ Upvalues[1]:
		[1]: script (readonly)
	]]
	qtesound(script.Fail,1)
	QTEFail()
end
function QTEMashStart(arg1, arg2, arg3) -- Line 218
	--[[ Upvalues[5]:
		[1]: mashActive (read and write)
		[2]: script (readonly)
		[3]: qteUI (readonly)
		[4]: isPc (read and write)
		[5]: mashCounter (read and write)
	]]
	mashActive = true
	getb(arg3)
	qtesound(script.Appear,1)
	qteUI.PromptG.MashPrompt.Visible = not isPc
	qteUI.ImageTransparency = 1
	qteUI.Left.ImageLabel.ImageTransparency = 1
	qteUI.Right.ImageLabel.ImageTransparency = 1
	if not isPc then
		qteUI.PromptG.Prompt.Size = UDim2.new(0.5, 0, 0.4, 0)
	end
	QTEStart()
	wait(0.1)
	for _ = 1, math.ceil(arg1 / 0.1) do
		task.wait(0.05)
		QTEMashInputDown()
		task.wait(0.05)
		QTEMashInputUp()
		if arg2 <= mashCounter then break end
	end
	if arg2 <= mashCounter then
		QTEMashSuccess()
	else
		QTEMashFail()
	end
end

local hook = Instance.new("BindableEvent")
hook.Event:Connect(function(arg1)
    if chosenInput and (whichInput == nil or mashActive) then
        whichInput = arg1
        if mashActive and whichInput == chosenInput then
            PulsateMash()
        end
    end
end)

local uis = game:GetService("UserInputService")
uis.InputBegan:Connect(function(key, gp)
    if gp then return end

    if (key.KeyCode == Enum.KeyCode.E or key.KeyCode == Enum.KeyCode.ButtonA) and fthActive then
        hook:Fire(1)
    elseif (key.KeyCode == Enum.KeyCode.Q or key.KeyCode == Enum.KeyCode.ButtonB) and fthActive then
        hook:Fire(2)
        elseif (key.UserInputType == Enum.UserInputType.MouseButton1 or key.KeyCode == Enum.KeyCode.ButtonX) and fthActive then
        hook:Fire(3)
        elseif (key.UserInputType == Enum.UserInputType.MouseButton2 or key.KeyCode == Enum.KeyCode.ButtonY) and fthActive then
        hook:Fire(4)
    end
end)

mButtons.ButtonA.Activated:Connect(function()
    if fthActive then
        hook:Fire(1)
    end
end)
mButtons.ButtonB.Activated:Connect(function()
    if fthActive then
        hook:Fire(2)
    end
end)
mButtons.ButtonX.Activated:Connect(function()
    if fthActive then
        hook:Fire(3)
    end
end)
mButtons.ButtonY.Activated:Connect(function()
    if fthActive then
        hook:Fire(4)
    end
end)

function checkpc() -- Line 256
	--[[ Upvalues[2]:
		[1]: device (readonly)
		[2]: isPc (read and write)
	]]
	if device.Value == "PC" then
		isPc = true
	else
		isPc = false
	end
end

device.Changed:connect(function() 
	wait()
	checkpc()
end)
checkpc()

function startMash(time, hits, button)
    QTEMashStart(time, hits, button)
end

local bossList = {}

local dStorage = {}
local rStorage = {}
local bStorage = {}

local dhStorage = {}
local rhStorage = {}
local bhStorage = {}

local mashHits = 0

function getStorage(style)
    if style.Name == "Brawler" then
        return dStorage
    elseif style.Name == "Rush" then
        return rStorage
    elseif style.Name == "Beast" then
        return bStorage
    end
end

function isHTMove(moveName)
    return moveName:sub(1, 2) == "H_" or moveName:sub(1, 2) == "T_"
end

function wipeMoves(style)
    local storage = getStorage(style)
    if not storage then return end
    for _, v in ipairs(style:GetChildren()) do
        if v:IsA("StringValue") then
            if isHTMove(v.Name) then
                if style.Name == "Brawler" then
                    dhStorage[v.Name] = v.Value
                elseif style.Name == "Rush" then
                    rhStorage[v.Name] = v.Value
                elseif style.Name == "Beast" then
                    bhStorage[v.Name] = v.Value
                end
            else
                storage[v.Name] = v.Value
                v.Value = "Slapper"
            end
        end
    end
end

function giveMoves(style)
    local storage = getStorage(style)
    if not storage then return end
    for _, v in ipairs(style:GetChildren()) do
        if v:IsA("StringValue") then
            if isHTMove(v.Name) then
                if style.Name == "Brawler" then
                    v.Value = dhStorage[v.Name] or v.Value
                elseif style.Name == "Rush" then
                    v.Value = rhStorage[v.Name] or v.Value
                elseif style.Name == "Beast" then
                    v.Value = bhStorage[v.Name] or v.Value
                end
            elseif storage[v.Name] then
                v.Value = storage[v.Name]
            end
        end
    end
end


function fillEveryThree()
    if not fthActive then return end
    if mashHits % 3 == 0 and mashHits > 0 then
        fillHeat(2) mashHits = 0
    end
end

game:GetService("RunService").Stepped:Connect(function()
    fillEveryThree() qteUI.PromptG.MashPrompt.Visible = false
end)
local oldPulsate = PulsateMash

PulsateMash = function(...)
    mashHits = mashHits + 1
    return oldPulsate(...)
end

local fList = {
    "Hue", "Vulcan"
}
local kList = {
    "Parker", "Silent Stranger", "Mikey", "Sensei Jeff Jefferson"
}
local bList = {
    "Derek", "The Foreman", "Gorillaman"
}
	
function doFinisher(enemy)
    local whichHact
    local enemyName = enemy.Name
    local finisher 
    --[[
    Choose finisher by name
    Hue, Vulcan for current finisher
    Parker, Silent Stranger, Mikey for kicking
    Derek, Foreman, Gorillaman for brute finisher

    --]]
    
    if table.find(fList, enemyName) then
        whichHact = "H_GUltimateEssence"
        finisher = "Ult"
    elseif table.find(kList, enemyName) then

        finisher = "Kicks"
    elseif table.find(bList, enemyName) then

        finisher = "Heavy"
    end
    print(finisher)
end
	
function feelTheHeat(boss)
    if not boss or bossList[boss.Name] then return end
    bossList[boss.Name] = true
    repeat task.wait() until not doingHact() and not boss:FindFirstChild("Ragdolled") and not char:FindFirstChild("Ragdolled") 
    task.wait(0.75)
    local bossHRP = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("HRP") fthActive = true 
    thing.Value = false
    Stun(bossHRP)
    print(bossHRP, bossHRP.Parent.Name)
    local hrp = char.HumanoidRootPart
    hrp.Anchored = true

    local charging = styles.Beast.Block
    local cTrack = char.Humanoid:LoadAnimation(charging)
    local rage = Instance.new("Animation") rage.AnimationId = "http://www.roblox.com/asset/?id=10478338114"
    
    local rTrack = char.Humanoid:LoadAnimation(rage)
    cTrack.Priority = Enum.AnimationPriority.Action3
    rTrack.Priority = Enum.AnimationPriority.Action3

    depleteHeat(13)
    Notify("Feel the Heat!", nil, Color3.fromRGB(30, 30, 255), nil)
    playsound(122181379530597) 
    wipeMoves(styles.Brawler)
    wipeMoves(styles.Rush)
    wipeMoves(styles.Beast)

    cTrack:Play()
    RPS.Invulnerable:Clone().Parent = status
    task.wait(0.5)

    task.delay(0.5, function()
        playSound(fetchRandom(RPS.Voices.Kiryu.Rage))
    end)

    startMash(8, 18, nil)
		
    cTrack:Stop()
    cTrack:Destroy()
    rTrack:Play() rTrack:AdjustSpeed(1.5) rTrack.Looped = false 
    playsound(74136410959637)
    task.wait(0.75)
    UseHeatAction("H_GUltimateEssence","Brawler",{bossHRP})
    doFinisher(boss)
    hrp.Anchored = false
    if status:FindFirstChild("Invulnerable") then
        status.Invulnerable:Destroy()
    end
    rTrack.Ended:Wait() task.wait(2)
    giveMoves(styles.Brawler)
    giveMoves(styles.Rush)
    giveMoves(styles.Beast) mashHits = 0 fthActive = false
    
    rTrack:Stop()
    rTrack:Destroy()
end

local inBattle = Instance.new("BoolValue")

plr.ChildAdded:Connect(function(child)
    if child.Name == "InBattle" then inBattle.Value = true end
end)

plr.ChildRemoved:Connect(function(child)
    if child.Name == "InBattle" then inBattle.Value = false end
end)

function checkBossHP()
    local enemy = getEnemy()
    if enemy and enemy:FindFirstChild("Boss") and isInBattle() and enemyValue.Value == enemy then
        local bossMarker = enemy:FindFirstChild("Boss")
        if not bossMarker or not bossMarker:IsA("Folder") then return end 

        local text = hpTextLabel.Text
        local currenthp, maxhp = string.match(text, "(%d+)%/(%d+)")
        if currenthp and maxhp then
            currenthp = tonumber(currenthp)
            maxhp = tonumber(maxhp)
            if currenthp <= 300 and not bossList[enemy.Name] then
                feelTheHeat(enemy)
            end
        end
    end
end

inBattle.Changed:Connect(function()
    if not inBattle.Value then
        bossList = {}
        mashHits = 0
    end
end)

hpTextLabel:GetPropertyChangedSignal("Text"):Connect(checkBossHP)
end

game:GetService("RunService").Stepped:Connect(function()
	UpdateStyle()
	AutoSlap() Hacts()
            if InCriticalHp() then
                RDS.Value = true -- Activate RDS
            end
        
            if RDS.Value and not isInBattle() then
                RDS.Value = false -- Disable RDS when exiting battle
            end

	if RDS.Value == true then
                if not status:FindFirstChild("Invulnerable") then
                    local invul = Instance.new("Folder",status)
                    invul.Name = "Invulnerable"
	    end
            end
end)

status.Style.Changed:Connect(function()
	if status.Style.Value == "Brawler" then
		moves["H_FastFootworkBack"].Closest.Value = '75'
		if not moves["H_FastFootworkBack"]:FindFirstChild("Within") then
			wn = Instance.new("StringValue", moves["H_FastFootworkBack"])
			wn.Name = "Within"
			wn.Value = '15'
		end
	elseif status.Style.Value == "Rush" then
		if moves["H_FastFootworkBack"]:FindFirstChild("Within") then
			moves["H_FastFootworkBack"]:FindFirstChild("Within"):Destroy()
			moves["H_FastFootworkBack"].Closest.Value = '15'
		end
	end
end)
status.Resets.Changed:Connect(function()
	Notify("You have prestiged [" .. status.Resets.Value .. "] times !",nil, Color3.fromRGB(255, 196, 0))
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
		Notify("You have defeated [" .. status.Stats.Kills.Value .. "] enemies.",nil, Color3.fromRGB(232, 9, 9))
	end
end)

status.AttackBegan.Changed:Connect(function() 
	if status.AttackBegan.Value == true then 
		if status.CurrentMove.Value.Name == "龍Attack4" then
			if char.LockedOn.Value and status.Heat.Value >= 75 and (char.HumanoidRootPart.CFrame.Position - char.LockedOn.Value.CFrame.Position).Magnitude <= 15 then
				UseHeatAction("H_Fisticuffs","Brawler",{char.LockedOn.Value})
				local con
				con = game:GetService("RunService").RenderStepped:Connect(function()
					Main.HeatMove.TextLabel.Text = "Essence of Hundred Fist Rush"
				end)
				task.wait(3)
				con:Disconnect()
			end
		end 
	end 
end)

if _G.DragonConfigurations.CustomMorphSkin == true and _G.DragonConfigurations.MorphMod == true then
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

if _G.DragonConfigurations.VoiceMod == true then
    _G.VoiceCharacter = "Kiryu"
    loadstring(game:HttpGet("https://pastebin.com/raw/ihQaV3N6"))();
end
menu.Abilities.Frame.Frame.Frame.Tabs.Tabs.Brawler.Filled.Title.Text = "Dragon"
menu.Abilities.Frame.Frame.Frame.Tabs.Tabs.Rush.Filled.Title.Text = "Frenzy"
menu.Abilities.Frame.Frame.Frame.Tabs.Tabs.Beast.Filled.Title.Text = "Brute"
--Ability Names--
local list = {
	["Counter Hook"] = "Komaki Tiger Drop",
	["Guru Parry"] = "Komaki Parry",
	["Time for Resolve"] = "Red Dragon Spirit",
	["Finishing Hold"] = "Essence of Sumo Slapping",
	["Ultimate Essence"] = "Ultimate Essence",
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

local startsound = Instance.new("Sound")
startsound.SoundId = "rbxassetid://9085027122"
game:GetService("SoundService"):PlayLocalSound(startsound)
Notify("Dragon Style Loaded!",nil,Color3.fromRGB(3,161,252),"RobotoMono")
Forcefield:Destroy()
startsound.Ended:Wait()
startsound:Destroy()









