--wire/turret

-- config
local config = { 
    delay   = {0.5, math.huge},
    damage  = {0, 20},
    force   = {0, 1},
    numbullets = {0, 1},
    spread = {0, 10}
}

-- min and max values for gmod_wire_turret
local values = { 
    config.delay,  
    config.damage, 
    config.force,  
    {}, --sound
    config.numbullets,
    config.spread
}

local clampFunction = cfcToolBalance.clampFunction

local function wrapWireTurret() 
    local WIRE_TURRET =  scripted_ents.GetStored( "gmod_wire_turret" ).t
    WIRE_TURRET.Setup = clampFunction(WIRE_TURRET.Setup, values)
    print("[cfc_tool_balance] wire/turret loaded")
end

local function waitingFor() 
    local ent = scripted_ents.GetStored( "gmod_wire_turret" ) 
    return ent and ent.t.Setup ~= nil
end

local function onTimout() 
    print("[cfc_tool_balance] wire/turret failed, waiter timed out")
end

cfcToolBalance.waitFor(waitingFor, wrapWireTurret, onTimout )