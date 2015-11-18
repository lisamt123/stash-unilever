/*
@Description: Generic Extension standard controller class to overide the functionalities for the Project, PDocument, PD Section, Task & Milestone objects
@Author: Cognizant Technology
@Date: Dec 2014
*/
public with sharing class IPM_GenericExtCtrl {
    
    public String urlId; //url id of any object specified
    
    //constructor
    public IPM_GenericExtCtrl(ApexPages.StandardController stdController) {
        urlId = ApexPages.currentPage().getParameters().get('id');
    }
    
    /*********************************************************************
    * @description: actual redirection method which finds out which record and which object it belongs to and redirects accordingly
    * @return: redirected page.
    */
    public PageReference red() {
        
        PageReference pageRef = null;
        if(urlId != Null && urlId.startsWith(IPM_Utils.getsObjPrefix('IPM_Project_Document__c'))) {
            IPM_Project_Document__c sObj = [SELECT IPM_Project__c FROM IPM_Project_Document__c WHERE Id = :urlId];
            urlId = sObj.IPM_Project__c;
            pageRef = Page.IPM_ProjectOverview;
            pageRef.getParameters().put('Id',urlId);
        } else if(urlId != Null && urlId.startsWith(IPM_Utils.getsObjPrefix('IPM_Project_Document_Section__c'))) {
            IPM_Project_Document_Section__c sObj = [SELECT IPM_Project_ID__c FROM IPM_Project_Document_Section__c WHERE Id = :urlId];
            urlId = sObj.IPM_Project_ID__c;
            pageRef = Page.IPM_ProjectDocumentSectionEditor;
            pageRef.getParameters().put('Id',urlId);
            pageRef.getParameters().put('projDocSecId',sObj.Id);
        } else if(urlId != Null && urlId.startsWith(IPM_Utils.getsObjPrefix('IPM_Task__c'))) {
            IPM_Task__c sObj = [SELECT IPM_Project__c FROM IPM_Task__c WHERE Id = :urlId];
            urlId = sObj.IPM_Project__c;
            pageRef = Page.IPM_Tasklist;
            pageRef.getParameters().put('Id',urlId);
        } else if(urlId != Null && urlId.startsWith(IPM_Utils.getsObjPrefix('IPM_Milestone__c'))) {
            IPM_Milestone__c sObj = [SELECT IPM_Project__c FROM IPM_Milestone__c WHERE Id = :urlId];
            urlId = sObj.IPM_Project__c;
            pageRef = Page.IPM_Tasklist;
            pageRef.getParameters().put('Id',urlId);
        } else if(urlId != Null && urlId.startsWith(IPM_Utils.getsObjPrefix('IPM_Project__c'))) {
            IPM_Project__c sObj = [SELECT id,IPM_IsSaved__c FROM IPM_Project__c WHERE Id = :urlId];
            if(sObj.IPM_IsSaved__c){
                pageRef = Page.IPM_ProjectOverview;
                pageRef.getParameters().put('Id',urlId);
            }
            else{
                pageRef = Page.IPM_ProjectSetupView;
                pageRef.getParameters().put('Pid',urlId);
            }
        }
        pageRef.setRedirect(true);
        return pageRef;
    }
}