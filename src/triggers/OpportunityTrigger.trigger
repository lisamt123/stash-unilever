trigger OpportunityTrigger on Opportunity (after insert, after update, before insert, before update) {

    //Check 'NAFS Opportunity Trigger Settings'in custom settings. If enabled then call the method
    FSOpportunityTriggerSettings__c Settings=FSOpportunityTriggerSettings__c.getinstance('isEnabled');
    boolean Enabled=Settings.Enabled__c;
    FS_OpportunityHandler handler = new FS_OpportunityHandler();
    //if(trigger.isAfter && trigger.isUpdate){
    //FS_OpportunityHelper.copyLineItemToExistingOpp(trigger.new,Trigger.OldMap);       
    //}    
    if(Enabled){
        if(trigger.isBefore && trigger.isUpdate){      
        }
        if(trigger.isAfter){
            if(trigger.isInsert){
                system.debug('ISINSERT Call------------');
                FS_OpportunityHelper.rollUptoAccountPlan(trigger.new); 
                FS_OpportunityHelper.rollUptoDefinedObjective(trigger.new);
                system.debug('Before onafterinsert Call');
                handler.onAfterInsert(trigger.newMap);
              
            }
            else if(trigger.isUpdate){
                FS_OpportunityHelper.rollUpOpportunityLineItem(trigger.new);
                FS_OpportunityHelper.copyLineItemToExistingOpp(trigger.new,Trigger.OldMap);
                FS_OpportunityHelper.rollUptoAccountPlan(trigger.new); 
                FS_OpportunityHelper.rollUptoDefinedObjective(trigger.new);             
                handler.onAfterUpdate(trigger.newMap,Trigger.OldMap);
            }
        }
        
    }
}