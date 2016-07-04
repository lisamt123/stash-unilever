trigger OpportunityTrigger on Opportunity (after insert, after update, before insert, before update) {

    //Check 'NAFS Opportunity Trigger Settings'in custom settings. If enabled then call the method
    FSOpportunityTriggerSettings__c Settings=FSOpportunityTriggerSettings__c.getinstance('isEnabled');
    boolean Enabled=Settings.Enabled__c;    
    if(trigger.isAfter && trigger.isUpdate && Enabled){
        FS_OpportunityHelper.rollUpOpportunityLineItem(trigger.new);
      }   
    //Roll up opportunity upto account plan and defined objective
    if(trigger.isAfter && trigger.isUpdate){
        FS_OpportunityHelper.rollUptoAccountPlan(trigger.new); 
    }
       if(trigger.isAfter && trigger.isInsert){
        FS_OpportunityHelper.rollUptoDefinedObjective(trigger.new);
       
    }
}