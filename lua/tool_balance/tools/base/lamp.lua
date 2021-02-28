-- base/lamp

-- config
local config = {
    fov        = { min = 10, max = 170 },
    distance   = { min = 64, max = 2048 },
    brightness = { min = 0, max = 8 },
}

-- min and max values for gmod_lamp
local values = config

local clampMethod = cfcToolBalance.clampMethod

local function wrapLamp()
    local LAMP =  scripted_ents.GetStored( "gmod_lamp" ).t

    LAMP.SetLightFov = clampMethod( LAMP.SetLightFov, {values.fov} )
    LAMP.SetBrightness = clampMethod( LAMP.SetBrightness, {values.brightness} )
    LAMP.SetDistance = clampMethod( LAMP.SetDistance, {values.distance} )

    print( "[CFC_Tool_Balance] base/lamp loaded" )
end

local function waitingFor()
    local ent = scripted_ents.GetStored( "gmod_lamp" )
    return ent and ent.t.UpdateLight ~= nil
end

local function onTimeout()
    print( "[CFC_Tool_Balance] base/lamp failed, waiter timed out" )
end

cfcToolBalance.waitFor( waitingFor, wrapLamp, onTimeout, "base/lamp" )
