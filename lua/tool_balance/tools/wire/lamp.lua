-- wire/lamp

-- config
local config = {
    distance = { min = 64, max = 2048 },
}

-- min and max values for gmod_wire_lamp
local values = config

local callAfter = cfcToolBalance.callAfter

local function clampWireLampDistance( self, ... ) -- Wire lamps don't have a :SetDistance() function of any kind, making the clamping process abnormal
    self.Dist = math.Clamp( self.Dist or 0, values.distance.min, values.distance.max )
end

local function wrapWireLamp()
    local WIRE_LAMP =  scripted_ents.GetStored( "gmod_wire_lamp" ).t

    WIRE_LAMP.UpdateLight = callAfter( clampWireLampDistance, WIRE_LAMP.UpdateLight )

    print( "[CFC_Tool_Balance] wire/lamp loaded" )
end

local function waitingFor()
    local ent = scripted_ents.GetStored( "gmod_wire_lamp" )
    return ent and ent.t.UpdateLight ~= nil
end

local function onTimeout()
    print( "[CFC_Tool_Balance] wire/lamp failed, waiter timed out" )
end

cfcToolBalance.waitFor( waitingFor, wrapWireLamp, onTimeout, "wire/lamp" )
