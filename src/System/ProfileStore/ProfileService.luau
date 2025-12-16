local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Modules.Types)
local module = {
    --cache players profile
    Profiles = {}
}

function module.GetProfile(player:Player)
    return module.Profiles[player]
end

function module.GetData(player:Player):Types.Profile_Template
    return module.Profiles[player].Data
end

return module