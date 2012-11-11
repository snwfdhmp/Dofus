﻿package com.ankamagames.dofus.network.messages.game.guild
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class GuildGetInformationsMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var infoType:uint = 0;
        public static const protocolId:uint = 5550;

        public function GuildGetInformationsMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 5550;
        }// end function

        public function initGuildGetInformationsMessage(param1:uint = 0) : GuildGetInformationsMessage
        {
            this.infoType = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.infoType = 0;
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
            this.serializeAs_GuildGetInformationsMessage(param1);
            return;
        }// end function

        public function serializeAs_GuildGetInformationsMessage(param1:IDataOutput) : void
        {
            param1.writeByte(this.infoType);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_GuildGetInformationsMessage(param1);
            return;
        }// end function

        public function deserializeAs_GuildGetInformationsMessage(param1:IDataInput) : void
        {
            this.infoType = param1.readByte();
            if (this.infoType < 0)
            {
                throw new Error("Forbidden value (" + this.infoType + ") on element of GuildGetInformationsMessage.infoType.");
            }
            return;
        }// end function

    }
}
