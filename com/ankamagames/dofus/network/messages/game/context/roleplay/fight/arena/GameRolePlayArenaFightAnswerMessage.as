﻿package com.ankamagames.dofus.network.messages.game.context.roleplay.fight.arena
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class GameRolePlayArenaFightAnswerMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var fightId:int = 0;
        public var accept:Boolean = false;
        public static const protocolId:uint = 6279;

        public function GameRolePlayArenaFightAnswerMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6279;
        }// end function

        public function initGameRolePlayArenaFightAnswerMessage(param1:int = 0, param2:Boolean = false) : GameRolePlayArenaFightAnswerMessage
        {
            this.fightId = param1;
            this.accept = param2;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.fightId = 0;
            this.accept = false;
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
            this.serializeAs_GameRolePlayArenaFightAnswerMessage(param1);
            return;
        }// end function

        public function serializeAs_GameRolePlayArenaFightAnswerMessage(param1:IDataOutput) : void
        {
            param1.writeInt(this.fightId);
            param1.writeBoolean(this.accept);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_GameRolePlayArenaFightAnswerMessage(param1);
            return;
        }// end function

        public function deserializeAs_GameRolePlayArenaFightAnswerMessage(param1:IDataInput) : void
        {
            this.fightId = param1.readInt();
            this.accept = param1.readBoolean();
            return;
        }// end function

    }
}
