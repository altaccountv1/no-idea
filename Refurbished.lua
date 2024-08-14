local DragonText = "Dragon"
local DragonColor = Color3.fromRGB(250, 5, 10)
local DragonSequence = ColorSequence.new({ColorSequenceKeypoint.new(0, DragonColor), ColorSequenceKeypoint.new(1, DragonColor)})
 
local plr = game.Players.LocalPlayer
local pgui = plr.PlayerGui
local interf = pgui.Interface
local bt = interf.Battle
local main = bt.Main
 
local hasUpdatedOnce = false
local tigerDropsSession = 0
local hactsSession = 0
 
 
local function sendNotification(Text, Color, Sound)
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
			end
		end
	end
end
 
local function changeValueStrict(obj, valName, newVal, valClass)
	if obj and newVal and valName then
		if not obj:FindFirstChild(valName) then
			local n = Instance.new(valClass)
			n.Name = valName
			n.Parent = obj
		end
		obj[valName].Value = newVal
	end
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
 
local alreadyRunning = game.ReplicatedStorage:FindFirstChild("DragonOfSteel")
if alreadyRunning then
	sendNotification("Dragon of Steel is already loaded")
	return
end
 
 
alreadyRunning = Instance.new("BoolValue")
alreadyRunning.Parent =game.ReplicatedStorage
alreadyRunning.Value = true
alreadyRunning.Name = "DragonOfSteel"
 
 
sendNotification("Loading mod...")
 
local menu = pgui.MenuUI.Menu 
local abil = menu.Abilities.Frame.Frame.Frame
local moves = game.ReplicatedStorage.Moves
 
local abilFolder = game.ReplicatedStorage.Abilities.Brawler
 
local kiwamiParticle;
local battleWatcher = false;
 
local fill3 = nil
local climaxfill3 = nil	
 
local fillPreview = nil
local climaxPreview = nil
 
local status = plr.Status
 
local connections = {
	KiwamiParticles = nil;
	PunchTrail = nil;
	BattleStart = nil;	
}
 
local specDialogues = {
	Parker = false;
	Bill = false;
	James = false;
	Caitlin = false;
}
 
local animsChanged = false
local hasReloaded = false
 
local essenceCodeNames = { }
local essenceUsages = { }
 
function scanHeatActions()
	for _,action in pairs(game.ReplicatedStorage.Moves:GetChildren()) do
		if string.sub(action.Name, 1, 2) == "H_" then
			local mn = action:FindFirstChild("MoveName")
			if mn then
				essenceCodeNames[mn.Value] = action.Name
 
				if action:FindFirstChild("HeatUse") then
					essenceUsages[mn.Value] = action.HeatUse.Value 
				else
					essenceUsages[mn.Value] = action:FindFirstChild("HeatNeeded") and (action.HeatNeeded.Value == "Climax" and 75 or action.HeatNeeded.Value == "Full" and 100 or 50) or 50
				end
			end
		end
	end
end
 
sendNotification("loading heat actions...", Color3.fromRGB(255, 255, 255))
scanHeatActions()
 
local function UpdateStyle()
	if status.Style.Value == "Brawler" then 
		--main gui
		game.ReplicatedStorage.Styles.Brawler.VisualName.Value = DragonText
		game.ReplicatedStorage.Styles.Brawler.Color.Value = DragonColor
		main.XP.Fill.ImageColor3 = DragonColor 
 
		--particles
		local char = plr.Character
		char.HumanoidRootPart.Fire_Main.Color = DragonSequence
		char.HumanoidRootPart.Fire_Secondary.Color = DragonSequence
		char.HumanoidRootPart.Fire_Main.Rate = status.Heat.Value >= 100 and 115 or status.Heat.Value >= 75 and 85 or 80
		char.HumanoidRootPart.Fire_Secondary.Rate = status.Heat.Value >= 100 and 90 or status.Heat.Value >= 75 and 80 or 70
		char.HumanoidRootPart.Lines1.Color = DragonSequence
		char.HumanoidRootPart.Lines1.Rate = status.Heat.Value >= 100 and 60 or status.Heat.Value >= 75 and 40 or 20
		char.HumanoidRootPart.Lines2.Color = DragonSequence
		char.HumanoidRootPart.Lines2.Rate = status.Heat.Value >= 100 and 60 or status.Heat.Value >= 75 and 40 or 20
		char.HumanoidRootPart.Sparks.Color = DragonSequence
		if not char.HumanoidRootPart.TimeFor.Enabled then
			char.HumanoidRootPart.TimeFor.Color = DragonSequence
		end
 
		char.UpperTorso["r2f_aura_burst"].Lines1.Color = DragonSequence
		char.UpperTorso["r2f_aura_burst"].Lines2.Color = DragonSequence
		char.UpperTorso["r2f_aura_burst"].Flare.Color = DragonSequence
		char.UpperTorso["r2f_aura_burst"].Lines1.Enabled = showMaxHeatEffect()
		char.UpperTorso["r2f_aura_burst"].Flare.Enabled = showMaxHeatEffect()
		char.UpperTorso["r2f_aura_burst"].Smoke.Color = DragonSequence
		char.UpperTorso.Evading.Color = DragonSequence
		-- heat bar
		if DragonText == "Dragon" then
			main.Heat.Fill.ImageColor3 = Color3.fromRGB(180, 0, 0)
			main.Heat.Fill2.ImageColor3 = Color3.fromRGB(255, 66, 142)
			main.Heat.ClimaxFill.ImageColor3 = Color3.fromRGB(180, 0, 0)
			main.Heat.ClimaxFill2.ImageColor3 = Color3.fromRGB(255, 39, 86)
		elseif DragonText == "Legend" then
			main.Heat.Fill.ImageColor3 = Color3.fromRGB(152, 152, 152)
			main.Heat.Fill2.ImageColor3 = Color3.fromRGB(203, 221, 225)
			main.Heat.ClimaxFill.ImageColor3 = Color3.fromRGB(136, 149, 152)
			main.Heat.ClimaxFill2.ImageColor3 = Color3.fromRGB(144, 216, 221)
		end
		-- idle stance
		--if (isInBattle() and not hasWeaponInHand() and char.Humanoid.MoveDirection == Vector3.new(0, 0, 0)) and not anim.IsPlaying then
		--	anim:Play()
		--elseif (not isInBattle() or hasWeaponInHand() or char.Humanoid.MoveDirection ~= Vector3.new(0, 0, 0)) and anim.IsPlaying then
		--	anim:Stop()
		--end
	else
		local char = plr.Character
		char.UpperTorso["r2f_aura_burst"].Flare.Enabled = false
		char.UpperTorso["r2f_aura_burst"].Lines1.Enabled = false
 
		char.HumanoidRootPart.Fire_Main.Rate = 80
		char.HumanoidRootPart.Fire_Secondary.Rate = 50
		char.HumanoidRootPart.Lines1.Rate = 20
		char.HumanoidRootPart.Lines2.Rate = 20
 
		main.Heat.Fill.ImageColor3 = Color3.fromRGB(40, 150, 250)
		main.Heat.Fill2.ImageColor3 = Color3.fromRGB(70, 250, 250)
		main.Heat.ClimaxFill.ImageColor3 = Color3.fromRGB(180, 0, 0)
		main.Heat.ClimaxFill2.ImageColor3 = Color3.fromRGB(250, 60, 100)
	end
 
 
	if abil.Info.LvlHolder.Box.LvlHolder.Box.Fill.BackgroundColor3 == Color3.fromRGB(19, 157, 255) then
		abil.Info.LvlHolder.Box.LvlHolder.Box.Fill.BackgroundColor3 = DragonColor
	end
	-- Hact Names
	if main.HeatMove.TextLabel.Text == "Guru Spin Counter [Front]" then
		main.HeatMove.TextLabel.Text = "Komaki Fist Reversal [Front]"
	elseif main.HeatMove.TextLabel.Text == "Guru Spin Counter [Left]" then
		main.HeatMove.TextLabel.Text = "Komaki Fist Reversal [Left]"
	elseif main.HeatMove.TextLabel.Text == "Guru Spin Counter [Right]" then
		main.HeatMove.TextLabel.Text = "Komaki Fist Reversal [Right]"
	elseif main.HeatMove.TextLabel.Text == "Guru Spin Counter [Back]" then
		main.HeatMove.TextLabel.Text = "Komaki Fist Reversal [Back]"
	elseif main.HeatMove.TextLabel.Text == "Essence of Fisticuffs" then
		main.HeatMove.TextLabel.Text = "Essence of Pummeling"
	elseif main.HeatMove.TextLabel.Text == "Guru Firearm Flip" then
		main.HeatMove.TextLabel.Text = "Komaki Shot Stopper"
	end
 
	if plr.Character:FindFirstChild("Heated") then
		if not plr.Character.Heated:FindFirstChild("HeatedBy") then
			main.HeatMove.ImageColor3 = Color3.fromRGB(255, 255, 255)
			main.HeatMove.TextLabel.TextColor3 = Color3.fromRGB(70, 250, 250)
		else
			main.HeatMove.ImageColor3 = Color3.fromRGB(255, 0, 0)
			main.HeatMove.TextLabel.TextColor3 = Color3.fromRGB(250, 73, 73)
		end
	end
 
	-- Move Descriptions
	abilFolder["Ultimate Essence"].Description.Value = "The Legend's ultimate attack. Unleash the might of the Red Dragon to crush any opponent."
	abilFolder["Ultimate Essence"].Prompt.Value = "HEAVY ATTACK near stunned enemies via Komaki Parry with Full Heat"
	abilFolder["Time for Resolve"].Description.Value = "Unleash the willpower of the Legendary Red Dragon to fly above the rest and withstand any attacks that would stagger or knock you down."
 
	abilFolder["Guru Parry"].Description.Value = "One of the Three Ultimate Komaki style moves. Stuns the enemy."
	abilFolder["Counter Hook"].Description.Value = "One of the Three Ultimate Komaki style moves. The style's strongest counter-attack."
	abilFolder["Guru Knockback"].Description.Value = "One of the Three Ultimate Komaki style moves. Send an enemy's attack right back at them."
 
	-- Move Names & Requirements
	for i,z in pairs(abil.List.ListFrame:GetChildren()) do
 
		if z:IsA("ImageButton") then
 
			if z:FindFirstChild("sty").Value == "Brawler" and z:FindFirstChild("MyColor").Value == Color3.fromRGB(19, 157, 255) then
				z.MyColor.Value = DragonColor
				z.Generic.Label.TextColor3 = DragonColor
				if z.Name == "Counter Hook" then
					z.Generic.Label.Text = "Komaki Tiger Drop (Lvl. 25)"
				elseif z.Name == "Guru Knockback" then
					z.Generic.Label.Text = "Komaki Knock Back"
				elseif z.Name == "Ultimate Essence" then
					if string.sub(z.Lock.Title.Text, 1, 10) ~= "Need to be" then
						z.Lock.Title.Text = "Need to unlock Komaki Parry"
					end
				elseif z.Name == "Guru Parry" then
					z.Generic.Label.Text = "Komaki Parry (Lvl. 20)"
					if string.sub(z.Lock.Title.Text, 1, 10) ~= "Need to be" then
						z.Lock.Title.Text = "Need to unlock Finishing Hold"
					end
				elseif z.Name == "Guru Spin Counter" then
					z.Generic.Label.Text = "Komaki Fist Reversal"
				elseif z.Name == "Guru Firearm Flip" then
					z.Generic.Label.Text = "Komaki Shot Stopper"
				elseif z.Name == "Guru Dodge Shot" then
					z.Generic.Label.Text = "Komaki Evade & Strike"
					if string.sub(z.Lock.Title.Text, 1, 10) ~= "Need to be" then
						z.Lock.Title.Text = "Need to unlock Komaki Knock Back"
					end
				elseif z.Name == "Guru Safety Roll" then
					z.Generic.Label.Text = "Komaki Dharma Tumbler"
				elseif z.Name == "Essence of Fisticuffs" then
					z.Generic.Label.Text = "Essence of Knockdown"
				elseif z.Name == "Time for Resolve" then
					z.Generic.Label.Text = "Red Dragon Spirit (Lvl. 20)"
				end
			end
		end
	end
 
end
 
local function UpdateStyleOnce()
	if not hasUpdatedOnce then
		hasUpdatedOnce = true
		sendNotification("setting style...", Color3.fromRGB(255, 255, 255))
	end
	DragonSequence = ColorSequence.new({ColorSequenceKeypoint.new(0, DragonColor), ColorSequenceKeypoint.new(1, DragonColor)})
	status.Stats.Kills_Brawler.Visual.Value = "Enemies defeated using " .. DragonText
 
	abil.Tabs.Tabs.Brawler.Filled.Title.Text = DragonText
 
	local function updateEncounterTitle()
		if interf.BattleStart.Text == "LEGENDARY DRAGON" then
			interf.BattleStart.Text = "THE TRUE DRAGON"
		elseif interf.BattleStart.Text == "MYSTERIOUS MERCS" then
			interf.BattleStart.Text = "MEN IN BLACK"
		elseif interf.BattleStart.Text == "DELINQUENTS" then
			local r = math.random(1, 3)
			interf.BattleStart.Text = r == 1 and "STREET RUFFIANS" or r == 2 and "STREET PUNKS" or "DELINQUENTS"
		elseif interf.BattleStart.Text == "RICH FIEND" then
			interf.BattleStart.Text = "NOUVEAU RICHE"
		elseif interf.BattleStart.Text == "DEVIOUS DAN" then
			interf.BattleStart.Text = "AVERAGE AMERICAN"
		elseif interf.BattleStart.Text == "JEFF ATTACK" then
			interf.BattleStart.Text = "BLUE BELTS"
		elseif interf.BattleStart.Text == "GORILLAMAN" then
			local r = math.random(1, 2)
			interf.BattleStart.Text = r == 1 and "COSPLAYERS" or "APE ARMY"
		elseif interf.BattleStart.Text == "HUE" then
			interf.BattleStart.Text = "COPYCAT"
		elseif interf.BattleStart.Text == "BLOODSUCKER" then
			local r = math.random(1, 4)
			interf.BattleStart.Text = r == 1 and "MENACING MAN" or r == 2 and "VAMPIRE" or r == 3 and "BUFF GUY" or "SUCKER" 
		end
	end
 
	if connections.BattleStart == nil then
		connections.BattleStart = interf.BattleStart.Changed:Connect(function()
			updateEncounterTitle()
		end)
	end	
 
	if kiwamiParticle == nil then
		kiwamiParticle = plr.Character.Head.FS:Clone()
		kiwamiParticle.Rate = 500
		kiwamiParticle.Enabled = false
		kiwamiParticle.Parent = game.ReplicatedStorage
		kiwamiParticle.Name = "KiwamiParticles"
	end
	if connections.PunchTrail == nil then -- punch trail colors properly to legend style color
		connections.PunchTrail = game.Players.LocalPlayer.Character.DescendantAdded:Connect(function(child)
			if child:IsA("Trail") and status.Style.Value == "Brawler" then
				coroutine.wrap(function()
					while child do
						child.Color = DragonSequence
						game:GetService("RunService").RenderStepped:Wait()
					end
				end)()
			end
		end)
	end
 
	if fill3 == nil and not main.Heat:FindFirstChild("Fill3") then
		fill3 = main.Heat.Fill2:Clone()
		fill3.Parent = main.Heat
		fill3.Name = "Fill3"
		fill3.Visible = false
		fill3.ImageColor3 = Color3.fromRGB(255, 255, 255)
		fill3.ImageTransparency = 1
		coroutine.wrap(function()
			main.Heat.Fill2.Changed:Connect(function()
				fill3.Size = main.Heat.Fill2.Size
			end)
 
			while true do
				repeat game:GetService("RunService").RenderStepped:Wait() until plr.Character:FindFirstChild("Heated") and not plr.Character.Heated:FindFirstChild("Throwing") and plr.Character.Heated:FindFirstChild("Heating") and plr.Character.Heated.Heating.Value ~= plr.Character
				fill3.ImageColor3 = Color3.fromRGB(0, 200, 0)		
				repeat game:GetService("RunService").RenderStepped:Wait() until not plr.Character:FindFirstChild("Heated")
				fill3.ImageColor3 = Color3.fromRGB(255, 255, 255)
			end
		end)()
		local tween = game:GetService("TweenService"):Create(fill3, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, math.huge, true, 0), {ImageTransparency = 0.4})
		tween:Play()
		local function updateFill()
			fill3.Visible = status.Heat.Value >= 50 and true or false
		end
		status.Heat.Changed:Connect(function()
			updateFill()
		end)
		updateFill()
	end
	if climaxfill3 == nil and not main.Heat:FindFirstChild("ClimaxFill3") then
		climaxfill3 = main.Heat.ClimaxFill2:Clone()
		climaxfill3.Parent = main.Heat
		climaxfill3.Name = "ClimaxFill3"
		climaxfill3.Visible = false
		climaxfill3.ImageColor3 = Color3.fromRGB(255, 255, 255)
		climaxfill3.ImageTransparency = 1
		coroutine.wrap(function()
			main.Heat.ClimaxFill2.Changed:Connect(function()
				climaxfill3.Size = main.Heat.ClimaxFill2.Size
			end)
 
			while true do
				repeat game:GetService("RunService").RenderStepped:Wait() until plr.Character:FindFirstChild("Heated") and not plr.Character.Heated:FindFirstChild("Throwing") and plr.Character.Heated:FindFirstChild("Heating") and plr.Character.Heated.Heating.Value ~= plr.Character
				climaxfill3.ImageColor3 = Color3.fromRGB(0, 200, 0)				
				repeat game:GetService("RunService").RenderStepped:Wait() until not plr.Character:FindFirstChild("Heated")
				climaxfill3.ImageColor3 = Color3.fromRGB(255, 255, 255)
			end
		end)()
		local tween = game:GetService("TweenService"):Create(climaxfill3, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, math.huge, true, 0), {ImageTransparency = 0.4})
		tween:Play()
		local function updateFill()
			climaxfill3.Visible = status.Heat.Value >= 100 and true or false
		end
		status.Heat.Changed:Connect(function()
			updateFill()
		end)
		updateFill()
	end
 
	if not fillPreview and not main.Heat:FindFirstChild("FillPreview") then
		fillPreview = main.Heat.Fill2:Clone()
		fillPreview.Parent = main.Heat
		fillPreview.Name = "FillPreview"
		fillPreview.Visible = false
		fillPreview.ImageColor3 = Color3.fromRGB(255, 0, 0)
		fillPreview.ImageTransparency = 0
	end
 
	if not climaxPreview and not main.Heat:FindFirstChild("ClimaxPreview") then
		climaxPreview = main.Heat.ClimaxFill2:Clone()
		climaxPreview.Parent = main.Heat
		climaxPreview.Name = "ClimaxPreview"
		climaxPreview.Visible = false
		climaxPreview.ImageColor3 = Color3.fromRGB(255, 0, 0)
		climaxPreview.ImageTransparency = 0
	end
 
	if not animsChanged then
		animsChanged = true
 
		game.ReplicatedStorage.Styles.Brawler.Idle.AnimationId = "rbxassetid://12120045620"
 
		local current;
		--finishing blows
		current = moves["BStomp"]
		current.Anim.AnimationId = "rbxassetid://7546695030"
 
		current = moves["BStrike1"]
		current.Anim.AnimationId = "rbxassetid://8216285224"
		changeValueStrict(current, "EndAt", 0.75, "NumberValue")
		changeValueStrict(current, "HitDur", 0.6, "NumberValue")
		changeValueStrict(current, "HitboxLocations", '[["RightFoot",3,[0,0,0]],["RightLowerLeg",2.25,[0,0,0]],["RightUpperLeg",1.5,[0,0,0]]]', "StringValue")
 
		current = moves["BStrike5"]
		current.Anim.AnimationId = "rbxassetid://7546691847"
		changeValueStrict(current, "MoveDuration", 0.3, "NumberValue")
		changeValueStrict(current, "ComboAt", 0.6, "NumberValue")
		changeValueStrict(current, "HSize", 1.3, "NumberValue")
		changeValueStrict(current, "HitboxLocations", '[["RightFoot",1.5,[0,0,0]],["RightLowerLeg",0.75,[0,0,0]],["RightUpperLeg",0.5,[0,0,0]]]', "StringValue")
 
		-- x2 finishing blows
		moves["B2Strike4"].Name = "Fake2Strike4"
		moves["龍2Strike4"].Name = "B2Strike4"
 
		current = moves["B2Strike2"]
		current.Anim.AnimationId = "rbxassetid://11955435829"
		changeValueStrict(current, "HSize", 0.75, "NumberValue")
		changeValueStrict(current, "HSound", "hardkick", "StringValue")
		changeValueStrict(current, "HitDur", 0.2, "NumberValue")
		changeValueStrict(current, "MoveDuration", 0.3, "NumberValue")
		changeValueStrict(current, "RagdollBonus", 1.25, "NumberValue")
		changeValueStrict(current, "HitboxLocations", '[["LeftFoot",1,[0,0,-0.5]],["LeftLowerLeg",2,[0,0,-0.5]],["LeftUpperLeg",2,[0,0,-0.5]]]', "StringValue")
 
		current = moves["B2Strike3"]
		current.Anim.AnimationId = "rbxassetid://11809009022"
		changeValueStrict(current, "HitDur", 0.2, "NumberValue")
		changeValueStrict(current, "MoveDuration", 0.3, "NumberValue")
		changeValueStrict(current, "AniSpeed", 0.75, "NumberValue")
		changeValueStrict(current, "HSize", 0.75, "NumberValue")
		changeValueStrict(current, "RagdollBonus", 1.25, "NumberValue")
		changeValueStrict(current, "HorizKnockback", 0, "NumberValue")
		changeValueStrict(current, "HitboxLocations", '[["LeftHand",2,[0,0,0]],["RightHand",2,[0,0,0]]]', "StringValue")
 
		current = moves["B2Strike1"]
		current.Anim.AnimationId = "rbxassetid://11826216628"
		changeValueStrict(current, "HitDur", 0.2, "NumberValue")
		changeValueStrict(current, "MoveDuration", 0.5, "NumberValue")
		changeValueStrict(current, "AniSpeed", 1, "NumberValue")
		changeValueStrict(current, "HSize", 0.75, "NumberValue")
		changeValueStrict(current, "RagdollBonus", 1.25, "NumberValue")
		changeValueStrict(current, "HorizKnockback", 0.25, "NumberValue")
		changeValueStrict(current, "Reaction", "Uppercut", "StringValue")
		changeValueStrict(current, "HitboxLocations", '[["RightHand",2,[0,0,0]],["RightLowerArm",1.5,[0,0,0]],["RightUpperArm",1,[0,0,0]]]', "StringValue")
 
		-- rush combo
		moves["BAttack1"].Name = "FakeAttack1"
		moves["龍Attack1"].Name = "BAttack1"
		changeValueStrict(moves["BAttack1"], "ComboAt", 0.35, "NumberValue")
 
		moves["BAttack2"].Name = "FakeAttack2"
		moves["龍Attack2"].Name = "BAttack2"
		changeValueStrict(moves["BAttack2"], "ComboAt", 0.35, "NumberValue")
 
		moves["BAttack3"].Name = "FakeAttack3"
		moves["龍Attack3"].Name = "BAttack3"
		changeValueStrict(moves["BAttack3"], "ComboAt", 0.35, "NumberValue")
 
		moves["BAttack4"].Name = "FakeAttack4"
		moves["龍Attack4"].Name = "BAttack4"
		changeValueStrict(moves["BAttack4"], "ComboAt", 0.35, "NumberValue")
	end
 
	main.Heat.noheattho.Text = "Heat Actions Disabled"
	main.Heat.noheattho.Size = UDim2.new(10, 0, 1, 0)
 
	menu.Bars.Mobile_Title.Text = "Refurbished Dragon of steel by MisterMax228"
	menu.Bars.Mobile_Title.Visible = true

	
end
game:GetService("RunService").RenderStepped:Connect(function()
	UpdateStyle()
end)
 
game.UserInputService.InputBegan:Connect(function(key)
	if game.UserInputService:GetFocusedTextBox() == nil then
		if key.KeyCode == Enum.KeyCode.ButtonR3 then
			if DragonText == "Dragon" then
				DragonText = "Legend"
				DragonColor = Color3.new(1,1,1)
				sendNotification("Legend", DragonColor)
			elseif DragonText == "Legend" then
				DragonText = "Dragon"
				DragonColor = Color3.new(1,0,0)
				sendNotification("Dragon of steel", DragonColor)
			end
			UpdateStyleOnce()
		end
	end
end)
 
coroutine.wrap(function()
	while true do
		UpdateStyleOnce()
		task.wait(5) -- update everything every 5 seconds (optimization)
	end
end)()
 
status.Resets.Changed:Connect(function()
	sendNotification("you are now prestige [" .. status.Resets.Value .. "]", Color3.fromRGB(0, 200, 0))
end)
 
status.Level.Changed:Connect(function()
	if status.Level.Value % 5 == 0 then
		sendNotification("you are now level [" .. status.Level.Value .. "]", Color3.fromRGB(0, 200, 0))
	end
end)
 
status.Stats.Deaths.Changed:Connect(function()
	sendNotification("deaths total: [" .. status.Stats.Deaths.Value .. "]", Color3.fromRGB(200, 0, 0))
end)
 
status.Stats.Kills_Brawler.Changed:Connect(function()
	if status.Stats.Kills_Brawler.Value % 50 == 0 then
		sendNotification("enemies defeated in " .. DragonText .. " style: [" .. status.Stats.Kills_Brawler.Value .. "]", Color3.fromRGB(0, 200, 0))
	end
end)
 
status.Stats.Kills_Beast.Changed:Connect(function()
	if status.Stats.Kills_Beast.Value % 50 == 0 then
		sendNotification("enemies defeated in Brute style: [" .. status.Stats.Kills_Beast.Value .. "]", Color3.fromRGB(0, 200, 0))
	end
end)
 
status.Stats.Kills_Rush.Changed:Connect(function()
	if status.Stats.Kills_Rush.Value % 50 == 0 then
		sendNotification("enemies defeated in Frenzy style: [" .. status.Stats.Kills_Rush.Value .. "]", Color3.fromRGB(0, 200, 0))
	end
end)
 
status.Stats.Kills.Changed:Connect(function()
	if status.Stats.Kills.Value % 50 == 0 then
		sendNotification("enemies defeated total: [" .. status.Stats.Kills.Value .. "]", Color3.fromRGB(0, 200, 0))
	end
end)
 
status.AttackBegan.Changed:Connect(function()
	if status.AttackBegan.Value == true then
		if status.CurrentMove.Value.Name == "TigerDrop" then
			tigerDropsSession += 1
			if tigerDropsSession % 10 == 0 then
				sendNotification("Tiger Drops (this session): [" .. tigerDropsSession .. "]", Color3.fromRGB(0, 200, 0))
				if tigerDropsSession == 100 then
					sendNotification("DAAAAAAAAAAAMN")
				end
			end
		end
	end
end)
local styles = game.ReplicatedStorage.Styles
if hasReloaded == false then
		hasReloaded = true
		game.ReplicatedStorage.Moves.TigerDrop.Anim.AnimationId = "rbxassetid://12120052426"
		local cframe = plr.Character.HumanoidRootPart.CFrame
		sendNotification("reloading character...")
		interf.Client.Disabled = true
		task.wait()
		interf.Client.Disabled = false
		plr.Character.HumanoidRootPart.CFrame = cframe
    game.ReplicatedStorage.Moves.TigerDrop.Anim.AnimationId = moves[styles.Brawler.Rush2.Value].Anim.AnimationId
end

sendNotification("Mod loaded", Color3.fromRGB(0, 200, 0))
task.wait(3)
sendNotification("Press [R3] to switch between legend/dragon styles", Color3.fromRGB(255, 255, 255))

