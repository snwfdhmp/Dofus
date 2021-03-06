﻿package com.ankamagames.dofus.logic.shield
{
    import com.ankamagames.jerakine.logger.Logger;
    import com.ankamagames.jerakine.logger.Log;
    import flash.utils.getQualifiedClassName;
    import flash.utils.Timer;
    import flash.utils.Dictionary;
    import com.ankamagames.dofus.misc.utils.RpcServiceManager;
    import com.ankamagames.jerakine.managers.StoreDataManager;
    import com.ankamagames.dofus.Constants;
    import com.ankamagames.jerakine.utils.errors.SingletonError;
    import com.ankamagames.berilia.managers.KernelEventsManager;
    import com.ankamagames.dofus.misc.lists.HookList;
    import com.ankamagames.dofus.network.types.secure.TrustCertificate;
    import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
    import com.ankamagames.dofus.BuildInfos;
    import com.ankamagames.dofus.network.enums.BuildTypeEnum;
    import com.ankamagames.dofus.types.events.RpcEvent;
    import com.ankamagames.jerakine.data.I18n;
    import flash.filesystem.File;
    import com.ankamagames.jerakine.types.CustomSharedObject;
    import flash.filesystem.FileStream;
    import by.blooddy.crypto.MD5;
    import flash.filesystem.FileMode;
    import com.ankamagames.jerakine.managers.ErrorManager;

    public class SecureModeManager 
    {

        protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SecureModeManager));
        private static const VALIDATECODE_CODEEXPIRE:String = "CODEEXPIRE";
        private static const VALIDATECODE_CODEBADCODE:String = "CODEBADCODE";
        private static const VALIDATECODE_CODENOTFOUND:String = "CODENOTFOUND";
        private static const VALIDATECODE_SECURITY:String = "SECURITY";
        private static const VALIDATECODE_TOOMANYCERTIFICATE:String = "TOOMANYCERTIFICATE";
        private static const VALIDATECODE_NOTAVAILABLE:String = "NOTAVAILABLE";
        private static const ACCOUNT_AUTHENTIFICATION_FAILED:String = "ACCOUNT_AUTHENTIFICATION_FAILED";
        private static var RPC_URL:String;
        private static const RPC_METHOD_SECURITY_CODE:String = "SecurityCode";
        private static const RPC_METHOD_VALIDATE_CODE:String = "ValidateCode";
        private static const RPC_METHOD_MIGRATE:String = "Migrate";
        private static var _self:SecureModeManager;

        private var _timeout:Timer;
        private var _active:Boolean;
        private var _computerName:String;
        private var _methodsCallback:Dictionary;
        private var _hasV1Certif:Boolean;
        private var _rpcManager:RpcServiceManager;
        public var shieldLevel:uint;

        public function SecureModeManager()
        {
            this._timeout = new Timer(30000);
            this._methodsCallback = new Dictionary();
            this.shieldLevel = StoreDataManager.getInstance().getSetData(Constants.DATASTORE_COMPUTER_OPTIONS, "shieldLevel", ShieldSecureLevel.MEDIUM);
            super();
            if (_self)
            {
                throw (new SingletonError());
            };
            this.initRPC();
        }

        public static function getInstance():SecureModeManager
        {
            if (!(_self))
            {
                _self = new (SecureModeManager)();
            };
            return (_self);
        }


        public function get active():Boolean
        {
            return (this._active);
        }

        public function set active(b:Boolean):void
        {
            this._active = b;
            KernelEventsManager.getInstance().processCallback(HookList.SecureModeChange, b);
        }

        public function get computerName():String
        {
            return (this._computerName);
        }

        public function set computerName(name:String):void
        {
            this._computerName = name;
        }

        public function get certificate():TrustCertificate
        {
            return (this.retreiveCertificate());
        }

        public function askCode(callback:Function):void
        {
            this._methodsCallback[RPC_METHOD_SECURITY_CODE] = callback;
            this._rpcManager.callMethod(RPC_METHOD_SECURITY_CODE, [this.getUsername(), AuthentificationManager.getInstance().ankamaPortalKey, 1]);
        }

        public function sendCode(code:String, callback:Function):void
        {
            var fooCertif:ShieldCertifcate = new ShieldCertifcate();
            fooCertif.secureLevel = this.shieldLevel;
            this._methodsCallback[RPC_METHOD_VALIDATE_CODE] = callback;
            this._rpcManager.callMethod(RPC_METHOD_VALIDATE_CODE, [this.getUsername(), AuthentificationManager.getInstance().ankamaPortalKey, 1, code.toUpperCase(), fooCertif.hash, fooCertif.reverseHash, ((this._computerName) ? true : (false)), ((this._computerName) ? this._computerName : "")]);
        }

        private function initRPC():void
        {
            if ((((((BuildInfos.BUILD_TYPE == BuildTypeEnum.DEBUG)) || ((BuildInfos.BUILD_TYPE == BuildTypeEnum.INTERNAL)))) || ((BuildInfos.BUILD_TYPE == BuildTypeEnum.TESTING))))
            {
                RPC_URL = "http://api.ankama.lan/ankama/shield.json";
            }
            else
            {
                RPC_URL = "https://api.ankama.com/ankama/shield.json";
                goto _label_2;
                while (this._rpcManager.addEventListener(RpcEvent.EVENT_ERROR, this.onRpcData), true)
                {
                    return;
                    
                _label_1: 
                    this._rpcManager.addEventListener(RpcEvent.EVENT_DATA, this.onRpcData);
                    continue;
                    var _local_1 = _local_1;
                };
                var _local_0 = this;
            };
            
        _label_2: 
            this._rpcManager = new RpcServiceManager(RPC_URL, "json");
            goto _label_1;
            var _local_2 = _local_2;
            return;
        }

        private function getUsername():String
        {
            return (AuthentificationManager.getInstance().username.toLowerCase().split("|")[0]);
        }

        private function parseRpcValidateResponse(response:Object, method:String):Object
        {
            var success:Boolean;
            while (true)
            {
                goto _label_1;
            };
            var _local_7 = _local_7;
            
        _label_1: 
            var result:Object = new Object();
            for (;;)
            {
                result.fatal = false;
                while (true)
                {
                    result.retry = false;
                    //unresolved jump
                };
                result.error = response.error;
                continue;
                
            _label_2: 
                result.text = "";
                goto _label_3;
            };
            
        _label_3: 
            switch (response.error)
            {
                case VALIDATECODE_CODEEXPIRE:
                    goto _label_6;
                    
                _label_4: 
                    result.fatal = true;
                    goto _label_7;
                    
                _label_5: 
                    goto _label_4;
                    
                _label_6: 
                    result.text = I18n.getUiText("ui.secureMode.error.checkCode.expire");
                    goto _label_5;
                    
                _label_7: 
                    goto _label_26;
                case VALIDATECODE_CODEBADCODE:
                    goto _label_10;
                    
                _label_8: 
                    result.retry = true;
                    goto _label_11;
                    
                _label_9: 
                    result.text = I18n.getUiText("ui.secureMode.error.checkCode.403");
                    goto _label_8;
                    var _local_6 = _local_6;
                    
                _label_10: 
                    goto _label_9;
                    
                _label_11: 
                    goto _label_26;
                case VALIDATECODE_CODENOTFOUND:
                    result.text = (I18n.getUiText("ui.secureMode.error.checkCode.404") + " (1)");
                    while (true)
                    {
                        result.fatal = true;
                        goto _label_12;
                    };
                    
                _label_12: 
                    goto _label_26;
                case VALIDATECODE_SECURITY:
                    while (true)
                    {
                        result.text = I18n.getUiText("ui.secureMode.error.checkCode.security");
                        while (true)
                        {
                            result.fatal = true;
                            goto _label_13;
                        };
                    };
                    var _local_0 = this;
                    
                _label_13: 
                    goto _label_26;
                case VALIDATECODE_TOOMANYCERTIFICATE:
                    goto _label_16;
                    
                _label_14: 
                    result.fatal = true;
                    goto _label_17;
                    
                _label_15: 
                    goto _label_14;
                    
                _label_16: 
                    result.text = I18n.getUiText("ui.secureMode.error.checkCode.413");
                    goto _label_15;
                    _local_0 = this;
                    
                _label_17: 
                    goto _label_26;
                case VALIDATECODE_NOTAVAILABLE:
                    goto _label_20;
                    
                _label_18: 
                    goto _label_21;
                    
                _label_19: 
                    result.fatal = true;
                    goto _label_18;
                    _local_0 = this;
                    
                _label_20: 
                    result.text = I18n.getUiText("ui.secureMode.error.checkCode.202");
                    goto _label_19;
                    
                _label_21: 
                    goto _label_26;
                case ACCOUNT_AUTHENTIFICATION_FAILED:
                    while (true)
                    {
                        result.text = (I18n.getUiText("ui.secureMode.error.checkCode.404") + " (2)");
                        goto _label_24;
                    };
                    
                _label_22: 
                    goto _label_25;
                    
                _label_23: 
                    result.fatal = true;
                    goto _label_22;
                    
                _label_24: 
                    goto _label_23;
                    
                _label_25: 
                    goto _label_26;
                default:
                    result.text = ((response.error) ? response.error : I18n.getUiText("ui.secureMode.error.default"));
                    result.fatal = true;
            };
            
        _label_26: 
            if (((response.certificate) && (response.id)))
            {
                while ((success = this.addCertificate(response.id, response.certificate, this.shieldLevel)), true)
                {
                    goto _label_27;
                };
                var _local_5 = _local_5;
                
            _label_27: 
                if (!(success))
                {
                    result.text = I18n.getUiText("ui.secureMode.error.checkCode.202.fatal");
                    while ((result.fatal = true), true)
                    {
                        goto _label_28;
                    };
                };
            };
            
        _label_28: 
            return (result);
        }

        private function parseRpcASkCodeResponse(response:Object, method:String):Object
        {
            while (true)
            {
                goto _label_1;
            };
            var _local_5 = _local_5;
            
        _label_1: 
            var result:Object = new Object();
            for (;;)
            {
                result.retry = false;
                goto _label_6;
                
            _label_2: 
                goto _label_7;
                
            _label_3: 
                result.fatal = false;
                continue;
                
            _label_4: 
                result.text = "";
                goto _label_2;
                var _local_6 = _local_6;
                
            _label_5: 
                goto _label_3;
                var _local_0 = this;
                result.error = !(result.error);
                goto _label_5;
                
            _label_6: 
                goto _label_4;
            };
            
        _label_7: 
            if (!(response.error))
            {
                while ((result.domain = response.domain), true)
                {
                    goto _label_8;
                };
                
            _label_8: 
                result.error = false;
            }
            else
            {
                switch (response.error)
                {
                    case ACCOUNT_AUTHENTIFICATION_FAILED:
                        _loop_1:
                        for (;;)
                        {
                            result.fatal = true;
                            while (goto _label_10, true)
                            {
                                
                            _label_9: 
                                result.text = (I18n.getUiText("ui.secureMode.error.checkCode.404") + " (3)");
                                continue _loop_1;
                            };
                        };
                        _local_0 = this;
                        
                    _label_10: 
                        break;
                    case VALIDATECODE_CODEEXPIRE:
                        while ((result.text = I18n.getUiText("ui.secureMode.error.checkCode.expire")), (result.fatal = true), true)
                        {
                            goto _label_11;
                        };
                        _local_0 = this;
                        
                    _label_11: 
                        break;
                    default:
                        for (;;continue, (method = method))
                        {
                            result.text = I18n.getUiText("ui.secureMode.error.default");
                            continue;
                            
                        _label_12: 
                            //unresolved jump
                            result.fatal = true;
                            goto _label_12;
                        };
                        var _local_4 = _local_4;
                };
            };
            return (result);
        }

        private function getCertifFolder(version:uint, useCustomSharedObjectFolder:Boolean=false):File
        {
            var f:File;
            var tmp:Array;
            var parentDir:String;
            while (true)
            {
                goto _label_1;
            };
            var _local_7 = _local_7;
            
        _label_1: 
            if (!(useCustomSharedObjectFolder))
            {
                goto _label_5;
                
            _label_2: 
                goto _label_6;
                
            _label_3: 
                tmp.pop();
                goto _label_2;
                var _local_6 = _local_6;
                while (tmp.pop(), true)
                {
                    goto _label_3;
                    
                _label_4: 
                    tmp = File.applicationStorageDirectory.nativePath.split(File.separator);
                    continue;
                };
                
            _label_5: 
                goto _label_7;
                
            _label_6: 
                parentDir = tmp.join(File.separator);
                //unresolved jump
                
            _label_7: 
                goto _label_4;
            }
            else
            {
                parentDir = CustomSharedObject.getCustomSharedObjectDirectory();
            };
            if (version == 1)
            {
                while ((f = new File(((parentDir + File.separator) + "AnkamaCertificates/"))), true)
                {
                    goto _label_8;
                };
            };
            
        _label_8: 
            if (version == 2)
            {
                f = new File(((parentDir + File.separator) + "AnkamaCertificates/v2-RELEASE"));
                goto _label_10;
                
            _label_9: 
                goto _label_11;
            };
            
        _label_10: 
            f.createDirectory();
            goto _label_9;
            
        _label_11: 
            return (f);
        }

        private function addCertificate(id:uint, content:String, secureLevel:uint=2):Boolean
        {
            //unresolved jump
            
        _label_1: 
            cert.version = 3;
            for (;;goto _label_1, (content = content), goto _label_3, (var _local_5 = _local_5), goto _label_10, var cert:ShieldCertifcate, continue, (var _local_7 = _local_7))
            {
                cert.content = content;
                goto _label_4;
                
            _label_2: 
                secureLevel = secureLevel;
                goto _label_11;
                
            _label_3: 
                content = content;
                goto _label_2;
                var addCertificate$0 = addCertificate$0;
                
            _label_4: 
                goto _label_12;
                
            _label_5: 
                cert.id = id;
                continue;
                
            _label_6: 
                goto _label_13;
                
            _label_7: 
                goto _label_5;
                
            _label_8: 
                cert = new ShieldCertifcate();
                goto _label_7;
                var f:File;
                goto _label_9;
            };
            var _local_0 = this;
            
        _label_9: 
            var fs:FileStream;
            //unresolved jump
            
        _label_10: 
            goto _label_8;
            var _local_6 = _local_6;
            
        _label_11: 
            //unresolved jump
            
        _label_12: 
            cert.secureLevel = secureLevel;
            goto _label_6;
            
        _label_13: 
            f = _local_0.getCertifFolder(2);
            while ((f = f.resolvePath(MD5.hash(_local_0.getUsername()))), goto _label_15, goto _label_16, fs.close(), //unresolved jump
, (id = id), (fs = new FileStream()), true)
            {
                goto _label_14;
            };
            while (fs.writeBytes(cert.serialize()), true)
            {
                //unresolved jump
                
            _label_14: 
                fs.open(f, FileMode.WRITE);
                continue;
            };
            
        _label_15: 
            //unresolved jump
            
        _label_16: 
            return (true);
            e = e;
            f = getCertifFolder(2, true);
            //unresolved jump
            
        _label_17: 
            goto _label_23;
            
        _label_18: 
            fs.close();
            goto _label_17;
            
        _label_19: 
            fs = new FileStream();
            goto _label_22;
            
        _label_20: 
            goto _label_18;
            
        _label_21: 
            while (fs.writeBytes(cert.serialize()), goto _label_20, (secureLevel = secureLevel), fs.open(f, FileMode.WRITE), goto _label_21, (var _local_8 = _local_8), (f = f.resolvePath(MD5.hash(getUsername()))), true)
            {
                goto _label_19;
            };
            
        _label_22: 
            //unresolved jump
            
        _label_23: 
            return (true);
            e = e;
            ErrorManager.addError(("Error writing certificate file at " + f.nativePath), id);
            return (false);
        }

        public function checkMigrate():void
        {
            if (!(this._hasV1Certif))
            {
                return;
            };
            var certif:TrustCertificate = this.retreiveCertificate();
            this.migrate(certif.id, certif.hash);
        }

        private function getCertificateFile():File
        {
            while (var userName:String, var f:File, true)
            {
                goto _label_1;
            };
            var _local_2 = _local_2;
            try
            {
                
            _label_1: 
                userName = this.getUsername();
                while ((f = this.getCertifFolder(2).resolvePath(MD5.hash(userName))), true)
                {
                    goto _label_2;
                };
                
            _label_2: 
                if (!(f.exists))
                {
                    while ((f = this.getCertifFolder(1).resolvePath(MD5.hash(userName))), true)
                    {
                        goto _label_3;
                    };
                    var _local_0 = this;
                };
                
            _label_3: 
                if (!(f.exists))
                {
                    while ((f = this.getCertifFolder(2, true).resolvePath(MD5.hash(userName))), true)
                    {
                        goto _label_4;
                    };
                    var _local_4 = _local_4;
                };
                
            _label_4: 
                if (f.exists)
                {
                    return (f);
                };
            }
            catch(e:Error)
            {
                _log.error(("Erreur lors de la recherche du certifcat : " + e.message));
            };
            return (null);
        }

        public function retreiveCertificate():TrustCertificate
        {
            var f:File;
            var fs:FileStream;
            var certif:ShieldCertifcate;
            try
            {
                this._hasV1Certif = false;
                f = this.getCertificateFile();
                if (f)
                {
                    fs = new FileStream();
                    fs.open(f, FileMode.READ);
                    certif = ShieldCertifcate.fromRaw(fs);
                    fs.close();
                    return (certif.toNetwork());
                };
            }
            catch(e:Error)
            {
                ErrorManager.addError("Impossible de lire le fichier de certificat.", e);
            };
            return (null);
        }

        private function onRpcData(e:RpcEvent):void
        {
            if ((((e.type == RpcEvent.EVENT_ERROR)) && (!(e.result))))
            {
                var _local_2 = this._methodsCallback;
                (_local_2[e.method]({
                    "error":true,
                    "fatal":true,
                    "text":I18n.getUiText("ui.secureMode.error.checkCode.503")
                }));
                return;
            };
            if (e.method == RPC_METHOD_SECURITY_CODE)
            {
                _local_2 = this._methodsCallback;
                (_local_2[e.method](this.parseRpcASkCodeResponse(e.result, e.method)));
            };
            if (e.method == RPC_METHOD_VALIDATE_CODE)
            {
                _local_2 = this._methodsCallback;
                (_local_2[e.method](this.parseRpcValidateResponse(e.result, e.method)));
            };
            if (e.method == RPC_METHOD_MIGRATE)
            {
                if (e.result.success)
                {
                    this.migrationSuccess(e.result);
                }
                else
                {
                    _log.error(("Impossible de migrer le certificat : " + e.result.error));
                };
            };
            return;
        }

        private function migrate(iCertificateId:uint, oldCertif:String):void
        {
            while (true)
            {
                goto _label_1;
            };
            var fooCertif = fooCertif;
            
        _label_1: 
            fooCertif = new ShieldCertifcate();
            goto _label_4;
            
        _label_2: 
            return;
            
        _label_3: 
            this._rpcManager.callMethod(RPC_METHOD_MIGRATE, [this.getUsername(), AuthentificationManager.getInstance().ankamaPortalKey, 1, 2, iCertificateId, oldCertif, fooCertif.hash, fooCertif.reverseHash]);
            goto _label_2;
            var _local_4 = _local_4;
            
        _label_4: 
            fooCertif.secureLevel = this.shieldLevel;
            goto _label_3;
            return;
        }

        private function migrationSuccess(result:Object):void
        {
            var f:File = this.getCertificateFile();
            if (f.exists)
            {
                goto _label_2;
                
            _label_1: 
                return;
            };
            
        _label_2: 
            this.addCertificate(result.id, result.certificate);
            goto _label_1;
            return;
        }


    }
}//package com.ankamagames.dofus.logic.shield

