-- base/turret
cfcToolBalance.canDealDamage["gmod_turret"] = true

-- config
local config = { 
    delay      = { min = 0.5, max = math.huge },
    damage     = { min = 0,   max = 20 },
    force      = { min = 0,   max = 1 },
    numbullets = { min = 0,   max = 1 },
    spread     = { min = 0,   max = 10 }
}

-- min and max values for gmod_turret
local values = config

local clampFunction = cfcToolBalance.clampFunction

local function wrapTurret() 
    local TURRET =  scripted_ents.GetStored( "gmod_turret" ).t
    
    TURRET.SetDelay = clampFunction(TURRET.SetDelay, {values.delay})
    TURRET.SetDamage = clampFunction(TURRET.SetDamage, {values.damage})
    TURRET.SetForce = clampFunction(TURRET.SetForce, {values.force})
    TURRET.SetNumBullets = clampFunction(TURRET.SetNumBullets, {values.numbullets})
    TURRET.SetSpread = clampFunction(TURRET.SetSpread , {values.spread})

    print("[CFC_Tool_Balance] base/turret loaded")
end

local function waitingFor() 
    local ent = scripted_ents.GetStored( "gmod_turret" ) 
    return ent and ent.t.SetDamage ~= nil
end

local function onTimout() 
    print("[CFC_Tool_Balance] base/turret failed, waiter timed out")
end

cfcToolBalance.waitFor(waitingFor, wrapTurret, onTimout )
