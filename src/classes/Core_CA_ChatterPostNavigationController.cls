public with sharing class Core_CA_ChatterPostNavigationController{
    
    public String requestId {get;set;}
    public String approverId {get;set;}
    public String sourceSystem {get;set;}
   
    public Core_CA_ChatterPostNavigationController(ApexPages.StandardController controller) {
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();   
        string urlId = ApexPages.currentPage().getParameters().get('id'); 
        List<Core_Approver_Details__c> lstApprover = [SELECT Id,Source_System__c FROM Core_Approver_Details__c WHERE Approval_Header__c =: urlId];           
        sourceSystem = lstApprover[0].Source_System__c;
        if(!lstApprover.isEmpty()){
            requestId=urlId;
            approverId=lstApprover[0].Id;
        }           
        else{
            requestId=urlId;
            approverId=urlId;
        }          
    }
}