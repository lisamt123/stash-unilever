trigger UID_StockedProductSummaryTrigger on UID_Stocked_Product_Summary__c (before insert, before update) {
    
    UID_StockedProductSummaryHandler handler = new UID_StockedProductSummaryHandler();
    
    if(Trigger.isUpdate && Trigger.isBefore)
    {
        handler.onBeforeUpdate(Trigger.newMap , trigger.oldMap);
    }
}