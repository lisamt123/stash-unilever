/**
@Author Cognizant
@Name IPM_Milestone_Trigger
@Description This Trigger is used for the IPM_Project__c SObject.
@Version 1.0
@reference 
*/
trigger IPM_Milestone_Trigger on IPM_Milestone__c (before insert,after insert,before update,after update,before delete,after delete, after undelete) {
    TriggerFactory.createHandler(IPM_Milestone__c.sObjectType);    
}