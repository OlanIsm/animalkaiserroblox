-- Run through Studio MCP in Server play mode.
local world=Instance.new("Folder",workspace)
world.Name="BlockResetCheck"
local zones={}
for i=1,3 do local zone=Instance.new("Folder",world); zone.Name="Zone"..i; zones[i]=zone end
local bounds=Instance.new("Part",world)
bounds.Name="LobbyBounds"; bounds.Size=Vector3.new(80,36,76); bounds.Position=Vector3.new(0,12,0)
bounds.Anchored=true; bounds.CanCollide=false; bounds.Transparency=1
local function block(x)
 local b=Instance.new("Part",zones[1])
 b.Name="Block"; b.Size=Vector3.new(6,6,6); b.Position=Vector3.new(x,3,1000)
 b.Anchored=true; b.CanCollide=false; b:SetAttribute("MaxHP",10); b:SetAttribute("HP",10)
 return b
end
local a,b,c=block(1000),block(1012),block(1006)
local rewards=0
local service=require(game.ServerScriptService.Server.BlockService)(world,function() rewards+=1 end)
local one,two={UserId=-1},{UserId=-2}
service.Hit(one,a,10,0); service.Hit(one,a,10,0); service.Hit(two,b,10,0)
assert(rewards==2,"Duplicate rewards for an already destroyed block")
assert(service.Reset(one)==1); service.RestorePending()
assert(a:GetAttribute("HP")==10 and a.CanQuery and a.CanCollide,"Owner block did not restore")
assert(b:GetAttribute("HP")==0,"Reset affected a different player's block")
service.Hit(one,a,10,6.5)
assert(c:GetAttribute("HP")==0,"Area level 2 failed to reach adjacent 6-stud blocks")
local player=game.Players:GetPlayers()[1]
a.Position=player.Character.HumanoidRootPart.Position
service.Reset(one); service.RestorePending()
assert(a:GetAttribute("HP")==0,"Restored a block inside an occupied character")
a.Position=Vector3.new(1000,3,1000); service.RestorePending()
assert(a:GetAttribute("HP")==10,"Deferred restore never completed")
assert(service.InLobby(Vector3.new(0,3,0)) and not service.InLobby(Vector3.new(0,3,-45)))
world:Destroy()
return "PASS: single reward, owner-only reset, area coverage, occupied-block deferral, lobby boundary"
