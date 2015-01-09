﻿package com.ankamagames.dofus.network.messages.game.context
{
    import com.ankamagames.jerakine.network.NetworkMessage;
    import com.ankamagames.jerakine.network.INetworkMessage;
    import flash.utils.ByteArray;
    import flash.utils.IDataOutput;
    import flash.utils.IDataInput;

    [Trusted]
    public class GameContextReadyMessage extends NetworkMessage implements INetworkMessage 
    {

        public static const protocolId:uint = 6071;

        private var _isInitialized:Boolean = false;
        public var mapId:uint = 0;


        override public function get isInitialized():Boolean
        {
            return (this._isInitialized);
        }

        override public function getMessageId():uint
        {
            return (6071);
        }

        public function initGameContextReadyMessage(mapId:uint=0):GameContextReadyMessage
        {
            this.mapId = mapId;
            this._isInitialized = true;
            return (this);
        }

        override public function reset():void
        {
            this.mapId = 0;
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

        public function serialize(output:IDataOutput):void
        {
            this.serializeAs_GameContextReadyMessage(output);
        }

        public function serializeAs_GameContextReadyMessage(output:IDataOutput):void
        {
            if (this.mapId < 0)
            {
                throw (new Error((("Forbidden value (" + this.mapId) + ") on element mapId.")));
            };
            output.writeInt(this.mapId);
        }

        public function deserialize(input:IDataInput):void
        {
            this.deserializeAs_GameContextReadyMessage(input);
        }

        public function deserializeAs_GameContextReadyMessage(input:IDataInput):void
        {
            this.mapId = input.readInt();
            if (this.mapId < 0)
            {
                throw (new Error((("Forbidden value (" + this.mapId) + ") on element of GameContextReadyMessage.mapId.")));
            };
        }


    }
}//package com.ankamagames.dofus.network.messages.game.context

