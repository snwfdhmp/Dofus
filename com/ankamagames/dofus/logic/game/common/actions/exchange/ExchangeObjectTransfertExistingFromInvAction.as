﻿package com.ankamagames.dofus.logic.game.common.actions.exchange
{
    import com.ankamagames.jerakine.handlers.messages.Action;

    public class ExchangeObjectTransfertExistingFromInvAction implements Action 
    {


        public static function create(fromBankExchange:Boolean=false):ExchangeObjectTransfertExistingFromInvAction
        {
            return (new (ExchangeObjectTransfertExistingFromInvAction)());
        }


    }
}//package com.ankamagames.dofus.logic.game.common.actions.exchange

