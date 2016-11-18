trigger IPM_SourcingUnitTrigger on IPM_SourcingUnit__c (after update) {
    if(!IPM_SourcePlanController_Helper.SKIP_TRIGGER_EXECUTION){ 
    	TriggerFactory.createHandler(IPM_SourcingUnit__c.sObjectType);
  	}    
}