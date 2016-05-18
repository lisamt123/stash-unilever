trigger OpportunityTrigger on Opportunity (after insert, after update, before insert, before update) {
    
    //Delete existing and Create new Opp line item if any product available with same package as it is in Opportunity package
    if(trigger.isInsert && trigger.isAfter){
        NAFS_OpportunityHelper.OppInsert(trigger.new);
    }
    
    
    else if(trigger.isUpdate && trigger.isAfter){
        //Create new Opp line item with standard PriceBook, if any product available with same package as it is in Opportunity package
        NAFS_OpportunityHelper.OppUpdate(trigger.new, trigger.oldMap);
        //to update Opp with Opp Line Item Value (MABE process)
        NAFS_OpportunityHelper.UpdateOppField(trigger.new);
        //Update parent opportunity (LEAF process)
        NAFS_OpportunityHelper.UpdateParentField(trigger.new, trigger.oldMap);
    }
    
    
}