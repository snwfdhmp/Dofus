﻿package blocks
{
    import d2hooks.*;

    public class SeparatorTooltipBlock 
    {

        private var _content:String;
        private var _block:Object;

        public function SeparatorTooltipBlock()
        {
            this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded, this.getContent);
            this._block.initChunk([Api.tooltip.createChunkData("separator", "chunks/base/separator.txt")]);
        }

        public function onAllChunkLoaded():void
        {
            this._content = this._block.getChunk("separator").processContent(new Object());
        }

        public function getContent():String
        {
            return (this._content);
        }

        public function get block():Object
        {
            return (this._block);
        }


    }
}//package blocks

