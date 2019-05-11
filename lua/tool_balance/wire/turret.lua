--wire/turret

-- min and max values for gmod_wire_turret
local values = { 
    delay   = {0.5, math.huge},
    damage  = {0, 20},
    force   = {0, 1},
    numbullets = {0,1},
    spread = {0,10}
}



local function wrapWireTurret() 
    local WIRE_TURRET =  scripted_ents.GetStored( "gmod_wire_turret" )
    local setup = WIRE_TURRET.t.Setup

    WIRE_TURRET.t.Setup = function(self, delay, damage, force, sound, numbullets, spread, tracer, tracernum)
        delay  = math.Clamp(delay,  values.delay[1],  values.delay[2])
        damage = math.Clamp(damage, values.damage[1], values.damage[2])
        force  = math.Clamp(damage, values.force[1],  values.force[2])
        numbullets = math.Clamp(numbullets, values.numbullets[1], values.numbullets[2])
        spread = math.Clamp(spread, values.spread[1], values.spread[2])
        
        return setup(self, delay, damage, force, sound, numbullets, spread, tracer, tracernum)
    end
    print("[cfc_tool_balance] wire/turret loaded")
end

local function waitingFor() 
    local ent = scripted_ents.GetStored( "gmod_wire_turret" ) 
    return ent and ent.t.Setup ~= nil
end

local function onTimout() 
    print("[cfc_tool_balance] wire/turret failed, waiter timed out")
end


if Waiter then
    Waiter.waitFor(waitingFor, wrapWireTurret, onTimout )
else
    WaiterQueue = WaiterQueue or {}

    local struct = {
        waitingFor = waitingFor,
        onSuccess = wrapWireTurret,
        onTimeout = onTimout
    }

    table.insert( WaiterQueue, struct )
end
