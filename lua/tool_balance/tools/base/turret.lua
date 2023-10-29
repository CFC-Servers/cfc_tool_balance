-- config
local config = {
    delay      = { min = 0.1, max = math.huge },
    damage     = { min = 0,   max = 15 },
    force      = { min = 0,   max = 1 },
    numbullets = { min = 0,   max = 1 },
    spread     = { min = 0,   max = 10 }
}

-- min and max values for gmod_turret
local values = config

local clampMethod = cfcToolBalance.clampMethod

local function wrapTurret( entTbl )
    entTbl.SetDelay = clampMethod( entTbl.SetDelay, { values.delay } )
    entTbl.SetDamage = clampMethod( entTbl.SetDamage, { values.damage } )
    entTbl.SetForce = clampMethod( entTbl.SetForce, { values.force } )
    entTbl.SetNumBullets = clampMethod( entTbl.SetNumBullets, { values.numbullets } )
    entTbl.SetSpread = clampMethod( entTbl.SetSpread, { values.spread } )
    entTbl.SetSound = function()
        -- noop
    end
end

cfcToolBalance.waitForSENT( "gmod_turret", wrapTurret )
