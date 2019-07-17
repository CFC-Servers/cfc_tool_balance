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

local function wrapEmitter()
    MakeEmitter = clampFunction( MakeEmitter, values )

    local EMITTER =  scripted_ents.GetStored( "gmod_emitter" ).t
    EMITTER.SetupDataTables = callAfter( EMITTER.SetupDataTables, function( self, ... )
        self.SetDelay = clampMethod( self.SetDelay, {config.delay} )
    end )

    print( "[CFC_Tool_Balance] base/emitter loaded" )
end

local function waitingFor()
    local ent =  scripted_ents.GetStored( "gmod_emitter"  )
    if not ent then return false end
    return MakeEmitter ~= nil and ent.t.SetupDataTables ~= nil
end

local function onTimeout()
    print( "[CFC_Tool_Balance] base/emitter failed, waiter timed out" )
end

cfcToolBalance.waitFor( waitingFor, wrapEmitter, onTimeout, "emitter" )
