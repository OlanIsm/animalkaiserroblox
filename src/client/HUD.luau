local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local storage=game:GetService("ReplicatedStorage")
local Config=require(storage.Shared.Config)

return function(atlas)
 local gui = Instance.new("ScreenGui")
 gui.Name = "SimulatorHUD"
 gui.ResetOnSpawn = false
 gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 gui.Parent = player:WaitForChild("PlayerGui")
 local ink = Color3.fromRGB(24,29,43)
 local function label(parent,name,text,size,position,textSize)
  local l=Instance.new("TextLabel")
  l.Name=name; l.Text=text; l.Size=size; l.Position=position
  l.BackgroundTransparency=1; l.Font=Enum.Font.FredokaOne
  l.TextSize=textSize; l.TextColor3=Color3.new(1,1,1)
  l.TextStrokeColor3=ink; l.TextStrokeTransparency=0.15
  l.Parent=parent
  return l
 end
 local function panel(name,parent,size,position,color,className)
  local f=Instance.new(className or "Frame")
  f.Name=name; f.Size=size; f.Position=position; f.BackgroundColor3=color
  f.BorderSizePixel=0; f.Parent=parent
  local corner=Instance.new("UICorner",f); corner.CornerRadius=UDim.new(0,18)
  local stroke=Instance.new("UIStroke",f); stroke.Color=ink; stroke.Thickness=3
  local gradient=Instance.new("UIGradient",f)
  gradient.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromRGB(185,195,220))
  gradient.Rotation=90
  return f
 end
 local left=Instance.new("Frame",gui)
 left.Name="LeftCounters"; left.Size=UDim2.fromOffset(202,360)
 left.Position=UDim2.new(0,22,0.5,0); left.AnchorPoint=Vector2.new(0,0.5)
 left.BackgroundTransparency=1
 local scale=Instance.new("UIScale",left)
 local function counter(name,caption,y,color,offset)
  local frame=panel(name,left,UDim2.fromOffset(202,64),UDim2.fromOffset(0,y),color)
  local image=Instance.new("ImageLabel",frame)
  image.Name="Icon"; image.BackgroundTransparency=1
  image.Image=atlas; image.ImageRectOffset=offset; image.ImageRectSize=Vector2.new(512,512)
  image.Size=UDim2.fromOffset(78,78); image.Position=UDim2.fromOffset(-8,-8)
  image.ScaleType=Enum.ScaleType.Fit
  local heading=label(frame,"Caption",caption,UDim2.fromOffset(121,20),UDim2.fromOffset(72,5),16)
  heading.TextXAlignment=Enum.TextXAlignment.Left
  local value=label(frame,"Value","0",UDim2.fromOffset(121,32),UDim2.fromOffset(72,25),28)
  value.TextXAlignment=Enum.TextXAlignment.Left
  return value
 end
 local strength=counter("Strength","STRENGTH",0,Color3.fromRGB(226,66,76),Vector2.new(512,0))
 local money=counter("Money","MONEY",84,Color3.fromRGB(71,185,103),Vector2.new(0,512))
 local brainrots=counter("Brainrots","BRAINROTS",168,Color3.fromRGB(163,103,218),Vector2.new(512,512))
 local rebirth=Instance.new("ImageButton",left)
 rebirth.Name="Rebirth"; rebirth.BackgroundTransparency=1
 rebirth.Size=UDim2.fromOffset(90,90); rebirth.Position=UDim2.fromOffset(56,244)
 rebirth.Image="rbxassetid://91246928932525"
 local percent=label(left,"RebirthProgress","0%",UDim2.fromOffset(202,26),UDim2.fromOffset(0,329),23)
 local modal=Instance.new("Frame",gui)
 modal.Name="RebirthModal"; modal.Size=UDim2.fromScale(1,1)
 modal.BackgroundTransparency=1; modal.ZIndex=20; modal.Visible=false
 modal:GetPropertyChangedSignal("Visible"):Connect(function()
  game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,not modal.Visible)
 end)
 local shade=Instance.new("TextButton",modal)
 shade.Name="Backdrop"; shade.Size=UDim2.fromScale(1,1)
 shade.Text=""; shade.BackgroundColor3=Color3.new(); shade.BackgroundTransparency=0.35
 shade.AutoButtonColor=false
 local dialog=panel("Dialog",modal,UDim2.fromOffset(420,330),UDim2.fromScale(0.5,0.5),Color3.fromRGB(40,53,75))
 dialog.AnchorPoint=Vector2.new(0.5,0.5); dialog.ZIndex=2; dialog.Active=true
 local dialogScale=Instance.new("UIScale",dialog)
 label(dialog,"Title","REBIRTH",UDim2.fromOffset(310,40),UDim2.fromOffset(55,14),30)
 local close=Instance.new("TextButton",dialog)
 close.Name="Close"; close.Text="X"; close.Font=Enum.Font.FredokaOne; close.TextSize=24
 close.Size=UDim2.fromOffset(44,44); close.Position=UDim2.new(1,-49,0,7)
 close.BackgroundTransparency=1; close.TextColor3=Color3.new(1,1,1)
 local needed=label(dialog,"Requirement","Cash needed",UDim2.fromOffset(376,26),UDim2.fromOffset(22,68),20)
 needed.TextXAlignment=Enum.TextXAlignment.Left
 local progress=panel("Progress",dialog,UDim2.fromOffset(376,38),UDim2.fromOffset(22,102),ink)
 progress.ClipsDescendants=true
 local fill=Instance.new("Frame",progress)
 fill.Name="Fill"; fill.Size=UDim2.fromScale(0,1); fill.BorderSizePixel=0
 fill.BackgroundColor3=Color3.fromRGB(55,204,149)
 local fillCorner=Instance.new("UICorner",fill); fillCorner.CornerRadius=UDim.new(1,0)
 local progressText=label(progress,"Value","",UDim2.fromScale(1,1),UDim2.fromOffset(0,0),23)
 progressText.ZIndex=2
 local bonuses=label(dialog,"Bonuses","",UDim2.fromOffset(376,48),UDim2.fromOffset(22,152),17)
 bonuses.TextColor3=Color3.fromRGB(143,255,220); bonuses.TextWrapped=true
 local resetText=label(dialog,"ResetInfo","Resets Strength, Cash, Gloves and Punch Area.\nBrainrots and permanent bonuses are kept.",UDim2.fromOffset(376,42),UDim2.fromOffset(22,207),14)
 resetText.TextWrapped=true
 local confirm=panel("Confirm",dialog,UDim2.fromOffset(280,48),UDim2.fromOffset(70,264),Color3.fromRGB(55,204,149),"TextButton")
 confirm.Text=""; confirm.AutoButtonColor=true
 local confirmText=label(confirm,"Caption","REBIRTH",UDim2.fromScale(1,1),UDim2.fromOffset(0,0),22)
 rebirth.Activated:Connect(function() modal.Visible=not modal.Visible end)
 close.Activated:Connect(function() modal.Visible=false end)
 shade.Activated:Connect(function() modal.Visible=false end)
 local gains=Instance.new("Frame",gui)
 gains.Name="TrainingGains"; gains.Size=UDim2.fromScale(1,1)
 gains.BackgroundTransparency=1; gains.ZIndex=5
 local random=Random.new()
 local function showGain(amount)
  local character=player.Character
  local root=character and character:FindFirstChild("HumanoidRootPart")
  local camera=workspace.CurrentCamera
  if not root or not camera or amount<=0 then return end
  local point,visible=camera:WorldToScreenPoint(root.Position+Vector3.new(0,1.5,0))
  if not visible then return end
  local size=math.clamp(camera.ViewportSize.Y/700,0.7,1)
  local side=if random:NextNumber()<0.5 then -1 else 1
  local x=math.clamp(point.X+side*random:NextNumber(65,120)*size,60,gains.AbsoluteSize.X-60)
  local y=math.clamp(point.Y+random:NextNumber(-35,30)*size,90,gains.AbsoluteSize.Y-30)
  local popup=Instance.new("Frame",gains)
  popup.Name="StrengthGain"; popup.Size=UDim2.fromOffset(112,46)
  popup.AnchorPoint=Vector2.new(0.5,0.5); popup.Position=UDim2.fromOffset(x,y)
  popup.BackgroundTransparency=1; popup.Rotation=random:NextNumber(-8,8)
  local zoom=Instance.new("UIScale",popup); zoom.Scale=size*0.6
  local image=Instance.new("ImageLabel",popup)
  image.Name="Icon"; image.BackgroundTransparency=1; image.Image=atlas
  image.ImageRectOffset=Vector2.new(512,0); image.ImageRectSize=Vector2.new(512,512)
  image.Size=UDim2.fromOffset(46,46)
  local text=label(popup,"Amount","+"..amount,UDim2.fromOffset(70,46),UDim2.fromOffset(44,0),34)
  text.TextXAlignment=Enum.TextXAlignment.Left
  text.TextColor3=Color3.fromRGB(255,218,86)
  TweenService:Create(zoom,TweenInfo.new(0.15,Enum.EasingStyle.Back),{Scale=size}):Play()
  local float=TweenService:Create(popup,TweenInfo.new(0.9,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
   {Position=UDim2.fromOffset(x+side*18*size,y-75*size),Rotation=0})
  local fade=TweenInfo.new(0.45,Enum.EasingStyle.Quad,Enum.EasingDirection.In,0,false,0.4)
  TweenService:Create(text,fade,{TextTransparency=1,TextStrokeTransparency=1}):Play()
  TweenService:Create(image,fade,{ImageTransparency=1}):Play()
  float.Completed:Once(function() popup:Destroy() end)
  float:Play()
 end
 player.CharacterRemoving:Connect(function() gains:ClearAllChildren() end)
 local toast=panel("Feedback",gui,UDim2.new(0.75,0,0,50),UDim2.new(0.5,0,0,24),ink)
 toast.AnchorPoint=Vector2.new(0.5,0)
 local limit=Instance.new("UISizeConstraint",toast); limit.MaxSize=Vector2.new(480,50)
 toast.Visible=false
 local toastText=label(toast,"Message","",UDim2.new(1,-20,1,-8),UDim2.fromOffset(10,4),19)
 toastText.TextWrapped=true
 local function compact(n)
  if n>=1000000 then return (string.format("%.1fM",n/1000000):gsub("%.0M","M")) end
  if n>=1000 then return (string.format("%.1fK",n/1000):gsub("%.0K","K")) end
  return tostring(n)
 end
 local values=player:WaitForChild("leaderstats")
 local cash=values:WaitForChild("Cash")
 local power=values:WaitForChild("Strength")
 local rebirthCount=values:WaitForChild("Rebirths")
 local pending=false
 local function refresh()
  money.Text="$"..compact(cash.Value)
  brainrots.Text=compact(player:GetAttribute("BrainrotsCarried") or 0)
  strength.Text=compact(power.Value)
  local ratio=math.clamp(cash.Value/Config.RebirthCash,0,1)
  percent.Text=math.floor(ratio*100).."%"
  percent.TextColor3=if ratio>=1 then Color3.fromRGB(143,255,220) else Color3.new(1,1,1)
  fill.Size=UDim2.fromScale(ratio,1)
  progressText.Text="$"..compact(cash.Value).." / $"..compact(Config.RebirthCash)
  confirm.BackgroundColor3=if ratio>=1 then Color3.fromRGB(55,204,149) else Color3.fromRGB(83,95,115)
  confirm.AutoButtonColor=ratio>=1
  confirmText.Text=if ratio>=1 then "REBIRTH" else "NEED $"..compact(Config.RebirthCash-cash.Value)
  local count=rebirthCount.Value
  local currentSpeed=math.max(Config.MinimumTrainingInterval,Config.TrainingInterval-count*Config.TrainingSpeedPerRebirth)
  local nextSpeed=math.max(Config.MinimumTrainingInterval,Config.TrainingInterval-(count+1)*Config.TrainingSpeedPerRebirth)
  bonuses.Text=string.format("Cash x%.2f → x%.2f\nTraining %.2fs → %.2fs",1+count*Config.CashBonusPerRebirth,1+(count+1)*Config.CashBonusPerRebirth,currentSpeed,nextSpeed)
 end
 confirm.Activated:Connect(function()
  if pending or cash.Value<Config.RebirthCash then return end
  pending=true
  storage.SimulatorAction:FireServer("Rebirth")
  task.delay(1,function() pending=false end)
 end)
 rebirthCount.Changed:Connect(function() modal.Visible=false; refresh() end)
 cash.Changed:Connect(refresh)
 power.Changed:Connect(refresh)
 player:GetAttributeChangedSignal("BrainrotsCarried"):Connect(refresh)
 local function resize()
  local viewport=workspace.CurrentCamera.ViewportSize
  if viewport.Y<500 then
   left.AnchorPoint=Vector2.zero; left.Position=UDim2.fromOffset(22,8)
   scale.Scale=math.clamp((viewport.Y-180)/360,0.5,0.65)
  else
   left.AnchorPoint=Vector2.new(0,0.5); left.Position=UDim2.new(0,22,0.5,0)
   scale.Scale=if viewport.X<500 then 0.8 else 1
  end
  dialogScale.Scale=math.min(1,(viewport.X-32)/420,(viewport.Y-60)/330)
 end
 workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
 resize(); refresh()
 local messageId=0
 return function(text)
  if typeof(text)=="number" then showGain(text); return end
  messageId+=1
  local id=messageId
  toastText.Text=text; toast.Visible=true
  task.delay(2.5,function() if id==messageId then toast.Visible=false end end)
 end
end
