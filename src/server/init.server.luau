local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local C = require(ReplicatedStorage.Shared.Config)
local createPunchAnimation = require(script.PunchAnimation)
local world = workspace:WaitForChild("SimulatorWorld")
local action = Instance.new("RemoteEvent", ReplicatedStorage)
action.Name = "SimulatorAction"
local feedback = Instance.new("RemoteEvent", ReplicatedStorage)
feedback.Name = "SimulatorFeedback"
local data = {}
local rng = Random.new()

local function tell(p, text) feedback:FireClient(p, text) end
local function stat(p, name) return p.leaderstats[name] end
local function refresh(p)
 local d = data[p]
 local count = 0
 for _, n in pairs(d.bag) do count += n end
 p:SetAttribute("BrainrotsCarried", count)
 p:SetAttribute("EquippedGlove", C.Gloves[d.glove].name)
 p:SetAttribute("PunchAreaLevel", d.area)
end
local function loot(p, position)
 local roll = rng:NextInteger(1,100)
 if roll <= C.LootChances.none then return end
 local rarity = if roll <= 85 then "Common" elseif roll <= 97 then "Uncommon" else "Rare"
 local choices = {}
 for i, item in ipairs(C.Brainrots) do if item.rarity == rarity then table.insert(choices,i) end end
 local i = choices[rng:NextInteger(1,#choices)]
 local marker = Instance.new("Part")
 marker.Name = C.Brainrots[i].name
 marker.Shape = Enum.PartType.Ball
 marker.Size = Vector3.new(1.5,1.5,1.5)
 marker.Position = position
 marker.Anchored = true
 marker.CanCollide = false
 marker.CanQuery = false
 marker.Material = Enum.Material.Neon
 marker.Color = if rarity == "Rare" then Color3.fromRGB(255,200,40) elseif rarity == "Uncommon" then Color3.fromRGB(145,90,255) else Color3.fromRGB(80,230,130)
 marker.Parent = world
 game:GetService("Debris"):AddItem(marker,2)
 local d = data[p]
 d.bag[i] = (d.bag[i] or 0) + 1
 refresh(p)
 tell(p, "You found "..C.Brainrots[i].name.."! Value: $"..C.Brainrots[i].value)
end
local blocks=require(script.BlockService)(world,loot)
local function punch(p,target)
 local d = data[p]
 local char = p.Character
 local root = char and char:FindFirstChild("HumanoidRootPart")
 if not d or not root or not char:FindFirstChild("Punch") then return end
 if not char:FindFirstChildOfClass("Humanoid") or char.Humanoid.Health <= 0 then return end
 if os.clock()-d.lastPunch < 0.4 then return end
 d.lastPunch = os.clock()
 d.animation.play(0.34)
 if blocks.InLobby(root.Position) then tell(p,"Leave the lobby to break blocks"); return end
 target=blocks.Target(char,target)
 if not target then tell(p,"Walk up to a wall and punch a block"); return end
 local radius = C.Areas[d.area].radius
 local amount = math.max(1,math.floor(stat(p,"Strength").Value/5))
 blocks.Hit(p,target,amount,radius)
 if target:GetAttribute("HP") > 0 then tell(p,"Block "..target:GetAttribute("HP").."/"..target:GetAttribute("MaxHP").." HP") end
end
local function booth(p,name)
 local d = data[p]
 if not d then return end
 local cash = stat(p,"Cash")
 if name == "SELL" then
  local total,count = 0,0
  for i,n in pairs(d.bag) do total += C.Brainrots[i].value*n; count += n end
  total = math.floor(total*(1+stat(p,"Rebirths").Value*C.CashBonusPerRebirth))
  cash.Value += total
  d.bag = {}
  refresh(p)
  tell(p,"Sold "..count.." Brainrots for $"..total)
 elseif name == "GLOVE SHOP" then
  for i = 2,#C.Gloves do
   local glove = C.Gloves[i]
   if d.owned[i] and i > d.glove then d.glove=i; refresh(p); tell(p,"Equipped "..glove.name); return end
   if not d.owned[i] then
    if cash.Value < glove.cost then tell(p,glove.name.." costs $"..glove.cost); return end
    cash.Value -= glove.cost; d.owned[i]=true; d.glove=i; refresh(p); tell(p,"Bought "..glove.name); return
   end
  end
  tell(p,"All gloves owned")
 elseif name == "PUNCH AREA UPGRADE" then
  local next = d.area+1
  if not C.Areas[next] then tell(p,"Punch Area is max level"); return end
  local cost = C.Areas[next].cost
  if cash.Value < cost then tell(p,"Punch Area costs $"..cost); return end
  cash.Value -= cost; d.area=next; refresh(p); tell(p,"Punch Area level "..next)
 elseif name == "REBIRTH" then
  if cash.Value < C.RebirthCash then tell(p,"Rebirth needs $"..C.RebirthCash); return end
  stat(p,"Strength").Value=0; cash.Value=0; stat(p,"Rebirths").Value += 1
  d.owned={[1]=true}; d.glove=1; d.area=1; refresh(p)
  tell(p,"Rebirth! Cash x"..(1+stat(p,"Rebirths").Value*C.CashBonusPerRebirth))
 end
end
for _, prompt in ipairs(world.Stalls:GetDescendants()) do
 if prompt:IsA("ProximityPrompt") and prompt.Parent:GetAttribute("BoothAction") then
  prompt.Triggered:Connect(function(p)
   local root=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
   local humanoid=p.Character and p.Character:FindFirstChildOfClass("Humanoid")
   local d=data[p]
   if not d or not root or not humanoid or humanoid.Health<=0 then return end
   if (root.Position-prompt.Parent.Position).Magnitude>prompt.MaxActivationDistance+2 then return end
   if os.clock()-(d.lastBooth or 0)<0.5 then return end
   d.lastBooth=os.clock()
   booth(p,prompt.Parent:GetAttribute("BoothAction"))
  end)
 end
end
Players.PlayerAdded:Connect(function(p)
 local leaderstats = Instance.new("Folder",p); leaderstats.Name="leaderstats"
 for _, name in ipairs({"Strength","Cash","Rebirths"}) do local v=Instance.new("IntValue",leaderstats); v.Name=name end
 data[p]={bag={},owned={[1]=true},glove=1,area=1,lastPunch=0,training=false,trainingRun=0,inLobby=true,lastRebirth=0}
 refresh(p)
 local function setup()
  local d=data[p]
  if not d then return end
  blocks.Reset(p)
  d.inLobby=true
  d.training=false
  d.trainingRun += 1
  if d.animation then d.animation.stop() end
  local character = p.Character
  local humanoid = character:WaitForChild("Humanoid")
  local animation = createPunchAnimation(character)
  d.animation = animation
  humanoid.Died:Connect(function()
   d.training=false
   d.trainingRun += 1
   animation.stop()
  end)
  local backpack=p:WaitForChild("Backpack")
  local punchTool=Instance.new("Tool",backpack); punchTool.Name="Punch"; punchTool.RequiresHandle=false; punchTool.CanBeDropped=false
  local train=Instance.new("Tool",backpack); train.Name="Shadowboxing"; train.RequiresHandle=false; train.CanBeDropped=false
  punchTool.Unequipped:Connect(animation.stop)
  train.Equipped:Connect(function()
   d.training=true
   d.trainingRun += 1
   local run = d.trainingRun
   task.spawn(function()
    while d.training and d.trainingRun==run and p.Parent and train.Parent==character and humanoid.Health > 0 do
     local interval = math.max(C.MinimumTrainingInterval,C.TrainingInterval-stat(p,"Rebirths").Value*C.TrainingSpeedPerRebirth)
     animation.play(math.min(0.4,interval * 0.85))
     local gain = C.Gloves[d.glove].gain
     stat(p,"Strength").Value += gain
     feedback:FireClient(p,gain)
     task.wait(interval)
    end
   end)
  end)
  train.Unequipped:Connect(function() d.training=false; d.trainingRun += 1; animation.stop() end)
 end
 p.CharacterAdded:Connect(setup)
 if p.Character then setup() end
end)
Players.PlayerRemoving:Connect(function(p) blocks.Reset(p); data[p]=nil end)
action.OnServerEvent:Connect(function(p,kind,target)
 if kind=="Punch" then punch(p,target)
 elseif kind=="Rebirth" then
  local d=data[p]
  local humanoid=p.Character and p.Character:FindFirstChildOfClass("Humanoid")
  if not d or not humanoid or humanoid.Health<=0 or os.clock()-d.lastRebirth<1 then return end
  d.lastRebirth=os.clock()
  booth(p,"REBIRTH")
 end
end)
task.spawn(function()
 while true do
  for p,d in pairs(data) do
   local root=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
   if root then
    local inside=blocks.InLobby(root.Position)
    if inside and not d.inLobby then
     local count=blocks.Reset(p)
     if count>0 then tell(p,"Welcome back! "..count.." blocks refreshed") end
    end
    d.inLobby=inside
   end
  end
  blocks.RestorePending()
  task.wait(0.25)
 end
end)
