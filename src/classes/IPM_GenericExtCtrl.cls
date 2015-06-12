public with sharing class IPM_GenericExtCtrl {
    
    public String urlId;
    
    public IPM_GenericExtCtrl(ApexPages.StandardController stdController) {
        urlId = ApexPages.currentPage().getParameters().get('id');
    }
    
    public PageReference red() {
        
        PageReference pageRef;
        if(urlId.startsWith(Label.PD_OBJ_NAME)) {
            IPM_Project_Document__c sObj = [SELECT IPM_Project__c FROM IPM_Project_Document__c WHERE Id = :urlId];
            urlId = sObj.IPM_Project__c;
            pageRef = new PageReference('/apex/ipmProjectOverview?id='+urlId);
        } else if(urlId.startsWith(Label.PS_OBJ_NAME)) {
            IPM_Project_Document_Section__c sObj = [SELECT IPM_Project_ID__c FROM IPM_Project_Document_Section__c WHERE Id = :urlId];
            urlId = sObj.IPM_Project_ID__c;
            pageRef = new PageReference('/apex/ipmProjectDocumentSectionEditorV1?Id='+urlId+'&projDocSecId='+sObj.Id);
        } else if(urlId.startsWith(Label.TASK_OBJ_NAME)) {
            IPM_Task__c sObj = [SELECT IPM_Project__c FROM IPM_Task__c WHERE Id = :urlId];
            urlId = sObj.IPM_Project__c;
            pageRef = new PageReference('/apex/IPM_Tasklist?id='+urlId);
        } else if(urlId.startsWith(Label.MLST_OBJ_NAME)) {
            IPM_Milestone__c sObj = [SELECT IPM_Project__c FROM IPM_Milestone__c WHERE Id = :urlId];
            urlId = sObj.IPM_Project__c;
            pageRef = new PageReference('/apex/IPM_Tasklist?id='+urlId);
        } else {
            pageRef = new PageReference('/apex/ipmProjectOverview?id='+urlId);
        }
        
        pageRef.setRedirect(true);
        return pageRef;
    }
}