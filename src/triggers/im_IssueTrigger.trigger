trigger im_IssueTrigger on im_Issue__c (before update) {
    
    // Custom validation to validate changes to fields based on permission sets. Could not use validation rules
    // or page layout assignments because permission sets are used, not profiles
    im_IssueTriggerHandler.validateIssueChanges(trigger.oldMap, trigger.newMap);
    
}