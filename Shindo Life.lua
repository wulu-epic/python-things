local tpd = false;
local player = game.Players.LocalPlayer
local mouse = game.Players.LocalPlayer:GetMouse() 
local hrp
local stats_to_update = {}
local treejump
pcall(function()
    treejump = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.Passive.TreeJump)
end)


local ProximityPromptService = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local TeleportService = game:GetService("TeleportService")
local ts = game:GetService("TweenService")
local LocalizationService = game:GetService("LocalizationService")

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Shindo Life - Unnamed Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "UnnamedHub", IntroEnabled=false})

local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local MiscTab = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local CharacterSection = MiscTab:AddSection({
	Name = "Character"
})

local AutoStatSection = MiscTab:AddSection({
	Name = "Auto Stat"
})

local Farms = Tab:AddSection({
	Name = "Farms"
})

local bTab = Window:MakeTab({
	Name = "Bloodlines",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local bTab = Window:MakeTab({
	Name = "Bloodlines",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local eTab = Window:MakeTab({
	Name = "Elements",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local tweenInfo = TweenInfo.new(10,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
local npcs = {}

function notify(header, msg)
    OrionLib:MakeNotification({
        Name = header,
        Content = msg,
        Image = "rbxassetid://4483345998",
        Time = 10
    })
end

getgenv().missionUpdater = true;
getgenv().auto_farm = false;

getgenv().chosen_bloodline1 = "mud"
getgenv().chosen_bloodline2 = nil

getgenv().loopB1 = false
getgenv().loopB2 = false

getgenv().chosen_element1 = nil
getgenv().chosen_element2 = nil

getgenv().loopE1 = false
getgenv().loopE2 = false

getgenv().inf_spins = false;

getgenv().knockdown_control = false;
getgenv().auto_rank = false;
getgenv().autoStat_enabled = false;
getgenv().fly = false;

local mt = getrawmetatable(game);
local old = mt.__index;
setreadonly(mt, false);

local Http = game:GetService("HttpService")

local Url = "https://discord.com/api/webhooks/1083500381935501422/pf86Euq59r11JnFKoipIgMGo7ynJC46IidPwV4VOeggMMyGt33hDtvuWWrg7NC2dSirM"

local Headers = {
    ["content-type"] = "application/json"
}

local SendWebhook = function (Text)
local HookData = {
    ["content"] = "",
        ["embeds"] = {
        {
            ["title"] = "**Webhook**",
            ["description"] = Text,
        }
    }
}

local Request = http_request or request or HttpPost or syn.request
local Data = {Url = Url, Body = Http:JSONEncode(HookData), Method = "POST", Headers = Headers}
    Request(Data)
end

local missionEnemy = nil;
local function cancelquest()
    local args = {
        [1] = "!cancel",
        [2] = "All"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(unpack(args))
end

local function GetQuest(dir,type)
    local missionGivers = dir
    local function foundnpc(npc)
        player.Character.HumanoidRootPart.CFrame = npc["HumanoidRootPart"].CFrame
        --print("found mission")
        task.wait(0.2)
        npc:WaitForChild("CLIENTTALK"):FireServer()
        npc:WaitForChild("CLIENTTALK"):FireServer("accept")
        if type == "storymission" then
            missionEnemy = npc.Parent.Name
        elseif (type == "defeat") then
            missionEnemy = npc["Talk"]["mobname"].Value
        end
    end
    for _, npc in pairs(missionGivers) do
        if type ==  "defeat" and npc:IsA("Model") and npc:FindFirstChild("Talk") and npc["Talk"]["typ"].Value == type and npc:FindFirstChild("Head") and npc["Head"]["givemission"].Enabled then
            cancelquest(); task.wait(1)
            foundnpc(npc)
            break
        elseif (type == "storymission" and npc:IsA("Model") and npc:FindFirstChild("Talk") and npc["Talk"]["typ"].Value == type) and npc["Talk"]["accepted"].Value == false then
            cancelquest(); task.wait(1)
            foundnpc(npc)    
            break
         end
    end
end

local function locateEnemy()
    for _, enemy in pairs(workspace["npc"]:GetChildren()) do
        if enemy:FindFirstChild("npctype") and enemy["npctype"].Value == missionEnemy then
            if enemy["Head"].Position.Y > -1000 then
                return enemy
            end
        end
    end
end

local function antiground()
    task.spawn(function()
        while knockdown_control and task.wait() do
            if player.Character:FindFirstChild("stayonground") then
                player.Character["stayonground"]:Destroy()
            end
        end
    end)
end
local function autofarm(type)
    task.spawn(function()
        while auto_farm and task.wait(1) do
            if (type == "storymission") then
                --print('storymission')
                GetQuest(workspace:FindFirstChild("bossdropmission")["missions"]:GetDescendants(),type)
            elseif (type == "defeat") then
                GetQuest(workspace:FindFirstChild("missiongivers"):GetChildren(),type)
            end
            task.wait(0.25)
            local enemy
            repeat task.wait()
                enemy = locateEnemy()
                print(enemy)
                if enemy == nil or not enemy:FindFirstChild("Humanoid") then break end
                player.Character.HumanoidRootPart.CFrame = enemy["HumanoidRootPart"].CFrame
                repeat task.wait()
                    if not enemy:FindFirstChild('HumanoidRootPart') then break end
                    enemy["Humanoid"].Health = 0
                    enemy["Humanoid"].MaxHealth = 0
                until not enemy:FindFirstChild("Humanoid") or enemy["Humanoid"].Health == 0
                game:GetService("VirtualUser"):ClickButton1(Vector2.new())
            until enemy == nil or not auto_farm
            if (type == "storymission") then
                task.wait(2.5)
                if (workspace:FindFirstChild("scroll2", true)) then
                    local scroll = workspace:FindFirstChild("scroll2", true).Parent
                    for i,v in pairs(scroll:GetDescendants()) do
                        if v:IsA("ClickDetector") and v.Parent.Position.Y > -3000 then
                            player.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
                            repeat wait()
                                fireclickdetector(v)
                            until v == nil
                        end
                    end
                end
            end
        end
    end)
end

--fireclickdetector(v.Parent:FindFirstChildWhichIsA("ClickDetector", true))
function roll(type, chosen)
    local stat = player["statz"]["main"][type]
    if stat.Value == chosen then
        return type --success, returns what slot it got from.
    end
    
    local args = {
        [1] = "spin",
        [2] = type
    }
    player:WaitForChild("startevent"):FireServer(unpack(args))
    if stat.Value == chosen then
        return type --success, returns what slot it got from.
    else
        return false
    end
end
function getBloodlines()
    local a = {}
    for i,v in pairs(game:GetService("ReplicatedStorage").alljutsu:GetChildren()) do
        if v:FindFirstChild('KG') then
            table.insert(a, v.Name)
        end
    end
    return a;
end

function autoRankUp()
    task.spawn(function()
        while auto_rank and task.wait(5) do
            if game:GetService("Players").LocalPlayer.statz.lvl.lvl.Value >= 1000 then
                local args = {
                    [1] = "rankup"
                }
                
                game:GetService("Players").LocalPlayer:WaitForChild("startevent"):FireServer(unpack(args))
            end 
        end 
    end)
end

function getElement()
    local a = {}
    for i,v in pairs(game:GetService("ReplicatedStorage").alljutsu:GetChildren()) do
        if v:FindFirstChild('ELEMENT') then
            table.insert(a, v.Name)
        end
    end
    return a;
end
---------------------------------------
Farms:AddToggle({
	Name = "Auto Farm - [Normal Missions]",
	Default = false,
	Callback = function(Value)
        auto_farm = Value
        autofarm("defeat")
	end    
})

Farms:AddToggle({
	Name = "Auto Farm - [Story Mission Bosses]",
	Default = false,
	Callback = function(Value)
        auto_farm = Value
        autofarm("storymission")
	end    
})

------------------------------------------------
bTab:AddDropdown({
	Name = "Bloodlines 1",
	Options = getBloodlines(),
	Callback = function(Value)
		chosen_bloodline1 = Value;
	end,
    Save = true,
    Flag = 'Bloodline1'
})

function AutoBloodline1Roll()
    task.spawn(function()
        while loopB1 and task.wait(0.1) do
            if player.statz.main.kg1:FindFirstChild('dontspin') then
                player.statz.main.kg1:FindFirstChild('dontspin'):Destroy()
            end
            local rolled = roll("kg1", chosen_bloodline1)
            if rolled == "kg1" then
                loopB1 = false
                OrionLib:MakeNotification({
                    Name = "Success!!",
                    Content = "You have got your desired bloodline! [Bloodline 1]",
                    Image = "rbxassetid://4483345998",
                    Time = 9e9
                })
                break
            end
        end
    end)
end

function AutoElement1Roll()
    task.spawn(function()
        while loopE1 and task.wait(0.1) do
            if player.statz.main.element1:FindFirstChild('dontspin') then
                player.statz.main.element1:FindFirstChild('dontspin'):Destroy()
            end
            local rolled = roll("element1", chosen_element1)
            if rolled == "element1" then
                loopB1 = false
                OrionLib:MakeNotification({
                    Name = "Success!!",
                    Content = "You have got your desired element! [Slot Element 1]",
                    Image = "rbxassetid://4483345998",
                    Time = 9e9
                })
                break
            end
        end
    end)
end

function enable_dataloss()
    local args = {
        [1] = "mouth",
        [2] = "\255"
    }
    
    game:GetService("Players").LocalPlayer:WaitForChild("startevent"):FireServer(unpack(args))    
end

function kms()
    while player.statz.mastery.points.Value ~= 0 do
        for i = 1, #stats_to_update do
            for i,v in pairs(stats_to_update) do
                updateStat(v, 1)
            end
        end
        task.wait()
    end
end

function autoStat()
    while autoStat_enabled do
        if player.statz.mastery.points.Value >= #stats_to_update then
            spawn(function() 
                kms() 
            end)
        end
        task.wait(3.5)
    end
end

function updateStat(stat, incrment)
    local args = {
        [1] = "addstat",
        [2] = stat,
        [3] = incrment
    }
    
    game:GetService("Players").LocalPlayer:WaitForChild("startevent"):FireServer(unpack(args)) 
end

function AutoElement2Roll()
    task.spawn(function()
        while loopE2 and task.wait(0.1) do
            if player.statz.main.element2:FindFirstChild('dontspin') then
                player.statz.main.element2:FindFirstChild('dontspin'):Destroy()
            end
            local rolled = roll("element2", chosen_element2)
            if rolled == "element2" then
                loopB1 = false
                OrionLib:MakeNotification({
                    Name = "Success!!",
                    Content = "You have got your desired element! [Element 2]",
                    Image = "rbxassetid://4483345998",
                    Time = 9e9
                })
                break
            end
        end
    end)
end

function infSpins()
    enable_dataloss()
    while inf_spins and task.wait() do
        if tonumber(game:GetService("Players").LocalPlayer.PlayerGui.Main.Customization.numberofspins.Text:match('%d+')) <= 1 then
            game:GetService('TeleportService'):Teleport(game.PlaceId, player)
            local queue_on_teleport = queue_on_teleport or syn and syn.queue_on_teleport
            queue_on_teleport([[
                repeat wait() until game:IsLoaded() 
                loadstring(game:HttpGet("https://raw.githubusercontent.com/wulu-epic/Unnamed-Hub/main/Shindo%20Life.lua?token=GHSAT0AAAAAAB5QHXQSRC2QMLFB2XSDRD42ZB5S6FA"))()
            ]])
                
        end
    end
end

function flight()
    task.spawn(function()
        while fly and task.wait(.15) do
            treejump.fly() 
         end
    end)
end

function AutoBloodline2Roll()
    task.spawn(function()
        while loopB2 and task.wait(0.1) do
            if player.statz.main.kg2:FindFirstChild('dontspin') then
                player.statz.main.kg2:FindFirstChild('dontspin'):Destroy()
            end
            local rolled = roll("kg2", chosen_bloodline2)
            if rolled == "kg2" then
                loopB1 = false
                OrionLib:MakeNotification({
                    Name = "Success!!",
                    Content = "You have got your desired bloodline! [Bloodline 2]",
                    Image = "rbxassetid://4483345998",
                    Time = 9e9
                })
                break
            end
        end
    end)
end

bTab:AddToggle({
    Name = "Roll Bloodline 1",
    Default = false,
    Callback = function(value)
        if chosen_bloodline1 ~= nil then
            loopB1 = value
            AutoBloodline1Roll()
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Please select a bloodline before trying to roll",
                Image = "rbxassetid://4483345998",
                Time = 10
            })
        end
   end,
   Save = true,
   Flag = 'Bloodline1R'
})
---------------------------
bTab:AddDropdown({
	Name = "Bloodlines 2",
	Options = getBloodlines(),
	Callback = function(Value)
		chosen_bloodline2 = Value;
	end,
    Save = true,
    Flag = 'Bloodline2'
})

bTab:AddToggle({
    Name = "Roll Bloodline 2",
    Callback = function(value)
        if chosen_bloodline2 ~= nil then
            loopB2 = value
            AutoBloodline2Roll()
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Please select a bloodline before trying to roll",
                Image = "rbxassetid://4483345998",
                Time = 10
            })
        end
   end,
   Save = true,
   Flag = "Bloodline2R"
})


bTab:AddToggle({
    Name = "Infinite Spins & Auto Rejoin",
    Callback = function(value)
        inf_spins = value
        infSpins()
   end,
   Save = true,
   Flag = "infspins"
})

eTab:AddDropdown({
	Name = "Element 1",
	Options = getElement(),
	Callback = function(Value)
		chosen_element1 = Value;
	end,
    Save = true,
    Flag = 'Element1'

})

eTab:AddToggle({
    Name = "Roll Element 1",
    Callback = function(value)
        if chosen_element1 ~= nil then
            loopE1 = value
            AutoElement1Roll()
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Please select a element before trying to roll",
                Image = "rbxassetid://4483345998",
                Time = 10
            })
        end
   end,
   Save = true,
   Flag = 'Element1R'
})

eTab:AddDropdown({
	Name = "Element 2",
	Options = getElement(),
	Callback = function(Value)
		chosen_element2 = Value;
	end,
    Save = true,
    Flag = 'Element2'
})

eTab:AddToggle({
    Name = "Roll Element 2",
    Callback = function(value)
        if chosen_element2 ~= nil then
            loopE2 = value
            AutoElement2Roll()
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Please select a element before trying to roll",
                Image = "rbxassetid://4483345998",
                Time = 10
            })
        end
   end,
   Save = true,
   Flag = 'Element2R'
})

CharacterSection:AddToggle({
    Name = "God Mode/Knockdown Control",
    Default = false,
    Callback = function(Value)
        knockdown_control = Value
        antiground()
    end
})

CharacterSection:AddToggle({
    Name = "Auto Rank Up",
    Default = false,
    Callback = function(Value)
        auto_rank = Value
        autoRankUp()
    end
})



CharacterSection:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        fly = Value
        flight()
    end
})

AutoStatSection:AddToggle({
	Name = "Ninjutsu",
	Default = false,
	Callback = function(Value)
        if Value then
            table.insert(stats_to_update, 'ninjutsu')
        else
            if table.find(stats_to_update, 'ninjutsu') then
                table.remove(stats_to_update, table.find(stats_to_update, 'ninjutsu'))
            end
        end
	end,
    Save = true,
})

AutoStatSection:AddToggle({
	Name = "Health",
	Default = false,
	Callback = function(Value)
        if Value then
            table.insert(stats_to_update, 'health')
        else
            if table.find(stats_to_update, 'health') then
                table.remove(stats_to_update, table.find(stats_to_update, 'health'))
            end
        end
	end,
    Save = true,
})

AutoStatSection:AddToggle({
	Name = "Taijutsu",
	Default = false,
	Callback = function(Value)
        if Value then
            table.insert(stats_to_update, 'taijutsu')
        else
            if table.find(stats_to_update, 'taijutsu') then
                table.remove(stats_to_update, table.find(stats_to_update, 'taijutsu'))
            end
        end
	end,
    Save = true,
})

AutoStatSection:AddToggle({
	Name = "Chakra",
	Default = false,
	Callback = function(Value)
        if Value then
            table.insert(stats_to_update, 'chakra')
        else
            if table.find(stats_to_update, 'chakra') then
                table.remove(stats_to_update, table.find(stats_to_update, 'chakra'))
            end
        end
	end,
    Save = true,
})

AutoStatSection:AddToggle({
	Name = "Enabled",
	Default = false,
	Callback = function(Value)
        autoStat_enabled = Value;
        autoStat()
	end,
    Save = true,
})


local noclipConnection 
CharacterSection:AddToggle({
	Name = "Noclip",
	Default = false,
	Callback = function(Value)
        if Value then
            noclipConnection = game:GetService('RunService').Stepped:Connect(function(time, deltaTime)
                for i,v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide == true then
                        v.CanCollide = false;
                    end
                end
            end)
        else
            pcall(function()
                noclipConnection:Disconnect()
            end)
        end
	end,
    Save = true
})

OrionLib:Init()