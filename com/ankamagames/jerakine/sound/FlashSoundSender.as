﻿package com.ankamagames.jerakine.sound
{
    import com.ankamagames.jerakine.logger.Logger;
    import com.ankamagames.jerakine.logger.Log;
    import flash.utils.getQualifiedClassName;
    import flash.events.StatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;

    public class FlashSoundSender extends AbstractFlashSound 
    {

        private static const _log:Logger = Log.getLogger(getQualifiedClassName(FlashSoundSender));

        public function FlashSoundSender(lcid:uint=0)
        {
            super(lcid);
            _conn.addEventListener(StatusEvent.STATUS, this.onStatus);
            _conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.dispatchError);
        }

        private function dispatchError(pEvt:ErrorEvent):void
        {
            dispatchEvent(pEvt);
        }

        private function onStatus(pEvt:StatusEvent):void
        {
            switch (pEvt.level)
            {
                case "status":
                    pEvt.currentTarget.removeEventListener(StatusEvent.STATUS, this.onStatus);
                    dispatchEvent(new Event(Event.CONNECT));
                    removePingTimer();
                    return;
                case "error":
                    if (_currentNbPing >= LIMIT_PING_TRY)
                    {
                        _log.fatal("nb try reached");
                        pEvt.currentTarget.removeEventListener(StatusEvent.STATUS, this.onStatus);
                        dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
                        removePingTimer();
                    }
                    else
                    {
                        _pingTimer.start();
                    };
                    return;
                default:
                    _log.fatal(("status level: " + pEvt.level));
            };
        }

        override public function connect(host:String, port:int):void
        {
            _currentNbPing++;
            _log.debug("try to ping");
            _conn.send(CONNECTION_NAME, "ping");
        }

        override public function flush():void
        {
            _conn.send(CONNECTION_NAME, "onData", _data);
            _data.clear();
        }


    }
}//package com.ankamagames.jerakine.sound

