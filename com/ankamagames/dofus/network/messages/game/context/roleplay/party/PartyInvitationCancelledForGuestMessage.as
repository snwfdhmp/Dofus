﻿package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
    import com.ankamagames.jerakine.network.INetworkMessage;
    import flash.utils.ByteArray;
    import com.ankamagames.jerakine.network.CustomDataWrapper;
    import com.ankamagames.jerakine.network.ICustomDataOutput;
    import com.ankamagames.jerakine.network.ICustomDataInput;

    [Trusted]
    public class PartyInvitationCancelledForGuestMessage extends AbstractPartyMessage implements INetworkMessage 
    {

        public static const protocolId:uint = 6256;

        private var _isInitialized:Boolean = false;
        public var cancelerId:uint = 0;


        override public function get isInitialized():Boolean
        {
            return (((super.isInitialized) && (this._isInitialized)));
        }

        override public function getMessageId():uint
        {
            return (6256);
        }

        public function initPartyInvitationCancelledForGuestMessage(partyId:uint=0, cancelerId:uint=0):PartyInvitationCancelledForGuestMessage
        {
            super.initAbstractPartyMessage(partyId);
            this.cancelerId = cancelerId;
            this._isInitialized = true;
            return (this);
        }

        override public function reset():void
        {
            super.reset();
            this.cancelerId = 0;
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
            this.serializeAs_PartyInvitationCancelledForGuestMessage(output);
        }

        public function serializeAs_PartyInvitationCancelledForGuestMessage(output:ICustomDataOutput):void
        {
            super.serializeAs_AbstractPartyMessage(output);
            if (this.cancelerId < 0)
            {
                throw (new Error((("Forbidden value (" + this.cancelerId) + ") on element cancelerId.")));
            };
            output.writeVarInt(this.cancelerId);
        }

        override public function deserialize(input:ICustomDataInput):void
        {
            this.deserializeAs_PartyInvitationCancelledForGuestMessage(input);
        }

        public function deserializeAs_PartyInvitationCancelledForGuestMessage(input:ICustomDataInput):void
        {
            super.deserialize(input);
            this.cancelerId = input.readVarUhInt();
            if (this.cancelerId < 0)
            {
                throw (new Error((("Forbidden value (" + this.cancelerId) + ") on element of PartyInvitationCancelledForGuestMessage.cancelerId.")));
            };
        }


    }
}//package com.ankamagames.dofus.network.messages.game.context.roleplay.party

