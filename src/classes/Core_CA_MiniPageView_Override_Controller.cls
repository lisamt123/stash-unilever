public with sharing class Core_CA_MiniPageView_Override_Controller{
    
    public String customPageURL {get;set;}
    public Core_CA_MiniPageView_Override_Controller(ApexPages.StandardController controller) {
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();   
        string urlId = ApexPages.currentPage().getParameters().get('id'); 
        List<Core_Approver_Details__c> lstApprover = [SELECT Id FROM Core_Approver_Details__c WHERE Approval_Header__c =: urlId];           
        if(!lstApprover.isEmpty())
            customPageURL = baseUrl+'/apex/Core_CA_ApprovalHomePage#/MyApprovalsHome?headerId='+urlId+'&ipId='+lstApprover[0].Id;
        else
           customPageURL = baseUrl+'/apex/Core_CA_ApprovalHomePage#/MyApprovalsHome?headerId='+urlId+'&ipId='+urlId; 
    }
}