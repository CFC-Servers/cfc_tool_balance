-- base/lamp

-- config
local config = {
    fov        = { min = 10, max = 170 },
    distance   = { min = 64, max = 1024 },
    brightness = { min = 0, max = 3 },
}

-- min and max values for gmod_lamp
local values = config

local callAfter = cfcToolBalance.callAfter
local IsValid = IsValid

local function clampLamp( self, ... ) -- The setter functions for lamps get overridden by ENT.NetworkVar, so we cannot just wrap those functions and call it a day
    self:SetLightFOV( math.Clamp( self.fov or 0, values.fov.min, values.fov.max ) )
    self:SetDistance( math.Clamp( self.distance or 0, values.distance.min, values.distance.max ) )
    self:SetBrightness( math.Clamp( self.brightness or 0, values.brightness.min, values.brightness.max ) )
end

local function wrapLamp()
    local LAMP = scripted_ents.GetStored( "gmod_lamp" ).t

    LAMP.UpdateLight = callAfter( LAMP.UpdateLight, clampLamp )

    hook.Add( "OnEntityCreated", "CFCToolBalanceClampLamp", function( ent )
        if not IsValid( ent ) then return end
        if ent:GetClass() ~= "gmod_lamp" then return end

        timer.Simple( 0.1, function()
            if not IsValid( ent ) then return end

            clampLamp( ent )
        end )
    end )

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
