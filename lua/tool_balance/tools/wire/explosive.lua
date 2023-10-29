-- config
local config = {
    damage          = { min = 0, max = 100 },
    radius          = { min = 0, max = 500 },
    delayreloadtime = { min = 5, max = math.huge }
}

local EXPLOSIVE_WAIT_PERIOD = 5

-- min and max values for gmod_wire_explosive
local values = {
    {}, -- key
    config.damage,
    {}, -- delaytime
    {}, -- removeafter
    config.radius,
    {}, -- affectother
    {}, -- notaffected
    config.delayreloadtime
}

local clampMethod = cfcToolBalance.clampMethod

local function wrapWireExplosive( entTbl )
    entTbl.Setup = clampMethod( entTbl.Setup, values )

    local explode = entTbl.Explode
    entTbl.Explode = function( self, ... )
        local age = CurTime() - self:GetCreationTime()
        if age < EXPLOSIVE_WAIT_PERIOD then return end

        explode( self, ... )
    end
end

cfcToolBalance.waitForSENT( "gmod_wire_explosive", wrapWireExplosive )
