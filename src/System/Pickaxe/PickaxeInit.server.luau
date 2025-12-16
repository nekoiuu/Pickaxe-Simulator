local ReplicatedStorage = game:GetService("ReplicatedStorage")
local attack = require(script.Parent.Attack)
local remote:RemoteEvent = ReplicatedStorage.Remotes.Pickaxe.PickAxeAttack

remote.OnServerEvent:Connect(function(player)
    local char = player.Character or player.CharacterAdded:Wait()
    local tool = char:FindFirstChildWhichIsA("Tool")
    if not tool then return end
    attack.Attack(player,tool)
end)