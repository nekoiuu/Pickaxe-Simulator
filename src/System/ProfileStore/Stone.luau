-- ReplicatedStorage modules
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Modules.Types)

-- Remote event for updating stone data on client
local UpdateData: RemoteEvent = ReplicatedStorage.Remotes.Stone.UpdateData

-- Profile service
local ProfileService = require(script.Parent.Parent.ProfileStore.ProfileService)

local module = {}

-- Get all stone data from player profile
function module.GetData(player: Player): {Types.InventoryStone}
    local StoneData = ProfileService.GetData(player).Inventory.Stones
    if StoneData == nil then
        warn("Stone data not exist")
        return
    end

    return StoneData
end

-- Get stone data by stone name
function module.GetDataByStoneName(player: Player, name: string): {index: number, stone: Types.InventoryStone}?
    local StoneData = module.GetData(player)

    for index, stone in ipairs(StoneData) do
        if stone.Name == name then
            return { index = index, stone = stone }
        end
    end
end

-- Add stone amount to inventory
function module.IncrementStone(player: Player, data: Types.InventoryStone): boolean
    if data.Amount <= 0 then return false end

    local GetStoneData = module.GetDataByStoneName(player, data.Name)

    -- If stone already exists
    if GetStoneData and GetStoneData.stone then
        GetStoneData.stone.Amount += data.Amount
        -- Update client UI
        UpdateData:FireClient(player, GetStoneData.stone)
    else
        -- Create new stone data
        table.insert(module.GetData(player), data)
        -- Update client UI
        UpdateData:FireClient(player, data)
    end
end

-- Remove stone amount from inventory
function module.DecrementStone(player: Player, data: Types.InventoryStone): boolean
    local GetStoneData = module.GetDataByStoneName(player, data.Name)
    if not GetStoneData then return false end

    -- Not enough stones
    if GetStoneData.stone.Amount < data.Amount then
        warn(`decrement fail {player.DisplayName} Not enough item {GetStoneData.stone.Name}`)
        return false
    end

    GetStoneData.stone.Amount -= data.Amount

    -- Remove stone if amount is zero
    if GetStoneData.stone.Amount <= 0 then
        table.remove(module.GetData(player), GetStoneData.index)
    end

    -- Update client UI
    UpdateData:FireClient(player, GetStoneData.stone)
    return true
end

return module
