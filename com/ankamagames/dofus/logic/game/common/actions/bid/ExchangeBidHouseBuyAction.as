﻿package com.ankamagames.dofus.logic.game.common.actions.bid
{
    import com.ankamagames.jerakine.handlers.messages.Action;

    public class ExchangeBidHouseBuyAction implements Action 
    {

        public var uid:uint;
        public var qty:uint;
        public var price:uint;


        public static function create(pUid:uint, pQty:uint, pPrice:uint):ExchangeBidHouseBuyAction
        {
            var a:ExchangeBidHouseBuyAction = new (ExchangeBidHouseBuyAction)();
            a.uid = pUid;
            a.qty = pQty;
            a.price = pPrice;
            return (a);
        }


    }
}//package com.ankamagames.dofus.logic.game.common.actions.bid

