local Players=game:GetService("Players")

return function(world,onDestroyed)
 local zones={world.Zone1,world.Zone2,world.Zone3}
 local known={}
 for _,zone in ipairs(zones) do
  for _,block in ipairs(zone:GetChildren()) do
   if block:IsA("BasePart") and block:GetAttribute("MaxHP") then known[block]=true end
  end
 end
 local query=OverlapParams.new()
 query.FilterType=Enum.RaycastFilterType.Include
 query.FilterDescendantsInstances=zones
 local owners={}
 local pending={}
 local bounds=world:WaitForChild("LobbyBounds")
 local service={}
 function service.InLobby(position)
  local p=bounds.CFrame:PointToObjectSpace(position)
  local half=bounds.Size/2
  return math.abs(p.X)<=half.X and math.abs(p.Y)<=half.Y and math.abs(p.Z)<=half.Z
 end
 function service.Target(character,requested)
  local root=character:FindFirstChild("HumanoidRootPart")
  if not root then return end
  local ray=RaycastParams.new()
  ray.FilterType=Enum.RaycastFilterType.Exclude
  ray.FilterDescendantsInstances={character}
  local function reachable(block)
   if not known[block] or block:GetAttribute("HP")<=0 then return false end
   local delta=block.Position-root.Position
   if delta.Magnitude>18 then return false end
   local result=workspace:Raycast(root.Position,delta,ray)
   return result and result.Instance==block
  end
  if typeof(requested)=="Instance" and reachable(requested) then return requested end
  local best,distance=nil,18
  for _,block in ipairs(workspace:GetPartBoundsInRadius(root.Position,18,query)) do
   local delta=block.Position-root.Position
   local length=delta.Magnitude
   if length>0 and length<distance and root.CFrame.LookVector:Dot(delta/length)>0.35 and reachable(block) then
    best=block; distance=length
   end
  end
  return best
 end
 function service.Hit(player,target,damage,radius)
  local targets=if radius>0 then workspace:GetPartBoundsInRadius(target.Position,radius,query) else {target}
  for _,block in ipairs(targets) do
   if not known[block] or block:GetAttribute("HP")<=0 then continue end
   if block~=target and (block.Position-target.Position).Magnitude>radius then continue end
   local hp=math.max(0,block:GetAttribute("HP")-damage)
   block:SetAttribute("HP",hp)
   block.Transparency=0.7*(1-hp/block:GetAttribute("MaxHP"))
   if hp==0 then
    block.Transparency=1; block.CanCollide=false; block.CanQuery=false
    block:SetAttribute("DestroyedBy",player.UserId)
    owners[player]=owners[player] or {}
    owners[player][block]=true
    onDestroyed(player,block.Position)
   end
  end
 end
 function service.Reset(player)
  local count=0
  for block in pairs(owners[player] or {}) do pending[block]=true; count+=1 end
  owners[player]=nil
  return count
 end
 function service.RestorePending()
  local roots={}
  for _,player in ipairs(Players:GetPlayers()) do
   local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
   if root then table.insert(roots,root.Position) end
  end
  for block in pairs(pending) do
   if not block.Parent then pending[block]=nil; continue end
   local occupied=false
   for _,position in ipairs(roots) do
    local delta=block.CFrame:PointToObjectSpace(position)
    local half=block.Size/2+Vector3.new(2,3,2)
    if math.abs(delta.X)<half.X and math.abs(delta.Y)<half.Y and math.abs(delta.Z)<half.Z then occupied=true; break end
   end
   if not occupied then
    block:SetAttribute("HP",block:GetAttribute("MaxHP")); block:SetAttribute("DestroyedBy",nil)
    block.Transparency=0; block.CanCollide=true; block.CanQuery=true
    pending[block]=nil
   end
  end
 end
 return service
end
