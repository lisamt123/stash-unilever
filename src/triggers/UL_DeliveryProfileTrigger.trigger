trigger UL_DeliveryProfileTrigger on UL_Delivery_Profile__c (before insert,before update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            UL_DeliveryProfileTriggerHandler.checkDuplicateRecords(trigger.new);
        }
    }
}