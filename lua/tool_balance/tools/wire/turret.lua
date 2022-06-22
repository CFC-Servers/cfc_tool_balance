-- wire/turret config
local config = {
    dynamicLimit  = true, -- Whether or not to use DPS calculations to clamp delay, damage, numbullets, and spread to a min/max DPS value and to each value's hard min/max
    dps           = { min = 0.01, max = 300 },
    delay         = { min = 0.05, max = 10 },
    damage        = { min = 1,    max = 200 },
    force         = { min = 0,    max = 200 },
    numbullets    = { min = 1,    max = 15 },
    spread        = { min = 0,    max = 1 }, -- Never set outside of the 0-1 range
    spreadDPSMult = { min = 0.1,  max = 1 } -- How spread affects DPS calculations from max spread (imprecise; min spreadMult) to min spread (precise; max spreadMult)
}

if SERVER then
    cfcToolBalance.canDealDamage["gmod_wire_turret"] = true
elseif not config.dynamicLimit then return end

-- min and max values for gmod_wire_turret
local values = {
    config.delay,
    config.damage,
    config.force,
    {}, -- sound
    config.numbullets,
    config.spread
}

local minF = math.min
local maxF = math.max
local floorF = math.floor
local clampF = math.Clamp

local WIRE_TURRET_DELAY
local WIRE_TURRET_DAMAGE
local WIRE_TURRET_NUMBULLETS
local WIRE_TURRET_SPREAD

if CLIENT then
    WIRE_TURRET_DELAY = GetConVar( "wire_turret_delay" )
    WIRE_TURRET_DAMAGE = GetConVar( "wire_turret_damage" )
    WIRE_TURRET_NUMBULLETS = GetConVar( "wire_turret_numbullets" )
    WIRE_TURRET_SPREAD = GetConVar( "wire_turret_spread" )
end

local function dpsMultDelay( self, forceVal )
    local delayLim = config.delay
    local delay = forceVal or ( SERVER and ( self.delay or 1 ) ) or WIRE_TURRET_DELAY:GetFloat()

    delay = clampF( delay, delayLim.min, delayLim.max )

    return 1 / delay
end

local function dpsMultDamage( self, forceVal )
    local damageLim = config.damage
    local damage = forceVal or ( SERVER and ( self.damage or 1 ) ) or WIRE_TURRET_DAMAGE:GetFloat()

    damage = clampF( damage, damageLim.min, damageLim.max )

    return damage
end

local function dpsMultNumbullets( self, forceVal )
    local numLim = config.numbullets
    local numbullets = forceVal or ( SERVER and ( self.numbullets or 1 ) ) or WIRE_TURRET_NUMBULLETS:GetInt()

    numbullets = clampF( floorF( numbullets ), numLim.min, numLim.max )

    return numbullets
end

local function dpsMultSpread( self, forceVal )
    local spreadLim = config.spread
    local spreadMultLim = config.spreadDPSMult
    local spread = forceVal or ( SERVER and ( self.spread or 0 ) ) or WIRE_TURRET_SPREAD:GetFloat()

    spread = clampF( spread, spreadLim.min, spreadLim.max )
    local spreadMult = spreadMultLim.max + ( spreadMultLim.min - spreadMultLim.max ) * spread

    return spreadMult
end

local dpsFuncs = {
    delay = dpsMultDelay,
    damage = dpsMultDamage,
    numbullets = dpsMultNumbullets,
    spread = dpsMultSpread
}

local function getDPSMult( self, exclude )
    local mult = 1

    for varName, func in pairs( dpsFuncs ) do
        if varName ~= exclude then
            mult = mult * func( self )
        end
    end

    return mult
end

local function getDPSMultLim( self, varName )
    local dpsLim = config.dps
    local curDPS = maxF( getDPSMult( self, varName ), 0.0001 )
    local dpsMultMin = dpsLim.min / curDPS
    local dpsMultMax = dpsLim.max / curDPS

    return dpsMultMin, dpsMultMax
end

local function dclampDelay( self, val )
    local dpsMultMin, dpsMultMax = getDPSMultLim( self, "delay" )
    local delayLim = config.delay

    local delay = clampF( val, 1 / dpsMultMax, 1 / dpsMultMin )

    delay = clampF( delay, delayLim.min, delayLim.max )

    return delay
end

local function dclampDamage( self, val )
    local dpsMultMin, dpsMultMax = getDPSMultLim( self, "damage" )
    local damageLim = config.damage

    local damage = clampF( val, dpsMultMin, dpsMultMax )

    damage = clampF( damage, damageLim.min, damageLim.max )

    return damage
end

local function dclampNumbullets( self, val )
    local dpsMultMin, dpsMultMax = getDPSMultLim( self, "numbullets" )
    local numLim = config.numbullets

    local numbullets = clampF( floorF( val ), dpsMultMin, dpsMultMax )

    numbullets = clampF( numbullets, numLim.min, numLim.max )

    return numbullets
end

local function dclampSpread( self, val )
    local dpsMultMin, dpsMultMax = getDPSMultLim( self, "spread" )
    local spreadLim = config.spread
    local spreadMultLim = config.spreadDPSMult
    local spreadMultAdjuster = -spreadMultLim.max
    local spreadMultAdjuster2 = ( spreadMultLim.min - spreadMultLim.max )

    -- Clamp dps mult limit based on spreadMult range, then convert from dps mult back to normal 0-1 spread range
    dpsMultMin = maxF( dpsMultMin, spreadMultLim.min )
    dpsMultMax = minF( dpsMultMax, spreadMultLim.max )

    dpsMultMin = ( dpsMultMin + spreadMultAdjuster ) / spreadMultAdjuster2
    dpsMultMax = ( dpsMultMax + spreadMultAdjuster ) / spreadMultAdjuster2

    local spread = clampF( val, dpsMultMax, dpsMultMin )

    spread = clampF( spread, spreadLim.min, spreadLim.max )

    return spread
end

if SERVER then
    AddCSLuaFile( "tool_balance/tools/wire/turret.lua" )

    local clampMethod = cfcToolBalance.clampMethod

    local function wrapWireTurret()
        local WIRE_TURRET =  scripted_ents.GetStored( "gmod_wire_turret" ).t

        if config.dynamicLimit then -- Using dynamic wire turret limits
            WIRE_TURRET._SetSpread = WIRE_TURRET._SetSpread or WIRE_TURRET.SetSpread

            WIRE_TURRET.SetDelay = function( self, val )
                self.delay = dclampDelay( self, val )
            end

            WIRE_TURRET.SetDamage = function( self, val )
                self.damage = dclampDamage( self, val )
            end

            WIRE_TURRET.SetNumBullets = function( self, val )
                self.numbullets = dclampNumbullets( self, val )
            end

            WIRE_TURRET.SetSpread = function( self, val )
                self._SetSpread( self, dclampSpread( self, val ) )
            end

            WIRE_TURRET.SetSound = function()
                -- nope
            end

            WIRE_TURRET.SetForce = clampMethod( WIRE_TURRET.SetForce, { config.force } )
            WIRE_TURRET.Setup = function ( self, delay, damage, force, sound, numbullets, spread, tracer, tracernum )
                self:SetForce( force )
                self:SetDelay( delay )
                self:SetSound( sound )
                self:SetDamage( damage )
                self:SetSpread( spread )
                self:SetTracer( tracer )
                self:SetTraceNum( tracernum )
                self:SetNumBullets( numbullets )
            end
        else -- Not using dynamic wire turret limits
            WIRE_TURRET.Setup = clampMethod( WIRE_TURRET.Setup, values )

            WIRE_TURRET.SetDelay = clampMethod( WIRE_TURRET.SetDelay, { config.delay } )
            WIRE_TURRET.SetForce = clampMethod( WIRE_TURRET.SetForce, { config.force } )
            WIRE_TURRET.SetDamage = clampMethod( WIRE_TURRET.SetDamage, { config.damage } )
            WIRE_TURRET.SetNumBullets = clampMethod( WIRE_TURRET.SetNumBullets, { config.numbullets } )
            WIRE_TURRET.SetSpread = clampMethod( WIRE_TURRET.SetSpread, { config.spread } )
        end

        print( "[CFC_Tool_Balance] wire/turret loaded" )
    end

    local function waitingFor()
        local ent = scripted_ents.GetStored( "gmod_wire_turret" )
        return ent and ent.t.Setup ~= nil
    end

    local function onTimeout()
        print( "[CFC_Tool_Balance] wire/turret failed, waiter timed out" )
    end

    cfcToolBalance.waitFor( waitingFor, wrapWireTurret, onTimeout, "wire/turret" )

    return
end

-- CLIENT

local LOCK_DELAY = CreateClientConVar( "wire_turret_delay_lock", 0, true, false, "Whether or not to lock the delay slider of a wire turret.", 0, 1 )
local LOCK_DAMAGE = CreateClientConVar( "wire_turret_damage_lock", 0, true, false, "Whether or not to lock the damage slider of a wire turret.", 0, 1 )
local LOCK_NUMBULLETS = CreateClientConVar( "wire_turret_numbullets_lock", 0, true, false, "Whether or not to lock the numbullets slider of a wire turret.", 0, 1 )
local LOCK_SPREAD = CreateClientConVar( "wire_turret_spread_lock", 0, true, false, "Whether or not to lock the spread slider of a wire turret.", 0, 1 )

local DPS_LABEL
local TEXT_COLOR = Color( 0, 0, 0, 255 )

local forceWrite = {}
local lockTable = {
    delay = LOCK_DELAY,
    damage = LOCK_DAMAGE,
    numbullets = LOCK_NUMBULLETS,
    spread = LOCK_SPREAD
}

local function isLocked( varName )
    local lockConVar = lockTable[varName]

    if not lockConVar then return end

    return lockConVar:GetBool()
end

local function dpsMultToDelay( mult )
    local delayLim = config.delay
    local delay = clampF( 1 / mult, delayLim.min, delayLim.max )

    return delay
end

local function dpsMultToDamage( mult )
    local damageLim = config.damage
    local damage = clampF( mult, damageLim.min, damageLim.max )

    return damage
end

local function dpsMultToNumbullets( mult )
    local numLim = config.numbullets
    local numbullets = clampF( floorF( mult ), numLim.min, numLim.max )

    return numbullets
end

local function dpsMultToSpread( mult )
    local spreadLim = config.spread
    local spreadMultLim = config.spreadDPSMult
    local spreadMultAdjuster = -spreadMultLim.max
    local spreadMultAdjuster2 = ( spreadMultLim.min - spreadMultLim.max )

    local spread = ( mult + spreadMultAdjuster ) / spreadMultAdjuster2
    spread = clampF( spread, spreadLim.min, spreadLim.max )

    return spread
end

local dpsMultToVarFuncs = {
    delay = dpsMultToDelay,
    damage = dpsMultToDamage,
    numbullets = dpsMultToNumbullets,
    spread = dpsMultToSpread
}

local function adjustDPSVar( varName, oldVal, newVal )
    if isLocked( varName ) then return oldVal end

    local varLim = config[varName]
    local dpsLim = config.dps
    local oldMult = 1
    local newMult = 1
    local oldDPS = 1
    local largestMult = 0
    local largestMultName = false

    oldVal = clampF( oldVal, varLim.min, varLim.max )
    newVal = clampF( newVal, varLim.min, varLim.max )

    for name, func in pairs( dpsFuncs ) do
        local isTargetVar = name == varName
        local mult = func( nil, isTargetVar and oldVal ) -- Get dps mult for current/old values

        oldDPS = oldDPS * mult

        if isTargetVar then
            oldMult = mult
            newMult = dpsFuncs[varName]( nil, newVal )
        elseif mult > largestMult and not isLocked( name ) then
            largestMultName = name
            largestMult = mult
        end
    end

    local multChange = newMult / oldMult
    local minMultChange = dpsLim.min / oldDPS
    local maxMultChange = dpsLim.max / oldDPS

    if multChange < minMultChange then -- newVal would bring dps below the min limit, clamp it
        return dpsMultToVarFuncs[varName]( minMultChange )
    end

    if multChange > maxMultChange then -- newVal would bring dps above the max limit, attempt to pull down the largest unlocked variable
        if not largestMultName then -- No other vars are unlocked, clamp target var based on current max multiplier
            return dpsMultToVarFuncs[varName]( maxMultChange )
        end

        local largestMultReduced = largestMult * maxMultChange / multChange
        local largestValReduced = dpsMultToVarFuncs[largestMultName]( largestMultReduced )

        return newVal, largestMultName, largestValReduced
    end

    return newVal
end

local function displayDPS()
    if not DPS_LABEL then return end

    local dps = getDPSMult()

    DPS_LABEL:SetText( "Estimated DPS: " .. floorF( dps ) )
end

local function dClampConVar( cvName, oldVal, newVal )
    if forceWrite[cvName] then
        forceWrite[cvName] = nil

        return
    end

    if oldVal == newVal then return end

    local varName = string.gsub( cvName, "wire_turret_", "" )
    oldVal = tonumber( oldVal or "1" ) or 1
    newVal = tonumber( newVal or "1" ) or 1

    local newValClamped, otherValName, otherValClamped = adjustDPSVar( varName, oldVal, newVal )

    if otherValName then
        otherValName = "wire_turret_" .. otherValName

        forceWrite[otherValName] = true
        LocalPlayer():ConCommand( otherValName .. " " .. otherValClamped )
    end

    if not newValClamped or newValClamped == newVal then
        displayDPS()

        return
    end

    forceWrite[cvName] = true
    LocalPlayer():ConCommand( cvName .. " " .. newValClamped )

    displayDPS()
end

cvars.AddChangeCallback( "wire_turret_delay", dClampConVar, "CFC_ToolBalance_WireTurret_Clamp" )
cvars.AddChangeCallback( "wire_turret_damage", dClampConVar, "CFC_ToolBalance_WireTurret_Clamp" )
cvars.AddChangeCallback( "wire_turret_numbullets", dClampConVar, "CFC_ToolBalance_WireTurret_Clamp" )
cvars.AddChangeCallback( "wire_turret_spread", dClampConVar, "CFC_ToolBalance_WireTurret_Clamp" )

hook.Add( "CFC_ToolBalance_WireTurret_PanelBuilt", "CFC_ToolBalance_WireTurret_WrapPanel", function()
    local mainPanel = controlpanel.Get( "wire_turret" )
    local mainChildren = mainPanel:GetChildren()

    local spOffset = game.SinglePlayer() and 1 or 0

    local damageSlider = mainChildren[6 + spOffset]:GetChildren()[1]
    local delaySlider = mainChildren[9 + spOffset]:GetChildren()[1]
    local spreadSlider = mainChildren[7 + spOffset]:GetChildren()[1]
    local forceSlider = mainChildren[8 + spOffset]:GetChildren()[1]
    local numbulletsSlider = mainChildren[game.SinglePlayer() and 6 or 10]:GetChildren()[1]

    damageSlider:SetMinMax( config.damage.min, config.damage.max )
    delaySlider:SetMinMax( config.delay.min, config.delay.max )
    spreadSlider:SetMinMax( config.spread.min, config.spread.max )
    forceSlider:SetMinMax( config.force.min, config.force.max )
    numbulletsSlider:SetMinMax( config.numbullets.min, config.numbullets.max )
end )

hook.Add( "InitPostEntity", "CFC_ToolBalance_WireTurret_WrapBuildCPanel", function()
    local toolMenu = spawnmenu.GetToolMenu( "Wire" )[8][1]
    local oldBuilder = toolMenu.CPanelFunction

    toolMenu._CPanelFunction = oldBuilder

    toolMenu.CPanelFunction = function( CPanel )
        oldBuilder( CPanel )

        if not game.SinglePlayer() then -- Wire for some reason only creates the numbullets slider in singleplayer
            local numLim = config.numbullets

            CPanel:NumSlider( "#Tool_wire_turret_numbullets", "wire_turret_numbullets", numLim.min, numLim.max, 0 )
        end

        DPS_LABEL = vgui.Create( "DLabel", CPanel )

        local skin = DPS_LABEL:GetSkin() or SKIN or {}

        DPS_LABEL:SetTextColor( skin.colTextEntryText or TEXT_COLOR )
        CPanel:AddItem( DPS_LABEL )

        CPanel:CheckBox( "Lock Damage", "wire_turret_damage_lock" )
        CPanel:CheckBox( "Lock Spread", "wire_turret_spread_lock" )
        CPanel:CheckBox( "Lock Delay", "wire_turret_delay_lock" )
        CPanel:CheckBox( "Lock Bullets per Shot", "wire_turret_numbullets_lock" )

        hook.Run( "CFC_ToolBalance_WireTurret_PanelBuilt" )

        WIRE_TURRET_DELAY = GetConVar( "wire_turret_delay" )
        WIRE_TURRET_DAMAGE = GetConVar( "wire_turret_damage" )
        WIRE_TURRET_NUMBULLETS = GetConVar( "wire_turret_numbullets" )
        WIRE_TURRET_SPREAD = GetConVar( "wire_turret_spread" )

        displayDPS()
    end
end )
