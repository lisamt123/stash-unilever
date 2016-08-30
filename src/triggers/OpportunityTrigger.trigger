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
                system.debug('Before onafterinsert Call');
                handler.onAfterInsert(trigger.newMap,trigger.new);
              
            }
            else if(trigger.isUpdate){
                handler.onAfterUpdate(trigger.newMap,Trigger.OldMap,trigger.new);
            }
        }
        if(trigger.isBefore){
            if(trigger.isInsert){
                handler.onBeforeInsert(trigger.new);              
            }
        }
        
    }
}