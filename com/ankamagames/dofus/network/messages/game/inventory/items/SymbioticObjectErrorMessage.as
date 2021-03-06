﻿package com.ankamagames.dofus.network.messages.game.inventory.items
{
    import com.ankamagames.jerakine.network.INetworkMessage;
    import flash.utils.ByteArray;
    import com.ankamagames.jerakine.network.CustomDataWrapper;
    import com.ankamagames.jerakine.network.ICustomDataOutput;
    import com.ankamagames.jerakine.network.ICustomDataInput;

    [Trusted]
    public class SymbioticObjectErrorMessage extends ObjectErrorMessage implements INetworkMessage 
    {

        public static const protocolId:uint = 6526;

        private var _isInitialized:Boolean = false;
        public var errorCode:int = 0;


        override public function get isInitialized():Boolean
        {
            return (((super.isInitialized) && (this._isInitialized)));
        }

        override public function getMessageId():uint
        {
            return (6526);
        }

        public function initSymbioticObjectErrorMessage(reason:int=0, errorCode:int=0):SymbioticObjectErrorMessage
        {
            super.initObjectErrorMessage(reason);
            this.errorCode = errorCode;
            this._isInitialized = true;
            return (this);
        }

        override public function reset():void
        {
            super.reset();
            this.errorCode = 0;
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
            this.serializeAs_SymbioticObjectErrorMessage(output);
        }

        public function serializeAs_SymbioticObjectErrorMessage(output:ICustomDataOutput):void
        {
            super.serializeAs_ObjectErrorMessage(output);
            output.writeByte(this.errorCode);
        }

        override public function deserialize(input:ICustomDataInput):void
        {
            this.deserializeAs_SymbioticObjectErrorMessage(input);
        }

        public function deserializeAs_SymbioticObjectErrorMessage(input:ICustomDataInput):void
        {
            super.deserialize(input);
            this.errorCode = input.readByte();
        }


    }
}//package com.ankamagames.dofus.network.messages.game.inventory.items

