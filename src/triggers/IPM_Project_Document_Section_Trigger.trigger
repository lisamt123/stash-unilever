trigger IPM_Project_Document_Section_Trigger on IPM_Project_Document_Section__c (before insert,after insert,before update,after update,before delete,after delete) 
{
    if(!IPM_ProjectSectionContentHelper.SKIP_TRIGGER_EXECUTION)
    {
        TriggerFactory.createHandler(IPM_Project_Document_Section__c.sObjectType);
    }
}