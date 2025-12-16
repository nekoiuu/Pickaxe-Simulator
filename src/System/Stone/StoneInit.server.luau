local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stones:Folder = workspace.Stones
local stoneModule = require(script.Parent.Stone)
local configuration = require(ReplicatedStorage.Modules.Configurations.Stone)

for _,stone:Model in ipairs(Stones:GetChildren()) do
    stoneModule.new(stone,configuration.GetDataByName(stone.Name))
end
