--wire/explosive
cfcToolBalance.tools["gmod_wire_explosive"] = true

-- config
local config = { 
    damage          = { min = 0, max = 100 },
    radius          = { min = 0, max = 500 },
    delayreloadtime = { min = 5, max = math.huge }
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
    
    print("[CFC_Tool_Balance] wire/explosive loaded")
end

local function waitingFor() 
    local ent = scripted_ents.GetStored( "gmod_wire_explosive" ) 
    return ent and ent.t.Setup ~= nil
end

local function onTimout() 
    print("[CFC_Tool_Balance] wire/explosive failed, waiter timed out")
end

cfcToolBalance.waitFor(waitingFor, wrapWireExplosive, onTimout )
