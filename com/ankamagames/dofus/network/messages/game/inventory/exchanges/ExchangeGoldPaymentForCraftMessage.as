﻿package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
    import com.ankamagames.jerakine.network.NetworkMessage;
    import com.ankamagames.jerakine.network.INetworkMessage;
    import flash.utils.ByteArray;
    import com.ankamagames.jerakine.network.CustomDataWrapper;
    import com.ankamagames.jerakine.network.ICustomDataOutput;
    import com.ankamagames.jerakine.network.ICustomDataInput;

    [Trusted]
    public class ExchangeGoldPaymentForCraftMessage extends NetworkMessage implements INetworkMessage 
    {

        public static const protocolId:uint = 5833;

        private var _isInitialized:Boolean = false;
        public var onlySuccess:Boolean = false;
        public var goldSum:uint = 0;


        override public function get isInitialized():Boolean
        {
            return (this._isInitialized);
        }

        override public function getMessageId():uint
        {
            return (5833);
        }

        public function initExchangeGoldPaymentForCraftMessage(onlySuccess:Boolean=false, goldSum:uint=0):ExchangeGoldPaymentForCraftMessage
        {
            this.onlySuccess = onlySuccess;
            this.goldSum = goldSum;
            this._isInitialized = true;
            return (this);
        }

        override public function reset():void
        {
            this.onlySuccess = false;
            this.goldSum = 0;
            this._isInitialized = false;
        }

        override public function pack(output:ICustomDataOutput):void
        {
            var data:ByteArray = new ByteArray();
            this.serialize(new CustomDataWrapper(data));
            writePacket(output, this.getMessageId(), data);
        }

        override public function unpack(input:ICustomDataInput, length:uint):void
        {
            this.deserialize(input);
        }

        public function serialize(output:ICustomDataOutput):void
        {
            this.serializeAs_ExchangeGoldPaymentForCraftMessage(output);
        }

        public function serializeAs_ExchangeGoldPaymentForCraftMessage(output:ICustomDataOutput):void
        {
            output.writeBoolean(this.onlySuccess);
            if (this.goldSum < 0)
            {
                throw (new Error((("Forbidden value (" + this.goldSum) + ") on element goldSum.")));
            };
            output.writeVarInt(this.goldSum);
        }

        public function deserialize(input:ICustomDataInput):void
        {
            this.deserializeAs_ExchangeGoldPaymentForCraftMessage(input);
        }

        public function deserializeAs_ExchangeGoldPaymentForCraftMessage(input:ICustomDataInput):void
        {
            this.onlySuccess = input.readBoolean();
            this.goldSum = input.readVarUhInt();
            if (this.goldSum < 0)
            {
                throw (new Error((("Forbidden value (" + this.goldSum) + ") on element of ExchangeGoldPaymentForCraftMessage.goldSum.")));
            };
        }


    }
}//package com.ankamagames.dofus.network.messages.game.inventory.exchanges

