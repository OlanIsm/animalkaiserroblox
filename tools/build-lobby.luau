-- Run through Studio MCP in Edit mode. Builds non-code instances only.
local world=workspace:WaitForChild("SimulatorWorld")
local archive=Instance.new("Folder")
archive.Name="LayoutBeforeLobby_"..os.time()
archive.Parent=game.ServerStorage
for _,name in ipairs({"Zone1","Zone2","Zone3","SELL","GLOVE SHOP","PUNCH AREA UPGRADE","REBIRTH"}) do
 local old=world:FindFirstChild(name)
 if old then old.Parent=archive end
end
local stalls=world:FindFirstChild("Stalls") or workspace:FindFirstChild("Stalls") or workspace:FindFirstChild("Folder")
assert(stalls and stalls:FindFirstChild("Red stall"),"Existing colored stalls not found")
stalls.Name="Stalls"; stalls.Parent=world
local specs={
 {"Red stall","SELL",Vector3.new(-27,3,-15)},
 {"Blue stall","GLOVE SHOP",Vector3.new(-27,3,2)},
 {"Green stall","PUNCH AREA UPGRADE",Vector3.new(10,3,26)},
}
for _,spec in ipairs(specs) do
 local model=stalls[spec[1]]
 local old=model:FindFirstChild("Interaction")
 if old then old:Destroy() end
 local anchor=Instance.new("Part")
 anchor.Name="Interaction"; anchor.Size=Vector3.new(2,2,2); anchor.Position=spec[3]
 anchor.Anchored=true; anchor.CanCollide=false; anchor.CanQuery=false; anchor.Transparency=1
 anchor:SetAttribute("BoothAction",spec[2]); anchor.Parent=model
 local prompt=Instance.new("ProximityPrompt",anchor)
 prompt.ActionText=if spec[2]=="SELL" then "Sell all" elseif spec[2]=="GLOVE SHOP" then "Buy next glove" else "Upgrade area"
 prompt.ObjectText=spec[2]; prompt.MaxActivationDistance=10; prompt.RequiresLineOfSight=false
 local sign=Instance.new("BillboardGui",anchor)
 sign.Name="BoothSign"; sign.Size=UDim2.fromOffset(220,40)
 sign.StudsOffsetWorldSpace=Vector3.new(0,7,0); sign.MaxDistance=65
 local text=Instance.new("TextLabel",sign)
 text.Size=UDim2.fromScale(1,1); text.BackgroundTransparency=1
 text.Text=spec[2]; text.Font=Enum.Font.FredokaOne; text.TextSize=22
 text.TextColor3=Color3.new(1,1,1); text.TextStrokeTransparency=0
end
for _,v in ipairs(stalls["Orange stall"]:GetDescendants()) do
 if v:IsA("ProximityPrompt") then v:Destroy() end
end
local walls=workspace:FindFirstChild("walls")
assert(walls,"Existing lobby walls not found")
-- Open the north exit without replacing the user's wall models.
for _,model in ipairs(walls:GetChildren()) do
 if model:IsA("Model") then
  local cf=model:GetBoundingBox()
  if cf.Position.Z < -35 and math.abs(cf.Position.X)<11 then model.Parent=archive end
 end
end
local bounds=world:FindFirstChild("LobbyBounds") or Instance.new("Part")
bounds.Name="LobbyBounds"; bounds.Size=Vector3.new(80,36,76); bounds.Position=Vector3.new(0,12,0)
bounds.Anchored=true; bounds.Transparency=1; bounds.CanCollide=false; bounds.CanTouch=false; bounds.CanQuery=false
bounds.Parent=world
world["Training Area"].Position=Vector3.new(0,0.2,-14)
world["Boxing Bag"]:PivotTo(CFrame.new(0,5.4,-14))
local road=world:FindFirstChild("LobbyExit") or Instance.new("Part")
road.Name="LobbyExit"; road.Size=Vector3.new(14,0.12,18); road.Position=Vector3.new(1,0.06,-42)
road.Anchored=true; road.Color=Color3.fromRGB(226,195,113); road.Material=Enum.Material.Sandstone
road.Parent=world
local C=require(game.ReplicatedStorage.Shared.Config)
local zones={}
for i=1,3 do local f=Instance.new("Folder",world); f.Name="Zone"..i; zones[i]=f end
local count=0
for x=-14,14 do for z=-14,14 do
 local ring=math.max(math.abs(x),math.abs(z))
 if ring>=9 then
  local zone=math.floor((ring-9)/2)+1
  for y=0,2 do
   local block=Instance.new("Part")
   block.Name="Block"; block.Size=Vector3.new(5.85,5.85,5.85)
   block.Position=Vector3.new(x*6,3+y*6,z*6); block.Anchored=true
   block.Color=C.Zones[zone].color; block.Material=C.Zones[zone].material
   block.TopSurface=Enum.SurfaceType.Smooth; block.BottomSurface=Enum.SurfaceType.Smooth
   block:SetAttribute("Zone",zone); block:SetAttribute("HP",C.Zones[zone].hp); block:SetAttribute("MaxHP",C.Zones[zone].hp)
   block.Parent=zones[zone]; count+=1
  end
 end
end end
return {blocks=count,zones=3,archive=archive:GetFullName(),stalls="Red sell / Blue shop / Green upgrade / Orange reserved"}
