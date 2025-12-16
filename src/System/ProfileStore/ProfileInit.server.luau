-- Roblox services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Profile system modules
local ProfileStore = require(script.Parent.ProfileStore)
local ProfilesService = require(script.Parent.ProfileService)
local Types = require(ReplicatedStorage.Modules.Types)

-- Game modules
local Pickaxes = require(script.Parent.Pickaxe)

-- Return datastore name (Test in Studio, Live in game)
function getStoreName()
    return RunService:IsStudio() and "Test" or "Live"
end

-- Create leaderstats for the player
function SetUpLeaderstats(player: Player, Data: Types.Profile_Template)
    local leaderstats = Instance.new("Folder", player)
    leaderstats.Name = "leaderstats"

    local money = Instance.new("NumberValue", leaderstats)
    money.Name = "Money"
    money.Value = Data.Money
end

-- Default profile data
local PROFILE_TEMPLATE: Types.Profile_Template = {
    Money = 50,
    Inventory = {
        Pickaxes = {},
        Stones = {},
    }
}

-- Create ProfileStore
local PlayerStore = ProfileStore.New(getStoreName(), PROFILE_TEMPLATE)
type Profile = typeof(PlayerStore:StartSessionAsync())

-- Store active profiles
ProfilesService.Profiles = {} :: {[Player]: Profile}

-- Handle player joining
function PlayerAdded(player: Player)

    -- Start profile session
    local profile = PlayerStore:StartSessionAsync(`{player.UserId}`, {
        Canlce = function()
            return player.Parent ~= Players
        end
    })

    if profile ~= nil then
        profile:AddUserId(player.UserId)
        profile:Reconcile()

        -- Handle session end
        profile.OnSessionEnd:Connect(function()
            ProfilesService.Profiles[player] = nil
            player:Kick("Profile session end Please rejoin")
        end)

        if player.Parent == Players then
            ProfilesService.Profiles[player] = profile
            SetUpLeaderstats(player, profile.Data)
            print(`Profile Loaded for {player.DisplayName}!`)
        else
            profile:EndSession()
        end
    else
        player:Kick("Profile load fail - Please rejoin")
    end
end

-- Load profiles for players already in server
for _, player in pairs(Players:GetPlayers()) do
    task.spawn(PlayerAdded, player)
end

-- Player join event
Players.PlayerAdded:Connect(PlayerAdded)

-- Player leave event
Players.PlayerRemoving:Connect(function(player)
    local profile = ProfilesService.Profiles[player]
    if profile ~= nil then
        profile:EndSession()
    end
end)
