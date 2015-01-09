﻿package com.ankamagames.dofus.logic.game.fight.actions
{
    import com.ankamagames.jerakine.handlers.messages.Action;

    public class GameFightSpellCastAction implements Action 
    {

        public var spellId:uint;


        public static function create(spellId:uint):GameFightSpellCastAction
        {
            var a:GameFightSpellCastAction = new (GameFightSpellCastAction)();
            a.spellId = spellId;
            return (a);
        }


    }
}//package com.ankamagames.dofus.logic.game.fight.actions

