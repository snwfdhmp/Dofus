﻿package com.ankamagames.dofus.network.messages.game.actions.fight
{
    import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
    import com.ankamagames.jerakine.network.INetworkMessage;
    import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
    import flash.utils.ByteArray;
    import com.ankamagames.jerakine.network.CustomDataWrapper;
    import com.ankamagames.jerakine.network.ICustomDataOutput;
    import com.ankamagames.jerakine.network.ICustomDataInput;
    import com.ankamagames.dofus.network.ProtocolTypeManager;

    [Trusted]
    public class GameActionFightSummonMessage extends AbstractGameActionMessage implements INetworkMessage 
    {

        public static const protocolId:uint = 5825;

        private var _isInitialized:Boolean = false;
        public var summon:GameFightFighterInformations;

        public function GameActionFightSummonMessage()
        {
            this.summon = new GameFightFighterInformations();
            super();
        }

        override public function get isInitialized():Boolean
        {
            return (((super.isInitialized) && (this._isInitialized)));
        }

        override public function getMessageId():uint
        {
            return (5825);
        }

        public function initGameActionFightSummonMessage(actionId:uint=0, sourceId:int=0, summon:GameFightFighterInformations=null):GameActionFightSummonMessage
        {
            super.initAbstractGameActionMessage(actionId, sourceId);
            this.summon = summon;
            this._isInitialized = true;
            return (this);
        }

        override public function reset():void
        {
            super.reset();
            this.summon = new GameFightFighterInformations();
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
            this.serializeAs_GameActionFightSummonMessage(output);
        }

        public function serializeAs_GameActionFightSummonMessage(output:ICustomDataOutput):void
        {
            super.serializeAs_AbstractGameActionMessage(output);
            output.writeShort(this.summon.getTypeId());
            this.summon.serialize(output);
        }

        override public function deserialize(input:ICustomDataInput):void
        {
            this.deserializeAs_GameActionFightSummonMessage(input);
        }

        public function deserializeAs_GameActionFightSummonMessage(input:ICustomDataInput):void
        {
            super.deserialize(input);
            var _id1:uint = input.readUnsignedShort();
            this.summon = ProtocolTypeManager.getInstance(GameFightFighterInformations, _id1);
            this.summon.deserialize(input);
        }


    }
}//package com.ankamagames.dofus.network.messages.game.actions.fight

