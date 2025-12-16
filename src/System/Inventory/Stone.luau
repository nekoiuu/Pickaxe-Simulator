-- ReplicatedStorage services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Stone remotes
local remotes: Folder = ReplicatedStorage.Remotes.Stone
local GetData: RemoteFunction = remotes.GetData

-- Profile store
local ProfileStoreStone = require(script.Parent.Parent.ProfileStore.Stone)

local module = {}

-- Initialize remote handlers
function module.Init()
    -- Get player stone data
    GetData.OnServerInvoke = function(player: Player)
        local data

        -- Wait until profile data is available
        repeat
            pcall(function()
                data = ProfileStoreStone.GetData(player)
            end)
            task.wait()
        until data

        return data
    end
end

return module
