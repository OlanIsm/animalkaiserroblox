-- Run with Studio MCP execute_luau in Client play mode, with tools unequipped.
local player = game.Players.LocalPlayer
local play = require(player.PlayerScripts.Client.PunchAnimation)
for _, names in ipairs({{"Right Shoulder","Left Shoulder"},{"RightShoulder","LeftShoulder"}}) do
 local rig=Instance.new("Model",workspace)
 local motors={}
 for _,name in ipairs(names) do
  local motor=Instance.new("Motor6D",rig)
  motor.Name=name
  table.insert(motors,motor)
 end
 play(rig,0.3,1)
 task.wait(0.1)
 assert(not motors[1].Transform:FuzzyEq(CFrame.identity),"Jab did not move shoulder")
 play(rig,0,1)
 task.wait(0.1)
 for _,m in ipairs(motors) do assert(m.Transform:FuzzyEq(CFrame.identity),"Cancelled jab stuck") end
 play(rig,0.3,-1)
 task.wait(0.1)
 assert(not motors[2].Transform:FuzzyEq(CFrame.identity),"Left jab did not move")
 task.wait(0.3)
 for _,m in ipairs(motors) do assert(m.Transform:FuzzyEq(CFrame.identity),"Jab did not recover") end
 rig:Destroy()
end
return "PASS: alternating shoulders, cancellation, recovery"
