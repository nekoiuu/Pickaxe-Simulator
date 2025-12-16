local module = {}

local cache = {} -- cache[Animator][AnimationId] = AnimationTrack

function module.Get(animator: Animator, id: string): AnimationTrack
	cache[animator] = cache[animator] or {}

	if not cache[animator][id] then
		local anim = Instance.new("Animation")
		anim.AnimationId = id

		cache[animator][id] = animator:LoadAnimation(anim)
	end

	return cache[animator][id]
end

function module.StopById(animator: Animator, id: string)
	if not cache[animator] then return end

	local track = cache[animator][id]
	if track then
		track:Stop()
	end
end

function module.StopAll(animator: Animator)
	if not cache[animator] then return end

	for _, track in pairs(cache[animator]) do
		track:Stop()
	end
end

return module
