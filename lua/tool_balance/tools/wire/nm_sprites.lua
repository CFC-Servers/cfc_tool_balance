-- wire/nm_sprites
local math_Clamp = math.Clamp

-- config
local scaleMin = 0
local scaleMax = 5

local function wrapWireSprites( entTbl )
    local old_UpdateSprite = entTbl.UpdateSprite
    function entTbl:UpdateSprite()
        self.spr_scale = math_Clamp( self.spr_scale, scaleMin, scaleMax )
        return old_UpdateSprite( self )
    end

    local old_CreateNMSprite = entTbl.CreateNMSprite
    function entTbl:CreateNMSprite()
        self.spr_scale = math_Clamp( self.spr_scale, scaleMin, scaleMax )
        return old_CreateNMSprite( self )
    end
end

cfcToolBalance.waitForSENT( "gmod_wire_nm_sprite", wrapWireSprites )
