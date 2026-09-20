-- Run via Studio MCP execute_luau in Client play mode after the HUD has loaded.
local gui=game.Players.LocalPlayer.PlayerGui:WaitForChild("SimulatorHUD")
local images={}
for _,v in ipairs(gui:GetDescendants()) do
 if v:IsA("ImageLabel") and v:IsDescendantOf(gui.LeftCounters) then table.insert(images,v) end
end
game:GetService("ContentProvider"):PreloadAsync(images)
assert(#images==3,"HUD must display only Money, Brainrots, and Strength icons")
for _,image in ipairs(images) do assert(image.IsLoaded,image.Name.." failed to load") end
for _,name in ipairs({"Money","Brainrots","Strength"}) do
 local frame=gui.LeftCounters[name]
 assert(not frame:IsA("GuiButton"),"Stat counters must remain informational")
 assert(frame.Value.AbsolutePosition.X>frame.Icon.AbsolutePosition.X+frame.Icon.AbsoluteSize.X,"Value must be to the right of the image")
end
assert(gui.LeftCounters.Strength.Position.Y.Offset<gui.LeftCounters.Money.Position.Y.Offset)
assert(gui.LeftCounters.Rebirth:IsA("ImageButton"))
assert(gui.LeftCounters.Rebirth.Position.Y.Offset>gui.LeftCounters.Brainrots.Position.Y.Offset)
return "PASS: informational stats, Strength first, clickable Rebirth below Brainrots"
