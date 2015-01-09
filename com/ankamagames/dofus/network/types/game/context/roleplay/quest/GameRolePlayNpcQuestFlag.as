﻿package com.ankamagames.dofus.network.types.game.context.roleplay.quest
{
    import com.ankamagames.jerakine.network.INetworkType;
    import __AS3__.vec.Vector;
    import flash.utils.IDataOutput;
    import flash.utils.IDataInput;
    import __AS3__.vec.*;

    public class GameRolePlayNpcQuestFlag implements INetworkType 
    {

        public static const protocolId:uint = 384;

        public var questsToValidId:Vector.<uint>;
        public var questsToStartId:Vector.<uint>;

        public function GameRolePlayNpcQuestFlag()
        {
            this.questsToValidId = new Vector.<uint>();
            this.questsToStartId = new Vector.<uint>();
            super();
        }

        public function getTypeId():uint
        {
            return (384);
        }

        public function initGameRolePlayNpcQuestFlag(questsToValidId:Vector.<uint>=null, questsToStartId:Vector.<uint>=null):GameRolePlayNpcQuestFlag
        {
            this.questsToValidId = questsToValidId;
            this.questsToStartId = questsToStartId;
            return (this);
        }

        public function reset():void
        {
            this.questsToValidId = new Vector.<uint>();
            this.questsToStartId = new Vector.<uint>();
        }

        public function serialize(output:IDataOutput):void
        {
            this.serializeAs_GameRolePlayNpcQuestFlag(output);
        }

        public function serializeAs_GameRolePlayNpcQuestFlag(output:IDataOutput):void
        {
            output.writeShort(this.questsToValidId.length);
            var _i1:uint;
            while (_i1 < this.questsToValidId.length)
            {
                if (this.questsToValidId[_i1] < 0)
                {
                    throw (new Error((("Forbidden value (" + this.questsToValidId[_i1]) + ") on element 1 (starting at 1) of questsToValidId.")));
                };
                output.writeShort(this.questsToValidId[_i1]);
                _i1++;
            };
            output.writeShort(this.questsToStartId.length);
            var _i2:uint;
            while (_i2 < this.questsToStartId.length)
            {
                if (this.questsToStartId[_i2] < 0)
                {
                    throw (new Error((("Forbidden value (" + this.questsToStartId[_i2]) + ") on element 2 (starting at 1) of questsToStartId.")));
                };
                output.writeShort(this.questsToStartId[_i2]);
                _i2++;
            };
        }

        public function deserialize(input:IDataInput):void
        {
            this.deserializeAs_GameRolePlayNpcQuestFlag(input);
        }

        public function deserializeAs_GameRolePlayNpcQuestFlag(input:IDataInput):void
        {
            var _val1:uint;
            var _val2:uint;
            var _questsToValidIdLen:uint = input.readUnsignedShort();
            var _i1:uint;
            while (_i1 < _questsToValidIdLen)
            {
                _val1 = input.readShort();
                if (_val1 < 0)
                {
                    throw (new Error((("Forbidden value (" + _val1) + ") on elements of questsToValidId.")));
                };
                this.questsToValidId.push(_val1);
                _i1++;
            };
            var _questsToStartIdLen:uint = input.readUnsignedShort();
            var _i2:uint;
            while (_i2 < _questsToStartIdLen)
            {
                _val2 = input.readShort();
                if (_val2 < 0)
                {
                    throw (new Error((("Forbidden value (" + _val2) + ") on elements of questsToStartId.")));
                };
                this.questsToStartId.push(_val2);
                _i2++;
            };
        }


    }
}//package com.ankamagames.dofus.network.types.game.context.roleplay.quest

