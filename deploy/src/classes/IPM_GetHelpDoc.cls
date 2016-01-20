public with sharing class IPM_GetHelpDoc {

    public string helpDocName{get;set;}
    public string strDocUrl{get;set;}
    public IPM_Milestone__c milestoneObj{get;set;}
    
    public IPM_GetHelpDoc()
    {
        String strurl = ApexPages.currentPage().getUrl();
        strurl = strurl.split('apex/')[1];
        strurl = strurl.split('\\?')[0];

        helpDocName = strurl;
    }
    
    public IPM_GetHelpDoc(ApexPages.StandardController stdController){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_Team_Assignment_Controller teamAssignCtrl) {
        this();
    }
    
    public IPM_GetHelpDoc(IPM_HomePageController homePageCtrl){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_ProjectSearchCtrl projSearchCtrl){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_BosscardStatusController bosscardStatusCtrl){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_CreateProject createProject){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_ImageUploadController imageUploadCtrl){
        this();
    }   
    
    public IPM_GetHelpDoc(IPM_Coreparameters coreParam){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_GateDocumentController gateDocCtrl){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_AddManageSection addSection){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_GateDocumentRiskManagement gateDocRiskMgmt){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_Resource_Allocation resourceAllocation){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_ProjDocumentSectionHstryController docSectionCtrl){
        this();
    } 
    
    public IPM_GetHelpDoc(IPM_ProjectDocumentSectionController projDocSectionCtrl){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_ChangProjectDocumentStatusController projDocStatusChange){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_RolloutPlansAddController addRolloutCtrl){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_RolloutPlansTableController rolloutTableCtrl){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_FinancialController financeCtrl){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_FinancialCopyPasteGrid financeGridCtrl){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_CommentsListController commentsCtrl){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_ChannelImageController channelImageCtrl){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_UploadBusinessCase businessCase){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_FileUploadController fileUploadCtrl){
        this();
    }
    
    public IPM_GetHelpDoc(IPM_BCCController bccCtrl){
        this();
    }
    
    public String getURL()
    {
        try{
            List<Document> lstDocument = [Select Id from Document where Name =: helpDocName  limit 1];
                strDocUrl = '/servlet/servlet.FileDownload?file='+lstDocument[0].Id;
            return strDocUrl;
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.IPM_Get_Help_Document);
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
  
}