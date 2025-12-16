-- player references
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid: Humanoid = char:FindFirstChild("Humanoid")
local Animator: Animator = humanoid:WaitForChild("Animator")

-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- remote event
local remote: RemoteEvent = ReplicatedStorage.Remotes.Pickaxe:WaitForChild("PickAxeAttack")

-- modules
local animation = require(ReplicatedStorage.Modules.Animation)
local configuration = require(ReplicatedStorage.Modules.Configurations.Pickaxe)

-- handle player input
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    -- ignore input if already handled by UI
    if gameProcessedEvent then return end

    -- check if player is holding a pickaxe tool
    local foundTool = char:FindFirstChildWhichIsA("Tool")
    if not foundTool or not foundTool:GetAttribute("Pickaxe") then return end

    -- left mouse click
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        
        -- get tool configuration data
        local toolData = configuration.GetDataByName(foundTool.Name)

        -- cooldown check
        if tick() - foundTool:GetAttribute("LastSwing") < toolData.CoolDown then return end
        foundTool:SetAttribute("LastSwing", tick())
        
        -- play attack animation
        local track = animation.Get(Animator, toolData.AnimationIds.Attack)
        track.Looped = false
        if track.IsPlaying then track:Stop() end
        track:Play()

        -- notify server about attack
        remote:FireServer()
    end
end)
