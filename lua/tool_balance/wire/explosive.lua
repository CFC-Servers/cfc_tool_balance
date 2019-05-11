print("[cfc_tool_balance] wire/explosive loaded")

-- min, max values for gmod_wire_turret
local values = { 
    damage  = {0, 20},
    radius  = {0, 500},
    delayreloadtime = {5,math.huge}
}

local WIRE_EXPLOSIVE = scripted_ents.GetStored( "gmod_wire_explosive" ) 

local function wrapWireExplosive() 
    local setup = WIRE_EXPLOSIVE.t.Setup
    WIRE_EXPLOSIVE.t.Setup = function(self, key, damage, delaytime, removeafter, radius, affectother, otaffected, delayreloadtime, maxhealth, bulletproof, explosionproof, fallproof, explodeatzero, resetatexplode, fireeffect, coloreffect, invisibleatzero )
    
        damage          = math.Clamp(damage, values.damage[0], values.damage[1])
        radius          = math.Clamp(radius, values.radius[0], values.radius[1])
        delayreloadtime = math.Clamp(delayreloadtime, values.delayreloadtime[0], values.delayreloadtime[1])
        return setup(self, key, damage, delaytime, removeafter, radius, affectother, notaffected, delayreloadtime, maxhealth, bulletproof, explosionproof, fallproof, explodeatzero, resetatexplode, fireeffect, coloreffect, invisibleatzero )
    end
end

local function waitingFor() 
    return WIRE_EXPLOSIVE.t.Setup ~= nil
end

local function onTimout() 
    print("Wire Explosive Wrapper timed out")
end


if Waiter then
    Waiter.waitFor(waitingFor, wrapWireExplosive, onTimout )
else
    WaiterQueue = WaiterQueue or {}

    local struct = {}
    struct["waitingFor"] = waitingFor
    struct["onSuccess"] = wrapWireExplosive
    struct["onTimeout"] = onTimout

    table.insert( WaiterQueue, struct )
end