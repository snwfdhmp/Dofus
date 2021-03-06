﻿package d2actions
{
    public class PartyInvitation implements IAction 
    {

        public static const NEED_INTERACTION:Boolean = true;
        public static const NEED_CONFIRMATION:Boolean = false;
        public static const MAX_USE_PER_FRAME:int = 1;
        public static const DELAY:int = 0;

        private var _params:Array;

        public function PartyInvitation(name:String, dungeon:uint=0, inArena:Boolean=false)
        {
            this._params = [name, dungeon, inArena];
        }

        public function get parameters():Array
        {
            return (this._params);
        }


    }
}//package d2actions

