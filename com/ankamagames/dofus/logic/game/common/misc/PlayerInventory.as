﻿package com.ankamagames.dofus.logic.game.common.misc
{
    import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;

    public class PlayerInventory extends Inventory 
    {


        override public function set kamas(value:int):void
        {
            if (PlayedCharacterManager.getInstance().characteristics)
            {
                PlayedCharacterManager.getInstance().characteristics.kamas = value;
            };
            super.kamas = value;
        }


    }
}//package com.ankamagames.dofus.logic.game.common.misc

