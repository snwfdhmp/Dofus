﻿package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
    import com.ankamagames.jerakine.network.NetworkMessage;
    import com.ankamagames.jerakine.network.INetworkMessage;
    import __AS3__.vec.Vector;
    import com.ankamagames.dofus.network.types.game.data.items.ObjectItemToSellInNpcShop;
    import flash.utils.ByteArray;
    import com.ankamagames.jerakine.network.CustomDataWrapper;
    import com.ankamagames.jerakine.network.ICustomDataOutput;
    import com.ankamagames.jerakine.network.ICustomDataInput;
    import __AS3__.vec.*;

    [Trusted]
    public class ExchangeStartOkNpcShopMessage extends NetworkMessage implements INetworkMessage 
    {

        public static const protocolId:uint = 5761;

        private var _isInitialized:Boolean = false;
        public var npcSellerId:int = 0;
        public var tokenId:uint = 0;
        public var objectsInfos:Vector.<ObjectItemToSellInNpcShop>;

        public function ExchangeStartOkNpcShopMessage()
        {
            this.objectsInfos = new Vector.<ObjectItemToSellInNpcShop>();
            super();
        }

        override public function get isInitialized():Boolean
        {
            return (this._isInitialized);
        }

        override public function getMessageId():uint
        {
            return (5761);
        }

        public function initExchangeStartOkNpcShopMessage(npcSellerId:int=0, tokenId:uint=0, objectsInfos:Vector.<ObjectItemToSellInNpcShop>=null):ExchangeStartOkNpcShopMessage
        {
            this.npcSellerId = npcSellerId;
            this.tokenId = tokenId;
            this.objectsInfos = objectsInfos;
            this._isInitialized = true;
            return (this);
        }

        override public function reset():void
        {
            this.npcSellerId = 0;
            this.tokenId = 0;
            this.objectsInfos = new Vector.<ObjectItemToSellInNpcShop>();
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
            this.serializeAs_ExchangeStartOkNpcShopMessage(output);
        }

        public function serializeAs_ExchangeStartOkNpcShopMessage(output:ICustomDataOutput):void
        {
            output.writeInt(this.npcSellerId);
            if (this.tokenId < 0)
            {
                throw (new Error((("Forbidden value (" + this.tokenId) + ") on element tokenId.")));
            };
            output.writeVarShort(this.tokenId);
            output.writeShort(this.objectsInfos.length);
            var _i3:uint;
            while (_i3 < this.objectsInfos.length)
            {
                (this.objectsInfos[_i3] as ObjectItemToSellInNpcShop).serializeAs_ObjectItemToSellInNpcShop(output);
                _i3++;
            };
        }

        public function deserialize(input:ICustomDataInput):void
        {
            this.deserializeAs_ExchangeStartOkNpcShopMessage(input);
        }

        public function deserializeAs_ExchangeStartOkNpcShopMessage(input:ICustomDataInput):void
        {
            var _item3:ObjectItemToSellInNpcShop;
            this.npcSellerId = input.readInt();
            this.tokenId = input.readVarUhShort();
            if (this.tokenId < 0)
            {
                throw (new Error((("Forbidden value (" + this.tokenId) + ") on element of ExchangeStartOkNpcShopMessage.tokenId.")));
            };
            var _objectsInfosLen:uint = input.readUnsignedShort();
            var _i3:uint;
            while (_i3 < _objectsInfosLen)
            {
                _item3 = new ObjectItemToSellInNpcShop();
                _item3.deserialize(input);
                this.objectsInfos.push(_item3);
                _i3++;
            };
        }


    }
}//package com.ankamagames.dofus.network.messages.game.inventory.exchanges

