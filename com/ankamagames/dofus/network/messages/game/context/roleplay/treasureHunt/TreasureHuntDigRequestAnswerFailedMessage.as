﻿package com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt
{
    import com.ankamagames.jerakine.network.INetworkMessage;
    import flash.utils.ByteArray;
    import com.ankamagames.jerakine.network.CustomDataWrapper;
    import com.ankamagames.jerakine.network.ICustomDataOutput;
    import com.ankamagames.jerakine.network.ICustomDataInput;

    [Trusted]
    public class TreasureHuntDigRequestAnswerFailedMessage extends TreasureHuntDigRequestAnswerMessage implements INetworkMessage 
    {

        public static const protocolId:uint = 6509;

        private var _isInitialized:Boolean = false;
        public var wrongFlagCount:uint = 0;


        override public function get isInitialized():Boolean
        {
            return (((super.isInitialized) && (this._isInitialized)));
        }

        override public function getMessageId():uint
        {
            return (6509);
        }

        public function initTreasureHuntDigRequestAnswerFailedMessage(questType:uint=0, result:uint=0, wrongFlagCount:uint=0):TreasureHuntDigRequestAnswerFailedMessage
        {
            super.initTreasureHuntDigRequestAnswerMessage(questType, result);
            this.wrongFlagCount = wrongFlagCount;
            this._isInitialized = true;
            return (this);
        }

        override public function reset():void
        {
            super.reset();
            this.wrongFlagCount = 0;
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
            this.serializeAs_TreasureHuntDigRequestAnswerFailedMessage(output);
        }

        public function serializeAs_TreasureHuntDigRequestAnswerFailedMessage(output:ICustomDataOutput):void
        {
            super.serializeAs_TreasureHuntDigRequestAnswerMessage(output);
            if (this.wrongFlagCount < 0)
            {
                throw (new Error((("Forbidden value (" + this.wrongFlagCount) + ") on element wrongFlagCount.")));
            };
            output.writeByte(this.wrongFlagCount);
        }

        override public function deserialize(input:ICustomDataInput):void
        {
            this.deserializeAs_TreasureHuntDigRequestAnswerFailedMessage(input);
        }

        public function deserializeAs_TreasureHuntDigRequestAnswerFailedMessage(input:ICustomDataInput):void
        {
            super.deserialize(input);
            this.wrongFlagCount = input.readByte();
            if (this.wrongFlagCount < 0)
            {
                throw (new Error((("Forbidden value (" + this.wrongFlagCount) + ") on element of TreasureHuntDigRequestAnswerFailedMessage.wrongFlagCount.")));
            };
        }


    }
}//package com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt

