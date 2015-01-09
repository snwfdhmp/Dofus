﻿package com.ankamagames.dofus.network.messages.game.alliance
{
    import com.ankamagames.jerakine.network.NetworkMessage;
    import com.ankamagames.jerakine.network.INetworkMessage;
    import flash.utils.ByteArray;
    import flash.utils.IDataOutput;
    import flash.utils.IDataInput;

    [Trusted]
    public class AllianceLeftMessage extends NetworkMessage implements INetworkMessage 
    {

        public static const protocolId:uint = 6398;


        override public function get isInitialized():Boolean
        {
            return (true);
        }

        override public function getMessageId():uint
        {
            return (6398);
        }

        public function initAllianceLeftMessage():AllianceLeftMessage
        {
            return (this);
        }

        override public function reset():void
        {
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
        }

        public function serializeAs_AllianceLeftMessage(output:IDataOutput):void
        {
        }

        public function deserialize(input:IDataInput):void
        {
        }

        public function deserializeAs_AllianceLeftMessage(input:IDataInput):void
        {
        }


    }
}//package com.ankamagames.dofus.network.messages.game.alliance

