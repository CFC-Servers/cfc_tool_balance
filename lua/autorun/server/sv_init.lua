cfcToolBalance = {}

function cfcToolBalance.clampFunction(func, min_max_values) 
    -- takes a function and a list of {min,max} values for each parameter
    -- returns a new function

    local function clamped(self, ...)
        local args = {...}
        
        -- clamp args according to min_max_values
        for i, range in ipairs(min_max_values) do
            local min, max
            if range then
                min = range[1]
                max = range[2]
            end
            
            if min and max then
                args[i] = math.Clamp(args[i], min, max)
            end
        end
        
        func(self, unpack(args))
    end
    
    return clamped
end

-- load all tool files
local baseDir = "tool_balance/"
local _, directories = file.Find( baseDir .. "*", "LUA")

for _, dir in ipairs(directories) do 
    local files, _ = file.Find(baseDir..dir.."/*.lua", "LUA") 
    for _, file in ipairs(files) do
        include(baseDir..dir.."/"..file)
    end
end
