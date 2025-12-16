-- ReplicatedStorage services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Pickaxe remotes
local remotes: Folder = ReplicatedStorage.Remotes.Pickaxe
local GetData: RemoteFunction = remotes.GetData
local EquipTool: RemoteFunction = remotes.EquipTool

-- Pickaxe configuration
local Configruation = require(ReplicatedStorage.Modules.Configurations.Pickaxe)

-- Profile store
local ProfileStorePickaxe = require(script.Parent.Parent.ProfileStore.Pickaxe)

local module = {}

-- Initialize remote handlers
function module.Init()
    -- Get player pickaxe data
    GetData.OnServerInvoke = function(player: Player)
        local data

        -- Wait until profile data is available
        repeat
            pcall(function()
                data = ProfileStorePickaxe.GetData(player)
            end)
            task.wait()
        until data

        return data
    end

    -- Equip / Unequip pickaxe
    EquipTool.OnServerInvoke = function(player, id)
        return module.ToggleEquip(player, id)
    end
end

-- Toggle equip state
function module.ToggleEquip(player: Player, id: number): boolean
    if module.FindTooEquipped(player, id) then
        if module.UnEquip(player, id) then
            return false
        end
    else
        if module.Equip(player, id) then
            return true
        end
    end
end

-- Find equipped pickaxe by id
function module.FindTooEquipped(player: Player, id: string): Tool?
    local char = player.Character
    local backPack = player.Backpack

    -- Check equipped tool
    local foundTool = char:FindFirstChildWhichIsA("Tool")
    if foundTool and foundTool:GetAttribute("id") == id then
        return foundTool
    end

    -- Check backpack
    for _, tool: Tool in ipairs(backPack:GetChildren()) do
        if tool:IsA("Tool") and tool:GetAttribute("id") == id then
            return tool
        end
    end
end

-- Equip pickaxe to player
function module.Equip(player: Player, id: string): boolean
    if module.FindTooEquipped(player, id) then return false end

    local playerPickaxe = ProfileStorePickaxe.GetPickaxeById(player, id)
    if not playerPickaxe then
        warn("Equip fail pickaxe Id not exist")
        return
    end

    local PickaxeData = Configruation.GetDataByName(playerPickaxe.pickaxe.Name)

    local newPickaxes = PickaxeData.Tool:Clone()
    newPickaxes:SetAttribute("id", playerPickaxe.pickaxe.Id)
    newPickaxes:SetAttribute("LastSwing", 0)
    newPickaxes:SetAttribute("CoolDown", PickaxeData.CoolDown)
    newPickaxes:SetAttribute("Pickaxe",true)
    newPickaxes.Parent = player.Backpack

    return true
end

-- Unequip pickaxe from player
function module.UnEquip(player: Player, id: string): boolean
    local tool = module.FindTooEquipped(player, id)
    if tool then
        tool:Destroy()
        return true
    end
    return false
end

return module
