trigger IPM_FinancialYearTrigger on IPM_Financial_Year__c (before insert,after insert,before update,after update,before delete,after delete) 
{
    if(!IPM_FinancialYearHelper.SKIP_TRIGGER_EXECUTION)
    {    
        TriggerFactory.createHandler(IPM_Financial_Year__c.sObjectType);
    }   
}