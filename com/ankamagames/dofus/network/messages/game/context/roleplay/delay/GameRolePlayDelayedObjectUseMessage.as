﻿package com.ankamagames.dofus.network.messages.game.context.roleplay.delay
{
    import com.ankamagames.jerakine.network.INetworkMessage;
    import flash.utils.ByteArray;
    import flash.utils.IDataOutput;
    import flash.utils.IDataInput;

    [Trusted]
    public class GameRolePlayDelayedObjectUseMessage extends GameRolePlayDelayedActionMessage implements INetworkMessage 
    {

        public static const protocolId:uint = 0x1919;

        private var _isInitialized:Boolean = false;
        public var objectGID:uint = 0;


        override public function get isInitialized():Boolean
        {
            return (((super.isInitialized) && (this._isInitialized)));
        }

        override public function getMessageId():uint
        {
            return (0x1919);
        }

        public function initGameRolePlayDelayedObjectUseMessage(delayedCharacterId:int=0, delayTypeId:uint=0, delayEndTime:Number=0, objectGID:uint=0):GameRolePlayDelayedObjectUseMessage
        {
            super.initGameRolePlayDelayedActionMessage(delayedCharacterId, delayTypeId, delayEndTime);
            this.objectGID = objectGID;
            this._isInitialized = true;
            return (this);
        }

        override public function reset():void
        {
            super.reset();
            this.objectGID = 0;
            this._isInitialized = false;
        }

        override public function pack(output:IDataOutput):void
        {
            var data:ByteArray = new ByteArray();
            this.serialize(data);
            writePacket(output, this.getMessageId(), data);
        }

        override public function unpack(input:IDataInput, length:uint):void
        {
            this.deserialize(input);
        }

        override public function serialize(output:IDataOutput):void
        {
            this.serializeAs_GameRolePlayDelayedObjectUseMessage(output);
        }

        public function serializeAs_GameRolePlayDelayedObjectUseMessage(output:IDataOutput):void
        {
            super.serializeAs_GameRolePlayDelayedActionMessage(output);
            if (this.objectGID < 0)
            {
                throw (new Error((("Forbidden value (" + this.objectGID) + ") on element objectGID.")));
            };
            output.writeShort(this.objectGID);
        }

        override public function deserialize(input:IDataInput):void
        {
            this.deserializeAs_GameRolePlayDelayedObjectUseMessage(input);
        }

        public function deserializeAs_GameRolePlayDelayedObjectUseMessage(input:IDataInput):void
        {
            super.deserialize(input);
            this.objectGID = input.readShort();
            if (this.objectGID < 0)
            {
                throw (new Error((("Forbidden value (" + this.objectGID) + ") on element of GameRolePlayDelayedObjectUseMessage.objectGID.")));
            };
        }


    }
}//package com.ankamagames.dofus.network.messages.game.context.roleplay.delay

