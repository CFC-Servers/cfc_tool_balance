-- config
local config = {
    fov        = { min = 10, max = 170 },
    distance   = { min = 64, max = 1024 },
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

local function wrapWireLamp( entTbl )
    entTbl.UpdateLight = callAfter( clampWireLamp, entTbl.UpdateLight )
end

cfcToolBalance.waitForSENT( "gmod_wire_lamp", wrapWireLamp )
