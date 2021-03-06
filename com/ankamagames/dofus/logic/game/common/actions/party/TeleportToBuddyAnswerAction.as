﻿package com.ankamagames.dofus.logic.game.common.actions.party
{
    import com.ankamagames.jerakine.handlers.messages.Action;

    public class TeleportToBuddyAnswerAction implements Action 
    {

        public var dungeonId:int;
        public var buddyId:int;
        public var accept:Boolean;


        public static function create(dungeonId:int, buddyId:int, accept:Boolean):TeleportToBuddyAnswerAction
        {
            var a:TeleportToBuddyAnswerAction = new (TeleportToBuddyAnswerAction)();
            a.dungeonId = dungeonId;
            a.buddyId = buddyId;
            a.accept = accept;
            return (a);
        }


    }
}//package com.ankamagames.dofus.logic.game.common.actions.party

