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

local function wrapLamp( entTbl )
    entTbl.UpdateLight = callAfter( clampLamp, entTbl.UpdateLight )

    hook.Add( "OnEntityCreated", "CFCToolBalanceClampLamp", function( ent )
        if not IsValid( ent ) then return end
        if ent:GetClass() ~= "gmod_lamp" then return end

        timer.Simple( 0, function()
            if not IsValid( ent ) then return end

            clampLamp( ent )
        end )
    end )
end

cfcToolBalance.waitForSENT( "gmod_lamp", wrapLamp )
