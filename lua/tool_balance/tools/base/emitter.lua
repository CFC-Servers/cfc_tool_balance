-- base/emitter

-- config
local config = {
    delay = { min = 0.5, max = math.huge },
}

-- min and max values for gmod_emitter
local values = {
    {}, -- ply
    {}, -- key
    config.delay
}

local clampMethod = cfcToolBalance.clampMethod
local clampFunction = cfcToolBalance.clampFunction
local callAfter = cfcToolBalance.callAfter

local function wrapEmitter( entTbl )
    MakeEmitter = clampFunction( MakeEmitter, values )

    entTbl.SetupDataTables = callAfter( entTbl.SetupDataTables, function( self, ... )
        self.SetDelay = clampMethod( self.SetDelay, { config.delay } )
    end )
end

cfcToolBalance.waitForSENT( "gmod_emitter", wrapEmitter )
