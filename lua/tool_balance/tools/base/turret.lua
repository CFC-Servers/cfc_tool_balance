-- base/turret
cfcToolBalance.canDealDamage["gmod_turret"] = true

-- config
local config = {
    delay      = { min = 0.05, max = math.huge },
    damage     = { min = 0,   max = 20 },
    force      = { min = 0,   max = 1 },
    numbullets = { min = 0,   max = 1 },
    spread     = { min = 0,   max = 10 }
}

-- min and max values for gmod_turret
local values = config

local clampMethod = cfcToolBalance.clampMethod

local function wrapTurret()
    local TURRET =  scripted_ents.GetStored( "gmod_turret" ).t

    TURRET.SetDelay = clampMethod( TURRET.SetDelay, {values.delay} )
    TURRET.SetDamage = clampMethod( TURRET.SetDamage, {values.damage} )
    TURRET.SetForce = clampMethod( TURRET.SetForce, {values.force} )
    TURRET.SetNumBullets = clampMethod( TURRET.SetNumBullets, {values.numbullets} )
    TURRET.SetSpread = clampMethod( TURRET.SetSpread , {values.spread} )

    print( "[CFC_Tool_Balance] base/turret loaded" )
end

local function waitingFor()
    local ent = scripted_ents.GetStored( "gmod_turret" )
    return ent and ent.t.SetDamage ~= nil
end

local function onTimeout()
    print( "[CFC_Tool_Balance] base/turret failed, waiter timed out" )
end

cfcToolBalance.waitFor(waitingFor, wrapTurret, onTimeout )
