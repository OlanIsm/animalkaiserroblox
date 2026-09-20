local event = Instance.new("RemoteEvent")
event.Name = "PunchAnimation"
event.Parent = game:GetService("ReplicatedStorage")

return function(character)
 local hand = -1
 return {
  play = function(duration)
   hand = -hand
   event:FireAllClients(character,duration,hand)
  end,
  stop = function()
   event:FireAllClients(character,0,hand)
  end,
 }
end
