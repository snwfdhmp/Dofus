﻿package com.ankamagames.dofus.logic.game.fight.steps
{
    import com.ankamagames.jerakine.sequencer.AbstractSequencable;
    import __AS3__.vec.Vector;
    import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
    import com.ankamagames.jerakine.sequencer.SerialSequencer;
    import com.ankamagames.dofus.internalDatacenter.communication.ChatBubble;
    import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
    import com.ankamagames.dofus.datacenter.spells.Spell;
    import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
    import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
    import com.ankamagames.dofus.network.enums.FightSpellCastCriticalEnum;
    import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
    import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
    import com.ankamagames.jerakine.data.I18n;
    import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
    import com.ankamagames.berilia.managers.TooltipManager;
    import com.ankamagames.berilia.managers.UiModuleManager;
    import com.ankamagames.berilia.types.LocationEnum;

    public class FightSpellCastStep extends AbstractSequencable implements IFightStep 
    {

        private var _fighterId:int;
        private var _cellId:int;
        private var _sourceCellId:int;
        private var _spellId:int;
        private var _spellRank:uint;
        private var _critical:uint;
        private var _portalIds:Vector.<int>;

        public function FightSpellCastStep(fighterId:int, cellId:int, sourceCellId:int, spellId:int, spellRank:uint, critical:uint)
        {
            this._fighterId = fighterId;
            this._cellId = cellId;
            this._sourceCellId = sourceCellId;
            this._spellId = spellId;
            this._spellRank = spellRank;
            this._critical = critical;
        }

        public function get stepType():String
        {
            return ("spellCast");
        }

        override public function start():void
        {
            var fighterInfos:GameFightFighterInformations;
            var seq:SerialSequencer;
            var bubble:ChatBubble;
            var fighterEntity:IDisplayable;
            if (Spell.getSpellById(this._spellId).verbose_cast)
            {
                FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_CASTED_SPELL, [this._fighterId, this._cellId, this._sourceCellId, this._spellId, this._spellRank, this._critical], 0, castingSpellId, false);
            };
            if (this._critical != FightSpellCastCriticalEnum.NORMAL)
            {
                fighterInfos = (FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._fighterId) as GameFightFighterInformations);
                seq = new SerialSequencer();
                if (this._critical == FightSpellCastCriticalEnum.CRITICAL_HIT)
                {
                    seq.addStep(new AddGfxEntityStep(1062, fighterInfos.disposition.cellId));
                }
                else
                {
                    if (this._critical == FightSpellCastCriticalEnum.CRITICAL_FAIL)
                    {
                        bubble = new ChatBubble(I18n.getUiText("ui.fight.criticalMiss"));
                        fighterEntity = (DofusEntities.getEntity(this._fighterId) as IDisplayable);
                        if (fighterEntity)
                        {
                            TooltipManager.show(bubble, fighterEntity.absoluteBounds, UiModuleManager.getInstance().getModule("Ankama_Tooltips"), true, ("ec" + this._fighterId), LocationEnum.POINT_BOTTOMLEFT, LocationEnum.POINT_TOPRIGHT, 0, true, null, null);
                        };
                        seq.addStep(new AddGfxEntityStep(1070, fighterInfos.disposition.cellId));
                    };
                };
                seq.start();
            };
            executeCallbacks();
        }


    }
}//package com.ankamagames.dofus.logic.game.fight.steps

