-- Player & services
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Stone remotes
local remotes: Folder = ReplicatedStorage.Remotes.Stone
local getData: RemoteFunction = remotes:WaitForChild("GetData")
local updateData: RemoteEvent = remotes:WaitForChild("UpdateData")

-- UI references
local playerGui = player.PlayerGui
local screenGui: ScreenGui = playerGui:WaitForChild("ScreenGui")
local Inventory: Frame = screenGui.Inventory
local items: Folder = Inventory.Components.Stones.Items
local UiStoneItemTemplates: Frame = ReplicatedStorage.Assets.UiTemplates.StoneItem

-- Types & configuration
local Types = require(ReplicatedStorage.Modules.Types)
local configruation = require(ReplicatedStorage.Modules.Configurations.Stone)

-- Create stone UI item
function CreateItem(item: Types.InventoryStone)
    -- Get stone config data
    local StoneData = configruation.GetDataByName(item.Name)
    
    -- Clone UI template
    local newitemUi = UiStoneItemTemplates:Clone()
    newitemUi.Parent = items
    newitemUi.Name = item.Name
    
    -- Set image
    local images: ImageLabel = newitemUi.ImageLabel
    images.Image = StoneData.ImageId
    
    -- Set name
    local TextName: TextLabel = newitemUi.TextName
    TextName.Text = item.Name
    
    -- Set amount
    local TextAmount: TextLabel = newitemUi.TextAmount
    TextAmount.Text = item.Amount
end

-- Remove stone UI item
function RemoveItem(name: string)
    local item: Frame = items:FindFirstChild(name)
    if item then
        item:Destroy()
    end
end

-- Update stone amount in UI
function updateAmount(item: Types.InventoryStone)
    local itemUi: Frame = items:FindFirstChild(item.Name)
    if itemUi then
        local TextAmount: TextLabel = itemUi.TextAmount
        TextAmount.Text = item.Amount
    end
end

-- Request stone data from server
local data: {Types.InventoryStone} = getData:InvokeServer()

-- Create initial UI items
for _, item in ipairs(data) do
    CreateItem(item)
end

-- Listen for server updates
updateData.OnClientEvent:Connect(function(newData: Types.InventoryStone)
    if newData.Amount > 0 then
        -- Update amount
        updateAmount(newData)
    elseif newData.Amount == 0 then
        -- Remove UI when amount is zero
        RemoveItem(newData.Name)
    end
end)
