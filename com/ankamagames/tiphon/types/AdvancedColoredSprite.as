﻿package com.ankamagames.tiphon.types
{
    import flash.geom.ColorTransform;

    public class AdvancedColoredSprite extends ColoredSprite 
    {

        private static const baseColorTransform:ColorTransform = new ColorTransform();


        override public function colorize(colorT:ColorTransform):void
        {
            if (colorT)
            {
                baseColorTransform.redMultiplier = (colorT.redOffset / 128);
                baseColorTransform.greenMultiplier = (colorT.greenOffset / 128);
                baseColorTransform.blueMultiplier = (colorT.blueOffset / 128);
                transform.colorTransform = baseColorTransform;
            };
        }


    }
}//package com.ankamagames.tiphon.types

