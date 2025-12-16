-- Initialize all ModuleScripts under this script
for _, item in ipairs(script.Parent:GetChildren()) do
    if item:IsA("ModuleScript") then
        local module = require(item)

        -- Call Init function if exists
        if module.Init then
            module.Init()
        end
    end
end
