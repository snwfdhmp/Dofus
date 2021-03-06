﻿package com.ankamagames.dofus.datacenter.misc
{
    import com.ankamagames.jerakine.interfaces.IDataCenter;
    import com.ankamagames.jerakine.data.GameData;

    public class Pack implements IDataCenter 
    {

        public static const MODULE:String = "Pack";

        public var id:int;
        public var name:String;
        public var hasSubAreas:Boolean;


        public static function getPackById(id:int):Pack
        {
            return ((GameData.getObject(MODULE, id) as Pack));
        }

        public static function getPackByName(name:String):Pack
        {
            var pack:Pack;
            var packs:Array = getAllPacks();
            for each (pack in packs)
            {
                if (name == pack.name)
                {
                    return (pack);
                };
            };
            return (null);
        }

        public static function getAllPacks():Array
        {
            return (GameData.getObjects(MODULE));
        }


    }
}//package com.ankamagames.dofus.datacenter.misc

