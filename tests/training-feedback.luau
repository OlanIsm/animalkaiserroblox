-- Run in Studio MCP Client play mode while Shadowboxing is equipped.
local p=game.Players.LocalPlayer
local layer=p.PlayerGui.SimulatorHUD.TrainingGains
local feedback=game.ReplicatedStorage.SimulatorFeedback
local amount
local connection=feedback.OnClientEvent:Connect(function(value)
 if typeof(value)=="number" then amount=value end
end)
local popup=layer.ChildAdded:Wait()
local text=popup:WaitForChild("Amount")
task.wait()
connection:Disconnect()
assert(amount and amount>0,"Expected a server training award")
assert(text.Text=="+"..amount,"Popup does not match server award")
local camera=workspace.CurrentCamera
local point=camera:WorldToScreenPoint(p.Character.HumanoidRootPart.Position+Vector3.new(0,1.5,0))
local origin=popup.Position
assert((Vector2.new(origin.X.Offset,origin.Y.Offset)-Vector2.new(point.X,point.Y)).Magnitude<180,"Popup is too far from character")
task.wait(0.2)
assert(popup.Position.Y.Offset<origin.Y.Offset,"Popup did not float upward")
task.wait(0.35)
assert(popup.Amount.TextTransparency>0,"Popup did not fade")
task.wait(0.5)
assert(popup.Parent==nil,"Popup did not clean itself up")
return "PASS: server amount, near-character placement, upward motion, fade, cleanup"
