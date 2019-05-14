--wire/turret
cfcToolBalance.canDamage["gmod_wire_turret"] = true

-- config
local config = { 
    delay      = { min = 0.5, max = math.huge },
    damage     = { min = 0,   max = 20 },
    force      = { min = 0,   max = 1 },
    numbullets = { min = 0,   max = 1 },
    spread     = { min = 0,   max = 10 }
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
    print("[CFC_Tool_Balance] wire/turret loaded")
end

local function waitingFor() 
    local ent = scripted_ents.GetStored( "gmod_wire_turret" ) 
    return ent and ent.t.Setup ~= nil
end

local function onTimout() 
    print("[CFC_Tool_Balance] wire/turret failed, waiter timed out")
end

cfcToolBalance.waitFor(waitingFor, wrapWireTurret, onTimout )
