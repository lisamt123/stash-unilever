trigger OpportunityTrigger on Opportunity (after insert, after update, before insert, before update) {

    //Check 'NAFS Opportunity Trigger Settings' in custom settings. If enabled then call the method 
    NAFSOpportunityTriggerSettings__c Settings=NAFSOpportunityTriggerSettings__c.getinstance('isEnabled');
    boolean Enabled=Settings.Enabled__c;
    
    if(trigger.isAfter && trigger.isUpdate && Enabled){
        NAFS_OpportunityHelper.rollUpOpportunityLineItem(trigger.new);
    }
    
}