--wire/explosive
cfcToolBalance.canDealDamage["gmod_wire_explosive"] = true

-- config
local config = {
    damage          = { min = 0, max = 100 },
    radius          = { min = 0, max = 500 },
    delayreloadtime = { min = 5, max = math.huge }
}

local EXPLOSIVE_WAIT_PERIOD = 5

-- min and max values for gmod_wire_explosive
local values = {
    {}, --key
    config.damage,
    {}, --delaytime
    {}, --removeafter
    config.radius,
    {}, --affectother
    {}, --notaffected
    config.delayreloadtime
}

local clampMethod = cfcToolBalance.clampMethod

local function wrapWireExplosive()
    local WIRE_EXPLOSIVE = scripted_ents.GetStored( "gmod_wire_explosive" ).t
    WIRE_EXPLOSIVE.Setup = clampMethod( WIRE_EXPLOSIVE.Setup, values )

    local explode = WIRE_EXPLOSIVE.Explode
    WIRE_EXPLOSIVE.Explode = function( self, ... )
        local age = CurTime() - self:GetCreationTime()
        if age < EXPLOSIVE_WAIT_PERIOD then return end

        explode( self, ... )
    end

    print( "[CFC_Tool_Balance] wire/explosive loaded" )
end

local function waitingFor()
    local ent = scripted_ents.GetStored( "gmod_wire_explosive" )
    return ent and ent.t.Setup ~= nil
end

local function onTimeout()
    print( "[CFC_Tool_Balance] wire/explosive failed, waiter timed out" )
end

cfcToolBalance.waitFor( waitingFor, wrapWireExplosive, onTimeout )
