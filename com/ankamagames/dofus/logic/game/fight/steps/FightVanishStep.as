﻿package com.ankamagames.dofus.logic.game.fight.steps
{
    import com.ankamagames.jerakine.sequencer.AbstractSequencable;
    import com.ankamagames.jerakine.sequencer.ISequencer;
    import com.ankamagames.tiphon.display.TiphonSprite;
    import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
    import com.ankamagames.jerakine.entities.interfaces.IEntity;
    import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
    import com.ankamagames.jerakine.sequencer.SerialSequencer;
    import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
    import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
    import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
    import com.ankamagames.tiphon.sequence.PlayAnimationStep;
    import com.ankamagames.dofus.types.enums.AnimationEnum;
    import com.ankamagames.jerakine.sequencer.CallbackStep;
    import com.ankamagames.jerakine.types.Callback;
    import com.ankamagames.jerakine.types.events.SequencerEvent;
    import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
    import com.ankamagames.berilia.managers.TooltipManager;
    import com.ankamagames.dofus.kernel.Kernel;
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;

    public class FightVanishStep extends AbstractSequencable implements IFightStep 
    {

        private var _entityId:int;
        private var _sourceId:int;
        private var _vanishSubSequence:ISequencer;

        public function FightVanishStep(entityId:int, sourceId:int)
        {
            this._entityId = entityId;
            this._sourceId = sourceId;
        }

        public function get stepType():String
        {
            return ("vanish");
        }

        public function get entityId():int
        {
            return (this._entityId);
        }

        override public function start():void
        {
            var _local_2:Array;
            var _local_3:int;
            var vanishingTiphonEntity:TiphonSprite;
            var rider:TiphonSprite;
            var vanishingEntity:IEntity = DofusEntities.getEntity(this._entityId);
            if (!(vanishingEntity))
            {
                _log.warn((("Unable to play vanish of an unexisting fighter " + this._entityId) + "."));
                this.vanishFinished();
                return;
            };
            BuffManager.getInstance().dispell(vanishingEntity.id, false, false, true);
            _local_2 = BuffManager.getInstance().removeLinkedBuff(vanishingEntity.id, false, true);
            BuffManager.getInstance().reaffectBuffs(vanishingEntity.id);
            this._vanishSubSequence = new SerialSequencer(FightBattleFrame.FIGHT_SEQUENCER_NAME);
            _local_3 = FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._sourceId).disposition.cellId;
            if ((((vanishingEntity is TiphonSprite)) && (!((vanishingEntity.position.cellId == _local_3)))))
            {
                vanishingTiphonEntity = (vanishingEntity as TiphonSprite);
                rider = (vanishingTiphonEntity.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER, 0) as TiphonSprite);
                if (rider)
                {
                    vanishingTiphonEntity = rider;
                };
                this._vanishSubSequence.addStep(new PlayAnimationStep(vanishingTiphonEntity, AnimationEnum.ANIM_VANISH));
                this._vanishSubSequence.addStep(new CallbackStep(new Callback(this.onAnimEnd, vanishingEntity)));
            };
            this._vanishSubSequence.addStep(new CallbackStep(new Callback(this.manualRollOut, this._entityId)));
            this._vanishSubSequence.addStep(new FightDestroyEntityStep(vanishingEntity));
            this._vanishSubSequence.addEventListener(SequencerEvent.SEQUENCE_END, this.vanishFinished);
            this._vanishSubSequence.start();
        }

        override public function clear():void
        {
            if (this._vanishSubSequence)
            {
                this._vanishSubSequence.clear();
            };
            super.clear();
        }

        private function manualRollOut(fighterId:int):void
        {
            var fightContextFrame:FightContextFrame;
            if (FightContextFrame.fighterEntityTooltipId == fighterId)
            {
                TooltipManager.hide();
                TooltipManager.hide("fighter");
                fightContextFrame = (Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame);
                if (fightContextFrame)
                {
                    fightContextFrame.outEntity(fighterId);
                };
            };
        }

        private function onAnimEnd(vanishingEntity:TiphonSprite):void
        {
            var rider:TiphonSprite = (vanishingEntity.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER, 0) as TiphonSprite);
            if (rider)
            {
                vanishingEntity = rider;
            };
            var carriedEntity:DisplayObjectContainer = vanishingEntity.getSubEntitySlot(FightCarryCharacterStep.CARRIED_SUBENTITY_CATEGORY, FightCarryCharacterStep.CARRIED_SUBENTITY_INDEX);
            if (carriedEntity)
            {
                vanishingEntity.removeSubEntity(carriedEntity);
            };
        }

        private function vanishFinished(e:Event=null):void
        {
            if (this._vanishSubSequence)
            {
                this._vanishSubSequence.removeEventListener(SequencerEvent.SEQUENCE_END, this.vanishFinished);
                this._vanishSubSequence = null;
            };
            executeCallbacks();
        }


    }
}//package com.ankamagames.dofus.logic.game.fight.steps

