/**
@Author Cognizant
@Name IPM_CountryTrigger
@CreateDate 27/08/2015
@Description This Trigger is used for the IPM_Country__c SObject.
@Version 1.0
@reference 
*/
trigger IPM_CountryTrigger on IPM_Country__c (before insert,after insert,before update,after update,before delete,after delete) 
{
    /** Checking for the trigger router flag from custom setting   */
    if(!IPM_Utils.validateTriggerSkip() && !IPM_ProjectCountryDetails.SKIP_TRIGGER_EXECUTION)
    {
        TriggerFactory.createHandler(IPM_Country__c.sObjectType);
    }    
}