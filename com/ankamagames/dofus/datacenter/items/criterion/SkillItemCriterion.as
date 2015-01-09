﻿package com.ankamagames.dofus.datacenter.items.criterion
{
    import com.ankamagames.jerakine.interfaces.IDataCenter;

    public class SkillItemCriterion extends ItemCriterion implements IDataCenter 
    {

        public function SkillItemCriterion(pCriterion:String)
        {
            super(pCriterion);
        }

        override public function get text():String
        {
            return (((((_criterionRef + " ") + _operator.text) + " ") + _criterionValue));
        }

        override public function clone():IItemCriterion
        {
            var clonedCriterion:SkillItemCriterion = new SkillItemCriterion(this.basicText);
            return (clonedCriterion);
        }

        override protected function getCriterion():int
        {
            return (0);
        }


    }
}//package com.ankamagames.dofus.datacenter.items.criterion

