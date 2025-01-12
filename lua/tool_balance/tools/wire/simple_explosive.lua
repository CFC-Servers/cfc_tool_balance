-- config
local config = {
    damage          = { min = 0, max = 100 },
    radius          = { min = 0, max = 500 },
}

-- min and max values for gmod_wire_explosive
local values = {
    {}, -- key
    config.damage,
    {}, -- removeafter
    config.radius,
}

local clampMethod = cfcToolBalance.clampMethod

local function wrapWireExplosive( entTbl )
    entTbl.Setup = clampMethod( entTbl.Setup, values )
end

cfcToolBalance.waitForSENT( "gmod_wire_simple_explosive", wrapWireExplosive )
