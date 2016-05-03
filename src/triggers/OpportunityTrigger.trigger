trigger OpportunityTrigger on Opportunity (after insert, after update, before insert, before update) {
	
	//Delete existing and Create new Opp line item if any product available with same package as it is in Opportunity package
	if(trigger.isInsert && trigger.isAfter){
        OpportunityHelper.OppInsert(trigger.new);
    }
    
    //Create new Opp line item with standard PriceBook, if any product available with same package as it is in Opportunity package
    else if(trigger.isUpdate && trigger.isAfter){
        OpportunityHelper.OppUpdate(trigger.new, trigger.oldMap);
        OpportunityHelper.UpdateOppField(trigger.new);
    }
    else if(trigger.isUpdate && trigger.isBefore){
        //OpportunityHelper.UpdateWithOppProdValue(trigger.new);
    }
    
}