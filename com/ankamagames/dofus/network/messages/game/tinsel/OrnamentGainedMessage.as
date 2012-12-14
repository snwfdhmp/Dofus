﻿package com.ankamagames.dofus.network.messages.game.tinsel
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class OrnamentGainedMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var ornamentId:uint = 0;
        public static const protocolId:uint = 6368;

        public function OrnamentGainedMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6368;
        }// end function

        public function initOrnamentGainedMessage(param1:uint = 0) : OrnamentGainedMessage
        {
            this.ornamentId = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.ornamentId = 0;
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
            this.serializeAs_OrnamentGainedMessage(param1);
            return;
        }// end function

        public function serializeAs_OrnamentGainedMessage(param1:IDataOutput) : void
        {
            if (this.ornamentId < 0)
            {
                throw new Error("Forbidden value (" + this.ornamentId + ") on element ornamentId.");
            }
            param1.writeShort(this.ornamentId);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_OrnamentGainedMessage(param1);
            return;
        }// end function

        public function deserializeAs_OrnamentGainedMessage(param1:IDataInput) : void
        {
            this.ornamentId = param1.readShort();
            if (this.ornamentId < 0)
            {
                throw new Error("Forbidden value (" + this.ornamentId + ") on element of OrnamentGainedMessage.ornamentId.");
            }
            return;
        }// end function

    }
}
