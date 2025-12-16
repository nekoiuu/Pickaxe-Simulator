local player = game.Players.LocalPlayer

--ui
local screenGui = player.PlayerGui:WaitForChild("ScreenGui")
local Inventory:Frame = screenGui.Inventory
local topBar:Frame = Inventory.TopBar
local buttons:Folder = topBar.ScrollingFrame.Buttons
local components:Frame = Inventory.Components
local defaultOpenComponents:ScrollingFrame = components.Pickaxes
defaultOpenComponents.Visible = true

-- ref ui component is open
local OpenComponent = defaultOpenComponents

for _,button:TextButton in ipairs(buttons:GetChildren()) do
    if button:IsA("TextButton") then

        button.Activated:Connect(function()
            --close preive component
            OpenComponent.Visible = false
            --find component name same as buton
            local component:ScrollingFrame = components:FindFirstChild(button.Name)
            component.Visible = true
            --set new ref to component is opened
            OpenComponent = component

        end)

    end
end
