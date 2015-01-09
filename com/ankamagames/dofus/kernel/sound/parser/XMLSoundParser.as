﻿package com.ankamagames.dofus.kernel.sound.parser
{
    import __AS3__.vec.Vector;
    import com.ankamagames.jerakine.types.SoundEventParamWrapper;
    import __AS3__.vec.*;

    public class XMLSoundParser 
    {

        private static const _IDS_UNLOCALIZED:Array = new Array("20", "17", "16");

        private var _xmlBreed:XML;


        public static function parseXMLSoundFile(pXMLFile:XML, pSkins:Vector.<uint>):SoundEventParamWrapper
        {
            var matchingSoundNode:XML;
            var sound:XML;
            var vectorSEPW:Vector.<SoundEventParamWrapper>;
            var Sounds:XMLList;
            var aSounds:Vector.<SoundEventParamWrapper>;
            var Sound:XML;
            var randomIndex:uint;
            var skinsString:String;
            var skins:Array;
            var skin:String;
            var skinGapless:String;
            var skinId:uint;
            var sepw:SoundEventParamWrapper;
            var sounds:XMLList = pXMLFile.elements();
            var r:RegExp = /^\s*(.*?)\s*$/g;
            for each (sound in sounds)
            {
                if (matchingSoundNode != null)
                {
                }
                else
                {
                    skinsString = sound.@skin;
                    skins = skinsString.split(",");
                    for each (skin in skins)
                    {
                        skinGapless = skin.replace(r, "$1");
                        for each (skinId in pSkins)
                        {
                            if (skinGapless == skinId.toString())
                            {
                                matchingSoundNode = sound;
                            };
                        };
                    };
                };
            };
            vectorSEPW = new Vector.<SoundEventParamWrapper>();
            Sounds = matchingSoundNode.elements();
            aSounds = new Vector.<SoundEventParamWrapper>();
            for each (Sound in Sounds)
            {
                sepw = new SoundEventParamWrapper(Sound.Id, Sound.Volume, Sound.RollOff);
                sepw.berceauDuree = Sound.BerceauDuree;
                sepw.berceauVol = Sound.BerceauVol;
                sepw.berceauFadeIn = Sound.BerceauFadeIn;
                sepw.berceauFadeOut = Sound.BerceauFadeOut;
                vectorSEPW.push(sepw);
            };
            randomIndex = (Math.random() * Math.floor((vectorSEPW.length - 1)));
            return (vectorSEPW[randomIndex]);
        }

        public static function isLocalized(pSoundId:String):Boolean
        {
            var patternBegin:String;
            for each (patternBegin in _IDS_UNLOCALIZED)
            {
                if (pSoundId.split(patternBegin)[0] == "")
                {
                    return (false);
                };
            };
            return (true);
        }


    }
}//package com.ankamagames.dofus.kernel.sound.parser

