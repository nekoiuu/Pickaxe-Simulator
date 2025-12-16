local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(script.Parent.Parent.Types)
local Tools:Folder = ReplicatedStorage.Tools.Pickaxes
--local Animations:Folder = ReplicatedStorage.Assets.Animations.Pickaxe
local module = {}
local PickaxeData = {}


function module.GetDataByName(name:string):Types.PickaxeData?
    return PickaxeData[name]
end

function CreateData(data:Types.PickaxeData)
    PickaxeData[data.Name] = data
end

local defaultData:Types.PickaxeData = {
    Name = "DefaultPickaxe",
    Damage = 30,
    CoolDown = 0.8,
    Tool = Tools:FindFirstChild("DefaultPickaxe"),
    ImageId = "rbxassetid://4503278227",
    AnimationIds = {
        Idle = "rbxassetid://82088326989557",
        Attack = "rbxassetid://116349465662023"
    }
}

CreateData(defaultData)

return module