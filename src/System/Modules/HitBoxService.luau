-- Roblox services
local Debris = game:GetService("Debris")

local module = {}

-- Stone data module
local Stone = require(script.Parent.Parent.Stone.Stone)

-- Create hitbox attached to character
function module.CreateCharHitBox(args)
    local char: Model = args.Character
    local rootPart: BasePart = char:FindFirstChild("HumanoidRootPart")

    local newHitBox = Instance.new("Part")
    newHitBox.Material = Enum.Material.Plastic
    newHitBox.Color = Color3.fromRGB(255, 0, 0)
    newHitBox.Transparency = 0.5
    newHitBox.Name = "HitBox"
    newHitBox.Size = args.Size
    newHitBox.Parent = args.Parent or workspace
    newHitBox.CanCollide = false

    -- Weld hitbox to character root
    local weld = Instance.new("Weld", newHitBox)
    weld.Part0 = rootPart
    weld.Part1 = newHitBox
    weld.C0 = args.C0

    -- Auto remove hitbox after duration
    if args.Duration then
        Debris:AddItem(newHitBox, args.Duration)
    end

    return newHitBox
end

-- Detect stones inside hitbox
function module.GetStoneInHitBox(hitBox: Part, params: OverlapParams, callBack)
    task.spawn(function()
        local alreadyHit = {}

        -- Loop while hitbox exists
        while hitBox and hitBox.Parent do
            local parts = workspace:GetPartsInPart(hitBox, params)

            for _, part in ipairs(parts) do
                local model = part:FindFirstAncestorOfClass("Model")
                if model and not alreadyHit[model] then
                    local data = Stone.GetStoneData(model)
                    if data then
                        alreadyHit[model] = true
                        callBack(data)
                    end
                end
            end

            task.wait()
        end

        -- End callback
        callBack(nil)
    end)
end

return module
