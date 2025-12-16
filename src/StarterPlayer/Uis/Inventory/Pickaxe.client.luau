-- Player & services
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- UI references
local playerGui = player.PlayerGui
local screenGui: ScreenGui = playerGui:WaitForChild("ScreenGui")
local Inventory: Frame = screenGui.Inventory
local items: Folder = Inventory.Components.Pickaxes.Items
local UiPickaxeItemTemplates: Frame = ReplicatedStorage.Assets.UiTemplates.PickaxeItem

-- Pickaxe remotes
local remotes: Folder = ReplicatedStorage.Remotes.Pickaxe
local getData: RemoteFunction = remotes:WaitForChild("GetData")
local updateData: RemoteEvent = remotes:WaitForChild("UpdateData")
local equipTool: RemoteFunction = remotes:WaitForChild("EquipTool")

-- Types & configuration
local Types = require(ReplicatedStorage.Modules:WaitForChild("Types"))
local configruation = require(ReplicatedStorage.Modules.Configurations:WaitForChild("Pickaxe"))

-- Create pickaxe UI item
function CreateItem(item: Types.InventoryPickaxe)
    -- Get pickaxe config data
    local PickaxeData = configruation.GetDataByName(item.Name)

    -- Clone UI template
    local newitemUi = UiPickaxeItemTemplates:Clone()
    newitemUi:SetAttribute("id", item.Id)

    -- Set image
    local images: ImageLabel = newitemUi.ImageLabel
    images.Image = PickaxeData.ImageId
    newitemUi.Parent = items

    -- Set stats
    local damage: TextLabel = newitemUi.Stats.Damage
    damage.Text = `Damage: {PickaxeData.Damage}`

    local coolDown: TextLabel = newitemUi.Stats.CoolDown
    coolDown.Text = `CoolDown: {PickaxeData.CoolDown}`

    -- Set name
    local TextName: TextLabel = newitemUi.TextName
    TextName.Text = PickaxeData.Name

    -- Equip / Unequip button
    local equipButton: TextButton = newitemUi.Equip
    equipButton.Activated:Connect(function()
        local isEquip: boolean = equipTool:InvokeServer(newitemUi:GetAttribute("id"))

        -- Update button state
        if isEquip == true then
            equipButton.Text = "UnEquip"
            equipButton.BackgroundColor3 = Color3.fromRGB(202, 0, 0)
        elseif isEquip == false then
            equipButton.Text = "Equip"
            equipButton.BackgroundColor3 = Color3.fromRGB(24, 207, 0)
        end
    end)
end

-- Request pickaxe data from server
local data: {Types.InventoryPickaxe} = getData:InvokeServer()

-- Create initial UI items
for _, item in ipairs(data) do
    CreateItem(item)
end

-- Listen for server updates
updateData.OnClientEvent:Connect(function(newData: Types.InventoryPickaxe, remove: boolean)
    if not remove then
        -- Create new UI item
        CreateItem(newData)
    elseif remove then
        -- Remove UI by pickaxe id
        for _, item: Frame in ipairs(items:GetChildren()) do
            if item:IsA("Frame") and item:GetAttribute("id") == newData.Id then
                item:Destroy()
            end
        end
    end
end)
