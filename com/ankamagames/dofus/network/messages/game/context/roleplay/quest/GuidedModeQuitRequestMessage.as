package com.ankamagames.dofus.network.messages.game.context.roleplay.quest
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class GuidedModeQuitRequestMessage extends NetworkMessage implements INetworkMessage
    {
        public static const protocolId:uint = 6092;

        public function GuidedModeQuitRequestMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return true;
        }// end function

        override public function getMessageId() : uint
        {
            return 6092;
        }// end function

        public function initGuidedModeQuitRequestMessage() : GuidedModeQuitRequestMessage
        {
            return this;
        }// end function

        override public function reset() : void
        {
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
            return;
        }// end function

        public function serializeAs_GuidedModeQuitRequestMessage(param1:IDataOutput) : void
        {
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            return;
        }// end function

        public function deserializeAs_GuidedModeQuitRequestMessage(param1:IDataInput) : void
        {
            return;
        }// end function

    }
}