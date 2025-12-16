-- ReplicatedStorage modules
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Modules.Types)

-- Stone class module
local module = {
    StoneData = {} -- Store all active stone instances
}

module.__index = module

-- Setup model attributes
local function AttributeSetUp(self)
    local Model: Model = self.Model
    Model:SetAttribute("MaxHealth", self.MaxHealth)
    Model:SetAttribute("Health", self.Health)
end

-- Create new stone instance
function module.new(model: Model, args)
    local self = setmetatable({}, module)

    self.Health = args.Health
    self.MaxHealth = args.MaxHealth
    self.Model = model
    self.Drop = args.Drop

    AttributeSetUp(self)

    -- Cache stone data by model
    module.StoneData[self.Model] = self
    return self
end

-- Set stone health
function module:SetHealth(amount: number): {Types.InventoryStone}?
    local Model: Model = self.Model
    local newHealth = math.max(0, amount)

    self.Health = newHealth
    Model:SetAttribute("Health", newHealth)

    -- Destroy stone and return drop when health is zero
    if self.Health == 0 then
        local drop = self.Drop
        self:Destroy()
        return drop
    end
end

-- Increase stone health
function module:IncrementHealth(amount: number)
    self:SetHealth(self.Health + amount)
end

-- Decrease stone health
function module:DecrementHealth(amount: number): {Types.InventoryStone}?
    return self:SetHealth(self.Health - amount)
end

-- Destroy stone instance
function module:Destroy()
    local Model: Model = self.Model
    Model:Destroy()

    -- Remove from cache
    module.StoneData[self.Model] = nil

    -- Clear references
    for key in pairs(self) do
        self[key] = nil
    end
end

-- Get stone data by model
function module.GetStoneData(Model: Model)
    return module.StoneData[Model]
end

return module
