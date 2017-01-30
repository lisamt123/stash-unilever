trigger  BEN_CategoryDetailsTrigger on BEN_Category_Details__c (before update,after insert){
    
    if(trigger.isUpdate && trigger.isBefore){  
        BEN_CategoryDetailsTriggerHandler.SendRecordForApproval(trigger.new,trigger.oldMap,trigger.newMap);
    }
    
   /* if(trigger.isInsert && trigger.isAfter){  
        BEN_CategoryDetailsTriggerHandler.SendEmailToRetest(trigger.new);
    }*/
    
}