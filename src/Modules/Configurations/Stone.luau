local Types = require(script.Parent.Parent.Types)
local module = {}
local StoneData = {}

function module.GetDataByName(name:string):Types.StoneData?
    return StoneData[name]
end

function CreateData(data:Types.StoneData)
    StoneData[data.Name] = data
end

local default:Types.StoneData = {
    Name = "NormalStone",
    Health = 100,
    MaxHealth = 100,
    ImageId = "rbxassetid://95808328618041",
    Drop = {
        Name = "NormalStone",
        Amount = 10
    },
}

CreateData(default)

return module