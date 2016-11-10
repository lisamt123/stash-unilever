trigger ContractProductTrigger on Contract_Product__c (after insert, after update) {
    FS_ContractProductHandler handler = new FS_ContractProductHandler();
    if(trigger.isAfter && trigger.isInsert){
       handler.createPlan(Trigger.new); 
    }
    if(trigger.isAfter && trigger.isUpdate){
       handler.updatePlan(Trigger.new); 
    }
}