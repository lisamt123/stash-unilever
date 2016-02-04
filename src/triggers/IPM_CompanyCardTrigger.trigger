/**
@Author Cognizant
@Name IPM_CompanyCardTrigger
@CreateDate 27/08/2015
@Description This Trigger is used for the IPM_Company_Card__c SObject.
@Version 1.0
@reference 
*/ 
trigger IPM_CompanyCardTrigger on IPM_Company_Card__c (before insert,after insert,before update,after update,before delete,after delete) 
{
    /** Checking for the trigger router flag from custom setting   */
    if(!IPM_Utils.validateTriggerSkip())
    {
        TriggerFactory.createHandler(IPM_Company_Card__c.sObjectType);
    }        
}