local RunService = game:GetService("RunService")
local active = {}

local function play(character, duration, hand)
 if typeof(character) ~= "Instance" or not character:IsA("Model") then return end
 local state = active[character]
 if not state then
  if duration == 0 or not character.Parent then return end
  state = {joints={}}
  for _, joint in ipairs(character:GetDescendants()) do
   if joint:IsA("Motor6D") or joint:IsA("AnimationConstraint") then
    local side = if joint.Name=="Right Shoulder" or joint.Name=="RightShoulder" then 1
     elseif joint.Name=="Left Shoulder" or joint.Name=="LeftShoulder" then -1 else nil
    if side then table.insert(state.joints,{motor=joint,rotation=joint.C0.Rotation,side=side}) end
   end
  end
  active[character] = state
 end
 state.start = os.clock()
 state.duration = duration
 state.hand = hand
end

-- Restore our previous overlay before Animator evaluates the next frame.
RunService.PreAnimation:Connect(function()
 for character,state in pairs(active) do
  for _, joint in ipairs(state.joints) do
   if joint.original and joint.motor.Parent then joint.motor.Transform=joint.original end
   joint.original=nil
  end
  if not character.Parent or os.clock()-state.start >= state.duration then active[character]=nil end
 end
end)
RunService.PreSimulation:Connect(function()
 for _,state in pairs(active) do
  if state.duration <= 0 then continue end
  local t = math.clamp((os.clock()-state.start)/state.duration,0,1)
  local weight = if t < 0.3 then 1-(1-t/0.3)^2 elseif t < 0.4 then 1 else (1-(t-0.4)/0.6)^2
  for _,joint in ipairs(state.joints) do
   if joint.motor.Parent then
    local angle = if joint.side==state.hand then 95 else 55
    local pose = joint.rotation:Inverse()
     * CFrame.Angles(math.rad(angle),0,math.rad(-joint.side*12))
     * joint.rotation
    joint.original=joint.motor.Transform
    joint.motor.Transform=joint.original:Lerp(pose,weight)
   end
  end
 end
end)
return play
