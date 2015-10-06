public with sharing class HRO_TaksLinkForwarder {

	private final sObject mysObject;
    public String redirectToPage{get;set;}
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public HRO_TaksLinkForwarder(ApexPages.StandardController stdController) {
        this.mysObject = (sObject)stdController.getRecord();
    }

    public PageReference updateActionTaken(){
        system.debug(ApexPages.currentPage().getParameters());
        
        Id recordId = (Id)mysObject.get('Id');
        HRO_Onboarding_Task__c hroTask = new HRO_Onboarding_Task__c(id = recordId);
        hroTask.Action_Taken__c = true;
        update hroTask;
       
        
        system.debug('before creating page reference');
        String pageUrl  = ApexPages.currentPage().getParameters().get('pageUrl');
        redirectToPage = EncodingUtil.urlDecode(pageUrl, 'UTF-8');
        
        system.debug('afrer creating page reference'+redirectToPage);
        
        try{
            return new PageReference(EncodingUtil.urlDecode(pageUrl, 'UTF-8'));
            //return new PageReference('/'+recordId);
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Link to this task is invalid please contact with your manager'));
            return null;
        }
        return null;
        
        
    }

    public String getRecordName() {
        return 'Hello ' + (String)mysObject.get('name') + ' (' + (Id)mysObject.get('Id') + ')';
    }
}