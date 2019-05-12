function cfcToolBalance.clampFunction(func, min_max_values) 
    -- takes a function and a list of {min,max} values for each parameter
    -- returns a new function

    local function clamped(self, ...)
        local args = {...}
        
        -- clamp args according to min_max_values
        for i, range in ipairs(min_max_values) do
            min = range[1]
            max = range[2]
            
            if min and max then
                args[i] = math.Clamp(args[i], min, max)
            end
        end

        func(self, unpack(args))
    end

    return clamped
end

function cfcToolBalance.waitFor( waitingFor, onSuccess, onTimout )
    if Waiter then
        Waiter.waitFor(waitingFor, onSuccess, onTimout )
    else
        WaiterQueue = WaiterQueue or {}

        local struct = {
            waitingFor = waitingFor,
            onSuccess = onSuccess,
            onTimeout = onTimout
        }

        table.insert( WaiterQueue, struct )
    end

end