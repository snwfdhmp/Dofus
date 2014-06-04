package com.ankamagames.dofus.network.messages.game.context.mount
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class MountInformationRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public function MountInformationRequestMessage() {
         super();
      }
      
      public static const protocolId:uint = 5972;
      
      private var _isInitialized:Boolean = false;
      
      override public function get isInitialized() : Boolean {
         return this._isInitialized;
      }
      
      public var id:Number = 0;
      
      public var time:Number = 0;
      
      override public function getMessageId() : uint {
         return 5972;
      }
      
      public function initMountInformationRequestMessage(id:Number = 0, time:Number = 0) : MountInformationRequestMessage {
         this.id = id;
         this.time = time;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void {
         this.id = 0;
         this.time = 0;
         this._isInitialized = false;
      }
      
      override public function pack(output:IDataOutput) : void {
         var data:ByteArray = new ByteArray();
         this.serialize(data);
         writePacket(output,this.getMessageId(),data);
      }
      
      override public function unpack(input:IDataInput, length:uint) : void {
         this.deserialize(input);
      }
      
      public function serialize(output:IDataOutput) : void {
         this.serializeAs_MountInformationRequestMessage(output);
      }
      
      public function serializeAs_MountInformationRequestMessage(output:IDataOutput) : void {
         if((this.id < -9.007199254740992E15) || (this.id > 9.007199254740992E15))
         {
            throw new Error("Forbidden value (" + this.id + ") on element id.");
         }
         else
         {
            output.writeDouble(this.id);
            if((this.time < -9.007199254740992E15) || (this.time > 9.007199254740992E15))
            {
               throw new Error("Forbidden value (" + this.time + ") on element time.");
            }
            else
            {
               output.writeDouble(this.time);
               return;
            }
         }
      }
      
      public function deserialize(input:IDataInput) : void {
         this.deserializeAs_MountInformationRequestMessage(input);
      }
      
      public function deserializeAs_MountInformationRequestMessage(input:IDataInput) : void {
         this.id = input.readDouble();
         if((this.id < -9.007199254740992E15) || (this.id > 9.007199254740992E15))
         {
            throw new Error("Forbidden value (" + this.id + ") on element of MountInformationRequestMessage.id.");
         }
         else
         {
            this.time = input.readDouble();
            if((this.time < -9.007199254740992E15) || (this.time > 9.007199254740992E15))
            {
               throw new Error("Forbidden value (" + this.time + ") on element of MountInformationRequestMessage.time.");
            }
            else
            {
               return;
            }
         }
      }
   }
}
