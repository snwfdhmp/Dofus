﻿package com.ankamagames.berilia.components
{
    import com.ankamagames.berilia.types.graphic.GraphicContainer;
    import com.ankamagames.berilia.FinalizableUIComponent;
    import flash.utils.Dictionary;
    import com.ankamagames.jerakine.logger.Logger;
    import com.ankamagames.jerakine.logger.Log;
    import flash.utils.getQualifiedClassName;
    import flash.display.Sprite;
    import flash.display.Shape;
    import com.ankamagames.berilia.types.graphic.MapGroupElement;
    import flash.geom.Rectangle;
    import com.ankamagames.berilia.types.data.Map;
    import __AS3__.vec.Vector;
    import com.ankamagames.berilia.types.data.MapArea;
    import com.ankamagames.jerakine.utils.system.AirScanner;
    import com.ankamagames.jerakine.utils.display.StageShareManager;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.display.InteractiveObject;
    import com.ankamagames.berilia.types.data.MapElement;
    import com.ankamagames.berilia.Berilia;
    import com.ankamagames.berilia.components.messages.MapMoveMessage;
    import flash.geom.ColorTransform;
    import com.ankamagames.jerakine.types.Uri;
    import com.ankamagames.berilia.types.graphic.MapAreaShape;
    import flash.display.Graphics;
    import com.ankamagames.berilia.types.data.LinkedCursorData;
    import flash.ui.Mouse;
    import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
    import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
    import com.ankamagames.jerakine.data.XmlConfig;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import com.ankamagames.berilia.components.messages.MapRollOverMessage;
    import com.ankamagames.jerakine.handlers.messages.mouse.MouseOverMessage;
    import com.ankamagames.jerakine.handlers.messages.mouse.MouseOutMessage;
    import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
    import com.ankamagames.jerakine.handlers.messages.mouse.MouseWheelMessage;
    import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightClickMessage;
    import com.ankamagames.berilia.components.messages.MapElementRollOverMessage;
    import com.ankamagames.berilia.components.messages.MapElementRollOutMessage;
    import com.ankamagames.jerakine.handlers.messages.mouse.MouseDownMessage;
    import com.ankamagames.berilia.managers.TooltipManager;
    import com.ankamagames.jerakine.handlers.messages.mouse.MouseReleaseOutsideMessage;
    import com.ankamagames.jerakine.handlers.messages.mouse.MouseUpMessage;
    import com.ankamagames.berilia.components.messages.MapElementRightClickMessage;
    import com.ankamagames.jerakine.messages.Message;
    import __AS3__.vec.*;

    public class MapViewer extends GraphicContainer implements FinalizableUIComponent 
    {

        public static var MEMORY_LOG:Dictionary = new Dictionary(true);
        protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MapViewer));
        public static var FLAG_CURSOR:Class;

        private var _finalized:Boolean;
        private var _showGrid:Boolean = false;
        private var _mapBitmapContainer:Sprite;
        private var _mapContainer:Sprite;
        private var _arrowContainer:Sprite;
        private var _grid:Shape;
        private var _areaShapesContainer:Sprite;
        private var _groupsContainer:Sprite;
        private var _layersContainer:Sprite;
        private var _openedMapGroupElement:MapGroupElement;
        private var _elementsGraphicRef:Dictionary;
        private var _lastMx:int;
        private var _lastMy:int;
        private var _viewRect:Rectangle;
        private var _layers:Array;
        private var _mapElements:Array;
        private var _dragging:Boolean;
        private var _currentMap:Map;
        private var _availableMaps:Array;
        private var _arrowPool:Array;
        private var _arrowAllocation:Dictionary;
        private var _reverseArrowAllocation:Dictionary;
        private var _mapGroupElements:Dictionary;
        private var _lastScaleIconUpdate:Number = -1;
        private var _enable3DMode:Boolean = false;
        private var _flagCursor:Sprite;
        private var _flagCursorVisible:Boolean;
        private var _mouseOnArrow:Boolean = false;
        private var _zoomLevels:Array;
        private var _zoomLevelsPercent:Array;
        private var _visibleMapAreas:Vector.<MapArea>;
        private var _mapToClear:Map;
        public var mapWidth:Number;
        public var mapHeight:Number;
        public var origineX:int;
        public var origineY:int;
        public var maxScale:Number = 2;
        public var minScale:Number = 0.5;
        public var startScale:Number = 0.8;
        public var roundCornerRadius:uint = 0;
        public var enabledDrag:Boolean = true;
        public var autoSizeIcon:Boolean = false;
        public var gridLineThickness:Number = 0.5;
        private var zz:Number = 1;
        private var _lastMouseX:int = 0;
        private var _lastMouseY:int = 0;

        public function MapViewer()
        {
            this._availableMaps = [];
            this._arrowPool = new Array();
            this._arrowAllocation = new Dictionary();
            this._reverseArrowAllocation = new Dictionary();
            this._mapGroupElements = new Dictionary();
            this._zoomLevels = [];
            super();
            MEMORY_LOG[this] = 1;
            if (AirScanner.hasAir())
            {
                StageShareManager.stage.nativeWindow.addEventListener(Event.DEACTIVATE, this.onWindowDeactivate);
            };
        }

        public function get mapContainerBounds():Rectangle
        {
            return (new Rectangle(this._mapContainer.x, this._mapContainer.y, this._mapContainer.width, this._mapContainer.height));
        }

        public function get finalized():Boolean
        {
            return (this._finalized);
        }

        public function set finalized(b:Boolean):void
        {
            this._finalized = b;
        }

        public function get showGrid():Boolean
        {
            return (this._showGrid);
        }

        public function set showGrid(b:Boolean):void
        {
            this._showGrid = b;
            this.drawGrid();
        }

        public function get isDragging():Boolean
        {
            return (this._dragging);
        }

        public function get visibleMaps():Rectangle
        {
            var vX:Number = (-(((this._mapContainer.x / this._mapContainer.scaleX) + this.origineX)) / this.mapWidth);
            var vY:Number = (-(((this._mapContainer.y / this._mapContainer.scaleY) + this.origineY)) / this.mapHeight);
            var vWidth:Number = ((width / (this.mapWidth * this._mapContainer.scaleX)) - 1);
            var vHeight:Number = ((height / (this.mapHeight * this._mapContainer.scaleY)) - 1);
            var w:Number = Math.ceil(vWidth);
            var h:Number = Math.ceil(vHeight);
            return (new Rectangle(vX, vY, (((w < 1)) ? 1 : w), (((h < 1)) ? 1 : h)));
        }

        public function get currentMouseMapX():int
        {
            return (this._lastMx);
        }

        public function get currentMouseMapY():int
        {
            return (this._lastMy);
        }

        public function get mapBounds():Rectangle
        {
            var rect:Rectangle = new Rectangle();
            rect.x = Math.floor((-(this.origineX) / this.mapWidth));
            rect.y = Math.floor((-(this.origineY) / this.mapHeight));
            if (this._currentMap)
            {
                rect.width = Math.round((this._currentMap.initialWidth / this.mapWidth));
                rect.height = Math.round((this._currentMap.initialHeight / this.mapHeight));
            }
            else
            {
                rect.width = Math.round((this._mapBitmapContainer.width / this.mapWidth));
                rect.height = Math.round((this._mapBitmapContainer.height / this.mapHeight));
            };
            return (rect);
        }

        public function set mapAlpha(value:Number):void
        {
            this._mapBitmapContainer.alpha = value;
        }

        public function get mapPixelPosition():Point
        {
            return (new Point(this._mapContainer.x, this._mapContainer.y));
        }

        public function get zoomFactor():Number
        {
            return (Number(this._mapContainer.scaleX.toFixed(2)));
        }

        override public function set width(nW:Number):void
        {
            super.width = nW;
            if (this.finalized)
            {
                this.initMask();
                this.updateVisibleChunck(false);
                this.updateMapElements();
            };
        }

        override public function set height(nH:Number):void
        {
            super.height = nH;
            if (this.finalized)
            {
                this.initMask();
                this.updateVisibleChunck(false);
                this.updateMapElements();
            };
        }

        public function setSize(w:Number, h:Number):void
        {
            super.width = w;
            super.height = h;
            if (this.finalized)
            {
                this.initMask();
                this.updateVisibleChunck(false);
                this.updateMapElements();
            };
        }

        public function get zoomStep():Number
        {
            return ((((this._availableMaps.length > 0)) ? (this.maxScale / this._availableMaps.length) : NaN));
        }

        public function get zoomLevels():Array
        {
            return (this._zoomLevels);
        }

        public function get allLayersVisible():Boolean
        {
            var layer:Sprite;
            for each (layer in this._layers)
            {
                if (!(layer.visible))
                {
                    return (false);
                };
            };
            return (true);
        }

        public function finalize():void
        {
            var arrow:Texture;
            var child:InteractiveObject;
            destroy(this._mapBitmapContainer);
            destroy(this._mapContainer);
            destroy(this._areaShapesContainer);
            destroy(this._groupsContainer);
            destroy(this._layersContainer);
            if (((this._arrowPool) && (this._arrowAllocation)))
            {
                for each (arrow in this._arrowAllocation)
                {
                    this._arrowPool.push(arrow);
                };
                this._arrowAllocation = new Dictionary();
            };
            MapElement.removeAllElements(this);
            this._viewRect = new Rectangle();
            this._mapBitmapContainer = new Sprite();
            this._mapBitmapContainer.doubleClickEnabled = true;
            this._mapBitmapContainer.mouseChildren = false;
            this._mapBitmapContainer.mouseEnabled = false;
            this._mapContainer = new Sprite();
            this._mapContainer.doubleClickEnabled = true;
            this._arrowContainer = new Sprite();
            this._arrowContainer.mouseEnabled = false;
            this._grid = new Shape();
            this._areaShapesContainer = new Sprite();
            this._areaShapesContainer.mouseEnabled = false;
            this._groupsContainer = new Sprite();
            this._groupsContainer.mouseEnabled = false;
            this._layersContainer = new Sprite();
            this._layersContainer.doubleClickEnabled = true;
            this._elementsGraphicRef = new Dictionary();
            this._layers = [];
            this._mapElements = [];
            this.initMap();
            this._finalized = true;
            var i:int;
            while (i < numChildren)
            {
                child = (getChildAt(i) as InteractiveObject);
                if (child)
                {
                    child.doubleClickEnabled = true;
                };
                i++;
            };
            this.setupZoomLevels(width, height);
            getUi().iAmFinalized(this);
        }

        public function setupZoomLevels(width:Number, height:Number):void
        {
            var zoom:Number;
            var zoomsToRemove:Vector.<Number>;
            for each (zoom in this._zoomLevels)
            {
                if (((this._currentMap) && (((((this._currentMap.initialWidth * zoom) < width)) || (((this._currentMap.initialHeight * zoom) < height))))))
                {
                    if (!(zoomsToRemove))
                    {
                        zoomsToRemove = new Vector.<Number>(0);
                    };
                    zoomsToRemove.push(zoom);
                };
            };
            if (zoomsToRemove)
            {
                for each (zoom in zoomsToRemove)
                {
                    this._zoomLevels.splice(this._zoomLevels.indexOf(zoom), 1);
                };
                Berilia.getInstance().handler.process(new MapMoveMessage(this));
            };
            this._zoomLevelsPercent = [];
            for each (zoom in this._zoomLevels)
            {
                this._zoomLevelsPercent.push(int((zoom * 100)));
            };
        }

        public function addLayer(name:String):void
        {
            var s:Sprite;
            if (!(this._layers[name]))
            {
                s = new Sprite();
                s.name = ("layer_" + name);
                s.mouseEnabled = false;
                s.doubleClickEnabled = true;
                this._layers[name] = s;
            };
            this._layersContainer.addChild(this._layers[name]);
        }

        public function addIcon(layer:String, id:String, uri:*, x:int, y:int, scale:Number=1, legend:String=null, follow:Boolean=false, color:int=-1, canBeGrouped:Boolean=true, canBeManuallyRemoved:Boolean=true):MapIconElement
        {
            var t:Texture;
            var s:Number;
            var mie:MapIconElement;
            var R:int;
            var V:int;
            var B:int;
            var ct:ColorTransform;
            if (((this._layers[layer]) && (this.mapBounds.contains(x, y))))
            {
                if ((uri is String))
                {
                    uri = new Uri(uri);
                };
                t = new Texture();
                t.uri = uri;
                t.mouseChildren = false;
                if (((this.autoSizeIcon) && ((this._lastScaleIconUpdate == this._mapContainer.scaleX))))
                {
                    s = (0.75 + (1 / this._mapContainer.scaleX));
                }
                else
                {
                    s = Math.min(2, scale);
                };
                t.scaleX = (t.scaleY = s);
                if (color != -1)
                {
                    R = ((color >> 16) & 0xFF);
                    V = ((color >> 8) & 0xFF);
                    B = ((color >> 0) & 0xFF);
                    ct = new ColorTransform(0.6, 0.6, 0.6, 1, (R - 80), (V - 80), (B - 80));
                    t.transform.colorTransform = ct;
                };
                mie = new MapIconElement(id, x, y, layer, t, legend, this, canBeManuallyRemoved);
                mie.canBeGrouped = canBeGrouped;
                mie.follow = follow;
                this._mapElements.push(mie);
                this._elementsGraphicRef[t] = mie;
                return (mie);
            };
            return (null);
        }

        public function addAreaShape(layer:String, id:String, coordList:Vector.<int>, lineColor:uint=0, lineAlpha:Number=1, fillColor:uint=0, fillAlpha:Number=0.4, thickness:int=4):MapAreaShape
        {
            var oldAreaShape:MapAreaShape;
            var shapeZone:Texture;
            var graphic:Graphics;
            var nCoords:int;
            var i:int;
            var mapAreaShape:MapAreaShape;
            var posX:int;
            var posY:int;
            if (((this._layers[layer]) && (coordList)))
            {
                oldAreaShape = MapAreaShape(MapElement.getElementById(id, this));
                if (oldAreaShape)
                {
                    if ((((oldAreaShape.lineColor == lineColor)) && ((oldAreaShape.fillColor == fillColor))))
                    {
                        return (oldAreaShape);
                    };
                    oldAreaShape.remove();
                    this._mapElements.splice(this._mapElements.indexOf(oldAreaShape), 1);
                };
                shapeZone = new Texture();
                shapeZone.mouseEnabled = false;
                shapeZone.mouseChildren = false;
                graphic = shapeZone.graphics;
                graphic.lineStyle(thickness, lineColor, lineAlpha, true);
                graphic.beginFill(fillColor, fillAlpha);
                nCoords = coordList.length;
                i = 0;
                while (i < nCoords)
                {
                    posX = coordList[i];
                    posY = coordList[(i + 1)];
                    if (posX > 10000)
                    {
                        graphic.moveTo(((posX - 11000) * this.mapWidth), ((posY - 11000) * this.mapHeight));
                    }
                    else
                    {
                        graphic.lineTo((posX * this.mapWidth), (posY * this.mapHeight));
                    };
                    i = (i + 2);
                };
                mapAreaShape = new MapAreaShape(id, layer, shapeZone, this.origineX, this.origineY, lineColor, fillColor, this);
                this._mapElements.push(mapAreaShape);
                return (mapAreaShape);
            };
            return (null);
        }

        public function areaShapeColorTransform(me:MapAreaShape, duration:int, rM:Number=1, gM:Number=1, bM:Number=1, aM:Number=1, rO:Number=0, gO:Number=0, bO:Number=0, aO:Number=0):void
        {
            me.colorTransform(duration, rM, gM, bM, aM, rO, gO, bO, aO);
        }

        public function getMapElement(id:String):MapElement
        {
            var elem:MapElement;
            var mapElem:MapElement = MapElement.getElementById(id, this);
            if (!(mapElem))
            {
                for each (elem in this._mapElements)
                {
                    if (elem.id == id)
                    {
                        mapElem = elem;
                        break;
                    };
                };
            };
            return (mapElem);
        }

        public function getMapElementsByLayer(layerId:String):Array
        {
            var mapElement:MapElement;
            var nbElements:int = this._mapElements.length;
            var elements:Array = new Array();
            var i:int;
            while (i < nbElements)
            {
                mapElement = this._mapElements[i];
                if (mapElement.layer == layerId)
                {
                    elements.push(mapElement);
                };
                i++;
            };
            return (elements);
        }

        public function removeMapElement(me:MapElement):void
        {
            var element:MapElement;
            var iconTexture:Object;
            if (!(me))
            {
                return;
            };
            var index:int = this._mapElements.indexOf(me);
            if (index != -1)
            {
                element = this._mapElements[index];
                if ((me is MapIconElement))
                {
                    iconTexture = MapIconElement(me)._texture;
                    if (this._mapGroupElements[me])
                    {
                        this._mapGroupElements[me].icons.splice(this._mapGroupElements[me].icons.indexOf(iconTexture), 1);
                        delete this._mapGroupElements[me];
                    };
                    if (((this._arrowAllocation[iconTexture]) && (this._arrowAllocation[iconTexture].parent)))
                    {
                        this._arrowAllocation[iconTexture].parent.removeChild(this._arrowAllocation[iconTexture]);
                        this._arrowPool.push(this._arrowAllocation[iconTexture]);
                        delete this._reverseArrowAllocation[this._arrowAllocation[iconTexture]];
                        delete this._arrowAllocation[iconTexture];
                    };
                };
                element.remove();
                this._mapElements.splice(index, 1);
            };
        }

        public function updateMapElements():void
        {
            var ico:Object;
            var elem:MapElement;
            var sortedMapElements:Array;
            var elems:Array;
            var iconNum:uint;
            var group:MapGroupElement;
            var _local_7:MapIconElement;
            var _local_8:MapAreaShape;
            var _local_9:Sprite;
            var visibleIconCount:uint;
            var iconIndex:uint;
            this.updateIconSize();
            for (ico in this._mapGroupElements)
            {
                delete this._mapGroupElements[ico];
            };
            this.clearLayer();
            this.clearElementsGroups();
            this.clearMapAreaShapes();
            sortedMapElements = new Array();
            for each (elem in this._mapElements)
            {
                if (!(sortedMapElements[((elem.x + "_") + elem.y)]))
                {
                    sortedMapElements[((elem.x + "_") + elem.y)] = new Array();
                };
                sortedMapElements[((elem.x + "_") + elem.y)].push(elem);
            };
            for each (elems in sortedMapElements)
            {
                iconNum = 0;
                group = null;
                for each (elem in elems)
                {
                    if (!!(this._layers[elem.layer].visible))
                    {
                        switch (true)
                        {
                            case (elem is MapIconElement):
                                _local_7 = (elem as MapIconElement);
                                _local_7._texture.x = (((_local_7.x * this.mapWidth) + this.origineX) + (this.mapWidth / 2));
                                _local_7._texture.y = (((_local_7.y * this.mapHeight) + this.origineY) + (this.mapHeight / 2));
                                if (((!((elems.length == 1))) && (_local_7.canBeGrouped)))
                                {
                                    if (!(group))
                                    {
                                        group = new MapGroupElement((this.mapWidth * 0.5), (this.mapHeight * 0.5));
                                        group.x = (((_local_7.x * this.mapWidth) + this.origineX) + (this.mapWidth / 2));
                                        group.y = (((_local_7.y * this.mapHeight) + this.origineY) + (this.mapHeight / 2));
                                        this._groupsContainer.addChild(group);
                                    };
                                    this._mapGroupElements[_local_7] = group;
                                    if (elem.layer != "layer_8")
                                    {
                                        visibleIconCount = elems.length;
                                        if (visibleIconCount > 2)
                                        {
                                            visibleIconCount = 2;
                                        };
                                        iconIndex = Math.min(visibleIconCount, iconNum);
                                        _local_7._texture.x = ((4 * iconIndex) - ((visibleIconCount * 4) / 2));
                                        _local_7._texture.y = ((4 * iconIndex) - ((visibleIconCount * 4) / 2));
                                        group.addChild(_local_7._texture);
                                    }
                                    else
                                    {
                                        group.icons.push(_local_7._texture);
                                        this._layers[elem.layer].addChild(_local_7._texture);
                                    };
                                }
                                else
                                {
                                    this._layers[elem.layer].addChild(_local_7._texture);
                                };
                                break;
                            case (elem is MapAreaShape):
                                _local_8 = (elem as MapAreaShape);
                                _local_9 = this._layers[elem.layer];
                                if (_local_9.parent != this._areaShapesContainer)
                                {
                                    this._areaShapesContainer.addChild(_local_9);
                                };
                                _local_9.addChild(_local_8.shape);
                                _local_8.shape.x = _local_8.x;
                                _local_8.shape.y = _local_8.y;
                                break;
                        };
                        iconNum++;
                    };
                };
            };
            this.updateIcons();
        }

        public function showLayer(name:String, display:Boolean=true):void
        {
            if (this._layers[name])
            {
                this._layers[name].visible = display;
            };
        }

        public function showAllLayers(visible:Boolean=true):void
        {
            var layer:Sprite;
            for each (layer in this._layers)
            {
                layer.visible = visible;
            };
            this.updateMapElements();
        }

        public function moveToPixel(x:int, y:int, zoomFactor:Number):void
        {
            this._mapContainer.x = x;
            this._mapContainer.y = y;
            this._mapContainer.scaleX = zoomFactor;
            this._mapContainer.scaleY = zoomFactor;
            this.updateVisibleChunck();
        }

        public function moveTo(x:Number, y:Number, width:uint=1, height:uint=1, center:Boolean=true, autoZoom:Boolean=true):void
        {
            var zoneWidth:int;
            var zoneHeight:int;
            var newX:int;
            var newY:int;
            var offsetX:Number;
            var offsetY:Number;
            var diffX:Number;
            var diffY:Number;
            var viewRect:Rectangle = this.mapBounds;
            if (viewRect.left > x)
            {
                x = viewRect.left;
            };
            if (viewRect.top > y)
            {
                y = viewRect.top;
            };
            if (center)
            {
                zoneWidth = ((width * this.mapWidth) * this._mapContainer.scaleX);
                if ((((zoneWidth > this.width)) && (autoZoom)))
                {
                    this._mapContainer.scaleX = (this.width / (this.mapWidth * width));
                    this._mapContainer.scaleY = this._mapContainer.scaleX;
                };
                zoneHeight = ((height * this.mapHeight) * this._mapContainer.scaleY);
                if ((((zoneHeight > this.height)) && (autoZoom)))
                {
                    this._mapContainer.scaleY = (this.height / (this.mapHeight * height));
                    this._mapContainer.scaleX = this._mapContainer.scaleY;
                };
                newX = ((-(((x * this.mapWidth) + this.origineX)) * this._mapContainer.scaleX) - ((this.mapWidth / 2) * this._mapContainer.scaleX));
                newY = ((-(((y * this.mapHeight) + this.origineY)) * this._mapContainer.scaleY) - ((this.mapHeight / 2) * this._mapContainer.scaleY));
                offsetX = (this.width / 2);
                offsetY = (this.height / 2);
                diffX = Math.abs((-(this._mapContainer.width) - newX));
                if (diffX < offsetX)
                {
                    offsetX = (offsetX + (offsetX - diffX));
                };
                diffY = Math.abs((-(this._mapContainer.height) - newY));
                if (diffY < offsetY)
                {
                    offsetY = (offsetY + (offsetY - diffY));
                };
                this._mapContainer.x = (newX + offsetX);
                this._mapContainer.y = (newY + offsetY);
            }
            else
            {
                this._mapContainer.x = (-(((x * this.mapWidth) + this.origineX)) * this._mapContainer.scaleX);
                this._mapContainer.y = (-(((y * this.mapHeight) + this.origineY)) * this._mapContainer.scaleY);
            };
            var w:Number = ((this._currentMap) ? this._currentMap.initialWidth : this._mapBitmapContainer.width);
            var h:Number = ((this._currentMap) ? this._currentMap.initialHeight : this._mapBitmapContainer.height);
            if (this._mapContainer.x < (width - w))
            {
                if (!(center))
                {
                    this._mapContainer.x = (width - w);
                }
                else
                {
                    this._mapContainer.x = 0;
                };
            };
            if (this._mapContainer.y < (height - h))
            {
                if (!(center))
                {
                    this._mapContainer.y = (height - h);
                }
                else
                {
                    this._mapContainer.y = 0;
                };
            };
            if (this._mapContainer.x > 0)
            {
                this._mapContainer.x = 0;
            };
            if (this._mapContainer.y > 0)
            {
                this._mapContainer.y = 0;
            };
            this.updateVisibleChunck();
            Berilia.getInstance().handler.process(new MapMoveMessage(this));
        }

        private function zoomWithScalePercent(scalePercent:int, coord:Point=null):void
        {
            if (this._zoomLevelsPercent.indexOf(scalePercent) != -1)
            {
                this.zoom((scalePercent / 100), coord);
            }
            else
            {
                _log.warn((((("Can't zoom, a scale of " + String((scalePercent / 100))) + " (") + scalePercent) + ") is not defined"));
            };
        }

        public function zoom(scale:Number, coord:Point=null):void
        {
            var w:Number;
            var h:Number;
            var _local_5:Rectangle;
            var _local_6:Point;
            if (scale > this.maxScale)
            {
                scale = this.maxScale;
            };
            if (scale < this.minScale)
            {
                scale = this.minScale;
            };
            if (((this._currentMap) && (((((this._currentMap.initialWidth * scale) < width)) || (((this._currentMap.initialHeight * scale) < height))))))
            {
                return;
            };
            if (coord)
            {
                if (this._currentMap)
                {
                    this._currentMap.currentScale = NaN;
                };
                this._mapContainer.x = (this._mapContainer.x - ((coord.x * scale) - (coord.x * this._mapContainer.scaleX)));
                this._mapContainer.y = (this._mapContainer.y - ((coord.y * scale) - (coord.y * this._mapContainer.scaleY)));
                this._mapContainer.scaleX = (this._mapContainer.scaleY = scale);
                w = ((this._currentMap) ? this._currentMap.initialWidth : this._mapBitmapContainer.width);
                h = ((this._currentMap) ? this._currentMap.initialHeight : this._mapBitmapContainer.height);
                if (this._mapContainer.x < (width - (w * scale)))
                {
                    this._mapContainer.x = (width - (w * scale));
                };
                if (this._mapContainer.y < (height - (h * scale)))
                {
                    this._mapContainer.y = (height - (h * scale));
                };
                if (this._mapContainer.x > 0)
                {
                    this._mapContainer.x = 0;
                };
                if (this._mapContainer.y > 0)
                {
                    this._mapContainer.y = 0;
                };
                this.updateIconSize();
            }
            else
            {
                _local_5 = this.visibleMaps;
                _local_6 = new Point((((_local_5.x + (_local_5.width / 2)) * this.mapWidth) + this.origineX), (((_local_5.y + (_local_5.height / 2)) * this.mapHeight) + this.origineY));
                this.zoom(scale, _local_6);
                return;
            };
            this.processMapInfo();
        }

        public function addMap(zoom:Number, src:String, unscaleWitdh:uint, unscaleHeight:uint, chunckWidth:uint, chunckHeight:uint):void
        {
            this._availableMaps.push(new Map(zoom, src, new Sprite(), unscaleWitdh, unscaleHeight, chunckWidth, chunckHeight));
            if (this._zoomLevels.indexOf(zoom) == -1)
            {
                this._zoomLevels.push(zoom);
                this._zoomLevels.sort(Array.NUMERIC);
            };
        }

        public function removeAllMap():void
        {
            var map:Map;
            var area:MapArea;
            for each (map in this._availableMaps)
            {
                for each (area in map.areas)
                {
                    area.free(true);
                };
            };
            this._availableMaps = [];
            this._zoomLevels.length = 0;
        }

        public function getOrigineFromPos(x:int, y:int):Point
        {
            return (new Point(((-(this._mapContainer.x) / this._mapContainer.scaleX) - (x * this.mapWidth)), ((-(this._mapContainer.y) / this._mapContainer.scaleY) - (y * this.mapHeight))));
        }

        public function set useFlagCursor(pValue:Boolean):void
        {
            var lcd:LinkedCursorData;
            if (!(FLAG_CURSOR))
            {
                return;
            };
            if (pValue)
            {
                if (!(this._flagCursor))
                {
                    this._flagCursor = new Sprite();
                    this._flagCursor.addChild(new FLAG_CURSOR());
                };
                lcd = new LinkedCursorData();
                lcd.sprite = this._flagCursor;
                lcd.offset = new Point();
                Mouse.hide();
                LinkedCursorSpriteManager.getInstance().addItem("mapViewerCursor", lcd);
            }
            else
            {
                this.removeCustomCursor();
            };
            this._flagCursorVisible = pValue;
        }

        public function get useFlagCursor():Boolean
        {
            return (this._flagCursorVisible);
        }

        public function get allChunksLoaded():Boolean
        {
            var mapArea:MapArea;
            if (((!(this._visibleMapAreas)) || (!(this._visibleMapAreas.length))))
            {
                return (false);
            };
            for each (mapArea in this._visibleMapAreas)
            {
                if (!(mapArea.isLoaded))
                {
                    return (false);
                };
            };
            return (true);
        }

        private function removeCustomCursor():void
        {
            Mouse.show();
            LinkedCursorSpriteManager.getInstance().removeItem("mapViewerCursor");
        }

        override public function remove():void
        {
            var me:MapElement;
            var k:Object;
            if (!(__removed))
            {
                if (this._grid)
                {
                    this._grid.cacheAsBitmap = false;
                    if (this._mapContainer.contains(this._grid))
                    {
                        this._mapContainer.removeChild(this._grid);
                    };
                };
                if (this._mapToClear)
                {
                    this.clearMap(this._mapToClear);
                    this._mapToClear = null;
                };
                this.removeAllMap();
                for each (me in MapElement.getOwnerElements(this))
                {
                    if (this._mapGroupElements[me])
                    {
                        delete this._mapGroupElements[me];
                    };
                    me.remove();
                };
                for (k in this._elementsGraphicRef)
                {
                    delete this._elementsGraphicRef[k];
                };
                this._mapElements = null;
                this._elementsGraphicRef = null;
                this._mapGroupElements = null;
                this._visibleMapAreas = null;
                MapElement._elementRef = new Dictionary(true);
                EnterFrameDispatcher.removeEventListener(this.onMapEnterFrame);
                this.removeCustomCursor();
                if (AirScanner.hasAir())
                {
                    StageShareManager.stage.nativeWindow.removeEventListener(Event.DEACTIVATE, this.onWindowDeactivate);
                };
            };
            super.remove();
        }

        private function getIconTextureGlobalCoords(pMapIconElement:MapIconElement):Point
        {
            var txX:Number = (((pMapIconElement.x * this.mapWidth) + this.origineX) + (this.mapWidth / 2));
            var txY:Number = (((pMapIconElement.y * this.mapHeight) + this.origineY) + (this.mapHeight / 2));
            var layer:Sprite = (this._layers[pMapIconElement.layer] as Sprite);
            return (layer.localToGlobal(new Point(txX, txY)));
        }

        private function updateIcons():void
        {
            var iconTexture:Texture;
            var mie:MapIconElement;
            var p:Point;
            var p2:Point;
            var dist:Number;
            var iconVisible:Boolean;
            var me:MapElement;
            var arrow:Texture;
            var angle:Number;
            var a:Number;
            var res:Number;
            var icon:*;
            var tempArrow:Texture;
            var vr:Number;
            var iconRect:Rectangle = new Rectangle(0, 0, 1, 1);
            var visibleMaps:Rectangle = this.visibleMaps;
            var currentPosition:Point = new Point(Math.floor((visibleMaps.x + (visibleMaps.width / 2))), Math.floor((visibleMaps.y + (visibleMaps.height / 2))));
            var minimalArrowDist:Number = (visibleMaps.width / 2);
            var isCircleView:Boolean = (this.roundCornerRadius > (width / 3));
            var radius:Number = (width / 2);
            for each (me in this._mapElements)
            {
                mie = (me as MapIconElement);
                if (!(mie))
                {
                }
                else
                {
                    iconRect.x = mie.x;
                    iconRect.y = mie.y;
                    iconTexture = mie._texture;
                    if (!!(iconTexture))
                    {
                        if (mie.follow)
                        {
                            p = this.getIconTextureGlobalCoords(mie);
                            if (isCircleView)
                            {
                                p2 = globalToLocal(p);
                                dist = Math.floor(Math.sqrt((Math.pow((p2.x - radius), 2) + Math.pow((p2.y - radius), 2))));
                                iconVisible = (dist < radius);
                            }
                            else
                            {
                                iconVisible = this._mapContainer.mask.getBounds(StageShareManager.stage).containsPoint(p);
                            };
                        }
                        else
                        {
                            iconVisible = visibleMaps.intersects(iconRect);
                        };
                        iconTexture.visible = ((!((this._layers[mie.layer].visible == false))) && (iconVisible));
                        if (((iconTexture.visible) && (!(iconTexture.finalized))))
                        {
                            iconTexture.finalize();
                        };
                        if (!(mie.follow))
                        {
                        }
                        else
                        {
                            if (((iconTexture.visible) && (this._arrowAllocation[iconTexture])))
                            {
                                this._arrowContainer.removeChild(this._arrowAllocation[iconTexture]);
                                this._arrowPool.push(this._arrowAllocation[iconTexture]);
                                mie.boundsRef = null;
                                delete this._reverseArrowAllocation[this._arrowAllocation[iconTexture]];
                                delete this._arrowAllocation[iconTexture];
                            }
                            else
                            {
                                if (((mie.follow) && (!(iconTexture.visible))))
                                {
                                    tempArrow = this.getIconArrow(iconTexture);
                                    tempArrow.visible = this._layers[mie.layer].visible;
                                    this._arrowContainer.addChild(tempArrow);
                                    this._elementsGraphicRef[tempArrow] = mie;
                                    mie.boundsRef = tempArrow;
                                };
                            };
                        };
                    };
                };
            };
            angle = Math.atan2(0, (-(width) / 2));
            a = (Math.atan2((width / 2), 0) + angle);
            for (icon in this._arrowAllocation)
            {
                arrow = this._arrowAllocation[icon];
                mie = this._elementsGraphicRef[icon];
                if (isCircleView)
                {
                    p = globalToLocal(this.getIconTextureGlobalCoords(mie));
                    vr = Math.atan2((-(p.y) + (height / 2)), (-(p.x) + (width / 2)));
                }
                else
                {
                    vr = Math.atan2((-(mie.y) + currentPosition.y), (-(mie.x) + currentPosition.x));
                };
                arrow.x = ((Math.cos((angle + vr)) * width) / 2);
                arrow.y = ((Math.sin((angle + vr)) * height) / 2);
                arrow.rotation = (vr * (180 / Math.PI));
                if (isCircleView)
                {
                    arrow.x = (arrow.x + (width / 2));
                    arrow.y = (arrow.y + (height / 2));
                }
                else
                {
                    a = (arrow.y / arrow.x);
                    vr = (vr + Math.PI);
                    if ((((vr < (Math.PI / 4))) || ((vr > ((Math.PI * 7) / 4)))))
                    {
                        res = (((width / 2) * a) + (height / 2));
                        if ((((res > 0)) && ((res < height))))
                        {
                            arrow.x = width;
                            arrow.y = res;
                            continue;
                        };
                    }
                    else
                    {
                        if (vr < ((Math.PI * 3) / 4))
                        {
                            res = (((height / 2) / a) + (width / 2));
                            res = (((res > width)) ? width : res);
                            if (res > 0)
                            {
                                arrow.x = res;
                                arrow.y = height;
                                continue;
                            };
                        }
                        else
                        {
                            if (vr < ((Math.PI * 5) / 4))
                            {
                                res = (((-(width) / 2) * a) + (height / 2));
                                if ((((res > 0)) && ((res < height))))
                                {
                                    arrow.x = 0;
                                    arrow.y = res;
                                    continue;
                                };
                            }
                            else
                            {
                                res = (((-(height) / 2) / a) + (width / 2));
                                res = (((res > width)) ? width : (((res < 0)) ? 0 : res));
                                if (res >= 0)
                                {
                                    arrow.x = res;
                                    arrow.y = 0;
                                    continue;
                                };
                            };
                        };
                    };
                    if (arrow.rotation == -45)
                    {
                        arrow.x = 0;
                        arrow.y = res;
                    };
                };
            };
        }

        private function getIconArrow(icon:Texture):Texture
        {
            var _local_2:Texture;
            if (this._arrowAllocation[icon])
            {
                return (this._arrowAllocation[icon]);
            };
            if (this._arrowPool.length)
            {
                this._arrowAllocation[icon] = this._arrowPool.pop();
            }
            else
            {
                _local_2 = new Texture();
                _local_2.uri = new Uri((XmlConfig.getInstance().getEntry("config.gfx.path") + "icons/assets.swf|arrow0"));
                _local_2.mouseEnabled = true;
                _local_2.buttonMode = (_local_2.useHandCursor = true);
                _local_2.finalize();
                this._arrowAllocation[icon] = _local_2;
            };
            this._reverseArrowAllocation[this._arrowAllocation[icon]] = icon;
            Texture(this._arrowAllocation[icon]).transform.colorTransform = icon.transform.colorTransform;
            return (this._arrowAllocation[icon]);
        }

        private function processMapInfo():void
        {
            var choosenMap:Map;
            var tmpZoomDist:Number;
            var map:Map;
            if (!(this._availableMaps.length))
            {
                return;
            };
            this._lastScaleIconUpdate = -1;
            var zoomDist:Number = 10000;
            for each (map in this._availableMaps)
            {
                tmpZoomDist = Math.abs((map.zoom - this._mapContainer.scaleX));
                if (tmpZoomDist < zoomDist)
                {
                    choosenMap = map;
                    zoomDist = tmpZoomDist;
                };
            };
            if (((!(this._currentMap)) || (!((choosenMap == this._currentMap)))))
            {
                if (this._currentMap)
                {
                    if (this._mapToClear)
                    {
                        this.clearMap(this._mapToClear);
                    };
                    this._mapToClear = this._currentMap;
                };
                this._currentMap = choosenMap;
                this._mapBitmapContainer.graphics.beginFill(0, 0);
                this._mapBitmapContainer.graphics.drawRect(0, 0, this._currentMap.initialWidth, this._currentMap.initialHeight);
                this._mapBitmapContainer.graphics.endFill();
                this._mapBitmapContainer.addChild(this._currentMap.container);
                this._viewRect.width = width;
                this._viewRect.height = height;
            };
            this.updateVisibleChunck();
        }

        private function updateVisibleChunck(refreshIcons:Boolean=true):void
        {
            var rect:MapArea;
            if (((!(this._currentMap)) || (!(this._currentMap.areas))))
            {
                return;
            };
            if (refreshIcons)
            {
                this.updateIcons();
            };
            var marge:uint = 100;
            this._visibleMapAreas = new Vector.<MapArea>();
            this._viewRect.x = ((-(this._mapContainer.x) / this._mapContainer.scaleX) - marge);
            this._viewRect.y = ((-(this._mapContainer.y) / this._mapContainer.scaleY) - marge);
            this._viewRect.width = ((width / this._mapContainer.scaleX) + (marge * 2));
            this._viewRect.height = ((height / this._mapContainer.scaleY) + (marge * 2));
            for each (rect in this._currentMap.areas)
            {
                if (this._viewRect.intersects(rect))
                {
                    if (!(rect.isUsed))
                    {
                        rect.parent.container.addChild(rect.getBitmap());
                    };
                    this._visibleMapAreas.push(rect);
                }
                else
                {
                    if (rect.isUsed)
                    {
                        rect.free();
                    };
                };
            };
            this._visibleMapAreas.fixed = true;
        }

        private function initMask():void
        {
            if (this._mapContainer.mask)
            {
                this._mapContainer.mask.parent.removeChild(this._mapContainer.mask);
            };
            var maskCtr:Sprite = new Sprite();
            maskCtr.doubleClickEnabled = true;
            maskCtr.graphics.beginFill(0x770000, 0.3);
            if (!(this.roundCornerRadius))
            {
                maskCtr.graphics.drawRect(0, 0, width, height);
            }
            else
            {
                maskCtr.graphics.drawRoundRectComplex(0, 0, width, height, this.roundCornerRadius, this.roundCornerRadius, this.roundCornerRadius, this.roundCornerRadius);
            };
            addChild(maskCtr);
            this._mapContainer.mask = maskCtr;
        }

        private function initMap():void
        {
            var t3d:Sprite;
            this._mapContainer = new Sprite();
            this.initMask();
            this._mapContainer.addChild(this._mapBitmapContainer);
            this._grid = new Shape();
            this.drawGrid();
            this._mapContainer.addChild(this._grid);
            this._areaShapesContainer = new Sprite();
            this._areaShapesContainer.mouseEnabled = false;
            this._mapContainer.addChild(this._areaShapesContainer);
            this._groupsContainer = new Sprite();
            this._groupsContainer.mouseEnabled = false;
            this._mapContainer.addChild(this._groupsContainer);
            this._layersContainer = new Sprite();
            this._mapContainer.addChild(this._layersContainer);
            this._layersContainer.mouseEnabled = false;
            if (this._enable3DMode)
            {
                t3d = new Sprite();
                t3d.addChild(this._mapContainer);
                t3d.rotationX = -30;
                t3d.doubleClickEnabled = true;
                addChild(t3d);
            }
            else
            {
                addChild(this._mapContainer);
            };
            addChild(this._arrowContainer);
            this._mapElements = new Array();
            this._layers = new Array();
            this._elementsGraphicRef = new Dictionary(true);
            this.zoom(this.startScale);
        }

        private function drawGrid():void
        {
            var _local_3:uint;
            var _local_4:Number;
            var _local_5:uint;
            var _local_6:uint;
            var offsetX:int = (this.origineX % this.mapWidth);
            var offsetY:int = (this.origineY % this.mapHeight);
            if (!(this._showGrid))
            {
                this._grid.graphics.clear();
            }
            else
            {
                this._grid.cacheAsBitmap = false;
                this._grid.graphics.lineStyle(1, 0x777777, this.gridLineThickness);
                _local_5 = (this._mapBitmapContainer.width / this.mapWidth);
                _local_3 = 0;
                while (_local_3 < _local_5)
                {
                    _local_4 = ((_local_3 * this.mapWidth) + offsetX);
                    this._grid.graphics.moveTo(_local_4, 0);
                    this._grid.graphics.lineTo(_local_4, this._mapBitmapContainer.height);
                    _local_3++;
                };
                _local_6 = (this._mapBitmapContainer.height / this.mapHeight);
                _local_3 = 0;
                while (_local_3 < _local_6)
                {
                    _local_4 = ((_local_3 * this.mapHeight) + offsetY);
                    this._grid.graphics.moveTo(0, _local_4);
                    this._grid.graphics.lineTo(this._mapBitmapContainer.width, _local_4);
                    _local_3++;
                };
                this._grid.cacheAsBitmap = true;
            };
        }

        private function clearLayer(target:DisplayObjectContainer=null):void
        {
            var child:DisplayObject;
            var l:DisplayObjectContainer;
            for each (l in this._layers)
            {
                if (((!(target)) || ((target == l))))
                {
                    while (l.numChildren)
                    {
                        child = l.removeChildAt(0);
                    };
                };
            };
        }

        private function clearElementsGroups():void
        {
            var mapGroupElement:MapGroupElement;
            while (this._groupsContainer.numChildren > 0)
            {
                mapGroupElement = (this._groupsContainer.getChildAt(0) as MapGroupElement);
                mapGroupElement.remove();
                this._groupsContainer.removeChildAt(0);
            };
        }

        private function clearMapAreaShapes():void
        {
            var mapAreaShape:MapAreaShape;
            var layer:Sprite;
            var i:int;
            var numLayers:int = this._areaShapesContainer.numChildren;
            i = 0;
            while (i < numLayers)
            {
                layer = (this._areaShapesContainer.getChildAt(i) as Sprite);
                while (layer.numChildren)
                {
                    mapAreaShape = (layer.getChildAt(0) as MapAreaShape);
                    mapAreaShape.remove();
                    layer.removeChildAt(0);
                };
                i++;
            };
        }

        private function updateIconSize():void
        {
            var mie:MapIconElement;
            var me:MapElement;
            if (((!(this.autoSizeIcon)) || ((this._lastScaleIconUpdate == this._mapContainer.scaleX))))
            {
                return;
            };
            this._lastScaleIconUpdate = this._mapContainer.scaleX;
            for each (me in this._mapElements)
            {
                mie = (me as MapIconElement);
                if (((!(mie)) || (!(mie.canBeAutoSize))))
                {
                }
                else
                {
                    mie._texture.scaleX = (mie._texture.scaleY = (0.75 + (1 / this._mapContainer.scaleX)));
                };
            };
        }

        private function forceMapRollOver():void
        {
            this._mouseOnArrow = false;
            Berilia.getInstance().handler.process(new MapRollOverMessage(this, Math.floor(((this._mapBitmapContainer.mouseX - this.origineX) / this.mapWidth)), Math.floor(((this._mapBitmapContainer.mouseY - this.origineY) / this.mapHeight))));
        }

        private function clearMap(map:Map):void
        {
            var i:uint;
            var l:uint = map.areas.length;
            i = 0;
            while (i < l)
            {
                map.areas[i].free();
                i++;
            };
            if (map.container.parent == this._mapBitmapContainer)
            {
                this._mapBitmapContainer.removeChild(map.container);
            };
            map = null;
        }

        [HideInFakeClass]
        override public function process(msg:Message):Boolean
        {
            var _local_2:MouseOverMessage;
            var _local_3:MouseOutMessage;
            var _local_4:MouseClickMessage;
            var _local_5:MouseWheelMessage;
            var _local_6:int;
            var _local_7:Point;
            var _local_8:MouseRightClickMessage;
            var me:MapElement;
            switch (true)
            {
                case (msg is MouseOverMessage):
                    _local_2 = (msg as MouseOverMessage);
                    if ((((((_local_2.target == this)) || ((_local_2.target.parent == this)))) || (((!((_local_2.target.parent == this._arrowContainer))) && ((_local_2.target.parent.parent == this))))))
                    {
                        if (!(EnterFrameDispatcher.hasEventListener(this.onMapEnterFrame)))
                        {
                            EnterFrameDispatcher.addEventListener(this.onMapEnterFrame, "mapMouse");
                        };
                        return (false);
                    };
                    this._mouseOnArrow = (((_local_2.target.parent == this._arrowContainer)) ? true : false);
                    if ((((((_local_2.target is MapGroupElement)) || ((((_local_2.target.parent is MapGroupElement)) && (!((this._openedMapGroupElement == _local_2.target.parent))))))) || ((((this._mapGroupElements[this._elementsGraphicRef[_local_2.target]] is MapGroupElement)) && (!((this._openedMapGroupElement == this._mapGroupElements[this._elementsGraphicRef[_local_2.target]])))))))
                    {
                        if ((_local_2.target is MapGroupElement))
                        {
                            this._openedMapGroupElement = MapGroupElement(_local_2.target);
                        }
                        else
                        {
                            if ((_local_2.target.parent is MapGroupElement))
                            {
                                this._openedMapGroupElement = MapGroupElement(_local_2.target.parent);
                            }
                            else
                            {
                                if (!(this._mouseOnArrow))
                                {
                                    this._openedMapGroupElement = this._mapGroupElements[this._elementsGraphicRef[_local_2.target]];
                                }
                                else
                                {
                                    this._openedMapGroupElement = null;
                                };
                            };
                        };
                        if (((((this._openedMapGroupElement) && (!(this._openedMapGroupElement.opened)))) && ((this._openedMapGroupElement.icons.length > 1))))
                        {
                            this._openedMapGroupElement.open();
                        };
                        if (((!((_local_2.target is MapGroupElement))) && (((!(this._openedMapGroupElement)) || ((this._openedMapGroupElement.icons.length > 1))))))
                        {
                            Berilia.getInstance().handler.process(new MapElementRollOverMessage(this, this._elementsGraphicRef[_local_2.target]));
                        };
                    }
                    else
                    {
                        if (this._elementsGraphicRef[_local_2.target])
                        {
                            Berilia.getInstance().handler.process(new MapElementRollOverMessage(this, this._elementsGraphicRef[_local_2.target]));
                        }
                        else
                        {
                            if (((this._reverseArrowAllocation[_local_2.target]) && (this._elementsGraphicRef[this._reverseArrowAllocation[_local_2.target]])))
                            {
                                Berilia.getInstance().handler.process(new MapElementRollOverMessage(this, this._elementsGraphicRef[this._reverseArrowAllocation[_local_2.target]]));
                            };
                        };
                    };
                    break;
                case (msg is MouseOutMessage):
                    _local_3 = (msg as MouseOutMessage);
                    if ((((((_local_3.target == this)) || ((_local_3.target.parent == this)))) || (((!((_local_3.target.parent == this._arrowContainer))) && ((_local_3.target.parent.parent == this))))))
                    {
                        if (((!(this._dragging)) && (EnterFrameDispatcher.hasEventListener(this.onMapEnterFrame))))
                        {
                            EnterFrameDispatcher.removeEventListener(this.onMapEnterFrame);
                        };
                        return (false);
                    };
                    this._mouseOnArrow = false;
                    if (((((((((((_local_3.mouseEvent.relatedObject) && (!((_local_3.mouseEvent.relatedObject.parent == this._openedMapGroupElement))))) && (!((_local_3.mouseEvent.relatedObject == this._openedMapGroupElement))))) && (!((this._mapGroupElements[this._elementsGraphicRef[_local_3.mouseEvent.relatedObject]] == this._openedMapGroupElement))))) && (this._openedMapGroupElement))) && (this._openedMapGroupElement.opened)))
                    {
                        this._openedMapGroupElement.close();
                        this._openedMapGroupElement = null;
                        this.forceMapRollOver();
                    };
                    if (this._elementsGraphicRef[_local_3.target])
                    {
                        Berilia.getInstance().handler.process(new MapElementRollOutMessage(this, this._elementsGraphicRef[_local_3.target]));
                    }
                    else
                    {
                        if (((this._reverseArrowAllocation[_local_3.target]) && (this._elementsGraphicRef[this._reverseArrowAllocation[_local_3.target]])))
                        {
                            Berilia.getInstance().handler.process(new MapElementRollOutMessage(this, this._elementsGraphicRef[this._reverseArrowAllocation[_local_3.target]]));
                        };
                    };
                    break;
                case (msg is MouseDownMessage):
                    if (!(this.enabledDrag))
                    {
                        return (false);
                    };
                    if (!(this._enable3DMode))
                    {
                        this._mapContainer.startDrag(false, new Rectangle((width - (this._currentMap.initialWidth * this._mapContainer.scaleX)), (height - (this._currentMap.initialHeight * this._mapContainer.scaleY)), ((this._currentMap.initialWidth * this._mapContainer.scaleX) - width), ((this._currentMap.initialHeight * this._mapContainer.scaleY) - height)));
                    };
                    this._dragging = true;
                    return (false);
                case (msg is MouseClickMessage):
                    _local_4 = (msg as MouseClickMessage);
                    if (this._reverseArrowAllocation[_local_4.target])
                    {
                        TooltipManager.hide();
                        me = this._elementsGraphicRef[this._reverseArrowAllocation[_local_4.target]];
                        this.moveTo(me.x, me.y);
                    };
                    break;
                case (msg is MouseReleaseOutsideMessage):
                case (msg is MouseUpMessage):
                    if (!(this._enable3DMode))
                    {
                        this._mapContainer.stopDrag();
                    };
                    this._dragging = false;
                    this._lastMouseX = 0;
                    this.updateVisibleChunck();
                    Berilia.getInstance().handler.process(new MapMoveMessage(this));
                    return (false);
                case (msg is MouseWheelMessage):
                    _local_5 = (msg as MouseWheelMessage);
                    _local_6 = ((this._mapContainer.scaleX * 100) + ((((_local_5.mouseEvent.delta > 0)) ? 100 : -100) * this.zoomStep));
                    _local_7 = new Point(_local_5.mouseEvent.localX, _local_5.mouseEvent.localY);
                    switch (true)
                    {
                        case (_local_5.mouseEvent.target.parent is MapGroupElement):
                            _local_7.x = _local_5.mouseEvent.target.parent.x;
                            _local_7.y = _local_5.mouseEvent.target.parent.y;
                            break;
                        case (_local_5.mouseEvent.target is MapGroupElement):
                        case (_local_5.mouseEvent.target is Texture):
                            _local_7.x = _local_5.mouseEvent.target.x;
                            _local_7.y = _local_5.mouseEvent.target.y;
                            break;
                    };
                    this.zoomWithScalePercent(_local_6, _local_7);
                    Berilia.getInstance().handler.process(new MapMoveMessage(this));
                    return (true);
                case (msg is MouseRightClickMessage):
                    _local_8 = (msg as MouseRightClickMessage);
                    if (this._elementsGraphicRef[_local_8.target])
                    {
                        Berilia.getInstance().handler.process(new MapElementRightClickMessage(this, this._elementsGraphicRef[_local_8.target]));
                    }
                    else
                    {
                        if (((this._reverseArrowAllocation[_local_8.target]) && (this._elementsGraphicRef[this._reverseArrowAllocation[_local_8.target]])))
                        {
                            Berilia.getInstance().handler.process(new MapElementRightClickMessage(this, this._elementsGraphicRef[this._reverseArrowAllocation[_local_8.target]]));
                        };
                    };
                    return (false);
            };
            return (false);
        }

        private function onMapEnterFrame(e:Event):void
        {
            var mx:int;
            var my:int;
            if (((this._mapToClear) && (this.allChunksLoaded)))
            {
                this.clearMap(this._mapToClear);
                this._mapToClear = null;
            };
            if (((this._dragging) && (((!((this._lastMouseX == StageShareManager.mouseX))) || (!((this._lastMouseY == StageShareManager.mouseY)))))))
            {
                if (((this._enable3DMode) && (this._lastMouseX)))
                {
                    this._mapContainer.x = (this._mapContainer.x - (StageShareManager.mouseX - this._lastMouseX));
                    this._mapContainer.y = (this._mapContainer.y - (StageShareManager.mouseY - this._lastMouseY));
                };
                this.updateVisibleChunck();
                this._lastMouseX = StageShareManager.mouseX;
                this._lastMouseY = StageShareManager.mouseY;
            };
            var posX:int = this.mouseX;
            var posY:int = this.mouseY;
            if ((((((((posX > 0)) && ((posX < __width)))) && ((posY > 0)))) && ((posY < __height))))
            {
                mx = Math.floor(((this._mapBitmapContainer.mouseX - this.origineX) / this.mapWidth));
                my = Math.floor(((this._mapBitmapContainer.mouseY - this.origineY) / this.mapHeight));
                if (((((((!(this._openedMapGroupElement)) || (!(this._openedMapGroupElement.opened)))) && (!(this._mouseOnArrow)))) && (((!((mx == this._lastMx))) || (!((my == this._lastMy)))))))
                {
                    this._lastMx = mx;
                    this._lastMy = my;
                    Berilia.getInstance().handler.process(new MapRollOverMessage(this, mx, my));
                };
            };
        }

        private function onWindowDeactivate(pEvent:Event):void
        {
            if (this._dragging)
            {
                this.process(new MouseUpMessage());
            };
        }


    }
}//package com.ankamagames.berilia.components

