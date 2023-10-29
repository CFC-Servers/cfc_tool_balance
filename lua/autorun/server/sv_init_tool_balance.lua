cfcToolBalance = cfcToolBalance or {}

include( "tool_balance/util.lua" )

-- load all tool files
local baseDir = "tool_balance/tools/"
local _, directories = file.Find( baseDir .. "*", "LUA" )

for _, dir in ipairs( directories ) do
    local files, _ = file.Find( baseDir .. dir .. "/*.lua", "LUA" )
    for _, filename in ipairs( files ) do
        include( baseDir .. dir .. "/" .. filename )
    end
end

-- Autorefresh support
if cfcToolBalance.AutorunLoaded then
    cfcToolBalance.runWrappers()
end

cfcToolBalance.AutorunLoaded = true
