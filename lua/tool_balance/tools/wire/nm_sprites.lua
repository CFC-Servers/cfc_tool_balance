-- wire/nm_sprites

local math_Clamp = math.Clamp

-- config
local scaleMin = 0
local scaleMax = 5

local function wrapWireSprites()
    local WIRE_SPRITES =  scripted_ents.GetStored( "gmod_wire_nm_sprite" ).t
    local old_UpdateSprite = WIRE_SPRITES.UpdateSprite
    function WIRE_SPRITES:UpdateSprite()
        self.spr_scale = math_Clamp( self.spr_scale, scaleMin, scaleMax )
        return old_UpdateSprite( self )
    end
    local old_CreateNMSprite = WIRE_SPRITES.CreateNMSprite
    function WIRE_SPRITES:CreateNMSprite()
        self.spr_scale = math_Clamp( self.spr_scale, scaleMin, scaleMax )
        return old_CreateNMSprite( self )
    end

    print( "[CFC_Tool_Balance] wire/nm_sprites loaded" )
end

local function waitingFor()
    local ent = scripted_ents.GetStored( "gmod_wire_nm_sprite" )
    return ent and ent.t.Setup ~= nil
end

local function onTimeout()
    print( "[CFC_Tool_Balance] wire/nm_sprites failed, waiter timed out" )
end

cfcToolBalance.waitFor( waitingFor, wrapWireSprites, onTimeout, "wire/nm_sprites" )
