﻿package com.ankamagames.dofus.datacenter.communication
{
    import com.ankamagames.jerakine.interfaces.IDataCenter;
    import com.ankamagames.jerakine.logger.Logger;
    import com.ankamagames.jerakine.logger.Log;
    import flash.utils.getQualifiedClassName;
    import __AS3__.vec.Vector;
    import com.ankamagames.jerakine.data.GameData;
    import com.ankamagames.jerakine.data.I18n;
    import com.ankamagames.tiphon.types.look.TiphonEntityLook;

    public class Emoticon implements IDataCenter 
    {

        public static const MODULE:String = "Emoticons";
        protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Emoticon));

        public var id:uint;
        public var nameId:uint;
        public var shortcutId:uint;
        public var order:uint;
        public var defaultAnim:String;
        public var persistancy:Boolean;
        public var eight_directions:Boolean;
        public var aura:Boolean;
        public var anims:Vector.<String>;
        public var cooldown:uint = 1000;
        public var duration:uint = 0;
        public var weight:uint;
        private var _name:String;
        private var _shortcut:String;


        public static function getEmoticonById(id:int):Emoticon
        {
            return ((GameData.getObject(MODULE, id) as Emoticon));
        }

        public static function getEmoticons():Array
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

        public function get shortcut():String
        {
            if (!(this._shortcut))
            {
                this._shortcut = I18n.getText(this.shortcutId);
            };
            if (((!(this._shortcut)) || ((this._shortcut == ""))))
            {
                return (this.defaultAnim);
            };
            return (this._shortcut);
        }

        public function getAnimName(look:TiphonEntityLook):String
        {
            var animName:String;
            var anim:String;
            var animCase:Array;
            var caseBoneId:uint;
            var caseSkins:Array;
            var matchingSkin:uint;
            var skin:String;
            var skinId:uint;
            var lookSkin:*;
            if (look)
            {
                for each (anim in this.anims)
                {
                    animCase = anim.split(";");
                    caseBoneId = parseInt(animCase[0]);
                    if (((look) && ((caseBoneId == look.getBone()))))
                    {
                        caseSkins = animCase[1].split(",");
                        matchingSkin = 0;
                        for each (skin in caseSkins)
                        {
                            skinId = parseInt(skin);
                            for each (lookSkin in look.skins)
                            {
                                if (skinId == lookSkin)
                                {
                                    matchingSkin++;
                                };
                            };
                        };
                        if (matchingSkin > 0)
                        {
                            animName = ("AnimEmote" + animCase[2]);
                        };
                    };
                };
            };
            if (!(animName))
            {
                animName = ((("AnimEmote" + this.defaultAnim.charAt(0).toUpperCase()) + this.defaultAnim.substr(1).toLowerCase()) + "_0");
            };
            return (animName);
        }


    }
}//package com.ankamagames.dofus.datacenter.communication

