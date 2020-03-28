local function count( tbl )
    local keys = table.GetKeys( tbl )
    return keys[#keys]
end

function cfcToolBalance.clampFunction( func, min_max_values )
    -- takes a function and a list of {min, max} values for each parameter
    -- returns a new function

    local function clamped( ... )
        local args = {...}

        -- clamp args according to min_max_values
        for i, range in ipairs( min_max_values ) do
            if range.min and range.max then
                args[i] = math.Clamp( args[i], range.min, range.max )
            end
        end

        local endIndex = count( args )
        return func( unpack( args, 1, endIndex ) )
    end

    return clamped
end

function cfcToolBalance.clampMethod( func, min_max_values )
    table.insert( min_max_values, 1, {} )
    return cfcToolBalance.clampFunction( func, min_max_values )
end

function cfcToolBalance.callAfter( func, afterFunc )
    local function wrapped( ... )
        local out = func( ... )
        afterFunc( ... )
        return out
    end
    return wrapped
end

function cfcToolBalance.waitFor( waitingFor, onSuccess, onTimout )
    Waiter.waitFor( waitingFor, onSuccess, onTimout )
end
