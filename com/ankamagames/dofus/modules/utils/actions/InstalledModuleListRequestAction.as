﻿package com.ankamagames.dofus.modules.utils.actions
{
    import com.ankamagames.jerakine.handlers.messages.Action;

    public class InstalledModuleListRequestAction implements Action 
    {


        public static function create():InstalledModuleListRequestAction
        {
            var action:InstalledModuleListRequestAction = new (InstalledModuleListRequestAction)();
            return (action);
        }


    }
}//package com.ankamagames.dofus.modules.utils.actions

