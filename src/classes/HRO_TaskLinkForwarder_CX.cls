/**********************************************************************
 Name:  HRO_TaskLinkForwarder_CX()
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
Class used to update task completed when Take Action 
made uder email
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0    Karol Szepietowski        08/10/2015      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/

public with sharing class HRO_TaskLinkForwarder_CX {

	private final sObject mysObject;
    public String redirectToPage{get;set;}
    private static final String INSTANCEURL = System.URL.getSalesforceBaseUrl().toExternalForm();
    private static final String UTF8 = 'UTF-8';
    /*******************************************************************
   Purpose:  Class constructor getting record                                                    
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public HRO_TaskLinkForwarder_CX(ApexPages.StandardController stdController) {
        system.debug('****HRO Entring HRO_TaskLinkForwarder_CX constructor');
        this.mysObject = (sObject)stdController.getRecord();
        system.debug('****HRO Exiting HRO_TaskLinkForwarder_CX constructor');
    }

    /*******************************************************************
   Purpose:  Method responsible for updating task as completed and redirecting 
   proper page
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/	
    public PageReference updateActionTaken(){
        system.debug('****HRO Entring updateActionTaken');
        
        try{
            Id recordId = (Id)mysObject.get('Id');
            HRO_Onboarding_Task__c hroTask = new HRO_Onboarding_Task__c(id = recordId);
            hroTask.Completed__c = true;
            List<Database.SaveResult> sr = Database.update(new List<HRO_Onboarding_Task__c>{hroTask});
        }catch(Exception ex){
            system.debug('***HRO updateActionTaken method could not be able to update record: '+ex.getMessage());
        }
        
        String pageUrl  = null;
        if(ApexPages.currentPage().getParameters().containsKey('pageUrl')){
            system.debug('before creating page reference');
        	pageUrl  = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('pageUrl'),UTF8);
        }else if(ApexPages.currentPage().getParameters().containsKey('selectedLeader')){
            pageUrl = INSTANCEURL+'/_ui/core/userprofile/UserProfilePage?tab=HRO_HeadStart&sfdc.userId='+UserInfo.getUserId()+'&tab.HRO_HeadStart.leaderToSelect='+EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('selectedLeader'),UTF8);        
        }

        system.debug('****HRO Exiting updateActionTaken:'+pageUrl);
        return new PageReference(pageUrl);
        
    }
}