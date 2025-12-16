-- Roblox services
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Remote event for updating pickaxe data on client
local UpdateData: RemoteEvent = ReplicatedStorage.Remotes.Pickaxe.UpdateData

-- Shared types
local Types = require(ReplicatedStorage.Modules.Types)

-- Profile service
local ProfileService = require(script.Parent.Parent.ProfileStore.ProfileService)

local module = {}

-- Get all pickaxe data from player profile
function module.GetData(player: Player): {Types.InventoryPickaxe}
    local PickaxesData = ProfileService.GetData(player).Inventory.Pickaxes
    if PickaxesData == nil then
        warn("pickaxe data not exist")
        return
    end
    return PickaxesData
end

-- Get pickaxe data by unique pickaxe id
function module.GetPickaxeById(player: Player, id: string): {pickaxe: Types.InventoryPickaxe, index: number}?
    local PickaxesData = module.GetData(player)
    for index, pickaxe in ipairs(PickaxesData) do
        if pickaxe.Id == id then
            return { pickaxe = pickaxe, index = index }
        end
    end
end

-- Add new pickaxe to player inventory
function module.AddItem(player: Player, name: string): boolean
    local PickaxesData = module.GetData(player)

    local newPickaxeData: Types.InventoryPickaxe = {
        -- Generate unique pickaxe id
        Id = HttpService:GenerateGUID(false),
        Name = name
    }
    
    -- Insert pickaxe into inventory table
    table.insert(PickaxesData, newPickaxeData)

    -- Update client UI (added)
    UpdateData:FireClient(player, newPickaxeData, false)

    return true
end

-- Remove pickaxe by id
function module.RemoveById(player: Player, id: string): boolean
    -- Get pickaxe data by id
    local pickaxe = module.GetPickaxeById(player, id)
    if not pickaxe then
        warn("remove fail pickaxe not exist")
        return false
    end

    -- Remove pickaxe using its index
    table.remove(module.GetData(player), pickaxe.index)

    -- Update client UI (removed)
    UpdateData:FireClient(player, pickaxe.pickaxe, true)

    return true
end

return module
