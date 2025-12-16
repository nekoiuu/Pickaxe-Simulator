-- ReplicatedStorage modules
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local configruation = require(ReplicatedStorage.Modules.Configurations.Pickaxe)

-- Services
local hitBoxService = require(script.Parent.Parent.Modules.HitBoxService)
local ProfileStorePickax = require(script.Parent.Parent.ProfileStore.Stone)
local Types = require(ReplicatedStorage.Modules.Types)

local model = {}

-- Hitbox settings
local HitboxSize = Vector3.new(3, 3, 3)
local HitDuration = 0.5
local WeldC0 = CFrame.new(0, 0, -2)

-- Handle pickaxe attack
function model.Attack(player: Player, tool: Tool)
    local char = player.Character
    local data = configruation.GetDataByName(tool.Name)
    if not data then return end

    -- Check attack cooldown
    if tick() - tool:GetAttribute("LastSwing") < data.CoolDown then return end
    tool:SetAttribute("LastSwing", tick())

    -- Create hitbox
    local newHitBox = hitBoxService.CreateCharHitBox({
        Size = HitboxSize,      -- Hitbox size
        Character = char,       -- Player character
        Duration = HitDuration,-- Hitbox lifetime
        C0 = WeldC0             -- Weld offset
    })

    -- Overlap parameters
    local params = OverlapParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { char, newHitBox }

    -- Detect stones inside hitbox
    hitBoxService.GetStoneInHitBox(newHitBox, params, function(stone)
        if not stone then return end

        -- Damage stone and get drops
        local drop: {Types.InventoryStone} = stone:DecrementHealth(data.Damage)

        -- Add drops to player inventory
        if drop then
            ProfileStorePickax.IncrementStone(player, drop)
        end
    end)
end

return model
