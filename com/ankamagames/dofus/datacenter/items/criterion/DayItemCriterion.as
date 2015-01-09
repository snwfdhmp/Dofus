﻿package com.ankamagames.dofus.datacenter.items.criterion
{
    import com.ankamagames.jerakine.interfaces.IDataCenter;
    import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
    import com.ankamagames.jerakine.data.I18n;
    import com.ankamagames.dofus.logic.game.common.managers.TimeManager;

    public class DayItemCriterion extends ItemCriterion implements IDataCenter 
    {

        public function DayItemCriterion(pCriterion:String)
        {
            super(pCriterion);
        }

        override public function get text():String
        {
            var readableCriterionValue:String = _criterionValue.toString();
            var readableCriterionRef:String = PatternDecoder.combine(I18n.getUiText("ui.time.days"), "n", true);
            return (((((readableCriterionRef + " ") + _operator.text) + " ") + readableCriterionValue));
        }

        override public function clone():IItemCriterion
        {
            var clonedCriterion:DayItemCriterion = new DayItemCriterion(this.basicText);
            return (clonedCriterion);
        }

        override protected function getCriterion():int
        {
            var date:Date = new Date();
            return (TimeManager.getInstance().getDateFromTime(date.getTime())[2]);
        }


    }
}//package com.ankamagames.dofus.datacenter.items.criterion

