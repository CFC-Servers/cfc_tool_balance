
-- min, max values for gmod_wire_turret
local values = { 
    damage  = {0, 100},
    radius  = {0, 500},
    delayreloadtime = {5, math.huge}
}



local function wrapWireExplosive() 
    local WIRE_EXPLOSIVE = scripted_ents.GetStored( "gmod_wire_explosive" ) 
    local setup = WIRE_EXPLOSIVE.t.Setup
    WIRE_EXPLOSIVE.t.Setup = function(self, key, damage, delaytime, removeafter, radius, affectother, notaffected, delayreloadtime, maxhealth, bulletproof, explosionproof, fallproof, explodeatzero, resetatexplode, fireeffect, coloreffect, invisibleatzero )
        damage          = math.Clamp(damage, values.damage[1], values.damage[2])
        radius          = math.Clamp(radius, values.radius[1], values.radius[2])
        delayreloadtime = math.Clamp(delayreloadtime, values.delayreloadtime[1], values.delayreloadtime[2])
        return setup(self, key, damage, delaytime, removeafter, radius, affectother, notaffected, delayreloadtime, maxhealth, bulletproof, explosionproof, fallproof, explodeatzero, resetatexplode, fireeffect, coloreffect, invisibleatzero )
    end
    print("[cfc_tool_balance] wire/explosive loaded")
end

local function waitingFor() 
    local ent = scripted_ents.GetStored( "gmod_wire_explosive" ) 
    return ent and ent.t.Setup ~= nil
end

local function onTimout() 
    print("[cfc_tool_balance] wire/explosive failed, waiter timed out")
end


if Waiter then
    Waiter.waitFor(waitingFor, wrapWireExplosive, onTimout )
else
    WaiterQueue = WaiterQueue or {}

    local struct = {
        waitingFor = waitingFor,
        onSuccess = wrapWireExplosive,
        onTimeout = onTimout
    }

    table.insert( WaiterQueue, struct )
end