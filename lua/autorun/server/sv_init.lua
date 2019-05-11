-- load all tool files
local baseDir = "tool_balance/"
local _, directories = file.Find( baseDir .. "*", "LUA")

for _, dir in ipairs(directories) do 
    local files, _ = file.Find(baseDir..dir.."/*.lua", "LUA") 
    for _, file in ipairs(files) do
        include(baseDir..dir.."/"..file)
    end
end
