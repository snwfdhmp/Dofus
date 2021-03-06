﻿package com.ankamagames.dofus.logic.game.roleplay.actions.preset
{
    import com.ankamagames.jerakine.handlers.messages.Action;

    public class InventoryPresetSaveAction implements Action 
    {

        public var presetId:uint;
        public var symbolId:uint;
        public var saveEquipment:Boolean;


        public static function create(presetId:uint, symbolId:uint, saveEquipment:Boolean):InventoryPresetSaveAction
        {
            var a:InventoryPresetSaveAction = new (InventoryPresetSaveAction)();
            a.presetId = presetId;
            a.symbolId = symbolId;
            a.saveEquipment = saveEquipment;
            return (a);
        }


    }
}//package com.ankamagames.dofus.logic.game.roleplay.actions.preset

