-- base/emitter

-- config
local config = { 
    delay = { min = 0.5, max = math.huge },
}

-- min and max values for gmod_emitter
local values = {
    {}, --ply
    {}, --key
    config.delay
}

local clampFunction = cfcToolBalance.clampFunction

local function wrapEmitter()
    MakeEmitter = clampFunction(MakeEmitter, values)
    print("[CFC_Tool_Balance] base/emitter loaded")
end

local function waitingFor() 
    return MakeEmitter ~= nil
end

local function onTimout() 
    print("[CFC_Tool_Balance] base/emitter failed, waiter timed out")
end

cfcToolBalance.waitFor(waitingFor, wrapEmitter, onTimout )
