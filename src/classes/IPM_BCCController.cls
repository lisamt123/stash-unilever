public class IPM_BCCController 
{
    public IPM_Project__c project{get; set;}
    public IPM_Financial__c finance{get; set;}
    public string projectId{get; set;}
    public Boolean saveMsg{get; set;}
    public List<IPM_Project__c> projList{get; set;}
    private String PROJECT_SPAN_GLOBAL='Global';
    private String PROJECT_SPAN_REGIONAL='Regional';
    private String PROJECT_SPAN_LOCAL='Local';
    public Boolean tldAlignment{get; set;}
    public IPM_BCCController()
    {
        projectId= ApexPages.currentPage().getParameters().get('Id');
        if (projectId != NULL)
        {
            project = [SELECT Id,IPM_Project_Name__c,IPMProject_Span__c,IPM_Phase__c,IPM_Target_Launch_Dates__c,IPM_Parent_Project__c,IPM_Parent_Project__r.IPM_Target_Launch_Dates__c FROM IPM_Project__c WHERE Id=:projectId];
            if(project.IPM_Target_Launch_Dates__c==project.IPM_Parent_Project__r.IPM_Target_Launch_Dates__c)
            {
                tldAlignment=true;
            }
            finance = [Select Id,Local_Project__c,Misaligned__c,IPM_Business_Case_Confirmed__c,IPM_Country_Feedback__c FROM IPM_Financial__c WHERE Local_Project__c=:projectId];    
        }
    }
    public void save()
    {
        update finance;
        saveMsg=true;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Business Case Confirmation Saved Successfully'));
    }
    public void changeStatus()
    {
        finance.IPM_Business_Case_Confirmed__c=true;
        update finance;
    }
    public void hideSaveMsg()
    {
        saveMsg=false;
    }
}