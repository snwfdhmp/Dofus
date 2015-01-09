﻿package com.ankamagames.jerakine.types
{
    import flash.utils.IExternalizable;
    import flash.utils.IDataOutput;
    import flash.utils.IDataInput;

    public class DefaultableColor extends Color implements IExternalizable 
    {

        public var isDefault:Boolean = false;

        public function DefaultableColor(c:uint=0)
        {
            super(c);
        }

        override public function writeExternal(output:IDataOutput):void
        {
            super.writeExternal(output);
            output.writeBoolean(this.isDefault);
        }

        override public function readExternal(input:IDataInput):void
        {
            super.readExternal(input);
            this.isDefault = input.readBoolean();
        }


    }
}//package com.ankamagames.jerakine.types

