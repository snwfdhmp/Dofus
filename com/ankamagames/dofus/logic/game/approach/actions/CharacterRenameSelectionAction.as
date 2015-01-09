﻿package com.ankamagames.dofus.logic.game.approach.actions
{
    import com.ankamagames.jerakine.handlers.messages.Action;

    public class CharacterRenameSelectionAction implements Action 
    {

        public var characterId:int;
        public var characterName:String;


        public static function create(characterId:int, characterName:String):CharacterRenameSelectionAction
        {
            var a:CharacterRenameSelectionAction = new (CharacterRenameSelectionAction)();
            a.characterId = characterId;
            a.characterName = characterName;
            return (a);
        }


    }
}//package com.ankamagames.dofus.logic.game.approach.actions

