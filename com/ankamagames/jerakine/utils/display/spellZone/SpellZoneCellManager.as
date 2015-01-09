﻿package com.ankamagames.jerakine.utils.display.spellZone
{
    import flash.display.Sprite;
    import __AS3__.vec.Vector;
    import com.ankamagames.jerakine.types.zones.IZone;
    import com.ankamagames.jerakine.map.IDataMapProvider;
    import com.ankamagames.jerakine.types.zones.Cross;
    import com.ankamagames.jerakine.types.zones.Lozenge;
    import com.ankamagames.jerakine.types.positions.MapPoint;
    import com.ankamagames.jerakine.types.zones.Line;
    import com.ankamagames.jerakine.types.zones.Square;
    import com.ankamagames.jerakine.types.zones.Cone;
    import com.ankamagames.jerakine.types.zones.HalfLozenge;
    import com.ankamagames.jerakine.types.enums.DirectionsEnum;
    import __AS3__.vec.*;

    public class SpellZoneCellManager extends Sprite 
    {

        public static const RANGE_COLOR:uint = 0xFF00;
        public static const CHARACTER_COLOR:uint = 0xFF0000;
        public static const SPELL_COLOR:uint = 0xFF;

        private var _centerCell:SpellZoneCell;
        public var cells:Vector.<SpellZoneCell>;
        private var _spellLevel:ICellZoneProvider;
        private var _spellCellsId:Vector.<uint>;
        private var _rollOverCell:SpellZoneCell;
        private var _width:Number;
        private var _height:Number;
        private var _paddingTop:uint;
        private var _paddingLeft:uint;
        private var _zoneDisplay:Sprite;

        public function SpellZoneCellManager()
        {
            this._zoneDisplay = new Sprite();
            addChild(this._zoneDisplay);
            this.cells = new Vector.<SpellZoneCell>();
            this._spellCellsId = new Vector.<uint>();
        }

        public function setDisplayZone(pWidth:uint, pHeight:uint):void
        {
            this._width = pWidth;
            this._height = pHeight;
        }

        public function set spellLevel(spellLevel:ICellZoneProvider):void
        {
            this._spellLevel = spellLevel;
        }

        private function addListeners():void
        {
            addEventListener(SpellZoneEvent.CELL_ROLLOVER, this.onCellRollOver);
            addEventListener(SpellZoneEvent.CELL_ROLLOUT, this.onCellRollOut);
        }

        private function removeListeners():void
        {
            removeEventListener(SpellZoneEvent.CELL_ROLLOVER, this.onCellRollOver);
            removeEventListener(SpellZoneEvent.CELL_ROLLOUT, this.onCellRollOut);
        }

        private function onCellRollOver(e:SpellZoneEvent):void
        {
            this._rollOverCell = e.cell;
            this.showSpellZone(e.cell);
        }

        private function onCellRollOut(e:SpellZoneEvent):void
        {
            this.setLastSpellCellToNormal();
        }

        public function showSpellZone(cell:SpellZoneCell):void
        {
            if (this._spellCellsId.length > 0)
            {
                this.setLastSpellCellToNormal();
            };
            this._spellCellsId = this.getSpellZone().getCells(cell.cellId);
            this.setSpellZone(this._spellCellsId);
        }

        private function setLastSpellCellToNormal():void
        {
            var cell:SpellZoneCell;
            var id:uint;
            for each (cell in this.cells)
            {
                for each (id in this._spellCellsId)
                {
                    if (id == cell.cellId)
                    {
                        cell.changeColorToDefault();
                    };
                };
            };
        }

        private function resetCells():void
        {
            var cell:SpellZoneCell;
            for each (cell in this.cells)
            {
                cell.setNormalCell();
            };
        }

        public function show():void
        {
            var zone:IZone;
            var posX:int;
            var posY:int;
            var nbHorCell:uint;
            var nbVerCell:uint;
            var changementId:uint;
            var dataMapProvider:IDataMapProvider;
            var cellWidth:uint;
            var cellHeight:uint;
            var i:int;
            var j:int;
            var graphicCell:SpellZoneCell;
            if (this._spellLevel == null)
            {
                return;
            };
            this.resetCells();
            if (this._spellLevel.castZoneInLine)
            {
                zone = new Cross(this._spellLevel.minimalRange, this._spellLevel.maximalRange, dataMapProvider);
            }
            else
            {
                zone = new Lozenge(this._spellLevel.minimalRange, this._spellLevel.maximalRange, dataMapProvider);
            };
            if (this.cells.length == 0)
            {
                posX = 0;
                posY = 0;
                nbVerCell = 40;
                nbHorCell = 14;
                changementId = 0;
                cellWidth = (this._width / (nbHorCell + 0.5));
                cellHeight = (this._height / ((nbVerCell / 2) + 0.5));
                i = 0;
                while (i < nbVerCell)
                {
                    posX = Math.ceil((i / 2));
                    posY = -(Math.floor((i / 2)));
                    j = 0;
                    while (j < nbHorCell)
                    {
                        graphicCell = new SpellZoneCell(cellWidth, cellHeight, MapPoint.fromCoords(posX, posY).cellId);
                        if (graphicCell.cellId == (SpellZoneConstant.CENTER_CELL_ID + changementId))
                        {
                            this._centerCell = graphicCell;
                        }
                        else
                        {
                            graphicCell.changeColorToDefault();
                        };
                        graphicCell.addEventListener(SpellZoneEvent.CELL_ROLLOVER, this.onCellRollOver);
                        graphicCell.addEventListener(SpellZoneEvent.CELL_ROLLOUT, this.onCellRollOut);
                        this.cells.push(graphicCell);
                        graphicCell.posX = posX;
                        graphicCell.posY = posY;
                        if ((((i == 0)) || (((i % 2) == 0))))
                        {
                            graphicCell.x = (j * cellWidth);
                        }
                        else
                        {
                            graphicCell.x = ((j * cellWidth) + (cellWidth / 2));
                        };
                        graphicCell.y = ((i * cellHeight) / 2);
                        this._zoneDisplay.addChild(graphicCell);
                        posX++;
                        posY++;
                        j++;
                    };
                    i++;
                };
            };
            this.colorCell(this._centerCell, CHARACTER_COLOR, true);
            var scale:Number = (14.5 / ((1 + Math.ceil(this._spellLevel.maximalRange)) + Math.ceil(this.getSpellZone().radius)));
            this._zoneDisplay.scaleX = (this._zoneDisplay.scaleY = scale);
            this._zoneDisplay.x = (((this._width - this._zoneDisplay.width) / 2) + (((0.5 / 14.5) * this._zoneDisplay.width) / 2));
            this._zoneDisplay.y = (((this._height - this._zoneDisplay.height) / 2) + (((0.5 / 20.5) * this._zoneDisplay.height) / 2));
            if (this._centerCell)
            {
                this.setRangedCells(zone.getCells(this._centerCell.cellId));
            };
            if (mask != null)
            {
                return;
            };
            var squareMask:Sprite = new Sprite();
            squareMask.graphics.beginFill(0xFF0000);
            squareMask.graphics.drawRoundRect(0, 0, this._width, (this._height - 3), 30, 30);
            addChild(squareMask);
            this.mask = squareMask;
        }

        private function isInSpellArea(cell:SpellZoneCell, lozenge:Lozenge):Boolean
        {
            var cellId:uint;
            if (lozenge == null)
            {
                return (false);
            };
            var cellsId:Vector.<uint> = lozenge.getCells(this._centerCell.cellId);
            for each (cellId in cellsId)
            {
                if (cellId == cell.cellId)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function remove():void
        {
            var graphicCell:SpellZoneCell;
            var vectorLength:uint = this.cells.length;
            var i:uint = vectorLength;
            while (i > 0)
            {
                graphicCell = this.cells.pop();
                this._zoneDisplay.removeChild(graphicCell);
                graphicCell = null;
                i--;
            };
        }

        public function setRangedCells(cellsId:Vector.<uint>):void
        {
            var cell:SpellZoneCell;
            var id:uint;
            for each (cell in this.cells)
            {
                for each (id in cellsId)
                {
                    if (id == cell.cellId)
                    {
                        cell.setRangeCell();
                    };
                };
            };
        }

        public function setSpellZone(cellsId:Vector.<uint>):void
        {
            var cell:SpellZoneCell;
            var id:uint;
            for each (cell in this.cells)
            {
                for each (id in cellsId)
                {
                    if (id == cell.cellId)
                    {
                        cell.setSpellCell();
                    };
                };
            };
        }

        public function colorCell(cell:SpellZoneCell, color:uint, setDefault:Boolean=false):void
        {
            cell.colorCell(color, setDefault);
        }

        public function colorCells(cellsId:Vector.<uint>, color:uint, setDefault:Boolean=false):void
        {
            var cell:SpellZoneCell;
            var id:uint;
            for each (cell in this.cells)
            {
                for each (id in cellsId)
                {
                    if (id == cell.cellId)
                    {
                        this.colorCell(cell, color, setDefault);
                    };
                };
            };
        }

        private function getSpellZone():IZone
        {
            var ray:uint;
            var dataMapProvider:IDataMapProvider;
            var i:IZoneShape;
            var shape:IZone;
            var _local_6:Line;
            var _local_7:Cross;
            var _local_8:Square;
            var _local_9:Cross;
            var diffPosX:int;
            var diffPosY:int;
            var shapeCode:uint = 88;
            ray = 0;
            for each (i in this._spellLevel.spellZoneEffects)
            {
                if (((((!((i.zoneShape == 0))) && ((i.zoneSize < 63)))) && ((((i.zoneSize > ray)) || ((((i.zoneSize == ray)) && ((shapeCode == SpellShapeEnum.P))))))))
                {
                    ray = i.zoneSize;
                    shapeCode = i.zoneShape;
                };
            };
            switch (shapeCode)
            {
                case SpellShapeEnum.X:
                    shape = new Cross(0, ray, dataMapProvider);
                    break;
                case SpellShapeEnum.L:
                    _local_6 = new Line(ray, dataMapProvider);
                    shape = _local_6;
                    break;
                case SpellShapeEnum.T:
                    _local_7 = new Cross(0, ray, dataMapProvider);
                    _local_7.onlyPerpendicular = true;
                    shape = _local_7;
                    break;
                case SpellShapeEnum.D:
                    shape = new Cross(0, ray, dataMapProvider);
                    break;
                case SpellShapeEnum.C:
                    shape = new Lozenge(0, ray, dataMapProvider);
                    break;
                case SpellShapeEnum.I:
                    shape = new Lozenge(ray, 63, dataMapProvider);
                    break;
                case SpellShapeEnum.O:
                    shape = new Lozenge(ray, ray, dataMapProvider);
                    break;
                case SpellShapeEnum.Q:
                    shape = new Cross(1, ray, dataMapProvider);
                    break;
                case SpellShapeEnum.G:
                    shape = new Square(0, ray, dataMapProvider);
                    break;
                case SpellShapeEnum.V:
                    shape = new Cone(0, ray, dataMapProvider);
                    break;
                case SpellShapeEnum.W:
                    _local_8 = new Square(0, ray, dataMapProvider);
                    _local_8.diagonalFree = true;
                    shape = _local_8;
                    break;
                case SpellShapeEnum.plus:
                    _local_9 = new Cross(0, ray, dataMapProvider);
                    _local_9.diagonal = true;
                    shape = _local_9;
                    break;
                case SpellShapeEnum.sharp:
                    _local_9 = new Cross(1, ray, dataMapProvider);
                    _local_9.diagonal = true;
                    shape = _local_9;
                    break;
                case SpellShapeEnum.star:
                    _local_9 = new Cross(0, ray, dataMapProvider);
                    _local_9.allDirections = true;
                    shape = _local_9;
                    break;
                case SpellShapeEnum.slash:
                    shape = new Line(ray, dataMapProvider);
                    break;
                case SpellShapeEnum.minus:
                    _local_9 = new Cross(0, ray, dataMapProvider);
                    _local_9.onlyPerpendicular = true;
                    _local_9.diagonal = true;
                    shape = _local_9;
                    break;
                case SpellShapeEnum.U:
                    shape = new HalfLozenge(0, ray, dataMapProvider);
                    break;
                case SpellShapeEnum.A:
                case SpellShapeEnum.a:
                    shape = new Lozenge(0, 63, dataMapProvider);
                    break;
                case SpellShapeEnum.P:
                default:
                    shape = new Cross(0, 0, dataMapProvider);
            };
            if (this._rollOverCell)
            {
                diffPosX = (this._centerCell.posX - this._rollOverCell.posX);
                diffPosY = (this._centerCell.posY - this._rollOverCell.posY);
                shape.direction = DirectionsEnum.DOWN_RIGHT;
                if ((((diffPosX == 0)) && ((diffPosY > 0))))
                {
                    shape.direction = DirectionsEnum.DOWN_LEFT;
                };
                if ((((diffPosX == 0)) && ((diffPosY < 0))))
                {
                    shape.direction = DirectionsEnum.UP_RIGHT;
                };
                if ((((diffPosX > 0)) && ((diffPosY == 0))))
                {
                    shape.direction = DirectionsEnum.UP_LEFT;
                };
            };
            return (shape);
        }


    }
}//package com.ankamagames.jerakine.utils.display.spellZone

