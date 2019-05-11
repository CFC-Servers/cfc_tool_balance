--base/turret

-- min and max values for gmod_turret
local values = { 
    delay   = {0.5, math.huge},
    damage  = {0, 20},
    force   = {0, 1},
    numbullets = {0,1},
    spread = {0,10}
}

local clampFunction = cfcToolBalance.clampFunction

local function wrapTurret() 
    local TURRET =  scripted_ents.GetStored( "gmod_turret" ).t
    
    TURRET.SetDelay = clampFunction(TURRET.SetDelay, {values.delay})
    TURRET.SetDamage = clampFunction(TURRET.SetDamage, {values.damage})
    TURRET.SetForce = clampFunction(TURRET.SetForce, {values.force})
    TURRET.SetNumBullets = clampFunction(TURRET.SetNumBullets, {values.numbullets})
    TURRET.SetSpread = clampFunction(TURRET.SetSpread , {values.spread})

    print("[cfc_tool_balance] base/turret loaded")
end

local function waitingFor() 
    local ent = scripted_ents.GetStored( "gmod_turret" ) 
    return ent and ent.t.SetDamage ~= nil
end

local function onTimout() 
    print("[cfc_tool_balance] base/turret failed, waiter timed out")
end


if Waiter then
    Waiter.waitFor(waitingFor, wrapTurret, onTimout )
else
    WaiterQueue = WaiterQueue or {}

    local struct = {
        waitingFor = waitingFor,
        onSuccess = wrapTurret,
        onTimeout = onTimout
    }

    table.insert( WaiterQueue, struct )
end
