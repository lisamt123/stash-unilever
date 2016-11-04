/**
   @Author: Chandra Reddy
   @Name: UL_Product_Part_Trigger
   @CreateDate: 19-10-2016
   @Description: User trigger to handle ProductPart insert, update events.
   @Version: 1.0
  */
trigger UL_Product_Part_Trigger on ACSFUL001__Product_Part__c (before insert, before update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            UL_ProductPartTriggerUtil.UpdateCUQuantity(trigger.new);
        }
        if(trigger.isUpdate){
            UL_ProductPartTriggerUtil.UpdateCUQuantity(trigger.new);        
        }
    }
}