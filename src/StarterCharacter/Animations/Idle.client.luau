local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- player references
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid: Humanoid = char:WaitForChild("Humanoid")
local animator: Animator = humanoid:WaitForChild("Animator")

-- modules
local configuration = require(ReplicatedStorage.Modules.Configurations.Pickaxe)
local animation = require(ReplicatedStorage.Modules.Animation)

-- currently playing idle animation
local currentIdle: AnimationTrack?

-- stop and clear current idle animation
local function stopCurrentIdle()
	if currentIdle then
		currentIdle:Stop()
		currentIdle = nil
	end
end

-- update idle animation based on equipped tool
local function updateIdle()
	-- find equipped tool
	local tool = char:FindFirstChildWhichIsA("Tool")

	-- no pickaxe equipped
	if not tool or not tool:GetAttribute("Pickaxe") then
		stopCurrentIdle()
		return
	end

	-- get animation data
	local data = configuration.GetDataByName(tool.Name)
	local id = data.AnimationIds.Idle

	-- reuse current idle if it's the same animation
	if currentIdle and currentIdle.Animation.AnimationId == id then
		if not currentIdle.IsPlaying then
			currentIdle:Play()
		end
		return
	end

	-- switch to new idle animation
	stopCurrentIdle()

	local track = animation.Get(animator, id)
	track.Looped = true
	track.Priority = Enum.AnimationPriority.Idle
	track:Play()

	currentIdle = track
end

-- update idle when a tool is equipped
char.ChildAdded:Connect(function(child)
	if child:IsA("Tool") then
		updateIdle()
	end
end)

-- update idle when a tool is removed
char.ChildRemoved:Connect(function(child)
	if child:IsA("Tool") then
		updateIdle()
	end
end)
