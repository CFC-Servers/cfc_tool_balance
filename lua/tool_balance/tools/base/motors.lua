local math_min = math.min
local maxScale = 1000000

local entMeta = FindMetaTable( "Entity" )
entMeta._CFC_ToolBalance_Fire = entMeta._CFC_ToolBalance_Fire or entMeta.Fire

function entMeta:Fire( input, param, delay, activator, caller )
    if self:GetClass() == "phys_torque" then
        if input == "Scale" then
            param = math_min( maxScale, param )
        end
    end

    return self:_CFC_ToolBalance_Fire( input, param, delay, activator, caller )
end
