cfcToolBalance = {}
cfcToolBalance.tools = {}

include("tool_balance/util.lua")

-- load all tool files
local baseDir = "tool_balance/tools/"
local _, directories = file.Find( baseDir .. "*", "LUA")

for _, dir in ipairs(directories) do 
    local files, _ = file.Find(baseDir..dir.."/*.lua", "LUA") 
    for _, file in ipairs(files) do
        include(baseDir..dir.."/"..file)
    end
end

-- allow turrets to do damage while apg "Allow Prop Killing" is off
hook.Remove("APGisBadEnt", "CFCToolIsBalanced")
hook.Add("APGisBadEnt", "CFCToolIsBalanced", function(ent)
    if not IsValid(ent) then return end

    local class = ent:GetClass()
    local isBalancedTool = cfcToolBalance.tools[class] 
    if isBalancedTool == nil then return end
    
    return not isBalancedTool
end)
