-- wire/lamp

-- config
local config = {
    fov = { min = 10, max = 170 },
    distance = { min = 64, max = 1024 },
    brightness = { min = 0, max = 3 },
}

-- min and max values for gmod_wire_lamp
local values = config

local callAfter = cfcToolBalance.callAfter

local function clampWireLamp( self, ... ) -- Wire lamps don't have setter functions of any kind for these values
    self.FOV = math.Clamp( self.FOV or 0, values.fov.min, values.fov.max )
    self.Dist = math.Clamp( self.Dist or 0, values.distance.min, values.distance.max )
    self.Brightness = math.Clamp( self.Brightness or 0, values.brightness.min, values.brightness.max )
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
