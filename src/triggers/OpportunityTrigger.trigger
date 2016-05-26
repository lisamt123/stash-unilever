trigger OpportunityTrigger on Opportunity (after insert, after update, before insert, before update) {
    
    if(trigger.isAfter && trigger.isUpdate){
        NAFS_OpportunityHelper.rollUpOpportunityLineItem(trigger.new);
    }
    
}