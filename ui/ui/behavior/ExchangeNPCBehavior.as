package ui.behavior
{
   import ui.StorageUi;
   import d2data.ItemWrapper;
   import ui.AbstractStorageUi;
   import d2actions.*;
   import d2hooks.*;
   import d2enums.SelectMethodEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import ui.enum.StorageState;
   
   public class ExchangeNPCBehavior extends Object implements IStorageBehavior
   {
      
      public function ExchangeNPCBehavior() {
         super();
      }
      
      private var _storage:StorageUi;
      
      private var _objectToExchange:Object;
      
      public function filterStatus(enabled:Boolean) : void {
      }
      
      public function dropValidator(target:Object, data:Object, source:Object) : Boolean {
         if((data is ItemWrapper) && (!(this._storage.categoryFilter == AbstractStorageUi.QUEST_CATEGORY)))
         {
            return true;
         }
         return false;
      }
      
      public function processDrop(target:Object, data:Object, source:Object) : void {
         if(data.quantity > 1)
         {
            this._objectToExchange = data;
            Api.common.openQuantityPopup(1,data.quantity,data.quantity,this.onValidQty);
         }
         else
         {
            Api.system.sendAction(new ExchangeObjectMove(data.objectUID,-1));
         }
      }
      
      public function onValidQtyDrop(qty:Number) : void {
      }
      
      private function onValidQty(qty:Number) : void {
         Api.system.sendAction(new ExchangeObjectMove(this._objectToExchange.objectUID,-qty));
      }
      
      public function onRelease(target:Object) : void {
      }
      
      public function onSelectItem(target:Object, selectMethod:uint, isNewSelection:Boolean) : void {
         var item:Object = null;
         switch(target)
         {
            case this._storage.grid:
               item = this._storage.grid.selectedItem;
               switch(selectMethod)
               {
                  case SelectMethodEnum.CLICK:
                     Api.system.dispatchHook(ObjectSelected,item);
                     Api.system.dispatchHook(ClickItemInventory,item);
                     break;
                  case SelectMethodEnum.DOUBLE_CLICK:
                     Api.ui.hideTooltip();
                     Api.system.dispatchHook(DoubleClickItemInventory,item,1);
                     break;
                  case SelectMethodEnum.CTRL_DOUBLE_CLICK:
                     Api.system.dispatchHook(DoubleClickItemInventory,item,item.quantity);
                     break;
                  case SelectMethodEnum.ALT_DOUBLE_CLICK:
                     this._objectToExchange = target.selectedItem;
                     Api.common.openQuantityPopup(1,target.selectedItem.quantity,target.selectedItem.quantity,this.onValidQty);
                     break;
               }
               break;
         }
      }
      
      public function attach(storageUi:AbstractStorageUi) : void {
         if(!(storageUi is StorageUi))
         {
            throw new Error("Can\'t attach a ExchangeNPCBehavior to a non StorageUi storage");
         }
         else
         {
            this._storage = storageUi as StorageUi;
            if(this._storage.playerLook)
            {
               this._storage.playerLook.look = null;
            }
            this._storage.questVisible = false;
            this._storage.btnMoveAll.visible = false;
            return;
         }
      }
      
      public function detach() : void {
         this._storage.questVisible = true;
         this._storage.btnMoveAll.visible = true;
      }
      
      public function onUnload() : void {
         Api.ui.unloadUi(UIEnum.EXCHANGE_NPC_UI);
      }
      
      public function isDefaultBehavior() : Boolean {
         return false;
      }
      
      public function getStorageUiName() : String {
         return UIEnum.STORAGE_UI;
      }
      
      public function getName() : String {
         return StorageState.EXCHANGE_NPC_MOD;
      }
      
      public function get replacable() : Boolean {
         return false;
      }
   }
}