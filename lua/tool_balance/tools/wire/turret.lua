-- config
local config = {
    delay      = { min = 0.05, max = math.huge },
    damage     = { min = 0, max = 5 },
    force      = { min = 0, max = 1 },
    numbullets = { min = 0, max = 1 },
    spread     = { min = 0.02, max = 10 }
}

-- min and max values for gmod_wire_turret
local values = {
    config.delay,
    config.damage,
    config.force,
    {}, -- sound
    config.numbullets,
    config.spread
}

local clampMethod = cfcToolBalance.clampMethod

local function wrapWireTurret( entTbl )
    entTbl.Setup = clampMethod( entTbl.Setup, values )

    entTbl.SetDelay = clampMethod( entTbl.SetDelay, { config.delay } )
    entTbl.SetForce = clampMethod( entTbl.SetForce, { config.force } )
    entTbl.SetDamage = clampMethod( entTbl.SetDamage, { config.damage } )
    entTbl.SetNumBullets = clampMethod( entTbl.SetNumBullets, { config.numbullets } )
    entTbl.SetSpread = clampMethod( entTbl.SetSpread, { config.spread } )

    entTbl.SetSound = function()
        -- nope
    end
end

cfcToolBalance.waitForSENT( "gmod_wire_turret", wrapWireTurret )
