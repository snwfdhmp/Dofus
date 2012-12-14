﻿package com.ankamagames.dofus.network.messages.game.basic
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class BasicAckMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var seq:uint = 0;
        public var lastPacketId:uint = 0;
        public static const protocolId:uint = 6362;

        public function BasicAckMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6362;
        }// end function

        public function initBasicAckMessage(param1:uint = 0, param2:uint = 0) : BasicAckMessage
        {
            this.seq = param1;
            this.lastPacketId = param2;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.seq = 0;
            this.lastPacketId = 0;
            this._isInitialized = false;
            return;
        }// end function

        override public function pack(param1:IDataOutput) : void
        {
            var _loc_2:* = new ByteArray();
            this.serialize(_loc_2);
            writePacket(param1, this.getMessageId(), _loc_2);
            return;
        }// end function

        override public function unpack(param1:IDataInput, param2:uint) : void
        {
            this.deserialize(param1);
            return;
        }// end function

        public function serialize(param1:IDataOutput) : void
        {
            this.serializeAs_BasicAckMessage(param1);
            return;
        }// end function

        public function serializeAs_BasicAckMessage(param1:IDataOutput) : void
        {
            if (this.seq < 0)
            {
                throw new Error("Forbidden value (" + this.seq + ") on element seq.");
            }
            param1.writeInt(this.seq);
            if (this.lastPacketId < 0)
            {
                throw new Error("Forbidden value (" + this.lastPacketId + ") on element lastPacketId.");
            }
            param1.writeShort(this.lastPacketId);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_BasicAckMessage(param1);
            return;
        }// end function

        public function deserializeAs_BasicAckMessage(param1:IDataInput) : void
        {
            this.seq = param1.readInt();
            if (this.seq < 0)
            {
                throw new Error("Forbidden value (" + this.seq + ") on element of BasicAckMessage.seq.");
            }
            this.lastPacketId = param1.readShort();
            if (this.lastPacketId < 0)
            {
                throw new Error("Forbidden value (" + this.lastPacketId + ") on element of BasicAckMessage.lastPacketId.");
            }
            return;
        }// end function

    }
}
