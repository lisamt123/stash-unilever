/**
@Author Cognizant
@Name IPM_FinancialTrigger
@CreateDate 27/08/2015
@Description Trigger for object:IPM_Project_Rollout__c
@Version 1.0
@reference 
*/
trigger IPM_RolloutTrigger on IPM_Project_Rollout__c (before insert,after insert,before update,after update,before delete,after delete) 
{
    /** Checking for the trigger router flag from custom setting   */
    if( !IPM_Utils.validateTriggerSkip() && !IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION )
    {
        TriggerFactory.createHandler(IPM_Project_Rollout__c.sObjectType);    
    }
}