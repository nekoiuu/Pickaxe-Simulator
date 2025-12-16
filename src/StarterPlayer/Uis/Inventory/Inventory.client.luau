local player = game.Players.LocalPlayer

--ui
local playerGui =  player.PlayerGui
local screenGui:ScreenGui = playerGui:WaitForChild("ScreenGui")
local OpenButton:ImageButton = screenGui.OpenInventory
local Inventory:Frame = screenGui.Inventory
local CloseButton:TextButton = Inventory.TopBar.CloseButton

--toggle open inventory
OpenButton.Activated:Connect(function()
    Inventory.Visible = not Inventory.Visible
end)

--close inventory button
CloseButton.Activated:Connect(function()
    Inventory.Visible = false
end)
