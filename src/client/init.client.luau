local p = game:GetService("Players").LocalPlayer
local storage = game:GetService("ReplicatedStorage")
storage:WaitForChild("PunchAnimation").OnClientEvent:Connect(require(script.PunchAnimation))
local action = storage:WaitForChild("SimulatorAction")
local feedback = storage:WaitForChild("SimulatorFeedback")
local showFeedback = require(script.HUD)("rbxassetid://80133056890623")
feedback.OnClientEvent:Connect(showFeedback)

local connected = setmetatable({}, {__mode="k"})
local function connect(tool)
 if not tool:IsA("Tool") or tool.Name~="Punch" or connected[tool] then return end
 connected[tool] = true
 tool.Activated:Connect(function() action:FireServer("Punch",p:GetMouse().Target) end)
end
local backpack = p:WaitForChild("Backpack")
backpack.ChildAdded:Connect(connect)
for _, tool in ipairs(backpack:GetChildren()) do connect(tool) end
local function characterAdded(character)
 character.ChildAdded:Connect(connect)
 for _, child in ipairs(character:GetChildren()) do connect(child) end
end
p.CharacterAdded:Connect(characterAdded)
if p.Character then characterAdded(p.Character) end
