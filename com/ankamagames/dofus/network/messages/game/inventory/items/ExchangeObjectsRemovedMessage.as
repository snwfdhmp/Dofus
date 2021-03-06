﻿package com.ankamagames.dofus.network.messages.game.inventory.items
{
    import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectMessage;
    import com.ankamagames.jerakine.network.INetworkMessage;
    import __AS3__.vec.Vector;
    import flash.utils.ByteArray;
    import com.ankamagames.jerakine.network.CustomDataWrapper;
    import com.ankamagames.jerakine.network.ICustomDataOutput;
    import com.ankamagames.jerakine.network.ICustomDataInput;
    import __AS3__.vec.*;

    [Trusted]
    public class ExchangeObjectsRemovedMessage extends ExchangeObjectMessage implements INetworkMessage 
    {

        public static const protocolId:uint = 6532;

        private var _isInitialized:Boolean = false;
        public var objectUID:Vector.<uint>;

        public function ExchangeObjectsRemovedMessage()
        {
            this.objectUID = new Vector.<uint>();
            super();
        }

        override public function get isInitialized():Boolean
        {
            return (((super.isInitialized) && (this._isInitialized)));
        }

        override public function getMessageId():uint
        {
            return (6532);
        }

        public function initExchangeObjectsRemovedMessage(remote:Boolean=false, objectUID:Vector.<uint>=null):ExchangeObjectsRemovedMessage
        {
            super.initExchangeObjectMessage(remote);
            this.objectUID = objectUID;
            this._isInitialized = true;
            return (this);
        }

        override public function reset():void
        {
            super.reset();
            this.objectUID = new Vector.<uint>();
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

        override public function serialize(output:ICustomDataOutput):void
        {
            this.serializeAs_ExchangeObjectsRemovedMessage(output);
        }

        public function serializeAs_ExchangeObjectsRemovedMessage(output:ICustomDataOutput):void
        {
            super.serializeAs_ExchangeObjectMessage(output);
            output.writeShort(this.objectUID.length);
            var _i1:uint;
            while (_i1 < this.objectUID.length)
            {
                if (this.objectUID[_i1] < 0)
                {
                    throw (new Error((("Forbidden value (" + this.objectUID[_i1]) + ") on element 1 (starting at 1) of objectUID.")));
                };
                output.writeVarInt(this.objectUID[_i1]);
                _i1++;
            };
        }

        override public function deserialize(input:ICustomDataInput):void
        {
            this.deserializeAs_ExchangeObjectsRemovedMessage(input);
        }

        public function deserializeAs_ExchangeObjectsRemovedMessage(input:ICustomDataInput):void
        {
            var _val1:uint;
            super.deserialize(input);
            var _objectUIDLen:uint = input.readUnsignedShort();
            var _i1:uint;
            while (_i1 < _objectUIDLen)
            {
                _val1 = input.readVarUhInt();
                if (_val1 < 0)
                {
                    throw (new Error((("Forbidden value (" + _val1) + ") on elements of objectUID.")));
                };
                this.objectUID.push(_val1);
                _i1++;
            };
        }


    }
}//package com.ankamagames.dofus.network.messages.game.inventory.items

