print("[cfc_tool_balance] wire/turret loaded")

-- min, max values for gmod_wire_turret
local values = { 
    delay   = {0.5, math.huge},
    damage  = {0, 20},
    force   = {0, 1}
}

local WIRE_TURRET = scripted_ents.GetStored( "gmod_wire_turret" ) 

local function wrapWireTurret() 
    local setup = WIRE_TURRET.t.Setup

    WIRE_TURRET.t.Setup = function(self, delay, damage, force, sound, numbullets, spread, tracer, tracernum) 
        delay  = math.Clamp(delay,  values.delay[1],  values.delay[2])
        damage = math.Clamp(damage, values.damage[1], values.damage[2])
        force  = math.Clamp(damage, values.force[1],  values.force[2])
        
        return setup(self, delay, damage, force, sound, numbullets, spread, tracer, tracernum)
    end
end

local function waitingFor() 
    return WIRE_TURRET.t.Setup ~= nil
end

local function onTimout() 
    print("Turret Wrapper timed out")
end


if Waiter then
    Waiter.waitFor(waitingFor, wrapWireTurret, onTimout )
else
    WaiterQueue = WaiterQueue or {}

    local struct = {}
    struct["waitingFor"] = waitingFor
    struct["onSuccess"] = wrapWireTurret
    struct["onTimeout"] = onTimout

    table.insert( WaiterQueue, struct )
end