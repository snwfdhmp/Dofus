﻿package com.ankamagames.dofus.datacenter.npcs
{
    import com.ankamagames.jerakine.interfaces.IDataCenter;
    import com.ankamagames.jerakine.logger.Logger;
    import com.ankamagames.jerakine.logger.Log;
    import flash.utils.getQualifiedClassName;
    import com.ankamagames.jerakine.data.GameData;
    import com.ankamagames.jerakine.data.I18n;

    public class TaxCollectorName implements IDataCenter 
    {

        protected static const _log:Logger = Log.getLogger(getQualifiedClassName(TaxCollectorName));
        public static const MODULE:String = "TaxCollectorNames";

        public var id:int;
        public var nameId:uint;
        private var _name:String;


        public static function getTaxCollectorNameById(id:int):TaxCollectorName
        {
            return ((GameData.getObject(MODULE, id) as TaxCollectorName));
        }

        public static function getTaxCollectorNames():Array
        {
            return (GameData.getObjects(MODULE));
        }


        public function get name():String
        {
            if (!(this._name))
            {
                this._name = I18n.getText(this.nameId);
            };
            return (this._name);
        }


    }
}//package com.ankamagames.dofus.datacenter.npcs

