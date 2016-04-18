trigger OpportunityTrigger on Opportunity (after insert, after update, before insert, before update) {
	
	if(trigger.isInsert && trigger.isAfter){
        OpportunityHelper.OppInsert(trigger.new);
    }
    else if(trigger.isUpdate && trigger.isAfter){
        OpportunityHelper.OppUpdate(trigger.new, trigger.oldMap);
    }
    
}