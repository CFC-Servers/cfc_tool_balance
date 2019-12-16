-- simfphys/geareditor

-- config
local config = {
    numgears = { min = 0, max = 12 },
}

local function wrapGearEditor()
    local tools = weapons.GetStored( "gmod_tool" ).Tool
    local simfphysgeareditor = tools["simfphysgeareditor"]
    local _GetClientInfo = simfphysgeareditor.GetClientInfo

    simfphysgeareditor.GetClientInfo = function( self, name, ... )
        local value = _GetClientInfo( self, name, ... )
        if not config[name] then return value end

        local numValue = tonumber( value )
        numValue = math.Clamp( numValue, config[name].min, config[name].max )
        value = tostring( numValue )
        return value
    end
    print( "[CFC_Tool_Balance] simfphys/geareditor loaded" )
end

local function waitingFor()
    local simfphysgeareditor = weapons.GetStored( "gmod_tool" ).Tool["simfphysgeareditor"]
    return simfphysgeareditor ~= nil
end

local function onTimeout()
    print( "[CFC_Tool_Balance] simfphys/geareditor failed, waiter timed out" )
end

cfcToolBalance.waitFor( waitingFor, wrapGearEditor, onTimeout, "simfphys/geareditor" )
