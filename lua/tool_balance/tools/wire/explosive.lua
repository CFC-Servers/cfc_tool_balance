--wire/explosive

-- config
local config = { 
    damage = {0,100},
    radius = {0, 500},
    delayreloadtime = {5, math.huge}
}

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

local clampFunction = cfcToolBalance.clampFunction

local function wrapWireExplosive() 
    local WIRE_EXPLOSIVE = scripted_ents.GetStored( "gmod_wire_explosive" ).t
    WIRE_EXPLOSIVE.Setup = clampFunction(WIRE_EXPLOSIVE.Setup, values)
    
    print("[cfc_tool_balance] wire/explosive loaded")
end

local function waitingFor() 
    local ent = scripted_ents.GetStored( "gmod_wire_explosive" ) 
    return ent and ent.t.Setup ~= nil
end

local function onTimout() 
    print("[cfc_tool_balance] wire/explosive failed, waiter timed out")
end

cfcToolBalance.waitFor(waitingFor, wrapWireExplosive, onTimout )

