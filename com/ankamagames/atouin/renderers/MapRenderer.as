﻿package com.ankamagames.atouin.renderers
{
    import com.ankamagames.atouin.*;
    import com.ankamagames.atouin.data.elements.*;
    import com.ankamagames.atouin.data.elements.subtypes.*;
    import com.ankamagames.atouin.data.map.*;
    import com.ankamagames.atouin.data.map.elements.*;
    import com.ankamagames.atouin.enums.*;
    import com.ankamagames.atouin.managers.*;
    import com.ankamagames.atouin.types.*;
    import com.ankamagames.atouin.types.events.*;
    import com.ankamagames.jerakine.data.*;
    import com.ankamagames.jerakine.logger.*;
    import com.ankamagames.jerakine.managers.*;
    import com.ankamagames.jerakine.resources.adapters.impl.*;
    import com.ankamagames.jerakine.resources.events.*;
    import com.ankamagames.jerakine.resources.loaders.*;
    import com.ankamagames.jerakine.script.*;
    import com.ankamagames.jerakine.types.*;
    import com.ankamagames.jerakine.types.positions.*;
    import com.ankamagames.jerakine.utils.display.*;
    import com.ankamagames.jerakine.utils.system.*;
    import com.ankamagames.sweevo.runners.*;
    import com.ankamagames.tiphon.display.*;
    import com.ankamagames.tiphon.types.look.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.utils.*;
    import org.flintparticles.twoD.renderers.*;

    public class MapRenderer extends EventDispatcher
    {
        public var useDefautState:Boolean;
        private var _container:DisplayObjectContainer;
        private var _elements:Elements;
        private var _gfxLoader:IResourceLoader;
        private var _swfLoader:IResourceLoader;
        private var _map:Map;
        private var _useSmooth:Boolean;
        private var _cacheRef:Array;
        private var _bitmapsGfx:Array;
        private var _swfGfx:Array;
        private var _swfApplicationDomain:Array;
        private var _dataMapContainer:DataMapContainer;
        private var _icm:InteractiveCellManager;
        private var _hideForeground:Boolean;
        private var _identifiedElements:Dictionary;
        private var _gfxPath:String;
        private var _gfxSubPathJpg:String;
        private var _gfxSubPathPng:String;
        private var _particlesPath:String;
        private var _hasSwfGxf:Boolean;
        private var _hasBitmapGxf:Boolean;
        private var _loadedGfxListCount:uint = 0;
        private var _pictoAsBitmap:Boolean;
        private var _mapLoaded:Boolean = true;
        private var _groundLayerCtrIndex:int;
        private var _hasGroundJPG:Boolean = false;
        private var _skipGroundCache:Boolean = false;
        private var _forceReloadWithoutCache:Boolean = false;
        private var _groundIsLoaded:Boolean = false;
        private var _mapIsReady:Boolean = false;
        private var _allowAnimatedGfx:Boolean;
        private var _debugLayer:Boolean;
        private var _allowParticlesFx:Boolean;
        private var _gfxMemorySize:uint = 0;
        private var _renderId:uint = 0;
        private var _extension:String;
        private var _progressBarCtr:Sprite;
        private var _downloadProgressBar:Shape;
        private var _downloadTimer:Timer;
        private var _fileToLoad:uint;
        private var _fileLoaded:uint;
        private var _cancelRender:Boolean;
        private var _bitmapForegroundContainer:Bitmap;
        private var _layersData:Array;
        private var _tacticModeActivated:Boolean = false;
        private var colorTransform:ColorTransform;
        private var _m:Matrix;
        private var _srcRect:Rectangle;
        private var _destPoint:Point;
        private var _ceilBitmapData:BitmapData;
        private var _clTrans:ColorTransform;
        public static var MEMORY_LOG_1:Dictionary = new Dictionary(true);
        public static var MEMORY_LOG_2:Dictionary = new Dictionary(true);
        static const _log:Logger = Log.getLogger(getQualifiedClassName(MapRenderer));
        public static var cachedAsBitmapElement:Array = new Array();
        public static var boundingBoxElements:Array;
        private static var _bitmapOffsetPoint:Point;
        private static var _groundGlobalScaleRatio:Number;

        public function MapRenderer(param1:DisplayObjectContainer, param2:Elements)
        {
            var _loc_4:* = undefined;
            this._bitmapsGfx = [];
            this._swfGfx = [];
            this._swfApplicationDomain = new Array();
            this._hideForeground = Atouin.getInstance().options.hideForeground;
            this._downloadTimer = new Timer(1);
            this.colorTransform = new ColorTransform();
            this._m = new Matrix();
            this._srcRect = new Rectangle();
            this._destPoint = new Point();
            this._clTrans = new ColorTransform();
            this._container = param1;
            if (isNaN(_groundGlobalScaleRatio))
            {
                _loc_4 = XmlConfig.getInstance().getEntry("config.gfx.world.scaleRatio");
                _groundGlobalScaleRatio = _loc_4 == null ? (1) : (parseFloat(_loc_4));
            }
            if (_bitmapOffsetPoint == null)
            {
                _bitmapOffsetPoint = StageShareManager.stage.localToGlobal(new Point(this._container.x, this._container.y));
            }
            this._elements = param2;
            this._icm = InteractiveCellManager.getInstance();
            this._gfxPath = Atouin.getInstance().options.elementsPath;
            this._gfxSubPathJpg = Atouin.getInstance().options.jpgSubPath;
            this._gfxSubPathPng = Atouin.getInstance().options.pngSubPath;
            this._particlesPath = Atouin.getInstance().options.particlesScriptsPath;
            this._extension = Atouin.getInstance().options.mapPictoExtension;
            var _loc_3:* = new Shape();
            _loc_3.graphics.lineStyle(1, 8947848);
            _loc_3.graphics.beginFill(2236962);
            _loc_3.graphics.drawRect(0, 0, 600, 10);
            _loc_3.x = 0;
            _loc_3.y = 0;
            this._downloadProgressBar = new Shape();
            this._downloadProgressBar.graphics.beginFill(10077440);
            this._downloadProgressBar.graphics.drawRect(0, 0, 597, 7);
            this._downloadProgressBar.graphics.endFill();
            this._downloadProgressBar.x = 2;
            this._downloadProgressBar.y = 2;
            this._progressBarCtr = new Sprite();
            this._progressBarCtr.addChild(_loc_3);
            this._progressBarCtr.addChild(this._downloadProgressBar);
            this._progressBarCtr.x = (StageShareManager.startWidth - this._progressBarCtr.width) / 2;
            this._progressBarCtr.y = (StageShareManager.startHeight - this._progressBarCtr.height) / 2;
            this._gfxLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
            this._gfxLoader.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE, this.onAllGfxLoaded, false, 0, true);
            this._gfxLoader.addEventListener(ResourceLoadedEvent.LOADED, this.onBitmapGfxLoaded, false, 0, true);
            this._gfxLoader.addEventListener(ResourceErrorEvent.ERROR, this.onGfxError, false, 0, true);
            this._swfLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
            this._swfLoader.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE, this.onAllGfxLoaded, false, 0, true);
            this._swfLoader.addEventListener(ResourceLoadedEvent.LOADED, this.onSwfGfxLoaded, false, 0, true);
            this._swfLoader.addEventListener(ResourceErrorEvent.ERROR, this.onGfxError, false, 0, true);
            this._downloadTimer.addEventListener(TimerEvent.TIMER, this.onDownloadTimer);
            return;
        }// end function

        public function get gfxMemorySize() : uint
        {
            return this._gfxMemorySize;
        }// end function

        public function get identifiedElements() : Dictionary
        {
            return this._identifiedElements;
        }// end function

        public function initRenderContainer(param1:DisplayObjectContainer) : void
        {
            this._container = param1;
            return;
        }// end function

        public function render(param1:DataMapContainer, param2:Boolean = false, param3:uint = 0) : void
        {
            var _loc_11:* = null;
            var _loc_13:* = false;
            var _loc_14:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_17:* = null;
            var _loc_18:* = 0;
            this._cancelRender = false;
            this._downloadTimer.reset();
            this._gfxMemorySize = 0;
            this._fileLoaded = 0;
            this._renderId = param3;
            Atouin.getInstance().cancelZoom();
            AnimatedElementManager.reset();
            boundingBoxElements = new Array();
            this._allowAnimatedGfx = Atouin.getInstance().options.allowAnimatedGfx;
            this._debugLayer = Atouin.getInstance().options.debugLayer;
            this._allowParticlesFx = Atouin.getInstance().options.allowParticlesFx;
            var _loc_4:* = !this._mapLoaded;
            this._mapLoaded = false;
            this._groundIsLoaded = false;
            this._mapIsReady = false;
            this._map = param1.dataMap;
            this._forceReloadWithoutCache = param2;
            var _loc_5:* = AirScanner.isStreamingVersion() ? (0) : (Atouin.getInstance().options.groundCacheMode);
            if (param2)
            {
                this._skipGroundCache = true;
                this._hasGroundJPG = false;
            }
            else
            {
                this._skipGroundCache = DataGroundMapManager.mapsCurrentlyRendered() > AtouinConstants.MAX_GROUND_CACHE_MEMORY || _loc_5 == 0;
                this._map.groundCacheCurrentlyUsed = _loc_5;
                if (_loc_5 && !this._skipGroundCache)
                {
                    _loc_18 = DataGroundMapManager.loadGroundMap(this._map, this.groundMapLoaded, this.groundMapNotLoaded);
                    if (_loc_18 == GroundCache.GROUND_CACHE_AVAILABLE)
                    {
                        this._hasGroundJPG = true;
                    }
                    else if (_loc_18 == GroundCache.GROUND_CACHE_NOT_AVAILABLE)
                    {
                        this._hasGroundJPG = false;
                    }
                    else if (_loc_18 == GroundCache.GROUND_CACHE_ERROR)
                    {
                        this._hasGroundJPG = false;
                        _loc_5 = 0;
                        Atouin.getInstance().options.groundCacheMode = 0;
                    }
                    else if (_loc_18 == GroundCache.GROUND_CACHE_SKIP)
                    {
                        this._skipGroundCache = true;
                        this._hasGroundJPG = false;
                    }
                }
                else
                {
                    this._hasGroundJPG = false;
                }
            }
            if (this._hasGroundJPG)
            {
                Atouin.getInstance().worldContainer.visible = false;
            }
            this._cacheRef = new Array();
            var _loc_6:* = new Array();
            var _loc_7:* = new Array();
            this._useSmooth = Atouin.getInstance().options.useSmooth;
            this._dataMapContainer = param1;
            this._identifiedElements = new Dictionary(true);
            this._loadedGfxListCount = 0;
            this._hasSwfGxf = false;
            this._hasBitmapGxf = false;
            var _loc_8:* = new Array();
            var _loc_9:* = new Array();
            var _loc_10:* = this._map.getGfxList(this._hasGroundJPG);
            var _loc_12:* = new LoaderContext();
            AirScanner.allowByteCodeExecution(_loc_12, true);
            for each (_loc_16 in _loc_10)
            {
                
                if (!(_loc_16 is NormalGraphicalElementData))
                {
                    continue;
                }
                _loc_14 = _loc_16 as NormalGraphicalElementData;
                if (_loc_14 is AnimatedGraphicalElementData)
                {
                    _loc_15 = new ApplicationDomain();
                    _loc_11 = new Uri(this._gfxPath + "/swf/" + _loc_14.gfxId + ".swf");
                    _loc_11.loaderContext = new LoaderContext(false, _loc_15);
                    AirScanner.allowByteCodeExecution(_loc_11.loaderContext, true);
                    _loc_9.push(_loc_11);
                    this._hasSwfGxf = true;
                    _loc_11.tag = _loc_14.gfxId;
                    this._cacheRef[_loc_14.gfxId] = "RES_" + _loc_11.toSum();
                    this._swfApplicationDomain[_loc_14.gfxId] = _loc_15;
                    continue;
                }
                if (this._bitmapsGfx[_loc_14.gfxId])
                {
                    _loc_6[_loc_14.gfxId] = this._bitmapsGfx[_loc_14.gfxId];
                    continue;
                }
                _loc_13 = Elements.getInstance().isJpg(_loc_14.gfxId);
                _loc_11 = new Uri(this._gfxPath + "/" + (_loc_13 ? (this._gfxSubPathJpg) : (this._gfxSubPathPng)) + "/" + _loc_14.gfxId + "." + (_loc_13 ? ("jpg") : (this._extension)));
                _loc_8.push(_loc_11);
                this._hasBitmapGxf = true;
                _loc_11.tag = _loc_14.gfxId;
                this._cacheRef[_loc_14.gfxId] = "RES_" + _loc_11.toSum();
            }
            if (!this._hasGroundJPG)
            {
                for each (_loc_17 in this._map.backgroundFixtures)
                {
                    
                    if (this._bitmapsGfx[_loc_17.fixtureId])
                    {
                        _loc_6[_loc_17.fixtureId] = this._bitmapsGfx[_loc_17.fixtureId];
                        continue;
                    }
                    _loc_13 = Elements.getInstance().isJpg(_loc_17.fixtureId);
                    _loc_11 = new Uri(this._gfxPath + "/" + (_loc_13 ? (this._gfxSubPathJpg) : (this._gfxSubPathPng)) + "/" + _loc_17.fixtureId + "." + (_loc_13 ? ("jpg") : (this._extension)));
                    _loc_11.tag = _loc_17.fixtureId;
                    _loc_8.push(_loc_11);
                    this._hasBitmapGxf = true;
                    this._cacheRef[_loc_17.fixtureId] = "RES_" + _loc_11.toSum();
                }
            }
            for each (_loc_17 in this._map.foregroundFixtures)
            {
                
                if (this._bitmapsGfx[_loc_17.fixtureId])
                {
                    _loc_6[_loc_17.fixtureId] = this._bitmapsGfx[_loc_17.fixtureId];
                    continue;
                }
                _loc_13 = Elements.getInstance().isJpg(_loc_17.fixtureId);
                _loc_11 = new Uri(this._gfxPath + "/" + (_loc_13 ? (this._gfxSubPathJpg) : (this._gfxSubPathPng)) + "/" + _loc_17.fixtureId + "." + (_loc_13 ? ("jpg") : (this._extension)));
                _loc_11.tag = _loc_17.fixtureId;
                _loc_8.push(_loc_11);
                this._hasBitmapGxf = true;
                this._cacheRef[_loc_17.fixtureId] = "RES_" + _loc_11.toSum();
            }
            dispatchEvent(new RenderMapEvent(RenderMapEvent.GFX_LOADING_START, false, false, this._map.id, this._renderId));
            this._bitmapsGfx = _loc_6;
            this._swfGfx = new Array();
            if (_loc_4)
            {
                this._gfxLoader.removeEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE, this.onAllGfxLoaded);
                this._gfxLoader.removeEventListener(ResourceLoadedEvent.LOADED, this.onBitmapGfxLoaded);
                this._gfxLoader.removeEventListener(ResourceErrorEvent.ERROR, this.onGfxError);
                this._swfLoader.removeEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE, this.onAllGfxLoaded);
                this._swfLoader.removeEventListener(ResourceLoadedEvent.LOADED, this.onSwfGfxLoaded);
                this._swfLoader.removeEventListener(ResourceErrorEvent.ERROR, this.onGfxError);
                this._gfxLoader.cancel();
                this._swfLoader.cancel();
                this._gfxLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
                this._gfxLoader.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE, this.onAllGfxLoaded, false, 0, true);
                this._gfxLoader.addEventListener(ResourceLoadedEvent.LOADED, this.onBitmapGfxLoaded, false, 0, true);
                this._gfxLoader.addEventListener(ResourceErrorEvent.ERROR, this.onGfxError, false, 0, true);
                this._swfLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
                this._swfLoader.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE, this.onAllGfxLoaded, false, 0, true);
                this._swfLoader.addEventListener(ResourceLoadedEvent.LOADED, this.onSwfGfxLoaded, false, 0, true);
                this._swfLoader.addEventListener(ResourceErrorEvent.ERROR, this.onGfxError, false, 0, true);
            }
            this._fileToLoad = _loc_8.length + _loc_9.length;
            this._gfxLoader.load(_loc_8);
            this._swfLoader.load(_loc_9, null, AdvancedSwfAdapter);
            this._downloadTimer.start();
            if (_loc_8.length == 0 && _loc_9.length == 0)
            {
                this.onAllGfxLoaded(null);
            }
            return;
        }// end function

        public function unload() : void
        {
            this._cancelRender = true;
            this._gfxLoader.cancel();
            this._swfLoader.cancel();
            RasterizedAnimation.optimize(1);
            while (cachedAsBitmapElement.length)
            {
                
                cachedAsBitmapElement.shift().cacheAsBitmap = false;
            }
            this._map = null;
            if (this._dataMapContainer)
            {
                this._dataMapContainer.removeContainer();
            }
            while (this._container.numChildren)
            {
                
                this._container.removeChildAt(0);
            }
            return;
        }// end function

        public function modeTactic(param1:Boolean) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            if (param1 && this._container.opaqueBackground != 0)
            {
                this._container.opaqueBackground = 0;
            }
            else if (!param1 && this._map)
            {
                this._container.opaqueBackground = this._map.backgroundColor;
            }
            this._tacticModeActivated = param1;
            if (!param1 && this._layersData && this._layersData.length > 0)
            {
                for each (_loc_2 in this._layersData)
                {
                    
                    _loc_2.data.visible = true;
                }
                this._layersData = null;
            }
            else if (param1 && this._groundIsLoaded)
            {
                this._layersData = new Array();
                _loc_2 = new Object();
                _loc_2.data = this._container.getChildAt(0);
                _loc_2.index = 0;
                this._layersData.push(_loc_2);
                _loc_2.data.visible = false;
            }
            else if (param1)
            {
                this._layersData = new Array();
                _loc_6 = this._map.layers.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_6)
                {
                    
                    _loc_3 = this._map.layers[_loc_5];
                    _loc_4 = this._container.getChildAt(0);
                    _loc_2 = new Object();
                    _loc_2.data = _loc_4;
                    _loc_2.index = _loc_5;
                    this._layersData.push(_loc_2);
                    _loc_4.visible = false;
                    _loc_5++;
                }
            }
            if (param1 && this._bitmapForegroundContainer != null)
            {
                this._bitmapForegroundContainer.visible = false;
            }
            else if (!param1 && this._bitmapForegroundContainer != null)
            {
                this._bitmapForegroundContainer.visible = true;
            }
            return;
        }// end function

        private function makeMap() : void
        {
            var layerCtr:DisplayObjectContainer;
            var cellInteractionCtr:DisplayObjectContainer;
            var groundLayerCtr:Bitmap;
            var cellCtr:ICellContainer;
            var cellPnt:Point;
            var cellDisabled:Boolean;
            var hideFg:Boolean;
            var skipLayer:Boolean;
            var groundLayer:Boolean;
            var i:uint;
            var nbCell:uint;
            var cell:Cell;
            var layer:Layer;
            var endCell:Cell;
            var t:ColorTransform;
            var reelBmpDt:BitmapData;
            var m:Matrix;
            var tmp:Bitmap;
            var tsJpeg:uint;
            this._downloadTimer.stop();
            if (this._progressBarCtr.parent)
            {
                this._progressBarCtr.parent.removeChild(this._progressBarCtr);
            }
            this._pictoAsBitmap = Atouin.getInstance().options.useCacheAsBitmap;
            groundLayerCtr = new Bitmap(new BitmapData(StageShareManager.startWidth * _groundGlobalScaleRatio, StageShareManager.startHeight * _groundGlobalScaleRatio, false, this._map.backgroundColor), "auto", true);
            groundLayerCtr.x = groundLayerCtr.x - _bitmapOffsetPoint.x;
            var aInteractiveCell:* = new Array();
            dispatchEvent(new RenderMapEvent(RenderMapEvent.MAP_RENDER_START, false, false, this._map.id, this._renderId));
            if (!this._hasGroundJPG)
            {
                this.renderFixture(this._map.backgroundFixtures, groundLayerCtr);
            }
            InteractiveCellManager.getInstance().initManager();
            EntitiesManager.getInstance().initManager();
            this._container.opaqueBackground = this._map.backgroundColor;
            var layerId:uint;
            var groundOnly:* = OptionManager.getOptionManager("atouin").groundOnly;
            var lastCellId:int;
            var currentCellId:uint;
            var _loc_2:* = 0;
            var _loc_3:* = this._map.layers;
            do
            {
                
                layer = _loc_3[_loc_2];
                layerId = layer.layerId;
                if (layer.layerId == Layer.LAYER_DECOR)
                {
                    layerCtr = this._dataMapContainer.getLayer(layerId);
                }
                else
                {
                    layerCtr;
                }
                groundLayer = layerCtr == null;
                hideFg = layerId && this._hideForeground;
                skipLayer = groundOnly;
                if (layer.cellsCount == 0)
                {
                }
                else
                {
                    if ((layer.cells[(layer.cells.length - 1)] as Cell).cellId != (AtouinConstants.MAP_CELLS_COUNT - 1))
                    {
                        endCell = new Cell(layer);
                        endCell.cellId = AtouinConstants.MAP_CELLS_COUNT - 1;
                        endCell.elementsCount = 0;
                        endCell.elements = [];
                        layer.cells.push(endCell);
                    }
                    i;
                    nbCell = layer.cells.length;
                    while (i < nbCell)
                    {
                        
                        cell = layer.cells[i];
                        currentCellId = cell.cellId;
                        if (layerId == Layer.LAYER_GROUND)
                        {
                            if (currentCellId - lastCellId > 1)
                            {
                                currentCellId = (lastCellId + 1);
                                cell;
                            }
                            else
                            {
                                i = (i + 1);
                            }
                        }
                        else
                        {
                            i = (i + 1);
                        }
                        if (groundLayer)
                        {
                            cellCtr = new BitmapCellContainer(currentCellId);
                        }
                        else
                        {
                            cellCtr = new CellContainer(currentCellId);
                        }
                        cellCtr.com.ankamagames.atouin.types:ICellContainer::layerId = layerId;
                        cellCtr.mouseEnabled = false;
                        if (cell)
                        {
                            cellPnt = cell.pixelCoords;
                            var _loc_4:* = int(Math.round(cellPnt.x)) * (cellCtr is CellContainer ? (_groundGlobalScaleRatio) : (1));
                            cellCtr.startX = int(Math.round(cellPnt.x)) * (cellCtr is CellContainer ? (_groundGlobalScaleRatio) : (1));
                            cellCtr.x = _loc_4;
                            var _loc_4:* = int(Math.round(cellPnt.y)) * (cellCtr is CellContainer ? (_groundGlobalScaleRatio) : (1));
                            cellCtr.startY = int(Math.round(cellPnt.y)) * (cellCtr is CellContainer ? (_groundGlobalScaleRatio) : (1));
                            cellCtr.y = _loc_4;
                            if (!skipLayer)
                            {
                                if (!this._hasGroundJPG || !groundLayer)
                                {
                                    cellDisabled = this.addCellBitmapsElements(cell, cellCtr, hideFg, groundLayer);
                                }
                            }
                        }
                        else
                        {
                            cellDisabled;
                            cellPnt = Cell.cellPixelCoords(currentCellId);
                            var _loc_4:* = cellPnt.x;
                            cellCtr.startX = cellPnt.x;
                            cellCtr.x = _loc_4;
                            var _loc_4:* = cellPnt.y;
                            cellCtr.startY = cellPnt.y;
                            cellCtr.y = _loc_4;
                        }
                        if (!groundLayer)
                        {
                            layerCtr.addChild(cellCtr as DisplayObject);
                        }
                        else if (!this._hasGroundJPG && groundLayer)
                        {
                            this.drawGround(groundLayerCtr, cellCtr as BitmapCellContainer);
                        }
                        this._dataMapContainer.getCellReference(currentCellId).addSprite(cellCtr as DisplayObject);
                        this._dataMapContainer.getCellReference(currentCellId).x = cellCtr.x;
                        this._dataMapContainer.getCellReference(currentCellId).y = cellCtr.y;
                        this._dataMapContainer.getCellReference(currentCellId).isDisabled = cellDisabled;
                        if (layerId == Layer.LAYER_DECOR)
                        {
                            this._dataMapContainer.getCellReference(currentCellId).heightestDecor = cellCtr as Sprite;
                        }
                        if (!aInteractiveCell[currentCellId])
                        {
                            aInteractiveCell[currentCellId] = true;
                            cellInteractionCtr = this._icm.getCell(currentCellId);
                            cellInteractionCtr.y = cellCtr.y - (this._tacticModeActivated ? (0) : (this._map.cells[currentCellId].floor));
                            cellInteractionCtr.x = cellCtr.x;
                            if (!this._dataMapContainer.getChildByName(currentCellId.toString()))
                            {
                                DataMapContainer.interactiveCell[currentCellId] = new InteractiveCell(currentCellId, cellInteractionCtr, cellCtr.x, cellCtr.y - (this._tacticModeActivated ? (0) : (this._map.cells[currentCellId].floor)));
                            }
                            this._dataMapContainer.getCellReference(currentCellId).elevation = cellCtr.y - (this._tacticModeActivated ? (0) : (this._map.cells[currentCellId].floor));
                            this._dataMapContainer.getCellReference(currentCellId).mov = CellData(this._map.cells[currentCellId]).mov;
                        }
                        lastCellId = currentCellId;
                    }
                    if (!groundLayer)
                    {
                        layerCtr.mouseEnabled = false;
                    }
                    if (this._debugLayer)
                    {
                        t = new ColorTransform();
                        t.color = Math.random() * 16777215;
                        layerCtr.transform.colorTransform = t;
                    }
                    if (!groundLayer)
                    {
                        var _loc_4:* = 1 / _groundGlobalScaleRatio;
                        layerCtr.scaleY = 1 / _groundGlobalScaleRatio;
                        layerCtr.scaleX = _loc_4;
                        this._container.addChild(layerCtr);
                    }
                    else if (!this._hasGroundJPG && groundLayer)
                    {
                        reelBmpDt = new BitmapData(AtouinConstants.RESOLUTION_HIGH_QUALITY.x, AtouinConstants.RESOLUTION_HIGH_QUALITY.y, false, this._map.backgroundColor);
                        m = new Matrix();
                        m.scale(1 / _groundGlobalScaleRatio, 1 / _groundGlobalScaleRatio);
                        reelBmpDt.lock();
                        reelBmpDt.draw(groundLayerCtr.bitmapData, m, null, null, null, true);
                        reelBmpDt.unlock();
                        tmp = new Bitmap(reelBmpDt, "auto", true);
                        tmp.x = -_bitmapOffsetPoint.x;
                        this._container.addChild(tmp);
                    }
                    if (!this._skipGroundCache && !this._hasGroundJPG && layerId == Layer.LAYER_GROUND)
                    {
                        try
                        {
                            tsJpeg = getTimer();
                            DataGroundMapManager.saveGroundMap(groundLayerCtr.bitmapData, this._map);
                        }
                        catch (e:Error)
                        {
                            _log.fatal("Impossible de sauvegarder le sol de la map " + _map.id + " sous forme JPEG");
                            _log.fatal(e.getStackTrace());
                        }
                    }
                }
            }while (_loc_3 in _loc_2)
            this._bitmapForegroundContainer = new Bitmap(new BitmapData(StageShareManager.startWidth, StageShareManager.startHeight, true, this._map.backgroundColor), "auto", true);
            this._bitmapForegroundContainer.x = -_bitmapOffsetPoint.x;
            this.renderFixture(this._map.foregroundFixtures, this._bitmapForegroundContainer);
            this._bitmapForegroundContainer.visible = !this._tacticModeActivated;
            this._container.addChild(this._bitmapForegroundContainer);
            if (!this._hasGroundJPG)
            {
                groundLayerCtr.cacheAsBitmap = true;
            }
            var selectionContainer:* = new Sprite();
            this._container.addChild(selectionContainer);
            selectionContainer.mouseEnabled = false;
            selectionContainer.mouseChildren = false;
            if (!this._hasGroundJPG || this._groundIsLoaded)
            {
                dispatchEvent(new RenderMapEvent(RenderMapEvent.MAP_RENDER_END, false, false, this._map.id, this._renderId));
                Atouin.getInstance().worldContainer.visible = true;
            }
            var atouin:* = Atouin.getInstance();
            if (this._map.zoomScale != 1 && atouin.options.useInsideAutoZoom)
            {
                atouin.rootContainer.scaleX = this._map.zoomScale;
                atouin.rootContainer.scaleY = this._map.zoomScale;
                atouin.rootContainer.x = this._map.zoomOffsetX;
                atouin.rootContainer.y = this._map.zoomOffsetY;
                atouin.currentZoom = this._map.zoomScale;
            }
            else
            {
                Atouin.getInstance().zoom(1);
            }
            this._mapIsReady = true;
            return;
        }// end function

        private function drawGround(param1:Bitmap, param2:BitmapCellContainer) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = false;
            var _loc_7:* = 0;
            var _loc_3:* = param1.bitmapData;
            var _loc_8:* = param2.numChildren;
            _loc_3.lock();
            _loc_7 = 0;
            while (_loc_7 < _loc_8)
            {
                
                if (!(param2.bitmaps[_loc_7] is BitmapData))
                {
                    _log.error("Attention, un élément non bitmap tente d\'être ajouter au sol " + param2.bitmaps[_loc_7]);
                }
                else
                {
                    _loc_5 = param2.bitmaps[_loc_7];
                    _loc_4 = param2.datas[_loc_7];
                    if (_loc_5 == null || _loc_4 == null)
                    {
                    }
                    else
                    {
                        if (param2.colorTransforms[_loc_7] != null)
                        {
                            _loc_6 = true;
                            this.colorTransform.redMultiplier = param2.colorTransforms[_loc_7].red;
                            this.colorTransform.greenMultiplier = param2.colorTransforms[_loc_7].green;
                            this.colorTransform.blueMultiplier = param2.colorTransforms[_loc_7].blue;
                            this.colorTransform.alphaMultiplier = param2.colorTransforms[_loc_7].alpha;
                        }
                        else
                        {
                            _loc_6 = false;
                        }
                        this._destPoint.x = _loc_4.x + param2.x;
                        if (_groundGlobalScaleRatio != 1)
                        {
                            this._destPoint.x = this._destPoint.x * _groundGlobalScaleRatio;
                        }
                        this._destPoint.x = this._destPoint.x + _bitmapOffsetPoint.x;
                        this._destPoint.y = _loc_4.y + param2.y;
                        if (_groundGlobalScaleRatio != 1)
                        {
                            this._destPoint.y = this._destPoint.y * _groundGlobalScaleRatio;
                        }
                        this._srcRect.width = _loc_5.width;
                        this._srcRect.height = _loc_5.height;
                        if (_loc_4.scaleX != 1 || _loc_4.scaleY != 1 || _loc_6)
                        {
                            this._m.identity();
                            this._m.scale(_loc_4.scaleX, _loc_4.scaleY);
                            this._m.translate(this._destPoint.x, this._destPoint.y);
                            _loc_3.draw(_loc_5, this._m, this.colorTransform, null, null, false);
                        }
                        else
                        {
                            _loc_3.copyPixels(_loc_5, this._srcRect, this._destPoint);
                        }
                    }
                }
                _loc_7++;
            }
            _loc_3.unlock();
            return;
        }// end function

        private function groundMapLoaded(param1:Bitmap) : void
        {
            this._groundIsLoaded = true;
            if (this._mapIsReady)
            {
                dispatchEvent(new RenderMapEvent(RenderMapEvent.MAP_RENDER_END, false, false, this._map.id, this._renderId));
                Atouin.getInstance().worldContainer.visible = true;
            }
            if (!this._tacticModeActivated)
            {
                param1.x = param1.x - _bitmapOffsetPoint.x;
                this._container.addChildAt(param1, 0);
            }
            param1.smoothing = true;
            _log.info("La map est chargée et affichée, tout va bien.");
            return;
        }// end function

        private function groundMapNotLoaded(param1:int) : void
        {
            var _loc_2:* = null;
            if (this._map.id == param1)
            {
                _loc_2 = MapDisplayManager.getInstance();
                _loc_2.display(_loc_2.currentMapPoint, true);
            }
            return;
        }// end function

        private function addCellBitmapsElements(param1:Cell, param2:ICellContainer, param3:Boolean = false, param4:Boolean = false) : Boolean
        {
            var elementDo:Object;
            var data:VisualData;
            var colors:Object;
            var ge:GraphicalElement;
            var ed:GraphicalElementData;
            var bounds:Rectangle;
            var element:BasicElement;
            var ged:NormalGraphicalElementData;
            var eed:EntityGraphicalElementData;
            var elementLook:TiphonEntityLook;
            var ts:WorldEntitySprite;
            var ped:ParticlesGraphicalElementData;
            var objectInfo:Object;
            var applicationDomain:ApplicationDomain;
            var ra:RasterizedAnimation;
            var renderer:DisplayObjectRenderer;
            var ie:Object;
            var namedSprite:Sprite;
            var elementDOC:DisplayObjectContainer;
            var bmp:Bitmap;
            var shape:Shape;
            var cell:* = param1;
            var cellCtr:* = param2;
            var transparent:* = param3;
            var ground:* = param4;
            var disabled:Boolean;
            var mouseChildren:Boolean;
            var cacheAsBitmap:Boolean;
            var hasBlendMode:Boolean;
            var lsElements:* = cell.elements;
            var nbElements:* = lsElements.length;
            var i:int;
            while (i < nbElements)
            {
                
                data = new VisualData();
                element = lsElements[i];
                switch(element.elementType)
                {
                    case ElementTypesEnum.GRAPHICAL:
                    {
                        ge = GraphicalElement(element);
                        ed = this._elements.getElementData(ge.elementId);
                        if (!ed)
                        {
                            break;
                        }
                        switch(true)
                        {
                            case ed is NormalGraphicalElementData:
                            {
                                ged = ed as NormalGraphicalElementData;
                                if (ged is AnimatedGraphicalElementData)
                                {
                                    objectInfo = this._swfGfx[ged.gfxId];
                                    applicationDomain = this._swfApplicationDomain[ged.gfxId];
                                    if (applicationDomain.hasDefinition("FX_0"))
                                    {
                                        elementDo = new applicationDomain.getDefinition("FX_0") as Sprite;
                                    }
                                    else if (this._map.getGfxCount(ged.gfxId) > 1)
                                    {
                                        if (ASwf(objectInfo).content == null)
                                        {
                                            _log.fatal("Impossible d\'afficher le picto " + ged.gfxId + " (format swf), le swf est probablement compilé en AS2");
                                            break;
                                        }
                                        ra = new RasterizedAnimation(ASwf(objectInfo).content as MovieClip, String(ged.gfxId));
                                        ra.gotoAndStop("1");
                                        ra.smoothing = true;
                                        elementDo = FpsControler.controlFps(ra, uint.MAX_VALUE);
                                        cacheAsBitmap;
                                    }
                                    else
                                    {
                                        elementDo = ASwf(objectInfo).content;
                                        if (elementDo is MovieClip)
                                        {
                                            if (!MovieClipUtils.isSingleFrame(elementDo as MovieClip))
                                            {
                                                cacheAsBitmap;
                                            }
                                        }
                                    }
                                    data.scaleX = 1;
                                    var _loc_6:* = 0;
                                    data.y = 0;
                                    data.x = _loc_6;
                                }
                                else if (ground)
                                {
                                    elementDo = this._bitmapsGfx[ged.gfxId];
                                }
                                else
                                {
                                    elementDo = new MapGfxBitmap(this._bitmapsGfx[ged.gfxId], "never", this._useSmooth, ge.identifier);
                                    elementDo.cacheAsBitmap = this._pictoAsBitmap;
                                    if (this._pictoAsBitmap)
                                    {
                                        cachedAsBitmapElement.push(elementDo);
                                    }
                                }
                                data.x = data.x - ged.origin.x;
                                data.y = data.y - ged.origin.y;
                                if (ged.horizontalSymmetry)
                                {
                                    data.scaleX = data.scaleX * -1;
                                    if (ged is AnimatedGraphicalElementData)
                                    {
                                        data.x = data.x + ASwf(this._swfGfx[ged.gfxId]).loaderWidth;
                                    }
                                    else
                                    {
                                        data.x = data.x + elementDo.width;
                                    }
                                }
                                if (ged is BoundingBoxGraphicalElementData)
                                {
                                    disabled;
                                    data.alpha = 0;
                                    boundingBoxElements[ge.identifier] = true;
                                }
                                if (elementDo is InteractiveObject)
                                {
                                    (elementDo as InteractiveObject).mouseEnabled = false;
                                    if (elementDo is DisplayObjectContainer)
                                    {
                                        (elementDo as DisplayObjectContainer).mouseChildren = false;
                                    }
                                }
                                if (ed is BlendedGraphicalElementData && elementDo.hasOwnProperty("blendMode"))
                                {
                                    elementDo.blendMode = (ed as BlendedGraphicalElementData).blendMode;
                                    elementDo.cacheAsBitmap = false;
                                    hasBlendMode;
                                }
                                break;
                            }
                            case ed is EntityGraphicalElementData:
                            {
                                eed = ed as EntityGraphicalElementData;
                                elementLook;
                                try
                                {
                                    elementLook = TiphonEntityLook.fromString(eed.entityLook);
                                }
                                catch (e:Error)
                                {
                                    _log.warn("Error in the Entity Element " + ed.id + "; misconstructed look string.");
                                    break;
                                }
                                ts = new WorldEntitySprite(elementLook, cell.cellId, ge.identifier);
                                ts.setDirection(0);
                                ts.mouseChildren = false;
                                ts.mouseEnabled = false;
                                ts.cacheAsBitmap = this._pictoAsBitmap;
                                if (this._pictoAsBitmap)
                                {
                                    cachedAsBitmapElement.push(ts);
                                }
                                if (this.useDefautState)
                                {
                                    ts.setAnimationAndDirection("AnimState0", 0);
                                }
                                if (eed.horizontalSymmetry)
                                {
                                    data.scaleX = data.scaleX * -1;
                                }
                                this._dataMapContainer.addAnimatedElement(ts, eed);
                                elementDo = ts;
                                break;
                            }
                            case ed is ParticlesGraphicalElementData:
                            {
                                ped = ed as ParticlesGraphicalElementData;
                                _log.debug("Rendering a particle element !");
                                if (this._allowParticlesFx)
                                {
                                    _log.debug("Particle element allowed !");
                                    renderer = new DisplayObjectRenderer();
                                    renderer.mouseChildren = false;
                                    renderer.mouseEnabled = false;
                                    cacheAsBitmap;
                                    ScriptExec.exec(new Uri(this._particlesPath + ped.scriptId + ".dx"), new EmitterRunner(renderer, null), true, null);
                                    elementDo = renderer as DisplayObject;
                                }
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                        if (elementDo == null)
                        {
                            _log.warn("A graphical element was missed (Element ID " + ge.elementId + "; Cell " + ge.cell.cellId + ").");
                            break;
                        }
                        if (!ge.colorMultiplicator.isOne())
                        {
                            colors;
                        }
                        if (transparent)
                        {
                            data.alpha = 0.5;
                        }
                        if (ge.identifier > 0)
                        {
                            if (!(elementDo is InteractiveObject) || elementDo is DisplayObjectContainer)
                            {
                                namedSprite = new SpriteWrapper(elementDo as DisplayObject, ge.identifier);
                                namedSprite.alpha = elementDo.alpha;
                                elementDo.alpha = 1;
                                elementDo.transform.colorTransform = new ColorTransform(colors.red, colors.green, colors.blue, colors.alpha);
                                colors;
                                elementDo = namedSprite;
                            }
                            mouseChildren;
                            elementDo.cacheAsBitmap = true;
                            cachedAsBitmapElement.push(elementDo);
                            if (elementDo is DisplayObjectContainer)
                            {
                                elementDOC = elementDo as DisplayObjectContainer;
                                elementDOC.mouseChildren = false;
                            }
                            ie = new Object();
                            this._identifiedElements[ge.identifier] = ie;
                            _log.debug("identifiedElements : " + ge.identifier);
                            ie.sprite = elementDo;
                            ie.position = MapPoint.fromCellId(cell.cellId);
                        }
                        data.x = data.x + Math.round(AtouinConstants.CELL_HALF_WIDTH + ge.pixelOffset.x);
                        data.y = data.y + Math.round(AtouinConstants.CELL_HALF_HEIGHT - ge.altitude * 10 + ge.pixelOffset.y);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (elementDo)
                {
                    cellCtr.addFakeChild(elementDo, data, colors);
                }
                else if (element.elementType != ElementTypesEnum.SOUND)
                {
                    if (this._ceilBitmapData == null)
                    {
                        this._ceilBitmapData = new BitmapData(AtouinConstants.CELL_WIDTH, AtouinConstants.CELL_HEIGHT, false, 13369548);
                        shape = new Shape();
                        shape.graphics.beginFill(13369548);
                        shape.graphics.drawRect(0, 0, AtouinConstants.CELL_WIDTH, AtouinConstants.CELL_HEIGHT);
                        shape.graphics.endFill();
                        this._ceilBitmapData.draw(shape);
                    }
                    bmp = new Bitmap(this._ceilBitmapData);
                    cellCtr.addFakeChild(bmp, null, null);
                }
                i = (i + 1);
            }
            if (this._pictoAsBitmap && !hasBlendMode)
            {
                cellCtr.cacheAsBitmap = cacheAsBitmap;
                if (cacheAsBitmap)
                {
                    cachedAsBitmapElement.push(cellCtr);
                }
            }
            else
            {
                cellCtr.cacheAsBitmap = false;
            }
            cellCtr.mouseChildren = mouseChildren;
            return disabled;
        }// end function

        private function renderFixture(param1:Array, param2:Bitmap) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            if (param1 == null || param1.length == 0)
            {
                return;
            }
            var _loc_3:* = OptionManager.getOptionManager("atouin").useSmooth;
            for each (_loc_5 in param1)
            {
                
                _loc_4 = this._bitmapsGfx[_loc_5.fixtureId];
                _loc_6 = _loc_4.width;
                _loc_7 = _loc_4.height;
                _loc_8 = _loc_6 * 0.5;
                _loc_9 = _loc_7 * 0.5;
                this._m.identity();
                this._m.translate(-_loc_8, -_loc_9);
                this._m.scale(_loc_5.xScale / 1000, _loc_5.yScale / 1000);
                this._m.rotate(_loc_5.rotation / 100 * (Math.PI / 180));
                this._m.translate(_loc_5.offset.x + _bitmapOffsetPoint.x + _loc_8 + AtouinConstants.CELL_HALF_WIDTH, _loc_5.offset.y + AtouinConstants.CELL_HEIGHT + _loc_9);
                param2.bitmapData.lock();
                if (_loc_5.redMultiplier || _loc_5.greenMultiplier || _loc_5.blueMultiplier || _loc_5.alpha != 1)
                {
                    this._clTrans.redMultiplier = _loc_5.redMultiplier / 128 + 1;
                    this._clTrans.greenMultiplier = _loc_5.greenMultiplier / 128 + 1;
                    this._clTrans.blueMultiplier = _loc_5.blueMultiplier / 128 + 1;
                    this._clTrans.alphaMultiplier = _loc_5.alpha / 255;
                    param2.bitmapData.draw(_loc_4, this._m, this._clTrans, null, null, _loc_3);
                }
                else
                {
                    param2.bitmapData.draw(_loc_4, this._m, null, null, null, _loc_3);
                }
                param2.bitmapData.unlock();
            }
            return;
        }// end function

        public function get container() : DisplayObjectContainer
        {
            return this._container;
        }// end function

        private function onAllGfxLoaded(event:ResourceLoaderProgressEvent) : void
        {
            if (this._cancelRender)
            {
                return;
            }
            var _loc_2:* = this;
            var _loc_3:* = this._loadedGfxListCount + 1;
            _loc_2._loadedGfxListCount = _loc_3;
            if (this._hasBitmapGxf && this._hasSwfGxf && this._loadedGfxListCount != 2)
            {
                return;
            }
            this._mapLoaded = true;
            dispatchEvent(new Event(RenderMapEvent.GFX_LOADING_END));
            this.makeMap();
            return;
        }// end function

        private function onBitmapGfxLoaded(event:ResourceLoadedEvent) : void
        {
            if (this._cancelRender)
            {
                return;
            }
            var _loc_2:* = this;
            var _loc_3:* = this._fileLoaded + 1;
            _loc_2._fileLoaded = _loc_3;
            this._downloadProgressBar.scaleX = this._fileLoaded / this._fileToLoad;
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, this._fileLoaded, this._fileToLoad));
            this._bitmapsGfx[event.uri.tag] = event.resource;
            this._gfxMemorySize = this._gfxMemorySize + BitmapData(event.resource).width * BitmapData(event.resource).height * 4;
            MEMORY_LOG_1[event.resource] = 1;
            return;
        }// end function

        private function onSwfGfxLoaded(event:ResourceLoadedEvent) : void
        {
            var _loc_2:* = this;
            var _loc_3:* = this._fileLoaded + 1;
            _loc_2._fileLoaded = _loc_3;
            this._downloadProgressBar.scaleX = this._fileLoaded / this._fileToLoad;
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, this._fileLoaded, this._fileToLoad));
            this._swfGfx[event.uri.tag] = event.resource;
            MEMORY_LOG_2[event.resource] = 1;
            return;
        }// end function

        private function onGfxError(event:ResourceErrorEvent) : void
        {
            _log.error("Unable to load " + event.uri);
            return;
        }// end function

        private function onDownloadTimer(event:TimerEvent) : void
        {
            if (Atouin.getInstance().options.showProgressBar)
            {
                this._container.addChild(this._progressBarCtr);
            }
            return;
        }// end function

    }
}

import com.ankamagames.atouin.*;

import com.ankamagames.atouin.data.elements.*;

import com.ankamagames.atouin.data.elements.subtypes.*;

import com.ankamagames.atouin.data.map.*;

import com.ankamagames.atouin.data.map.elements.*;

import com.ankamagames.atouin.enums.*;

import com.ankamagames.atouin.managers.*;

import com.ankamagames.atouin.types.*;

import com.ankamagames.atouin.types.events.*;

import com.ankamagames.jerakine.data.*;

import com.ankamagames.jerakine.logger.*;

import com.ankamagames.jerakine.managers.*;

import com.ankamagames.jerakine.resources.adapters.impl.*;

import com.ankamagames.jerakine.resources.events.*;

import com.ankamagames.jerakine.resources.loaders.*;

import com.ankamagames.jerakine.script.*;

import com.ankamagames.jerakine.types.*;

import com.ankamagames.jerakine.types.positions.*;

import com.ankamagames.jerakine.utils.display.*;

import com.ankamagames.jerakine.utils.system.*;

import com.ankamagames.sweevo.runners.*;

import com.ankamagames.tiphon.display.*;

import com.ankamagames.tiphon.types.look.*;

import flash.display.*;

import flash.events.*;

import flash.geom.*;

import flash.system.*;

import flash.utils.*;

import org.flintparticles.twoD.renderers.*;

class VisualData extends Object
{
    public var scaleX:Number = 1;
    public var scaleY:Number = 1;
    public var x:Number = 0;
    public var y:Number = 0;
    public var width:Number = 0;
    public var height:Number = 0;
    public var alpha:Number = 1;

    function VisualData()
    {
        return;
    }// end function

}

