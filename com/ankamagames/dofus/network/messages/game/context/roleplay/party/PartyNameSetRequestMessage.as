package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PartyNameSetRequestMessage extends AbstractPartyMessage implements INetworkMessage
   {
      
      public function PartyNameSetRequestMessage() {
         super();
      }
      
      public static const protocolId:uint = 6503;
      
      private var _isInitialized:Boolean = false;
      
      override public function get isInitialized() : Boolean {
         return (super.isInitialized) && (this._isInitialized);
      }
      
      public var partyName:String = "";
      
      override public function getMessageId() : uint {
         return 6503;
      }
      
      public function initPartyNameSetRequestMessage(partyId:uint = 0, partyName:String = "") : PartyNameSetRequestMessage {
         super.initAbstractPartyMessage(partyId);
         this.partyName = partyName;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void {
         super.reset();
         this.partyName = "";
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
      
      override public function serialize(output:IDataOutput) : void {
         this.serializeAs_PartyNameSetRequestMessage(output);
      }
      
      public function serializeAs_PartyNameSetRequestMessage(output:IDataOutput) : void {
         super.serializeAs_AbstractPartyMessage(output);
         output.writeUTF(this.partyName);
      }
      
      override public function deserialize(input:IDataInput) : void {
         this.deserializeAs_PartyNameSetRequestMessage(input);
      }
      
      public function deserializeAs_PartyNameSetRequestMessage(input:IDataInput) : void {
         super.deserialize(input);
         this.partyName = input.readUTF();
      }
   }
}